---
title: "Long-term Viability of Protocol Extension Mechanisms"
abbrev: Use It Or Lose It
docname: draft-iab-use-it-or-lose-it-latest
category: info
ipr: trust200902

stand_alone: yes
pi: [toc, sortrefs, symrefs, docmapping]

author:
  -
    ins: M. Thomson
    name: Martin Thomson
    org: Mozilla
    email: mt@lowentropy.net
  -
    ins: T. Pauly
    name: Tommy Pauly
    org: Apple
    email: tpauly@apple.com

normative:


informative:
  HASH:
    title: "Deploying a New Hash Algorithm"
    author:
      -
        ins: S. Bellovin
        name: Steven M. Bellovin
      -
        ins: E. Rescorla
        name: Eric M. Rescorla
    date: 2006
    target: "https://www.cs.columbia.edu/~smb/papers/new-hash.pdf"
    seriesinfo: "Proceedings of NDSS '06"

  SNI:
    title: "Accepting that other SNI name types will never work"
    author:
      -
        ins: A. Langley
        name: Adam Langley
    date: 2016-03-03
    target: "https://mailarchive.ietf.org/arch/msg/tls/1t79gzNItZd71DwwoaqcQQ_4Yxc"

  INTOLERANCE:
    title: "Re: [TLS] Thoughts on Version Intolerance"
    author:
      -
        ins: H. Kario
        name: Hubert Kario
    date: 2016-07-20
    target: "https://mailarchive.ietf.org/arch/msg/tls/bOJ2JQc3HjAHFFWCiNTIb0JuMZc"

  RIPE-99:
    title: "RIPE NCC and Duke University BGP Experiment"
    author:
      -
        ins: E. Romijn
        name: Erik Romijn
    date: 2010-08-27
    target: https://labs.ripe.net/Members/erik/ripe-ncc-and-duke-university-bgp-experiment/

  DNSFLAGDAY:
    title: "DNS Flag Day 2019"
    date: 2019-05
    target: https://dnsflagday.net/2019/

  HTTP11: I-D.ietf-httpbis-messaging



--- abstract

The ability to change protocols depends on exercising the extension and version
negotiation mechanisms that support change.  Protocols that don't use these
mechanisms can find it difficult and costly to deploy changes.


--- middle

# Introduction

A successful protocol {{?SUCCESS=RFC5218}} needs to change in ways that allow it
to continue to fulfill the needs of its users.  New use cases, conditions and
constraints on the deployment of a protocol can render a protocol that does not
change obsolete.

Usage patterns and requirements for a protocol shift over time.  In response,
implementations might adjust usage patterns within the constraints of the
protocol, the protocol could be extended, or a replacement protocol might be
developed.  Experience with Internet-scale protocol deployment shows that each
option comes with different costs.  {{?TRANSITIONS=RFC8170}} examines the
problem of protocol evolution more broadly.

This document examines the specific conditions that determine whether protocol
maintainers have the ability to design and deploy new or modified protocols.
{{implementations}} highlights some historical examples of difficulties in
transitions to new protocol features.  {{use-it}} argues that ossified protocols
are more difficult to update and successful protocols make frequent use of new
extensions and code-points.  {{use}} and {{other}} outline several strategies
that might aid in ensuring that protocol changes remain possible over time.

The experience that informs this document is predominantly at "higher" layers of
the network stack, in protocols that operate at very large scale and
Internet-scale applications.  It is possible that these conclusions are less
applicable to protocol deployments that have less scale and diversity, or
operate under different constraints.


# Imperfect Implementations Limit Protocol Evolution {#implementations}

It can be extremely difficult to deploy a change to a protocol if there are
bugs in implementations with which the new deployment needs to interoperate.
Bugs in how new codepoints or extensions are handled often mean that endpoints
will react poorly to the use of extension mechanisms. This can manifest
as abrupt termination of sessions, errors, crashes, or disappearances of
endpoints and timeouts.

Interoperability with other implementations is usually highly valued, so
deploying mechanisms that trigger adverse reactions can be untenable.  Where
interoperability is a competitive advantage, this is true even if the negative
reactions happen infrequently or only under relatively rare conditions.

