#import "./model.typ": *
#import "@preview/cetz:0.4.2"

= C++11

== Présentation

- Approuvé le 12 août 2011
- Dernier _Working Draft_ : #link("https://wg21.link/std11")[N3337 #linklogo()]
- Standardisation laborieuse
  - Sortie tardive (C++0x)
  - Périmètre initial trop ambitieux (retrait des concepts en 2009)
- Changement de fonctionnement du comité
  - Utilisation de _Technical Specification_ et de groupes de travail dédiés
  - Pilotage par les dates et pas les fonctionnalités
  - Des versions fréquentes (3 ans : 2011, 2014, 2017, 2020, ...)
  - Voir #link("https://herbsutter.com/2016/03/11/trip-report-winter-iso-c-standards-meeting/")[Trip report: Winter ISO C++ standards meeting #linklogo()]
- Objectifs : sûreté, simplicité, rapidité et meilleure détection d'erreur en _compile-time_

== Dépréciations et suppressions

- Dépréciation de ```cpp register```

#addproposal("n4193")

== Export templates

- Suppression des _export templates_
- ```cpp export``` reste un mot-clé réservé

#noteblock("Compatibilité", text[
  Rupture de comptabilité ascendante

  Implémenté sur un unique compilateur et inutilisé en pratique

  // Un seul front end EDG, utilisé par deux compilateurs (Comeau et ICC) mais la fonctionnalité n'était pas active chez Intel
  // Suppression soutenue par l'équipe d'EDG
])

#addproposal("N1426")

== Nouveaux types entiers

- Hérités de C99

#noteblock("Depuis C99", text[
  Ainsi que _variadic macro_, ```cpp __func__```, concaténation de chaînes littérales, ...
])

- ```cpp long long int``` et ```cpp unsigned long long int```
  - Au moins aussi grand que ```cpp long int```
  - Plages garanties : [$-(2^63-1)$, $2^63-1$] et [$0$, $2^64$]
  - Extension de nombreux compilateurs bien avant C++11
- Types entiers le plus grand disponibles ```cpp intmax_t``` et ```cpp uintmax_t```

#addproposal("N1811")
#addproposal("N1835")
#addproposal("n1988")

== Nouveaux types entiers

- Entiers de ```cpp N``` bits ```cpp int<N>_t``` et ```cpp uint<N>_t```
  - ```cpp N``` = 8, 16, 32 ou 64
  - ```cpp int<N>_t``` obligatoirement en complément à 2

  // En C++, pas de contrainte sur les autres types entiers signés avant C++20
  // En C (avant C23), d'autres représentations possibles : signe + valeur (avec deux codages de 0, algorithme d'addition/ multiplication non canonique) et complément à 1 où chaque bit du positif est inversé pour donner le négatif, là encore deux valeurs de 0
  // Complément à 2 : inversion de chaque bit (complément à 1) puis ajout de 1

  - Pas de bit de _padding_
  - Support optionnel
- Plus petits entiers d'au moins ```cpp N``` bits ```cpp int_least<N>_t``` et ```cpp uint_least<N>_t```
- Plus rapides entiers d'au moins ```cpp N``` bits ```cpp int_fast<N>_t``` et ```cpp uint_fast<N>_t```
- Entiers capables de contenir une adresse ```cpp intptr_t``` et ```cpp uintptr_t```
  - Convertibles en ```cpp void*``` avec une valeur égale au pointeur original
  - Support optionnel

#addproposal("N1835")
#addproposal("n1988")

== Nouveaux types entiers

- Macros de définition des plages correspondantes
- Macros de construction depuis des entiers classiques
- Macros des spécificateurs pour ```cpp printf()``` et ```cpp scanf()```
- Fonctions de manipulation de ```cpp intmax_t``` et ```cpp uintmax_t```
- Surcharges de ```cpp abs()``` et ```cpp div()``` pour ```cpp intmax_t``` si nécessaire

#addproposal("N1835")
#addproposal("n1988")

== POD Généralisé -- Rappels

- Types POD (_Plain Old Data_) : classes et structures POD, unions POD, types scalaires et tableaux de ces types
- Certaines constructions permises uniquement sur les types POD

  // Permises uniquement sur les POD vue de la norme tout du moins. En pratique, certaines opérations peuvent fonctionner sur des types non-POD sur une implémentation particulière

  - Utilisation de ```cpp memcpy()``` ou ```cpp memmove()```
  - Utilisation de ```cpp goto``` au-delà de la déclaration d'une variable

  // C'est à dire depuis un point où la variable n'est pas dans le scope vers un point où la variable est déjà dans le scope

  - Utilisation de ```cpp reinterpret_cast```
  - Accès au début commun d'une union par un membre non actif
  - Utilisation des fonctions C ```cpp qsort()``` ou ```cpp bsearch()```
  - ...

== POD Généralisé -- Classe agrégat C++98

- Pas de constructeur déclaré par l'utilisateur
- Pas de donnée membre non-statique privée ou protégée
- Pas de classe de base
- Pas de fonction virtuelle

== POD Généralisé -- Classe agrégat C++11

- Pas de constructeur #underline[fourni] par l'utilisateur

// Les constructeurs déclarés =default par l'utilisateur sont autorisés

- Pas d'initialisation _brace-or-equal-initializers_ des données membres non-statiques
- Pas de donnée membre non-statique privée ou protégée
- Pas de classe de base
- Pas de fonction virtuelle

#addproposal("n2342")

== POD Généralisé -- Classe POD C++98

- Classe agrégat
- Sans donnée membre non-statique de type non-POD
- Sans référence
- Sans opérateur d'affectation défini par l'utilisateur
- Sans destructeur défini par l'utilisateur

== POD Généralisé -- Classe POD C++11

- Contraintes réparties en trois sous-notions
- _trivially copyable_
  - Pas de constructeur de copie ou de déplacement non triviaux
  - Pas d'opérateur d'affectation non trivial
  - Destructeur trivial

#noteblock("Trivial", text[
  Pas fournie par l'utilisateur

  Pas de fonction virtuelle ni de classe de base virtuelle

  Opération des classes de bases et des membres non-statiques est triviale
])

#addproposal("n2342")

== POD Généralisé -- Classe POD C++11

#noteblock("Autre formulation", text[
  Copie, déplacement, affectation et destruction générés implicitement

  Pas de fonction ni de classe de base virtuelle

  Classes de base et membres non-statiques _trivially copyable_
])

#addproposal("n2342")

== POD Généralisé -- Classe POD C++11

- _trivial_
  - _trivially copyable_
  - Constructeur par défaut trivial
    - Pas fourni par l'utilisateur
    - Pas de fonction virtuelle ni de classe de base virtuelle
    - Constructeur par défaut des classes de base et des membres non-statiques trivial
    - Pas d'initialisation _brace-or-equal-initializers_ des données membres non-statiques

#addproposal("n2342")

== POD Généralisé -- Classe POD C++11

- _Standard-layout_
  - Pas de donnée membre non-statique non-_Standard-layout_
  - Pas de référence
  - Pas de classe de base non-_Standard-layout_
  - Pas de fonction virtuelle
  - Pas de classe de base virtuelle
  - Même accessibilité de toutes les données membres non-statique
  - Données membres non-statiques dans une seule classe de l'hiérarchie
  - Pas de classe de base du type de la première donnée membre non-statique

#noteblock("En résumé", "Organisation mémoire similaire aux structures C")

#addproposal("n2342")

== POD Généralisé -- Classe POD C++11

- POD
  - _trivial_
  - _standard layout_
  - Pas de donnée membre non-statique non-POD
- Traits correspondants
  - ```cpp std::is_trivial```
  - ```cpp std::is_trivially_copyable```
  - ```cpp std::is_standard_layout```

#addproposal("n2342")

== POD Généralisé -- Objectifs

- Opérations POD accessibles à la sous-notion correspondante
- Relâchement et adaptation de certaines contraintes
  - Constructeurs ou destructeurs ```cpp =default``` autorisés
  - Données membres non-statiques plus nécessairement publiques

  //Mais doivent toutes avoir la même portée, car en C++, le compilateur peut réordonner les données de portées différentes

  - Classes de base non virtuelles autorisées

// A condition de respecter les contraintes de type et de localité des données membre

#addproposal("n2342")

== POD Généralisé -- Conséquences

- _standard layout_
  - Utilisation de ```cpp reinterpret_cast```
  - Utilisation de ```cpp offsetof```
  - Accès au début commun d'une union par un membre non actif

- _trivially copyable_
  - Utilisation de ```cpp memcpy()``` ou ```cpp memmove()```

- _trivial_
  - Utilisation de ```cpp goto``` au-delà de la déclaration d'une variable
  - Utilisation de ```cpp qsort()``` ou ```cpp bsearch()```

#addproposal("n2342")

== Unions généralisées

- Constructeurs, opérateurs d'assignation ou destructeurs définis par l'utilisateur acceptés sur les types membres d'une union
- ... mais les fonctions équivalentes de l'union sont supprimées

// Il est donc impossible de copier une union si un des membres est un type possédant un constructeur de copie défini par l'utilisateur

- Toujours impossible d'utiliser des types avec des fonctions virtuelles, des références ou des classes de base

#addproposal("N2544")

== ``` inline namespace```

- Injection des déclarations du namespace imbriqué dans le namespace parent

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:26,startColumn:1,startLineNumber:26),source:'%23include+%3Ciostream%3E%0A%0Anamespace+V1%0A%7B%0A++static+void+foo()%0A++%7B%0A++++std::cout+%3C%3C+%22V1%5Cn%22%3B%0A++%7D%0A%7D%0A%0Ainline+namespace+V2%0A%7B%0A++static+void+foo()%0A++%7B%0A++++std::cout+%3C%3C+%22V2%5Cn%22%3B%0A++%7D%0A%7D%0A%0Aint+main()%0A%7B%0A++V1::foo()%3B%0A++V2::foo()%3B%0A%0A++foo()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    namespace V1 { void foo() { cout << "V1\n"; } }

    inline namespace V2 { void foo() { cout << "V2\n"; } }

    V1::foo();  // Affiche V1
    V2::foo();  // Affiche V2
    foo();      // Affiche V2
    ```
  ],
)

#noteblock("Motivation", "Évolution de bibliothèques et conservation des versions précédentes")

#addproposal("N2535")

== ``` 0``` ou ``` NULL``` ?

- C++ 98 : ```cpp 0``` ou ```cpp NULL```

// En C++, NULL est un define sur 0 (ou équivalent), ne peut pas être (void*)0 comme en C

- Cohabite mal avec les surcharges

#noteblock("Quiz : Quelle surcharge est éligible ?", text[
  ```cpp
  void foo(char*) { cout << "chaîne\n"; }
  void foo(int) { cout << "entier\n"; }

  foo(0);
  foo(NULL);
  ```
])

== ``` 0``` ou ``` NULL``` ? ``` nullptr``` !

- C++ 11 : ```cpp nullptr```
  - Unique pointeur du type ```cpp nullptr_t```
  - Conversion implicite de ```cpp nullptr_t``` vers tout type de pointeur

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astatic+void+foo(char*)%0A%7B%0A++std::cout+%3C%3C+%22chaine%5Cn%22%3B%0A%7D%0A%0Astatic+void+foo(int)%0A%7B%0A++std::cout+%3C%3C+%22entier%5Cn%22%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++foo(0)%3B%0A%23if+1%0A++foo(NULL)%3B%0A%23else%0A++foo(nullptr)%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    void foo(char*) { cout << "chaîne\n"; }
    void foo(int) { cout << "entier\n"; }

    foo(0);        // Version int
    foo(nullptr);  // Version pointeur
    ```
  ],
)

#adviceblock("Do", text[
  Utilisez ```cpp nullptr``` plutôt que ```cpp 0``` ou ```cpp NULL```
])

#addproposal("N2431")

== ``` static_assert```

- Assertion vérifiée à la compilation

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++static_assert(sizeof(int)+%3D%3D+3,+%22Taille+incorrecte%22)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    static_assert(sizeof(int) == 3, "Taille incorrecte");
    // Erreur de compilation indiquant "Taille incorrecte"
    ```
  ],
)

#adviceblock("Do", text[
  Utilisez ```cpp static_assert``` pour vérifier à la compilation ce qui peut l'être
])

#adviceblock("Do", text[
  Préférez les vérifications _compile-time_ ou _link-time_ aux vérifications _run-time_
])

#addproposal("N1720")

== ``` constexpr```

- Indique une expression constante
- Donc évaluable et utilisable à la compilation
- Implicitement ```cpp const```
- Fonctions ```cpp constexpr``` implicitement ```cpp inline```
- Contenu des fonctions ```cpp constexpr``` limité
  - ```cpp static_assert```
  - ```cpp typedef```
  - ```cpp using```
  - Exactement une expression ```cpp return```

// Et des null statements, mais ça n'a pas d'intérêt

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astatic+constexpr+int+foo()%0A%7B%0A++return+42%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++char+bar%5Bfoo()%5D+%3D+%22azerty%22%3B%0A%0A++std::cout+%3C%3C+bar+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    constexpr int foo() { return 42; }

    char bar[foo()];
    ```
  ],
)

#addproposal("N2235")

== ``` constexpr```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astatic+constexpr+int+foo()%0A%7B%0A++return+42%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++int+a+%3D+42%3B%0A++switch(a)%0A++%7B%0A++++case+foo():%0A++++++std::cout+%3C%3C+%22case+foo%5Cn%22%3B%0A++++++break%3B%0A%0A++++default:%0A++++++std::cout+%3C%3C+%22defuault%5Cn%22%3B%0A++++++break%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    constexpr int foo() { return 42; }

    int a = 42;
    switch(a) {
      case foo():
        break;

      default:
        break;
    }
    ```
  ],
)

#addproposal("N2235")

== ``` constexpr```

- Sous certaines conditions restrictives, ```cpp const``` sur une variable est suffisant

// type entier ou énumération, initialisé à la déclaration par une expression constante

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:13,endLineNumber:6,positionColumn:13,positionLineNumber:6,selectionStartColumn:13,selectionStartLineNumber:6,startColumn:13,startLineNumber:6),source:'%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++const+int+a+%3D+42%3B%0A++char+bar%5Ba%5D+%3D+%22azerty%22%3B%0A%0A++std::cout+%3C%3C+bar+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    const int a = 42;
    char bar[a];
    ```
  ],
)

#alertblock(text[_Variable-Length Array_], text[
  Pas de rapport entre VLA et ```cpp constexpr```

  VLA est un mécanisme _run-time_
])

// VLA est une fonctionnalité C, non reprise en C++, mais proposée sous forme d'extension par certains compilateurs. Elle consiste à accepter les tableaux de taille définie au run-time

#adviceblock("Do", text[
  Déclarez ```cpp constexpr``` les constantes et fonctions évaluables en _compile-time_
])

#addproposal("N2235")

== Extended ``` sizeof```

