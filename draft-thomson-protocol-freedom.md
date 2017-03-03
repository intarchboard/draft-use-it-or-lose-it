---
title: "Freedom in Protocols"
abbrev: Protocol Freedom
docname: draft-thomson-protocol-freedom-latest
date: {DATE}
category: std
ipr: trust200902
area: GEN
workgroup: Thoughtful

stand_alone: yes
pi: [toc, sortrefs, symrefs, docmapping]

author:
  -
    ins: M. Thomson
    name: Martin Thomson
    org: Mozilla
    email: martin.thomson@gmail.com

normative:


informative:

  FOUCAULT:
    title: "Ethics: Subjectivity and Truth"
    author:
      -
        ins: M. Foucault
        name: Michel Foucault
      -
        ins: P. Rabinow
        name: Paul Rabinow
        role: editor
    date: 1997
    seriesinfo:
      ISBN: 1565843525

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

--- abstract

The ability to change protocols depends on exercising that ability.


--- middle

# Introduction

Successful protocols evolve over time in response to changes in their usage.
New use cases, conditions and constraints on the deployment of a protocol can
render the protocol obsolete.  A successful protocol {{?RFC5218}} will change in
ways that allow it to continue to fulfill the needs of its users.

Changes often manifest over time with a shift in the usage patterns of the
protocol.  These changes are made without changing the fundamental structure of
the protocol.  However, it is rare that the design of a protocol properly
anticipate future needs to the extent that a protocol can remain relevant
without being changed itself.

Evolving requirements for protocols can often be managed incrementally for some
time.  Over longer periods it might be necessary to deploy entirely new
protocols.  Though new protocol versions are much more disruptive, they are
needed if there are fundamental shortcomings in the original protocol design
when assessed against current needs.

Experience with deployment of Internet protocols has shown that adding features
to protocols or designing entirely new versions is not uniformly successful.

This document examines the conditions that determine whether protocol
maintainers have the ability - the freedom - to design and deploy new protocol
mechanisms or protocols.


# Implementations of Protocols are Imperfect

A change to a protocol can be made extremely difficult to deploy if there are
bugs in implementations with which the deployment needs to interoperate.  Bugs
in the handling of new codepoints or extensions can mean that instead of
handling the mechanism as designed, endpoints react poorly.  This can manifest
as abrupt termination of sessions, errors, crashes, or disappearances of
endpoints and timeouts.

Interoperability with other implementations is usually highly valued, so
deploying mechanisms that trigger adverse reactions like these can be untenable.
This is true even if the negative reactions happen infrequently or only under
certain circumstances.

Deploying a change to a protocol could require fixing a good proportion of
these issues in the deployments with buggy implementations.  This can involve a
tedious and lengthy process that includes identifying the cause of these errors,
finding the responsible implementation, coordinating a bug fix and release plan,
contacting the operator of affected services, and waiting for the fix to be
deployed to those services.

Given the effort involved in fixing these problems, the existence of these sorts
of bugs can outright prevent the deployment of some protocol changes.  It could
even be necessarily to come up with a new protocol design that uses a different
method to achieve the same result.


## Good Protocol Design is Not Sufficient

It is often argued that the design of a protocol extension point or version
negotiation capability is critical to the freedom that it ultimately offers.

RFC 6709 {{?RFC6709}} contains a great deal of well-considered advice on
designing for extension.  It includes the following advice:

> This means that, to be useful, a protocol version- negotiation mechanism
  should be simple enough that it can reasonably be assumed that all the
  implementers of the first protocol version at least managed to implement the
  version-negotiation mechanism correctly.

This has proven to be insufficient in practice.  Many protocols have evidence of
imperfect implementation of key mechanisms, and those that aren't used are the
ones that fail most often. The same paragraph from RFC 6709 even acknowledges
the existence of this problem, but does not offer any remedy:

> The nature of protocol version-negotiation mechanisms is that, by definition,
  they don't get widespread real-world testing until *after* the base protocol
  has been deployed for a while, and its deficiencies have become evident.

Transport Layer Security (TLS) {{?RFC5246}} provides an example of where a
design that is objectively sound fails when incorrectly implemented.  TLS
provides examples of failures in protocol version negotiation and extensibility.

