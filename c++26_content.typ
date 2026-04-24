#import "./model.typ": *

= C++26

== Présentation

=== Présentation

- Début formel des travaux en juin 2023
- Fin des travaux techniques en mars 2026
- Dernier _Working Draft_ : #link("https://wg21.link/std")[N5014 #linklogo()]

== Dépréciations et suppressions

=== Dépréciations

- Annulation de la dépréciation de ```cpp std::polymorphic_allocator::destroy```
- Dépréciation de ```cpp std::is_trivial``` et ```cpp std::is_trivial_v```
- Dépréciation de ```cpp memory_order::consume```
- Dépréciation de l'ellipse sans virgulant la précédant

#addproposal("p2875")
#addproposal("p3247")
#addproposal("p3475")
#addproposal("p3176")

=== Suppressions

- Suppression d'éléments précédemment dépréciés
  - Conversion arithmétique d'énumération
  - ```cpp strstream```
  - ```cpp std::allocator```
  - API d'accès atomique à ```cpp std::shared_ptr```
  - ```cpp wstring_convert```
  - Surcharge de ```cpp std::basic_string::reserve()``` sans argument
  - Unicode conversion facet (```cpp <codecvt>```)
  - Comparaison entre tableaux C
- Suppression ```cpp std::execution::split```

#addproposal("P2864")
#addproposal("P2867")
#addproposal("p2868")
#addproposal("P2869")
#addproposal("P2870")
#addproposal("P2871")
#addproposal("P2872")
#addproposal("p2865")
#addproposal("p3682")

== Comportement

=== _Erroneous Behavior_

- Nouveau type de comportement : _Erroneous Behavior_
- Code incorrect, mais bien défini
- Recommandation à l'implémentation de fournir un diagnostic (warning à la compilation, erreur au _run-time_, ...)
- Applicable aux lectures de variables non initialisées
  - Doit retourner une valeur "erronée"

  // Valeur propre à l'implémentation, indiquant la non-initialisation
  // En particulier pas la valeur précédente de la zone mémoire, ni 0

  - ... et non la valeur d'une autre variable récemment libérée

#addproposal("P2795")

=== _Undefined_ / _unspecified_ / _ill-formed_

- La libération d'un pointeur sur un type incomplet devient _ill-formed_

// Auparavant, undefined behavior

- ```cpp std::observable_checkpoint()``` empêche la propagation de supposition basé sur de potentiels comportements indéfinis

```cpp
if (!p) cerr << "foo\n"; // Pas de suppression possible
observable_checkpoint();
if (!p) cerr << "bar\n"; // Suppression possible
*p += r;                 // p supposé non-nul
```

- Tous les _undefined behavior_ du préprocesseur ou du lexer deviennent _ill-formed_ sans diagnostic requis

#noteblock("À suivre", text[
  Exiger un diagnostic

  Rendre ces comportements _well-formed_
])

#addproposal("p3144")
#addproposal("p1494")
#addproposal("p3641")
#addproposal("p2843")

=== _Undefined_ / _unspecified_ / _ill-formed_

#questionblock(text[ _Undefined_, _unspecified_, _ill-formed_ ?], text[
  - _ill-formed_ : erreurs syntaxiques ou sémantiques
  - _implementation-defined_ : comportement défini par l'implémentation qui doit le documenter
  - _unspecified behavior_ : comportment défini par l'implémentation qui n'a pas l'obligation de le documenter
  - _undefined behavior_ : aucune restriction sur le comportement
])

=== Boucles infinies

- Les boucles infinies triviales ne sont plus des _Undefined Behavior_
- Alignement avec le comportement du C

```cpp
// Comportement indéfini en C++23 et avant
while (true)
{}
```

#addproposal("P2809")

== Syntaxe

=== _Lexer_

- Suppression de comportements indéfinis
  - _Universal characters_ sur plusieurs lignes sont autorisés

```cpp
int \\
u\
0\
3\
9\
1 = 0;
```

#list(marker: [], list(indent: 5pt, text[Construction possible d'_universal characters_ par des macros]))

```cpp
#define CONCAT(x, y) x ## y
int CONCAT(\, u0393) = 0;
```
#list(marker: [], list(indent: 5pt, text[Une chaîne non terminée est une erreur]))

#addproposal("P2621")

=== Encodage

- Ajout de ```cpp @```, ```cpp $``` et ```cpp ` ``` au jeu de caractères de base
// Ajoutés en C (C23)}
// Supportés par tous les encodages communément utilisés
- Caractères non-encodables sont mal formés
- Identification de l'encodage
  - ```cpp std::text_encoding::literal()``` : encodage du code
  - ```cpp std::text_encoding::environment()``` : encodage de l'environnement

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:3,positionColumn:1,positionLineNumber:3,selectionStartColumn:1,selectionStartLineNumber:3,startColumn:1,startLineNumber:3),source:'%23include+%3Ctext_encoding%3E%0A%23include+%3Ciostream%3E%0A%0Aint+main()+%0A%7B%0A++++std::cout+%3C%3C+std::text_encoding::literal().name()+%3C%3C+%22%5Cn%22%3B%0A++++std::cout+%3C%3C+std::text_encoding::environment().name()+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-Wall+-Wextra+-pedantic+-fcontracts+-std%3Dc%2B%2B26',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    text_encoding::literal().name();
    text_encoding::environment().name();
    ```
  ],
)

#addproposal("P2558")
#addproposal("P1854")
#addproposal("p1885")
#addproposal("p2862")

== Compatibilité C

=== En-têtes C23

- Support des en-têtes C23 ```cpp <stdbit.h>``` et ```cpp <stdckdint.h>```

#addproposal("p3370")

== Statique

=== ``` static_assert```

- Support de messages construits par ```cpp static_assert```

```cpp
static_assert(sizeof(Foo) == 1,
              format("Attendu 1, obtenu {}", sizeof(Foo)));
```

#alertblock(text[_Compile-time_], "Uniquement des valeurs connues à la compilation")

#alertblock("Dépendance", text[
  Nécessite que ```cpp std::format``` devienne ```cpp constexpr```
])