Deploying a change to a protocol could require implementations to fix a
substantial proportion of the bugs that the change exposes.  This can
involve a difficult process that includes identifying the cause of
these errors, finding the responsible implementation(s), coordinating a
bug fix and release plan, contacting users and/or the operator of affected
services, and waiting for the fix to be deployed.

Given the effort involved in fixing problems, the existence of these sorts of
bugs can outright prevent the deployment of some types of protocol changes,
especially for protocols involving multiple parties or that are considered
critical infrastructure (e.g., IP, BGP, DNS, or TLS).  It could even be
necessary to come up with a new protocol design that uses a different method to
achieve the same result.

The set of interoperable features in a protocol is often the subset of its
features that have some value to those implementing and deploying the protocol.
It is not always the case that future extensibility is in that set.


## Good Protocol Design is Not Itself Sufficient {#not-good-enough}

It is often argued that the careful design of a protocol extension point or
version negotiation capability is critical to the freedom that it ultimately
offers.

RFC 6709 {{?EXTENSIBILITY=RFC6709}} contains a great deal of well-considered
advice on designing for extension.  It includes the following advice:

> This means that, to be useful, a protocol version-negotiation mechanism
  should be simple enough that it can reasonably be assumed that all the
  implementers of the first protocol version at least managed to implement the
  version-negotiation mechanism correctly.

This has proven to be insufficient in practice.  Many protocols have evidence of
imperfect implementation of critical mechanisms of this sort.  Mechanisms that
aren't used are the ones that fail most often.  The same paragraph from RFC
6709 acknowledges the existence of this problem, but does not offer any remedy:

> The nature of protocol version-negotiation mechanisms is that, by definition,
  they don't get widespread real-world testing until *after* the base protocol
  has been deployed for a while, and its deficiencies have become evident.

Indeed, basic interoperability is considered critical early in the deployment of
a protocol.  A desire to deploy can result in an engineering practice that
values simplicity, which could result in deferring implementation of version
negotiation and extension mechanisms.  This leads to these mechanisms being
particularly affected by this problem.


## Disuse Can Hide Problems {#disuse}

There are many examples of extension points in protocols that have been either
completely unused, or their use was so infrequent that they could no longer be
relied upon to function correctly.


### TLS

Transport Layer Security (TLS) {{?TLS12=RFC5246}} provides examples of where a
design that is objectively sound fails when incorrectly implemented.  TLS
provides examples of failures in protocol version negotiation and extensibility.

Version negotiation in TLS 1.2 and earlier uses the "Highest mutually supported
version (HMSV)" scheme exactly as it is described in {{?EXTENSIBILITY}}.
However, clients are unable to advertise a new version without causing a
non-trivial proportion of sessions to fail due to bugs in server and middlebox
implementations.

Intolerance to new TLS versions is so severe {{INTOLERANCE}} that TLS 1.3
{{?TLS13=RFC8446}} has abandoned HMSV version negotiation for a new mechanism.

The server name indication (SNI) {{?TLS-EXT=RFC6066}} in TLS is another
excellent example of the failure of a well-designed extensibility point.  SNI
uses the same technique for extension that is used with considerable success in
other parts of the TLS protocol.  The original design of SNI includes the
ability to include multiple names of different types.

What is telling in this case is that SNI was defined with just one type of name:
a domain name.  No other type has ever been standardized, though several have
been proposed.  Despite an otherwise exemplary design, SNI is so inconsistently
implemented that any hope for using the extension point it defines has been
abandoned {{SNI}}.

Even where extension points have multiple valid values, if the set of permitted
values does not change over time, there is still a risk that new values are not
tolerated by existing implementations.  If the set of values for a particular
field remains fixed over a long period, some implementations might not correctly
handle a new value when it is introduced.  For example, implementations of TLS
broke when new values of the signature_algorithms extension were introduced.


### DNS

Ossified DNS code bases and systems resulted in fears that new Resource Record
Codes (RRCodes) would take years of software propagation before new RRCodes
could be used.  The result for a long time was heavily overloaded use of the TXT
record, such as in the Sender Policy Framework {{?SPF=RFC7208}}.  It wasn't
until after the standard mechanism for dealing with new RRCodes
{{?RRTYPE=RFC3597}} was considered widely deployed that new RRCodes can be
safely created and used.


