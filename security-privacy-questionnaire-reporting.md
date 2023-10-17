# [Self-Review Questionnaire: Security and Privacy](https://w3ctag.github.io/security-questionnaire/)

Note: Permissions Policy reporting is built on top of the Reporting API, which has its own questionnaire here: https://github.com/w3c/reporting/blob/main/security-and-privacy-questionnaire.md

1.  What information does this feature expose,
     and for what purposes?

    This feature exposes information about violations of permissions policy configuration, which are actions taken by a site which are not allowed under the site's permissions policy. This allows site owners to see what code running on their site is attempting to use features which have been blocked. This feature also includes a Report-Only mode, which can be used by site owners to "preview" the effect that enforcing a given policy would have on their site, before actually deploying it. This allows site owners to deploy new policies with greater confidence that their site will not be broken for their users.
    
1.  Do features in your specification expose the minimum amount of information
     necessary to implement the intended functionality?

    Yes. The information is limited to the feature whose policy was violated, and enough information to identify the page and time when the violation occurred. (Per the Reporting API)
    
1.  Do the features in your specification expose personal information,
     personally-identifiable information (PII), or information derived from
     either?

    No, this specification does not deal with any PII. The Reporting API, which is the underlying mechanism through which reports are generated and sent, could expose the user's IP address to third parties, although (see the reporting questionnaire as well) this is the same as with any resource request.
    
1.  How do the features in your specification deal with sensitive information?

    Sensitive information is removed from the reports, by the reporting API. See that feature's questonnaire.
    
1.  Do the features in your specification introduce state
     that persists across browsing sessions?

    No.

1.  Do the features in your specification expose information about the
     underlying platform to origins?

    No.
    
1.  Does this specification allow an origin to send data to the underlying
     platform?

    No.
    
1.  Do features in this specification enable access to device sensors?

    No.  
   
1.  Do features in this specification enable new script execution/loading mechanisms?

    No.

1.  Do features in this specification allow an origin to access other devices?

    No.

1.  Do features in this specification allow an origin some measure of control over
     a user agent's native UI?

    No.

1.  What temporary identifiers do the features in this specification create or
     expose to the web?

    None.

1.  How does this specification distinguish between behavior in first-party and
     third-party contexts?

    Permissions policy in general tackles the issue of first-party vs third-party behaviour, through the inheritance of policies from embedders to embedded frames. The embedded can disable features in the embedded content, in general. Reporting configurations, however, are not inherited in any context (first or third party), and so the embedder cannot request to receive reports about actions taken in the embedded frame. Each document must configure its own reporting policy in order to generate and send violation reports.
    
1.  How do the features in this specification work in the context of a browser’s
     Private Browsing or Incognito mode?

    This is not covered by this specification.
    
1.  Does this specification have both "Security Considerations" and "Privacy
     Considerations" sections?

    Yes.
    
1.  Do features in your specification enable origins to downgrade default
     security protections?

    No.
    
1.  What happens when a document that uses your feature is kept alive in BFCache
     (instead of getting destroyed) after navigation, and potentially gets reused
     on future navigations back to the document?

    Nothing special. The existing policy, including reporting configuration, remains in place.
    
1.  What happens when a document that uses your feature gets disconnected?

    Nothing. If the disconnected document is still capable of violating the permissions policy, then reports will continue to be generated and queued for sending.
1.  What should this questionnaire have asked?