Version negotiation in TLS 1.2 and earlier uses the "Highest mutually supported
version (HMSV)" exactly as described in {{?RFC6709}}.  However, clients are
unable to advertise a new version without causing a non-trivial proportions of
sessions to fail due to bugs in server (or middlebox) implementations.

Intolerance to new TLS versions is so severe {{INTOLERANCE}} that TLS 1.3 has
abandoned HMSV version negotiation for a different mechanism
{{?I-D.ietf-tls-tls13}}.

The server name indication (SNI) {{?RFC6066}} in TLS is another excellent
example of the failure of a well-designed extensibility point.  SNI uses the
same technique for extension that is used with considerable success in other
parts of the TLS protocol.  The original design of SNI includes the ability to
include multiple names of different types.

What is telling in this case is that SNI was defined with just one type of name:
a domain name.  No other type has ever been defined, though several have been
proposed.  Despite an otherwise exemplary design, SNI is so inconsistently
implemented that any hope for using the extension point it defines has been
abandoned {{SNI}}.


## Multi-Party Interactions and Middleboxes

Even the most superficially simple protocols can often involve more actors than
is immediately apparent.  A two-party protocol still has two ends, and even at
the endpoints of an interaction, protocol elements can be passed on to other
entities (machines or software components) in ways that can affect protcol
operation.

One of the key challenges in deploying new features in a protocol is ensuring
compat that all actors that could influence the success of the protocol.

In particular, one of the consequences of an unencrypted protocol is that any
element on path can interact with the protocol.  This was originally seen as an
advantage for HTTP and was what produced the notion of a transparent proxy
{{?RFC7230}}.  Because HTTP was specifically designed with intermediation in
mind, this was not only possible, but sometimes advantageous.  Consequently,
transparent proxies for HTTP are commonplace.

Middleboxes are also protocol participants, to the degree that they are able to
observe and act within the protocol.  The degree to which a middlebox
participates varies from the basic functions that a router performs to full
session participation.  For example, a SIP back-to-back user agent (B2BUA)
{{?RFC7092}} can be very deeply involved in the SIP protocol.

By increasing the number of different actors involved in any single protocol
exchange, the number of potential implementation bugs that a deployment needs to
contend with also increases.  This can increase the difficulty of deploying
changes to a protocol considerably.


# Protocol Freedom

If design is insufficient, what then would give protocol designers the freedom
to later change a deployed protocol?

Michel Foucault defines freedom as a practice rather than a state that is
bestowed or attained:

> \[...] when a colonized people attempts to liberate itself from its
  colonizers, this is indeed a practice of liberation in the strict sense.  But
  we know very well \[...] that this practice of liberation is not in itself
  sufficient to define the practices of freedom that will still be needed if
  this people, this society, and these individuals are to be able to
  define·admissible and acceptable forms of existence or political
  society. --{{FOUCAULT}}

In the same way, the design of a protocol for extensibility and eventual
replacement {{?RFC6709}} is the act of liberation.  Liberating a protocol makes
it possible to use that protocol for use cases that were not originally
conceived by the designers or to provide a replacement that is better suited.


## Use of Protocol Freedom

Designing for protocol freedom makes freedom possible, but does not assure it.

> This is why I emphasize practices of freedom over processes of liberation;
  again, the latter indeed have their place, but they do not seem to me, to be
  capable by themselves of defining all the practical forms of
  freedom. --{{FOUCAULT}}

If freedom exists only in practice, it becomes clear that the definition of
mechanisms is not important, it's the active use of those mechanisms that
determines the existence of freedom.

This is evident in protocols that are known to have viable version negotiation
or extension points.

For example, header fields in email {{?RFC5322}}, HTTP {{?RFC7230}} and SIP
{{?RFC3261}} all derive from the same basic design.  Though there have been
improvements to the process by which new header fields are defined, there is no
evidence of any barriers to deploying header fields with new names and
semantics.

In another example, the attribute-value pairs (AVPs) in Diameter {{?RFC6733}}
are fundamental to the design of the protocol.  The definition of new uses of
Diameter regularly exercise the ability to add new AVPs and do so with no fear
that the definition might be unsuccessful.