#addproposal("P2741")

== Types

=== _Saturation arithmetic_

- Fonctions ```cpp std::saturating_add()```, ```cpp std::saturating_sub()```, ```cpp std::saturating_mul()```, ```cpp std::saturating_div()``` et ```cpp std::saturating_cast()```
- Les calculs dont le résultat est hors borne retournent les plus grandes ou plus petites valeurs représentables

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cnumeric%3E%0A%23include+%3Cclimits%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::add_sat(3,+4)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+INT_MIN+%3C%3C+%22+%22+%3C%3Cstd::sub_sat(INT_MIN,+1)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+static_cast%3Cint%3E(std::add_sat%3Cunsigned+char%3E(255,+4))+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B26+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    add_sat(3, 4);                  // 7
    sub_sat(INT_MIN, 1);            // INT_MIN
    add_sat<unsigned char>(255, 4); // 255
    ```
  ],
)

#addproposal("P0543")
#addproposal("p4052")

=== _Replaceability_

- Nouvelle catégorie _replaceable type_ : destruction puis construction depuis une autre instance est équivalent à assigner depuis une autre instance
- Objet implicitement _replaceable_ si il n'est pas ```cpp const``` ni ```cpp volatile``` et si toutes ces classes de bases et membres non-statiques sont _replaceable_
// std::vector<> suppose déjà que les objets qu'il manipule sont replaceable, contrairement à std::swap()
- ```cpp replaceable_if_eligible``` sur les classes pour les marquer _replaceable_
- _Trait_ ```cpp std::is_replaceable```

#addproposal("P2786")

=== ``` std::indirect<T>``` - ``` std::polymorphic<T>```

- ```cpp std::indirect<T>``` encapsule des objets de type ```cpp T```
- ```cpp std::polymorphic<T>``` encapsule des objets héritant de ```cpp T```
- _Wrappers_ à sémantique de valeur d'objets alloués dynamiquement
  - Copie profonde
  - Propagation de ```cpp const```

#addproposal("P3019")

=== _Constant wrapper_

- ```cpp std::cw()``` et ```cpp std::constant_wrapper()``` permet d'utiliser une valeur au _compile-time_

#addproposal("p2781")
#addproposal("P3948")

== Variables

=== _Placeholders_

- Joker ```cpp _``` pour des variables inutilisées

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cnumeric%3E%0A%23include+%3Cclimits%3E%0A%0Aint+foo()%0A%7B%0A++return+42%3B%0A%7D%0A%0Aint+main()%0A%7B%0A%23if+1%0A++auto+bar+%3D+foo()%3B%0A%23else%0A++auto+_+%3D+foo()%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B26+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    auto _ = foo();
    ```
  ],
)

```cpp
std::lock_guard _(mutex);
```

```cpp
auto  [x, y, _] = f();
```

- ```cpp std::ignore``` pour ignorer un retour de fonction

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:18,positionColumn:1,positionLineNumber:18,selectionStartColumn:1,selectionStartLineNumber:18,startColumn:1,startLineNumber:18),source:'%23include+%3Ciostream%3E%0A%23include+%3Cnumeric%3E%0A%23include+%3Cclimits%3E%0A%0A%5B%5Bnodiscard%5D%5Dint+foo()%0A%7B%0A++return+42%3B%0A%7D%0A%0Aint+main()%0A%7B%0A%23if+1%0A++foo()%3B%0A%23else%0A++std::ignore+%3D+foo()%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B26+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    std::ignore = f();
    ```
  ],
)

#addproposal("P2169")
#addproposal("p2968")

== _Structured binding_

=== _Structured binding_

- Utilisable comme condition dans les ```cpp if```, ```cpp while```, ```cpp for``` et ```cpp switch```

#codesample(
  "https://godbolt.org/#z:OYLghAFBqd5QCxAYwPYBMCmBRdBLAF1QCcAaPECAMzwBtMA7AQwFtMQByARg9KtQYEAysib0QXACx8BBAKoBnTAAUAHpwAMvAFYTStJg1DIApACYAQuYukl9ZATwDKjdAGFUtAK4sGIMwAcpK4AMngMmAByPgBGmMQSAGykAA6oCoRODB7evv5BaRmOAmER0SxxCVzJdpgOWUIETMQEOT5%2BgbaY9sUMjc0EpVGx8Um2TS1teZ0KE4PhwxWj1QCUtqhexMjsHOYAzOHI3lgA1CZ7bk6zxJis59gmGgCCj0/XXg4nAGKoqGfPJgA7FZnicTuECCcmOcQU8wRCTjEYa9XmDMKoUrQ8MhCCdUCl4kwiMREb9aCcICsTmgGLNUWdgf84WCTjcCJsGFCTmAwOcACKI5Gghl8lGA0V7WGvBEsJjhSli2HwqgQJheIhnACsFiYpEFmoF/O%2BvyBFjMes1QL5K3ppvpYNm6BAKA2kPObndXPdnvMZm5vL2hrMfu9F0RZwuPuDJk1bgYvqFzKt9O6SltwPtJ0dzrQ6ojHrDTHzUZDgaNvuLYZilbcZ2jsfj0cl6dFAOFeBVao1MZ1eqRBojAp%2BqFN5pOZitNuFduFDoITpdedDtaLy7rfp55eDNfDa4TDYTzen4pTtDTx6VLOzi7dkcLO4r/K3pYLtere/rccPl%2BTbZe4o4NZaE4TVeD8DgtFIVBOA9SxrCzDYtkwOs9h4UgCE0QC1gAaxATUNH0ThJDAzCoM4XgFBAAiMIgwDSDgWAkHROp1RIchKGaYAFGUQxuiEBBUAAd3AtC0BYFI6CJLIeIiWh%2BKE8DILEiT6ASLjmBSBQBIIUhlLoeJIlYHZeD01SAHl1Xk4TSOY5AnmILjyOCVQ6kafBwN4fhBBEMR2CkGRBEUFR1Fo0hdC4fRDGMaxrH0PAYkoyA1nxXpKI4ABaR1%2BVMODLDMZATnSgB1MRyWK9ECGIIt0oJdBDEcZBeFQAA3eJiDwLBEspUhiC8QQ8DYAAVMkurWBREO2PRHXCGS%2BIE6zuF4SrMB2NDBKqlJMKAkCSNC6COGwFzkFYklVACRJ0sSSQTmAZACogSq%2BuwqkIFgqxLD1XBCBIFCuBWJatrWBBbiwBJutw/DCI4YjSEUpqnMo6jAahsxdsg/aAdolY1la4gMmcSQgA",
  code: [
    ```cpp
    struct Foo {
      int a, b;
      operator bool () const { return a != b; }};

      if(auto [a, b] = Foo{...})
      // Équivalent a
      if(auto [a, b] = Foo{...}; a != b)
    ```
  ],
)

#addproposal("p0963")

=== _Structured binding_

- Utilisation de _parameters pack_ dans les _structures bindings_

```cpp
tuple<X, Y, Z> f();