- ```cpp sizeof``` sur des membres non statiques

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astruct+Foo%0A%7B%0A++int+bar%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+sizeof+Foo::bar+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    struct Foo { int bar; };

    // Valide en C++11, mal-forme en C++98/03
    cout << sizeof Foo::bar;
    ```
  ],
)

// Mal-formé (ill-formed) n'implique pas une erreur de compilation ni même un avertissement, seulement que ce n'est pas correct vu de la norme

#noteblock("Note", "En pratique, cet exemple compile en mode C++98 sous GCC")

#addproposal("n2253")

== Sémantique de déplacement

- Deux constats
  - Copie potentiellement coûteuse ou impossible
  - Copie inutile lorsque l'objet source est immédiatement détruit

#noteblock("Optimisation des copies", "Partiellement adressé en C++98/03 par l'élision de copie et (N)RVO")

- Échange de données légères plutôt que copie profonde
- Déplacement seulement si
  - Type déplaçable
  - Instance sur le point d'être détruite ou explicitement déplacée

#alertblock("Attention", "Les données ne sont plus présentes dans l'objet initial")

#addproposal("N2118")
#addproposal("n2439")
#addproposal("N2844")
#addproposal("N3053")

== Sémantique de déplacement

- Copie

#cetz.canvas(length: 1em, {
  import cetz.draw: *

  // Grille pour le tracer, changer la couleur pour l'affiche ou pas
  grid(
    (0, 0),
    (30, -17),
    stroke: white,
  )

  rect((4, 0), (8, -1), name: "vec1_0")
  rect((8, 0), (10, -1), name: "cap1_0")
  rect((10, 0), (12, -1), name: "size1_0")
  content("vec1_0", text(size: 0.7em)[Vecteur 1])
  content("cap1_0", text(size: 0.7em)[Cap. n])
  content("size1_0", text(size: 0.7em)[Tail. n])

  rect((6, -2), (8, -3), name: "obj11_0")
  rect((8, -2), (10, -3), name: "obj12_0")
  rect((10, -2), (12, -3), name: "obj13_0")
  rect((12, -2), (14, -3), name: "obj14_0")
  content("obj11_0", text(size: 0.7em)[Obj1])
  content("obj12_0", text(size: 0.7em)[Obj2])
  content("obj13_0", text(size: 0.7em)[...])
  content("obj14_0", text(size: 0.7em)[Objn])

  line((5, -1), (5, -2.5))
  line((5, -2.5), (6, -2.5))

  rect((16, 0), (20, -1), name: "vec2_0")
  rect((20, 0), (22, -1), name: "cap2_0")
  rect((22, 0), (24, -1), name: "size2_0")
  content("vec2_0", text(size: 0.7em)[Vecteur 2])
  content("cap2_0", text(size: 0.7em)[Cap. 0])
  content("size2_0", text(size: 0.7em)[Tail. 0])

  rect((18, -2), (20, -3), name: "obj21_0")
  content("obj21_0", text(size: 0.7em)[_null_])

  line((17, -1), (17, -2.5))
  line((17, -2.5), (18, -2.5))
})

== Sémantique de déplacement

- Copie

#cetz.canvas(length: 1em, {
  import cetz.draw: *

  // Grille pour le tracer, changer la couleur pour l'affiche ou pas
  grid(
    (0, 0),
    (30, -17),
    stroke: white,
  )

  rect((4, 0), (8, -1), name: "vec1_0")
  rect((8, 0), (10, -1), name: "cap1_0")
  rect((10, 0), (12, -1), name: "size1_0")
  content("vec1_0", text(size: 0.7em)[Vecteur 1])
  content("cap1_0", text(size: 0.7em)[Cap. n])
  content("size1_0", text(size: 0.7em)[Tail. n])

  rect((6, -2), (8, -3), name: "obj11_0")
  rect((8, -2), (10, -3), name: "obj12_0")
  rect((10, -2), (12, -3), name: "obj13_0")
  rect((12, -2), (14, -3), name: "obj14_0")
  content("obj11_0", text(size: 0.7em)[Obj1])
  content("obj12_0", text(size: 0.7em)[Obj2])
  content("obj13_0", text(size: 0.7em)[...])
  content("obj14_0", text(size: 0.7em)[Objn])

  line((5, -1), (5, -2.5))
  line((5, -2.5), (6, -2.5))

  rect((16, 0), (20, -1), name: "vec2_0")
  rect((20, 0), (22, -1), name: "cap2_0")
  rect((22, 0), (24, -1), name: "size2_0")
  content("vec2_0", text(size: 0.7em)[Vecteur 2])
  content("cap2_0", text(size: 0.7em)[Cap. 0])
  content("size2_0", text(size: 0.7em)[Tail. 0])

  rect((18, -2), (20, -3), name: "obj21_0")
  content("obj21_0", text(size: 0.7em)[_null_])

  line((17, -1), (17, -2.5))
  line((17, -2.5), (18, -2.5))

  rect((2, -3.1), (10, -3.9), name: "alloc", stroke: white)
  content("alloc", box(width: 8em, align(left)[#text(main_color, size: 0.7em)[Allocation]]))

  rect((4, -4), (8, -5), name: "vec1_1")
  rect((8, -4), (10, -5), name: "cap1_1")
  rect((10, -4), (12, -5), name: "size1_1")
  content("vec1_1", text(size: 0.7em)[Vecteur 1])
  content("cap1_1", text(size: 0.7em)[Cap. n])
  content("size1_1", text(size: 0.7em)[Tail. n])

  rect((6, -6), (8, -7), name: "obj11_1")
  rect((8, -6), (10, -7), name: "obj12_1")
  rect((10, -6), (12, -7), name: "obj13_1")
  rect((12, -6), (14, -7), name: "obj14_1")
  content("obj11_1", text(size: 0.7em)[Obj1])
  content("obj12_1", text(size: 0.7em)[Obj2])
  content("obj13_1", text(size: 0.7em)[...])
  content("obj14_1", text(size: 0.7em)[Objn])

  line((5, -5), (5, -6.5))
  line((5, -6.5), (6, -6.5))

  rect((16, -4), (20, -5), name: "vec2_1")
  rect((20, -4), (22, -5), name: "cap2_1")
  rect((22, -4), (24, -5), name: "size2_1")
  content("vec2_1", text(size: 0.7em)[Vecteur 2])
  content("cap2_1", text(size: 0.7em)[Cap. n])
  content("size2_1", text(size: 0.7em)[Tail. 0])

  rect((18, -6), (20, -7), name: "obj21_1")
  rect((20, -6), (22, -7), name: "obj22_1")
  rect((22, -6), (24, -7), name: "obj23_1")
  rect((24, -6), (26, -7), name: "obj24_1")

  line((17, -5), (17, -6.5))
  line((17, -6.5), (18, -6.5))
})

== Sémantique de déplacement

- Copie

#cetz.canvas(length: 1em, {
  import cetz.draw: *

  // Grille pour le tracer, changer la couleur pour l'affiche ou pas
  grid(
    (0, 0),
    (30, -17),
    stroke: white,
  )

  rect((4, 0), (8, -1), name: "vec1_0")
  rect((8, 0), (10, -1), name: "cap1_0")
  rect((10, 0), (12, -1), name: "size1_0")
  content("vec1_0", text(size: 0.7em)[Vecteur 1])
  content("cap1_0", text(size: 0.7em)[Cap. n])
  content("size1_0", text(size: 0.7em)[Tail. n])

  rect((6, -2), (8, -3), name: "obj11_0")
  rect((8, -2), (10, -3), name: "obj12_0")
  rect((10, -2), (12, -3), name: "obj13_0")
  rect((12, -2), (14, -3), name: "obj14_0")
  content("obj11_0", text(size: 0.7em)[Obj1])
  content("obj12_0", text(size: 0.7em)[Obj2])
  content("obj13_0", text(size: 0.7em)[...])
  content("obj14_0", text(size: 0.7em)[Objn])

  line((5, -1), (5, -2.5))
  line((5, -2.5), (6, -2.5))

  rect((16, 0), (20, -1), name: "vec2_0")
  rect((20, 0), (22, -1), name: "cap2_0")
  rect((22, 0), (24, -1), name: "size2_0")
  content("vec2_0", text(size: 0.7em)[Vecteur 2])
  content("cap2_0", text(size: 0.7em)[Cap. 0])
  content("size2_0", text(size: 0.7em)[Tail. 0])

  rect((18, -2), (20, -3), name: "obj21_0")
  content("obj21_0", text(size: 0.7em)[_null_])

  line((17, -1), (17, -2.5))
  line((17, -2.5), (18, -2.5))

  rect((2, -3.1), (10, -3.9), name: "alloc", stroke: white)
  content("alloc", box(width: 8em, align(left)[#text(main_color, size: 0.7em)[Allocation]]))

  rect((4, -4), (8, -5), name: "vec1_1")
  rect((8, -4), (10, -5), name: "cap1_1")
  rect((10, -4), (12, -5), name: "size1_1")
  content("vec1_1", text(size: 0.7em)[Vecteur 1])
  content("cap1_1", text(size: 0.7em)[Cap. n])
  content("size1_1", text(size: 0.7em)[Tail. n])

  rect((6, -6), (8, -7), name: "obj11_1")
  rect((8, -6), (10, -7), name: "obj12_1")
  rect((10, -6), (12, -7), name: "obj13_1")
  rect((12, -6), (14, -7), name: "obj14_1")
  content("obj11_1", text(size: 0.7em)[Obj1])
  content("obj12_1", text(size: 0.7em)[Obj2])
  content("obj13_1", text(size: 0.7em)[...])
  content("obj14_1", text(size: 0.7em)[Objn])

  line((5, -5), (5, -6.5))
  line((5, -6.5), (6, -6.5))

  rect((16, -4), (20, -5), name: "vec2_1")
  rect((20, -4), (22, -5), name: "cap2_1")
  rect((22, -4), (24, -5), name: "size2_1")
  content("vec2_1", text(size: 0.7em)[Vecteur 2])
  content("cap2_1", text(size: 0.7em)[Cap. n])
  content("size2_1", text(size: 0.7em)[Tail. 0])

  rect((18, -6), (20, -7), name: "obj21_1")
  rect((20, -6), (22, -7), name: "obj22_1")
  rect((22, -6), (24, -7), name: "obj23_1")
  rect((24, -6), (26, -7), name: "obj24_1")

  line((17, -5), (17, -6.5))
  line((17, -6.5), (18, -6.5))

  rect((2, -7.1), (10, -7.9), name: "alloc", stroke: white)
  content("alloc", box(width: 8em, align(left)[#text(main_color, size: 0.7em)[Copie des éléments]]))

  rect((4, -8), (8, -9), name: "vec1_2")
  rect((8, -8), (10, -9), name: "cap1_2")
  rect((10, -8), (12, -9), name: "size1_2")
  content("vec1_2", text(size: 0.7em)[Vecteur 1])
  content("cap1_2", text(size: 0.7em)[Cap. n])
  content("size1_2", text(size: 0.7em)[Tail. n])

  rect((6, -10), (8, -11), name: "obj11_2")
  rect((8, -10), (10, -11), name: "obj12_2")
  rect((10, -10), (12, -11), name: "obj13_2")
  rect((12, -10), (14, -11), name: "obj14_2")
  content("obj11_2", text(size: 0.7em)[Obj1])
  content("obj12_2", text(size: 0.7em)[Obj2])
  content("obj13_2", text(size: 0.7em)[...])
  content("obj14_2", text(size: 0.7em)[Objn])

  line((5, -9), (5, -10.5))
  line((5, -10.5), (6, -10.5))

  rect((16, -8), (20, -9), name: "vec2_2")
  rect((20, -8), (22, -9), name: "cap2_2")
  rect((22, -8), (24, -9), name: "size2_2")
  content("vec2_2", text(size: 0.7em)[Vecteur 2])
  content("cap2_2", text(size: 0.7em)[Cap. n])
  content("size2_2", text(size: 0.7em)[Tail. 1])

  rect((18, -10), (20, -11), name: "obj21_2")
  rect((20, -10), (22, -11), name: "obj22_2")
  rect((22, -10), (24, -11), name: "obj23_2")
  rect((24, -10), (26, -11), name: "obj24_2")
  content("obj21_2", text(size: 0.7em)[Obj1])

  line((17, -9), (17, -10.5))
  line((17, -10.5), (18, -10.5))
})

== Sémantique de déplacement

- Copie

#cetz.canvas(length: 1em, {
  import cetz.draw: *

  // Grille pour le tracer, changer la couleur pour l'affiche ou pas
  grid(
    (0, 0),
    (30, -17),
    stroke: white,
  )

  rect((4, 0), (8, -1), name: "vec1_0")
  rect((8, 0), (10, -1), name: "cap1_0")
  rect((10, 0), (12, -1), name: "size1_0")
  content("vec1_0", text(size: 0.7em)[Vecteur 1])
  content("cap1_0", text(size: 0.7em)[Cap. n])
  content("size1_0", text(size: 0.7em)[Tail. n])

  rect((6, -2), (8, -3), name: "obj11_0")
  rect((8, -2), (10, -3), name: "obj12_0")
  rect((10, -2), (12, -3), name: "obj13_0")
  rect((12, -2), (14, -3), name: "obj14_0")
  content("obj11_0", text(size: 0.7em)[Obj1])
  content("obj12_0", text(size: 0.7em)[Obj2])
  content("obj13_0", text(size: 0.7em)[...])
  content("obj14_0", text(size: 0.7em)[Objn])

  line((5, -1), (5, -2.5))
  line((5, -2.5), (6, -2.5))

  rect((16, 0), (20, -1), name: "vec2_0")
  rect((20, 0), (22, -1), name: "cap2_0")
  rect((22, 0), (24, -1), name: "size2_0")
  content("vec2_0", text(size: 0.7em)[Vecteur 2])
  content("cap2_0", text(size: 0.7em)[Cap. 0])
  content("size2_0", text(size: 0.7em)[Tail. 0])

  rect((18, -2), (20, -3), name: "obj21_0")
  content("obj21_0", text(size: 0.7em)[_null_])

  line((17, -1), (17, -2.5))
  line((17, -2.5), (18, -2.5))

  rect((2, -3.1), (10, -3.9), name: "alloc", stroke: white)
  content("alloc", box(width: 8em, align(left)[#text(main_color, size: 0.7em)[Allocation]]))

  rect((4, -4), (8, -5), name: "vec1_1")
  rect((8, -4), (10, -5), name: "cap1_1")
  rect((10, -4), (12, -5), name: "size1_1")
  content("vec1_1", text(size: 0.7em)[Vecteur 1])
  content("cap1_1", text(size: 0.7em)[Cap. n])
  content("size1_1", text(size: 0.7em)[Tail. n])

  rect((6, -6), (8, -7), name: "obj11_1")
  rect((8, -6), (10, -7), name: "obj12_1")
  rect((10, -6), (12, -7), name: "obj13_1")
  rect((12, -6), (14, -7), name: "obj14_1")
  content("obj11_1", text(size: 0.7em)[Obj1])
  content("obj12_1", text(size: 0.7em)[Obj2])
  content("obj13_1", text(size: 0.7em)[...])
  content("obj14_1", text(size: 0.7em)[Objn])

  line((5, -5), (5, -6.5))
  line((5, -6.5), (6, -6.5))

  rect((16, -4), (20, -5), name: "vec2_1")
  rect((20, -4), (22, -5), name: "cap2_1")
  rect((22, -4), (24, -5), name: "size2_1")
  content("vec2_1", text(size: 0.7em)[Vecteur 2])
  content("cap2_1", text(size: 0.7em)[Cap. n])
  content("size2_1", text(size: 0.7em)[Tail. 0])

  rect((18, -6), (20, -7), name: "obj21_1")
  rect((20, -6), (22, -7), name: "obj22_1")
  rect((22, -6), (24, -7), name: "obj23_1")
  rect((24, -6), (26, -7), name: "obj24_1")

  line((17, -5), (17, -6.5))
  line((17, -6.5), (18, -6.5))

  rect((2, -7.1), (10, -7.9), name: "alloc", stroke: white)
  content("alloc", box(width: 8em, align(left)[#text(main_color, size: 0.7em)[Copie des éléments]]))

  rect((4, -8), (8, -9), name: "vec1_2")
  rect((8, -8), (10, -9), name: "cap1_2")
  rect((10, -8), (12, -9), name: "size1_2")
  content("vec1_2", text(size: 0.7em)[Vecteur 1])
  content("cap1_2", text(size: 0.7em)[Cap. n])
  content("size1_2", text(size: 0.7em)[Tail. n])

  rect((6, -10), (8, -11), name: "obj11_2")
  rect((8, -10), (10, -11), name: "obj12_2")
  rect((10, -10), (12, -11), name: "obj13_2")
  rect((12, -10), (14, -11), name: "obj14_2")
  content("obj11_2", text(size: 0.7em)[Obj1])
  content("obj12_2", text(size: 0.7em)[Obj2])
  content("obj13_2", text(size: 0.7em)[...])
  content("obj14_2", text(size: 0.7em)[Objn])

  line((5, -9), (5, -10.5))
  line((5, -10.5), (6, -10.5))

  rect((16, -8), (20, -9), name: "vec2_2")
  rect((20, -8), (22, -9), name: "cap2_2")
  rect((22, -8), (24, -9), name: "size2_2")
  content("vec2_2", text(size: 0.7em)[Vecteur 2])
  content("cap2_2", text(size: 0.7em)[Cap. n])
  content("size2_2", text(size: 0.7em)[Tail. 1])

  rect((18, -10), (20, -11), name: "obj21_2")
  rect((20, -10), (22, -11), name: "obj22_2")
  rect((22, -10), (24, -11), name: "obj23_2")
  rect((24, -10), (26, -11), name: "obj24_2")
  content("obj21_2", text(size: 0.7em)[Obj1])

  line((17, -9), (17, -10.5))
  line((17, -10.5), (18, -10.5))

  rect((4, -11.1), (26, -11.5), name: "alloc", stroke: white)
  content("alloc", [...])

  rect((4, -12), (8, -13), name: "vec1_3")
  rect((8, -12), (10, -13), name: "cap1_3")
  rect((10, -12), (12, -13), name: "size1_3")
  content("vec1_3", text(size: 0.7em)[Vecteur 1])
  content("cap1_3", text(size: 0.7em)[Cap. n])
  content("size1_3", text(size: 0.7em)[Tail. n])

  rect((6, -14), (8, -15), name: "obj11_3")
  rect((8, -14), (10, -15), name: "obj12_3")
  rect((10, -14), (12, -15), name: "obj13_3")
  rect((12, -14), (14, -15), name: "obj14_3")
  content("obj11_3", text(size: 0.7em)[Obj1])
  content("obj12_3", text(size: 0.7em)[Obj2])
  content("obj13_3", text(size: 0.7em)[...])
  content("obj14_3", text(size: 0.7em)[Objn])

  line((5, -13), (5, -14.5))
  line((5, -14.5), (6, -14.5))

  rect((16, -12), (20, -13), name: "vec2_3")
  rect((20, -12), (22, -13), name: "cap2_3")
  rect((22, -12), (24, -13), name: "size2_3")
  content("vec2_3", text(size: 0.7em)[Vecteur 2])
  content("cap2_3", text(size: 0.7em)[Cap. n])
  content("size2_3", text(size: 0.7em)[Tail. n])

  rect((18, -14), (20, -15), name: "obj21_3")
  rect((20, -14), (22, -15), name: "obj22_3")
  rect((22, -14), (24, -15), name: "obj23_3")
  rect((24, -14), (26, -15), name: "obj24_3")
  content("obj21_3", text(size: 0.7em)[Obj1])
  content("obj22_3", text(size: 0.7em)[Obj2])
  content("obj23_3", text(size: 0.7em)[...])
  content("obj24_3", text(size: 0.7em)[Objn])

  line((17, -13), (17, -14.5))
  line((17, -14.5), (18, -14.5))
})

== Sémantique de déplacement

- Déplacement

#cetz.canvas(length: 1em, {
  import cetz.draw: *

  // Grille pour le tracer, changer la couleur pour l'affiche ou pas
  grid(
    (0, 0),
    (30, -17),
    stroke: white,
  )

  rect((4, 0), (8, -1), name: "vec1_0")
  rect((8, 0), (10, -1), name: "cap1_0")
  rect((10, 0), (12, -1), name: "size1_0")
  content("vec1_0", text(size: 0.7em)[Vecteur 1])
  content("cap1_0", text(size: 0.7em)[Cap. n])
  content("size1_0", text(size: 0.7em)[Tail. n])

  rect((6, -2), (8, -3), name: "obj11_0")
  rect((8, -2), (10, -3), name: "obj12_0")
  rect((10, -2), (12, -3), name: "obj13_0")
  rect((12, -2), (14, -3), name: "obj14_0")
  content("obj11_0", text(size: 0.7em)[Obj1])
  content("obj12_0", text(size: 0.7em)[Obj2])
  content("obj13_0", text(size: 0.7em)[...])
  content("obj14_0", text(size: 0.7em)[Objn])

  line((5, -1), (5, -2.5))
  line((5, -2.5), (6, -2.5))

  rect((16, 0), (20, -1), name: "vec2_0")
  rect((20, 0), (22, -1), name: "cap2_0")
  rect((22, 0), (24, -1), name: "size2_0")
  content("vec2_0", text(size: 0.7em)[Vecteur 2])
  content("cap2_0", text(size: 0.7em)[Cap. 0])
  content("size2_0", text(size: 0.7em)[Tail. 0])

  rect((18, -2), (20, -3), name: "obj21_0")
  content("obj21_0", text(size: 0.7em)[_null_])

  line((17, -1), (17, -2.5))
  line((17, -2.5), (18, -2.5))
})

== Sémantique de déplacement

- Déplacement

#cetz.canvas(length: 1em, {
  import cetz.draw: *

  // Grille pour le tracer, changer la couleur pour l'affiche ou pas
  grid(
    (0, 0),
    (30, -17),
    stroke: white,
  )

  rect((4, 0), (8, -1), name: "vec1_0")
  rect((8, 0), (10, -1), name: "cap1_0")
  rect((10, 0), (12, -1), name: "size1_0")
  content("vec1_0", text(size: 0.7em)[Vecteur 1])
  content("cap1_0", text(size: 0.7em)[Cap. n])
  content("size1_0", text(size: 0.7em)[Tail. n])

  rect((6, -2), (8, -3), name: "obj11_0")
  rect((8, -2), (10, -3), name: "obj12_0")
  rect((10, -2), (12, -3), name: "obj13_0")
  rect((12, -2), (14, -3), name: "obj14_0")
  content("obj11_0", text(size: 0.7em)[Obj1])
  content("obj12_0", text(size: 0.7em)[Obj2])
  content("obj13_0", text(size: 0.7em)[...])
  content("obj14_0", text(size: 0.7em)[Objn])

  line((5, -1), (5, -2.5))
  line((5, -2.5), (6, -2.5))

  rect((16, 0), (20, -1), name: "vec2_0")
  rect((20, 0), (22, -1), name: "cap2_0")
  rect((22, 0), (24, -1), name: "size2_0")
  content("vec2_0", text(size: 0.7em)[Vecteur 2])
  content("cap2_0", text(size: 0.7em)[Cap. 0])
  content("size2_0", text(size: 0.7em)[Tail. 0])

  rect((18, -2), (20, -3), name: "obj21_0")
  content("obj21_0", text(size: 0.7em)[_null_])

  line((17, -1), (17, -2.5))
  line((17, -2.5), (18, -2.5))

  rect((2, -3.1), (10, -3.9), name: "alloc", stroke: white)
  content("alloc", box(width: 8em, align(left)[#text(main_color, size: 0.7em)[Déplacement]]))

  rect((4, -4), (8, -5), name: "vec1_1")
  rect((8, -4), (10, -5), name: "cap1_1")
  rect((10, -4), (12, -5), name: "size1_1")
  content("vec1_1", text(size: 0.7em)[Vecteur 1])
  content("cap1_1", text(size: 0.7em)[Cap. 0])
  content("size1_1", text(size: 0.7em)[Tail. 0])

  rect((6, -6), (8, -7), name: "obj11_1")
  rect((8, -6), (10, -7), name: "obj12_1")
  rect((10, -6), (12, -7), name: "obj13_1")
  rect((12, -6), (14, -7), name: "obj14_1")
  content("obj11_1", text(size: 0.7em)[Obj1])
  content("obj12_1", text(size: 0.7em)[Obj2])
  content("obj13_1", text(size: 0.7em)[...])
  content("obj14_1", text(size: 0.7em)[Objn])

  line((5, -5), (5, -7.5))
  line((5, -7.5), (17.5, -7.5))
  line((17.5, -7.5), (17.5, -6.5))
  line((17.5, -6.5), (18, -6.5))

  rect((16, -4), (20, -5), name: "vec2_1")
  rect((20, -4), (22, -5), name: "cap2_1")
  rect((22, -4), (24, -5), name: "size2_1")
  content("vec2_1", text(size: 0.7em)[Vecteur 2])
  content("cap2_1", text(size: 0.7em)[Cap. n])
  content("size2_1", text(size: 0.7em)[Tail. n])

  rect((18, -6), (20, -7), name: "obj21_1")
  content("obj21_1", text(size: 0.7em)[_null_])

  line((17, -5), (17, -5.5))
  line((17, -5.5), (5.5, -5.5))
  line((5.5, -5.5), (5.5, -6.5))
  line((5.5, -6.5), (6, -6.5))
})

== Sémantique de déplacement

- _rvalue reference_
  - Référence sur un objet temporaire ou sur le point d'être détruit
  - Noté par une double esperluette : ```cpp T&& value```
- Deux fonctions de conversion
  - ```cpp std::move()``` convertit le paramètre en _rvalue_

  // std::move force la sémantique de déplacement sur l'objet}

  - ```cpp std::forward()``` convertit le paramètre en _rvalue_ s'il n'est pas une _lvalue reference_

#noteblock(text[_rvalue_, _lvalue_, ... ?], text[
  Voir #link("http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2012/n3337.pdf")[N3337 #linklogo() §3.10]
])

#noteblock(text[``` std::forward()``` ?], text[
  _perfect forwarding_ (Voir #link("http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2002/n1385.htm")[N1385 #linklogo()])
])

#addproposal("N2118")
#addproposal("n2439")
#addproposal("N2844")
#addproposal("N3053")

== Sémantique de déplacement

- Rendre une classe déplaçable
  - Constructeur par déplacement ```cpp T(const T&&)```
  - Opérateur d'affectation par déplacement ```cpp T& operator=(const T&&)```

#noteblock("Génération implicite", text[
  Pas de constructeur par copie, d'opérateur d'affectation, de destructeur, ni l'autre déplacement _user-declared_
])

#alertblock(text[_user-declared_ ? _user-provided_ ?], text[
  _user-declared_ : fonction déclarée par l'utilisateur, y compris ```cpp =default```

  _user-provided_ : corps de la fonction fourni par l'utilisateur
])

#addproposal("N2118")
#addproposal("n2439")
#addproposal("N2844")
#addproposal("N3053")

== Sémantique de déplacement

#noteblock(text[_Rule of five_], text[
  Si une classe déclare destructeur, constructeur par copie ou par déplacement, affectation par copie ou par déplacement, alors elle doit définir les cinq

  // Contrairement à Rule of three, l'absence des constructeur et opérateur d'affectation par déplacement n'est pas une erreur grave, mais une optimisation manquée
])

#noteblock(text[_Rule of zero_], text[
  Lorsque c'est possible, n'en définissez aucune

  // Rule of zero s'applique typiquement aux classes sans gestion explicite d'ownership, c'est à dire sans membres qu'il faut explicitement libérés, fermés, ... Ce qui devrait être le cas par défaut
])

#noteblock("Pour aller plus loin", text[
  Voir #link("https://github.com/cppp-france/CPPP-19/blob/master/elegance_style_epure_et_classe-Loic_Joly/elegance_style_epure_et_classe-Loic_Joly.pdf")[Élégance, style épuré et classe #linklogo() (Loïc Joly)]
])

#addproposal("N2118")
#addproposal("n2439")
#addproposal("N2844")
#addproposal("N3053")

== Sémantique de déplacement

#noteblock("Dans la bibliothèque standard", text[
  Nombreuses classes standards déplaçables (thread, flux, ...)
  // Mutex et lock ne sont pas copiables ni déplaçables

  Évolution de contraintes : déplaçable plutôt que copiable
  // Évolution des contraintes notamment pour les conteneurs et les algorithmes

  Implémentations utilisant le déplacement si possible
])

#addproposal("N2118")
#addproposal("n2439")
#addproposal("N2844")
#addproposal("N3053")

== Initializer list

- Initialisation des conteneurs

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B1,+56,+18,+3%7D%3B%0A%0A++std::cout+%3C%3C+foo.size()+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo;
    foo.push_back(1);
    foo.push_back(56);
    foo.push_back(18);
    foo.push_back(3);

    // Devient

    vector<int> foo{1, 56, 18, 3};
    ```
  ],
)

#addproposal("N2672")

== Initializer list

- Classe ```cpp std::initializer_list``` pour accéder aux valeurs de la liste

#alertblock("Accéder, pas contenir !", text[
  ```cpp std::initializer_list``` référence mais ne contient pas les valeurs

  Valeurs contenues dans un tableau temporaire de même durée de vie

  Copier un ```cpp std::initializer_list``` ne copie pas les données
])

- Fonctions membres ```cpp size()```, ```cpp begin()```, ```cpp end()```
- Construction automatique depuis une liste de valeurs entre accolades

#addproposal("N2672")

== Initializer list

- Constructeurs peuvent prendre un ```cpp std::initializer_list``` en paramètre

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cinitializer_list%3E%0A%0Astruct+Foo%0A%7B%0A++Foo(std::initializer_list%3Cint%3E+l)+:+m_vec(l)%0A++%7B%0A++++std::cout+%3C%3C+l.size()+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0A++void+append(std::initializer_list%3Cint%3E+l)%0A++%7B%0A++++for(std::initializer_list%3Cint%3E::iterator+it+%3D+l.begin()%3B+it+!!%3D+l.end()%3B+%2B%2Bit)%0A++++%7B%0A++++++m_vec.push_back(*it)%3B%0A++++%7D%0A++%7D%0A%0A++std::vector%3Cint%3E+m_vec%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++Foo+foo+%3D+%7B1,+2,+3,+4,+5%7D%3B%0A++for(size_t+i+%3D+0%3B+i+%3C+foo.m_vec.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+foo.m_vec%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%0A++foo.append(%7B6,+7,+8%7D)%3B%0A++for(size_t+i+%3D+0%3B+i+%3C+foo.m_vec.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+foo.m_vec%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    MaClasse(initializer_list<value_type> itemList);
    ```
  ],
)

- Ainsi que toute autre fonction
- Intégré aux conteneurs de la bibliothèque standard

#addproposal("N2672")

== Initializer list

#adviceblock("Do", text[
  Préférez ```cpp std::initializer_list``` aux insertions successives
])

#alertblock("Don't", text[
  N'utilisez pas ```cpp std::initializer_list``` pour copier ou transformer

  Utilisez les algorithmes et constructeurs idoines
])

#addproposal("N2672")

== Uniform Initialization

- Plusieurs types d'initialisation en C++98/03

```cpp
int a = 2;
int b(2);
int c[] = {1, 2, 3};
int d;
```

== Uniform Initialization

- Mais aucune de générique

```cpp
int a(2);        // Definition de l'entier a
int b();         // Declaration d'une fonction
int c(foo);      // ???
int d[] (1, 2);  // KO
```

```cpp
int a[] = {1, 2, 3};        // OK

struct Foo { int a; };
Foo foo = {1};              // OK

vector<int> b = {1, 2, 3};  // KO
int c{8}                    // KO
```

// L'initialisation de Foo fonctionne car c'est un POD (pas de classe de base, pas de virtuel, etc.)

== Uniform Initialization

- En C++ 11, l'initialisation via ```cpp {}``` est générique

```cpp
int a[] = {1, 2, 3};         // OK
Foo b = {5};                 // OK
vector<int> c = {1, 2, 3};   // OK
int d = {8};                 // OK
int e = {};                  // OK
```

- Avec ou sans ```cpp =```

```cpp
int a[]{1, 2, 3};            // OK
Foo b{5};                    // OK
vector<int> c{1, 2, 3};      // OK
int d{8};                    // OK
int e{};                     // OK
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Astruct+Foo+%0A%7B%0A++int+foo%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++int+a%5B%5D+%3D+%7B1,+2,+3%7D%3B%0A++Foo+b+%3D+%7B5%7D%3B%0A++std::vector%3Cint%3E+c+%3D+%7B1,+2,+3%7D%3B%0A++int+d%7B8%7D%3B%0A++int+e%7B%7D%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra+-Wno-unused-variable+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Uniform Initialization

- Dans différents contextes

```cpp
int* p = new int{4};
long l = long{2};

void f(int);
f({2});
```

== Uniform Initialization

#alertblock("Attention", text[
  Pas de troncature avec ```cpp {}```

  ```cpp
  int foo{2.5};  // Erreur
  ```
])

#alertblock("Attention", text[
  Si le constructeur par ```cpp std::initializer_list``` existe, il est utilisé

  ```cpp
  vector<int> foo{2};  // 2
  vector<int> foo(2);  // 0 0
  ```
])

== Uniform Initialization

#alertblock("Contraintes sur l'initialisation d'agrégats", text[
  Pas d'héritage

  Pas de constructeur fourni par l'utilisateur

  Pas d'initialisation _brace-or-equal-initializers_

  Pas de fonction virtuelle ni de membre non statique protégé ou privé
])

#adviceblock("Do", text[
  Préférez l'initialisation ```cpp {}``` aux autres formes
])

