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

  AGILITY:
    title: "Accepting that other SNI name types will never work"
    author:
      -
        ins: A. Langley
        name: Adam Langley
    date: 2016-03-03
    target: "https://mailarchive.ietf.org/arch/msg/tls/1t79gzNItZd71DwwoaqcQQ_4Yxc"

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


# Good Design is Not Sufficient

It is often argued that the design of a protocol extension point or version
negotiation capability is critical to the freedom that it ultimately offers.

RFC 6709 {{?RFC6709}} contains a great deal of well-considered advice on
designing for extension.  It includes the following advice:

> This means that, to be useful, a protocol version- negotiation mechanism
  should be simple enough that it can reasonably be assumed that all the
  implementers of the first protocol version at least managed to implement the
  version-negotiation mechanism correctly.

This has proven to be insufficient in practice.  Transport Layer Security (TLS)
{{?RFC5246}} provides two good examples of different failures.

The first failure in TLS is that of version negotiation.  Version negotiation in
TLS precisely follows the "Highest mutually supported version (HMSV)" described
in {{?RFC6709}}.  However, even advertising that a new version is supported
results in a non-trivial proportion of sessions failing.

"Intolerance" to new TLS versions is so severe that TLS 1.3 has abandoned HMSV
version negotiation for a different mechanism {{?I-D.ietf-tls-tls13}}.

The server name indication (SNI) {{?RFC6066}} in TLS is another excellent
example of the failure of a well-design extensibility point.  Though it only
defined use with domain names, the original design of SNI includes the ability
to include multiple names of different types.  SNI uses the same technique for
extension that is used with considerable success in other parts of the TLS
protocol.

Despite an exemplary design, SNI is so inconsistently implemented that any hope
for using the extension point it defines has been abandoned {{SNI}}.


# Protocol Freedom

If design is insufficient, what then would give protocol designers the freedom
to later change a deployed protocol?

Michel Foucault defines freedom as a practice rather than a state that is
bestowed or attained:

> [...] when a colonized people attempts to liberate itself from its colonizers,
  this is indeed a practice of liberation in the strict sense.  But we know very
  well [...] that this practice of liberation is not in itself sufficient to
  define the practices of freedom that will still be needed if this people, this
  society, and these individuals are to be able to define·admissible and
  acceptable forms of existence or political society. --{{FOUCAULT}}

In the same way, the design of a protocol for extensibility and eventual
replacement {{?RFC6709}} is the act of liberation.  Liberating a protocol makes
it possible to use that protocol for use cases that were not originally
conceived by the designers or to provide a replacement that is better suited.

Designing for protocol freedom makes freedom possible, but does not assure it.

> This is why I emphasize practices of freedom over processes of liberation;
  again, the latter indeed have their place, but they do not seem to me, to be
  capable by themselves of defining all the practical forms of
  freedom. --{{FOUCAULT}}

Applying this to protocol design it becomes apparent that freedom exists only in
practice and that defining mechanisms is insufficient - they have to be
**used**.

Section 4.1 of RFC 6709 acknowledges the existence of a shortcoming, but does
not offer any remedy:

> The nature of protocol version-negotiation mechanisms is that, by definition,
  they don't get widespread real-world testing until *after* the base protocol
  has been deployed for a while, and its deficiencies have become evident.



# Grease

Is it possible to defensively design a protocol in a way that increases the
chance that freedom is possible when protocol designers reach for it?

{{?I-D.ietf-tls-grease}} suggests a model that


# Other Considerations

## Middleboxes



## Incomplete Replacement

A protocol replacement necessarily takes some time to deploy and displace the
protocol that it was intended to replace {{?I-D.iab-protocol-transitions}}.  Moreover, it
is possible that the new protocol will never completely replace the old.

Degrees of freedom



# Security and Privacy Considerations


# IANA Considerations

This document makes no request of IANA.


--- back