auto [...xs] = f();
auto [x, ...rest] = f();
auto [x,y,z, ...rest] = f();
auto [x, ...rest, z] = f();
auto [...a, ...b] = f();  // ill-formed
```

#addproposal("p1061")

== Classes

=== ``` =delete```

- Ajout d'un message à ```cpp =delete```
- Permet d'indiquer la raison de la suppression
- Et d'obtenir de meilleures erreurs de compilation

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:40,endLineNumber:3,positionColumn:40,positionLineNumber:3,selectionStartColumn:1,selectionStartLineNumber:3,startColumn:1,startLineNumber:3),source:'%23include+%3Ciostream%3E%0A%0Avoid+foo()+%3D+delete(%22Unsafe,+use+bar%22)%3B%0A%0Aint+main()%0A%7B%0A+++foo()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B26+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    void foo() =delete("Unsafe, use bar");

    // use of deleted function 'void foo()': Unsafe, use bar
    foo();
    ```
  ],
)

#addproposal("P2573")

=== _Variadic friends_

- Possibilité de déclaré ```cpp friend``` un _parameter pack_

```cpp
template <typename... Ts>
class Bar {
  friend Ts...;  // Invalide en C++23
  ...
};
```

#addproposal("P2893")

== Templates

=== Templates

- Utilisation de concepts ou de variable template comme paramètres template

```cpp
template<template <typename T> concept C,
         template <typename T> auto V>
struct S{};

template <typename T> concept Concept = true;
template <typename T> constexpr auto Var = 42;

S<Concept, Var> s;
```

#addproposal("P2841")

== Gestion d'erreurs

=== Gestion d'erreurs

- Récupération des informations contenues dans un ```cpp std::exception_ptr```
  - ```cpp exception_ptr_cast``` converti un ```cpp std::exception_ptr``` en un pointeur sur une exception

#addproposal("P2927")

== Conteneurs

=== Conteneurs

- Vecteur de capacité fixée en _compile-time_ ```cpp std::inplace_vector```
// Contrairement à std::array la taille n'est pas fixée, seule la capacité l'est, et donc utilisable pour des éléments "sans valeur par défaut"
  - 3 jeux d'API d'insertion pour gérer l'absence de place
    - API standard : lancement d'exception
    - API ```cpp try_``` : retour d'un booléen
    - API ```cpp unchecked_``` : pas de vérification

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:16,positionColumn:1,positionLineNumber:16,selectionStartColumn:1,selectionStartLineNumber:16,startColumn:1,startLineNumber:16),source:'%23include+%3Ciostream%3E%0A%23include+%3Cinplace_vector%3E%0A%0Aint+main()%0A%7B%0A++++std::inplace_vector%3Cint,+4%3E+foo%7B0,+1,+2%7D%3B%0A%0A++++std::cout+%3C%3C+foo.size()+%3C%3C+%22+%22+%3C%3C+foo.capacity()+%3C%3C+%22+%22+%3C%3C+foo.max_size()+%3C%3C+%22%5Cn%22%3B%0A++++foo.push_back(5)%3B%0A++++std::cout+%3C%3C+foo.size()+%3C%3C+%22+%22+%3C%3C+foo.capacity()+%3C%3C+%22+%22+%3C%3C+foo.max_size()+%3C%3C+%22%5Cn%22%3B%0A%0A%23if+0%0A++++foo.push_back(5)%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-Wall+-Wextra+-pedantic+-fcontracts+-std%3Dc%2B%2B26',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    inplace_vector<int, 4> foo{0, 1, 2};  // size = 3, capacity = 4
    foo.push_back(5);                     // size = 4, capacity = 4
    foo.push_back(5);                     // Exception
    ```
  ],
)

- _Bucket array_ ```cpp std::hive``` : plusieurs blocs d'éléments liés entre eux avec un indicateur sur l'état de chaque élément (actif / effacé)

- Possibilité d'utiliser ```cpp std::weak_ptr``` en tant que clé de conteneur associatif

#addproposal("p0843")
#addproposal("P0447")
#addproposal("P1901")

=== ``` std::span```

- Ajout de ```cpp at()``` à ```cpp std::span``` et  ```cpp std::mdspan```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:35,endLineNumber:10,positionColumn:35,positionLineNumber:10,selectionStartColumn:35,selectionStartLineNumber:10,startColumn:35,startLineNumber:10),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cspan%3E%0A%0Aint+main()%0A%7B%0A+++std::vector%3Cint%3E+foo%7B1,+5,+42,+68,+33%7D%3B%0A+++std::span+bar%7Bstd::begin(foo)+%2B+1,+std::end(foo)%7D%3B%0A%0A+++std::cout+%3C%3C+bar.at(1)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B26+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo{1, 5, 42, 68, 33};
    span bar{begin(foo) + 1, end(foo)};

    bar.at(1);    // 42
    ```
  ],
)

- ```cpp std::submdspan()``` : vue sur un sous-ensemble d'un ```cpp std::mdspan```
- Layouts pour ```cpp std::mdspan``` : ```cpp layout_left_padded``` et ```cpp layout_right_padded```
- Ajout de ```cpp dextents``` à ```cpp std::mdspan```