== ``` auto```

- Déduction (ou inférence) de type depuis l'initialisation

#alertblock("Attention", text[
  Inférence de type $eq.not$ typage dynamique

  Inférence de type $eq.not$ typage faible

  Typage dynamique $eq.not$ typage faible
])

#noteblock("Vocabulaire", text[
  Statique : type porté par la variable et ne varie pas

  Dynamique : type porté par la valeur

  Absence : variable non typée, type imposé par l'opération
])

#addproposal("N1984")
#addproposal("n1737")
#addproposal("n2546")

== ``` auto```

- ```cpp auto``` définit une variable dont le type est déduit

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ctypeinfo%3E%0A%23include+%3Ccassert%3E%0A%0Aint+main()%0A%7B%0A++auto+i+%3D+2%3B+%0A++assert(typeid(i)+%3D%3D+typeid(int))%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    auto i = 2;  // int
    ```
  ],
)

- Règles de déduction proches de celles des templates
- Listes entre accolades inférées comme des ```cpp std::initializer_list```

#alertblock("Attention", text[
  Référence, ```cpp const``` et ```cpp volatile``` perdus durant la déduction

  ```cpp
  const int i = 2;
  auto j = i;  // int
  ```
])

#addproposal("N1984")
#addproposal("n1737")
#addproposal("n2546")

== ``` auto```

- Combinaison possible avec ```cpp const```, ```cpp volatile``` ou ```cpp &```

```cpp
const auto i = 2;

int j = 3;
auto& k = j;
```

- Typer explicitement l'initialiseur permet de forcer le type déduit

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ctypeinfo%3E%0A%23include+%3Ccassert%3E%0A%0Aint+main()%0A%7B%0A++auto+i+%3D+static_cast%3Cunsigned+long%3E(2)%3B%0A++assert(typeid(i)+%3D%3D+typeid(unsigned+long))%3B%0A++%0A++auto+j+%3D+2UL%3B%0A++assert(typeid(j)+%3D%3D+typeid(unsigned+long))%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    // unsigned long
    auto i = static_cast<unsigned long>(2);
    auto j = 2UL
    ```
  ],
)

#addproposal("N1984")
#addproposal("n1737")
#addproposal("n2546")

== ``` auto```

- Tendance forte "Almost Always Auto" (AAA)

#noteblock("Pour aller plus loin", text[
  Voir #link("https://herbsutter.com/2013/08/12/gotw-94-solution-aaa-style-almost-always-auto/")[GotW 94 : AAA Style #linklogo()]
])

- Plusieurs avantages
  - Variables forcément initialisées
  - Typage correct et précis
  - Garanties conservées au fil des corrections et refactoring
  - Généricité et simplification du code

#noteblock("Quiz", text[
  Type de retour de ```cpp std::list<std::string>::size()``` ?
])

#addproposal("N1984")
#addproposal("n1737")
#addproposal("n2546")

== ``` auto```

- Limitations - solutions
  - Erreur de déduction - typage explicite de l'initialiseur
  - Initialisation impossible - ```cpp decltype```
  - Interfaces, rôles, contexte - concepts ?

//Mais il faut attendre C++20 pour avoir les concepts

#alertblock("Compatibilité", text[
  ```cpp auto``` présent en C++98/03 avec un sens radicalement différent

  // Sens en C++98/03 : variable de type automatique (c'est à dire sur la pile) par opposition à statique (cas par défaut et donc inutilisé en pratique)
])

#addproposal("N1984")
#addproposal("n1737")
#addproposal("n2546")

== ``` decltype```

- Déduction du type d'une variable ou d'une expression
- Permet donc la création d'une variable du même type

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ctypeinfo%3E%0A%23include+%3Ccassert%3E%0A%0Aint+main()%0A%7B%0A++int+a%3B%0A++long+b%3B%0A%0A++decltype+(a)+c%3B%0A++decltype+(a+%2B+b)+d%3B%0A%0A++assert(typeid(c)+%3D%3D+typeid(int))%3B%0A++assert(typeid(d)+%3D%3D+typeid(long))%3B%0A%0A%23if+0%0A++decltype(+(a)+)+e%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    int a;
    long b;

    decltype(a) c;         // int
    decltype(a + b) d;     // long
    ```
  ],
)

- Généralement, déduction sans aucune modification du type
// Donc conservation des références, const, etc.
- Depuis une _lvalue_ de type ```cpp T``` autre qu'un nom de variable : ```cpp T&```

```cpp
decltype( (a) ) e;     // int&
```

#addproposal("N2343")
#addproposal("N3276")

== ``` declval```

- Utilisation de fonctions membres dans ```cpp decltype``` sans instance
- Typiquement sur des templates acceptant des types sans constructeur commun mais avec une fonction membre commune

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Cutility%3E%0A%23include+%3Ctypeinfo%3E%0A%23include+%3Ccassert%3E%0A%0Astruct+foo%0A%7B%0A++foo(const+foo%26)+%7B%7D%0A++int+bar()+const+%7B+return+1%3B+%7D%0A%7D%3B%0A%0Aint+main()%0A%7B%0A%23if+0%0A++decltype(foo().bar())+a+%3D+5%3B%0A%23endif%0A++decltype(std::declval%3Cfoo%3E().bar())+b+%3D+5%3B%0A%0A++assert(typeid(b)+%3D%3D+typeid(int))%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    struct foo {
      foo(const foo&) {}
      int bar () const { return 1; }
    };

    decltype(foo().bar()) a = 5;               // Erreur
    decltype(std::declval<foo>().bar()) b = 5; // OK, int
    ```
  ],
)

#alertblock("Attention", text[
  Uniquement dans des contextes non évalués
])

== Déduction du type retour

- Combinaison de ```cpp auto``` et ```cpp decltype```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Cutility%3E%0A%23include+%3Ctypeinfo%3E%0A%23include+%3Ccassert%3E%0A%0Aauto+add(int+a,+int+b)+-%3E+decltype(a+%2B+b)+%0A%7B%0A++return+a+%2B+b%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++auto+i+%3D+add(1,+3)%3B%0A++assert(typeid(i)+%3D%3D+typeid(int))%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    auto add(int a, int b) -> decltype(a + b) {
      return a + b;
    }
    ```
  ],
)

- Particulièrement utiles pour des fonctions templates

#noteblock(text[Quiz : ``` T```, ``` U``` ou autre ?], text[
  ```cpp
  template<typename T, typename U> ??? add(T a, U b) {
    return a + b;
  }
  ```
])

#addproposal("n2541")

== Déduction du type retour

#noteblock("Solution", text[
  Pas de bonne réponse en typage explicite
  // Une solution historique : un seul type template et on compte sur les conversions implicites voire on demande des conversions explicites

  Mais l'inférence de type vient à notre secours
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Cutility%3E%0A%23include+%3Ctypeinfo%3E%0A%23include+%3Ccassert%3E%0A%0Atemplate%3Ctypename+T,+typename+U%3E%0Aauto+add(T+a,+U+b)+-%3E+decltype(a+%2B+b)%0A%7B%0A++return+a+%2B+b%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++auto+i+%3D+add(1UL,+3)%3B%0A++assert(typeid(i)+%3D%3D+typeid(unsigned+long))%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    template<typename T, typename U>
    auto add(T a, U b) -> decltype(a + b) {
      return a + b;
    }
    ```
  ],
)

#adviceblock("do", text[
  Utilisez la déduction du type retour dans vos fonctions templates
])

#addproposal("n2541")

== ``` std::array```

- ```cpp std::array```
  - Tableau de taille fixe connue à la compilation
  - Éléments contigus
  - Accès indexé

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:6,endLineNumber:7,positionColumn:6,positionLineNumber:7,selectionStartColumn:6,selectionStartLineNumber:7,startColumn:6,startLineNumber:7),source:'%23include+%3Ciostream%3E%0A%23include+%3Carray%3E%0A%23include+%3Cnumeric%3E%0A%0Aint+main()%0A%7B%0A%23if+1%0A++std::array%3Cint,+8%3E+foo%7B2,+5,+9,+8,+2,+6,+8,+9%7D%3B%0A%23else%0A++std::array%3Cint,+8%3E+foo%7B2,+5,+9,+8,+2,+6,+8,+9,+17%7D%3B%0A%23endif%0A++std::cout+%3C%3C+std::accumulate(foo.begin(),+foo.end(),+0)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    array<int, 8> foo{2, 5, 9, 8, 2, 6, 8, 9};

    accumulate(foo.begin(), foo.end(), 0); // 49
    ```
  ],
)

```cpp
array<int, 8> foo{2, 5, 9, 8, 2, 6, 8, 9, 17};
// Erreur de compilation
```

#addproposal("n1836")

== ``` std::array```

#list(marker: [], list(indent: 5pt, text[Vérification des index à la compilation]))

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Carray%3E%0A%0Aint+main()%0A%7B%0A++std::array%3Cint,+8%3E+foo%7B2,+5,+9,+8,+2,+6,+8,+9%7D%3B%0A++std::cout+%3C%3C+std::get%3C2%3E(foo)+%3C%3C+!'%5Cn!'%3B%0A%23if+0%0A++std::cout+%3C%3C+std::get%3C8%3E(foo)+%3C%3C+!'%5Cn!'%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    array<int, 8> foo{2, 5, 9, 8, 2, 6, 8, 9};

    get<2>(foo);  // 9
    get<8>(foo);  // Erreur de compilation
    ```
  ],
)

#addproposal("n1836")

== ``` std::forward_list```

- Liste simplement chaînée ```cpp std::forward_list```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cforward_list%3E%0A%23include+%3Cnumeric%3E%0A%0Aint+main()%0A%7B%0A++std::forward_list%3Cint%3E+foo%7B2,+5,+9,+8,+2,+6,+8,+9,+12%7D%3B%0A%0A++std::cout+%3C%3C+std::accumulate(foo.begin(),+foo.end(),+0)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    forward_list<int> foo{2, 5, 9, 8, 2, 6, 8, 9, 12};

    accumulate(foo.begin(), foo.end(), 0); // 61
    ```
  ],
)

#addproposal("n1836")

== Conteneurs associatifs

- Conteneurs associatifs sous forme de tables de hachage
  - ```cpp std::unordered_map```
  - ```cpp std::unordered_multimap```
  - ```cpp std::unordered_set```
  - ```cpp std::unordered_multiset```
- Versions non ordonnées de ```cpp std::map```, ```cpp std::set```, ...

#noteblock(text[Pourquoi ``` unordered_``` ?], text[
  Nombreuses implémentations ```cpp hash_``` existantes

  Structures fondamentalement non ordonnées
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%23include+%3Cunordered_map%3E%0A%0Aint+main()%0A%7B%0A++std::unordered_map%3Cint,+std::string%3E+foo%7B%7B5,+%22Une+chaine%22%7D,+%7B42,+%22La+reponse%22%7D%7D%3B%0A%0A++std::cout+%3C%3C++foo%5B42%5D+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("n1836")

== ``` shrink_to_fit()```

- ```cpp shrink_to_fit()``` réduit la capacité des ```cpp std::vector```, ```cpp std::deque``` et ```cpp std::string``` à leur taille
// Pour être précis, ce n'est pas nécessairement exactement à la taille ça peut être plus grand - à la discrétion de l'implémentation (performances, cohérence, ...) -, mais l'idée est là

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B12,+25%7D%3B%0A++foo.reserve(15)%3B%0A++std::cout+%3C%3C+foo.size()+%3C%3C+%22+/+%22+%3C%3C+foo.capacity()+%3C%3C+!'%5Cn!'%3B%0A%0A++foo.shrink_to_fit()%3B%0A++std::cout+%3C%3C+foo.size()+%3C%3C+%22+/+%22+%3C%3C+foo.capacity()+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo{12, 25};

    foo.reserve(15);      // Taille : 2, capacité : 15
    foo.shrink_to_fit();  // Taille : 2, capacité : 2
    ```
  ],
)

== ``` data()```

- ```cpp data()``` récupère le "tableau C" d'un ```cpp std::vector```

#noteblock(text[``` foo.data()``` ou ``` &foo[0]``` ?], text[
  Comportement identique

  Préférez ```cpp foo.data()``` à la sémantiquement plus clair
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Avoid+bar(const+int*+data,+const+size_t+size)%0A%7B%0A++for(size_t+i+%3D+0%3B+i+%3C+size%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+data%5Bi%5D+%3C%3C+%22%5Cn%22%3B%0A++%7D%0A%7D%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B12,+25%7D%3B%0A%0A++bar(foo.data(),+foo.size())%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== ``` emplace()```

- ```cpp emplace()```, ```cpp emplace_back()``` et ```cpp emplace_front()``` construisent dans le conteneur depuis les paramètres d'un des constructeurs de l'élément

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Aclass+Point+%0A%7B%0Apublic:%0A++Point(int+a,+int+b)%0A++++:+m_a(a)%0A++++,+m_b(b)%0A++%7B%0A++%7D%0A%0A++int+m_a%3B%0A++int+m_b%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++std::vector%3CPoint%3E+foo%3B%0A++foo.emplace_back(2,+5)%3B%0A%0A++std::cout+%3C%3C+foo%5B0%5D.m_a+%3C%3C+%22+%22+%3C%3C+foo%5B0%5D.m_b+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    class Point {
    public:
      Point(int a, int b);
    };

    vector<Point> foo;
    foo.emplace_back(2, 5);
    ```
  ],
)

#noteblock("Objectif", text[
  Éliminer des copies inutiles et gagner en performance
])

== ``` std::string```

- Évolutions de ```cpp std::string```
  - Éléments obligatoirement contigus
  - ```cpp data()``` retourne une chaîne C valide (synonyme à ```cpp c_str()```)
  // En C++98, data() renvoyait les caractères de la chaîne mais pas nécessairement sous forme d'une chaîne C valide (pas obligatoirement de 0 terminal)
  - ```cpp front()``` retourne le premier caractère d'une chaîne
  - ```cpp back()``` retourne le dernier caractère d'une chaîne
  - ```cpp pop_back()``` supprime le dernier caractère d'une chaîne
  - Interdiction du _Copy-on-Write_

== ``` std::bitset```

- Évolutions de ```cpp std::bitset```
  - ```cpp all()``` teste si tous les bits sont levés
  - ```cpp to_ullong()``` convertit en ```cpp unsigned long long```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cbitset%3E%0A%0Aint+main()%0A%7B%0A++std::bitset%3C5%3E+foo%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+foo.all()+%3C%3C+!'%5Cn!'%3B%0A%0A++foo.set(2)%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+foo.all()+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+foo.to_ullong()+%3C%3C+!'%5Cn!'%3B%0A%0A++foo.set()%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+foo.all()+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+foo.to_ullong()+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    bitset<5> foo;
    foo.all();        // False

    foo.set(2);
    foo.to_ullong();  // 4

    foo.set();
    foo.all();        // True
    foo.to_ullong();  // 31
    ```
  ],
)

== Conteneurs - Choix

#adviceblock("Do", text[
  Préférez ```cpp std::array``` lorsque la taille est fixe et connue
])

#adviceblock("Do", text[
  Sinon préférez ```cpp std::vector```
])

== Itérateurs

- Fonctions membres ```cpp cbegin()```, ```cpp cend()```, ```cpp crbegin()``` et ```cpp crend()``` retournant des ```cpp const_iterator```
// Les fonctions begin(), end(), etc. retournent des const_iterator si le conteneur est const, des iterator dans le cas contraire
- Fonctions libres ```cpp std::begin()``` et ```cpp std::end()```
  - Conteneur : appel des fonctions membres
  - Tableau C : adresse du premier élément et suivant le dernier élément

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cnumeric%3E%0A%0Ausing+std::begin%3B%0Ausing+std::end%3B%0A%0Aint+main()%0A%7B%0A++int+foo%5B%5D+%3D+%7B1,+2,+3,+4%7D%3B%0A++std::vector%3Cint%3E+bar%7B2,+3,+4,+5%7D%3B%0A%0A++std::cout+%3C%3C+std::accumulate(begin(foo),+end(foo),+0)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::accumulate(begin(bar),+end(bar),+0)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    int foo[] = {1, 2, 3, 4};
    vector<int> bar{2, 3, 4, 5};

    accumulate(begin(foo), end(foo), 0);  // 10
    accumulate(begin(bar), end(bar), 0);  // 14
    ```
  ],
)

== Itérateurs

#list(
  marker: [],
  list(indent: 5pt, text[Compatibles avec les conteneurs non-STL proposant ```cpp begin()``` et ```cpp end()```]),
  list(indent: 5pt, text[Surchargeable sans modification du conteneur pour les autres]),
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cnumeric%3E%0A%0Ausing+std::begin%3B%0Ausing+std::end%3B%0A%0Aclass+Foo+%0A%7B%0Apublic:%0A++int*+first()+%7B+return+std::begin(m_data)%3B+%7D%3B%0A++int*+last()+%7B+return+std::end(m_data)%3B+%7D%3B%0A%0Aprivate:%0A++static+int+m_data%5B3%5D%3B%0A%7D%3B%0A%0Aint+Foo::m_data%5B3%5D+%3D+%7B5,+8,+12%7D%3B%0A%0Aint*+begin(Foo%26+foo)%0A%7B%0A++return+foo.first()%3B%0A%7D%0A%0Aint*+end(Foo%26+foo)%0A%7B%0A++return+foo.last()%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++Foo+foo%3B%0A%0A++std::cout+%3C%3C+std::accumulate(begin(foo),+end(foo),+0)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    class Foo {
    public:
      int* first();
      const int* first() const;
    };

    int* begin(Foo& foo) {
      return foo.first();
    }

    const int* begin(const Foo& foo) {
      return foo.first();
    }
    ```
  ],
)

== Itérateurs

#noteblock("Conseils", text[
  ```cpp using std::begin``` et ```cpp using std::end``` permet l'ADL malgré la surcharge
])

#alertblock("Don't", text[
  N'ouvrez pas le namespace ```cpp std``` pour spécialiser
])

#adviceblock("Do", text[
  Préférez ```cpp std::begin()``` et ```cpp std::end()``` aux fonctions membres
])

== Itérateurs

- ```cpp std::prev()``` et ```cpp std::next()``` retournent l'itérateur suivant ou précédent
- Adaptateur d'itérateur ```cpp std::move_iterator``` retournant des _rvalue reference_ lors du déréférencement

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:25,positionColumn:1,positionLineNumber:25,selectionStartColumn:1,selectionStartLineNumber:25,startColumn:1,startLineNumber:25),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cstring%3E%0A%23include+%3Calgorithm%3E%0A%0Atypedef+std::vector%3Cstd::string%3E::iterator+Iter%3B%0A%0Aint+main()%0A%7B%0A++std::vector%3Cstd::string%3E+foo(3)%3B%0A++std::vector%3Cstd::string%3E+bar%7B%22one%22,%22two%22,%22three%22%7D%3B%0A++std::copy(std::move_iterator%3CIter%3E(bar.begin()),+std::move_iterator%3CIter%3E(bar.end()),+foo.begin())%3B%0A%0A++for(size_t+i+%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+%22!'%22+%3C%3C+foo%5Bi%5D+%3C%3C+%22!'+%22%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A++for(size_t+i+%3D+0%3B+i+%3C+bar.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+%22!'%22+%3C%3C+bar%5Bi%5D+%3C%3C+%22!'+%22%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:55.14360313315927,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:44.85639686684073,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<string> foo(3), bar{"one","two","three"};

    typedef vector<string>::iterator Iter;

    copy(move_iterator<Iter>(bar.begin()),
         move_iterator<Iter>(bar.end()),
         foo.begin());
    // foo : "one" "two" "three"
    // bar : "" "" ""
    ```
  ],
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cstring%3E%0A%0Atypedef+std::vector%3Cstd::string%3E::iterator+Iter%3B%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B5,+3,+8,+12%7D%3B%0A%0A++auto+it+%3D+std::begin(foo)%3B%0A++std::cout+%3C%3C+*it+%3C%3C+%22+%22+%3C%3C+*next(it)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:55.14360313315927,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:44.85639686684073,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Foncteurs prédéfinis

- Et bit à bit ```cpp std::bit_and()```
- Ou inclusif bit à bit ```cpp std::bit_or()```
- Ou exclusif bit à bit ```cpp std::bit_xor()```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:20,positionColumn:1,positionLineNumber:20,selectionStartColumn:1,selectionStartLineNumber:20,startColumn:1,startLineNumber:20),source:'%23include+%3Ciostream%3E%0A%23include+%3Ciomanip%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cunsigned+char%3E+foo%7B0x10,+0x20,+0x30%7D%3B%0A++std::vector%3Cunsigned+char%3E+bar%7B0xFF,+0x25,+0x00%7D%3B%0A++std::vector%3Cunsigned+char%3E+baz%3B%0A%0A++std::transform(std::begin(foo),+std::end(foo),+std::begin(bar),+std::back_inserter(baz),+std::bit_and%3Cunsigned+char%3E())%3B%0A%0A++for(size_t+i+%3D+0%3B+i+%3C+baz.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+std::hex+%3C%3C+std::setfill(!'0!')+%3C%3C+std::setw(2)+%3C%3C+static_cast%3Cunsigned+int%3E(baz%5Bi%5D)+%3C%3C+%22+%22%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:55.14360313315927,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:44.85639686684073,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<unsigned char> foo{0x10, 0x20, 0x30};
    vector<unsigned char> bar{0xFF, 0x25, 0x00};
    vector<unsigned char> baz;

    transform(begin(foo), end(foo), begin(bar), back_inserter(baz),
              bit_and<unsigned char>());  // baz : 0x10, 0x20, 0x00
    ```
  ],
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:19,positionColumn:1,positionLineNumber:19,selectionStartColumn:1,selectionStartLineNumber:19,startColumn:1,startLineNumber:19),source:'%23include+%3Ciostream%3E%0A%23include+%3Ciomanip%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cunsigned+char%3E+foo%7B0x10,+0x20,+0x30%7D%3B%0A++std::vector%3Cunsigned+char%3E+bar%7B0xFF,+0x25,+0x00%7D%3B%0A++std::vector%3Cunsigned+char%3E+baz%3B%0A++std::transform(std::begin(foo),+std::end(foo),+std::begin(bar),+std::back_inserter(baz),+std::bit_or%3Cunsigned+char%3E())%3B%0A%0A++for(size_t+i+%3D+0%3B+i+%3C+baz.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+std::hex+%3C%3C+std::setfill(!'0!')+%3C%3C+std::setw(2)+%3C%3C+static_cast%3Cunsigned+int%3E(baz%5Bi%5D)+%3C%3C+%22+%22%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:55.14360313315927,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:44.85639686684073,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    transform(begin(foo), end(foo), begin(bar), back_inserter(baz),
              bit_or<unsigned char>());   // baz : 0xFF, 0x25, 0x30
    ```
  ],
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:20,positionColumn:1,positionLineNumber:20,selectionStartColumn:1,selectionStartLineNumber:20,startColumn:1,startLineNumber:20),source:'%23include+%3Ciostream%3E%0A%23include+%3Ciomanip%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cunsigned+char%3E+foo%7B0x10,+0x20,+0x30%7D%3B%0A++std::vector%3Cunsigned+char%3E+bar%7B0xFF,+0x25,+0x00%7D%3B%0A++std::vector%3Cunsigned+char%3E+baz%3B%0A%0A++std::transform(std::begin(foo),+std::end(foo),+std::begin(bar),+std::back_inserter(baz),+std::bit_xor%3Cunsigned+char%3E())%3B%0A%0A++for(size_t+i+%3D+0%3B+i+%3C+baz.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+std::hex+%3C%3C+std::setfill(!'0!')+%3C%3C+std::setw(2)+%3C%3C+static_cast%3Cunsigned+int%3E(baz%5Bi%5D)+%3C%3C+%22+%22%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:55.14360313315927,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'1',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:44.85639686684073,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    transform(begin(foo), end(foo), begin(bar), back_inserter(baz),
              bit_xor<unsigned char>());  // baz : 0xEF, 0x05, 0x30
    ```
  ],
)

== Algorithmes -- Recherche linéaire