### SNMP

As a counter example, the first version of the Simple Network Management
Protocol (SNMP) {{?SNMPv1=RFC1157}} defines that unparseable or unauthenticated
messages are simply discarded without response:

> It then verifies the version number of the SNMP message. If there is a
  mismatch, it discards the datagram and performs no further actions.

When SNMP versions 2, 2c and 3 came along, older agents did exactly what the
protocol specifies.  Deployment of new versions was likely successful because
the handling of newer versions was both clear and simple.


### HTTP

HTTP has a number of very effective extension points in addition to the
aforementioned header fields.  It also has some examples of extension points
that are so rarely used that it is possible that they are not at all usable.

Extension points in HTTP that might be unwise to use include the extension point
on each chunk in the chunked transfer coding {{Section 7.1 of HTTP11}}, the
ability to use transfer codings other than the chunked coding, and the range
unit in a range request {{Section 14 of HTTP}}.


### IPv4

Codepoints that are reserved for future use can be especially problematic.
Reserving codepoints without attributing semantics to their use can result in
diverse or conflicting semantics being attributed without any hope of
interoperability.  An example of this is the "class E" address space in IPv4
{{?RFC0988}}, which was reserved without assigning any semantics.

For protocols that can use negotiation to attribute semantics to codepoints, it
is possible that unused codepoints can be reclaimed for active use, though this
requires that the negotiation include all protocol participants.  For something
as fundamental as addressing, negotiation is difficult or even impossible, as
all nodes on the network path plus potential alternative paths would need to be
involved.


## Multi-Party Interactions and Middleboxes {#middleboxes}

Even the most superficially simple protocols can often involve more actors than
is immediately apparent.  A two-party protocol has two ends, but even at the
endpoints of an interaction, protocol elements can be passed on to other
entities in ways that can affect protocol operation.

One of the key challenges in deploying new features is ensuring compatibility
with all actors that could be involved in the protocol.

Protocols deployed without active measures against intermediation will tend to
become intermediated over time, as network operators deploy middleboxes to
perform some function on traffic {{?PATH-SIGNALS=RFC8588}}.  In particular, one
of the consequences of an unencrypted protocol is that any element on path can
interact with the protocol.  For example, HTTP was specifically designed with
intermediation in mind, transparent proxies {{?HTTP=I-D.ietf-httpbis-semantics}}
are not only possible but sometimes advantageous, despite some significant
downsides.  Consequently, transparent proxies for cleartext HTTP are commonplace.
The DNS protocol was designed with intermediation in mind through its use of
caching recursive resolvers {{?DNS=RFC1034}}.  What was less anticipated was the
forced spoofing of DNS records by many middle-boxes such as those that inject
authentication or pay-wall mechanisms as an authentication and authorization
check, which are now prevalent in hotels, coffee shops and business networks.

Middleboxes are also protocol participants, to the degree that they are able
to observe and act in ways that affect the protocol.  The degree to which a
middlebox participates varies from the basic functions that a router performs
to full participation.  For example, a SIP back-to-back user agent (B2BUA)
{{?B2BUA=RFC7092}} can be very deeply involved in the SIP protocol.

This phenomenon appears at all layers of the protocol stack, even when
protocols are not designed with middlebox participation in mind. TCP's
{{?TCP=RFC0793}} extension points have been rendered difficult to use, largely
due to middlebox interactions, as experience with Multipath TCP
{{?MPTCP=RFC6824}} and Fast Open {{?TFO=RFC7413}} has shown.  IP's version field
was rendered useless when encapsulated over Ethernet, requring a new ethertype
with IPv6 {{?RFC2464}}, due in part to layer 2 devices making
version-independent assumptions about the structure of the IPv4 header.  The
announcements of new optional transitive attributes in BGP caused significant
routing instability {{RIPE-99}}.

By increasing the number of different actors involved in any single protocol
exchange, the number of potential implementation bugs that a deployment needs to
contend with also increases.  In particular, incompatible changes to a protocol
that might be negotiated between endpoints in ignorance of the presence of a
middlebox can result in a middlebox interfering in negative and
unexpected ways.

Unfortunately, middleboxes can considerably increase the difficulty of
deploying new versions or other changes to a protocol.