```cpp
mdspan<float, extents<dynamic_extent, dynamic_extent,
dynamic_extent>> foo;
// Devient
mdspan<float, dextents<3>> foo;
```

#addproposal("P2821")
#addproposal("p3383")
#addproposal("p3355")
#addproposal("P2642")
#addproposal("p2389")
#addproposal("P2630")
#addproposal("p3982")

=== Chaînes de caractères

- Support de ```cpp std::string_view``` par ```cpp std::stringstream```
- Interfaçage de ```cpp std::bitset``` avec ```cpp std::string_view```

```cpp
bitset b1{""sv};            // Valide en C++26, invalide avant
```

- Concaténation de ```cpp std::string``` et ```cpp std::string_view```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:11,endLineNumber:9,positionColumn:11,positionLineNumber:9,selectionStartColumn:11,selectionStartLineNumber:9,startColumn:11,startLineNumber:9),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%23include+%3Cstring_view%3E%0A%0Aint+main()%0A%7B%0A++++const+std::string+foo%7B%22Hello%22%7D%3B%0A++++const+std::string+bar%7B%22Salut+world!!%22%7D%3B%0A++++const+std::string_view+baz%7Bstd::begin(bar)+%2B+5,+std::end(bar)%7D%3B%0A%0A++++std::cout+%3C%3C+foo+%2B+baz+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B26+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    string foo{"Hello"};
    string bar{"Salut world!"};
    string_view baz{begin(bar) + 5, end(bar)};

    cout << foo + baz << "\n";  // Hello world!
    ```
  ],
)

#addproposal("P2495")
#addproposal("P2697")
#addproposal("P2591")

=== _Initializer-list_

- _static storage_ possible pour les _braced-initializer-list_
// Évite de copier les données depuis le static storage vers le tableau sous-jacent de l'initializer list puis vers le conteneur

#addproposal("P2752")

=== ```cpp reference_wrapper```

- Comparaison de ```cpp std::reference_wrapper```

#addproposal("P2944")

== _tuple-like_

=== ``` std::complex```

- ```cpp std::complex``` deviennent des _tuple-like_

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:45,endLineNumber:10,positionColumn:45,positionLineNumber:10,selectionStartColumn:45,selectionStartLineNumber:10,startColumn:45,startLineNumber:10),source:'%23include+%3Ciostream%3E%0A%23include+%3Ccomplex%3E%0A%0Aint+main()%0A%7B%0A++++const+std::complex%3Cint%3E+foo%7B1,+5%7D%3B%0A++++std::cout+%3C%3C+std::get%3C1%3E(foo)+%3C%3C+%22%5Cn%22%3B%0A%0A++++const+auto+%5Ba,+b%5D+%3D+foo%3B%0A++++std::cout+%3C%3C+%22(%22+%3C%3C+a+%3C%3C+%22,+%22+%3C%3C+b+%3C%3C+%22)%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B26+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    complex<int> foo{1, 5};

    get<1>(foo);        // 5
    auto [a, b] = foo;  // 1 5
    ```
  ],
)

#addproposal("p2819")

== ``` std::optional```

=== ``` std::optional```

- Support des références par ```cpp std::optional```

#alertblock("Affectation", text[
  L'affectation modifie la référence pas la valeur référencée

  #codesample(
    "https://godbolt.org/#z:OYLghAFBqd5QCxAYwPYBMCmBRdBLAF1QCcAaPECAMzwBtMA7AQwFtMQByARg9KtQYEAysib0QXACx8BBAKoBnTAAUAHpwAMvAFYTStJg1DIApACYAQuYukl9ZATwDKjdAGFUtAK4sGIAKwA7KSuADJ4DJgAcj4ARpjEIGZmpAAOqAqETgwe3r4BwemZjgLhkTEs8YnJtpj2JQxCBEzEBLk%2BfgDMtfXZTS0EZdFxCSAAbLbNre353QpTgxHDlaNjAJS2qF7EyOwc5p0RyN5YANQmnW5O88SYrBfYJhoAggdHJ5jnl6ipDWIPT1eLwiBFOLCYEQga0BJkCVhep1OINOsRaXwAIqdJGYLvDnojkaiAF4Y05cDS4wGI%2BboEAgH5/WgXK6CcxjB6nfioUmo4iUhGnGl0tBeUHM5mnABUXK%2Bbgl5jM52SsolvJVlyVioV6rcKKYJPFGoVJn8bgYxs6eKpnNQ3IumOJ/PxgoItJQWzFlwl0ttOs1/sNurVgYDypDxL9xtN5uSTphZkOVFOFIFMvtp38cYTrjwVBhqdtADoAG5iLyYKE8lpO6mu4Uev0%2Bu1eo1hsMtoNokPansdvUGvtRs0Wq0CpukzOW61C92ixtpwdtrV94OLrXtuUaiPd2PRkcwwLowEcDa0Tj%2BXh%2BDhaUioThyyzWQVbHafA48UgETQnjYAawCGj6JwkiXt%2Bt6cLwCggIBX7XiepBwLASCYKomDIKKJDkJQLTAAoyiGHUQgIKgADuV4fmgLCpHQTANPhkS0ERpFXjelHUfQiS4cwqQKMRBCkGxdAJFErB7LwgkcQA8qKTFkWBKFoc8xC4RBISocgTT4FevD8IIIhiOwUgyIIigqOocGkLoXD6IYxjWNY%2Bh4LEUGQBsDLZFBHAALQ0vapiPpYZhjKcXkAOpiLQIWhShBDEEwIWpJg6CGI4yC8KgxYJMQeBYC5UKkMQXiCHgbAACq2rQeUbAoL67HoNIRPRhHEXJ3C8LFmB7B%2BJFxak36nueoEWXeHDYOpGHEKcqgABxjF5YySKcwDIMgpwQLFRW/msa0PlYlikKcuCECQSqdFwaztf1GwIHcWCJPl/7%2BIBZ4cCBpAselqlQTBV1ARwZhDTeI2XXBawbJlxCZM4khAA%3D%3D%3D",
    code: [
      ```cpp
        int bar = 42;
        int baz = 10;

        optional<int&> foo = bar; // foo => bar, bar = 42, baz = 10
        foo = baz;                // foo => baz, bar = 42, baz = 10
        foo.value() = bar;        // foo => baz, bar = 42, baz = 42
        *foo = 5;                 // foo => baz, bar = 42, baz = 5
        foo = 5;                  // Invalide
      ```
    ],
  )
])

