#let conf(
  title: none,
  subtitle: none,
  authors: (),
  affiliations: (),
  keywords: (),
  date: none,
  lang: "en",
  region: none,
  abstract-title: none,
  abstract: none,
  thanks: none,

  margin: none,
  paper: "a4",

  font: ("Noto Serif CJK JP",),
  fontsize: 10.5pt,
  mathfont: (),
  codefont: (),

  linestretch: 1.0,
  sectionnumbering: "1.1",
  pagenumbering: "1",

  linkcolor: none,
  citecolor: none,
  filecolor: none,

  cols: 1,

  body,
) = {

  // ============================================================
  // Document metadata
  // ============================================================

  let author-names = authors.map(a => a.name)

  set document(
    title: if title == none { "" } else { title },
    author: author-names,
  )

  // ============================================================
  // Basic document settings
  // ============================================================

  set text(
    font: font,
    size: fontsize,
    lang: lang,
  )

  set page(
    paper: paper,
    margin: (
      top: 22mm,
      bottom: 22mm,
      left: 22mm,
      right: 22mm,
    ),
    numbering: pagenumbering,
    number-align: center + bottom,
  )

  set par(
    justify: true,
    leading: 0.75em,
    first-line-indent: 1em,
  )

  // ============================================================
  // Title
  // ============================================================

  align(center)[
    #text(
      size: 17pt,
      weight: "bold",
    )[
      #title
    ]

    #v(7mm)

    // ----------------------------------------------------------
    // Authors
    // ----------------------------------------------------------

    #for (i, author) in authors.enumerate() [
      #if i > 0 [
        #h(0.8em)
      ]

      #author.name

      #if "affiliation" in author [
        #super[
          #author.affiliation.map(str).join(",")
        ]
      ]

      #if "corresponding" in author and author.corresponding [
        #super[*]
      ]
    ]

    #v(5mm)

    // ----------------------------------------------------------
    // Affiliations
    // ----------------------------------------------------------

    #set text(size: 9.5pt)

    #for affiliation in affiliations [
      #super[#affiliation.id]
      #h(0.4em)
      #affiliation.name
      #linebreak()
    ]

    // ----------------------------------------------------------
    // Corresponding authors
    // ----------------------------------------------------------

    #let corresponding-authors = authors.filter(
      a => "corresponding" in a and a.corresponding
    )

    #if corresponding-authors.len() > 0 [
      #v(3mm)

      #set text(size: 9pt)

      #for author in corresponding-authors [
        [* Corresponding author]

        #if "email" in author [
          [: #author.email]
        ]

        #linebreak()
      ]
    ]

    #v(5mm)
  ]

  // ============================================================
  // Abstract
  //
  // Markdown:
  //
  // ::: abstract
  // ...
  // :::
  // ============================================================

  show block.where(
    label: <abstract>
  ): it => [
    #block(
      inset: (
        left: 8mm,
        right: 8mm,
      ),
    )[
      #set text(size: 9.5pt)

      #set par(
        justify: true,
        leading: 0.7em,
        first-line-indent: 0pt,
      )

      #align(center)[
        #text(
          size: 11pt,
          weight: "bold",
        )[Abstract]
      ]

      #v(2mm)

      #it.body
    ]

    #v(4mm)
  ]

  // ============================================================
  // Keywords
  // ============================================================

  if keywords.len() > 0 [
    #block(
      inset: (
        left: 8mm,
        right: 8mm,
      ),
    )[
      #set text(size: 9pt)

      #strong[Keywords:]
      #h(0.5em)
      #keywords.join(", ")
    ]

    #v(6mm)
  ]

  // ============================================================
  // Headings
  // ============================================================

  set heading(
    numbering: (..nums) => {
      nums.pos().map(str).join(".")
    },
  )

  show heading.where(level: 1): it => {
    set text(
      weight: "bold",
      size: 13pt,
    )

    let prefix = if it.numbering != none {
      [
        #numbering(
          it.numbering,
          ..counter(heading).at(it.location())
        )
        #h(0.8em)
      ]
    } else {
      []
    }

    block(
      above: 1.6em,
      below: 0.8em,
    )[
      #prefix
      #it.body
    ]
  }

  show heading.where(level: 2): it => {
    set text(
      weight: "bold",
      size: 11pt,
    )

    let prefix = if it.numbering != none {
      [
        #numbering(
          it.numbering,
          ..counter(heading).at(it.location())
        )
        #h(0.8em)
      ]
    } else {
      []
    }

    block(
      above: 1.3em,
      below: 0.6em,
    )[
      #prefix
      #it.body
    ]
  }

  show heading.where(level: 3): it => {
    set text(
      weight: "bold",
      size: 10.5pt,
    )

    let prefix = if it.numbering != none {
      [
        #numbering(
          it.numbering,
          ..counter(heading).at(it.location())
        )
        #h(0.8em)
      ]
    } else {
      []
    }

    block(
      above: 1em,
      below: 0.5em,
    )[
      #prefix
      #it.body
    ]
  }

  // ============================================================
  // Equations
  // ============================================================

  set math.equation(
    numbering: "(1)",
  )

  // ============================================================
  // Figures and tables
  // ============================================================

  show figure: it => {
    set text(size: 9.5pt)
    it
  }

  // ============================================================
  // Acknowledgments
  //
  // Markdown:
  //
  // ::: acknowledgments
  // ...
  // :::
  // ============================================================

  show block.where(
    label: <acknowledgments>
  ): it => [
    #v(1em)

    #text(
      size: 11pt,
      weight: "bold",
    )[Acknowledgments]

    #v(0.5em)

    #it.body
  ]

  // ============================================================
  // References generated by Pandoc citeproc
  // ============================================================

  show <refs>: it => {
    set text(size: 9pt)

    set par(
      justify: true,
      leading: 0.65em,
      first-line-indent: 0pt,
    )

    set block(spacing: 1.1em)

    it
  }

  // ============================================================
  // Body
  // ============================================================

  if cols == 1 {
    body
  } else {
    columns(
      cols,
      gutter: 6mm,
      body,
    )
  }
}
