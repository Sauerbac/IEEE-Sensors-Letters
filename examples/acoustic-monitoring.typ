#import "@local/ieee-sensors-letters:0.1.0": *

// This is a fictional formatting demonstration. All signals, measurements,
// apparatus details, and results are deterministic synthetic examples.
#show: lsens.with(
  title: [Model-Based Acoustic Event Detection for Compact Condition-Monitoring Nodes],
  authors: (
    (name: "Mira Chen", affiliations: (1,), membership: 1),
    (name: "Noah Alvarez", affiliations: (1, 2)),
    (name: "Leonie Hart", affiliations: (2,), membership: 1),
  ),
  affiliations: (
    [Department of Measurement Systems, Example Technical University, City, Country],
    [Embedded Sensing Laboratory, Example Research Center, City, Country],
  ),
  memberships: ("Member, IEEE",),
  subject: "Sensor Applications",
  abstract: [This fictional demonstration presents a compact acoustic event detector for condition-monitoring nodes. A damped sinusoidal model converts each candidate transient into an amplitude-normalized residual score, while a short adaptive noise estimate controls the decision threshold. Deterministic synthetic signals emulate normal operation, impulsive background interference, and fault-like knocking events. Across the illustrative test set, the model-based score separates fault-like events from background impulses while retaining a small memory footprint and bounded processing latency. The example is designed to exercise the IEEE Sensors Letters Typst template and makes no experimental or product-performance claim. All apparatus details, numerical values, diagrams, signals, and results are synthetic and reproducible from the source artwork.],
  graphical-abstract: image("../template/assets/graphical-abstract.svg", width: 7cm),
  keywords: ("Acoustic sensing", "condition monitoring", "edge detection", "synthetic data"),
  received: [This fictional manuscript is supplied only as a formatting demonstration.],
  corresponding: [M. Chen (e-mail: mira.chen\@example.org).],
  publication: "VOL. 0, NO. 1, OCTOBER 2026",
  article-number: "0000000",
  copyright: [Synthetic demonstration for the ieee-sensors-letters Typst package.],
)

= Introduction <sec:introduction>
Acoustic sensing can complement vibration measurements when direct mechanical
coupling is inconvenient. Recent work has described knocking sounds with a
signal model to reduce dependence on large fault datasets @pichler2024, while
public machine-sound corpora illustrate the variety of operating conditions
encountered by anomaly detectors @koizumi2019. A compact edge implementation,
however, must also expose its assumptions and operate within fixed memory and
latency budgets.

This letter demonstrates a transparent detector built around a damped transient
model. The claimed contribution is deliberately fictional: the manuscript,
figures, and results exist to exercise a reusable typesetting template. The
example nonetheless follows a plausible technical narrative and labels all
synthetic evidence explicitly.

== Signal Model
For a candidate beginning at sample $n_0$, the modeled transient is
$ hat(x)[n] = A e^(-alpha (n-n_0)) sin(2 pi f_0 (n-n_0) / f_s + phi). $ <eq:model>
The fitted amplitude $A$, decay $alpha$, frequency $f_0$, and phase $phi$ are
estimated over a fixed window. A normalized residual score is
$ r = frac(sum_(n=n_0)^(n_0+N-1) (x[n] - hat(x)[n])^2, sum_(n=n_0)^(n_0+N-1) x[n]^2 + epsilon). $ <eq:residual>
Small values of $r$ indicate agreement with the fault-like model. The detector
combines this agreement with event energy $E$ and declares an alert when
$ q = (1-r) log(1 + E / sigma^2) > tau, $ <eq:score>
where $sigma^2$ is a rolling noise estimate and $tau$ is the threshold.

#figure(
  image("assets/test-rig.svg", width: 100%),
  caption: [Fictional evaluation arrangement. A microphone observes a compact motor housing while an edge node fits the transient model and records an alert score. All geometry and labels are illustrative.],
) <fig:rig>

= Synthetic Evaluation
@fig:rig shows the notional arrangement. A deterministic signal generator
creates 12-s records at #quantity("16", "kHz"). Normal records contain a
stationary harmonic component and colored noise. Background-interference
records add isolated broadband impulses, whereas fault-like records add three
damped sinusoids with randomized phase. No recording of a real machine is used.