- ```cpp std::find_if_not()``` recherche le premier élément ne vérifiant pas le prédicat

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Astatic+bool+is_odd(int+i)%0A%7B%0A++return+(i+%25+2)+%3D%3D+1%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B1,+4,+5,+9,+12%7D%3B%0A++std::cout+%3C%3C+*std::find_if_not(std::begin(foo),+std::end(foo),+is_odd)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:55.14360313315927,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:44.85639686684073,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo{1, 4, 5, 9, 12};

    find_if_not(begin(foo), end(foo), is_odd); // 4
    ```
  ],
)

== Algorithmes -- Comparaison

- ```cpp std::all_of()``` teste si tous les éléments de l'ensemble vérifient un prédicat
- Retourne vrai si l'ensemble est vide

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Ausing+std::begin%3B%0Ausing+std::end%3B%0A%0Astatic+bool+is_odd(int+i)%0A%7B%0A++return+(i+%25+2)+%3D%3D+1%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B1,+4,+5,+9,+12%7D%3B%0A++++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::all_of(begin(foo),+end(foo),+is_odd)+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B1,+5,+9%7D%3B%0A++++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::all_of(begin(foo),+end(foo),+is_odd)+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B4,+12%7D%3B%0A++++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::all_of(begin(foo),+end(foo),+is_odd)+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo{1, 4, 5, 9, 12};
    vector<int> bar{1, 5, 9};
    vector<int> baz{4, 12};

    all_of(begin(foo), end(foo), is_odd); // False
    all_of(begin(bar), end(bar), is_odd); // True
    all_of(begin(baz), end(baz), is_odd); // False
    ```
  ],
)

== Algorithmes -- Comparaison

- ```cpp std::any_of()``` teste si au moins un élément vérifie un prédicat
- Retourne faux si l'ensemble est vide

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Ausing+std::begin%3B%0Ausing+std::end%3B%0A%0Astatic+bool+is_odd(int+i)%0A%7B%0A++return+(i+%25+2)+%3D%3D+1%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B1,+4,+5,+9,+12%7D%3B%0A++++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::any_of(begin(foo),+end(foo),+is_odd)+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B1,+5,+9%7D%3B%0A++++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::any_of(begin(foo),+end(foo),+is_odd)+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B4,+12%7D%3B%0A++++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::any_of(begin(foo),+end(foo),+is_odd)+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo{1, 4, 5, 9, 12};
    vector<int> bar{1, 5, 9};
    vector<int> baz{4, 12};

    any_of(begin(foo), end(foo), is_odd); // True
    any_of(begin(bar), end(bar), is_odd); // True
    any_of(begin(baz), end(baz), is_odd); // False
    ```
  ],
)

== Algorithmes -- Comparaison

- ```cpp std::none_of()``` teste si aucun élément ne vérifie le prédicat
- Retourne vrai si l'ensemble est vide

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Ausing+std::begin%3B%0Ausing+std::end%3B%0A%0Astatic+bool+is_odd(int+i)%0A%7B%0A++return+(i+%25+2)+%3D%3D+1%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B1,+4,+5,+9,+12%7D%3B%0A++++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::none_of(begin(foo),+end(foo),+is_odd)+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B1,+5,+9%7D%3B%0A++++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::none_of(begin(foo),+end(foo),+is_odd)+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B4,+12%7D%3B%0A++++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::none_of(begin(foo),+end(foo),+is_odd)+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo{1, 4, 5, 9, 12};
    vector<int> bar{1, 5, 9};
    vector<int> baz{4, 12};

    none_of(begin(foo), end(foo), is_odd); // False
    none_of(begin(bar), end(bar), is_odd); // False
    none_of(begin(baz), end(baz), is_odd); // True
    ```
  ],
)

== Algorithmes -- Permutation

- ```cpp std::is_permutation()``` teste si un ensemble est la permutation d'un autre

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Ausing+std::begin%3B%0Ausing+std::end%3B%0A%0Aint+main()%0A%7B%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B1,+4,+5,+9,+12%7D%3B%0A++++std::vector%3Cint%3E+bar%7B5,+4,+12,+9,+1%7D%3B%0A%0A++++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_permutation(begin(foo),+end(foo),+begin(bar))+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B1,+4,+5,+9,+12%7D%3B%0A++++std::vector%3Cint%3E+bar%7B5,+4,+12,+7,+1%7D%3B%0A%0A++++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_permutation(begin(foo),+end(foo),+begin(bar))+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo{1, 4, 5, 9, 12};
    vector<int> bar{1, 5, 4, 9, 12};
    vector<int> baz{5, 4, 3, 9, 1};

    is_permutation(begin(foo), end(foo), begin(bar)); // true
    is_permutation(begin(foo), end(foo), begin(baz)); // false
    ```
  ],
)

== Algorithmes -- Copie

- ```cpp std::copy_n()``` copie les n premiers éléments d'un ensemble

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:18,positionColumn:1,positionLineNumber:18,selectionStartColumn:1,selectionStartLineNumber:18,startColumn:1,startLineNumber:18),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B1,+4,+5,+9,+12%7D%3B%0A++std::vector%3Cint%3E+bar%3B%0A%0A++std::copy_n(std::begin(foo),+4,+std::back_inserter(bar))%3B%0A%0A++for(size_t+i+%3D+0%3B+i+%3C+bar.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+bar%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo{1, 4, 5, 9, 12}, bar;

    copy_n(begin(foo), 3, back_inserter(bar));
    // 1 4 5
    ```
  ],
)

- ```cpp std::copy_if()``` copie les éléments vérifiant un prédicat

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:23,positionColumn:1,positionLineNumber:23,selectionStartColumn:1,selectionStartLineNumber:23,startColumn:1,startLineNumber:23),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Astatic+bool+is_odd(int+i)%0A%7B%0A++return+(i+%25+2)+%3D%3D+1%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B1,+4,+5,+9,+12%7D%3B%0A++std::vector%3Cint%3E+bar%3B%0A%0A++std::copy_if(std::begin(foo),+std::end(foo),+std::back_inserter(bar),+is_odd)%3B%0A%0A++for(size_t+i+%3D+0%3B+i+%3C+bar.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+bar%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo{1, 4, 5, 9, 12}, bar;

    copy_if(begin(foo), end(foo), back_inserter(bar), is_odd);
    // 1 5 9
    ```
  ],
)

== Algorithmes -- Déplacement

- ```cpp std::move()``` déplace les éléments d'un ensemble du début vers la fin

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cstring%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cstd::string%3E+foo%7B%22aa%22,+%22bb%22,+%22cc%22%7D%3B%0A++std::vector%3Cstd::string%3E+bar%3B%0A%0A++std::move(std::begin(foo),+std::end(foo),+std::back_inserter(bar))%3B%0A%0A++for(size_t+i+%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+%22!'%22+%3C%3C+foo%5Bi%5D+%3C%3C+%22!'+%22%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A++for(size_t+i+%3D+0%3B+i+%3C+bar.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+%22!'%22+%3C%3C+bar%5Bi%5D+%3C%3C+%22!'+%22%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<string> foo{"aa", "bb", "cc"};
    vector<string> bar;

    move(begin(foo), end(foo), back_inserter(bar));
    // foo : "", "", ""
    // bar : "aa", "bb", "cc"
    ```
  ],
)

- ```cpp std::move_backward()``` déplace les éléments de la fin vers le début
- Versions "déplacement" de ```cpp std::copy()``` et ```cpp std::copy_backward()```

== Algorithmes -- Partitionnement

- ```cpp std::is_partitioned()``` indique si un ensemble est partitionné
// C'est à dire si les éléments vérifiant un prédicat sont avant ceux ne le vérifiant pas

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Astatic+bool+is_odd(int+i)%0A%7B%0A++return+(i+%25+2)+%3D%3D+1%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B4,+5,+9,+12%7D%3B%0A++std::vector%3Cint%3E+bar%7B9,+5,+4,+12%7D%3B%0A%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_partitioned(std::begin(foo),+std::end(foo),+is_odd)+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_partitioned(std::begin(bar),+std::end(bar),+is_odd)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo{4, 5, 9, 12};
    vector<int> bar{9, 5, 4, 12};

    is_partitioned(begin(foo), end(foo), is_odd); // false
    is_partitioned(begin(bar), end(bar), is_odd); // true
    ```
  ],
)

== Algorithmes -- Partitionnement

- ```cpp std::partition_copy()``` copie l'ensemble en le partitionnant
- ```cpp std::partition_point()``` retourne le point de partition d'un ensemble partitionné
  - C'est à dire le premier élément ne vérifiant pas le prédicat

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Astatic+bool+is_odd(int+i)%0A%7B%0A++return+(i+%25+2)+%3D%3D+1%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B9,+5,+4,+12%7D%3B%0A%0A++std::cout+%3C%3C+*std::partition_point(std::begin(foo),+std::end(foo),+is_odd)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo{9, 5, 4, 12};

    partition_point(begin(foo), end(foo), is_odd); // 4
    ```
  ],
)

== Algorithmes -- Tri

- ```cpp std::is_sorted()``` indique si l'ensemble est ordonnée (ordre ascendant)
// Possibilité de fournir un foncteur de comparaison (< par défaut)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:13,positionColumn:1,positionLineNumber:13,selectionStartColumn:1,selectionStartLineNumber:13,startColumn:1,startLineNumber:13),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B4,+5,+9,+12%7D%3B%0A++std::vector%3Cint%3E+bar%7B9,+5,+4,+12%7D%3B%0A%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_sorted(std::begin(foo),+std::end(foo))+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_sorted(std::begin(bar),+std::end(bar))+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo{4, 5, 9, 12};
    vector<int> bar{9, 5, 4, 12};

    is_sorted(begin(foo), end(foo)); // true
    is_sorted(begin(bar), end(bar)); // false
    ```
  ],
)

- ```cpp std::is_sorted_until()``` détermine le premier élément mal placé

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B4,+5,+9,+3,+12%7D%3B%0A%0A++std::cout+%3C%3C+*std::is_sorted_until(std::begin(foo),+std::end(foo))+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo{4, 5, 9, 3, 12};

    is_sorted_until(begin(foo), end(foo)); // 3
    ```
  ],
)

== Algorithmes -- Mélange

- ```cpp std::shuffle()``` mélange l'ensemble grâce à un générateur de nombre aléatoire uniforme

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%23include+%3Cchrono%3E%0A%23include+%3Crandom%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B4,+5,+9,+12%7D%3B%0A++unsigned+seed+%3D+std::chrono::system_clock::now().time_since_epoch().count()%3B%0A%0A++std::shuffle(std::begin(foo),+std::end(foo),+std::default_random_engine(seed))%3B%0A++for(size_t+i+%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo{4, 5, 9, 12};
    unsigned seed = now().time_since_epoch().count();

    shuffle(begin(foo), end(foo), default_random_engine(seed));
    ```
  ],
)

== Algorithmes -- Gestion de tas

- ```cpp std::is_heap()``` indique si l'ensemble forme un tas

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B4,+5,+9,+3,+12%7D%3B%0A%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_heap(std::begin(foo),+std::end(foo))+%3C%3C+!'%5Cn!'%3B%0A++std::make_heap(std::begin(foo),+std::end(foo))%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_heap(std::begin(foo),+std::end(foo))+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo{4, 5, 9, 3, 12};

    is_heap(begin(foo), end(foo));  // false
    make_heap(begin(foo), end(foo));
    is_heap(begin(foo), end(foo));  // true
    ```
  ],
)

- ```cpp std::is_heap_until()``` indique le premier élément qui n'est pas dans la position correspondant à un tas

== Algorithmes -- Min-max

- ```cpp std::minmax()``` retourne la paire constituée du plus petit et du plus grand de deux éléments

```cpp
minmax(5, 2); // 2 - 5
```

- ```cpp std::minmax_element()``` retourne la paire constituée des itérateurs sur le plus petit et le plus grand élément d'un ensemble

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%23include+%3Cutility%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B18,+5,+6,+8%7D%3B%0A++auto+p+%3D+std::minmax_element(std::begin(foo),+std::end(foo))%3B%0A%0A++std::cout+%3C%3C+*(p.first)+%3C%3C+%22+%22+%3C%3C+*(p.second)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo{18, 5, 6, 8};

    minmax_element(foo.begin(), foo.end()); // 5 - 18
    ```
  ],
)

== Algorithmes -- Numérique

- ```cpp std::iota()``` affecte des valeurs successives aux éléments d'un ensemble

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cnumeric%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo(5)%3B%0A++%0A++std::iota(std::begin(foo),+std::end(foo),+50)%3B%0A++for(size_t+i+%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo(5);

    iota(begin(foo), end(foo), 50); // 50 51 52 53 54
    ```
  ],
)

== Algorithmes -- Conclusion

#adviceblock("Do", text[
  Continuez à suivre les règles C++98/03 à propos des algorithmes
])

#adviceblock("Do", text[
  Privilégiez la sémantique lorsque plusieurs algorithmes sont utilisables
])

== Range-based for loop

- Itération sur un conteneur complet

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B4,+8,+12,+37%7D%3B%0A%0A++for(int+var+:+foo)%0A++%7B%0A++++std::cout+%3C%3C+var+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo{4, 8, 12, 37};

    for(int var : foo)
      cout << var << " ";    // 4 8 12 37
    ```
  ],
)

- Compatible avec ```cpp auto```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:14,positionColumn:1,positionLineNumber:14,selectionStartColumn:1,selectionStartLineNumber:14,startColumn:1,startLineNumber:14),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B4,+8,+12,+37%7D%3B%0A%0A++for(auto+var+:+foo)%0A++%7B%0A++++std::cout+%3C%3C+var+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo{4, 8, 12, 37};

    for(auto var : foo)
      cout << var << " ";    // 4 8 12 37
    ```
  ],
)

- Utilisable sur tout conteneur
  - Exposant ```cpp begin()``` et ```cpp end()```
  - Utilisable avec ```cpp std::begin()``` et ```cpp std::end()```

#addproposal("N2930")
#addproposal("N3271")

== Range-based for loop

#alertblock("Modification des éléments", text[
  La variable d'itération doit être une référence

  ```cpp
  vector<int> foo(4);

  for(auto& var : foo)
    var = 5;    // foo : 5 5 5 5
  ```
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo(4)%3B%0A%0A++for(auto%26+var+:+foo)%0A++%7B%0A++++var+%3D+5%3B%0A++%7D%0A%0A++for(auto+var+:+foo)%0A++%7B%0A++++std::cout+%3C%3C+var+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("N2930")
#addproposal("N3271")

== Range-based for loop

#adviceblock("Do", text[
  Préférez _range-based for loop_ aux boucles classiques et à ```cpp std::for_each()```
  // std::for_each() n'a plus d'intérêt en C++11 mais redevient utile en C++17 avec les politiques d'exécution parallélisées
])

#noteblock("Conseils", text[
  Contrairement à ```cpp for```, l'indice de l'itération n'est pas disponible

  Malgré tout, préférez la _range-based for loop_ avec un indice externe à ```cpp for```
])

#adviceblock("Do", text[
  Utilisez l'inférence de type sur la variable d'itération
])

#addproposal("N2930")
#addproposal("N3271")

== ``` std::string``` et conversions

- Fonctions de conversion d'une chaîne de caractères en un nombre
  - ```cpp std::stoi()``` vers ```cpp int```
  - ```cpp std::stol()``` vers ```cpp long```
  - ```cpp std::stoul()``` vers ```cpp unsigned long```
  - ```cpp std::stoll()``` vers ```cpp long long```
  - ```cpp std::stoull()``` vers ```cpp unsigned long long```
  - ```cpp std::stof()``` vers ```cpp float```
  - ```cpp std::stod()``` vers ```cpp double```
  - ```cpp std::stold()``` vers ```cpp long double```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%0Aint+main()%0A%7B%0A++int+a+%3D+std::stoi(%2242%22)%3B%0A%0A++std::cout+%3C%3C+a+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    stoi("42"); // 42
    ```
  ],
)

- S'arrêtent sur le premier caractère non convertible

== ``` std::string``` et conversions

- ```cpp std::to_string()``` convertit d'un nombre en une chaîne de caractères

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%0Aint+main()%0A%7B%0A++std::string+b+%3D+std::to_string(56)%3B%0A%0A++std::cout+%3C%3C+b+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    to_string(56); // "56"
    ```
  ],
)

- ```cpp std::to_wstring()``` convertit vers une chaîne de caractères larges

== ``` std::string``` et conversions

#alertblock("Attention", text[
  Pas de fonction ```cpp std::stoui()``` de conversion vers un ```cpp unsigned int```
])

#adviceblock("Do", text[
  Préférez ```cpp std::sto...()``` à ```cpp sscanf()```, ```cpp atoi()``` ou ```cpp strto...()```
])

#adviceblock("Do", text[
  Préférez ```cpp std::to_string()``` à ```cpp snprintf()``` ou ```cpp itoa()```
])

#noteblock("Alternative et complément", text[
  ```cpp Boost.Lexical_cast``` permet de telles conversions et quelques autres
])

== Chaînes de caractères UTF

- ```cpp char``` doit pouvoir contenir un encodage 8 bits UTF-8
// Pas de garantie en C++98/03, implémentation-defined
- ```cpp char16_t``` représente un code point 16 bits
- ```cpp char32_t``` représente un code point 32 bits
- ```cpp std::u16string``` spécialisation de ```cpp basic_string``` pour caractères 16 bits
- ```cpp std::u32string``` spécialisation de ```cpp basic_string``` pour caractères 32 bits
- Même interface que ```cpp std::string```

#addproposal("N2249")

== Nouvelles chaînes littérales

- Chaînes littérales UTF-8, UTF-16 et UTF32

```cpp
string u8str     = u8"UTF-8 string";
u16string u16str = u"UTF-16 string";
u32string u32str = U"UTF-32 string";
```

#addproposal("N2442")

== Nouvelles chaînes littérales

- Chaînes littérales brutes (sans interprétation des échappements)
  // Utile pour écrire des expressions rationnelles, des commandes shell ou autres qui ont aussi leurs échappements
  - Préfixées par ```cpp R```
  - Encadrées par une paire de parenthèses
  - Éventuellement complétées d'un délimiteur

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:7,positionColumn:1,positionLineNumber:7,selectionStartColumn:1,selectionStartLineNumber:7,startColumn:1,startLineNumber:7),source:'%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+R%22(Message%5Cn+en+une+seule+%5Cn+ligne)%22+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+R%22--(Message%5Cn+en+une+seule+%5Cn+ligne)--%22+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    // Affiche Message\n en une seule \n ligne
    cout << R"(Message\n en une seule \n ligne)";
    cout << R"--(Message\n en une seule \n ligne)--";
    ```
  ],
)

- Composition possible des deux type de chaînes littérales

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:5,positionColumn:1,positionLineNumber:5,selectionStartColumn:1,selectionStartLineNumber:5,startColumn:1,startLineNumber:5),source:'%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+u8R%22(Message%5Cn+en+une+seule+%5Cn+ligne)%22+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    u8R"(Message\n en une seule \n ligne)";
    ```
  ],
)

#addproposal("N2442")

== User-defined literals

- Possibilité de définir des littéraux "utilisateur"
- Nombre (entier ou réel), caractère ou chaîne suffixé par un identifiant
- Identifiants non standards préfixés par ```cpp _```
- Définit via ```cpp operator""``` suffixe

#noteblock("Motivations", text[
  Pas de conversion implicite

  Expressivité
  // Exemple d'expressivité : des classes de "quantité" avec des user-defined literals pour les unités
])

#addproposal("N2765")

== User-defined literals

- Littéraux brutes : chaîne C entièrement analysée par l'opérateur

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%0Aclass+Foo%0A%7B%0Apublic:%0A++explicit+Foo(int+a)%0A++++:+m_a%7Ba%7D%0A++%7B%7D%0A%0A++void+print()%0A++%7B%0A++++std::cout+%3C%3C+m_a+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0Aprivate:%0A++int+m_a%3B%0A%7D%3B%0A%0Astatic+Foo+operator%22%22_b(const+char*+str)%0A%7B%0A++unsigned+long+long+a+%3D+0%3B%0A++for(size_t+i+%3D+0%3B+str%5Bi%5D%3B+%2B%2Bi)%0A++%7B%0A++++a+%3D+(a+*+2)+%2B+(str%5Bi%5D+-+!'0!')%3B%0A++%7D%0A++return+Foo(a)%3B%0A%7D%0A%0Aint+main()%0A%7B%0A%23if+0%0A++Foo+foo+%3D+6%3B%0A%23else%0A++Foo+foo+%3D+0110_b%3B%0A%23endif%0A++foo.print()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    class Foo {
    public: explicit Foo(int a) : m_a{a} {}
    private: int m_a; };

    Foo operator""_b(const char* str) {
      unsigned long long a = 0;
      for(size_t i = 0; str[i]; ++i) a = (a * 2) + (str[i] - '0');
      return Foo(a); }

    Foo foo = 6        // Erreur de compilation
    Foo bar = 0110_b;  // 6
    ```
  ],
)

#alertblock("Restrictions", text[
  Uniquement pour les littéraux numériques
])

#addproposal("N2765")

== User-defined literals

- Littéraux préparés par le compilateur
  - Littéraux entiers : ```cpp unsigned long long int```
  - Littéraux réels : ```cpp long double```
  - Littéraux caractères : ```cpp char```, ```cpp wchar_t```, ```cpp char16_t``` ou ```cpp char32_t```
  - Chaînes littérales : couple pointeur sur caractères et ```cpp size_t```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%0Aclass+Foo%0A%7B%0Apublic:%0A++explicit+Foo(int+a)%0A++++:+m_a%7Ba%7D%0A++%7B%7D%0A%0A++void+print()%0A++%7B%0A++++std::cout+%3C%3C+m_a+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0Aprivate:%0A++int+m_a%3B%0A%7D%3B%0A%0Astatic+Foo+operator+%22%22+_f(unsigned+long+long+int+a)%0A%7B%0A++return+Foo(a)%3B%0A%7D%0A%0Astatic+Foo+operator%22%22_f(const+char*+str,+size_t+/*+length+*/)%0A%7B%0A++return+Foo(std::stoull(str))%3B%0A%7D%0A%0Aint+main()%0A%7B%0A%23if+0%0A++Foo+foo+%3D+12%3B%0A%23endif%0A%0A++Foo+bar+%3D+12_f%3B%0A++bar.print()%3B%0A%0A++Foo+baz+%3D+%2212%22_f%3B%0A++baz.print()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    Foo operator""_f(unsigned long long int a) {
      return Foo(a); }

    Foo operator""_f(const char* str, size_t) {
      return Foo(std::stoull(str)); }

    Foo baz = 12_f;    // OK
    Foo bar = "12"_f;  // OK
    ```
  ],
)

#addproposal("N2765")

== ``` std::tuple```

- Collection d'objets de type divers
- Généralisation de ```cpp std::pair```

```cpp
tuple<int, char, long> foo;
```

- ```cpp std::make_tuple()``` construit un ```cpp std::tuple```

```cpp
tuple<int, char, long> foo = make_tuple(5, 'e', 98L);
```

#noteblock(text[``` std::make_tuple``` ou constructeur ?], text[
  ```cpp std::make_tuple()``` permet la déduction de types, pas le constructeur

  ```cpp
  auto foo{5, 'e', 98L};              // KO
  auto bar = make_tuple(5, 'e', 98L); // OK
  ```
])

#addproposal("n1836")

== ``` std::tuple```

- Fonction de déstructuration ```cpp std::tie()```
- Et une constante pour ignorer des éléments ```cpp std::ignore```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:15,positionColumn:1,positionLineNumber:15,selectionStartColumn:1,selectionStartLineNumber:15,startColumn:1,startLineNumber:15),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%23include+%3Ctuple%3E%0A%0Aint+main()%0A%7B%0A++std::tuple%3Cint,+std::string,+double%3E+foo+%3D+std::make_tuple(42,+%22FOO%22,+25.2)%3B%0A%0A++int+a%3B%0A++double+b%3B%0A%0A++std::tie(a,+std::ignore,+b)+%3D+foo%3B%0A++std::cout+%3C%3C+a+%3C%3C+!'+!'+%3C%3C+b+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    int a; long b;
    tie(a, ignore, b) = foo;
    ```
  ],
)

// C++17 introduit les structured binding qui améliore grandement la déstructuration en proposant une syntaxe plus simple et claire

- ```cpp std::get<>()``` accède aux éléments du ```cpp std::tuple``` par l'indice

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%23include+%3Ctuple%3E%0A%0Aint+main()%0A%7B%0A++std::tuple%3Cint,+std::string,+double%3E+foo+%3D+std::make_tuple(42,+%22FOO%22,+25.2)%3B%0A%0A++std::string+c+%3D+std::get%3C1%3E(foo)%3B%0A++std::cout+%3C%3C+c+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    char c = get<1>(foo);
    ```
  ],
)