- ```cpp std::optional<T&>``` trivialement copiable

#addproposal("p2988")
#addproposal("p3836")

== Algorithmes

=== Algèbre linéaire

- Basé sur un sous-ensemble de #link("https://www.netlib.org/blas/")[BLAS #linklogo()]
- Multiples opérations
  - Somme de vecteurs
  - Multiplication de vecteurs ou de matrices par un scalaire
  - Produit de vecteurs et de matrices
  - Triangularisation de matrices
  - Rotation de plans
- Plusieurs formats de stockage des matrices

```cpp
vector<double> x_vec{1., 2., 3., 4., 5.};
mdspan x(x_vec.data(), 5);

linalg::scale(2.0, x); // x = 2.0 * x
```

#addproposal("P1673")
#addproposal("p3050")
#addproposal("p3222")

=== Algorithmes

- Algorithmes appelables avec des _list-initialization_

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:62,endLineNumber:20,positionColumn:61,positionLineNumber:20,selectionStartColumn:62,selectionStartLineNumber:20,startColumn:61,startLineNumber:20),source:'%23include+%3Ciostream%3E%0A%23include+%3Calgorithm%3E%0A%23include+%3Cvector%3E%0A%0Astruct+Foo%0A%7B%0A++++int+x%3B%0A++++int+y%3B%0A%0A++++bool+operator%3D%3D(const+Foo%26+rhs)+const%0A++++%7B%0A++++++++return+x+%3D%3D+rhs.x+%26%26+y+%3D%3D+rhs.y%3B%0A++++%7D%0A%7D%3B%0A%0Aint+main()%0A%7B%0A%09const+std::vector%3CFoo%3E+foo%7B%7B1,+2%7D,+%7B3,+4%7D,+%7B3,+5%7D,+%7B7,+12%7D%7D%3B%0A%0A%09const+auto+it+%3D+std::find(std::begin(foo),+std::end(foo),+%7B3,+4%7D)%3B%0A++++std::cout+%3C%3C+std::boolalpha+%3C%3C+(it+!!%3D+std::end(foo))+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B26+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    struct Foo { int x; int y; };
    vector<Foo> v{ ... };

    find(begin(v), end(v), {3, 4}); // Foo{3, 4} en C++23
    ```
  ],
)

#addproposal("P2248")
#addproposal("P3787")

=== ``` std::visit()```

- Versions membres de ```cpp std::visit()``` et ```cpp std::visit_format_arg()```

#addproposal("P2637")

== Ranges

=== Ranges

- ```cpp std::views::concat()``` concatène plusieurs ranges

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:16,positionColumn:1,positionLineNumber:16,selectionStartColumn:1,selectionStartLineNumber:16,startColumn:1,startLineNumber:16),source:'%23include+%3Ciostream%3E%0A%23include+%3Cranges%3E%0A%23include+%3Cvector%3E%0A%23include+%3Carray%3E%0A%0Aint+main()%0A%7B%0A%09std::vector%3Cint%3E+v1%7B1,2,3%7D,+v2%7B4,5%7D,+v3%7B%7D%3B%0A%09std::array+a%7B6,7,8%7D%3B%0A%0A%09for(const+auto+i:+std::views::concat(v1,+v2,+v3,+a))%0A++++%7B%0A++++++++std::cout+%3C%3C+i+%3C%3C+%22+%22%3B%0A++++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B26+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> v1{1,2,3}, v2{4,5}, v3{};
    array a{6,7,8};

    // 1, 2, 3, 4, 5, 6, 7, 8
    views::concat(v1, v2, v3, a);
    ```
  ],
)

- API de génération de nombres aléatoires

```cpp
array<int, 10> a;
mt19937 g(777);

ranges::generate_random(a, g);
```

#addproposal("P2542")
#addproposal("P1068")

=== Ranges

- ```cpp std::views::cache_latest()``` met en cache le résultat du dernier déréférencement de l'itérateur sous-jacent
- ```cpp std::views::as_input()``` convertit un range en _input-only_ range
- ```cpp std::ranges::reserve_hint()``` permet de réserver la mémoire pour des _non-sized_ ranges dont la taille peut être approximer
- Concept ```cpp approximately_sized_range``` supporte ```cpp std::ranges::reserve_hint()```
- Construction d'une ```cpp sub-string_view``` depuis ```cpp std::string```
- ```cpp views::indices()``` : séquence d'entiers de 0 à $n - 1$

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:9,positionColumn:1,positionLineNumber:9,selectionStartColumn:1,selectionStartLineNumber:9,startColumn:1,startLineNumber:9),source:'%23include+%3Ciostream%3E%0A%23include+%3Cranges%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++++std::cout+%3C%3C+std::format(%22%7B%7D%22,+std::views::indices(5))%3B+//+%5B0,+1,+2,+3,+4%5D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B26+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    views::indices(5); // [0, 1, 2, 3, 4]
    ```
  ],
)

#addproposal("p3138")
#addproposal("p3137")
#addproposal("p3828")
#addproposal("p2846")
#addproposal("p3044")
#addproposal("p3060")

=== Ranges

- Traitement de ```cpp std::optional``` comme un range similaire à ```cpp single_view```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:19,positionColumn:1,positionLineNumber:19,selectionStartColumn:1,selectionStartLineNumber:19,startColumn:1,startLineNumber:19),source:'%23include+%3Ciostream%3E%0A%23include+%3Cranges%3E%0A%23include+%3Coptional%3E%0A%0Aint+main()%0A%7B%0A++++std::optional%3Cint%3E+empty%3B%0A++++for(int+i:+empty)%0A++++%7B%0A++++++++std::cout+%3C%3C+i%3B%0A++++%7D%0A%0A++++std::optional%3Cint%3E+not_empty+%3D+5%3B%0A++++for(int+i:+not_empty)%0A++++%7B%0A++++++++std::cout+%3C%3C+i%3B%0A++++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B26+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    optional<int> empty;
    for(int i: empty) { std::cout << i; } // Vide

    optional<int> not_empty = 5;
    for(int i: not_empty) { std::cout << i; } // Un element
    ```
  ],
)

