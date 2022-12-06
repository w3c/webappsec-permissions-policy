Permissions Policy Reporting
============================

In a nutshell
-------------

A document's permissions policy sets limits on what kinds of actions it can
perform; what APIs are available. When a page tries to do something that is
blocked by policy, the browser currently surfaces a message in developer
tools -- this can be great when developing a site, but is often not enough
when dealing with a site in production. It would be very useful to be able to
collect reports about real problems that users are seeing.

We're addressing this by integrating permissions policy with the
[Reporting API](https://w3c.github.io/reporting/). In the same way that sites
can opt in to receiving reports about CSP violations or deprecations, they will
now be able to receive reports about permissions policy violations in the wild.

Sounds great! How do I do it?
-------------

Turning on the Reporting API is simple; all you need to do is configure your
web server to send an HTTP header that declares where the reports should be
sent. Something like:

```http
Reporting-Endpoints: violation-reports="https://reportingapi.tools/public/submit"
```

Then, in the `Permissions-Policy` header, specify a `report-to` directive, whose
value is the name of the reporting endpoint:

```http
Permissions-Policy: geolocation=(), report-to=violation-reports
```

This header will cause the browser to send details about any per policy
violations, via an HTTP POST, to a web server running at that URL. The messages
that the browser sends will look something like this:

```json
{
 "type": "permissions-policy-violation",
 "url": "https://a.featurepolicy.rocks/geolocation.html",
 "age": 60000,
 "user_agent": "Mozilla/1.22 (compatible; MSIE 2.0; Windows 95)",
 "body": {
    "featureId": "geolocation",
    "message": "Geolocation access has been blocked because of a policy applied to the current document. See https://goo.gl/EuHzyv for more details.",
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
    alert("Whatever you just tried to do was blocked by policy.: " + report.body.featureId);
  });
}, {"types": ["permissions-policy-violation"]});

myObserver.observe();
```

Then any violations that occur within that page will cause the callback to be
run, and the user will be bombarded by annoying popups every time it happens.

What about the frames I embed? Can I get reports for those, too?
-------------

At the moment, this isn't possible. There are many privacy concerns around being
able to observe behaviour, no matter how subtle, in third-party frames.
Cooperating frames may be able to get around this restriction by communicating
with each other using `postMessage()`, observing reports in one frame and relaying
them to the other, but without a mechanism to ensure mutual trust between frames,
there is no way to unilaterally set up reporting from the embedder.

[This is an area we'd like to improve -- see [previous versions of this document](https://github.com/WICG/feature-policy/blob/ea8085c74eef65de8eef81c1e23c1980497a7ed7/reporting.md) for some ideas.]

Can I just trigger reports, without actually enforcing the policy?
-------------

Yes! In addition to using permissions policy to disable features, you can use it
tentatively, to ask "what would break, if I used this policy?".

To do this, you can specify a "report-only" policy for any given feature. Like
[Content Security Policy](https://w3c.github.io/webappsec-csp/#cspro-header),
this uses a separate HTTP header, in this case named `Permissions-Policy-Report-Only`.
This policy looks like any other policy, but can specify features which, even if
allowed, should trigger reporting when used.

The report-only policy is a separate policy attached to the document served with
the header. Like the enforcing policy, it inherits from the document's parent
frame, if any, but the header can be used to further restrict the set of features
which should be allowed.

(Note that a [previous version of this document](https://github.com/WICG/feature-policy/blob/670fe1b4b7d12752f307fd9eecccb6558b0b0d83/reporting.md) used a special
suffix for report-only policies, and combined enforcing and reporting policies in
the same declarations. This has changed to better reflect the fact that the
report-only policy is local to the current document and does not affect child
frames at all.)

```http
Permissions-Policy-Report-Only: geolocation=(); report-to=violation-reports
```

If the enforcing policy for the frame is such that the feature should be allowed,
but the reporting policy disallows it, then a page which uses the feature will see it
succeed (as usual), but a report will be sent to the frame's Reporting API endpoint.

The report looks much like a permissions policy violation report, but the
`"disposition"` field is set to `"report"` rather than `"enforce"`.

Note that if any ancestor frame actually disables the feature using a policy,
then it will actually be blocked, and a violation report will be generated
instead. Report-only mode cannot be used to enable a feature which would
otherwise be disabled.
