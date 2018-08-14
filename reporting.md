Feature Policy Reporting
========================

In a nutshell
-------------

A document's feature policy sets limits on what kinds of actions it can
perform; what APIs are available. When a page tries to do something that is
blocked by policy, the browser currently sends a message to the JavaScript
console -- this can be great when developing a site, but is often not enough
when dealing with a site in production. It would be very useful to be able to
collect reports about real problems that users are seeing.

We're addressing this by integrating feature policy with the
[Reporting API](https://wicg.github.io/reporting/). In the same way that sites
can opt in to receiving reports about CSP violations or deprecations, they will
now be able to receive reports about feature policy violations in the wild.

Sounds great! How do I do it?
-------------

Turning on the Reporting API is simple; all you need to do is configure your
web server to send an HTTP header that declares where the reports should be
sent. Something like:

```http
Report-To: {
            "max_age": 86400,
            "endpoints": [{
              "url": "https://reportingapi.tools/public/submit"
            }]
           }
```

Once we add feature policy reporting to the Reporting API, per this proposal,
this header will make the browser send details about any feature policy
violations, via an HTTP POST, to a web server running at that URL. The messages
that the browser sends will look something like this:

```json
{
 "type": "feature-policy-violation",
 "url": "https://a.featurepolicy.rocks/geolocation.html",
 "age": 60000,
 "user_agent": "Mozilla/1.22 (compatible; MSIE 2.0; Windows 95)",
 "body": {
    "featureId": "geolocation",
    "message": "Geolocation access has been blocked because of a Feature Policy applied to the current document. See https://goo.gl/EuHzyv for more details.",
    "source_file": "https://a.featurepolicy.rocks/geolocation.html",
    "line_number": 20,
    "column_number": 37,
    "disposition": "enforce"
  }
}
```

With a `ReportingObserver` you can even do this in the page, with
JavaScript:

```javascript
const myObserver = new ReportingObserver(reportList => {
  reportList.forEach(report => {
    alert("Whatever you just tried to do was blocked by policy.: " + report.body.feature);
  });
}, {"types": ["feature-policy-violation"]);

myObserver.observe();
```

Then any violations that occur within that page will cause the callback to be
run, and the user will be bombarded by annoying popups every time it happens.

What about the frames I embed? Can I get reports for those, too?
-------------

This is also possible, but the rules are a little bit different. Because of the
same-origin-policy, we don't want to leak information to a parent frame about
what a cross-origin child frame is doing. We take two different precautions to
avoid this as far as possible:

First, feature policy violation reports which come from a cross-origin child
frame are not observable in JavaScript. A `ReportingObserver` object will not see
them at all.

Second, reports which are normally delivered directly to the service in the
`Report-To` header will instead be anonymized and aggregated. The reports are
first delivered to an aggregation server, which will hold on to them until it
has received enough reports, from different users, for a given violation, that
it can generate a single aggregate report. This report will be stripped of
identifying data, and will include a count to indicate how many times it was
triggered. The aggregate report will then be delivered to the original
reporting endpoint that was specified in the header.

Can I just trigger reports, without actually enforcing the policy?
-------------

Yes! In addition to using feature policy to disable features, you can use it
tentatively, to ask "what would break, if I used this policy?".

To do this, you can specify a "report-only" policy for any given feature. In
the policy declaration, you use the feature name with "`-report-only`" appended,
and specify the list of origins where the feature would be allowed, like with
any other policy.

```http
Feature-Policy: sync-xhr-report-only 'none'
```

```html
<iframe allow="fullscreen-report-only https://video.example.com" src="..."></iframe>
```

If the frame, and all of its ancestors up to the top-level document, all agree
that the feature should either be allowed, or should be report-only, then a
page which uses the feature will see it succeed (as usual), but a report will
be sent to the Reporting API endpoints of each frame which said 'report-only'.

The report looks much like a feature policy violation report, but the
`"disposition"` field is set to `"report"` rather than `"enforce"`.

If they are generated in a cross-origin frame, these reports will be aggregated
before delivery, just like the actual violation reports.

Note that if any ancestor frame actually disables the feature using a policy,
then it will actually be blocked, and a violation report will be generated
instead. Report-only mode cannot be used to enable a feature which would
otherwise be disabled.