# Retaining Viable Protocol Evolution Mechanisms {#use-it}

The design of a protocol for extensibility and eventual replacement
{{?EXTENSIBILITY}} does not guarantee the ability to exercise those options.
The set of features that enable future evolution need to be interoperable in the
first implementations and deployments of the protocol.  Implementation of
mechanisms that support evolution is necessary to ensure that they remain
available for new uses, and history has shown this occurs almost exclusively
through active mechanism use.

The conditions for retaining the ability to evolve a design is most clearly
evident in the protocols that are known to have viable version negotiation or
extension points.  The definition of mechanisms alone is insufficient; it's the
assured implementation through active use of those mechanisms that determines
the existence of freedom.  Protocols that routinely add new extensions and code
points rarely have trouble adding additional ones, especially when the handling
of new versions or extensions is well defined.


## Examples of Active Use {#ex-active}

For example, header fields in email {{?SMTP=RFC5322}}, HTTP {{?HTTP}}
and SIP {{?SIP=RFC3261}} all derive from the same basic design, which amounts to
a list of name/value pairs.  There is no evidence of significant barriers to
deploying header fields with new names and semantics in email and HTTP as
clients and servers can ignore headers they do not understand or need.  The
widespread deployment of SIP B2BUAs means that new SIP header fields do not
reliably reach peers, however, which doesn't necessarily cause interoperability
issues but rather causes feature deployment issues due to the lack of
option passing middleboxes (see {{middleboxes}}).

As another example, the attribute-value pairs (AVPs) in Diameter
{{?DIAMETER=RFC6733}} are fundamental to the design of the protocol.  Any use of
Diameter requires exercising the ability to add new AVPs.  This is routinely
done without fear that the new feature might not be successfully deployed.

These examples show extension points that are heavily used are also being
relatively unaffected by deployment issues preventing addition of new values
for new use cases.

These examples also confirm the case that good design does not guarantee
success.  On the contrary, success is often despite shortcomings in the design.
For instance, the shortcomings of HTTP header fields are significant enough that
there are ongoing efforts to improve the syntax
{{?HTTP-HEADERS=RFC8941}}.

Only by using a protocol's extension capabilities does it ensure the
availability of that capability.  Protocols that fail to use a mechanism, or a
protocol that only rarely uses a mechanism, may suffer an inability to rely on
that mechanism.


## Dependency is Better {#need-it}

The best way to guarantee that a protocol mechanism is used is to make the
handling of it critical to an endpoint participating in that protocol.
This means that implementations must rely on both the existence of extension
mechanisms and their continued, repeated expansion over time.

For example, the message format in SMTP relies on header fields for most of its
functions, including the most basic delivery functions.  A deployment of SMTP
cannot avoid including an implementation of header field handling.  In addition
to this, the regularity with which new header fields are defined and used
ensures that deployments frequently encounter header fields that they do not yet
(and may never) understand.  An SMTP implementation therefore needs to be able
to both process header fields that it understands and ignore those that it does
not.

In this way, implementing the extensibility mechanism is not merely mandated by
the specification, it is crucial to the functioning of a protocol deployment.
Should an implementation fail to correctly implement the mechanism, that failure
would quickly become apparent.

Caution is advised to avoid assuming that building a dependency on an extension
mechanism is sufficient to ensure availability of that mechanism in the long
term.  If the set of possible uses is narrowly constrained and deployments do
not change over time, implementations might not see new variations or assume a
narrower interpretation of what is possible.  Those implementations might still
exhibit errors when presented with new variations.



## Restoring Active Use

With enough effort, active use can be used to restore capabililities.

EDNS {{?EDNS=RFC6891}} was defined to provide extensibility in DNS.  Intolerance
of the extension in DNS servers resulted in a fallback method being widely
deployed (see {{Section 6.2.2 of EDNS}}).  This fallback resulted in EDNS being
disabled for affected servers.  Over time, greater support for EDNS and
increased reliance on it for different features motivated a flag day
{{DNSFLAGDAY}} where the workaround was removed.

The EDNS example shows that effort can be used to restore capabilities.  This is
in part because EDNS was actively used with most resolvers and servers.  It was
therefore possible to force a change to ensure that extension capabilities would
always be available.  However, this required an enormous coordination effort.  A
small number of incompatible servers and the names they serve also became
inaccessible to most clients.


