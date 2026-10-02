// Independent Typst implementation of Michael Shell's IEEE_lsens class.
// Layout rationale and validation evidence live in the private workshop.
// Requires Typst 0.15.0 and the bundled fonts directory.
#import "vendor/wrap-it/wrap-it.typ": wrap-content

#let serif = "TeX Gyre Termes"
#let sans = "TeX Gyre Heros"
#let math-font = "TeX Gyre Termes Math"
#let tex-pt = 72pt / 72.27
#let text-width = 43 * 12 * tex-pt
#let column-gap = 0.25in
#let column-width = (text-width - column-gap) / 2
#let title-blue = rgb("004772")

// Semantic helpers remain visible to the conservative LaTeX exporter.
#let acknowledgment(body) = metadata((lsens: "acknowledgment", body: body))
#let references(value) = metadata((
  lsens: "references",
  path: if type(value) == str { value } else { none },
  body: if type(value) == content { value } else { none },
))
#let run-in(title, body, level: 3) = {
  assert(level in (3, 4), message: "Run-in headings support levels 3 and 4")
  metadata((lsens: "run-in", title: title, body: body, level: level))
}
#let quantity(value, unit) = metadata((lsens: "quantity", value: str(value), unit: unit))
#let panels(paths) = metadata((lsens: "panels", paths: paths))
// For expressions not covered by the exporter, provide an explicit equivalent.
#let dual(typst, latex) = metadata((lsens: "dual", body: typst, latex: latex))

#let uses-helper(value, name) = {
  if type(value) == content { uses-helper(value.fields(), name) }
  else if type(value) == dictionary {
    value.at("lsens", default: none) == name or value.values().any(v => uses-helper(v, name))
  }
  else if type(value) == array { value.any(v => uses-helper(v, name)) }
  else { false }
}

#let ieee-number(..nums) = {
  let n = nums.pos()
  if n.len() == 1 { numbering("I.", n.last()) }
  else if n.len() == 2 { numbering("A.", n.last()) }
  else if n.len() == 3 { numbering("1)", n.last()) }
  else { numbering("a)", n.last()) }
}

#let author-block(authors, affiliations, memberships, editorial: false) = {
  set par(justify: false, first-line-indent: 0pt, leading: 2.1pt, spacing: 0pt)
  set text(font: if editorial { serif } else { sans },
    size: if editorial { 8pt } else { 11pt },
    spacing: if editorial { 0.35em } else { 100% }, top-edge: 0.7em, bottom-edge: -0.2em)
  authors.enumerate().map(((i, a)) => {
    if i > 0 { if i == authors.len() - 1 { [, and ] } else { [, ] } }
    a.name
    if a.at("affiliations", default: ()).len() > 0 {
      super(size: 8pt, a.affiliations.map(str).join(","))
    }
    if a.at("membership", default: none) != none {
      for _ in range(a.membership) {
        h(0.5pt); super(size: 8pt, text(font: serif, style: "normal", "*"))
      }
      h(0.5pt)
    }
  }).join()
  v(5.1pt)
  set text(size: 8pt, style: "italic")
  set par(leading: 2.67pt)
  for (i, affiliation) in affiliations.enumerate() {
    if i > 0 { linebreak() }
    super(size: 7pt, str(i + 1)); h(1pt); affiliation
  }
  for (i, membership) in memberships.enumerate() {
    linebreak()
    for _ in range(i + 1) {
      super(size: 7pt, text(font: serif, style: "normal", "*")); h(0.5pt)
    }
    membership
  }
}

