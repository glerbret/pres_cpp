#let layouts = (
  "small": ("height": 9cm, "space": 1.4cm),
  "medium": ("height": 10.5cm, "space": 1.6cm),
  "large": ("height": 12cm, "space": 1.8cm),
)
#let numberingH(c) = {
  return numbering(c.numbering, ..counter(heading).at(c.location()))
}

#let currentH(level: 1) = {
  let elems = query(selector(heading.where(level: level)).after(here()))

  if elems.len() != 0 and elems.first().location().page() == here().page() {
    return [#numberingH(elems.first())]
  } else {
    elems = query(selector(heading.where(level: level)).before(here()))
    if elems.len() != 0 {
      return [#numberingH(elems.last())]
    }
  }
  return ""
}
#let slides(
  content,
  title: none,
  date: none,
  authors: (),
  layout: "medium",
  ratio: 4 / 3,
  title-color: none,
  bg-color: white,
  footer: true,
  toc: true,
) = {
  set text(lang: "fr")

  // Parsing
  if layout not in layouts {
    panic("Unknown layout " + layout)
  }
  let (height, space) = layouts.at(layout)
  let width = ratio * height

  // Colors
  if title-color == none {
    title-color = blue.darken(50%)
  }
  let block-color = title-color.lighten(90%)
  let body-color = title-color.lighten(80%)
  let header-color = title-color.lighten(65%)
  let fill-color = title-color.lighten(50%)

  // Setup
  set document(
    title: title,
    author: authors,
  )
  set heading(numbering: "1.a")

  // PAGE----------------------------------------------
  set page(
    fill: bg-color,
    width: width,
    height: height,
    margin: (x: 0.5 * space, top: space, bottom: 0.6 * space),
    // HEADER
    header: [
      #context {
        let page = here().page()
        let sections = query(selector(heading.where(level: 1)))
        let section = sections.rev().find(x => x.location().page() <= page)
        let headings = query(selector(heading.where(level: 2)))
        let heading = headings.rev().find(x => x.location().page() <= page)

        if heading != none {
          set align(top)

          if section != none {
            block(
              width: 100%,
              fill: title-color.darken(50%),
              stroke: title-color.darken(50%),
              height: space * 0.30,
              outset: (x: 0.5 * space),
              spacing: 0pt,
            )[
              #set text(0.8em, fill: bg-color)
              #align(right + horizon)[#section.body]

            ]
          } else {
            block(
              width: 100%,
              fill: title-color,
              stroke: title-color,
              height: space * 0.30,
              outset: (x: 0.5 * space),
              spacing: 0pt,
            )[ ]
          }
          block(
            width: 100%,
            fill: title-color,
            stroke: title-color,
            height: space * 0.50,
            outset: (x: 0.5 * space),
            spacing: 0pt,
          )[
            #set text(1.4em, weight: "bold", fill: bg-color)
            #align(horizon)[#heading.body]
          ]
        }
      }
    ],
    header-ascent: 0%,
    // FOOTER ----------------------------------------------------
    footer: [
      #if footer == true {
        set align(right + horizon)
        set text(0.7em, fill: bg-color)
        columns(3, gutter: 0cm)[
          // Left side of the Footer
          #block(
            width: 100%,
            outset: (left: 0.5 * space, bottom: 0cm),
            height: 0.3 * space,
            fill: title-color.darken(50%),
            inset: (right: 0.5 * space),
          )[
            #set align(center + horizon)
            #smallcaps()[#title]
          ]
          // Center of the Footer
          #block(
            width: 100%,
            height: 0.3 * space,
            fill: title-color.darken(25%),
          )[
            #set align(center + horizon)
            #if authors != none {
              if (type(authors) != array) { authors = (authors,) }
              authors.join(", ", last: " and ")
            } else [#date]
          ]
          // Right Side of the Footer
          #block(
            width: 100%,
            outset: (right: 0.5 * space, bottom: 0cm),
            height: 0.3 * space,
            fill: title-color,
            inset: (right: -0.4 * space),
          )[
            #context {
              let last = counter(page).final().first()
              let current = here().page()
              [#current / #last]
            }
          ]
        ]
      }
    ],
    footer-descent: 0.3 * space,
  )

  // SLIDES STYLING --------------------------------------------------
  // Section Slides
  show heading.where(level: 1): x => {
    set page(header: none, footer: none, margin: 0cm)
    set align(horizon)
    grid(
      columns: (1fr, 3fr),
      inset: 10pt,
      align: (center, left),
      fill: (title-color, bg-color),
      [#block(height: 100%, text(3em, fill: bg-color)[#context [#let selector = selector(heading).before(here())
        #let level = counter(selector)
        #level.display()
      ]])],
      [#block(height: 100%, text(1.2em, weight: "bold", fill: title-color)[#x.body])],
    )
  }

  show heading.where(level: 2): pagebreak(weak: true) // this is where the magic happens
  show heading: set text(1.1em, fill: title-color)


  // ADDITIONAL STYLING --------------------------------------------------
  // Terms
  show terms.item: it => {
    set block(width: 100%, inset: 5pt)
    stack(
      block(fill: header-color, radius: (top: 0.2em, bottom: 0cm), strong(it.term)),
      block(fill: block-color, radius: (top: 0cm, bottom: 0.2em), it.description),
    )
  }


  // Code
  show raw.where(block: false): it => {
    box(fill: block-color, inset: 1pt, radius: 1pt, baseline: 1pt)[#text(it)]
  }

  show raw.where(block: true): it => {
    block(radius: 0.5em, fill: block-color, width: 100%, inset: 1em, it)
  }

  // Bullet List
  show list: set list(marker: (
    text(fill: title-color)[•],
    text(fill: title-color)[‣],
    text(fill: title-color)[-],
  ))

  // Enum
  let color_number(nrs) = text(fill: title-color)[*#nrs.*]
  set enum(numbering: color_number)

  // Table
  show table: set table(
    stroke: (x, y) => (
      x: none,
      bottom: 0.8pt + black,
      top: if y == 0 { 0.8pt + black } else if y == 1 { 0.4pt + black } else { 0pt },
    ),
  )

  show table.cell.where(y: 0): set text(
    style: "normal",
    weight: "bold",
  ) // for first / header row

  set table.hline(stroke: 0.4pt + black)
  set table.vline(stroke: 0.4pt)

  // Quote
  set quote(block: true)
  show quote.where(block: true): it => {
    v(-5pt)
    block(
      fill: block-color,
      inset: 5pt,
      radius: 1pt,
      stroke: (left: 3pt + fill-color),
      width: 100%,
      outset: (left: -5pt, right: -5pt, top: 5pt, bottom: 5pt),
    )[#it]
    v(-5pt)
  }

  // Link
  show link: it => {
    if type(it.dest) != str {
      // Local Links
      it
    } else {
      underline(stroke: 0.5pt + title-color)[#it] // Web Links
    }
  }

  // Outline
  set outline(
    title: "Sommaire",
    target: heading.where(level: 1),
    indent: auto,
  )
  show outline.entry: it => link(
    it.element.location(),
    it.indented(
      highlight(fill: title-color, radius: 1em, extent: 1em)[#text(bg-color, weight: "bold")[#it.prefix()]],
      text(title-color, weight: "bold")[#it.body()],
      gap: 2em,
    ),
  )
  show outline: set heading(level: 2) // To not make the TOC heading a section slide by itself
  show outline.entry.where(
    level: 1,
  ): set block(above: 1.5em)

  // Bibliography
  set bibliography(
    title: none,
  )

  // References
  show ref: it => {
    // Filter only for links, not for citations
    if it.element != none {
      let el = it.element
      set text(size: 0.7em, fill: white)
      box(
        fill: fill-color,
        outset: (x: 0.0em, y: 0.2em),
        radius: 0.8em,
        height: 0.8em,
        inset: (x: 0.5em),
        //stroke: (bottom: fill-color),
      )[
        // if no supplement is passed
        #if el.func() == heading and it.supplement == auto {
          link(el.location(), el.body)
        } else if el.func() == heading {
          // if a supplement is passed
          link(el.location(), it.supplement.text)
        } else {
          // everything else (equations, figures etc)
          it
        }
      ]
    } else {
      // these are the citations
      return it
    }
  }


  // CONTENT---------------------------------------------
  // Title Slide
  if (title == none) {
    panic("A title is required")
  } else {
    if (type(authors) != array) {
      authors = (authors,)
    }
    set page(footer: none, header: none, margin: 0cm)
    block(height: 2%)
    align(center)[#block(
      inset: (x: 0.5 * space, y: 1em),
      radius: 10pt,
      fill: title-color,
      width: 95%,
      height: 15%,
      align(center + horizon)[#text(2.0em, weight: "bold", fill: bg-color, title)],
    )]
    block(
      width: 100%,
      height: 70%,
      inset: (x: 0.5 * space, top: 0cm, bottom: 1em),
      align(center + top, authors.join(", ", last: " & "))
        + if date != none { text(1em)[ \ ] }
        + if date != none {
          text(1em, align(center, date))
          align(right + bottom, image("license.png", height: 10%))
        },
    )
  }

  // Outline
  align(horizon)[
    #if (toc == true) {
      outline()
    }]
  // The body of the slides
  content
}