- Ajout du choix de l'algorithme de parallélisme aux ranges


#addproposal("p3168")
#addproposal("p3179")

== Rapport

=== Rapport

- Ajout des préfixes _quecto_, _ronto_, _ronna_ et _quetta_

#addproposal("P2734")

== _Compile-time_

=== ``` constexpr```

- Davantage de ```cpp constexpr``` dans la bibliothèque standard
- Conversion depuis ```cpp void*``` dans des contextes ```cpp constexpr```
  - ```cpp std::format()``` au _compile-time_
  - ```cpp std::function_ref```, ```cpp std::function``` et ```cpp std::any``` ```cpp constexpr```
- Utilisation ```cpp constexpr``` de
  - _Structured bindings_
  - ```cpp atomic```
  - Placement ```cpp new```
  - Conteneurs et adaptateurs
  - Héritage virtuel
  - ```cpp std::shared_ptr```
  - Spécialisations ```cpp std::atomic``` des _smart pointers_

#addproposal("P2738")
#addproposal("P2686")
#addproposal("P3309")
#addproposal("p2747")
#addproposal("p3372")
#addproposal("p3533")
#addproposal("p3037")

=== Exceptions

- Possibilité de lancer des exceptions dans des fonctions ```cpp consteval```
  - Erreur de compilation si l'exception est lancée au _compile-time_

#addproposal("P3068")
#addproposal("P3378")

== _Parameters pack_

=== _Parameters pack_

- Indexation des _packs_

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:13,positionColumn:1,positionLineNumber:13,selectionStartColumn:1,selectionStartLineNumber:13,startColumn:1,startLineNumber:13),source:'%23include+%3Ciostream%3E%0A%0Atemplate+%3Ctypename...+T%3E%0Avoid+first_plus_last(T...+values)%0A%7B%0A++std::cout+%3C%3C+T...%5B0%5D(values...%5B0%5D+%2B+values...%5Bsizeof...(values)-1%5D)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++first_plus_last(1,+2,+10)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B26+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    template <typename... T>
    constexpr auto first_plus_last(T... values) -> T...[0] {
      return T...[0](values...[0] + values...[sizeof...(values)-1]);
    }

    first_plus_last(1, 2, 10);  // 11
    ```
  ],
)

#addproposal("P2662")

== Gestion mémoire

=== _lifetime_

- ```cpp std::is_within_lifetime()``` indique au _compile-time_ si l'objet pointé est vivant
- ... en particulier si un membre d'une union est active
- Surcharge testant, au _compile-time_, si l'objet est vivant et convertible vers un autre type

#addproposal("P2641")
#addproposal("p3450")

=== Gestion mémoire

- _hazard pointers_ : unique écrivain, multiples lecteurs
- Structure de donnée _read-copy update_
  - Une mise à jour entraîne une copie
  - Chaque thread utilise soit l'ancienne soit la nouvelle version
  - Donc une version cohérente

#addproposal("P2530")
#addproposal("P2545")

== SIMD

=== SIMD (_Single Instruction on Multiple Data_)

- Intégration de ```cpp simd```
- ```cpp simd<T>``` se comporte comme ```cpp T``` en manipulant plusieurs valeurs simultanément

```cpp
native_simd<int> a = 1;                           // 1 1 1 1
native_simd<int> b([](int i) { return i - 2; });  // -2 -1 0 1
auto c = a + b;                                   // -1 0 1 2
auto d = c * c;                                   // 1 0 1 4
auto e = reduce(d);                               // 6
```

#addproposal("p1928")
#addproposal("P3430")
#addproposal("P3441")
#addproposal("P3287")
#addproposal("P2663")
#addproposal("P2933")

== _Traits_

=== _Traits_

- ```cpp std::is_virtual_base_of``` indique si une classe est une base virtuelle d'une autre

#addproposal("p2985")

== Programmation fonctionnelle

=== Type appelable

- ```cpp std::copiable_function``` pour les fonctions copiables
- ```cpp std::function_ref```
  - Type référence pour le passage d'appelable à une fonction
  - Plus générique et moins gourmand que ```cpp std::function``` et équivalents
// Les fonctions n'ont pas besoin d'être copiables ni déplaçables

#addproposal("P2548")
#addproposal("P0792")

=== _Binding_

- Surcharge de ```cpp std::bind_front()``` et ```cpp std::bind_back()``` prenant l'appelable en paramètre template

```cpp
struct S { void foo(int, int) {...} };

bind_front(&S::foo, s, p1, p2);
// devient
bind_front<&S::foo>(s, p1, p2);
```

- Surcharge de ```cpp std::not_fn()``` prenant l'appelable en paramètre template

#addproposal("p2714")

== Attributs

=== Attributs

- Attributs sur les _structured binding_

```cpp
auto [a, b [[attribute]], c] = foo();
```

- ```cpp [[indeterminate]]``` indique qu'une variable non initialisée a une valeur indéterminé
  - Conséquence de l'introduction d'_Erroneous Behavior_
  - Permet de revenir au comportement pré-C++26

```cpp
int x [[indeterminate]]; // indeterminate value
int y;                   // erroneous value

f(x); // undefined behavior
f(y); // erroneous behavior
```

#addproposal("P0609")
#addproposal("p2795")

== Flux

=== ``` std::format```

- Possibilité de fournir une chaîne de format au _run-time_

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:10,positionColumn:1,positionLineNumber:10,selectionStartColumn:1,selectionStartLineNumber:10,startColumn:1,startLineNumber:10),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%23include+%3Cstring%3E%0A%0Aint+main()%0A%7B%0A++std::string+str+%3D+%22%7B%7D%22%3B%0A++std::cout+%3C%3C+std::format(std::runtime_format(str),+42)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:g152,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B26+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+15.2+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    string str = "{}";
    format(dynamic_format(str), 42);
    ```
  ],
)