# Active Use {#use}

As discussed in {{use-it}}, the most effective defense against ossification of
protocol extension points is active use.

Implementations are most likely to be tolerant of new values if they depend on
being able to frequently use new values.  Failing that, implementations that
routinely see new values are more likely to correctly handle new values.  More
frequent changes will improve the likelihood that incorrect handling or
intolerance is discovered and rectified.  The longer an intolerant
implementation is deployed, the more difficult it is to correct.

What constitutes "active use" can depend greatly on the environment in which a
protocol is deployed.  The frequency of changes necessary to safeguard some
mechanisms might be slow enough to attract ossification in another protocol
deployment, while being excessive in others.


## Version Negotiation

As noted in {{not-good-enough}}, protocols that provide version negotiation
mechanisms might not be able to test that feature until a new version is
deployed.  One relatively successful design approach has been to use the
protocol selection mechanisms built into a lower-layer protocol to select the
protocol.  This could allow a version negotiation mechanism to benefit from
active use of the extension point by other protocols.

For instance, all published versions of IP contain a version number as the four
high bits of the first header byte.  However, version selection using this
field proved to be unsuccessful. Ultimately, successful deployment of IPv6
over Ethernet {{?RFC2464}} required a different EtherType from IPv4.  This
change took advantage of the already-diverse usage of EtherType.

Other examples of this style of design include Application-Layer Protocol
Negotiation ({{?ALPN=RFC7301}}) and HTTP content negotiation ({{Section 12 of
HTTP}}).

This technique relies on the codepoint being usable.  For instance, the IP
protocol number is known to be unreliable and therefore not suitable
{{?NEW-PROTOCOLS=DOI.10.1016/j.comnet.2020.107211}}.


## Falsifying Active Use {#grease}

"Grease" was originally defined for TLS {{?GREASE=RFC8701}}, but has been
adopted by other protocols, such as QUIC {{?QUIC=RFC9000}}.  Grease identifies
lack of use as an issue (protocol mechanisms "rusting" shut) and proposes
reserving values for extensions that have no semantic value attached.

The design in {{?GREASE}} is aimed at the style of negotiation most used in TLS,
where one endpoint offers a set of options and the other chooses the one that it
most prefers from those that it supports.  An endpoint that uses grease randomly
offers options - usually just one - from a set of reserved values.  These values
are guaranteed to never be assigned real meaning, so its peer will never have
cause to genuinely select one of these values.

More generally, greasing is used to refer to any attempt to exercise extension
points without changing endpoint behavior, other than to encourage participants
to tolerate new or varying values of protocol elements.

The principle that grease operates on is that an implementation that is
regularly exposed to unknown values is less likely to be intolerant of new
values when they appear.  This depends largely on the assumption that the
difficulty of implementing the extension mechanism correctly is as easy or
easier than implementing code to identify and filter out reserved values.
Reserving random or unevenly distributed values for this purpose is thought to
further discourage special treatment.

Without reserved greasing codepoints, an implementation can use code points from
spaces used for private or experimental use if such a range exists.  In addition
to the risk of triggering participation in an unwanted experiment, this can be
less effective.  Incorrect implementations might still be able to identify these
code points and ignore them.

In addition to advertising bogus capabilities, an endpoint might also
selectively disable non-critical protocol elements to test the ability of peers
to handle the absence of certain capabilities.

This style of defensive design is limited because it is only superficial.  As
greasing only mimics active use of an extension point, it only exercises a small
part of the mechanisms that support extensibility.  More critically, it does not
easily translate to all forms of extension points.  For instance, HMSV
negotiation cannot be greased in this fashion.  Other techniques might be
necessary for protocols that don't rely on the particular style of exchange that
is predominant in TLS.

Grease is deployed with the intent of quickly revealing errors in implementing
the mechanisms it safeguards.  Though it has been effective at revealing
problems in some cases with TLS, the efficacy of greasing isn't proven more
generally.  Where implementations are able to tolerate a non-zero error rate in
their operation, greasing offers a potential option for safeguarding future
extensibility.  However, this relies on there being a sufficient proportion of
participants that are willing to invest the effort and tolerate the risk of
interoperability failures.