#alertblock("Attention", text[
  Les indices commencent à 0
])

#addproposal("n1836")

== ``` std::tuple```

- ```cpp std::tuple_cat()``` concatène deux ```cpp std::tuple```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:23,endLineNumber:7,positionColumn:23,positionLineNumber:7,selectionStartColumn:23,selectionStartLineNumber:7,startColumn:23,startLineNumber:7),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%23include+%3Ctuple%3E%0A%0Aint+main()%0A%7B%0A++std::tuple%3Cint,+char%3E+foo+%3D+std::make_tuple(5,+!'e!')%3B%0A++auto+bar+%3D+std::make_tuple(98L,+!'r!')%3B%0A++auto+baz+%3D+std::tuple_cat(foo,+bar)%3B%0A%0A++std::cout+%3C%3C+std::tuple_size%3Cdecltype(baz)%3E::value+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    auto foo = make_tuple(5, 'e');
    auto bar = make_tuple(98L, 'r');
    auto baz = tuple_cat(foo, bar);               // 5 'e' 98L 'r'
    ```
  ],
)

- Classe représentant la taille ```cpp std::tuple_size```

```cpp
	tuple_size<decltype(baz)>::value;             // 4
```

- Classe représentant le type des éléments ```cpp std::tuple_element```

```cpp
tuple_element<0, decltype(baz)>::type first;  // int
```

#addproposal("n1836")

== ``` std::tuple```

#alertblock("Don't", text[
  N'utilisez pas ```cpp std::tuple``` pour remplacer une structure

  ```cpp std::tuple``` regroupe localement des éléments sans lien sémantique
])

#adviceblock("Do", text[
  Préférez un ```cpp std::tuple``` de retour aux paramètres "_OUT_"
])

== ``` fstream```

- Construction depuis des ```cpp std::string```

```cpp
string filename{"foo.txt"};

// C++ 98
ofstream file(filename.c_str());

// C++ 11
ofstream file{filename};
```

== ``` =default``` et ``` =delete```

- Applicables aux fonctions générées implicitement le compilateur
  - Constructeur par défaut, par copie et par déplacement
  - Destructeur
  - Opérateur d'affectation
  - Opérateur d'affectation par déplacement
- ```cpp =default``` force le compilateur à générer l'implémentation triviale
- ```cpp =delete``` désactive la génération implicite de la fonction
- ```cpp =delete``` peut aussi s'appliquer aux fonctions héritées pour les supprimer

#addproposal("N2346")

== ``` =default``` et ``` =delete```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aclass+Foo%0A%7B%0Apublic:%0A++Foo(int)+%7B%7D%0A%23if+1%0A++Foo()+%3D+default%3B%0A%23endif%0A%0Aprivate:%0A++Foo(const+Foo%26)+%3D+delete%3B%0A++Foo%26+operator%3D(const+Foo%26)+%3D+delete%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++Foo+foo%3B%0A++Foo+bar(5)%3B%0A%23if+0%0A++Foo+baz(bar)%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra+-Wno-unused-variable',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    class Foo {
      public: Foo(int) {}
      public: Foo() = default;

      private: Foo(const Foo&) = delete;
      private: Foo& operator=(const Foo&) = delete;
    };
    ```
  ],
)

#addproposal("N2346")

== ``` =default``` et ``` =delete```

#adviceblock("Do", text[
  Préférez ```cpp =default``` à une implémentation manuelle avec le même effet
])

#adviceblock("Do", text[
  Préférez ```cpp =delete``` à une déclaration privée sans définition
])

#noteblock(text[``` =default``` ou non définition ?], text[
  Consensus plutôt du côté de la non-définition

  Intérêt documentaire réel à ```cpp =default```
])

#addproposal("N2346")

== Initialisation par défaut des membres

- Initialisation des membres lors de la déclaration

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astruct+Foo%0A%7B%0A++Foo()%0A++%7B%7D%0A%0A++int+m_a%7B2%7D%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++Foo+foo%3B%0A%0A++std::cout+%3C%3C+foo.m_a+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    struct Foo {
      Foo() {}
      int m_a{2};
    };
    ```
  ],
)

#alertblock("Restriction", text[
  Pas d'initialisation avec ```cpp ()```

  Initialisation avec ```cpp =``` uniquement sur des types copiables
])

#adviceblock("Do", text[
  Préférez l'initialisation des membres à l'initialisation par constructeurs pour les initialisations avec une valeur connue à la compilation
])

#addproposal("N2756")

== Délégation de constructeur

- Utilisation d'un constructeur dans l'implémentation d'un second
- ... en l'initialisant dans la liste d'initialisation

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aclass+Foo%0A%7B%0Apublic:%0A++Foo(int+a)%0A++++:+m_a(a)%0A++%7B%0A++%7D%0A%0A++Foo()%0A++++:+Foo(2)%0A++%7B%0A++%7D%0A%0A++void+print()%0A++%7B%0A++++std::cout+%3C%3C+m_a+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0Aprivate:%0A++int+m_a%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++Foo+foo(4)%3B%0A++Foo+bar%3B%0A%0A++foo.print()%3B%0A++bar.print()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    struct Foo {
      Foo(int a) : m_a(a) {}
      Foo() : Foo(2) {}
      int m_a;
    };
    ```
  ],
)

#addproposal("N1986")

== Délégation de constructeur

#adviceblock("Do", text[
  Utilisez la délégation de constructeur pour mutualiser le code commun
])

#alertblock("Don't", text[
  Évitez la délégation pour l'initialisation constante de membres
])

#adviceblock("Do", text[
  Préférez l'initialisation par défaut des membres
])

#addproposal("N1986")

== Héritage de constructeur

- Indique que la classe hérite des constructeurs de la classe mère
- Génération du constructeur correspondant par le compilateur
  - Paramètres du constructeur de base
  - Appelle le constructeur de base correspondant
  - Initialise les membres sans fournir de paramètres

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astruct+Foo%0A%7B%0A++Foo()%0A++%7B%7D%0A%0A++Foo(int+a)%0A++++:+m_a(a)%0A++%7B%7D%0A%0A++int+m_a%7B2%7D%3B%0A%7D%3B%0A%0Astruct+Bar+:+Foo%0A%7B%0A++using+Foo::Foo%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++%7B%0A++++Foo+foo%3B%0A++++Foo+bar(4)%3B%0A%0A++++std::cout+%3C%3C+foo.m_a+%3C%3C+!'+!'+%3C%3C+bar.m_a+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0A++%7B%0A++++Bar+foo%3B%0A++++Bar+bar(4)%3B%0A%0A++++std::cout+%3C%3C+foo.m_a+%3C%3C+!'+!'+%3C%3C+bar.m_a+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    struct Foo {
      Foo() {}
      Foo(int a) : m_a(a) {}
      int m_a{2};
    };

    struct Bar : Foo {
      using Foo::Foo;
    };
    ```
  ],
)

#addproposal("N2540")

== Héritage de constructeur

- Redéfinition possible dans la classe dérivée

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astruct+Foo%0A%7B%0A++Foo()%0A++%7B%7D%0A%0A++Foo(int+a)%0A++++:+m_a(a)%0A++%7B%7D%0A%0A++int+m_a%7B2%7D%3B%0A%7D%3B%0A%0Astruct+Bar+:+Foo%0A%7B%0A++using+Foo::Foo%3B%0A++Bar()%0A++++:+Foo(5)+%0A++%7B%7D%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++Bar+foo%3B%0A++Bar+bar(4)%3B%0A%0A++std::cout+%3C%3C+foo.m_a+%3C%3C+!'+!'+%3C%3C+bar.m_a+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    struct Bar : Foo {
      using Foo::Foo;
      Bar() : Foo(5) {}
    };
    ```
  ],
)

#alertblock("Valeurs par défaut", text[
  Génération de toutes les combinaisons de constructeurs sans valeur par défaut correspondantes au constructeur de base avec des valeurs par défaut
  // Ainsi Foo(int, int = 2) va injecter Bar(int) et Bar(int, int)
])

#alertblock("Héritage multiple", text[
  Héritage impossible de deux constructeurs avec la même signature
])

#addproposal("N2540")

== ``` override```

- Indique la redéfinition d'une fonction d'une classe de base

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%0Astruct+Foo%0A%7B%0A++Foo()%0A++%7B%7D%0A%0A++virtual+void+f(int)%0A++%7B%7D%0A%7D%3B%0A%0Astruct+Bar+:+Foo%0A%7B%0A++Bar()%0A++%7B%7D%0A%0A++void+f(int)+override%0A++%7B%7D%0A%7D%3B%0A%0Aint+main()%0A%7B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    struct Foo {
      Foo() {}
      virtual void f(int);
    };

    struct Bar : Foo {
      Bar() {}
      void f(int) override;
    };
    ```
  ],
)

#addproposal("N2928")
#addproposal("N3206")
#addproposal("N3272")

== ``` override```

- Provoque une erreur de compilation si
  - La fonction n'existe pas dans la classe de base
  - La fonction de la classe de base n'est pas virtuelle

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astruct+Foo%0A%7B%0A++Foo()+%0A++%7B%7D%0A%0A++virtual+void+f(int)%0A++%7B%7D%0A%0A++virtual+void+g(int)+const%0A++%7B%7D%0A%0A++void+h(int)%0A++%7B%7D%0A%7D%3B%0A%0Astruct+Bar+:+Foo%0A%7B%0A++Bar()%0A++%7B%7D%0A%0A++void+f(float)+override%0A++%7B%7D%0A%0A++void+g(int)+override%0A++%7B%7D%0A%0A++void+h(int)+override%0A++%7B%7D%0A%0A++void+i(int)+override%0A++%7B%7D%0A%7D%3B%0A%0Aint+main()%0A%7B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    struct Foo {
      virtual void f(int);
      virtual void g(int) const;
      void h(int);
    };

    struct Bar : Foo {
      void f(float) override;   // Erreur
      void g(int) override;     // Erreur
      void h(int) override;     // Erreur
    };
    ```
  ],
)

#addproposal("N2928")
#addproposal("N3206")
#addproposal("N3272")

== ``` override```

#noteblock("Objectifs", text[
  Documentaire

  Détection des non-reports de modifications lors d'un refactoring

  Détection des redéfinitions involontaires
])

#adviceblock("Do", text[
  Marquez ```cpp override``` les fonctions que vous redéfinissez
])

#adviceblock("Do", text[
  Utilisez ```cpp virtual``` à la base de l'arbre d'héritage
])

#adviceblock("Do", text[
  Utilisez ```cpp override``` sur les redéfinitions
  // Si une fonction est virtuelle, toutes ces redéfinitions le sont qu'elles soient ou non marquées comme tel}
])

#addproposal("N2928")
#addproposal("N3206")
#addproposal("N3272")

== ``` final```

- Indique qu'une classe ne peut pas être dérivée

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astruct+Foo+final%0A%7B%0A++Foo()%0A++%7B%7D%0A%7D%3B%0A%0Astruct+Bar+:+Foo%0A%7B%0A++Bar()%0A++%7B%7D%0A%7D%3B%0A%0Aint+main()%0A%7B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    struct Foo final {
      virtual void f(int);
    };

    struct Bar : Foo {   // Erreur
      void f(int);
    };
    ```
  ],
)

- Aussi bien via l'héritage public que privé

#addproposal("N3206")
#addproposal("N3272")

== ``` final```

- Ou qu'une fonction ne peut plus être redéfinie

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astruct+Foo%0A%7B%0A++Foo()%0A++%7B%7D%0A%0A++virtual+void+f(int)%0A++%7B%7D%0A%7D%3B%0A%0Astruct+Bar+:+Foo%0A%7B%0A++Bar()%0A++%7B%7D%0A%0A++virtual+void+f(int)+final%0A++%7B%7D%0A%7D%3B%0A%0Astruct+Baz+:+Bar%0A%7B%0A++Baz()%0A++%7B%7D%0A%0A++virtual+void+f(int)%0A++%7B%7D%0A%7D%3B%0A%0Aint+main()%0A%7B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    struct Foo {
      virtual void f(int);
    };

    struct Bar : Foo {
      void f(int) final;
    };

    struct Baz : Bar {
      void f(int);       // Erreur
    };
    ```
  ],
)

#adviceblock("Do", text[
  Utilisez ```cpp final``` avec parcimonie
])

#addproposal("N3206")
#addproposal("N3272")

== Opérateurs de conversion explicite

- Extension de ```cpp explicit``` aux opérateurs de conversion
- ... qui ne définissent alors plus de conversion implicite

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:17,positionColumn:1,positionLineNumber:17,selectionStartColumn:1,selectionStartLineNumber:17,startColumn:1,startLineNumber:17),source:'%23include+%3Ciostream%3E%0A%0Astruct+Foo%0A%7B%0A++operator+int()%0A++%7B%0A++++return+5%3B%0A++%7D%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++Foo+f%3B%0A++int+a+%3D+f%3B%0A++int+b+%3D+static_cast%3Cint%3E(f)%3B%0A++std::cout+%3C%3C+a+%3C%3C+!'+!'+%3C%3C+b+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    struct Foo { operator int() { return 5; } };

    Foo f;
    int a = f;                    // OK
    int b = static_cast<int>(f);  // OK
    ```
  ],
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:6,endLineNumber:14,positionColumn:6,positionLineNumber:14,selectionStartColumn:6,selectionStartLineNumber:14,startColumn:6,startLineNumber:14),source:'%23include+%3Ciostream%3E%0A%0Astruct+Foo%0A%7B%0A++explicit+operator+int()%0A++%7B%0A++++return+5%3B%0A++%7D%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++Foo+f%3B%0A%23if+1%0A++int+a+%3D+f%3B%0A%23endif%0A++int+b+%3D+static_cast%3Cint%3E(f)%3B%0A++std::cout+%3C%3C+b+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    struct Foo { explicit operator int() { return 5; } };

    Foo f;
    int a = f;                    // Erreur
    int b = static_cast<int>(f);  // OK
    ```
  ],
)

#addproposal("N2437")

== ``` noexcept```

- Indique qu'une fonction ne jette pas d'exception
// Rôle documentaire et permet au compilateur d'effectuer certaines optimisations (p. ex. sur le choix entre déplacement et copie)
// Appelle std::terminate() lorsque la fonction ne respecte pas son contrat et lance une exception
// std::terminate() appelle le handler correspondant qui par défaut est std::abort() qui arrête violemment le programme

```cpp
void foo() noexcept {}
```

- Pilotable par une expression booléenne

```cpp
void foo() noexcept(true) {}
```

#noteblock("Dépréciation", text[
  Les spécifications d'exception sont dépréciées

  Voir #link("http://www.gotw.ca/publications/mill22.htm")[A Pragmatic Look at Exception Specifications #linklogo()] (Herb Sutter)
  // En pratique, seule throw() était utilisée et utilisable et a été remplacée par noexcept
])

#addproposal("N3050")

== ``` noexcept```

- Opérateur ```cpp noexcept()``` teste, au _compile-time_, si une expression peut ou non lever une exception
- Pour l'appel de fonction, teste si la fonction est ```cpp noexcept```

```cpp
noexcept(foo()); // true
```

#adviceblock("Do", text[
  Marquez ```cpp noexcept``` les fonctions qui sémantiquement ne jette pas d'exception
])

#addproposal("N3050")

== Conversion exception - pointeur

- Quasi-pointeur ```cpp std::exception_ptr``` à responsabilité partagée sur une exception
- ```cpp std::current_exception()``` récupère un pointeur sur l'exception courante
- ```cpp std::rethrow_exception()``` relance l'exception contenue dans ```cpp std::exception_ptr```
- ```cpp std::make_exception_ptr()``` construit ```cpp std::exception_ptr``` depuis une exception

#addproposal("n2179")

== Conversion exception - pointeur

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cexception%3E%0A%0Avoid+foo()%0A%7B%0A++throw+42%3B%0A%7D%0A%0Avoid+bar(std::exception_ptr+e)%0A%7B%0A++std::rethrow_exception(e)%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++try%0A++%7B%0A++++foo()%3B%0A++%7D%0A++catch(...)%0A++%7B%0A++++std::exception_ptr+e+%3D+std::current_exception()%3B%0A++++bar(e)%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:54.83028720626631,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:45.16971279373369,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    void foo() { throw 42; }

    try {
      foo();
    }
    catch(...) {
      exception_ptr bar = current_exception();
      rethrow_exception(bar);
    }
    ```
  ],
)

#noteblock("Motivation", text[
  Faire passer la barrière des threads aux exceptions
])

#addproposal("n2179")

== Nested exception

- ```cpp std::nested_exception``` contient une exception imbriquée
- ```cpp nested_ptr()``` récupère un pointeur sur l'exception imbriquée
- ```cpp rethrow_nested()``` relance l'exception imbriquée
- ```cpp std::rethrow_if_nested()``` relance l'exception imbriquée si elle existe
- ```cpp std::throw_with_nested()``` lance une exception embarquant l'exception courante

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cexception%3E%0A%0Avoid+foo()+%0A%7B%0A++try+%0A++%7B+%0A++++throw+42%3B%0A++%7D%0A++catch(...)%0A++%7B+%0A++++std::throw_with_nested(std::logic_error(%22bar%22))%3B%0A++%7D%0A%7D%0A%0Aint+main()%0A%7B%0A++try%0A++%7B%0A++++foo()%3B%0A++%7D%0A++catch(std::logic_error+%26e)%0A++%7B%0A%23if+0%0A++++std::rethrow_if_nested(e)%3B%0A%23else%0A++++throw%3B%0A%23endif%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    void foo() {
      try { throw 42; }
      catch(...) { throw_with_nested(logic_error("bar")); }
    }

    try { foo(); }
    catch(logic_error &e) { std::rethrow_if_nested(e); }
    ```
  ],
)

== ``` enum class```

- Énumérations mieux typées
- Sans conversions implicites
- Énumérés locaux à l'énumération

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:15,endLineNumber:4,positionColumn:15,positionLineNumber:4,selectionStartColumn:15,selectionStartLineNumber:4,startColumn:15,startLineNumber:4),source:'%23include+%3Ciostream%3E%0A%23include+%3Ctype_traits%3E%0A%0Aenum+class+Foo%0A%7B+%0A++BAR1,%0A++BAR2,%0A%7D%3B%0A%0Aint+main()%0A%7B%0A%23if+0%0A++Foo+foo+%3D+BAR2%3B%0A%23else%0A++Foo+foo+%3D+Foo::BAR2%3B%0A%23endif%0A%0A%23if+0%0A++std::cout+%3C%3C+foo+%3C%3C+%22%5Cn%22%3B%0A%23else%0A++std::cout+%3C%3C+static_cast%3Cstd::underlying_type%3CFoo%3E::type%3E(foo)+%3C%3C+%22%5Cn%22%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    enum class Foo { BAR1, BAR2 };

    Foo foo = Foo::BAR1;
    ```
  ],
)

- Possibilité de fournir le type sous-jacent
// Sur les énumérations classiques aussi

```cpp
enum class Foo : unsigned char { BAR1, BAR2 };
```

- ```cpp std::underlying_type``` permet de récupérer ce type sous-jacent

#addproposal("N2347")

== ``` enum class```

#adviceblock("Do", text[
  Préférez les énumérations fortement typées
])

#noteblock("Bémol", text[
  Pas de méthode simple et robuste pour récupérer la valeur ou l'intitulé de l'énuméré
])

#addproposal("N2347")

== ``` std::function```

// Fonction de première classe (first-class citizens) : utilisables comme paramètre ou retour de fonction
// Fonction d'ordre supérieur : prend en paramètre ou retourne une autre fonction

- Encapsule un appelable de n'importe quel type

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cfunctional%3E%0A%0Aint+foo(int+a,+int+b)%0A%7B%0A++return+a+%2B+b%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::function%3Cint(int,+int)%3E+bar+%3D+foo%3B%0A%0A++std::cout+%3C%3C+bar(1,2)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    int foo(int, int);

    function<int(int, int)> bar = foo;
    ```
  ],
)

- Copiable
- Peut être passer en paramètre ou retourner par une fonction

#addproposal("n1836")

== ``` std::mem_fn```

- Convertit une fonction membre en _function object_ prenant une instance en paramètre

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cfunctional%3E%0A%0Astruct+Foo%0A%7B%0A++int+f(int+a)%0A++%7B%0A++++return+2+*+a%3B%0A++%7D%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++Foo+foo%3B%0A++std::function%3Cint(Foo,+int)%3E+bar+%3D+std::mem_fn(%26Foo::f)%3B%0A%0A++std::cout+%3C%3C+bar(foo,+5)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    struct Foo { int f(int a) { return 2 * a; } };

    Foo foo;
    function<int(Foo, int)> bar = mem_fn(&Foo::f);
    bar(foo, 5);   // 10
    ```
  ],
)

#noteblock("Note", text[
  Type de retour non spécifié mais stockable dans ```cpp std::function```
])

#noteblock("Dépréciation", text[
  Dépréciation de ```cpp std::mem_fun```, ```cpp std::ptr_fun``` et consorts
  // Série de fonctions templates convertissant des fonctions membres, des pointeurs de fonction, etc. en foncteur utilisable dans les algorithmes
  // Leur grosse limitation venait du nombre de paramètres limités (0 ou 1)
])

#addproposal("n1836")

== ``` std::bind```

- Construction de _function object_ en liant des paramètres à un appelable
- _Placeholders_ ```cpp std::placholders::_1```, ```cpp std::placholders::_2```, ... pour lier les paramètres du _function object_ à l'appelable

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cfunctional%3E%0A%0Astatic+int+foo(int+a,+int+b)%0A%7B%0A++return+(a+-+1)+*+b%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::function%3Cint(int)%3E+bar+%3D+std::bind(%26foo,+std::placeholders::_1,+2)%3B%0A++std::cout+%3C%3C+bar(3)+%3C%3C+!'%5Cn!'%3B%0A%0A++auto+baz+%3D+std::bind(%26foo,+std::placeholders::_2,+std::placeholders::_1)%3B%0A++std::cout+%3C%3C+baz(3,+2,+1,+2,+3)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    int foo(int a, int b) { return (a - 1) * b; }

    function<int(int)> bar = bind(&foo, _1, 2);
    bar(3);               // 4

    auto baz = bind(&foo, _2, _1);
    baz(3, 2, 1, 2, 3);   // 3
    ```
  ],
)

// Avec auto, il est possible de passer autant de paramètres surnuméraires que souhaiter

#noteblock("Dépréciation", text[
  Dépréciation de ```cpp std::bind1st``` et ```cpp std::bind2nd```
  // Version C++98 mais limités car ne pouvait que convertir une fonction binaire en fonction unaire en liant le premier ou le second paramètre
])

#addproposal("n1836")

== lambda et fermeture

#noteblock("Vocabulaire", text[
  Lambda : fonction anonyme

  Fermeture : capture des variables libres de l'environnement lexical
])