These examples show extension points that are heavily used also being relatively
unaffected by deployment issues.  These examples also confirm the case that good
design is not a prerequisite for success.  On the contrary, success is often
despite shortcomings in the design.  For instance, the shortcomings of HTTP
header fields are significant enough that there are ongoing efforts to improve
the syntax {{?I-D.ietf-httpbis-header-structure}}.

This suggests that it is *use* that ensures that a given protocol capability
remains available.  Protocols that fail to use a mechanism, or a protocol that
only rarely uses a mechanism, suffer an inability to rely on that mechanism.


## Reliance on Protocol Freedom

The best way to guarantee that a protocol mechanism is used is to make it
critical to an endpoint participating in that protocol.  This means that
implementations need to rely on the existence of a mechanism and that also
depend on the mechanism being used.

For example, the message format in SMTP relies on header fields for most of its
functions, including the most basic functions.  This, together with the fact
that new header fields are added so easily, means that no implementation can
operate on the Internet for any reasonable period without encountering a header
field that it does not understand.  An SMTP implementation therefore needs to be
able to both process header fields that it understands and ignore those that it
does not.

In this way, implementation of this extensibility mechanism is not merely
mandated by the specification, it becomes critical to the functioning of the
endpoint.  Should an implementation fail to correctly implement the mechanism,
that failure would become immediately apparent.


## Unused Extension Points Become Unusable

In contrast, there are many examples of extension points in protocols that have
been either completely unused, or their use was so infrequent that they could no
longer be relied upon to function correctly.

HTTP has a number of very effective extension points in addition to the
aforementioned header fields.  It also has some examples of extension point that
are so rarely used that it is possible that they are not at all usable.
Extension points in HTTP that might be unwise to use include the extension point
on each chunk in the chunked transfer coding {{?RFC7230}}, the ability to use
transfer codings other than the chunked coding, and the range unit in a range
request {{?RFC7233}}.


## Defensive Design for Protocol Freedom

"Grease" {{?I-D.ietf-tls-grease}} identifies lack of use as an issue (protocol
mechanisms "rusting" shut) and proposes a system of use that exercises extension
points by using dummy values.

The grease design aims at the style of negotiation most used in TLS, where the
client offers a set of options and the server chooses the one that it most
prefers from those that it supports.  In that design, the client randomly offers
options (usually just one) from a set of reserved values.  These values are
guaranteed to never be assigned real meaning, so the server will never have
cause to genuinely select one of these values.

The principle that grease operates on is that an implementation that is
regularly exposed to unknown values is not likely to become intolerant of new
values when they appear.  This depends somewhat on the fact that the difficulty
of implementing the protocol mechanism correctly is not significantly more
effort than implementing code to specifically filter out the randomized "grease"
values.  To that end, the values that are reserved are not taken from a single
contiguous block of code points, but are distributed across the entire space of
code points.

The hope with grease is that errors in implementing the mechanisms it safeguards
are quickly detected.  If many implementations send these "grease" values as
part of regular operation, then any failure to properly handle these apparently
new values will be detected.

This form of defensive design has some limitations.  It does not necessarily
create the need for an implementation to rely on the mechanism it safeguards;
that is determined by the underlying protocol itself.  More critically, it does
not easily translate to other forms of extension point.  Other techniques might
be necessary for protocols that don't rely on the particular style of exchange
that is predominant in TLS.

A method of defensive design is that of using cryptography (such as TLS) to
forcibly reduce the number of entities that can participate in the protocol.
Data that is exchanged under encryption cannot be seen by middleboxes, excluding
them from participating in that part of the protocol.  Similarly, data that is exchanged
with integrity protection cannot be modified by middleboxes.

The QUIC protocol {{?I-D.ietf-quic-transport}}, adopts both encryption to
carefully control what information is exposed to middleboxes.  QUIC also uses
integrity protection over all the data it exchanges to prevent modification.


#

A protocol replacement necessarily takes some time to deploy and displace the
protocol that it was intended to replace {{?I-D.iab-protocol-transitions}}.  Moreover, it
is possible that the new protocol will never completely replace the old.

The decision to exclude some use cases and deployments can restore



# Security and Privacy Considerations


# IANA Considerations

This document makes no request of IANA.


--- back
