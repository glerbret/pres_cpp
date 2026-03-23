#import "@preview/fontawesome:0.6.0": *

// Couleur principale
#let main_color = rgb("#007F7F")

// Définition de blocs d'affichage (note, avertissement et consieil)
#let _block(title, content, color) = {
  set block(width: 100%, inset: (x: 0pt, y: 3pt))

  show list: set list(
    marker: (
      text(1.5em, baseline: -0.1em, fill: color)[•],
      text(1.5em, baseline: -0.1em, fill: color)[‣],
      text(1.5em, baseline: -0.1em, fill: color)[-],
    ),
    spacing: 0.65em,
  )

  if (title != none) {
    stack(
      block(fill: color, stroke: color, outset: (x: 1.2em), radius: (top: 0.4em, bottom: 0cm), text(white)[#strong(
        title,
      )]),
      block(fill: color.lighten(80%), stroke: color, outset: (x: 1.2em), radius: (top: 0cm, bottom: 0.4em), content),
    )
  } else {
    block(fill: color.lighten(80%), stroke: color, outset: (x: 1.2em), radius: (top: 0.4em, bottom: 0.4em), content)
  }
}

#let noteblock(title, content) = {
  _block(title, content, main_color)
}

#let alertblock(title, content) = {
  _block(title, content, rgb("#BF0000"))
}

#let adviceblock(title, content) = {
  _block(title, content, rgb("#009900"))
}

// Logo "lien"
#let linklogo() = {
  super[#text(main_color, size: 0.5em)[#fa-external-link()]]
}

// Exemple de code en ligne
#let codecounter = counter("code_counter")
#let codesample(codelink) = {
  context place(
    bottom + right,
    dx: 1.5em - 1.4em * codecounter.get().first(),
    link(codelink)[#text(main_color)[#fa-icon("circle-play", solid: true)]],
  )
  context codecounter.step()
}

// Proposition de norme
#let proposalcounter = counter("proposal_counter")
#let addproposal(ref, url: none) = {
  if (url == none) {
    url = "https://wg21.link/" + ref
  }

  context place(
    bottom + left,
    dx: -1.3em + 4.5em * proposalcounter.get().first(),
    link(url)[
      #box(fill: white, stroke: main_color, radius: 1em, inset: (
        left: 0.3em,
        right: -0.1em,
        top: -0.25em,
        bottom: 0.18em,
      ))[#text(main_color, weight: "bold", top-edge: "baseline", bottom-edge: "baseline", size: 0.9em)[#ref] #text(
          main_color,
          size: 1em,
          baseline: 0.1em,
        )[#fa-icon("circle-play", solid: true)]]],
  )
  context proposalcounter.step()
}

#let slides(
  content,
  title: none,
  date: none,
  authors: (),
  ratio: 4 / 3,
  title-color: none,
  bg-color: white,
  footer: true,
  toc: true,
) = {
  set text(lang: "fr")
  set par(spacing: 0.8em)

  let height = 10.5cm
  let space = 1.6cm
  let width = ratio * height
  let title-color = main_color
  let bg-color = white

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
              inset: (right: -0.4 * space),
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
            outset: (right: 0.5 * space, bottom: 0cm),
            inset: (right: -0.5 * space),
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
            outset: (right: 0.5 * space, left: -0.5 * space, bottom: 0cm),
            height: 0.3 * space,
            fill: title-color,
            inset: (right: -0.4 * space),
          )[
            #set align(right + horizon)
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

  show heading.where(level: 2): it => {
    codecounter.update(0)
    proposalcounter.update(0)
    pagebreak(weak: true)
  }

  show heading: set text(1.1em, fill: title-color)

  // ADDITIONAL STYLING --------------------------------------------------
  // Code
  show raw.where(block: true): it => {
    block(
      radius: 0.4em,
      fill: white,
      stroke: title-color,
      width: 100%,
      inset: (x: 0pt, y: 5pt),
      outset: (x: 1.2em),
      it,
    )
  }

  // Bullet List
  show list: set list(
    marker: (
      text(1.5em, baseline: -0.1em, fill: title-color)[•],
      text(1.5em, baseline: -0.1em, fill: title-color)[‣],
      text(1.5em, baseline: -0.1em, fill: title-color)[-],
    ),
    spacing: 0.65em,
  )

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
        fill: title-color.lighten(50%),
        outset: (x: 0.0em, y: 0.2em),
        radius: 0.8em,
        height: 0.8em,
        inset: (x: 0.5em),
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
    block(height: 5%)
    align(center)[#block(
      inset: (x: 0.5 * space, y: 1em),
      radius: 10pt,
      fill: title-color,
      width: 95%,
      height: 15%,
      align(center + horizon)[#text(2.0em, weight: "bold", fill: bg-color, title)],
    )]
    block(height: 5%)
    block(
      width: 100%,
      height: 60%,
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