- ```cpp [capture](paramètres) spécificateurs -> type_retour {instructions}```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++int+bar+%3D+4%3B%0A++auto+foo+%3D+%5B%26bar%5D+(int+a)+-%3E+int+%7B+bar+*%3D+a%3B+return+a%3B%7D%3B%0A%0A++std::cout+%3C%3C+foo(5)+%3C%3C+!'+!'+%3C%3C+bar+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    int bar = 4;
    auto foo = [&bar] (int a) -> int { bar *= a; return a; };

    int baz = foo(5);  // bar : 20, baz : 5
    ```
  ],
)

#addproposal("N2550")
#addproposal("N2658")
#addproposal("N2927")

== lambda et fermeture

- Capture
  - ```cpp []``` : pas de capture
  - ```cpp [x]``` : capture x par valeur
  - ```cpp [&y]``` : capture y par référence
  - ```cpp [=]```  : capture tout par valeur
  - ```cpp [&]``` : capture tout par référence
  - ```cpp [x, &y]``` : capture x par valeur et y par référence
  - ```cpp [=, &z]``` : capture z par référence et le reste par copie
  - ```cpp [&, z]``` : capture z par valeur et le reste par référence

#addproposal("N2550")
#addproposal("N2658")
#addproposal("N2927")

== lambda et fermeture

- La capture de variables membres se fait par la capture de  ```cpp this```
  - Soit explicitement via ```cpp [this]```

#alertblock(text[Capture de ``` this```], text[
  Capture du pointeur, non de l'objet
])

#list(marker: [], list(indent: 5pt, text[Soit via ```cpp [=]``` ou ```cpp [&]```]))

#addproposal("N2550")
#addproposal("N2658")
#addproposal("N2927")

== lambda et fermeture

- Préservation de la constante des variables capturées
// Même avec mutable
- Pas de capture des variables globales et statiques

#alertblock("Attention", text[
  Par défaut, les variables capturées par copie ne sont pas modifiables

  ```cpp
  int i = 5;

  auto foo = [=] () { cout << ++i << "\n"; };          // Erreur
  uto bar = [=] () mutable { cout << ++i << "\n"; };  // OK
  ```

  // Bien entendu dans le cas de mutable, ce qui est modifié est bien la copie, pas la variable originale
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++int+i+%3D+5%3B%0A%0A%23if+1%0A++auto+foo+%3D+%5B%3D%5D+()+%7B+std::cout+%3C%3C+%2B%2Bi+%3C%3C+%22%5Cn%22%3B+%7D%3B%0A++foo()%3B%0A%23endif%0A%0A++auto+bar+%3D+%5B%3D%5D+()+mutable+%7B+std::cout+%3C%3C+%2B%2Bi+%3C%3C+%22%5Cn%22%3B+%7D%3B%0A++bar()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("N2550")
#addproposal("N2658")
#addproposal("N2927")

== lambda et fermeture

- Spécificateurs
  - ```cpp mutable``` : modification possible des variables capturées par copie
  - ```cpp noexcept``` : ne lève pas d'exception
- Omission possible du type de retour si
  - Unique instruction
  - Un ```cpp return```
- Omission possible d'une liste de paramètres vide

```cpp
auto foo = [] { return 5; };
```

#alertblock("Exception", text[
  Omission impossible si la lambda est ```cpp mutable```
])

#addproposal("N2550")
#addproposal("N2658")
#addproposal("N2927")

== lambda, ``` std::function```, ... - Conclusion

#adviceblock("Do", text[
  Préférez les lambdas aux ```cpp std::function```
])

#adviceblock("Do", text[
  Préférez les lambdas à ```cpp std::bind()```
])

// Les lambdas sont généralement plus efficaces

#noteblock("Motivations", text[
  Lisibilité, expressivité et performances

  Voir #link("https://github.com/boostcon/cppnow_presentations_2016/blob/master/00_tuesday/practical_performance_practices.pdf")[Practical Performance Practices #linklogo()]

  // Entre autres, il y a aussi des remarques intéressantes sur le choix des conteneurs, des pointeurs intelligents, sur std::endl, etc.
])

#alertblock("Attention", text[
  Prenez garde à la durée de vie des variables capturées par référence
])

== ``` std::reference_wrapper```

- Encapsule un objet en émulant une référence
- Construction par ```cpp std::ref()``` et ```cpp std::cref()```
- Copiable

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cfunctional%3E%0A%0Aint+main()%0A%7B%0A++int+a%7B10%7D%3B%0A%0A++std::reference_wrapper%3Cint%3E+aref+%3D+std::ref(a)%3B%0A++aref%2B%2B%3B%0A++std::cout+%3C%3C+a+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    int a{10};
    reference_wrapper<int> aref = ref(a);

    aref++; // a : 11
    ```
  ],
)

#addproposal("n1836")

== Double chevron

- En C++98/03, ```cpp >>``` est toujours l'opérateur de décalage
- En C++11, ```cpp >>``` peut être une double fermeture de template

```cpp
vector<vector<int>> foo;
// Invalide en C++98/03
// Valide en C++11
```

// En C++98/03, il fallait un espace entre les deux >

- Utilisation de parenthèses pour forcer l'interprétation en tant qu'opérateur

```cpp
vector<array<int, (0x10 >> 3) >> foo;
```

#addproposal("N1757")

== Alias de template

- En C++98/03, ```cpp typedef``` définit des alias sur des templates
- ... seulement si tous les paramètres templates sont explicites

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Atemplate+%3Ctypename+T,+typename+U,+int+V%3E%0Aclass+Foo%0A%7B%0A%7D%3B%0A%0Atypedef+Foo%3Cint,+int,+5%3E+Baz%3B%0A%0A%23if+0%0Atemplate+%3Ctypename+U%3E%0Atypedef+Foo%3Cint,+U,+5%3E+Bar%3B%0A%23endif%0A%0Aint+main()%0A%7B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    template <typename T, typename U, int V>
    class Foo;

    typedef Foo<int, int, 5> Baz;  // OK

    template <typename U>
    typedef Foo<int, U, 5> Bar;    // Incorrect
    ```
  ],
)

#addproposal("N2258")

== Alias de template

- ```cpp using``` permet la création d'alias ne définissant que certains paramètres

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Atemplate+%3Ctypename+T,+typename+U,+int+V%3E%0Aclass+Foo%0A%7B%0A%7D%3B%0A%0Ausing+Baz+%3D+Foo%3Cint,+int,+5%3E%3B%0A%0Atemplate+%3Ctypename+U%3E%0Ausing+Bar+%3D+Foo%3Cint,+U,+5%3E%3B%0A%0Aint+main()%0A%7B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    template <typename U>
    using Bar = Foo<int, U, 5>;
    ```
  ],
)

#noteblock(text[``` using``` de types], text[
  ```cpp using``` n'est pas réservé aux templates

  ```cpp
  using Error = int;
  ```
])

#addproposal("N2258")

== Extern template

- Indique que le template est instancié dans une autre unité de compilation
- Inutile de l'instancier ici

```cpp
extern template class std::vector<int>;
```

#noteblock("Objectif", text[
  Réduction du temps de compilation
])

#addproposal("N1987")

== Variadic template

- Template à nombre de paramètres variable
- Définition avec ```cpp typename...```

```cpp
template<typename... Args>
class Foo;
```

- Récupération de la liste avec ```cpp ...```

```cpp
template<typename... Args>
void bar(Args... parameters);
```

#addproposal("N2242")
#addproposal("N2555")

== Variadic template

- Récupération de la taille avec ```cpp sizeof...```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%0Atemplate%3Ctypename...+Args%3E%0Aclass+Foo%0A%7B%0Apublic:%0A++static+const+unsigned+int+size+%3D+sizeof...(Args)%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+Foo%3Cint,+int,+long%3E::size+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    template<typename... Args>
    class Foo {
    public:
      static const unsigned int size = sizeof...(Args);
    };
    ```
  ],
)

#addproposal("N2242")
#addproposal("N2555")

== Variadic template

- Utilisation récursive par spécialisation

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%0A//+Condition+d!'arret%0Atemplate%3Ctypename+T%3E%0AT+sum(T+val)%0A%7B%0A++return+val%3B%0A%7D%0A%0Atemplate%3Ctypename+T,+typename...+Args%3E%0AT+sum(T+val,+Args...+values)%0A%7B%0A++return+val+%2B+sum(values...)%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+sum(1,+5,+56,+9)+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+sum(std::string(%22Un%22),+std::string(%22Deux%22))+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    // Condition d'arrêt
    template<typename T>
    T sum(T val) {
      return val;
    }

    template<typename T, typename... Args>
    T sum(T val, Args... values) {
      return val + sum(values...);
    }

    sum(1, 5, 56, 9);                   // 71
    sum(string("Un"), string("Deux"));  // "UnDeux"
    ```
  ],
)

#addproposal("N2242")
#addproposal("N2555")

== Variadic template

- Ou expansion sur une expression et une fonction d'expansion

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%0Atemplate%3Ctypename...+T%3E+%0Avoid+pass(T%26%26...)%0A%7B%0A%7D%0A%0Aint+total+%3D+0%3B%0Aint+foo(int+i)%0A%7B%0A++total+%2B%3D+i%3B%0A++return+i%3B%0A%7D%0A%0Atemplate%3Ctypename...+T%3E%0Aint+sum(T...+t)%0A%7B%0A++pass((foo(t))...)%3B+%0A++return+total%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+sum(1,+2,+3,+5)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    template<typename... T> void pass(T&&...) {}

    int total = 0;
    int foo(int i) {
      total += i;
      return i;
    }

    template<typename... T>
    int sum(T... t) {
      pass((foo(t))...); return total;
    }

    sum(1, 2, 3, 5);  // 11
    ```
  ],
)

#addproposal("N2242")
#addproposal("N2555")

== Variadic template

#alertblock("Contraintes de l'expansion", text[
  Paramètre unique

  Ne retournant pas ```cpp void```

  Pas d'ordre garanti
])

- Candidat naturel ```cpp std::initializer_list```
- ... constructible depuis un _variadic template_

```cpp
template<typename... T>
int foo(T... t) {
  initializer_list<int>{ t... };
}

foo(1, 2, 3, 5);
```

#addproposal("N2242")
#addproposal("N2555")

== Variadic template

- ... qui règle le problème de l'ordre

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aint+total+%3D+0%3B%0Aint+foo(int+i)%0A%7B%0A++total+%2B%3D+i%3B%0A++return+i%3B%0A%7D%0A%0Atemplate%3Ctypename...+T%3E%0Aint+sum(T...+t)%0A%7B%0A++std::initializer_list%3Cint%3E%7B+(foo(t),+0)...+%7D%3B%0A++return+total%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+sum(1,+2,+3,+5)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    int total = 0;
    int foo(int i) {
      total += i; return i;
    }

    template<typename... T>
    int sum(T... t) {
      initializer_list<int>{ (foo(t), 0)... };
      return total;
    }

    sum(1, 2, 3, 5);  // 11
    ```
  ],
)

// ,0 permet de régler le souci du retour void

#addproposal("N2242")
#addproposal("N2555")

== Variadic template

- .. sur n'importe quelle expression prenant un paramètre

//Donc appelle de fonction ou lambda mais aussi simple expression

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:2,endLineNumber:10,positionColumn:2,positionLineNumber:10,selectionStartColumn:2,selectionStartLineNumber:10,startColumn:2,startLineNumber:10),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%0Atemplate%3Ctypename+...+T%3E%0Atypename+std::common_type%3CT...%3E::type+sum(T+...+t)%0A%7B%0A++typename+std::common_type%3CT...%3E::type+result%7B%7D%3B%0A++std::initializer_list%3Cint%3E%7B+(result+%2B%3D+t,+0)...+%7D%3B%0A++return+result%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+sum(1,+2,+3,+5)+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+sum(std::string(%22Un%22),+std::string(%22Deux%22))+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    template<typename... T>
    auto sum(T... t) {
      typename common_type<T...>::type result{};
      initializer_list<int>{ (result += t, 0)... };
      return result;
    }

    sum(1, 2, 3, 5);  // 11
    ```
  ],
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:12,positionColumn:1,positionLineNumber:12,selectionStartColumn:1,selectionStartLineNumber:12,startColumn:1,startLineNumber:12),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%0Atemplate%3Ctypename+...+T%3E%0Avoid+print(T+...+t)%0A%7B%0A++std::initializer_list%3Cint%3E%7B+(std::cout+%3C%3C+t+%3C%3C+%22+%22,+0)...+%7D%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++print(1,+2,+3,+5)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    template<typename... T>
    void print(T... t) {
      initializer_list<int>{ (cout << t << " ", 0)... };
    }

    print(1, 2, 3, 5);
    ```
  ],
)

#addproposal("N2242")
#addproposal("N2555")

== ``` std::enable_if```

- Classe template sur une expression booléenne et un type
- Définition du type seulement si l'expression booléenne est vraie
- Templates disponibles uniquement pour certains types

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ctype_traits%3E%0A%0Atemplate%3Cclass+T,+typename+std::enable_if%3Cstd::is_integral%3CT%3E::value,+T%3E::type*+%3D+nullptr%3E%0Avoid+foo(T+data)%0A%7B%0A++std::cout+%3C%3C+data+%3C%3C+%22%5Cn%22%3B%0A%7D%0A%0Atemplate%3Cclass+T,+typename+std::enable_if%3C!!std::is_integral%3CT%3E::value,+T%3E::type*+%3D+nullptr%3E%0Avoid+bar(T)%0A%7B%0A++std::cout+%3C%3C+%22Generique%5Cn%22%3B%0A%7D%0A%0Atemplate%3Cclass+T,typename+std::enable_if%3Cstd::is_integral%3CT%3E::value,+T%3E::type*+%3D+nullptr%3E%0Avoid+bar(T)%0A%7B%0A++std::cout+%3C%3C+%22Entier%5Cn%22%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++foo(42)%3B%0A%23if+0%0A++foo(%22azert%22)%3B%0A%23endif%0A%0A++bar(42)%3B%0A++bar(%22azert%22)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    template<class T,
    typename enable_if<is_integral<T>::value, T>::type* = nullptr>
    void foo(T data) { }

    foo(42);
    foo("azert");    // Erreur
    ```
  ],
)

== Types locaux en arguments templates

- Utilisation des types locaux non-nommés comme arguments templates

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Astruct+Less%0A%7B%0A++bool+operator()(int+a,+int+b)%0A++%7B%0A++++return+a+%3C+b%3B%0A++%7D%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B5,+2,+8,+12,+3%7D%3B%0A++std::sort(foo.begin(),+foo.end(),+Less())%3B%0A%0A++for(size_t+i+%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+%22+%22%3B%0A++%7D%0A++std::cout+%3C%3C+%22%5Cn%22%3B%0A%7D%0A%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo)
    struct Less {
      bool operator()(int a, int b) { return a < b; }
    };

    sort(foo.begin(), foo.end(), Less());
    ```
  ],
)

- Y compris des lambdas

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:17,positionColumn:1,positionLineNumber:17,selectionStartColumn:1,selectionStartLineNumber:17,startColumn:1,startLineNumber:17),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B5,+2,+8,+12,+3%7D%3B%0A++std::sort(foo.begin(),+foo.end(),+%5B%5D+(int+a,+int+b)+%7B+return+a+%3C+b%3B+%7D)%3B%0A%0A++for(size_t+i+%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+%22+%22%3B%0A++%7D%0A++std::cout+%3C%3C+%22%5Cn%22%3B%0A%7D%0A%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    sort(foo.begin(), foo.end(),
         [] (int a, int b) { return a < b; });
    ```
  ],
)

#addproposal("N2657")

== Type traits -- Helper

- Constante _compile-time_ ```cpp std::integral_constant```
- ```cpp std::integral_constant``` booléen vrai ```cpp true_type```
- ```cpp std::integral_constant``` booléen faux ```cpp false_type```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ctype_traits%3E%0A%0Atemplate+%3Cunsigned+n%3E%0Astruct+factorial+:+std::integral_constant%3Cint,+n*factorial%3Cn-1%3E::value%3E+%0A%7B%7D%3B%0A%0Atemplate+%3C%3E%0Astruct+factorial%3C0%3E+:+std::integral_constant%3Cint,+1%3E%0A%7B%7D%3B%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+factorial%3C5%3E::value+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    template <unsigned n>
    struct factorial
      : integral_constant<int, n*factorial<n-1>::value> {};

    template <>
    struct factorial<0>
      : integral_constant<int, 1> {};
    	factorial<5>::value;  // 120 en compile-time
    ```
  ],
)

#addproposal("n1836")

== Type traits -- Trait

- Détermine, à la compilation, les caractéristiques des types
- ```cpp std::is_array``` : tableau C

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:11,positionColumn:1,positionLineNumber:11,selectionStartColumn:1,selectionStartLineNumber:11,startColumn:1,startLineNumber:11),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%23include+%3Ctype_traits%3E%0A%0Aint+main()%0A%7B%0A%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_array%3Cint%3E::value+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_array%3Cint%5B3%5D%3E::value+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    is_array<int>::value;        // false
    is_array<int[3]>::value;     // true
    ```
  ],
)

- ```cpp std::is_integral``` : type entier

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:7,positionColumn:1,positionLineNumber:7,selectionStartColumn:1,selectionStartLineNumber:7,startColumn:1,startLineNumber:7),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%23include+%3Ctype_traits%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::is_integral%3Cshort%3E::value+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::is_integral%3Cstd::string%3E::value+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    is_integral<short>::value;   // true
    is_integral<string>::value;  // false
    ```
  ],
)

#addproposal("n1836")

== Type traits -- Trait

- ```cpp std::is_fundamental``` : type fondamental (entier, réel, ```cpp void``` ou ```cpp nullptr_t```)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:10,positionColumn:1,positionLineNumber:10,selectionStartColumn:1,selectionStartLineNumber:10,startColumn:1,startLineNumber:10),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%23include+%3Ctype_traits%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_fundamental%3Cshort%3E::value+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_fundamental%3Cstd::string%3E::value+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_fundamental%3Cvoid*%3E::value+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    is_fundamental<short>::value;   // true
    is_fundamental<string>::value;  // false
    is_fundamental<void*>::value;   // false
    ```
  ],
)

- ```cpp std::is_const``` : type constant

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:7,positionColumn:1,positionLineNumber:7,selectionStartColumn:1,selectionStartLineNumber:7,startColumn:1,startLineNumber:7),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%23include+%3Ctype_traits%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::is_const%3Cconst+short%3E::value+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::is_const%3Cstd::string%3E::value+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    is_const<const short>::value;  // true
    is_const<string>::value;       // false
    ```
  ],
)

#addproposal("n1836")

== Type traits -- Trait

- ```cpp std::is_base_of``` : base d'un autre type

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%23include+%3Ctype_traits%3E%0A%0Astruct+Foo%0A%7B%7D%3B%0A%0Astruct+Bar+:+Foo%0A%7B%7D%3B%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_base_of%3Cint,+int%3E::value+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_base_of%3Cstd::string,+std::string%3E::value+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_base_of%3CFoo,+Bar%3E::value+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_base_of%3CBar,+Foo%3E::value+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    struct Foo {};
    struct Bar : Foo {};

    is_base_of<int, int>::value;        // false
    is_base_of<string, string>::value;  // true
    is_base_of<Foo, Bar>::value;        // true
    is_base_of<Bar, Foo>::value;        // false
    ```
  ],
)

- Et bien d'autres ...

#addproposal("n1836")

== Type traits -- Transformations

- Construction d'un type par transformation d'un type existant
- ```cpp std::add_const``` : type ```cpp const```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ctype_traits%3E%0A%0Atypedef+std::add_const%3Cint%3E::type+A%3B%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_const%3CA%3E::value+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    typedef add_const<int>::type A;         // const int
    typedef add_const<const int>::type B;   // const int
    typedef add_const<const int*>::type C;  // const int* const
    ```
  ],
)

#addproposal("n1836")

== Type traits -- Transformations

- ```cpp std::make_unsigned``` : type non signé correspondant

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ctype_traits%3E%0A%0Aenum+Foo%0A%7B%0A++bar%0A%7D%3B%0A%0Atypedef+std::make_unsigned%3Cint%3E::type+A%3B%0Atypedef+std::make_unsigned%3CFoo%3E::type+B%3B%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_unsigned%3Cint%3E::value+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_unsigned%3CFoo%3E::value+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_unsigned%3CA%3E::value+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_unsigned%3CB%3E::value+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    enum Foo {bar};

    typedef make_unsigned<int>::type A;             // unsigned int
    typedef make_unsigned<unsigned>::type B;        // unsigned int
    typedef make_unsigned<const unsigned>::type C;  // const unsigned int
    typedef make_unsigned<Foo>::type D;             // unsigned int
    ```
  ],
)

- Et bien d'autres ...

#addproposal("n1836")

== Pointeurs intelligents

- RAII appliqué aux pointeurs et aux ressources allouées
- Objets à sémantique de pointeur gérant la durée de vie des objets
- Garantie de libération
- Garantie de cohérence
- Historiquement
  - ```cpp std::auto_ptr```
  - ```cpp boost::scoped_ptr``` et ```cpp boost::scoped_array```

== Pointeurs intelligents -- ``` std::unique_ptr```

- Responsabilité exclusive
- Non copiable, mais déplaçable
- Testable

```cpp
unique_ptr<int> p(new int);
*p = 42;
```

- ```cpp release()``` relâche la responsabilité de la ressource
// La ressource n'est pas libérée, mais le pointeur n'en a plus la responsabilité (pointeur brut retourné)
- ```cpp reset()``` change la ressource possédée
// L'objet précédemment pointé est libéré
// Possible de fournir un pointeur nullptr à reset() (valeur par défaut) pour simplement libérer l'objet contenu
- ```cpp get()``` récupère un pointeur brut sur la ressource
// P.ex. pour appeler une API C

#alertblock("Attention", text[
  Ne pas utilisez le pointeur retourné par ```cpp get()``` pour libérer la ressource
])

== Pointeurs intelligents -- ``` std::unique_ptr```

- Fourniture possible de la fonction de libération

```cpp
FILE *fp = fopen("foo.txt", "w");
unique_ptr<FILE, int(*)(FILE*)> p(fp, &fclose);
```

- Spécialisation pour les tableaux C
  - Sans ```cpp *``` et ```cpp ->```
  - Mais avec ```cpp []```

```cpp
std::unique_ptr<int[]> foo (new int[5]);
for(int i=0; i<5; ++i) foo[i] = i;
```

#noteblock("Dépréciation", text[
  Dépréciation de ```cpp std::auto_ptr```
])

== Pointeurs intelligents -- ``` std::shared_ptr```

- Responsabilité partagée de la ressource
- Comptage de références
- Copiable (incrémentation du compteur de références)
- Testable

```cpp
shared_ptr<int> p(new int());
*p = 42;
```

- ```cpp reset()``` change la ressource possédée
// Avec ajustement des compteurs de références et libération si nécessaire
- ```cpp use_count()``` retourne le nombre de possesseurs de la ressource
- ```cpp unique()``` indique si la possession est unique
- Fourniture possible de la fonction de libération

#addproposal("n1836")

== Pointeurs intelligents -- ``` std::make_shared()```

- Allocation et construction de l'objet dans le ```cpp std::shared_ptr```

```cpp
shared_ptr<int> p = make_shared<int>(42);
```

#noteblock("Objectifs", text[
  Pas de ```cpp new``` explicite, plus robuste

  ```cpp
  // Fuite possible en cas d'exception depuis bar()
  foo(shared_ptr<int>(new int(42)), bar());
  ```

  Allocation unique pour la ressource et le compteur de référence
])

#adviceblock("Do", text[
  Utilisez ```cpp std::make_shared()``` pour construire vos ```cpp std::shared_ptr```
])

== Pointeurs intelligents -- ``` std::weak_ptr```

- Aucune responsabilité sur la ressource
- Collabore avec ```cpp std::shared_ptr```
- ... sans impact sur le comptage de références
- Pas de création depuis un pointeur nu

#noteblock("Objectif", text[
  Rompre les cycles
])

```cpp
shared_ptr<int> sp(new int(20));
weak_ptr<int> wp(sp);
```

#addproposal("n1836")

== Pointeurs intelligents -- ``` std::weak_ptr```

- Pas d'accès à la ressource
- Convertible en ```cpp std::shared_ptr``` via ```cpp lock()```
// Retourne un std::shared_ptr vide si la ressource n'existe plus

```cpp
shared_ptr<int> sp = wp.lock();
```

- ```cpp reset()``` vide le pointeur
- ```cpp use_count()``` retourne le nombre de possesseurs de la ressource
// Possesseurs aux nombres desquels notre std::weak_ptr n'appartient pas
- ```cpp expired()``` indique si le ```cpp std::weak_ptr``` ne référence pas une ressource valide
// Soit il pointe sur rien, soit la ressource a été libérée car n'avait plus de std::shared_ptr sur elle

#addproposal("n1836")

== Pointeurs intelligents -- Conclusion

#alertblock("Don't", text[
  N'utilisez pas de pointeurs bruts possédants
])

#adviceblock("Do", text[
  Réfléchissez à la responsabilité de vos ressources
])

#adviceblock("Do", text[
  Préférez ```cpp std::unique_ptr``` à ```cpp std::shared_ptr```
])

#adviceblock("Do", text[
  Préférez une responsabilité unique à une responsabilité partagée
])

== Pointeurs intelligents -- Conclusion

#adviceblock("Do", text[
  Brisez les cycles à l'aide de ```cpp std::weak_ptr```
])

#alertblock("Attention", text[
  Passez par un ```cpp std::unique_ptr``` temporaire intermédiaire pour insérer des éléments dans un conteneur de ```cpp std::unique_ptr```

  Voir #link("https://accu.org/index.php/journals/2271")[Overload 134 - C++ Antipatterns #linklogo()]
  // push_back d'un pointeur brute n'est pas possible et emplace_back peut échouer en laissant fuir le pointeur
])

#adviceblock("Do", text[
  Transférez au plus tôt la responsabilité à un pointeur intelligent
])

== Pointeurs intelligents -- Conclusion

#noteblock("Pour aller plus loin", text[
  Voir #link("http://loic-joly.developpez.com/tutoriels/cpp/smart-pointers/")[Pointeurs intelligents #linklogo() (Loïc Joly)]
])

#noteblock("Sous silence", text[
  Allocateurs, mémoire non-initialisée, alignement, ...
])

#noteblock("Mais aussi", text[
  Support minimal des _Garbage Collector_
  // Support enlevé en C++23 : trop restrictif, inutilisé, conceptions très différentes et variés dans les langages à GC

  Mais pas de GC standard
])

== Attributs

- Syntaxe standard pour les directives de compilation _inlines_
- ... y compris celles spécifiques à un compilateur
- Remplace la directive ```cpp #pragma```
- Et les mots-clé propriétaires (```cpp __attribute__```, ```cpp __declspec```)

