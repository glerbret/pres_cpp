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

== Dépréciations & suppressions

=== Dépréciations

- ```cpp signed char``` et ```cpp unsigned char``` dans ```cpp iostream```

#addproposal("p3154")

== Types

=== Types

- Support obligatoire de ```cpp intptr_t``` et ```cpp uintptr_t```

#addproposal("p3248")

== Contrats

=== Contrats

- Contrats sur les fonctions virtuelles

#alertblock(text[Héritage])[Pas d'héritage des contrats sur les fonctions virtuelles]

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

== Templates

=== Templates

- _Pack Indexing_ sur les templates

#addproposal("P3670")

== Conteneurs

=== Conteneurs associatifs

- Ajout de ```cpp lookup()``` à ```cpp std::map``` et ```cpp std::unordered_map```
  - Récupère de la valeur associée à une clé
  - Retourne un ```cpp std::optional```
  - Alternative à ```cpp operator[]``` et ```cpp find()``` plus générique et plus simple

#addproposal("P3091")

=== ``` std::span```

- ```cpp std::copy()``` et ```cpp std::fill()``` sur les ```cpp std::mdspan```

#addproposal("p3242")

== Algorithmes

=== Manipulation de bits

- ```cpp std::bit_reverse()``` renverse les bits d'un entier non-signé

  ```cpp
  bit_reverse(uint32_t{0x00001234});  // 0x24c80000
  ```

- ```cpp std::bit_repeat()``` répète un pattern pour remplir un entier non-signé

  ```cpp
  bit_repeat(uint32_t{0xc}, 4);       // 0xcccccccc
  ```

- ```cpp std::bit_compress()``` ne conserve que les bits présents dans le masque

  ```cpp
  uint32_t x =          /* ... */;    // a b c d
  bit_compress(x, uint32_t{0b0101});  // 0 0 b d
  ```

- ```cpp std::bit_expand()``` expand en ajoutant les 0 du masque

  ```cpp
  uint32_t x =          /* ... */;    // 0 0 b d
  bit_compress(x, uint32_t{0b0101});  // 0 b 0 d
  ```

#addproposal("P3104")

=== Manipulation de bits

- ```cpp std::shl()``` et ```cpp std::shr()``` : décalage de bits

#addproposal("P3793")

== Flux

=== ``` std::format```

- Ajout d'un formatter pour ```cpp std::error_code```
- Correction du formatage des flottants

  ```cpp
  std::format("{}", 120000.0);  // 120000
  std::format("{}", 100000.0);  // C++26: 1e+05, C++29: 100000
  ```

#addproposal("p3395")
#addproposal("p3505")

== Concurrence

=== thread

- Ajout d'un nom aux threads
- Contrôle de la taille de pile des threads

#addproposal("p2019")

== Compilation et implémentation

=== Compilation et implémentation

- Ajout d'un offset à ```cpp #embed```

#addproposal("p3540")