- Amélioration du support de ```cpp std::filesystem::path```
  - Présence de caractères d'échappement (p.ex. ```cpp \n```)
  - Support de caractère UTF-8
- Redéfinition de ```cpp std::to_string``` en terme de ```cpp std::format```
- Davantage de vérifications _compile-time_ du type des arguments

```cpp
format("{:>{}}", "hello", "10");
// Erreur run-time
```

#addproposal("p2905")
#addproposal("P2918")
#addproposal("P2845")
#addproposal("p2909")
#addproposal("P2587")
#addproposal("P2757")
#addproposal("p3953")

=== ``` std::format```

- Formatage des pointeurs

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++int+i+%3D+0%3B%0A++std::cout+%3C%3C+std::format(%22%7B:%23018X%7D%22,+reinterpret_cast%3Cuintptr_t%3E(%26i))%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B26+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    format("{:#018X}", reinterpret_cast<uintptr_t>(&i));
    // 0X00007FFE0325C4E4
    ```
  ],
)

#addproposal("P2510")

=== ``` std::print```

- Impression de ligne vide

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:16,endLineNumber:2,positionColumn:16,positionLineNumber:2,selectionStartColumn:16,selectionStartLineNumber:2,startColumn:16,startLineNumber:2),source:'%23include+%3Ciostream%3E%0A%23include+%3Cprint%3E%0A%0Aint+main()%0A%7B%0A++++std::println(%22ligne+1%22)%3B%0A++++std::println()%3B%0A++++std::println(%22ligne+3%22)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B26+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    println();
    // println("") en C++23
    ```
  ],
)

- Optimisation de ```cpp std::print()```

#addproposal("P3142")
#addproposal("p3107")
#addproposal("p3235")

== Durées et temps

=== Durées et temps

- Spécialisation de ```cpp std::hash``` pour ```cpp std::chrono```

#addproposal("P2592")

== _Filesystem_

=== Accès bas-niveaux aux IO

- Alias ```cpp native_handle_type``` sur le descripteur de fichier de la plateforme
- ```cpp native_handle()``` retourne ce descripteur

#addproposal("P1759")

== Concurrence

=== Concurrence

- Version ```cpp atomic``` de minimum et maximum
- Obtention de l'adresse de l'objet référencé par ```cpp std::atomic_ref``` via ```cpp address()```
- ```cpp std::execution``` : gestion d'exécution asynchrone
  - Basé sur des _schedulers_, _senders_ et _receivers_
  - Et un ensemble d'algorithmes asynchrones
- ```cpp std::async_scope``` : RAII sur du code non séquentiel et non _stack-based_
- Contexte d'exécution asynchrone standard (interface aux pools de thread)
- Type pour contenir les _coroutine tasks_ : ```cpp std::execution::task```
- ```cpp std::store_XXX()``` équivalents à ```cpp std::fetch_XXX()``` ne retournant pas l'ancienne valeur

#addproposal("P0493")
#addproposal("p3008")
#addproposal("p2835")
#addproposal("p2300")
#addproposal("p3325")
#addproposal("p3149")
#addproposal("p2079")
#addproposal("p3552")
#addproposal("p3111")

== Nombres aléatoires

=== Générateurs

- Ajout des moteurs _counter based Philox_
- Support de ```cpp signed char``` et ```cpp unsigned char``` par les générateurs aléatoires

#addproposal("p2075")
#addproposal("P4037")

== Contrats

=== Contrats - Présentation

- Support de la programmation par contrat
- Remplace la vérification via ```cpp assert```
- Et la documentation via commentaires ```cpp @pre```, ```cpp @post``` et ```cpp @invariant```
- Intégration des contrats à la bibliothèque standard
  - Vérification des bornes
  - Présence d'un élément avant accès (```cpp std::optional```, ```cpp std::expected```)

#noteblock("Note", "Version plutôt minimale des contrats")

#noteblock(
  "Note",
  "Paramètres et variables définies hors du contrat sont constants lors de la vérification des contrats",
)

#addproposal("P2900")

=== Contrats - Présentation

#alertblock("Nombreuses critiques", text[
  #link("https://wg21.link/p3909")[P3909 : Contracts should go into a White Paper - even at this late point #linklogo()]

  #link("https://wg21.link/p3851")[P3851 : Position on contracts assertion for C++26 #linklogo()]

  #link("https://wg21.link/P4043")[P4043 : Are C++ Contracts Ready to Ship in C++26? #linklogo()]

  #link("https://wg21.link/p4020")[P4020 : Concerns about contract assertions #linklogo()]

  #link("https://wg21.link/p3846")[P3846 : C++26 Contract Assertions, Reasserted #linklogo()]
])

#questionblock("Fallait-it attendre ?", text[
Les contrats actuels sont-ils cohérents et utilisables ?

Les problèmes peuvent-ils corrigés dans une version future ?
])

=== Contrats - Présentation

- Fonctions non supportées (futures propositions)
  - Préconditions et postconditions sur les fonctions virtuelles
  - Préconditions et postconditions sur les pointeurs de fonction
  - Accès à la valeur originale des paramètres dans les postconditions
  - Sémantique ```cpp assume``` sur les contrats non vérifiés
  // Permettait au compilateur d'optimiser en fonction du contrat
  - Définition de la sémantique dans la déclaration du contrat
  - Définition de propriété du contrat dans la déclaration du contrat
  - Postconditions sur les fonctions ne sortant pas
  - Postconditions sur les sorties par exception
  - Contrats non évaluables au runtime
  - État du contrat utilisable hors du contrat
  - Invariants

#addproposal("P2900")

=== Contrats - Préconditions

- Sur les déclarations de fonctions et coroutines
- Introduites par le mot-clé contextuel ```cpp pre```
- Évaluées après l'initialisation des paramètres et avant le corps de la fonction
- Dans l'ordre des déclarations

```cpp
int f(int i)
pre (i >= 0)
{...}
```