```cpp
[[ attribut ]]
```

- Peut être multiple

```cpp
[[ attribut1, attribut2 ]]
```

#addproposal("N2761")

== Attributs

- Peut prendre des arguments

```cpp
[[ attribut(arg1, arg2) ]]
```

- Peut être dans un namespace et spécifique à une implémentation

```cpp
[[ vendor::attribut ]]
```

#noteblock("Exemple", text[
  les attributs ```cpp gsl``` des "C++ Core Guidelines Checker" de Microsoft

  ```cpp
  [[ gsl::suppress(26400) ]]
  ```
])

#addproposal("N2761")

== Attributs

- Placé après le nom pour les entités nommées

```cpp
int [[ attribut1 ]] i [[ attribut2 ]];
// Attribut1 s'applique au type
// Attribut2 s'applique a i
```

- Placé avant l'entité sinon

```cpp
[[ attribut ]] return i;
// Attribut s'applique au return
```

#adviceblock("Bonus", text[
  Aussi une information à destination des développeurs
])

#addproposal("N2761")

== Attribut ``` [[ noreturn ]]```

- Indique qu'une fonction ne retourne pas

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cexception%3E%0A%0A%5B%5B+noreturn+%5D%5D+void+foo()%0A%7B%0A%23if+0%0A++throw+std::runtime_error(%22foo%22)%3B%0A%23endif%0A%7D%0A%0Aint+main()%0A%7B%0A++foo()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    [[ noreturn ]] void foo() { throw "error"; }
    ```
  ],
)

#alertblock("Attention", text[
  Qui ne retourne pas

  Pas qui ne retourne rien
])

#noteblock("Usage", text[
  Boucle infinie, sortie de l'application, exception systématique
])

#noteblock("Sous silence", text[
  ```cpp [[ carries_dependency ]]```
])

#addproposal("N2761")

== Rapport

// La rapport est dans le type, pas dans les valeurs ou les instances

- ```cpp std::ratio``` représente un rapport entre deux nombres
- Numérateur et dénominateur sont des paramètres templates
- ```cpp num``` accède au numérateur
- ```cpp den``` accède au dénominateur

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cratio%3E%0A%0Aint+main()%0A%7B%0A++std::ratio%3C6,+2%3E+r%3B%0A++std::cout+%3C%3C+r.num+%3C%3C+!'/!'+%3C%3C+r.den+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    ratio<6, 2> r;
    cout << r.num << "/" << r.den;   // 3/1
    ```
  ],
)

- Instanciations standards des préfixes du système international d'unités
  - yocto, zepto, atto, femto, pico, nano, micro, milli, centi, déci
  - déca, hecto, kilo, méga, giga, téra, péta, exa, zetta, yotta

== Rapport

- Méta-fonctions arithmétiques
  - ```cpp std::ratio_add()```, ```cpp std::ratio_subtract()```
  - ```cpp std::ratio_multiply()```, ```cpp std::ratio_divide()```
// Méta car elles agissent sur les types et non sur les valeurs

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:10,positionColumn:1,positionLineNumber:10,selectionStartColumn:1,selectionStartLineNumber:10,startColumn:1,startLineNumber:10),source:'%23include+%3Ciostream%3E%0A%23include+%3Cratio%3E%0A%0Aint+main()%0A%7B%0A++std::ratio_add%3Cstd::ratio%3C6,+2%3E,+std::ratio%3C2,+3%3E%3E+r%3B%0A%0A++std::cout+%3C%3C+r.num+%3C%3C+!'/!'+%3C%3C+r.den+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    ratio_add<ratio<6, 2>, ratio<2, 3>> r;
    cout << r.num << "/" << r.den;   // 11/3
    ```
  ],
)

- Méta-fonctions de comparaison
  - ```cpp std::ratio_equal()```, ```cpp std::ratio_not_equal()```
  - ```cpp std::ratio_less()```, ```cpp std::ratio_less_equal()```
  - ```cpp std::ratio_greater()``` et ```cpp std::ratio_greater_equal()```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:9,positionColumn:1,positionLineNumber:9,selectionStartColumn:1,selectionStartLineNumber:9,startColumn:1,startLineNumber:9),source:'%23include+%3Ciostream%3E%0A%23include+%3Cratio%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::boolalpha+%0A++++++++++++%3C%3C+std::ratio_less_equal%3Cstd::ratio%3C6,+2%3E,+std::ratio%3C2,+3%3E%3E::value+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    ratio_less_equal<ratio<6, 2>, ratio<2, 3>>::value;  // false
    ```
  ],
)

== Durées

- Classe template ```cpp std::chrono::duration```
- Unité dépendante d'un ratio avec la seconde
- Instanciations standards _hours_, _minutes_, _seconds_, _milliseconds_, _microseconds_ et _nanosecond_

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:10,positionColumn:1,positionLineNumber:10,selectionStartColumn:1,selectionStartLineNumber:10,startColumn:1,startLineNumber:10),source:'%23include+%3Ciostream%3E%0A%23include+%3Cchrono%3E%0A%0Aint+main()%0A%7B%0A++std::chrono::milliseconds+foo(12000)%3B%0A%0A++std::cout+%3C%3C+foo.count()+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    milliseconds foo(12000);  // 12000 ms
    foo.count();              // 12000
    ```
  ],
)

- ```cpp count()``` retourne la valeur
- ```cpp period``` est le type représentant le ratio

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:8,positionColumn:1,positionLineNumber:8,selectionStartColumn:1,selectionStartLineNumber:8,startColumn:1,startLineNumber:8),source:'%23include+%3Ciostream%3E%0A%23include+%3Cchrono%3E%0A%0Aint+main()%0A%7B%0A++std::chrono::milliseconds+foo(12000)%3B%0A%0A++std::cout+%3C%3C+foo.count()+*+std::chrono::milliseconds::period::num+/+std::chrono::milliseconds::period::den+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    milliseconds foo(12000);
    foo.count() * milliseconds::period::num /
                  milliseconds::period::den;  // 12
    ```
  ],
)

== Durées

- Opérateurs de manipulation des durées (ajout, suppression, ...)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cchrono%3E%0A%0Aint+main()%0A%7B%0A++std::chrono::milliseconds+foo(500)%3B%0A++std::chrono::milliseconds+bar(10)%3B%0A%0A++foo+%2B%3D+bar%3B%0A++std::cout+%3C%3C+foo.count()+%3C%3C+!'%5Cn!'%3B%0A%0A++foo+/%3D+2%3B%0A++std::cout+%3C%3C+foo.count()+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    milliseconds foo(500);
    milliseconds bar(10);
    foo += bar;   // 510
    foo /= 2;     // 255
    ```
  ],
)

- Opérateurs de comparaison entre durées
- ```cpp zero()``` crée une durée nulle
- ```cpp min()``` crée la plus petite valeur possible
- ```cpp max()``` crée la plus grande valeur possible

== Temps relatif

- ```cpp std::chrono::time_point``` temps relatif depuis l'epoch

#noteblock("Epoch", text[
  Origine des temps de l'OS (1 janvier 1970 00h00 sur Unix)
])

- ```cpp time_since_epoch()``` retourne la durée depuis l'epoch
- Opérateurs d'ajout et de suppression d'une durée
- Opérateurs de comparaison entre ```cpp time_point```
- ```cpp min()``` retourne le plus petit temps relatif
- ```cpp max()``` retourne le plus grand temps relatif

== Horloges

- Horloge temps-réel du système ```cpp std::chrono::system_clock```
- ```cpp now()``` récupère temps courant

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:9,positionColumn:1,positionLineNumber:9,selectionStartColumn:1,selectionStartLineNumber:9,startColumn:1,startLineNumber:9),source:'%23include+%3Ciostream%3E%0A%23include+%3Cchrono%3E%0A%0Aint+main()%0A%7B%0A++std::chrono::system_clock::time_point+today+%3D+std::chrono::system_clock::now()%3B%0A++std::cout+%3C%3C+today.time_since_epoch().count()+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    system_clock::time_point today = system_clock::now();
    today.time_since_epoch().count();
    ```
  ],
)

- ```cpp to_time_t()``` converti en ```cpp time_t```
- ```cpp fromtime_t()``` construit depuis ```cpp time_t```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:11,positionColumn:1,positionLineNumber:11,selectionStartColumn:1,selectionStartLineNumber:11,startColumn:1,startLineNumber:11),source:'%23include+%3Ciostream%3E%0A%23include+%3Cchrono%3E%0A%0Aint+main()%0A%7B%0A++std::chrono::system_clock::time_point+today+%3D+std::chrono::system_clock::now()%3B%0A%0A++time_t+tt+%3D+std::chrono::system_clock::to_time_t(today)%3B%0A++std::cout+%3C%3C+ctime(%26tt)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    system_clock::time_point today = system_clock::now();
    time_t tt = system_clock::to_time_t(today);
    ctime(&tt);
    ```
  ],
)

== Horloges

- Horloge monotone de mesure des intervalles ```cpp std::chrono::steady_clock```
// Monotone, c'est à dire que cette horloge n'est jamais réglée, en particulier une mise à l'heure durant la mesure n'a pas d'impact sur la mesure
// Pas le cas de std::chrono::system_clock qui mesure le temps par rapport à epoch et dont la valeur est impactée par la mise à l'heure
// A priori, sous Linux, pas d'appel système pour récupérer la valeur

- ```cpp now()``` récupère temps courant

```cpp
steady_clock::time_point t1 = steady_clock::now();
...
steady_clock::time_point t2 = steady_clock::now();
duration<double> time_span =
duration_cast<duration<double>>(t2 - t1);
```

== Horloges

- Horloge avec le plus petit intervalle entre deux _ticks_ ```cpp std::chrono::high_resolution_clock```
- Possible synonyme de ```cpp std::chrono::system_clock``` ou ```cpp std::chrono::steady_clock```

#adviceblock("Do", text[
  Préférez ```cpp std::clock::duration``` aux entiers pour manipuler les durées
])

#alertblock("Attention", text[
  N'espérez pas une précision arbitrairement grande des horloges
])

== Thread Local Storage

- Spécificateur de classe de stockage ```cpp thread_local```
- Influant sur la durée de stockage
- Compatible avec ```cpp static``` et ```cpp extern```
- Rend propres au thread des objets normalement partagés
// Typiquement des variables globales ou statiques
// C'est à dire qu'il y a une instance de la variable par thread
- Instance propre au thread créée à la création du thread
- Valeur initiale héritée du thread créateur

```cpp
thread_local int foo = 0;
```

#addproposal("N2659")

== Variables atomiques -- ``` std::atomic```

- Encapsulation de types de base fournissant des opérations atomiques
- Atomicité de l'affectation, de l'incrémentation et de la décrémentation

```cpp
atomic<int> foo{5};
++foo;
```

- ```cpp store()``` stocke une nouvelle valeur
- ```cpp load()``` lit la valeur
- ```cpp exchange()``` met à jour et retourne la valeur avant modification

#addproposal("N2427")

== Variables atomiques -- ``` std::atomic```

- ```cpp compare_exchange_weak``` et ```cpp compare_exchange_strong```
  // Différence weak / strong : weak peu échouer dans certains cas. Lorsque cela se produit, aucune valeur n'est modifiée

  - Si ```cpp std::atomic``` est égal à la valeur attendue, il est mis à jour avec une valeur fournie
  - Sinon, il n'est pas modifié et la valeur attendue prends la valeur de ```cpp std::atomic```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Catomic%3E%0A%0Aint+main()%0A%7B%0A++std::atomic%3Cint%3E+foo%7B5%7D%3B%0A++int+bar%7B5%7D%3B%0A%0A++foo.compare_exchange_strong(bar,+10)%3B%0A++std::cout+%3C%3C+foo+%3C%3C+%22+%22+%3C%3C+bar+%3C%3C+%22%5Cn%22%3B%0A++foo.compare_exchange_strong(bar,+8)%3B%0A++std::cout+%3C%3C+foo+%3C%3C+%22+%22+%3C%3C+bar+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    atomic<int> foo{5};
    int bar{5};

    foo.compare_exchange_strong(bar, 10);  // foo : 10, bar : 5
    foo.compare_exchange_strong(bar, 8);   // foo : 10, bar : 10
    ```
  ],
)

#addproposal("N2427")

== Variables atomiques -- ``` std::atomic```

- ```cpp fetch_add()``` addition et retour de la valeur avant modification

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Catomic%3E%0A%0Aint+main()%0A%7B%0A++std::atomic%3Cint%3E+foo%7B5%7D%3B%0A%0A++std::cout+%3C%3C+foo.fetch_add(10)+%3C%3C+%22+%22%3B%0A++std::cout+%3C%3C+foo%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    	atomic<int> foo{5};

    	cout << foo.fetch_add(10) << " ";
    	cout << foo;        // Affiche 5 15
    ```
  ],
)

- ```cpp fetch_sub()``` soustraction et retour de la valeur avant modification
- ```cpp fetch_and()``` et binaire et retour de la valeur avant modification
- ```cpp fetch_or()``` ou binaire et retour de la valeur avant modification
- ```cpp fetch_xor()``` ou exclusif et retour de la valeur avant modification

#addproposal("N2427")

== Variables atomiques -- ``` std::atomic```

- Plusieurs instanciations standards (```cpp atomic_bool```, ```cpp atomic_int```, ...)

#noteblock("Mais aussi", text[
  Plusieurs fonctions "C-style", similaires aux fonctions membres de ```cpp std::atomic```, manipulant atomiquement des données
])

#addproposal("N2427")

== Variables atomiques -- ``` std::atomic_flag```

- Gestion atomique de _flags_
- Non copiable, non déplaçable, _lock free_
- ```cpp clear()``` remet à 0 le _flag_
- ```cpp test_and_set()``` lève le _flag_ et retourne sa valeur avant modification

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Catomic%3E%0A%0Aint+main()%0A%7B%0A++std::atomic_flag+foo+%3D+ATOMIC_FLAG_INIT%3B%0A%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+foo.test_and_set()+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+foo.test_and_set()+%3C%3C+%22%5Cn%22%3B%0A++foo.clear()%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+foo.test_and_set()+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    atomic_flag foo = ATOMIC_FLAG_INIT;

    foo.test_and_set();  // false
    foo.test_and_set();  // true
    foo.clear();
    foo.test_and_set();  // false
    ```
  ],
)

#addproposal("N2427")

== Threads -- ``` std::thread```

- Représente un fil d'exécution
- Déplaçable mais non copiable
- Constructible depuis une fonction et sa liste de paramètre

```cpp
void foo(int);

thread t(foo, 10);
```

- Thread initialisé démarre immédiatement
- ```cpp joignable()``` indique si le thread est joignable
  - Pas construit par défaut
  - Pas été déplacé
  - Ni joint ni détaché

== Threads -- ``` std::thread```

- ```cpp join()``` attend la fin d'exécution du thread
- ```cpp detach()``` détache le thread

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cthread%3E%0A%23include+%3Cchrono%3E%0A%0Avoid+foo(size_t+imax)%0A%7B%0A++for(size_t+i+%3D+0%3B+i+%3C+imax%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+%22thread+%22+%3C%3C+i+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%7D%0A%0Aint+main()%0A%7B%0A++size_t+imax+%3D+40%3B%0A++std::thread+t(foo,+imax)%3B%0A%0A++for(size_t+i+%3D+0%3B+i+%3C+imax%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+%22main+%22+%3C%3C+i+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A++t.join()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    void foo(size_t imax) {
      for(size_t i = 0; i < imax; ++i)
        cout << "thread " << i << '\n';
    }

    size_t imax = 40;
    thread t(foo, imax);

    for(size_t i = 0; i < imax; ++i)
      cout << "main " << i << '\n';
    t.join();
    ```
  ],
)

== Threads -- ``` std::this_thread```

- Représente le thread courant
- ```cpp yield()``` permet de "passer son tour"
// C'est à dire d'indiquer à l'ordonnanceur qu'il peut replanifier
- ```cpp sleep_for()``` suspend l'exécution sur la durée spécifiée

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cthread%3E%0A%23include+%3Cchrono%3E%0A%0Aint+main()%0A%7B%0A++std::this_thread::sleep_for(std::chrono::seconds(5))%3B%0A++std::cout+%3C%3C+%22Main%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    this_thread::sleep_for(chrono::seconds(5));
    ```
  ],
)

- ```cpp sleep_until()``` suspend le thread jusqu'au temps demandé

#alertblock("Attention", text[
  Ne vous attendez pas à des attentes arbitrairement précises
  // À l'échéance, le thread n'interrompt pas les autres pour reprendre la main
])

#noteblock("Attentes passives", text[
  Les autres threads continuent de s'exécuter
])

== Mutex -- ``` std::mutex```

- Verrou pour l'accès exclusif à une section de code
- ```cpp lock()``` verrouille le mutex
- ... en attendant sa libération s'il est déjà verrouillé
- ```cpp try_lock()``` verrouille le mutex s'il est libre, retourne ```cpp false``` sinon
- ```cpp unlock()``` relâche le mutex

#alertblock("Attention", text[
  ```cpp lock()``` sur un mutex verrouillé par le même thread provoque un _deadlock_
])

- ```cpp std::recursive_mutex``` verrouillable plusieurs fois par un même thread
// Il faut le relâcher autant de fois pour qu'il soit effectivement non verrouillé

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cthread%3E%0A%23include+%3Cchrono%3E%0A%23include+%3Cmutex%3E%0A%0Astd::mutex+g_mutex%3B%0A%0Avoid+foo(size_t+imax)%0A%7B%0A++for(size_t+i+%3D+0%3B+i+%3C+imax%3B+%2B%2Bi)%0A++%7B%0A++++g_mutex.lock()%3B%0A++++std::cout+%3C%3C+%22thread+%22+%3C%3C+i+%3C%3C+!'%5Cn!'%3B%0A++++g_mutex.unlock()%3B%0A++++std::this_thread::sleep_for(std::chrono::milliseconds(10))%3B%0A++%7D%0A%7D%0A%0Aint+main()%0A%7B%0A++size_t+imax+%3D+40%3B%0A++std::thread+t(foo,+imax)%3B%0A%0A++for(size_t+i+%3D+0%3B+i+%3C+imax%3B+%2B%2Bi)%0A++%7B%0A++++g_mutex.lock()%3B%0A++++std::cout+%3C%3C+%22main+%22+%3C%3C+i+%3C%3C+!'%5Cn!'%3B%0A++++g_mutex.unlock()%3B%0A++++std::this_thread::sleep_for(std::chrono::milliseconds(10))%3B%0A++%7D%0A++t.join()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Mutex -- ``` std::timed_mutex```

- Similaire à ```cpp std::mutex```
- ... proposant en complément des _try lock_ temporisés
- ```cpp try_lock_for()``` attend, si le mutex est verrouillé, la libération de celui-ci ou l'expiration d'une durée
- ```cpp try_lock_until()``` attend, si le mutex est verrouillé, la libération de celui-ci ou l'atteinte d'un temps
- ```cpp std::recursive_timed_mutex``` est une variante de ```cpp std::timed_mutex``` verrouillable plusieurs fois par un même thread

== Mutex -- ``` std::lock_guard```

- Capsule RAII sur les mutex
- Constructible uniquement depuis un mutex
- Verrouille le mutex à la création et le relâche à la destruction

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cthread%3E%0A%23include+%3Cchrono%3E%0A%23include+%3Cmutex%3E%0A%0Astd::mutex+mtx%3B%0A%0Avoid+foo(size_t+imax)%0A%7B%0A++for(size_t+i+%3D+0%3B+i+%3C+imax%3B+%2B%2Bi)%0A++%7B%0A++++%7B%0A++++++std::lock_guard%3Cstd::mutex%3E+lock(mtx)%3B%0A++++++std::cout+%3C%3C+%22thread+%22+%3C%3C+i+%3C%3C+!'%5Cn!'%3B%0A++++%7D%0A++++std::this_thread::sleep_for(std::chrono::milliseconds(10))%3B%0A++%7D%0A%7D%0A%0Aint+main()%0A%7B%0A++size_t+imax+%3D+40%3B%0A++std::thread+t(foo,+imax)%3B%0A%0A++for(size_t+i+%3D+0%3B+i+%3C+imax%3B+%2B%2Bi)%0A++%7B%0A++++%7B%0A++++++std::lock_guard%3Cstd::mutex%3E+lock(mtx)%3B%0A++++++std::cout+%3C%3C+%22main+%22+%3C%3C+i+%3C%3C+!'%5Cn!'%3B%0A++++%7D%0A++++std::this_thread::sleep_for(std::chrono::milliseconds(10))%3B%0A++%7D%0A++t.join()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    mutex mtx;
    {
      lock_guard<mutex> lock(mtx);  // Prise du mutex
      ...
    }  // Liberation du mutex
    ```
  ],
)

#noteblock("Note", text[
  Gestion du mutex entièrement confiée au _lock_
])

== Mutex -- ``` std::unique_lock```

- Capsule RAII des mutex
- Supporte les mutex verrouillés ou non
- Relâche le mutex à la destruction
- Expose les méthodes de verrouillage et libération des mutex

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cthread%3E%0A%23include+%3Cchrono%3E%0A%23include+%3Cmutex%3E%0A%0Astd::mutex+mtx%3B%0A%0Avoid+foo(size_t+imax)%0A%7B%0A++for(size_t+i+%3D+0%3B+i+%3C+imax%3B+%2B%2Bi)%0A++%7B%0A++++%7B%0A++++++std::unique_lock%3Cstd::mutex%3E+lock(mtx,+std::defer_lock)%3B%0A++++++lock.lock()%3B%0A++++++std::cout+%3C%3C+%22thread+%22+%3C%3C+i+%3C%3C+!'%5Cn!'%3B%0A++++%7D%0A++++std::this_thread::sleep_for(std::chrono::milliseconds(10))%3B%0A++%7D%0A%7D%0A%0Aint+main()%0A%7B%0A++size_t+imax+%3D+40%3B%0A++std::thread+t(foo,+imax)%3B%0A%0A++for(size_t+i+%3D+0%3B+i+%3C+imax%3B+%2B%2Bi)%0A++%7B%0A++++%7B%0A++++++std::lock_guard%3Cstd::mutex%3E+lock(mtx)%3B%0A++++++std::cout+%3C%3C+%22main+%22+%3C%3C+i+%3C%3C+!'%5Cn!'%3B%0A++++%7D%0A++++std::this_thread::sleep_for(std::chrono::milliseconds(10))%3B%0A++%7D%0A++t.join()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    mutex mtx;
    {
      unique_lock<mutex> lock(mtx, defer_lock);
      ...
      lock.lock();  // Prise du mutex
      ...
    }  // Liberation du mutex
    ```
  ],
)

== Mutex -- ``` std::unique_lock```

- Comportements multiples à de la création
  - Verrouillage immédiat
  - Tentative de verrouillage
  - Acquisition sans verrouillage
  - Acquisition d'un mutex déjà verrouillé