# Complementary Techniques {#other}

The protections to protocol evolution that come from [active use](#use) can be
improved through the use of other defensive techniques. The techniques listed
here might not prevent ossification on their own, but can make active use more
effective.


## Cryptography

Cryptography can be used to reduce the number of middlebox entities that can
participate in a protocol or limit the extent of participation.  Using TLS or
other cryptographic tools can therefore reduce the number of entities that can
influence whether new features are usable.

{{?PATH-SIGNALS=RFC8588}} recommends the use of encryption and integrity
protection to limit participation.  For example, encryption is used by the QUIC
protocol {{?QUIC=RFC9000}} to limit the information that is available to
middleboxes and integrity protection prevents modification.


## Fewer Extension Points

A successful protocol will include many potential types of extension.  Designing
multiple types of extension mechanism, each suited to a specific purpose, might
leave some extension points less heavily used than others.

Disuse of a specialized extension point might render it unusable.  In contrast,
having a smaller number of extension points with wide applicability could
improve the use of those extension points.  Use of a shared extension point for
any purpose can protect rarer or more specialized uses.

Both extensions and core protocol elements use the same extension points in
protocols like HTTP {{?HTTP}} and DIAMETER {{?DIAMETER}}; see {{ex-active}}.


### Invariants

Documenting aspects of the protocol that cannot or will not change as
extensions or new versions are added can be a useful exercise. Understanding
what aspects of a protocol are invariant can help guide the process of
identifying those parts of the protocol that might change.

As a means of protecting extensibility, a declaration of protocol invariants is
useful only to the extent that protocol participants are willing to allow new
uses for the protocol.  Like with greasing, protocol participants could still
purposefully block the deployment of new features.  A protocol that declares
protocol invariants relies on implementations understanding and respecting those
invariants.

Protocol invariants need to be clearly and concisely documented.  Including
examples of aspects of the protocol that are not invariant, such as the
appendix of {{?QUIC-INVARIANTS=RFC8999}}, can be used to
clarify intent.


## Effective Feedback

While not a direct means of protecting extensibility mechanisms, feedback
systems can be important to discovering problems.

Visibility of errors is critical to the success of techniques like grease (see
{{grease}}).  The grease design is most effective if a deployment has a means of
detecting and reporting errors.  Ignoring errors could allow problems to become
entrenched.

Feedback on errors is more important during the development and early deployment
of a change.  It might also be helpful to disable automatic error recovery
methods during development.

Automated feedback systems are important for automated systems, or where error
recovery is also automated.  For instance, connection failures with HTTP
alternative services {{?ALT-SVC=RFC7838}} are not permitted to affect the
outcome of transactions.  An automated feedback system for capturing failures in
alternative services is therefore necessary for failures to be detected.

How errors are gathered and reported will depend greatly on the nature of the
protocol deployment and the entity that receives the report.  For instance, end
users, developers, and network operations each have different requirements for
how error reports are created, managed, and acted upon.

Automated delivery of error reports can be critical for rectifying deployment
errors as early as possible, such as seen in {{?DMARC=RFC7489}} and
{{?SMTP-TLS-Reporting=RFC8460}}.


# Security Considerations

Many of the problems identified in this document are not the result of
deliberate actions by an adversary, but more the result of mistakes, decisions
made without sufficient context, or simple neglect.  Problems therefore not the
result of opposition by an adversary.  In response, the recommended measures
generally assume that other protocol participants will not take deliberate
action to prevent protocol evolution.

The use of cryptographic techniques to exclude potential participants is the
only strong measure that the document recommends.  However, authorized protocol
peers are most often responsible for the identified problems, which can mean
that cryptography is insufficient to exclude them.

The ability to design, implement, and deploy new protocol mechanisms can be
critical to security.  In particular, it is important to be able to replace
cryptographic algorithms over time {{?AGILITY=RFC7696}}.  For example,
preparing for replacement of weak hash algorithms was made more difficult
through misuse {{HASH}}.


# IANA Considerations

This document makes no request of IANA.


--- back

# Acknowledgments
{:numbered="false"}

Wes Hardaker, Mirja Kühlewind, Mark Nottingham, and Brian Trammell made
significant contributions to this document.
