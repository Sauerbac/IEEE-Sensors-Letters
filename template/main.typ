#import "@local/ieee-sensors-letters:0.1.0": *

#show: lsens.with(
  title: [Your Paper Title],
  authors: (
    (name: "Alex Researcher", affiliations: (1,), membership: 1),
  ),
  affiliations: (
    [Department of Electrical Engineering, Example University, City, Country],
  ),
  memberships: ("Member, IEEE",),
  abstract: [Replace this text with a concise abstract of no more than 150 words. State the sensing problem, the approach, and the principal result without citations, footnotes, displayed equations, or unsupported claims. The included graphic is an original placeholder and should be replaced with artwork that summarizes the actual contribution.],
  graphical-abstract: image("assets/graphical-abstract.svg", width: 7cm),
  keywords: ("Sensors", "measurement", "signal processing"),
  corresponding: [A. Researcher (e-mail: author\@example.org).],
  publication: "VOL. 1, NO. 1, MONTH 2026",
  copyright: [Publication information will be supplied by IEEE.],
)

= Introduction <sec:introduction>
Introduce the sensing problem and the contribution. This starter demonstrates
ordinary prose, a citation @example, and the section hierarchy.

== Measurement Model
Define every symbol near its first use. A simple sensor response can be written
as
$ y = S dot x + b, $ <eq:model>
where $S$ is sensitivity and $b$ is offset. Refer to Equation @eq:model using a
stable label.

#figure(
  image("assets/graphical-abstract.svg", width: 100%),
  caption: [Replace this original placeholder with a manuscript figure.],
) <fig:example>

= Conclusion
Summarize the result and its practical significance. Check the current journal
instructions and accepted submission formats before submission.

#acknowledgment[Replace this paragraph with funding and contributor acknowledgments.]
#references(bibliography("references.bib", style: "ieee", title: [References]))