- ```cpp mutex()``` retourne le mutex associé
- ```cpp owns_lock()``` teste si le _lock_ a un mutex associé et l'a verrouillé
- ```cpp operator bool()``` encapsule ```cpp owns_lock()```

#noteblock("Note", text[
  Gestion du mutex conservée, garantie de libération
])

== Mutex -- Gestion multiple

- ```cpp std::lock()``` verrouille tous les mutex passés en paramètre
- ... sans produire de _deadlock_

#codesample(
  "https://godbolt.org/#z:OYLghAFBqd5QCxAYwPYBMCmBRdBLAF1QCcAaPECAMzwBtMA7AQwFtMQByARg9KtQYEAysib0QXACx8BBAKoBnTAAUAHpwAMvAFYTStJg1DIApACYAQuYukl9ZATwDKjdAGFUtAK4sGe1wAyeAyYAHI%2BAEaYxHoADqgKhE4MHt6%2BcQlJAkEh4SxRMVy2mPaOAkIETMQEqT5%2BRXaYDskVVQQ5YZHRegqV1bXpDX3twZ353VwAlLaoXsTI7BzmAMzByN5YANQmy25OvcSYrDvYJhoAgitrG5jbuwQIh0zoJ2eXZqsM615bO27IjwEqFeFyuXxudzcLC8BEwqhBlwuvXQIBA0Nhqk2LAIqiKWJxZh2VlBFwAbqg8OhNvxUBBEgAvTAAfQImzwLCYqkmbxMAHZiedNtSSHS8IyWWy7gARTYaImSv5sjnw5YWbaWax4bkXIV8gVC3X8t4Gg3I1G0VDIADWTOAXiqL12ZrRMLhJ02FutXAg2Nx3NVxpNm2daBhkMV5jMDye6C46rM4d2Ct2irASwArG4GGmiYHDVK88GCCiQA88AoWY8jiWFPRMLEmfxiHTi6iAcQgaiWHRaOWmgJ0AoIFwNJN/frtryC6CpzyyRSqREqqLxaz2ZztZcjTrhc2Gcy19LZfK8JClZz5dZNZvDRPb4Whc7PTa7Q6/s70W7ltgPZarWYfQJccHyLEtQ1ZP4IzMKMq2eBNI0TNxkzcVMMyzHMAx3fNC2dMsK2jatUVrTB60bEUQ0BBhUC7Hs%2BzQBhB2HdMx1zHc%2BWnLcOLeYJWQ5YIIE3PVA33CV10xHYZUkOVMMFUDUQI55NgIb0aVIc8uVY2TcNgqkCAApcyHU4CSVkpsVwPZMZWktVT0VMTLw1SwtUDISsMnO9TVbEBn0A3E1N9MxjNkk0nz/W17WIR03A/V0VR/Z9vV9PFnWeVBYgIJlnyCoM5O8sLX0i98vM/OLf2tACArUlL0DSjKss0nKQ1mCCUyTSM%2BIYeNEOQ1CTEzbMlhkk12Jwry8MrGMiLrBszIojsqJo2heyUejGJHFihsnDihWUgA6bQKQYASGqUsx9sO46ZJGi4OGmWhOHTXg/A4LRSGojgUMctUFFmeZbhWHhSAITRbumK0QHTDR9E4SQnpBt7OF4BQQCh4GXtu0g4FgJA4SaGESHISgqmABRlEMEohAQVAAHdnsBtAWFiOgmDKBgyZCWhKZp57XoZpn6BiEnmFiBQqYIUg%2BboaJQlYRZeElgWAHkYS52n4dx5BzmIEnEdIDWKnwZ7eH4QQRDEdgpBkQRFBUdR0dIXQigMIwUCvSx9DwCJkcgaZauSZGOAAWmRCTTC%2Brg40DgB1MRaE2aO4QIYgmF4VBSWiYhKUwb2BNIYgvEEdlMAAFVQTwc%2BmH65gWHpi2CdmKaptXuF4JOSM4QHqeT2IQbuh64ft97sFUPGiGITZVAADgANkD6fJE2YBkGQTYICTgurUmVfPqsd3NlwQgSHVZYplb3vpgQatulz8HIehjhYdIHnU915HUfP%2B%2BzAH173rP9Gx1IOnYgiRnCSCAA%3D%3D",
  code: [
    ```cpp
    mutex mtx1, mtx2;
    lock(mtx1, mtx2);
    ```
  ],
)

- ```cpp std::try_lock``` tente de verrouiller dans l'ordre tous les mutex passés en paramètre
- ... et relâche les mutex déjà pris en cas d'échec sur l'un d'eux

== Mutex -- ``` std::call_once()```

- Garantit l'appel unique (pour un _flag_ donnée) de la fonction en paramètre
- Si la fonction a déjà été exécutée, ```cpp std::call_once()``` retourne sans exécuter la fonction
- Si la fonction est en cours d'exécution, ```cpp std::call_once()``` attend la fin de cette exécution avant de retourner

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cmutex%3E%0A%0Avoid+foo(int+a,+char+b)%0A%7B%0A++std::cout+%3C%3C+a+%3C%3C+%22-%22+%3C%3C+b+%3C%3C+%22%5Cn%22%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::once_flag+flag%3B%0A++std::once_flag+other%3B%0A%0A++std::call_once(flag,+foo,+42,+!'r!')%3B%0A++std::call_once(flag,+foo,+43,+!'s!')%3B%0A++std::call_once(other,+foo,+44,+!'t!')%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    void foo(int, char);

    once_flag flag;
    call_once(flag, foo, 42, 'r');
    ```
  ],
)

#noteblock("Cas d'utilisation", text[
  Appelle par un unique thread d'une fonction d'initialisation
])

== Variables conditionnelles -- Principe

- Mise en attente du thread sur la variable conditionnelle
- Réveil du thread lors de la notification de la variable
- Protection par verrou
  - Prise du verrou avant l'appel à la fonction d'attente
  - Relâchement du verrou par la fonction
  - Reprise du verrou lors de la notification avant le déblocage du thread

== Variables conditionnelles -- ``` condition_variable```

- Uniquement avec ```cpp std::unique_lock```
- ```cpp wait()``` met en attente le thread

```cpp
mutex mtx;
condition_variable cv;

unique_lock<std::mutex> lck(mtx);
cv.wait(lck);
```

#noteblock("Note", text[
  Possibilité de fournir un prédicat
  - Blocage seulement s'il retourne ```cpp false```
  - Déblocage seulement s'il retourne ```cpp true```
])

== Variables conditionnelles -- ``` condition_variable```

- ```cpp wait_for()``` met en attente le thread, au maximum la durée donnée
- ```cpp wait_until()``` met en attente le thread, au maximum jusqu'au temps donné

#noteblock("Note", text[
  ```cpp wait_for()``` et ```cpp wait_until()``` indique si l'exécution a repris suite à un timeout
])

== Variables conditionnelles -- ``` condition_variable```

- ```cpp notify_one()``` notifie un des threads en attente sur la variable conditionnelle

#alertblock("Attention", text[
  Impossible de choisir quel thread notifié avec ```cpp notify_one()```
])

- ```cpp notify_all()``` notifie tous les threads en attente
- ```cpp std::condition_variable_any``` similaire à ```cpp std::condition_variable```
- ... sans être limité à ```cpp std::unique_lock```
- ```cpp std::notify_all_at_thread_exit()```
  - Indique de notifier tous les threads à la fin du thread courant
  - Prend un verrou qui sera libéré à la fin du thread

== Variables conditionnelles -- ``` condition_variable```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cthread%3E%0A%23include+%3Cchrono%3E%0A%23include+%3Cmutex%3E%0A%23include+%3Ccondition_variable%3E%0A%0Astd::mutex+mtx%3B%0Astd::condition_variable+cv%3B%0A%0Avoid+print_id(int+id)%0A%7B%0A++std::unique_lock%3Cstd::mutex%3E+lck(mtx)%3B%0A++cv.wait(lck)%3B%0A++std::cout+%3C%3C+%22thread+%22+%3C%3C+id+%3C%3C+!'%5Cn!'%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::thread+threads%5B10%5D%3B%0A%0A++for(int+i+%3D+0%3B+i%3C10%3B+%2B%2Bi)%0A++%7B%0A++++threads%5Bi%5D+%3D+std::thread(print_id,+i)%3B%0A++%7D%0A++std::this_thread::sleep_for(std::chrono::seconds(5))%3B%0A++cv.notify_all()%3B%0A%0A++for(auto%26+th+:+threads)%0A++%7B%0A++++th.join()%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    mutex mtx;
    condition_variable cv;

    void print_id(int id) {
      unique_lock<mutex> lck(mtx);
      cv.wait(lck);
      cout << "thread " << id << '\n';
    }

    thread threads[10];
    for(int i = 0; i<10; ++i)
      threads[i] = thread(print_id, i);
    this_thread::sleep_for(chrono::seconds(5));
    cv.notify_all();
    for(auto& th : threads) th.join();
    ```
  ],
)

== Futures et promise -- Principe

- ```cpp std::promise``` contient une valeur
  - Disponible ultérieurement
  - Récupérable, éventuellement dans un autre thread, via ```cpp std::future```
- ```cpp std::future``` permet la récupération d'une valeur disponible ultérieurement
  - Depuis un ```cpp std::promise```
  - Depuis un appel asynchrone ou différé de fonction
- Mécanismes asynchrones
- ```cpp std::future``` définissent des points de synchronisation

#noteblock("Note", text[
  ```cpp std::promise``` et ```cpp std::future``` peuvent également manipuler des exceptions
])

== Futures et promise -- ``` std::future```

- Utilisable uniquement s'il est valide (associé à un état partagé)
- Construit valide que par certaines fonctions fournisseuses
- Déplaçable mais non copiable
- Prêt lorsque la valeur, ou une exception, est disponible
- ```cpp valid()``` teste s'il est valide
- ```cpp wait()``` attend qu'il soit prêt
- ```cpp wait_for()``` attend qu'il soit prêt, au plus la durée donnée
- ```cpp wait_until()``` attend qu'il soit prêt, au plus jusqu'au temps donné
- ```cpp get()``` attend qu'il soit prêt, retourne la valeur (ou lève l'exception) et libère l'état partagé

== Futures et promise -- ``` std::future```

- ```cpp share()``` construit un ```cpp std::shared_future``` depuis le ```cpp std::future```

#alertblock("Attention", text[
  Après un appel à ```cpp share()```, le ```cpp std::future``` n'est plus valide
])

- ```cpp std::shared_future``` similaires à ```cpp std::future```
  - Mais copiables
  - Responsabilité partagée sur l'état partagé
  - Valeur lisible à plusieurs reprises

== Futures et promise -- ``` std::async()```

- Appelle la fonction fournie
- Et retourne, sans attendre la fin de l'exécution, un ```cpp std::future```
- ```cpp std::future``` permettant de récupérer la valeur de retour de la fonction

#noteblock("Note", text[
  Deux politiques d'exécution de la fonction appelée
  - Exécution asynchrone
  - Exécution différée à l'appel de ```cpp wait()``` ou ```cpp get()```
  Le choix par défaut est laissé à l'implémentation
])

== Futures et promise -- ``` std::async()```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cthread%3E%0A%23include+%3Cchrono%3E%0A%23include+%3Cfuture%3E%0A%0Aint+foo()%0A%7B%0A++std::cout+%3C%3C+%22Begin+foo%5Cn%22%3B%0A++std::this_thread::sleep_for(std::chrono::seconds(5))%3B%0A++std::cout+%3C%3C+%22End+foo%5Cn%22%3B%0A++return+10%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::future%3Cint%3E+bar+%3D+async(std::launch::async,+foo)%3B%0A++std::cout+%3C%3C+%22Attente%5Cn%22%3B%0A++std::this_thread::sleep_for(std::chrono::seconds(1))%3B%0A++std::cout+%3C%3C+%22Attente%5Cn%22%3B%0A++std::cout+%3C%3C+bar.get()+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:49.99999999999999,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:49.99999999999999,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    int foo() {
      this_thread::sleep_for(chrono::seconds(5));
      return 10;
    }

    future<int> bar = async(launch::async, foo);
    ...
    cout << bar.get() << "\n";
    ```
  ],
)

== Futures et promise -- ``` std::promise```

- Objet que l'on promet de valoriser ultérieurement
- Déplaçable mais non copiable
- Partage un état avec le ```cpp std::future``` associé
- ```cpp get_future()``` retourne le ```cpp std::future``` associé

#alertblock("Attention", text[
  Un seul ```cpp std::future``` par ```cpp std::promise``` peut être récupéré
])

== Futures et promise -- ``` std::promise```

- ```cpp set_value()``` affecte une valeur et passe l'état partagé à prêt
- ```cpp set_exception()``` affecte une exception et passe l'état partagé à prêt
- ```cpp set_value_at_thread_exit()``` affecte une valeur, l'état partagé passera à prêt à la fin du thread
- ```cpp set_exception_at_thread_exit()``` affecte une exception, l'état partagé passera à prêt à la fin du thread

== Futures et promise -- ``` std::promise```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cthread%3E%0A%23include+%3Cchrono%3E%0A%23include+%3Cfuture%3E%0A%0Avoid+foo(std::future%3Cint%3E%26+fut)%0A%7B%0A++int+x+%3D+fut.get()%3B%0A++std::cout+%3C%3C+x+%3C%3C+!'%5Cn!'%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::promise%3Cint%3E+prom%3B%0A++std::future%3Cint%3E+fut+%3D+prom.get_future()%3B%0A++std::thread+th1(foo,+ref(fut))%3B%0A%0A++std::this_thread::sleep_for(std::chrono::seconds(2))%3B%0A%0A++prom.set_value(10)%3B%0A++th1.join()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:49.99999999999999,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:49.99999999999999,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    void foo(future<int>& fut) {
      int x = fut.get();
      cout << x << '\n';
    }

    promise<int> prom;
    future<int> fut = prom.get_future();
    thread th1(foo, ref(fut));
    ...
    prom.set_value(10);
    th1.join();
    ```
  ],
)

== Futures et promise -- ``` std::packaged_task```

- Encapsulation d'un appelable similaire à ```cpp std::function```
- ... dont la valeur de retour est récupérable par un ```cpp std::future```
- Partage un état avec le ```cpp std::future``` associé
- ```cpp valid()``` teste s'il est associé à un état partagé (contient un appelable)
- ```cpp get_future()``` retourne le ```cpp std::future``` associé

#alertblock("Attention", text[
  Un seul ```cpp std::future``` par ```cpp std::packaged_task``` peut être récupéré
])

== Futures et promise -- ``` std::packaged_task```

- ```cpp operator()``` appelle l'appelable, affecte sa valeur de retour (ou l'exception levée) au ```cpp std::future``` et passe l'état partagé à prêt
- ```cpp reset()``` réinitialise l'état partagé en conservant l'appelable

#noteblock("note", text[
  ```cpp reset()``` permet d'appeler une nouvelle fois l'appelable
])

- ```cpp make_ready_at_thread_exit()``` appelle l'appelable et affecte sa valeur de retour (ou l'exception levée), l'état partagé passera à prêt à la fin

== Futures et promise -- ``` std::packaged_task```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:8,endLineNumber:21,positionColumn:8,positionLineNumber:21,selectionStartColumn:8,selectionStartLineNumber:21,startColumn:8,startLineNumber:21),source:'%23include+%3Ciostream%3E%0A%23include+%3Cthread%3E%0A%23include+%3Cchrono%3E%0A%23include+%3Cfuture%3E%0A%0Avoid+foo(std::future%3Cint%3E%26+fut)%0A%7B%0A++int+x+%3D+fut.get()%3B%0A++std::cout+%3C%3C+x+%3C%3C+!'%5Cn!'%3B%0A%7D%0A%0Aint+bar()%0A%7B%0A++return+10%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::packaged_task%3Cint()%3E+tsk(bar)%3B%0A++std::future%3Cint%3E+fut+%3D+tsk.get_future()%3B%0A++std::thread+th1(foo,+std::ref(fut))%3B%0A%0A++std::this_thread::sleep_for(std::chrono::seconds(2))%3B%0A%0A++tsk()%3B%0A++th1.join()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:49.99999999999999,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:49.99999999999999,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    void foo(future<int>& fut) {
      int x = fut.get();
      cout << x << '\n';
    }

    int bar() { return 10; }

    packaged_task<int()> tsk(bar);
    future<int> fut = tsk.get_future();
    thread th1(foo, std::ref(fut));
    ...
    tsk();
    th1.join();
    ```
  ],
)

== Conclusion

#adviceblock("Do, dans cet ordre", text[
  + Évitez de partager variables et ressources
  + Préférez les partages en lecture seule
  + Préférez les structures de données gérant les accès concurrents
  // std::atomic`, conteneur lock-free, conteneur thread-safe, etc.
  + Protégez l'accès par mutex ou autres barrières
])

#adviceblock("Do", text[
  Encapsulez les mutex dans des ```cpp std::lock_guard``` ou ```cpp std::unique_lock```
])

== Conclusion

#adviceblock("Do", text[
  Analysez vos cas d'utilisation pour choisir le bon outil
])

#alertblock("Attention", text[
  Très faibles garanties de _thread-safety_ de la part des conteneurs standards
  // En gros plusieurs threads peuvent lire un même conteneur et plusieurs threads peuvent lire ou écrire simultanément des conteneurs différents sans problème et c'est à peu prés tout
])

#adviceblock("Do", text[
  ```cpp Boost.Lockfree``` pour des structures de données _thread-safe_ et _lock-free_
])

#noteblock("Pour aller plus loin", text[
  Voir _C++ Concurrency in action_ d'Anthony Williams
  // Anthony Williams est coauteur des propositions de multi-threading dans C++11 et co-auteur de Boost.Thread
])

== Expressions rationnelles (regex)

- ```cpp std::basic_regex``` représente une expression rationnelle
- Instanciations standards ```cpp std::regex``` et ```cpp std::wregex```
- Construite depuis une chaîne représentant l'expression
- ... et des drapeaux de configuration
  - #underline[ECMAScript], basic POSIX, extended POSIX, awk, grep, egrep
  - Case sensitive ou non
  - Prise en compte de la locale
  - ...

```cpp
regex foo("[0-9A-Z]+", icase);
```

#addproposal("n1836")
#addproposal("N1429")

== Expressions rationnelles (regex)

- ```cpp std::regex_search()``` recherche

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:11,positionColumn:1,positionLineNumber:11,selectionStartColumn:1,selectionStartLineNumber:11,startColumn:1,startLineNumber:11),source:'%23include+%3Ciostream%3E%0A%23include+%3Cregex%3E%0A%0Aint+main()%0A%7B%0A++std::regex+r(%22%5B0-9%5D%2B%22)%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::regex_search(std::string(%22123%22),+r)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::regex_search(std::string(%22abcd123efg%22),+r)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::regex_search(std::string(%22abcdefg%22),+r)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:49.99999999999999,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:49.99999999999999,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    regex r("[0-9]+");
    regex_search(string("123"), r);         // true
    regex_search(string("abcd123efg"), r);  // true
    regex_search(string("abcdefg"), r);     // false
    ```
  ],
)

```cpp std::regex_match()``` vérifie la correspondance

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:11,positionColumn:1,positionLineNumber:11,selectionStartColumn:1,selectionStartLineNumber:11,startColumn:1,startLineNumber:11),source:'%23include+%3Ciostream%3E%0A%23include+%3Cregex%3E%0A%0Aint+main()%0A%7B%0A++std::regex+r(%22%5B0-9%5D%2B%22)%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::regex_match(std::string(%22123%22),+r)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::regex_match(std::string(%22abcd123efg%22),+r)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::regex_match(std::string(%22abcdefg%22),+r)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:49.99999999999999,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:49.99999999999999,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    regex r("[0-9]+");
    regex_match(string("123"), r);          // true
    regex_match(string("abcd123efg"), r);   // false
    regex_match(string("abcdefg"), r);      // false
    ```
  ],
)

#addproposal("n1836")
#addproposal("N1429")

== Expressions rationnelles (regex)

- Capture de sous-expressions dans ```cpp std::match_results```
- Instanciations standards ```cpp std::cmatch```, ```cpp std::wcmatch```, ```cpp std::smatch``` et ```cpp std::wsmatch```
- ```cpp empty()``` teste la vacuité de la capture
- ```cpp size()``` retourne le nombre de captures
- Itérateurs sur les captures
- Sur chaque élément capturé
  - ```cpp str()``` : la chaîne capturée
  - ```cpp length()``` : sa longueur
  - ```cpp position()``` : sa position dans la chaîne de recherche
  - ```cpp suffix()``` : la séquence de caractères suivant la capture
  - ```cpp prefix()``` : la séquence de caractères précédant la capture

#addproposal("n1836")
#addproposal("N1429")

== Expressions rationnelles (regex)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cregex%3E%0A%0Aint+main()%0A%7B%0A++std::string+s(%22abcd123efg%22)%3B%0A++std::regex+r(%22%5B0-9%5D%2B%22)%3B%0A++std::smatch+m%3B%0A%0A++std::regex_search(s,+m,+r)%3B%0A++std::cout+%3C%3C+m.size()+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+m.str(0)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+m.position(0)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+m.prefix()+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+m.suffix()+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:49.99999999999999,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:49.99999999999999,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    string s("abcd123efg");
    regex r("[0-9]+");
    smatch m;

    regex_search(s, m, r);
    m.size();       // 1
    m.str(0);       // 123
    m.position(0);  // 4
    m.prefix();     // abcd
    m.suffix();     // efg
    ```
  ],
)

#addproposal("n1836")
#addproposal("N1429")

== Expressions rationnelles (regex)

- Fonction de remplacement : ```cpp std::regex_replace()```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cregex%3E%0A%0Aint+main()%0A%7B%0A++std::string+s(%22abcd123efg%22)%3B%0A++std::regex+r(%22%5B0-9%5D%2B%22)%3B%0A++std::cout+%3C%3C+std::regex_replace(s,+r,+%22-%22)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:49.99999999999999,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:49.99999999999999,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    string s("abcd123efg");
    regex r("[0-9]+");
    regex_replace(s, r, "-"); // abcd-efg
    ```
  ],
)

#addproposal("n1836")
#addproposal("N1429")

== Expressions rationnelles (regex)

#adviceblock("Do", text[
  Préférez les expressions rationnelles aux analyseurs "à la main"
])

#alertblock("Don't", text[
  N'utilisez pas les expressions rationnelles pour les traitements triviaux

  Préférez les algorithmes
])

#noteblock("Conseil", text[
  Encapsulez les expressions rationnelles ayant une sémantique claire et utilisées plusieurs fois dans une fonction dédiée au nom évocateur
])

#noteblock("Performance", text[
  Construction très coûteuse de l'expression rationnelle
])

#addproposal("n1836")
#addproposal("N1429")

== Nombres aléatoires

- Générateurs pseudo-aléatoires initialisés par une graine (congruence linéaire, Mersenne, ...)
- Générateur aléatoire

#alertblock("Attention", text[
  Peut ne pas être présent sur certaines implémentations

  Peut être un générateur pseudo-aléatoire (entropie nulle) sur d'autres
])

- Distributions adaptant la séquence d'un générateur pour respecter une distribution particulière (uniforme, normale, binomiale, de Poisson, ...)
- Fonction de normalisation ramenant la séquence générée dans [0,1)

#addproposal("n1836")

== Nombres aléatoires

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Crandom%3E%0A%23include+%3Cchrono%3E%0A%0Aint+main()%0A%7B%0A++std::default_random_engine+generator%3B%0A++std::uniform_int_distribution%3Cint%3E+distribution(0,9)%3B%0A%0A++generator.seed(std::chrono::system_clock::now().time_since_epoch().count())%3B%0A++std::cout+%3C%3C+distribution(generator)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    	default_random_engine gen;
    	uniform_int_distribution<int> distribution(0,9);
    	gen.seed(system_clock::now().time_since_epoch().count());

    	// Nombre aléatoire entre 0 et 9
    	distribution(gen);
    ```
  ],
)

#adviceblock("Do", text[
  Préférez ces générateurs et distributions à ```cpp rand()```
])

#noteblock("Quiz", text[
  Comment générer un tirage équiprobable entre 6 et 42 avec ```cpp rand()```
])

#addproposal("n1836")
