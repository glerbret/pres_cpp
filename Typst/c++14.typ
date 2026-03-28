#import "./model.typ": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/cetz:0.4.2"

#show: slides.with(
  title: "C++",
  date: datetime.today().display("[day]/[month]/[year]"),
  authors: "Grégory Lerbret",
  footer: true,
  toc: true,
)

#include "c++14_content.typ"