#addproposal("P2900")

=== Contrats - Postconditions

- Sur les déclarations de fonctions et coroutines
- Introduites par le mot-clé contextuel ```cpp post```
- Évaluées lors d'une sortie normale de fonction
- Après la destruction des variables locales
- Dans l'ordre des déclarations
- Récupération de la valeur de retour dans une variable précédant la condition

```cpp
int f(int i)
post (r: r > 0)
{...}
```

#noteblock("Note", text[
  Seuls les paramètres ```cpp const``` ou de type référence sont utilisables
])

#addproposal("P2900")

=== Contrats - Assertions

- Dans le corps des fonctions
- Introduite par le mot-clé ```cpp contract_assert```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:6,endLineNumber:17,positionColumn:5,positionLineNumber:17,selectionStartColumn:6,selectionStartLineNumber:17,startColumn:5,startLineNumber:17),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%0Aconstexpr+int+foo(int+a,+int+b)%0A++%5B%5Bpre:+a+%3E+0+%26%26+b+%3E+0%5D%5D%0A++%5B%5Bpost+r:+r+%3E+10%5D%5D%0A%7B%0A++++return+a+/+b%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+foo(120,+3)+%3C%3C+%22%5Cn%22%3B%0A%23if+0%0A++std::cout+%3C%3C+foo(6,+3)+%3C%3C+%22%5Cn%22%3B%0A%23endif%0A%23if+0%0A++std::cout+%3C%3C+foo(120,+0)+%3C%3C+%22%5Cn%22%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:g152,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-Wall+-Wextra+-pedantic+-fcontracts+-Wno-unused-parameter',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+15.2+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    int f(int i)
    pre (i >= 0)
    post (r: r > 0) {
      contract_assert (i >= 0);
      return i + 1; }
    ```
  ],
)

#addproposal("P2900")

=== Contrats - Sémantiques

- Plusieurs sémantiques
  - ```cpp ignore``` : contrat non vérifié
  - ```cpp observe``` : appel au _handler_ de violation de contrat et poursuite
  - ```cpp enforce``` : appel au _handler_ de violation de contrat et terminaison
  - ```cpp quick_enforce``` : terminaison
// enforce : arrêt systématique
// observe : on laisse le handler décider
- Si la violation est détectée à la compilation
  - ```cpp observe``` : warning
  - ```cpp enforce``` et ```cpp quick_enforce``` : erreur
- Possibilité de remplacer le _handler_ par défaut :
  - Fonction ```cpp handle_contract_violation```
  - Paramètre de type ```cpp std::contracts::contract_violation```

#addproposal("P2900")

== Réflexion

=== Réflexion

- Support de la réflexion statique
  - Type opaque ```cpp std::meta::info``` représente les éléments du programme
  - Opérateur de réflexion ```cpp ^^```
  - Méta-fonctions de réflexion
  - Construction de production des éléments ```cpp [: refl :]```
- Introspection
- Méta-programmation et code _compile-time_
- Injection
- Construction de données statiques depuis du _compile-time_ : ```cpp std::define_static_string```, ```cpp std::define_static_object``` et ```cpp std::define_static_array```
- ```cpp is_structural_type``` détermine si un type est un _structural type_

#addproposal("p2996")
#addproposal("p3096")
#addproposal("p1306")
#addproposal("p3491")
#addproposal("p3293")
#addproposal("p3394")
#addproposal("p3560")
#addproposal("p3856")

=== Réflexion

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:52,endLineNumber:23,positionColumn:52,positionLineNumber:23,selectionStartColumn:52,selectionStartLineNumber:23,startColumn:52,startLineNumber:23),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%23include+%3Coptional%3E%0A%23include+%3Cmeta%3E%0A%23include+%3Cstring_view%3E%0A%0Aenum+Color+%7B+red,+green,+blue+%7D%3B%0A%0Atemplate%3Ctypename+E,+bool+Enumerable+%3D+std::meta::is_enumerable_type(%5E%5EE)%3E%0Arequires+std::is_enum_v%3CE%3E%0Aconstexpr+std::string_view+enum_to_string(E+value)+%7B%0A++if+constexpr+(Enumerable)%0A++++template+for+(constexpr+auto+e+:%0A++++++define_static_array(std::meta::enumerators_of(%5E%5EE)))%0A++if+(value+%3D%3D+%5B:e:%5D)%0A++++return+std::meta::identifier_of(e)%3B%0A%0Areturn+%22%3Cunnamed%3E%22%3B+%7D%0A%0Aint+main()%0A%7B%0A++++std::cout+%3C%3C+enum_to_string(Color::red)+%3C%3C+%22%5Cn%22%3B%0A++++std::cout+%3C%3C+enum_to_string(Color(42))+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:clang_bb_p2996,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B26+-Wall+-Wextra+-pedantic+-fexpansion-statements',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+clang+(reflection+-+C%2B%2B26)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    enum Color { red, green, blue };

    template<typename E, bool Enumerable = meta::is_enumerable_type(^^E)>
    requires is_enum_v<E>
    constexpr string_view enum_to_string(E value) {
      if constexpr (Enumerable)
        template for (constexpr auto e :
          define_static_array(meta::enumerators_of(^^E)))
      if (value == [:e:])
        return meta::identifier_of(e);

    return "<unnamed>"; }

    enum_to_string(Color::red);  // red
    enum_to_string(Color(42));   // <unnamed>
    ```
  ],
)

== Compilation et implémentation

=== Modules

- Suppression de l'expansion de macros dans les déclarations de module

#addproposal("P3034")

=== Compilation et implémentation

- ```cpp #embed``` ressources externes disponibles au _run-time_

```cpp
const unsigned char foo[] = {
  #embed "foo.png"
};
```

#addproposal("p1967")

=== Debug

- ```cpp std::breakpoint()``` : point d'arrêt dans le programme
- ```cpp std::breakpoint_if_debugging()``` : point d'arrêt si l'exécution se fait dans un debugger
- ```cpp std::is_debugger_present()``` permet de savoir si l'exécution se fait dans un debugger

#addproposal("P2546")