#let lsens(
  title: [],
  authors: (),
  affiliations: (),
  memberships: (),
  subject: "Sensor Applications",
  abstract: none,
  graphical-abstract: none,
  keywords: (),
  received: none,
  corresponding: none,
  editor: none,
  doi: none,
  publication: "VOL. 1, NO. 1, MONTH 2026",
  article-number: "0000000",
  copyright: none,
  kind: "regular",
  color: true,
  equation-align: center,
  body,
) = {
  assert(kind in ("regular", "viewpoint", "editorial"), message: "Unknown article kind")
  let source = (
    schema: 1, title: title, authors: authors, affiliations: affiliations,
    memberships: memberships, subject: subject, abstract: abstract,
    graphical-abstract: graphical-abstract, keywords: keywords, received: received,
    corresponding: corresponding, editor: editor, doi: doi, publication: publication,
    article-number: article-number, copyright: copyright, kind: kind,
    color: color, equation-align: repr(equation-align), body: body,
  )
  set document(title: title, author: authors.map(a => a.name), keywords: keywords)
  set text(font: serif, size: 9pt, lang: "en", region: "US",
    hyphenate: true, top-edge: 0.7em, bottom-edge: -0.2em,
    spacing: 0.35em, ligatures: true)
  // 0.7em + 0.2em + 3.8pt = 11.9pt baseline-to-baseline.
  set par(justify: true, leading: 3.8pt, spacing: 3.8pt,
    justification-limits: (spacing: (min: 40%, max: 157.14%)),
    first-line-indent: (amount: 9pt, all: true))
  set page(paper: "us-letter", columns: 2,
    margin: (x: (8.5in - text-width) / 2, top: 63.076pt, bottom: 44.5pt),
    header-ascent: 22.976pt,
    header: context {
      set text(font: sans, size: 7pt, spacing: 0.278em)
      set par(first-line-indent: 0pt)
      let p = counter(page).get().first()
      let issue = upper(publication)
      let id = article-number
      block(width: 100%, height: 7pt)[
        #grid(columns: (1fr, 1fr),
          if calc.odd(p) { issue } else { id },
          align(right, if calc.odd(p) { id } else { issue }))
        #if p > 1 { place(top + left, dy: 10.5pt, line(length: 100%, stroke: 1pt)) }
      ]
    },
    footer: none,
  )
  set columns(gutter: column-gap)
  set heading(numbering: ieee-number)
  show heading.where(level: 1): it => block(width: 100%, above: 21pt, below: 10.5pt, sticky: true)[
    #set text(font: sans, size: 10pt, weight: "regular", spacing: 100%)
    #set par(first-line-indent: 0pt, leading: 2pt, justify: false)
    #align(center)[#if it.numbering != none { counter(heading).display(it.numbering); h(0.7em) }#upper(it.body)]
  ]
  show heading.where(level: 2): it => block(width: 100%, above: 19pt, below: 9.5pt, sticky: true)[
    #set text(font: sans, size: 10pt, weight: "regular", style: "italic", spacing: 100%)
    #set par(first-line-indent: 0pt, leading: 2pt, justify: false)
    #if it.numbering != none { counter(heading).display(it.numbering); h(0.7em) }#it.body
  ]
  // Native low-level headings are blocks in Typst, but run-ins in the class.
  // Require the semantic helper rather than silently changing paragraph flow.
  show heading: it => {
    assert(it.level <= 2, message: "Use run-in(title, body, level: 3 or 4) for deeper headings")
    it
  }
  show math.equation: set text(font: math-font, spacing: 100%)
  set math.equation(numbering: "(1)", number-align: right)
  show math.equation.where(block: true): set align(equation-align)
  show math.equation.where(block: true): set block(above: 7.65pt, below: 10pt)
  set figure(placement: top, gap: 12.25pt, supplement: [Fig.], numbering: "1")
  show figure: set text(font: sans, size: 7pt, spacing: 100%)
  show figure: set par(first-line-indent: 0pt, leading: 2.25pt)
  show figure.where(kind: table): set figure(gap: 11pt, supplement: [TABLE], numbering: "1")
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.caption: set text(font: sans, size: 8pt, spacing: 100%)
  show figure.caption: set par(justify: true, first-line-indent: 0pt, leading: 2.3pt)
  show figure.caption: it => block(width: 100%)[
    #set align(left)
    #it.supplement~#it.counter.display(it.numbering).#h(1em)#it.body
  ]
  set table(stroke: none, inset: (x: 4pt, y: 3pt))
  set footnote.entry(separator: none, gap: 0pt, indent: 0pt, clearance: 10pt)
  show footnote.entry: set text(font: sans, size: 7pt, spacing: 100%)
  show footnote.entry: set par(first-line-indent: 0pt, leading: 2.95pt)
  set bibliography(style: "ieee", title: [References])
  show bibliography: set text(size: 7pt)
  show bibliography: set par(first-line-indent: 0pt, leading: 2.95pt, spacing: 2.95pt)
  set list(indent: 9pt, body-indent: 4pt, spacing: 3.8pt, tight: false)
  set enum(numbering: "1)", indent: 9pt, body-indent: 4pt, spacing: 3.8pt, tight: false)
  show link: set text(fill: black)
  show ref: it => {
    let el = it.element
    if el != none and el.func() == figure and el.kind == table {
      [Table~#counter(figure.where(kind: table)).at(el.location()).first()]
    } else if el != none and el.func() == math.equation {
      [#link(el.location())[(#counter(math.equation).at(el.location()).first())]]
    } else { it }
  }
  show metadata: it => {
    let d = it.value
    if type(d) == dictionary and d.at("lsens", default: none) != none {
      if d.lsens == "quantity" { box[#d.value#h(0.166em)#text(style: "normal", d.unit)] }
      else if d.lsens == "panels" {
        grid(columns: (1fr,) * d.paths.len(), gutter: 8pt,
          ..d.paths.enumerate().map(((i, path)) => [
            #image(path, width: 100%)
            #align(center)[(#numbering("a", i + 1))]
          ]))
      }
      else if d.lsens == "dual" { d.body }
      else if d.lsens == "run-in" {
        parbreak(); h(if d.level == 4 { 18pt } else { 9pt })
        emph[#d.title:]; h(0.4em); d.body; parbreak()
      }
      else if d.lsens == "acknowledgment" {
        heading(numbering: none)[Acknowledgment]
        block[
          #set text(size: 7pt)
          #set par(leading: 2.95pt, spacing: 2.95pt)
          #d.body
        ]
      }
      else if d.lsens == "references" {
        if kind == "editorial" {
          block(above: 12pt, inset: (left: 6 * 12 * tex-pt))[
            #author-block(authors, affiliations, memberships, editorial: true)
          ]
        }
        if d.body != none { d.body }
        else { bibliography(d.path, style: "ieee", title: [References]) }
      }
    }
  }
  [#metadata(source) <lsens-source>]

  let notes = {
    if corresponding != none { [Corresponding author: #corresponding]; parbreak() }
    if editor != none { [Associate Editor: #editor.]; parbreak() }
    if doi != none { [Digital Object Identifier #doi] }
  }
  // A first-page parent float reserves the same space in BOTH columns.
  // Unlike an overlay, neither manuscript text nor footnotes can collide with it.
  if copyright != none {
    place(bottom, float: true, scope: "parent", clearance: 10pt)[
      #set text(font: sans, size: 7pt, spacing: 100%)
      #set par(first-line-indent: 0pt, leading: 2.95pt, justify: false)
      #block(width: text-width)[#align(center, copyright)]
    ]
  }
  if notes != [] {
    place(bottom, float: true, clearance: 10pt)[
      #set text(font: sans, size: 7pt, spacing: 100%)
      #set par(first-line-indent: 0pt, leading: 2.95pt, justify: false)
      #notes
    ]
  }
  place(top, float: true, scope: "parent", clearance: 20.6pt, pad(top: -5.476pt)[
    #set par(first-line-indent: 0pt, justify: false, spacing: 0pt)
    #set text(font: sans, spacing: 100%, hyphenate: false, top-edge: "cap-height", bottom-edge: "baseline")
    #if subject != none {
      grid(columns: (auto, 1fr), column-gutter: 4pt, align: bottom,
        text(size: 12pt, subject), line(length: 100%, stroke: 1pt))
      v(18pt)
    }
    #block(width: 100%)[
      #set par(leading: 4.4pt, spacing: 0pt)
      #text(size: 14pt, top-edge: 0.7em, bottom-edge: -0.2em,
        weight: "bold", fill: if color { title-blue } else { black }, title)
    ]
    #v(10pt)
    #block(width: 93.3%, above: 0pt, below: 0pt)[
      #if kind != "editorial" { author-block(authors, affiliations, memberships) }
      #if received != none { v(12pt); text(size: 7pt, received) }
      #if abstract != none {
        v(9pt)
        block[
          // Keep Helvetica's 0.278em nominal word space explicit. Prevent
          // compression here because Typst's line optimizer otherwise accepts
          // wrapped lines that LaTeX avoids, collapsing words almost together.
          #set text(size: 9pt, spacing: 0.278em, hyphenate: true,
            top-edge: 0.7em, bottom-edge: -0.2em)
          #set par(justify: true, leading: 2.9pt, first-line-indent: 0pt,
            justification-limits: (spacing: (min: 100%, max: 150%)))
          #let prose = [Abstract—#abstract]
          #if graphical-abstract != none {
            let graphic = if type(graphical-abstract) == content {
              graphical-abstract
            } else {
              image(graphical-abstract, width: 7cm)
            }
            wrap-content(graphic, prose,
              align: top + right, columns: (1fr, 7cm), column-gutter: 10 * tex-pt)
          } else { prose }
        ]
      }
      #if keywords.len() > 0 {
        v(13pt)
        text(size: 8pt)[Index Terms—#keywords.join(", ").]
      }
    ]
  ])
  body
  if kind == "editorial" and not uses-helper(body, "references") {
    block(above: 12pt, inset: (left: 6 * 12 * tex-pt))[
      #author-block(authors, affiliations, memberships, editorial: true)
    ]
  }
  context [#metadata((
    pages: counter(page).final().first(),
    figures: query(figure).map(f => (
      kind: repr(f.kind), scope: f.scope, page: f.location().page(),
      label: f.at("label", default: none))),
    bibliography: query(bibliography).map(b => b.location().position()),
  )) <lsens-preflight>]
}