== Implementation
The edge pipeline uses a 256-sample circular buffer. Candidate events are
triggered by an energy ratio, fitted over 64 samples, and summarized by the
score in Equation @eq:score. All processing is single precision in the fictional
implementation. @tab:settings lists the illustrative configuration.

#figure(
  table(
    columns: 3,
    table.hline(), [Parameter], [Symbol], [Synthetic setting], table.hline(),
    [Sampling rate], [$f_s$], [16 kHz],
    [Fit window], [$N$], [64 samples],
    [Noise horizon], [—], [2 s],
    [Decision threshold], [$tau$], [2.4],
    [Buffer memory], [—], [1.0 KiB], table.hline(),
  ),
  caption: [Illustrative Detector Configuration.],
) <tab:settings>

The implementation deliberately avoids a learned embedding. That choice keeps
the example focused on interpretable equations, a compact table, and a bounded
processing path rather than implying a comparison with current production
classifiers.

#figure(
  image("assets/synthetic-results.svg", width: 100%),
  scope: "parent",
  caption: [Deterministic synthetic results. (a) Normalized waveform with a modeled fault-like transient. (b) Event score and fixed threshold. (c) Illustrative receiver-operating characteristic for the model score and an energy-only baseline. Values demonstrate figure and caption layout; they are not experimental measurements.],
) <fig:results>

= Results
The example generator produces 600 normal windows, 200 background-impulse
windows, and 200 fault-like windows. In @fig:results(a), the fitted model follows
the damped component after the trigger. The score in @fig:results(b) crosses the
threshold for the fault-like event and remains below it for the two background
impulses. The receiver-operating curves in @fig:results(c) summarize the same
synthetic construction across thresholds.

At the selected operating point, the model score yields the illustrative values
in @tab:results. Confidence intervals are intentionally omitted because
these deterministic examples do not represent a sampled physical population.

#figure(
  table(
    columns: 3,
    table.hline(), [Metric], [Energy only], [Model score], table.hline(),
    [Synthetic true-positive rate], [0.84], [0.94],
    [Synthetic false-positive rate], [0.11], [0.03],
    [Median latency], [1.8 ms], [3.6 ms],
    [Working memory], [0.6 KiB], [1.0 KiB], table.hline(),
  ),
  caption: [Synthetic Operating-Point Summary.],
) <tab:results>

== Sensitivity to Noise
Increasing the background level primarily affects the energy term in Equation
@eq:score. Updating $sigma^2$ over a horizon much longer than the fit window
keeps the threshold interpretable, but a sudden sustained disturbance can still
bias the estimate. A deployable study would therefore specify the acoustic
environment, sensor transfer function, and calibration protocol rather than
relying on the generic values used here.

== Resource Use
The fictional node stores one circular buffer and a small set of sufficient
statistics. Its notional median processing latency remains below one frame at
the stated sampling rate. These values demonstrate the typography of units and
tables; they are not benchmarks of hardware or software distributed with this
template.

= Discussion
The model score illustrates a useful design tradeoff. Adding structure can
reject broadband impulses that an energy detector accepts, but the benefit
depends on how accurately the chosen transient describes the target fault.
Changes in mounting, speed, enclosure, or reverberation may violate that model.
The transparent residual makes such failure modes easier to inspect than a
single opaque anomaly score, but it does not eliminate the need for field data.

Three limitations would govern a real evaluation. First, representative
negative examples must include the dominant plant disturbances. Second, sensor
placement and sampling hardware must be fixed or explicitly modeled. Third,
threshold selection must be separated from final performance estimation. None
of these questions can be answered by synthetic layout data.

== Reproducibility of the Demonstration
Every plotted value is encoded directly in the original SVG artwork distributed
with this example. The diagrams use no external icons, photographs, datasets,
or copied paper figures. This makes the example legally clean and ensures that
future edits remain inspectable in version control.

= Conclusion
This fictional letter demonstrated the template with front matter, a graphical
abstract, equations, single- and double-column figures, tables, citations,
cross-references, and a final references column. The underlying detector should
not be interpreted as validated research. Authors can replace the narrative and
assets while retaining the structural conventions shown here.

#colbreak()
#acknowledgment[The authors and affiliations are fictional. All data and artwork were created solely to demonstrate the `ieee-sensors-letters` Typst package.]
#references(bibliography("references.bib", style: "ieee", title: [References]))
