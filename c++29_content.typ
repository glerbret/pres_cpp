#import "./model.typ": *

= C++29

== Présentation

=== Présentation

- Adoption du planing en mars 2026
- Travaux en cours sur
  - la sécurité (profils, amélioration de la bibliothèque standard)
  - _Pattern matching_
  - Réseau
  - la bibliothèque de quantité et d'unité

#addproposal("p5000")
#addproposal("p4025")
#addproposal("P4029")

== Types

=== Types

- Support obligatoire de ```cpp intptr_t``` et ```cpp uintptr_t```

#addproposal("p3248")

== Contrats

=== Contrats

- Contrats sur les fonctions virtuelles

#alertblock(text[Héritage], "Pas d'héritage des contrats sur les fonctions virtuelles")

#addproposal("P3097")

== Opérateurs

=== Opérateurs

- Génération ```cpp =default``` des ```cpp operator++``` et ```cpp operator--``` suffixés
  - À partir des versions préfixés
  - Utilisation de l'implémentation canonique

  ```cpp
  Foo tmp = Foo(foo);
  ++foo;
  return tmp;
  ```

#addproposal("P3668")

== Classes

=== agrégats

- _Designated-initializers_ des classes de base

  ```cpp
  struct A { int a; };
  struct B : A { int b; };

  B{{1}, 2}         // Valide en C++17
  B{1, 2}           // Valide en C++17

  B{.a=1, .b=2}     // Invalide avant C++29
  B{{.a=1}, .b=2}   // Invalide avant C++29
  B{.a{1}, .b{2}}   // Invalide avant C++29
  B{.b=2, .a=1}     // Toujours mal-formé
  ```

#addproposal("P2287")

== Conteneurs

=== Conteneurs associatifs

- Ajout de ```cpp get()``` à ```cpp std::map``` et ```cpp std::unordered_map``` : récupération de la valeur associée à une clé
  - Retourne un ```cpp std::optional```
  - Alternative à ```cpp operator[]``` et ```cpp find()``` plus générique et plus simple

#addproposal("P3091")
