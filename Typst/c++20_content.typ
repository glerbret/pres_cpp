#import "./model.typ": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/cetz:0.4.2"

= C++20

== Présentation

- Approuvé en décembre 2020
- Dernier Working Draft : #link("https://wg21.link/std20")[ N4860 #linklogo()]

== Changements d'organisation du comité

- Création d'un _Direction Group_
- Création d'un _Study Group_ pour l'éducation (SG20)

#figure(
  image("wg21-structure.png", width: 70%),
)

== Dépréciations et suppressions

- Dépréciation du terme POD et de ```cpp std::is_pod()```
- Dépréciation partielle de ```cpp volatile```
- Dépréciation de l'usage de l'opérateur virgule dans les expressions d'indiçage

// C'est à dire de ne plus pouvoir écrire [x,y] comme indice d'un conteneur classique
// L'expression [x,y] revient à utiliser y comme indice mais en ayant évalué x

- Dépréciation de ```cpp std::rel_ops```
- Suppression des membres dépréciés de ```cpp std::reference_wrapper```
  - ```cpp result_type```
  - ```cpp argument_type```
  - ```cpp first_argument_type```
  - ```cpp second_argument_type```

== Fonctionnalités

- ```cpp __has_cpp_attribute``` teste le support d'un attribut
  - Similaire à ```cpp __has_include``` pour la présence d'entête
  - Extensible aux attributs propriétaires d'une implémentation
- Macros testant le support de fonctionnalité du langage
  - ```cpp __cpp_decltype``` : support de ```cpp decltype```
  - ```cpp __cpp_range_based_for``` : support du _range-based for loop_
  - ```cpp __cpp_static_assert``` : support de ```cpp static_assert```
  - ...

#addproposal("P0941")

== Fonctionnalités

- Macros testant le support de fonctionnalités par la bibliothèque standard
  - ```cpp __cpp_lib_any``` : support de ```cpp std::any```
  - ```cpp __cpp_lib_chrono``` : support de ```cpp std::chrono```
  - ```cpp __cpp_lib_gcd_lcm``` : support des fonctions ```cpp std::gcd()``` et ```cpp std::lcm()```
  - ...

#noteblock("Valorisation", text[
  - Année et mois de l'acceptation dans le standard ou de l'évolution

  // Ainsi en testant la valeur, on peut savoir l'état d'implémentation de la fonctionnalité si celle-ci a évolué
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0A%23if+1%0A%23include+%3Cnumeric%3E%0A%23endif%0A%0Aint+main()%0A%7B%0A%23if+__cpp_lib_gcd_lcm%0A++std::cout+%3C%3C+%22__cpp_lib_gcd_lcm+%22+%3C%3C+__cpp_lib_gcd_lcm+%3C%3C+%22%5Cn%22%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A%23if+__cpp_attributes%0A++std::cout+%3C%3C+%22__cpp_attributes+%22+%3C%3C+__cpp_attributes+%3C%3C+%22%5Cn%22%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A%23if+__has_cpp_attribute(deprecated)%0A++std::cout+%3C%3C+%22__has_cpp_attribute(deprecated)+%22+%3C%3C+__has_cpp_attribute(deprecated)+%3C%3C+%22%5Cn%22%3B%0A%23endif%0A%0A%23if+__has_cpp_attribute(toto)%0A++std::cout+%3C%3C+%22__has_cpp_attribute(toto)+%22+%3C%3C+__has_cpp_attribute(toto)+%3C%3C+%22%5Cn%22%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0941")

== Information à la compilation

- Entête ```cpp <version>``` : informations de version
  - Contenu _implementation-dependent_
  - Version du standard, de la bibliothèque, _release date_, copyright, ...
- ```cpp source_location``` : position dans le code source
  - Fichier, ligne, colonne et fonction courante
  - Contenu _implementation-dependent_

  // En particulier, la numérotation des lignes et colonnes peut commencer à 0 ou à 1
  // Il est toutefois encouragé de numéroter à partir de 1 et de retourner 0 lorsque le numéro n'est pas connu

  - Remplaçant de ```cpp __LINE__```, ```cpp __FILE__```, ```cpp __func__``` et autres macros propriétaires

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring_view%3E%0A%23include+%3Csource_location%3E%0A%0Avoid+log(const+std::string_view%26+message,+const+std::source_location%26+location+%3D+std::source_location::current())%0A%7B%0A++std::cout+%3C%3C+location.file_name()+%3C%3C+%22:%22%0A++++++++++++%3C%3C+location.line()+%3C%3C+%22+%22%0A++++++++++++%3C%3C+location.function_name()+%3C%3C+%22+%22%0A++++++++++++%3C%3C+message+%3C%3C+!'%5Cn!'%3B%0A%7D%0A+%0Aint+main()%0A%7B%0A++log(%22Hello+world!!%22)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0754")
#addproposal("P1208")

== Compilation conditionnelle

- Ajout d'un paramètre booléen, optionnel, à ```cpp explicit```
  - Pilotage de ```cpp explicit``` via un paramètre booléen _compile-time_
  - Possibilité de rendre des constructeurs templates explicites ou non en fonction de l'instanciation
  - Alternative à des constructions à base de macros de compilation ou de SFINAE

#addproposal("P0892")

== Types entiers

- Types entiers signés obligatoirement en compléments à 2

#noteblock("Situation pré-C++20", text[
  Pas de contrainte en C++

  3 choix en C : signe + mantisse, complément à 1 et complément à 2
])

// Le même changement a eu lieu en C2x
// Complément à 1 : négation de tous les bits
// Complément à 2 : négation de tous les bits, puis ajout de 1

#alertblock("Compatibilité", text[
  En pratique, toutes les implémentations actuelles sont en complément à 2
])

- Précision de comportements sur des types entiers signés
  - Conversion vers non signé est toujours bien définie
  // C'est l'unique valeur de la destination congruent à la source modulo 2^N où N est le nombre de bits de la destination
  - Décalage à gauche : même résultat que celui du type non signé correspondant
  - Décalage à droite : décalage arithmétique avec extension du signe

#addproposal("P1236")

== Caractères

- Contraintes de ```cpp char16_t``` et ```cpp char32_t``` : caractères UTF-16 et UTF-32
// Auparavant, ils pouvaient représenter ces caractères, mais ce n'était pas une obligation et pouvaient représenter d'autres codages de caractères larges
// Et les Universal character name doivent correspondre à des code points ISO/IEC 10646
- ```cpp char8_t``` pour les caractères UTF-8
  - Pendant UTF-8 de ```cpp char16_t``` et ```cpp char32_t```
  - Similaire en taille, alignement et conversions à ```cpp unsigned char```
  - Pas un alias sur un autre type
  - Prise en compte dans la bibliothèque standard
- Type ```cpp u8string``` pour les chaînes UTF-8

#noteblock("Motivation", text[
  Suppression de l'ambiguïté caractère UTF-8 / littéral

  Suppression d'ambiguïté sur les surcharges et spécialisation de template
])

#addproposal("P0482")
#addproposal("P1041")

== Définition d'agrégat

- Modification de la définition d'agrégat :
  - C++17 : pas de constructeur _user-provided_
  - C++20 : pas de constructeur _user-declared_
// Ni ==default, ni ==delete
// Y compris dans les classes de base

```cpp
// Agregat en C++17 pas en C++20
struct S {
  S() = default;
};
```

#addproposal("P1008")

== Initialisation des agrégats

- Initialisation nommée des membres d'un agrégat ou d'une union

```cpp
struct S { int a; int b; int c; };
S s{.a = 1, .c = 2};

union U { int a; char* b };
U u{.b = "foo"};
```

#alertblock("Restrictions", text[
  Uniquement sur les agrégats et les unions

  Initialisation des champs dans leur ordre de déclaration

  Initialisation d'un unique membre d'une union

  // Par contre, il est permis de ne pas initialiser des champs d'un agrégat}
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aunion+U%0A%7B%0A++int+a%3B%0A++const+char*+b%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++%7B%0A++++U+u+%3D+%7B+.b+%3D+%22foo%22+%7D%3B%0A++++std::cout+%3C%3C+u.b+%3C%3C+%22%5Cn%22%3B%0A++%7D%0A%0A%23if+0%0A++%7B%0A++++U+u+%3D+%7B+.a+%3D+1,+.b+%3D+%22asdf%22+%7D%3B%0A++%7D%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astruct+S%0A%7B%0A++int+a%3B%0A++int+b%3B%0A++int+c%7B0%7D%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++%7B%0A++++S+s%7B.a+%3D+1,+.b+%3D+2%7D%3B%0A++++std::cout+%3C%3C+s.a+%3C%3C+%22+%22+%3C%3C+s.b+%3C%3C+%22+%22+%3C%3C+s.c+%3C%3C+%22%5Cn%22%3B%0A++%7D%0A%0A++%7B%0A++++S+s%7B.a+%3D+1,+.b+%3D+2,+.c+%3D+3%7D%3B%0A++++std::cout+%3C%3C+s.a+%3C%3C+%22+%22+%3C%3C+s.b+%3C%3C+%22+%22+%3C%3C+s.c+%3C%3C+%22%5Cn%22%3B%0A++%7D%0A%0A%23if+0%0A++%7B%0A++++S+s%7B.b+%3D+2,+.a+%3D+1%7D%3B%0A++%7D%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0329")

== Initialisation des agrégats

- Initialisation des agrégats via des données parenthésées

#noteblock(text[``` {}``` ou ``` ()```], text[
  ```cpp {}``` permet l'utilisation d'_initializer list_

  ```cpp ()``` permet les conversions avec perte de précision
])

#noteblock("Motivations", text[
  Fonctions transférant les arguments à un constructeur sur des agrégats
  // Comme std::make_unique() ou emplace_back()
])

- Initialisation par défaut des champs de bits

```cpp
struct Foo {
  unsigned int a : 1 {0};
  unsigned int b : 1 = 1;
};
```

// Avant C++20, il fallait définir un constructeur

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astruct+Foo%0A%7B%0A++unsigned+int+a+:+1+%7B0%7D%3B%0A++unsigned+int+b+:+1+%3D+1%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++Foo+foo%3B%0A++std::cout+%3C%3C+foo.a+%3C%3C+%22+%22+%3C%3C+foo.b+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0960")

== Endianess

- Énumération ```cpp std::endian```
  - ```cpp little``` : _little-endian_
  - ```cpp big``` : _big-endian_
  - ```cpp native``` : _endianess_ du système

```cpp
if(endian::native == endian::big)
  cout << "big-endian\n";
else if(endian::native == endian::little)
  cout << "little-endian\n";
else
  cout << "mixed-endian\n";
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Cbit%3E%0A%23include+%3Ciostream%3E%0A+%0Aint+main()%0A%7B%0A++if(std::endian::native+%3D%3D+std::endian::big)%0A++++std::cout+%3C%3C+%22big-endian%5Cn%22%3B%0A++else+if(std::endian::native+%3D%3D+std::endian::little)%0A++++std::cout+%3C%3C+%22little-endian%5Cn%22%3B%0A++else%0A++++std::cout+%3C%3C+%22mixed-endian%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0463")

== ``` using enum```

- Utilisation d'```cpp using``` sur une ```cpp enum class```

```cpp
enum class Foo { val1, val2, val3 };
using enum Foo;

if(foo == val2) { ... }
```

- Sur une valeur de l'énumération

```cpp
enum class Foo { val1, val2, val3 };
using Foo::val2;

if(foo == val2) { ... }
```

- Sur une _unscoped_ ```cpp enum```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Cbit%3E%0A%23include+%3Ciostream%3E%0A+%0Aenum+class+Foo%0A%7B%0A++val1,%0A++val2,%0A++val3,%0A%7D%3B%0A%0Ausing+Foo::val2%3B%0A%0Aint+main()%0A%7B%0A++Foo+foo+%3D+Foo::val2%3B%0A%0A++if(foo+%3D%3D+val2)%0A++%7B%0A++++std::cout+%3C%3C+%22val2%5Cn%22%3B%0A++%7D%0A%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Cbit%3E%0A%23include+%3Ciostream%3E%0A+%0Aenum+class+Foo%0A%7B%0A++val1,%0A++val2,%0A++val3,%0A%7D%3B%0A%0Ausing+enum+Foo%3B%0A%0Aint+main()%0A%7B%0A++Foo+foo+%3D+Foo::val2%3B%0A%0A++if(foo+%3D%3D+val2)%0A++%7B%0A++++std::cout+%3C%3C+%22val2%5Cn%22%3B%0A++%7D%0A%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P1099")

== Conversion pointeur-booléen

- Conversion pointeur vers booléen devient _narrowing_
// Et donc interdite dans tous les contextes où les conversion narrowing ne sont pas autorisées
- ```cpp nullptr``` reste autorisé dans les initialisations directes

```cpp
struct Foo {
  int i;
  bool b;
};

void* p;
Foo foo{1, p};       // erreur
bool b1{p};          // erreur
bool b2 = p;         // OK
bool b3{nullptr};    // OK
bool b4 = nullptr;   // erreur
bool b5 = {nullptr}; // erreur
if(p) { ... }        // OK
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Cbit%3E%0A%23include+%3Ciostream%3E%0A%0Astruct+Foo%0A%7B%0A++int+i%3B%0A++bool+b%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++void*+p+%3D+nullptr%3B%0A%0A%23if+0%0A++Foo+foo%7B1,+p%7D%3B%0A%23endif%0A%23if+0%0A++bool+b1%7Bp%7D%3B%0A%23endif%0A++bool+b2+%3D+p%3B%0A++bool+b3%7Bnullptr%7D%3B%0A%23if+0%0A++bool+b4+%3D+nullptr%3B%0A%23endif%0A%23if+0%0A++bool+b5+%3D+%7Bnullptr%7D%3B%0A%23endif%0A++if(p)+%7B+%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic+-Wno-unused-variable',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P1957")

== Spécifications d'exception et ``` =default```

- Définition possible de spécifications d'exception des fonctions ```cpp =default``` différentes de celles de la fonction implicite

```cpp
struct S {
  // Valide en C++20
  // Invalide en C++17 (constructeur implicite noexcept)
  S() noexcept(false) = default;
};
```

#addproposal("P1286")

== Sémantique de déplacement

- Davantage de déplacements possibles

```cpp
unique_ptr<T> f0(unique_ptr<T> && ptr) { return ptr; }

string f1(string && x) { return x; }

struct Foo{};

void f2(Foo w) { throw w; }

struct Bar { B(Foo); };

Bar f3() {
  Foo w;
  return w;
}
```

// Tous ces exemples sont des cas où il y a une copie en C++17 et un déplacement possible en C++20

#addproposal("P1825")

== spaceship operator -- ``` operator<=>```

- Effectue une "_Three-way comparison_"
- Génère les opérateurs d'ordre (```cpp <```, ```cpp <=```, ```cpp >``` et ```cpp >=```)
- Réécrit ```cpp a@b``` en ```cpp a<=>b@0``` ou ```cpp 0@b<=>a```

#adviceblock("Comparaison hétérogène", text[
  Une unique version à écrire (```cpp A<=>B``` ou ```cpp B<=>A```)
])

- Peut être déclaré ```cpp =default``` et généré par
  - ```cpp operator<=>``` des bases et membres
  - ```cpp operator==``` et ```cpp operator<```

#alertblock("Attention", text[
  Uniquement pour des comparaisons homogènes
])

- Utilisation de l'opérateur binaire déclaré s'il existe

#addproposal("P1185")
#addproposal("P1186")
#addproposal("P0768")

== spaceship operator -- ``` operator<=>```

- Trois types de retour possibles
  - ```cpp std::strong_ordering``` : ordre total et égalité
    - ```cpp less```, ```cpp equivalent```/```cpp equal``` et ```cpp greater```
  - ```cpp std::weak_ordering``` : ordre total et équivalence
    - ```cpp less```, ```cpp equivalent``` et ```cpp greater```
  - ```cpp std::partial_ordering``` : ordre partiel
    - ```cpp less```, ```cpp equivalent```, ```cpp greater``` et ```cpp unordered```
- Conversion ```cpp strong_ordering``` $->$ ```cpp weak_ordering``` $->$ ```cpp partial_ordering```
- Comparable uniquement avec ```cpp 0```

#addproposal("P1185")
#addproposal("P1186")
#addproposal("P0768")

== spaceship operator -- ``` operator==```

- Génère l'opérateur ```cpp !=```
- Peut être déclaré ```cpp =default``` et généré par ```cpp operator==``` des bases et membres

#alertblock(text[Génération de ``` operator==```], text[
  Pas de génération depuis ```cpp operator<=>```
  // Initialement, operator== et operator!= aussi résolu via operator<=>. Modifié pour ne pas avoir des tests d'égalité non optimaux "par erreur" via le fallback sur operator<=> (p.ex. court-circuit sur la taille de conteneurs)
])

#adviceblock(text[``` =default``` implicite], text[
  Implicitement ```cpp =default``` lorsque ```cpp operator<=>``` est ```cpp =default```
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ccompare%3E%0A%23include+%3Ciostream%3E%0A%0Astruct+Foo%0A%7B%0A++int+value%3B%0A%0A%23if+1%0A++auto+operator%3C%3D%3E(const+Foo%26+rhs)+const%0A++%7B%0A++++return+value+%3C%3D%3E+rhs.value%3B%0A++%7D%0A%23else%0A++auto+operator%3C%3D%3E(const+Foo%26+rhs)+const+%3D+default%3B%0A%23endif%0A%0A%23if+0%0A++bool+operator%3D%3D(const+Foo%26+rhs)+const+%3D+default%3B%0A%23endif%0A%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++Foo+foo1%7B2011%7D%3B%0A++Foo+foo2%7B2014%7D%3B%0A%0A++std::cout+%3C%3C+std::boolalpha%3B%0A++std::cout+%3C%3C+(foo1+%3C+foo2)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+(foo1+%3E+foo2)+%3C%3C+%22%5Cn%22%3B%0A%23if+0%0A++std::cout+%3C%3C+(foo1+%3D%3D+foo2)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+(foo1+!!%3D+foo2)+%3C%3C+%22%5Cn%22%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P1185")
#addproposal("P1186")
#addproposal("P0768")

== spaceship operator -- Conclusion

#adviceblock("Do", text[
  Privilégiez ```cpp operator<=>``` aux opérateurs ```cpp <```, ```cpp <=```, ```cpp >``` et ```cpp >=```
])

#adviceblock("Do", text[
  Déclarez ```cpp operator<=>``` et ```cpp operator==``` ```cpp =default``` si possible
])

#alertblock("Don't", text[
  Ne mélangez pas ```cpp operator<=>``` et opérateurs d'ordre dans une même classe
])

== Nested namespace

- Extension des _nested namespaces_ aux _inline namespaces_

```cpp
namespace A::inline B::C {
  int i;
}

// Equivalent a

namespace A {
  inline namespace B {
    namespace C {
      int i;
} } }
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Anamespace+A::inline+B::C%0A%7B%0A++int+i+%3D+5%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+A::B::C::i+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+A::C::i+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P1094")

== Modules -- Présentation

// Fusion du TS de mai 2018 et de la proposition concurrente de Clang (ATOM)
- Alternative au mécanisme d'inclusion

#alertblock(text[Modules et ``` namespace```], text[
  Ne replace pas les ```cpp namespace```
])

#list(marker: [ ], text[
  - Réduction des temps de compilation
  - Nouveau niveau d'encapsulation
  - Plus grande robustesse (isolation des effets des macros)
  - Gestion des inclusions multiples sans garde
  - Compatible avec le système actuel d'inclusion
])

#alertblock("Bibliothèque standard", text[
  En C++20, la bibliothèque standard n'utilise pas les modules
])

#addproposal("P1103")

== Modules -- Interface Unit

- L'_Interface Unit_ commence par un préambule
  - Nom du module à exporter
  - Suivi de l'import d'autres modules
  - Éventuellement ré-exportés par le module

```cpp
export module foo;
import a;
export import b;
```

- Suivi du corps exportant des symboles via le mot-clé ```cpp export```
// Les symboles "internal linkage" ne sont bien entendu pas exportables

```cpp
export int i;
export void bar(int j);
export {
  void baz();
  long l; }
```

#addproposal("P1103")

== Modules -- Implementation Unit

- L'_Implementation Unit_ commence par un préambule
  - Nom du module implémenté
  - Suivi de l'import d'autres modules
  - Suivi du corps contenant les détails d'implémentation

```cpp
module foo;
void bar(int j) { return 3 * j; }
```

#noteblock("Note", text[
  _Implementation Unit_ a accès aux déclarations non exportées du module
  // Les déclarations non exportées sont visibles de l'ensemble du module
])

#alertblock("Mais ...", text[
  Pas les autres unités de compilation même si elles importent le module
])

#addproposal("P1103")

== Modules -- Partitions

- Les modules peuvent être partitionnés sur plusieurs unités
- Les partitions fournissent alors un nom de partition

```cpp
// Interface Unit
export module foo:part;
```

```cpp
// Implementation Unit
module foo:part;
```

#alertblock(text[_Primary Module Interface Unit_], text[
  Une et une seule _Interface Unit_ sans nom de partition par module
])

- Un élément peut être déclaré dans une partition et défini dans une autre

#addproposal("P1103")

== Modules -- Partitions

- Les partitions sont un détail d'implémentation non visibles hors du module
// Concrètement, hors du module on importe le module dans son ensemble
- Une partition peut être importée dans une _Implementation Unit_
- ... en important uniquement le nom de la partition

```cpp
module foo;
import :part;     // Importe foo:part
import foo:part;  // Erreur
```

- Le _Primary Module Interface Unit_ peut exporter les partitions

```cpp
export module foo;
export :part1;
export :part2;
```

#addproposal("P1103")

== Modules -- Export de namespace

- Un namespace est exporté s'il est déclaré ```cpp export```
- ... ou implicitement si un de ses éléments est exporté

```cpp
export namespace A {  // A est exporte
  int n;              // A::n est exporte
}

namespace B {
  export int n;       // B::n et B sont exportes
  int m;              // B::m n'est pas exporte
}
```

#addproposal("P1103")

== Modules -- Export de namespace

- Les éléments d'une partie exportée d'un namespace sont exportés

```cpp
namespace C { int n; }         // C::m est exporte

export namespace C { int m; }  // mais pas C::n
```

#addproposal("P1103")

== Modules -- Implémentation inline

- Interface et implémentation dans un unique fichier
- Implémentation dans un fragment ```cpp private```

```cpp
export module m;
struct s;
export using s_ptr = s*;

module :private;
struct s {};
```

#alertblock("Restriction", text[
  Uniquement dans une _Primary Module Interface Unit_

  Qui doit être la seule unité du module
])

#addproposal("P1103")

== Modules -- Utilisation

- Import des modules via la directive ```cpp import```

```cpp
import foo;

// Utilisation des symboles exportes de foo
```

- Cohabitation possible avec des inclusions

```cpp
#include <vector>
import foo;
#include "bar.h"
```

#addproposal("P1103")

== Modules -- Code non-modulaire

- Inclusion d'en-têtes avant le préambule du module
// Seules des directives include peuvent apparaître

```cpp
module;
#include "bar.h"
export module foo;
```

- Ou import des en-têtes

```cpp
export module foo;
import "bar.h";
import <version>;
```

#addproposal("P1103")

== Modules -- Code non-modulaire

- Export possible des symboles inclus

```cpp
module;
#include "bar.h" // Definit X
export module foo;
export using X = ::X;
```

- Ou de l'en-tête dans son ensemble

```cpp
export module foo;
export import "bar.h";
```

#addproposal("P1103")

== Chaînes de caractères

- ```cpp std::basic_string::reserve()``` ne peut plus réduire la capacité
  - Appel avec une capacité inférieure sans effet
  // Auparavant, la norme permettait de réduire effectivement la capacité mais ne l'imposait pas (idem shrink_to_fit())
  // Si la capacité demandée était inférieur à la taille effective, cet appel était équivalent à un appel à shrink_to_fit()
  - Comportement similaire à ```cpp std::vector::reserve()```

#noteblock("Rappel", text[
  Après ```cpp reserve()```, la capacité est supérieure ou égale à la capacité demandée
])

- Dépréciation de ```cpp reserve()``` sans paramètre

#adviceblock("Réduction à la capacité utile", text[
  Utilisez ```cpp shrink_to_fit()``` et non ```cpp reserve()```
])

#addproposal("P0966")

== Chaînes de caractères

- Ajout à ```cpp std::basic_string``` et ```cpp std::string_view```
  - ```cpp starts_with()``` teste si la chaîne commence par une sous-chaîne
  - ```cpp ends_with()``` teste si la chaîne termine par une sous-chaîne

```cpp
string foo = "Hello world";

foo.starts_with("Hello");   // true
foo.ends_with("monde");     // false
```

- ```cpp std::string_view``` constructible depuis une paire d'itérateurs

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Cstring%3E%0A%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++std::string+foo+%3D+%22Hello+world%22%3B%0A%0A++std::cout+%3C%3C+std::boolalpha%3B%0A++std::cout+%3C%3C+foo.starts_with(%22Hello%22)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+foo.ends_with(%22monde%22)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0457")

== Conteneurs associatifs

- ```cpp contains()``` teste la présence d'une clé

```cpp
map<int, string> foo{{1, "foo"}, {42, "bar"}};

foo.contains(42);  // true
foo.contains(38);  // false
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Cmap%3E%0A%23include+%3Cstring%3E%0A%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++std::map%3Cint,+std::string%3E+foo%7B%7B1,+%22foo%22%7D,+%7B42,+%22bar%22%7D%7D%3B%0A%0A++std::cout+%3C%3C+std::boolalpha%3B%0A++std::cout+%3C%3C+foo.contains(42)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+foo.contains(38)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0458")

== Conteneurs associatifs

- Optimisation de la recherche hétérogène dans des conteneurs non-ordonnés
  - Fourniture d'une classe exposant
    - Différents foncteurs de calcul du hash
    - Tag ```cpp transparent_key_equal``` sur une comparaison transparente
  - Suppression de conversions inutiles

#addproposal("P0919")
#addproposal("P1690")

== Conteneurs associatifs

```cpp
struct string_hash {
  using transparent_key_equal = equal_to<>;
  size_t operator()(string_view txt) const {
    return hash_type{}(txt); }
  size_t operator()(const string& txt) const {
    return hash_type{}(txt); }
  size_t operator()(const char* txt) const {
    return hash_type{}(txt); } };

unordered_map<string, int, string_hash> foo = ...;
foo.find("abc");
foo.find("def"sv);
```

#addproposal("P0919")
#addproposal("P1690")

== ``` std::list``` et ``` forward_list```

- ```cpp remove()```, ```cpp remove_if()``` et ```cpp unique()``` retournent le nombre d'éléments supprimés

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Calgorithm%3E%0A%23include+%3Clist%3E%0A%0Aint+main()%0A%7B%0A++std::list%3Cint%3E+foo%7B1,+5,+12,+8,+13%7D%3B%0A%0A++std::cout+%3C%3C+foo.remove_if(%5B%5D+(int+i)+%7B+return+i+%3E+10%3B+%7D)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0646")

== ``` std::array```

- ```cpp std::to_array()``` construit un ```cpp std::array``` depuis un tableau C

```cpp
auto foo = to_array({1, 2, 5, 42});

long foo[] = {1, 2, 5, 42};
auto bar = to_array(foo);

auto foo = to_array<long>({1, 2, 5, 42});
```

- Y compris une chaîne C

```cpp
auto foo = to_array("foo");
```

#alertblock(text[``` \0``` terminal], text[
  Le ``` \0``` terminal est un élément du tableau
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Carray%3E%0A%0Aint+main()%0A%7B%0A++auto+foo+%3D+std::to_array(%22foo%22)%3B%0A++std::cout+%3C%3C+foo.size()+%3C%3C+%22%5Cn%22%3B%0A++for(const+auto+c+:+foo)%0A++%7B%0A++++std::cout+%3C%3C+c+%3C%3C+%22+%22%3B%0A++%7D%0A++std::cout+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Carray%3E%0A%0Aint+main()%0A%7B%0A++%7B%0A++++auto+foo+%3D+std::to_array(%7B1,+2,+5,+42,+58%7D)%3B%0A++++std::cout+%3C%3C+foo.size()+%3C%3C+%22%5Cn%22%3B%0A++++for(const+auto+c+:+foo)%0A++++%7B%0A++++++std::cout+%3C%3C+c+%3C%3C+%22+%22%3B%0A++++%7D%0A++++std::cout+%3C%3C+%22%5Cn%22%3B%0A++%7D%0A%0A++%7B%0A++++long+foo%5B%5D+%3D+%7B1,+2,+5,+42,+33,+12%7D%3B%0A++++auto+bar+%3D+std::to_array(foo)%3B%0A++++std::cout+%3C%3C+bar.size()+%3C%3C+%22%5Cn%22%3B%0A++++for(const+auto+c+:+bar)%0A++++%7B%0A++++++std::cout+%3C%3C+c+%3C%3C+%22+%22%3B%0A++++%7D%0A++++std::cout+%3C%3C+%22%5Cn%22%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'0',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0325")

== Suppression d'éléments

- ```cpp std::erase()``` supprime les éléments égaux à la valeur fournie
- ```cpp std::erase_if()``` supprime les éléments satisfaisant le prédicat fourni

```cpp
vector<int> foo {5, 12, 2, 56, 18, 33};

erase_if(foo, [](int i) { return i > 20; }); // 5 12 2 18
```

- Remplacement de l'idiome "_Erase-remove_"
- Remplacement de la fonction membre ```cpp erase()```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:26,positionColumn:1,positionLineNumber:26,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Cvector%3E%0A%23include+%3Cmap%3E%0A%23include+%3Cstring%3E%0A%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo+%7B5,+12,+2,+56,+18,+33%7D%3B%0A++std::erase_if(foo,+%5B%5D(int+i)+%7Breturn+i+%3E+20%3B%7D)%3B%0A%0A++for(int+i+:+foo)%0A++%7B%0A++++std::cout+%3C%3C+i+%3C%3C+%22+%22%3B%0A++%7D%0A++std::cout+%3C%3C+%22%5Cn%22%3B%0A%0A++std::map%3Cint,+std::string%3E+bar%7B%7B5,+%22a%22%7D,+%7B12,+%22b%22%7D,+%7B2,+%22c%22%7D,+%7B42,+%22d%22%7D%7D%3B%0A++std::erase_if(bar,+%5B%5D(std::pair%3Cint,+std::string%3E+i)+%7Breturn+i.first+%3E+20%3B%7D)%3B%0A%0A++for(auto+i+:+bar)%0A++%7B%0A++++std::cout+%3C%3C+i.first+%3C%3C+%22+:+%22+%3C%3C+i.second+%3C%3C+%22+%22%3B%0A++%7D%0A++std::cout+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P1209")
#addproposal("P1115")

== ``` std::span```

- Vue sur un conteneur contigu
- Similaire à ```cpp std::string_view```
- Constructible depuis
  - Conteneur
  - Couple début / taille
  - Couple début / fin
  - Range
  - Autre ```cpp std::span```

```cpp
array<int, 5> foo = {0, 1, 2, 3, 4};
span<int> s1{foo};
span<int> s2(foo.data(), 3);
```

#addproposal("P0122")
#addproposal("P1024")
#addproposal("P1227")

== ``` std::span```

- ```cpp begin()```, ```cpp end()```, ... : itérateurs sur le ```cpp std::span```
- ```cpp size()```, ```cpp empty()``` : taille et vacuité
- ```cpp operator[]```, ```cpp front()```, ```cpp back()``` : accès à un élément

```cpp
array<int, 5> foo = {0, 1, 2, 3, 4};
span<int> bar{ foo.data(), 4 };

bar.front();  // 0
```

- ```cpp first()```, ```cpp last()``` : construction de sous-span

```cpp
span<int> baz = bar.first(2);  // 0, 1
```

- _structured binding_ sur des ```cpp std::span``` de taille fixe

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Carray%3E%0A%23include+%3Cspan%3E%0A%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++std::array%3Cint,+5%3E+foo+%3D+%7B7,+12,+28,+3,+9%7D%3B%0A++std::span%3Cint%3E+bar(foo.data(),+3)%3B%0A%0A++std::cout+%3C%3C+bar.size()+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+bar.front()+%3C%3C+%22%5Cn%22%3B+%0A++std::cout+%3C%3C+bar%5B2%5D+%3C%3C+%22%5Cn%22%3B+%0A%0A++std::span%3Cint%3E+baz+%3D+bar.first(2)%3B%0A++for(const+auto+i+:+baz)%0A++%7B%0A++++std::cout+%3C%3C+i+%3C%3C+%22+%22%3B%0A++%7D%0A++std::cout+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0122")
#addproposal("P1024")
#addproposal("P1227")

== Décalages d'éléments

- ```cpp std::shift_left()``` décale les éléments vers le début de l'ensemble
- ```cpp std::shift_right()``` décale les éléments vers la fin de l'ensemble
- ... retournent un itérateur vers la fin (resp. début) du nouvel ensemble

#noteblock("Taille et décalage", text[
  Opération sans effet si le décalage est supérieur la taille de l'ensemble
])

```cpp
vector<int> foo{5, 10, 15, 20};
shift_left(foo.begin(), foo.end(), 2);   // 15, 20

vector<int> bar{5, 10, 15, 20};
shift_right(bar.begin(), bar.end(), 1);  // 5, 10, 15
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B5,+10,+15,+20%7D%3B%0A++std::shift_left(foo.begin(),+foo.end(),+2)%3B%0A++//+%7B15,+20,+%3F,+%3F%7D%0A++for(int+i+:+foo)%0A++%7B%0A++++std::cout+%3C%3C+i+%3C%3C+%22+%22%3B%0A++%7D%0A++std::cout+%3C%3C+%22%5Cn%22%3B%0A%0A++std::vector%3Cint%3E+bar%7B5,+10,+15,+20%7D%3B%0A++std::shift_right(bar.begin(),+bar.end(),+1)%3B%0A++//+%7B%3F,+5,+10,+15%7D%0A++for(int+i+:+bar)%0A++%7B%0A++++std::cout+%3C%3C+i+%3C%3C+%22+%22%3B%0A++%7D%0A++std::cout+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0769")

== Manipulation de puissances de deux

- ```cpp std::has_single_bit()``` teste si un entier est une puissance de deux
- ```cpp std::bit_ceil()``` plus petite puissance de deux non strictement inférieure
- ```cpp std::bit_floor()``` plus grande puissance de deux non strictement supérieure
- ```cpp std::bit_width()``` plus petit nombre de bits pour représenter un entier

```cpp
has_single_bit(4u);  // true
has_single_bit(7u);  // false
bit_ceil(7u);        // 8
bit_ceil(8u);        // 8
bit_floor(7u);       // 4
bit_width(7u);       // 3
```

#alertblock("Restriction", text[
  Uniquement sur des entiers non signés
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cbit%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::has_single_bit(4u)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::has_single_bit(7u)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::bit_ceil(7u)++%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::bit_ceil(8u)++%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::bit_floor(7u)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::bit_width(7u)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0556")
#addproposal("P1956")

== Manipulation binaire

- ```cpp std::rotl()``` et ```cpp std::rotr()``` rotations binaires
- ```cpp std::countl_zero``` nombre consécutif de bits à zéro depuis le MSB
- ```cpp std::countl_one``` nombre consécutif de bits à un depuis le MSB
- ```cpp std::countr_zero``` nombre consécutif de bits à zéro depuis le LSB
- ```cpp std::countr_one``` nombre consécutif de bits à un depuis le LSB
- ```cpp std::popcount``` nombre de bit à un

```cpp
rotl(6u, 2);   // 24
rotr(6u, 1);   // 3
popcount(6u);  // 2
```

#alertblock("Restriction", text[
  Uniquement sur des entiers non signés
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cbit%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::rotl(6u,+2)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::rotr(6u,+1)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::popcount(6u)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0553")

== Conversion binaire

- ```cpp std::bit_cast``` ré-interprète une représentation binaire en un autre type
  - Conversion bit-à-bit
  - Alternative plus sûre à ```cpp reinterpret_cast``` ou ```cpp memcpy()```
  - Conversion ```cpp constexpr``` si possible

#alertblock("Restriction", text[
  Uniquement sur des types _trivially copyable_
])

#addproposal("P0476")

== Comparaison d'entiers

- Ajout de fonctions de comparaison d'entier : ```cpp std::cmp_equal()```, ```cpp std::cmp_not_equal()```, ```cpp std::cmp_less()```, ```cpp std::cmp_greated()```, ```cpp std::cmp_less_equal()``` et ```cpp std::cmp_greater_equal()```
- Permettent la comparaison signé / non signé sans promotion

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cutility%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::boolalpha%3B%0A++std::cout+%3C%3C+(-1+%3E+1U)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::cmp_greater(-1,+1U)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0586")

== Mathématiques

- Définition des constantes mathématiques $e$, $log_2 e$, $log_10 e$, $pi$, $1/pi$, $1/sqrt(pi)$, $ln 2$, $ln 10$, $sqrt(2)$, $sqrt(3)$, $1/sqrt(3)$, $gamma$, $phi$
// gamma est la constante de Euler-Mascheroni et varphi le nombre d'or}
- ```cpp std::midpoint()``` : demi-somme de deux valeurs (entières ou flottantes)

#noteblock("Règle d'arrondi", text[
  La demi-somme d'entiers est entière et arrondie vers le premier paramètre

  ```cpp
  midpoint(2, 4);  // 3
  midpoint(2, 5);  // 3
  midpoint(5, 2);  // 4
  ```
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cnumeric%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::midpoint(2,+4)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::midpoint(2,+5)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::midpoint(5,+2)+%3C%3C+%22%5Cn%22%3B+%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0631")
#addproposal("P0811")

== Mathématiques

- ```cpp std::lerp()``` : interpolation linéaire entre deux valeurs flottantes

```cpp
lerp(10, 20, 0);    // 10
lerp(10, 20, 0.1);  // 11
lerp(10, 20, 0.2);  // 12
lerp(10, 20, 0.3);  // 13
lerp(10, 20, 0.4);  // 14
lerp(10, 20, 0.5);  // 15
lerp(10, 20, 0.6);  // 16
lerp(10, 20, 0.7);  // 17
lerp(10, 20, 0.8);  // 18
lerp(10, 20, 0.9);  // 19
lerp(10, 20, 1);    // 20
```

#codesample(
  "https://godbolt.org/#z:OYLghAFBqd5QCxAYwPYBMCmBRdBLAF1QCcAaPECAMzwBtMA7AQwFtMQByARg9KtQYEAysib0QXACx8BBAKoBnTAAUAHpwAMvAFYTStJg1DIApACYAQuYukl9ZATwDKjdAGFUtAK4sGe1wAyeAyYAHI%2BAEaYxHoADqgKhE4MHt6%2BcQlJAkEh4SxRMVy2mPaOAkIETMQEqT5%2BRXaYDskVVQQ5YZHRegqV1bXpDX3twZ353VwAlLaoXsTI7BzmAMzByN5YANQmy25OvcSYrDvYJhoAgitrG5jbu8gsTAQIJ2eXF8EEm4/BEJNvJgA7FYLptNr10CAULMvjs3HDwQRISB6MRYhAuBpSJszFjNhpJnd4bttmYzCYAKxuBjmcnLEHnMEQqFoLyw3YI5ko6LozHY3HYjQAOimRIRtMp1Il9LeTKRLJhYpJXNRvLxAvxQrMhLh4rJkpp%2BploMRyNZ7OJblNUNVGPVeOFyx1HJJEqphrpDLlZsVuuV8u5aLt/IdQskzstpPJ7ulXut0LZSqtKp5wZxoYpEb10alRrjXPNSfjtr56cFQoAbFnXfqY3nZfHC37kwGS/by4Dq1a3bnPQ2C76XS3kW2Q%2BWABxdqMG2P9gNNofF1OljXCgCcU57Hp2%2Bfng8jKaDK7xoub07rfYuQIAIm8ONNaJwKbw/BwtKRUJx4ZZrODZvNbhWHhSAITR72mABrEAKSxR8OEkF8wI/TheAUEAsVAt971IOBYCQTBVCaNkSHISgqmABRlEMEohAQVAAHdX2AtAWFiOgnmSKiQloWiGNfd8WLY1EQAo5hYgUOiCFIQS6GiUJWEWXgZNRAB5NleMYpCCKac5iAolDSG05AKnwV9eH4QQRDEdgpBkQRFBUdQsNIXQigMIwUGsax9DwCI0MgaZUFiMoGDQjgAFoIR2a9TB/SxcU2cKAHUxFoRKkoIghiCYRLYkwdBDEcZBeFQAA3aJiDwLB/L%2BUhiC8QQ8DYAAVVBPBq6YFH/BYeiRYIuJoujNO4XgsswRZgPo7LYjAh8n0Q5zPw4bBCOQYjiE2VRxwrcKK0kTZgGQZBNggLKGogwkIG/KxLGxXBCBIUllimUbZumBAjiwGJaqgmD9E4BDSH4kqDLQjC3v%2BjgzAW98lterDJmmcriESZxJCAA%3D",
)

#addproposal("P0811")

== Évolutions de la bibliothèque standard

- Utilisation de l'attribut ```cpp [[ nodiscard ]]```
- Davantage de ```cpp noexcept```
- Optimisation d'algorithmes numériques via ```cpp std::move()```

== Ranges -- Présentation

- Abstraction de plus haut niveau que les itérateurs
- Manipulation d'ensemble au travers d'algorithmes et de _range adaptators_
- Vivent dans le ```cpp namespace std::ranges```
// Pour être précis, les range adaptors manipulent seulement les viewable ranges

#noteblock("Pour aller plus loin", text[
  #link(
    "https://accu.org/content/conf2009/AndreiAlexandrescu_iterators-must-go.pdf",
  )[Iterators Must Go #linklogo() (Andrei Alexandrescu)]

  #link("http://ericniebler.com/")[Blog d'Eric Niebler #linklogo()]
])

#addproposal("P0896")
#addproposal("P1035")

== Ranges -- Concepts

- ```cpp Range``` : séquence d'éléments définie par
  - Itérateur de début
  - Sentinelle de fin
    - Itérateur
    - Valeur particulière
    - ```cpp std::default_sentinel_t``` : itérateurs gérant la limite du range
// std::default_sentinel_t utilisable avec std::counted_iterator
// Appelé counted range, range représenté par un itérateur de début et un nombre d'éléments
- Conteneur : range possédant ses éléments
- ```cpp View```
  - Range ne possédant pas les éléments
  - Copie, déplacement et affectation en temps constant
- ```cpp SizedRange``` : taille en temps constant
- ```cpp ViewableRange``` : range convertible en une vue
- ```cpp CommonRange``` : itérateur et sentinelle de même type

#addproposal("P0896")
#addproposal("P1035")

== Ranges -- Concepts

- ```cpp InputRange``` : fournit des ```cpp input_iterator```
- ```cpp OutputRange``` : fournit des ```cpp output_iterator```
- ```cpp ForwardRange``` : fournit ```cpp forward_iterator```
- ```cpp BidirectionalRange``` : fournit ```cpp bidirectional_iterator```
- ```cpp RandomAccessRange``` : fournit ```cpp random_access_iterator```
- ```cpp ContiguousRange``` : fournit ```cpp contiguous_iterator```

#noteblock("En résumé", text[
  Conteneurs : possession, copie profonde

  Vues : référence, copie superficielle
])

#addproposal("P0896")
#addproposal("P1035")

== Ranges -- Itérateurs

- ```cpp std::common_iterator``` : adaptateur d'itérateurs/sentinelles permettant de représenter un _non-common_ ```cpp range``` comme un ```cpp CommonRange```
// Passe de itérateur/sentinelle de types différents à itérateur/sentinelle de même type
// Grâce à l'opérateur de comparaison adéquate
- ```cpp std::counted_iterator``` : adaptateur d'itérateurs reprenant le fonctionnement de l'itérateur sous-jacent mais conservant la distance à la fin du ```cpp range```

#addproposal("P0896")
#addproposal("P1035")

== Ranges -- Opérations

- ```cpp begin()```, ```cpp end()```, ```cpp cbegin()```, ```cpp cend()```, ... retournent itérateurs et sentinelles
- ```cpp size()``` retourne la taille du ```cpp range```
- ```cpp empty()``` teste la vacuité
- ```cpp data()``` et ```cpp cdata()``` retournent l'adresse de début du ```cpp range```

#alertblock("Restrictions", text[
  ```cpp data()``` et ```cpp cdata()``` uniquement sur des ```cpp ContiguousRange```
])

- Surcharges de différents algorithmes prenant un ```cpp range``` en paramètre

#addproposal("P0896")
#addproposal("P1035")

== Ranges -- Factory

- ```cpp std::views::empty``` crée une vue vide
- ```cpp std::views::single``` crée une vue sur un unique élément
- ```cpp std::views::iota``` crée une vue en incrémentant une valeur initiale

```cpp
for(int i : iota(1, 10))
  cout << i << ' ';   // 1 2 3 4 5 6 7 8 9
```

- ```cpp std::views::counted``` crée un vue depuis un itérateur et un nombre d'éléments

```cpp
int a[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
counted(a, 3);   // 1 2 3
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Cranges%3E%0A%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++int+a%5B%5D+%3D+%7B1,+2,+3,+4,+5,+6,+7,+8,+9,+10%7D%3B%0A++for(int+i+:+std::views::counted(a,+3))%0A++%7B%0A++++std::cout+%3C%3C+i+%3C%3C+!'+!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Cranges%3E%0A%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++for(int+i+:+std::views::iota(1,+10))%0A++%7B%0A++++std::cout+%3C%3C+i+%3C%3C+!'+!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0896")
#addproposal("P1035")

== Ranges -- Factory

- ```cpp std::ranges::istream_view``` créé une vue sur un un flux d'entrée
- ```cpp std::ranges::subrange()``` construit un sous-range depuis
  - Une paire d'itérateur
  - Un itérateur de début et une sentinelle de fin

```cpp
vector<int> vec{1, 2, 3, 4, 5, 6, 7, 8, 9};
subrange(begin(vec), begin(vec) + 3);   // 1 2 3
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:73,endLineNumber:8,positionColumn:73,positionLineNumber:8,selectionStartColumn:3,selectionStartLineNumber:7,startColumn:3,startLineNumber:7),source:'%23include+%3Cranges%3E%0A%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+vec%7B1,+2,+3,+4,+5,+6,+7,+8,+9%7D%3B%0A++auto+rg+%3D+std::ranges::subrange(std::begin(vec),+std::begin(vec)+%2B+3)%3B%0A++for(int+i+:+rg)%0A++%7B%0A++++std::cout+%3C%3C+i+%3C%3C+!'+!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0896")
#addproposal("P1035")

== Ranges -- Range adaptators

- Appliquent filtres et transformations aux ranges
- Évaluation paresseuse des ```cpp view```
- Peuvent être chaînés avec une syntaxe "appel de fonction"

```cpp
D(C(R));
```

- Ou une syntaxe "pipeline"

```cpp
R | C | D;
```

#addproposal("P0896")
#addproposal("P1035")

== Ranges -- Range adaptators

- ```cpp std::views::all``` : tous les éléments du ```cpp range```
- ```cpp std::views::ref``` : références sur les éléments du ```cpp range```
- ```cpp std::views::filter``` : tous les éléments satisfaisants un prédicat

```cpp
vector<int> ints{0, 1, 2, 3, 4, 5};
auto even = [](int i){ return (i % 2) == 0; };

ints | filter(even);       // 0, 2, 4
```

- ```cpp std::views::transform``` applique d'une fonction aux éléments

```cpp
vector<int> ints{0, 1, 2, 3, 4, 5};
auto foo = [](int i){ return 2 * i; };

ints | transform(foo);  // 0, 2, 4, 6, 8, 10
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cranges%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+ints%7B0,+1,+2,+3,+4,+5%7D%3B%0A++auto+foo+%3D+%5B%5D(int+i)%7B+return+2+*+i%3B+%7D%3B%0A%0A++for(int+i+:+ints+%7C+std::views::transform(foo))%0A++%7B%0A++++std::cout+%3C%3C+i+%3C%3C+!'+!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cranges%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+ints%7B0,+1,+2,+3,+4,+5%7D%3B%0A++auto+even+%3D+%5B%5D(int+i)%7B+return+(i+%25+2)+%3D%3D+0%3B+%7D%3B%0A%0A++for(int+i+:+ints+%7C+std::views::filter(even))%0A++%7B%0A++++std::cout+%3C%3C+i+%3C%3C+!'+!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0896")
#addproposal("P1035")

== Ranges -- Range adaptators

- ```cpp std::views::take``` : les $N$ premiers éléments

```cpp
iota(1, 10) | take(foo);  // 1, 2, 3
```

- ```cpp std::views::take_while``` : les éléments jusqu'au premier ne satisfaisant pas un prédicat

```cpp
iota(1, 10) | take_while([] (int i) { return i != 5; }))
// 1, 2, 3, 4
```

- ```cpp std::views::drop``` : tous les éléments sauf les $N$ premiers

```cpp
iota(1, 10) | drop(3)) // 4, 5, 6, 7, 8, 9
```

- ```cpp std::views::drop_while``` : tous les éléments depuis le premier ne satisfaisant pas un prédicat

```cpp
iota(1, 10) | drop_while([] (int i) { return i != 5; }))
// 5, 6, 7, 8, 9
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:93,endLineNumber:6,positionColumn:93,positionLineNumber:6,selectionStartColumn:64,selectionStartLineNumber:6,startColumn:64,startLineNumber:6),source:'%23include+%3Cranges%3E%0A%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++for(int+i+:+std::views::iota(1,+10)+%7C+std::views::drop_while(%5B%5D+(int+i)+%7B+return+i+!!%3D+5%3B+%7D))%0A++%7B%0A++++std::cout+%3C%3C+i+%3C%3C+!'+!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:57,endLineNumber:6,positionColumn:57,positionLineNumber:6,selectionStartColumn:57,selectionStartLineNumber:6,startColumn:57,startLineNumber:6),source:'%23include+%3Cranges%3E%0A%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++for(int+i+:+std::views::iota(1,+10)+%7C+std::views::drop(3))%0A++%7B%0A++++std::cout+%3C%3C+i+%3C%3C+!'+!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:95,endLineNumber:6,positionColumn:95,positionLineNumber:6,selectionStartColumn:41,selectionStartLineNumber:6,startColumn:41,startLineNumber:6),source:'%23include+%3Cranges%3E%0A%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++for(int+i+:+std::views::iota(1,+10)+%7C+std::views::take_while(%5B%5D+(int+i)+%7B+return+i+!!%3D+5%3B+%7D))%0A++%7B%0A++++std::cout+%3C%3C+i+%3C%3C+!'+!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:38,endLineNumber:6,positionColumn:20,positionLineNumber:6,selectionStartColumn:38,selectionStartLineNumber:6,startColumn:20,startLineNumber:6),source:'%23include+%3Cranges%3E%0A%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++for(int+i+:+std::views::iota(1,+10)+%7C+std::views::take(3))%0A++%7B%0A++++std::cout+%3C%3C+i+%3C%3C+!'+!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0896")
#addproposal("P1035")

== Ranges -- Range adaptators

- ```cpp std::views::common``` convertit une vue en ```cpp common_range```
- ```cpp std::views::reverse``` : éléments en sens inverse

```cpp
iota(1, 10) | reverse) // 9, 8, 7, 6, 5, 4, 3, 2, 1
```

- ```cpp std::views::join``` joint les éléments d'un range

```cpp
vector<string> foo{"hello", " ", "world", "!"};
foo | join);  // hello world!
```

- ```cpp std::views::split``` et ```cpp std::views::lazy_split``` découpent un range

```cpp
string foo{"the quick brown fox"};
foo | splitbar(' '); // the, quick, brown, fox
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:9,positionColumn:1,positionLineNumber:9,selectionStartColumn:1,selectionStartLineNumber:9,startColumn:1,startLineNumber:9),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cstring%3E%0A%23include+%3Cranges%3E%0A%0Aint+main()%0A%7B%0A++std::string+foo%7B%22the+quick+brown+fox%22%7D%3B%0A++for(auto+baz+:+foo+%7C+std::views::split(!'+!'))%0A++%7B%0A++++for(char+c+:+baz)%0A++++%7B%0A++++++std::cout+%3C%3C+c%3B%0A++++%7D%0A++++std::cout+%3C%3C+%22%5Cn%22%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:10,positionColumn:1,positionLineNumber:10,selectionStartColumn:1,selectionStartLineNumber:8,startColumn:1,startLineNumber:8),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cstring%3E%0A%23include+%3Cranges%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cstd::string%3E+foo%7B%22hello%22,+%22+%22,+%22world%22,+%22!!%22%7D%3B%0A++for(char+c+:+foo+%7C+std::views::join)%0A++%7B%0A++++std::cout+%3C%3C+c%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:61,endLineNumber:6,positionColumn:61,positionLineNumber:6,selectionStartColumn:61,selectionStartLineNumber:6,startColumn:61,startLineNumber:6),source:'%23include+%3Cranges%3E%0A%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++for(int+i+:+std::views::iota(1,+10)+%7C+std::views::reverse)%0A++%7B%0A++++std::cout+%3C%3C+i+%3C%3C+!'+!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0896")
#addproposal("P1035")

== Ranges -- Range adaptators}

- ```cpp std::views::elements``` : /* $N\textsuperscript{e}$*/ éléments d'un range de _tuple-likes_

```cpp
map<std::string, int> foo {
  {"Lovelace"s, 1815}, {"Turing"s,   1912},
  {"Babbage"s,  1791}, {"Hamilton"s, 1936}};

foo | elements<1>;  // 1791 1936 1815 1912
```
- ```cpp std::views::keys``` : clés d'un range de ```cpp std::pair```

```cpp
foo | keys; // Babbage Hamilton Lovelace Turing
```

- ```cpp std::views::values``` : valeurs d'un range de ```cpp std::pair```

```cpp
foo | values; // 1791 1936 1815 1912
```

- Surcharges des algorithmes opérants sur les ranges

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:5,endLineNumber:16,positionColumn:5,positionLineNumber:16,selectionStartColumn:5,selectionStartLineNumber:16,startColumn:5,startLineNumber:16),source:'%23include+%3Ciostream%3E%0A%23include+%3Cmap%3E%0A%23include+%3Cstring%3E%0A%23include+%3Cranges%3E%0A%0Ausing+namespace+std::literals%3B%0A%0Aint+main()%0A%7B%0A++std::map%3Cstd::string,+int%3E+foo+%3D+%0A++%7B%0A++++%7B%22Lovelace%22s,+1815%7D,%0A++++%7B%22Turing%22s,+++1912%7D,%0A++++%7B%22Babbage%22s,++1791%7D,%0A++++%7B%22Hamilton%22s,+1936%7D,%0A++%7D%3B%0A%0A++for(auto+i+:+foo+%7C+std::views::values)%0A++%7B%0A++++std::cout+%3C%3C+i+%3C%3C+%22+%22%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:38,endLineNumber:18,positionColumn:38,positionLineNumber:18,selectionStartColumn:38,selectionStartLineNumber:18,startColumn:38,startLineNumber:18),source:'%23include+%3Ciostream%3E%0A%23include+%3Cmap%3E%0A%23include+%3Cstring%3E%0A%23include+%3Cranges%3E%0A%0Ausing+namespace+std::literals%3B%0A%0Aint+main()%0A%7B%0A++std::map%3Cstd::string,+int%3E+foo+%3D+%0A++%7B%0A++++%7B%22Lovelace%22s,+1815%7D,%0A++++%7B%22Turing%22s,+++1912%7D,%0A++++%7B%22Babbage%22s,++1791%7D,%0A++++%7B%22Hamilton%22s,+1936%7D,%0A++%7D%3B%0A%0A++for(auto+i+:+foo+%7C+std::views::keys)%0A++%7B%0A++++std::cout+%3C%3C+i+%3C%3C+%22+%22%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cmap%3E%0A%23include+%3Cstring%3E%0A%23include+%3Cranges%3E%0A%0Ausing+namespace+std::literals%3B%0A%0Aint+main()%0A%7B%0A++std::map%3Cstd::string,+int%3E+foo+%3D+%0A++%7B%0A++++%7B%22Lovelace%22s,+1815%7D,%0A++++%7B%22Turing%22s,+++1912%7D,%0A++++%7B%22Babbage%22s,++1791%7D,%0A++++%7B%22Hamilton%22s,+1936%7D,%0A++%7D%3B%0A%0A++for(auto+i+:+foo+%7C+std::views::elements%3C1%3E)%0A++%7B%0A++++std::cout+%3C%3C+i+%3C%3C+%22+%22%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0896")
#addproposal("P1035")

== Gestion des flux

- Flux synchrones
  - Classe tampon synchrone : ```cpp std::basic_syncbuf```
  - Classe flux bufferisé synchrone : ```cpp std::basic_osyncstream```
  - ```cpp emit()``` transfère le tampon vers le flux de sortie

```cpp
{ osyncstream s(cout);
  s << "Hello," << '\n'; // no flush
  s.emit(); // characters transferred, cout not flushed
  s << "World!" << endl; // flush noted, cout not flushed
  s.emit(); // characters transferred, cout flushed
  s << "Greetings." << '\n'; // no flush
} // characters transferred, cout not flushed
```

- Limitation de la taille lue dans les flux avec ```cpp std::setw()```

```cpp
cin >> setw(24) >> a; // Seuls 24 caracteres sont lus
```

#addproposal("P0053")

== ``` std::format``` -- Présentation

- API de formatage inspiré de la bibliothèque #link("https://github.com/fmtlib/fmt")[``` {fmt}```]

#noteblock("Motivations", text[
  Formatage "à la C" non extensible et peu sûr

  Flux complexes, peu performants, peu propices à l'internationalisation et la localisation, formateurs globaux
  // Peu propices à la localisation car le format et l'ordre des éléments est dans le code lui-même et ne peut pas être sortie facilement
  // Les formateurs sont globaux, ainsi l'injection de std::hex dans un flux va passer tous les affichages des entiers en hexadécimal jusqu'à un changement explicite et pas uniquement celui concerné
])

- Formatage _locale-specific_ ou _locale-independent_
// Par défaut, la locale n'est pas prise en compte, mais peut l'être si souhaité
- Format sous forme de chaînes utilisant ```cpp {}``` comme _placeholder_

#noteblock("Alternatives à C++20", text[
  Utilisez ```cpp {fmt}``` ou ```cpp Boost.Format```
])

#addproposal("P0645")

== ``` std::format``` -- API

- ```cpp format()``` retourne une chaîne

```cpp
format("{}", "a");  // "a"
```

- ```cpp format_to()``` formate dans un ```cpp output_iterator```

```cpp
vector<char> foo;

format_to(back_inserter(foo), "{}", "a");
```

// output_iterator est retourné par format_to()

- ```cpp format_to_n()``` formate dans un ```cpp output_iterator``` avec une taille limite

```cpp
array<char, 4> foo;

format_to_n(foo.data(), foo.size(), "{}", "a");
```

// Troncature à la taille indiquée si nécessaire

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Carray%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::array%3Cchar,+4%3E+foo%3B%0A%0A++std::format_to_n(foo.data(),+foo.size(),+%22%7B%7D%22,+%22a%22)%3B%0A++for(auto+c:+foo)%0A++%7B%0A++++std::cout+%3C%3C+c+%3C%3C+%22+%22%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cchar%3E+foo%3B%0A%0A++std::format_to(std::back_inserter(foo),+%22%7B%7D%22,+%22a%22)%3B%0A++for(auto+c:+foo)%0A++%7B%0A++++std::cout+%3C%3C+c+%3C%3C+%22+%22%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7B%7D%22,+%22a%22)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0645")

== ``` std::format``` -- API

- ```cpp formatted_size()``` retourne la taille nécessaire au formatage

```cpp
formatted_size("{}", "a");  // 1
```

- ```cpp vformat()``` et ```cpp vformat_to()``` arguments regroupés dans un _tuple-like_

```cpp
vformat("{}", make_format_args("a"));
```

- Variantes ```cpp wchar``` et ```cpp locale```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::vformat(%22%7B%7D%22,+std::make_format_args(%22a%22))+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::formatted_size(%22%7B%7D%22,+%22a%22)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0645")

== ``` std::format``` -- Placeholder

- Format général : ```cpp {[arg-id][:format-spec]}```
  - ```cpp arg-id``` : index, optionnel, de l'argument de la liste de paramètres
  - ```cpp format-spec``` : spécifications, optionnelles, du format

#noteblock("Séquences d'échappement", text[
  ```cpp {{``` affiche ```cpp {```

  ```cpp }}``` affiche ```cpp }```
])

#addproposal("P0645")

== ``` std::format``` -- Identifiant d'arguments

- Valeur optionnelle indiquant l'index du paramètre à afficher
- Débute à ```cpp 0```

```cpp
format("{1} et {0}", "a", "b"); // "b et a"
format("{0} et {0}", "a");      // "a et a"
```

- En cas d'absence, les paramètres sont pris dans l'ordre d'apparition

```cpp
format("{} et {}", "a", "b");   // "a et b"
```

#alertblock("Limite", text[
  Impossible d'en n'omettre que certains
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7B%7D+et+%7B%7D%22,+%22a%22,+%22b%22)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7B1%7D+et+%7B0%7D%5Cn%22,+%22a%22,+%22b%22)%3B%0A++std::cout+%3C%3C+std::format(%22%7B0%7D+et+%7B0%7D%5Cn%22,+%22a%22)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0645")

== ``` std::format``` -- Spécification de format

- Format général : ``` [[fill]align][sign][#][0][width][prec][L][type]```
  - ```cpp fill``` et ```cpp align``` : gestion de l'alignement
  - ```cpp sign``` : gestion du signe
  - ```cpp #``` : forme alternative
  - ```cpp 0``` : gestion des zéros non significatifs
  - ```cpp width``` : taille minimal du champ
  - ```cpp prec``` : précision du champ
  - ```cpp L``` : prise en compte de la locale
  - ```cpp type``` : type à afficher

#addproposal("P0645")

== ``` std::format``` -- Alignement

- Alignement par défaut dépendant du type

```cpp
format("{:6}", 42);     // "    42"
format("{:6}", 'x');    // "x     "
```

- Fourniture du caractère de _padding_

```cpp
format("{:06}", 42);    // "000042"
```

- Choix de l'alignement

```cpp
format("{:*<6}", 'x');  // "x*****"
format("{:*>6}", 'x');  // "*****x"
format("{:*^6}", 'x');  // "**x***"
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7B:*%3C6%7D%22,+!'x!')+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B:*%3E6%7D%22,+!'x!')+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B:*%5E6%7D%22,+!'x!')+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7B:06%7D%22,+42)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7B:6%7D%22,+42)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B:6%7D%22,+!'x!')+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0645")

== ``` std::format``` -- Taille minimale

- Fournit la taille minimal du champ
- Si le champ est plus long, il n'est pas tronqué

```cpp
// "|  10| |          10|"
format("|{0:4}| |{0:12}|", 10);
// "|10000000| |    10000000|"
format("|{0:4}| |{0:12}|", 1000000);
```

- Possible de fournir la taille en paramètre via un _placeholder_

```cpp
// "|  10| |          10|"
format("|{0:{1}}| |{0:{2}}|", 10, 4, 12);
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7C%7B0:%7B1%7D%7D%7C+%7C%7B0:%7B2%7D%7D%7C%22,+10,+4,+12)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7C%7B0:4%7D%7C+%7C%7B0:12%7D%7C%22,+10)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7C%7B0:4%7D%7C+%7C%7B0:12%7D%7C%22,+1000000)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0645")

== ``` std::format``` -- Précision

- Introduit par un ```cpp .```
- Sur les nombres flottants

```cpp
format("{:.6f}", 392.65);       // "392.650000"
```

- Et les chaînes de caractères : troncature

```cpp
format("{:.6}", "azertyuiop");  // "azerty"
```

- Possible de fournir la taille en paramètre via un _placeholder_

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7B:.6%7D%22,+%22azertyuiop%22)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7B:.6f%7D%22,+392.65)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0645")

== ``` std::format``` -- Signe

- Affiche le signe uniquement sur les négatifs : '```cpp -```'
- Affiche le signe sur toutes les valeurs : '```cpp +```'
- Réserve l'espace et affiche le signe sur les négatifs : ' '

```cpp
		format("{0:},{0:+},{0:-},{0: }", 1);   // "1,+1,1, 1"
		format("{0:},{0:+},{0:-},{0: }", -1);  // "-1,-1,-1,-1"
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7B0:%7D,%7B0:%2B%7D,%7B0:-%7D,%7B0:+%7D%22,+1)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B0:%7D,%7B0:%2B%7D,%7B0:-%7D,%7B0:+%7D%22,+-1)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0645")

== ``` std::format``` -- Zéros non significatifs

- Affichage des zéros non significatifs

```cpp
format("{:+06d}", 120);  // "+00120"
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7B:%2B06d%7D%22,+120)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0645")

== ``` std::format``` -- Format

- Entiers : décimal, octal, binaire ou hexadécimal

```cpp
format("{:d}", 42);           // "42"
format("{:x} {:X}", 42, 42);  // "2a 2A"
format("{:b}", 42);           // "101010"
format("{:o}", 42);           // "52"
```

- Caractères : valeur numérique ou caractère

```cpp
format("{:X}", 'A');          // "41"
format("{:c}", 'A');          // "A"
```

- Booléens : chaîne ou nombre

```cpp
format("{:d}", true);         // "1"
format("{:s}", true);         // "true"
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7B:d%7D%22,+true)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B:s%7D%22,+true)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7B:X%7D%22,+!'A!')+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B:c%7D%22,+!'A!')+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7B:d%7D%22,+42)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B:x%7D+%7B:X%7D%22,+42,+42)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B:b%7D%22,+42)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B:o%7D%22,+42)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0645")

== ``` std::format``` -- Format

- Flottants : fixe, court, scientifique ou hexadécimal

```cpp
format("{:.6f}", 392.65);   // "392.650000"
format("{:.6g}", 392.65);   // "392.65"
format("{:.6e}", 392.65);   // "3.9265e+02"
format("{:.6E}", 392.65);   // "3.9265E+02"
format("{:.6a}", 42.);      // "1.500000p+5"
```

// Format court : fixe sur les petites nombres, scientifique sur les grands
// Par défaut court : .6g

- Chaîne de caractère

```cpp
format("{:s}", "azerty");   // "azerty"
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7B:s%7D%22,+%22azerty%22)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7B:.6f%7D%22,+392.65)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B:.6g%7D%22,+392.65)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B:.6e%7D%22,+392.65)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B:.6E%7D%22,+392.65)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B:.6a%7D%22,+42.)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0645")

== ``` std::format``` -- Forme alternative

- Affichage de la base des entiers

```cpp
format("{:#x}", 42);        // "0x2a"
format("{:#X}", 42);        // "0X2A"
```

- Affichage du point décimal et de l'ensemble de la précision des flottants

```cpp
format("{:.6g}", 392.65);   // "392.65"
format("{:#.6g}", 392.65);  // "392.650"
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7B:.6g%7D%22,+392.65)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B:%23.6g%7D%22,+392.65)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7B:%23x%7D%22,+42)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B:%23X%7D%22,+42)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0645")

== ``` std::format``` -- Dates et heures

- Format basé sur ```cpp strftime```
  - ```cpp %y``` : année sur deux digits
  - ```cpp %m``` : mois
  - ```cpp %d``` : jour dans le mois
  - ```cpp %u```, ```cpp %w``` : jour dans la semaine
  // 1 à 7 avec 1 lundi pour u, 0 à 6 avec 0 pour dimanche pour w}
  - ```cpp %H```, ```cpp %I``` : heure (format 24h ou 12h)
  - ```cpp %M``` : minutes
  - ```cpp %S``` : secondes
  - ```cpp %Z``` : timezone
  - ...

```cpp
format("{:%F %T}", chrono::system_clock::now());
// AAAA-MM-JJ HH:mm:ss
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cchrono%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7B:%25F+%25T%7D%22,+std::chrono::system_clock::now())%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0645")

== ``` std::format``` -- Gestion des erreurs

- Exception ```cpp std::format_error```
  - Chaîne de format invalide
  - Spécificateurs non cohérents avec le type fournit
  - Absence de valeur
  - Exception levée par un formateur

#noteblock("Valeur surnuméraire", text[
  Les valeurs surnuméraires ne sont pas des erreurs et sont ignorées
])

#addproposal("P0645")

== ``` std::format``` -- Types utilisateur

- Par spécialisation de ```cpp std::formatter<>```

```cpp
template<>
struct formatter<T> {
  template <class ParseContext>
  auto parse(ParseContext& parse_ctx);

  template <class FormatContext>
  auto format(const T& value, FormatContext& fmt_ctx);
};
```

#addproposal("P0645")

== ``` std::format``` -- Types utilisateur

```cpp
struct MyComplex { double real; double imag; };

template <>
struct formatter<MyComplex> {
  constexpr auto parse(format_parse_context& ctx) {
    return ctx.begin(); }

  auto format(const MyComplex& value, format_context& ctx) const {
    return format_to(ctx.out(), "{}+{}i", value.real, value.imag);
  }};

format("{}", MyComplex{1, 2});  // "1+2i"
```

#noteblock("Aller plus loin", text[
  Voir #link("https://www.sandordargo.com/blog/2025/07/23/format-your-own-type-part-1")[Format your own type (Part 1) #linklogo()] et #link("https://www.sandordargo.com/blog/2025/07/30/format-your-own-type-part-2")[Format your own type (Part 2) #linklogo()]
])

#codesample(
  "https://godbolt.org/#z:OYLghAFBqd5QCxAYwPYBMCmBRdBLAF1QCcAaPECAMzwBtMA7AQwFtMQByARg9KtQYEAysib0QXACx8BBAKoBnTAAUAHpwAMvAFYTStJg1DIApACYAQuYukl9ZATwDKjdAGFUtAK4sGIAMxmpK4AMngMmAByPgBGmMQgABwAnKQADqgKhE4MHt6%2BAUEZWY4CYRHRLHEJKbaY9qUMQgRMxAR5Pn6BdQ05za0E5VGx8UmpCi1tHQXdEwNDldVjAJS2qF7EyOwcAPQ7ANQIBARpCiB7AO5XAHQKhugk6K3AqNdoLDsxtKjAO2YaZgArDsNAB2Hb%2BDQ7fjEFhMAgAWgAnutiAjUBcGAiCEi0pgEWkBgizCYNABBUkUsz%2BcLIbxYfYmfxuUQKJRtJnYSnmGkMOleBlMtwwuEETnc6m0%2BmYRnMpwTYiYVji8k8qUCmVC1BpRpiFVU3n8wXMhXhYD6ykKrwOfbKYg/YisFhmkKGYBeJjATWgqzk/b%2B/YTdAgECmoz7ZhsJm%2BskB/bhAj7OHaEgAfQAbvEsgITD6NLmACLRylxoMh7W62hChOcpPhNOZ4jZhi5ixlkAMLy0b46wvFv0B9sVnJ6uWCWuEgjIBAZrM5Vvtzvdit9/wx1fr8kETAsNIGbeytz6q029si%2BHb4hCu0Op0ut0er211slwcEYOhgjEM37VMX78xF424KP2sYBmgDATJgqhpMQ%2BxMEBqD7ISTaYBAZ4kKKqYoUoqYQduqhimYABsyGtLh%2BHQQQyyMj6r5xv6CFEPGiZMgWgbviGjpGJgZwgDQDDoBAOGYHhshUaQ%2BxgBwhbScsoEMQGf7HABQG8bK7HtmGwDCeRomUYR1xxMA4QQKsLHyWu9EMYqBAbAwLEKQGfaqgOjGIfs54EBAEETLa9rAI6LDOkYrpGI%2BmDmKRsG3sFZqpgY4WepgpDWYpikYbC8JiYIVFRZ5mHZQZ1H7L5rF0W5DFMUh6ysf47FeTlBEENctVmU5il4FQ%2BwQMpX54IBwHXDuOpImZNEvpV6X7LVGkcR%2BjVEBAtWSeYJJ0aCRYbUWZhBMhAVBSFwAJQ%2ByXXJGKVpdN103ftsVHSdSVetcyYNnOAiWTGt37LZ9kzUBHUMS5YGKTCPXVRGc0aF40aQ0Kv7/gNakKLceAAF5oZ9jKWNYDATRVIPXV1PV9apwEmICFgtoC7FsWxUkyUCcm0V932DhchDTiTiODbxFNWDjljUwW%2BOs2zDGsjK0m0NJIBXeLcazfTmVYUtK3Y%2BtVibWtqVTQr%2BvXTFgV3kYj3umdF2ffLBsxIqTAANaA/rksM%2BmsvW/rSv1fNIaLagEAewb/rq2tL7a7tklG4d8WJebz2vcQs5NjkVt60HxPCQdJvHbHEUvfWieNs2ouB0HXuaZx/GFQQqZLaXQcBiHu3XGHO1BPXDf7AAVFH2dm3nIVvcnH1Ow3wOd3GGe93Fpu52dk7Tknxcsx3Cvlz7VdZTXddpxPitAatzetzrq9Bz3Wczznp3PQvM5Fyno9B%2BPe/7LbSqO1Zu/fS70ksO7X9ryAnNFW2Ud6Exfv9Agh9NZ9gjndY2l9%2B5nQTkvB%2Bn9wENzfg7R%2BbMf4cAYP/DBZcgHK0rn7AOADiFQI1sfOB597ox2vpgfODAh7FxwfrLBH9NxENwUwJQDM0iEIgevEB29/anzZk3GB4c9r0IQQ9OeN94SL3viPdBECuEcNung8wgJhEv1EWQ6utd/bSL0WtVOvDOF224ZI5%2BN1Cz7HqAIya1j0pGIWiYtWB8aHbR1gjFSSNyaU2FlY76Digba13r9YgDlaqA2Bhubk5IExJiYKZEulUvBZHDBdBQhItgb20glQg8QxAgQ0QGG8Cj7xPRlMgNIaQXy7SPILAWe1/jJMqjU6OoUmHISRAQBAOY6K7WUEMkZLY4H%2BEklwdaRYqn%2Bl6dnMKccZRpEmQIZQKiEAtLMBM4ZOYZlzL2lwfM2t0HWXbGgEhzJ4ZiIDrtWhe1GlpAmvc5kDMKZuAITJJZG9bl1SPF8x5ocfRyyBFWIELBYGvKaR8kFbhvmAl%2BdJQGNyvZIo3l5J5mtIWAmhYCWFsjJJvMRfDdFqK/kYsrkCw8DzjFbzxa2AlRL0xwrJQihlXyqVov%2BWLQFWLGVeOZeCrWbdI5bIYDsqcCAKW8pktS9FALMV3OxWC55EK9G0GxoCDlpLBlHJlbshVyK%2BU0tVXS4VoKmWihZdqqFeqWAtyBAwV1gJmmGs2ca2V04zUov5aBYGHBVi0E4ICXgfgOBaFIKgTgbSBYWEDKiIpPIeCkAIJoUNqx7YgEBBofQnBJBRuzXGzgvAziFqzTG0NpA4CwCQNBTAyBEJkAoBAZ4CgdkRFoEIEZmJOAZveGkOg8Icg9vqP2jE0bY0jroKMYAChmCnBGVA%2Bd9BiCRFYNsXgG74gAHkgLTsHbW4IqgW1kmIEuit56W3NHwNG3g/BBAiDEOwKQMhBCKBUOoM9uguD6DdCgaw1h9ADTOJAVYw4BBnA4AiIMbFTDtP%2BPsBEAB1MQuqMNUUdGhvETxBB4GQLwVAjZvxYEg2ZUgxAvBEbYAAFVQJ4KjqwFCpo/bYd84RJ19oHdGjNX5MDbAzRcR0aRs1hojaWs98aODYAva2ogcFVCJGIgiYikh9jAGQMgHqX46P2xohARNYH9i4EICQbG/guDLF4DWrQyxVgICVFgBI1G80FqLRwEtpBZ2kdvVWzNkmpMcDMDJ2Ncn7MhdIGovwkggA%3D%3D%3D",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Astruct+MyComplex%0A%7B%0A++double+real%3B%0A++double+imag%3B%0A%7D%3B%0A%0Atemplate%3C%3E%0Astruct+std::formatter%3CMyComplex%3E%0A%7B%0A++++constexpr+auto+parse(std::format_parse_context%26+ctx)%0A++++%7B%0A++++++++return+ctx.begin()%3B%0A++++%7D%0A+%0A++++auto+format(const+MyComplex%26+value,+std::format_context%26+ctx)+const%0A++++%7B%0A++++++++return+std::format_to(ctx.out(),+%22%7B%7D%2B%7B%7Di%22,+value.real,+value.imag)%3B%0A++++%7D%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++++std::cout+%3C%3C+std::format(%22%7B%7D%22,+MyComplex%7B1,+2%7D)+%3C%3C+%22%5Cn%22%3B%0A%7D'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0645")

== Tableaux

- Support des tableaux par ```cpp std::make_shared()```

```cpp
shared_ptr<double[]> foo = make_shared<double[]>(1024);
```

- Déduction de la taille des tableaux par ```cpp new()```

```cpp
double* a = new double[]{1, 2, 3};
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++double*+foo+%3D+new+double%5B%5D%7B1,+2,+3%7D%3B%0A++delete%5B%5D+foo%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cmemory%3E%0A%0Aint+main()%0A%7B%0A++std::shared_ptr%3Cdouble%5B%5D%3E+foo+%3D+std::make_shared%3Cdouble%5B%5D%3E(1024)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0674")
#addproposal("P1009")

== Destruction

- ```cpp std::destroying_delete_t``` : pas de destruction avant l'appel à ```cpp delete()```

#noteblock("Intérêt", text[
  Conserver des informations nécessaire à la libération
])

```cpp
struct Foo {
  void operator delete(Foo* ptr, destroying_delete_t) {
    const size_t realSize = ...;
    ptr->~Foo();
    ::operator delete(ptr, realSize);
  }
};
```

#alertblock("Ne pas oublier", text[
  La destruction doit être appelée explicitement
])

#addproposal("P0722")

== Horloges

- Nouvelles horloges
  - ```cpp std::chrono::utc_clock```
    - Temps universel coordonné
    - Epoch : 1 janvier 1970 00:00:00
    - Support des secondes intercalaires
  - ```cpp std::chrono::gps_clock```
    - Epoch : 6 janvier 1980 00:00:00 UTC
    - Pas de seconde intercalaire
  - ```cpp std::chrono::tai_clock```
    - Temps atomique universel
    - Epoch : 31 décembre 1957 23:59:50 UTC
    - Pas de seconde intercalaire
  - ```cpp std::chrono::file_clock``` : alias vers le temps du système de fichier

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cchrono%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7B:%25F+%25T%7D%22,+std::chrono::utc_clock::now())+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B:%25F+%25T%7D%22,+std::chrono::gps_clock::now())+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B:%25F+%25T%7D%22,+std::chrono::tai_clock::now())+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B:%25F+%25T%7D%22,+std::chrono::file_clock::now())+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0355")

== Horloges

- Conversion des horloges vers et depuis UTC
- Conversion de ```cpp std::chrono::utc_clock``` vers et depuis le temps système
- Conversion des horloges entre-elles

#alertblock(text[Conversion de ```cpp std::chrono::file_clock```], text[
  Support optionnel des conversions entre ```cpp std::chrono::file_clock``` et ```cpp std::chrono::utc_clock``` ou ```cpp std::chrono::system_clock```
])

- Pseudo-horloge ```cpp std::chrono::local_t``` temps dans la _timezone_ locale

#addproposal("P0355")

== Évolution de ``` std::chrono::duration```

- _Helper_ pour le jour, la semaine, le mois ou l'année
- ```cpp from_stream()``` lit une ```cpp std::chrono::duration```
- Utilisation de chaîne de format utilisant des séquences préfixées par ```cpp %```
  - ```cpp %H```,```cpp %I``` : heure (format 24h ou 12h)
  - ```cpp %M``` : minutes
  - ```cpp %S``` : secondes
  - ```cpp %Y```, ```cpp %y``` : année (4 ou 2 chiffres)
  - ```cpp %m``` : numéro du mois
  - ```cpp %b```, ```cpp %B``` : nom du mois dans la locale (abrégé ou complet)
  - ```cpp %d``` : numéro du jour dans le mois
  - ```cpp %U``` : numéro de la semaine
  - ...
// Similaire à strftime()
// Et identique à ceux utilisés dans std::format

#addproposal("P0355")

== Calendrier

- Gestion du calendrier grégorien
- Différentes représentations
  - Année, mois
  - Jour dans l'année, dans le mois
  - Dernier jour du mois
  - Jour dans la semaine, $n^\e$ jour de la semaine dans le mois
  - Et différentes combinaisons permettant de construire une date complète

#alertblock("Convention anglo-saxonne", text[
  Le premier jour de la semaine est le dimanche
])

#addproposal("P0355")

== Calendrier

- Constantes représentant les jours de la semaine et les mois
- Suffixes littéraux ```cpp y``` et ```cpp d``` pour les années et les jours
- ```cpp operator/``` pour construire une date depuis un format humain

```cpp
auto date1 = 2016y/May/29d;
auto date2 = Sunday[3]/May/2016y;
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cchrono%3E%0A%23include+%3Cformat%3E%0A%0Ausing+namespace+std::literals::chrono_literals%3B%0A%0Aint+main()%0A%7B%0A++auto+date1+%3D+2016y/std::chrono::May/29d%3B%0A++auto+date2+%3D+std::chrono::Sunday%5B3%5D/std::chrono::May/2016y%3B%0A%0A++std::cout+%3C%3C+std::format(%22%7B:%25F%7D%22,+date1)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B:%25F%7D%22,+date2)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0355")

== Timezone

- Gestion des _timezones_
  - Gestion de la base de _timezones_ de l'IANA
  // IANA : Internet Assigned Numbers Authority
  - Récupération de la _timezone_ courante
  - Recherche d'une _timezone_ depuis son nom
  - Caractéristiques d'une _timezone_
  - Informations sur les secondes intercalaires
  - Récupération du nom d'une _timezone_
  - Conversion entre _timezone_
  - Gestion des ambiguïté de conversion

```cpp
// 2016-05-29 07:30:06.153 UTC
auto tp = sys_days{2016y/may/29d} + 7h + 30min + 6s + 153ms;
// 2016-05-29 16:30:06.153 JST
zoned_time zt = {"Asia/Tokyo", tp};
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cchrono%3E%0A%23include+%3Cformat%3E%0A%0Ausing+namespace+std::literals::chrono_literals%3B%0A%0Aint+main()%0A%7B%0A++auto+tp+%3D+std::chrono::sys_days%7B2016y/std::chrono::May/29d%7D+%2B+7h+%2B+30min+%2B+6s+%2B+153ms%3B+%0A++std::chrono::zoned_time+zt+%3D+%7B%22Asia/Tokyo%22,+tp%7D%3B%0A%0A++std::cout+%3C%3C+std::format(%22%7B:%25F+%25T+%25Z%7D%22,+tp)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B:%25F+%25T+%25Z%7D%22,+zt)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0355")

== Date et heure

#noteblock("Alternative à C++20", text[
  Utilisez ```cpp Boost.DateTime```
])

#noteblock("Pour aller plus loin", text[
  #link("http://site.icu-project.org/home")[```cpp ICU``` #linklogo()] supporte de nombreux calendriers et mécanismes de localisation
  // ICU : International Components for Unicode
])

== Range-based for loop

- Initialisation dans les range-based for loop

```cpp
vector<int> foo{1, 8, 5, 56, 42};
for(size_t i = 0; const auto& bar : foo) {
  cout << bar << " " << i << "\n";
  ++i; }
```

- Seuls des couples ```cpp begin()```, ```cpp end()``` cohérents sont utilisés
  - "Début" et "début + taille"
  - fonctions membres ```cpp begin()``` et ```cpp end()```
  - fonctions libres ```cpp std::begin()``` et ```cpp std::end()```

#noteblock("Intérêt", text[
  Itération (via des fonctions libres) d'éléments ayant une fonction membre ```cpp begin()``` ou ```cpp end()``` mais pas les deux
])

// Fonction membre qui n'est probablement pas une fonction d'itération
// Auparavant la fonction membre était utilisé bien qu'incohérente

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B1,+8,+5,+56,+42%7D%3B%0A++for(size_t+i+%3D+0%3B+const+auto%26+bar+:+foo)+%0A++%7B%0A++++std::cout+%3C%3C+bar+%3C%3C+%22+%22+%3C%3C+i+%3C%3C+%22%5Cn%22%3B%0A++++%2B%2Bi%3B+%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0614")
#addproposal("P0962")

== ``` consteval```

- ```cpp consteval``` impose une évaluation _compile-time_
  // constexpr permet une évaluation compile-time mais ne l'impose pas
  - ```cpp consteval``` implique ```cpp inline```

```cpp
consteval int sqr(int n) { return n * n; }
sqr(100);    // OK
int x = 100;
sqr(x);      // Erreur
```

#alertblock("Restriction", text[
  Pas de pointeur dans des contextes ```cpp consteval```
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aconsteval+int+sqr(int+n)%0A%7B%0A++return+n+*+n%3B%0A%7D%0A%0Aconstexpr+int+sqr2(int+n)%0A%7B%0A++return+n+*+n%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+sqr(100)+%3C%3C+%22%5Cn%22%3B%0A%0A++constexpr+int+x+%3D+10%3B%0A++std::cout+%3C%3C+sqr(x)+%3C%3C+%22%5Cn%22%3B%0A%0A++int+y+%3D+100%3B%0A%23if+0%0A++std::cout+%3C%3C+sqr(y)%3B+%3C%3C+%22%5Cn%22%3B%0A%23endif%0A%0A%23if+0%0A++std::cout+%3C%3C+sqr2(y)+%3C%3C+%22%5Cn%22%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic+-Wno-unused-variable',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P1073")

== ``` constinit```

- ```cpp constinit``` impose une initialisation durant la phase _static initialization_
  - Uniquement sur des objets dont la _storage duration_ est _static_ ou _thread_
  - Mal-formé en cas d'initialisation dynamique
  - Adresse le _static initialization order fiasco_

#addproposal("P1143")

== ``` constexpr```

- Initialisation triviale dans des contextes ```cpp constexpr```
- ```cpp std::is_constant_evaluated()``` teste si l'évaluation est _compile-time_
- Prise en compte accrue dans la bibliothèque standard
- Assouplissement des restrictions
  - Fonctions virtuelles ```cpp constexpr```
  - Utilisation d'```cpp union```
  - Utilisation de ```cpp try {} catch()```
    - Se comporte comme _no-ops_ en _compile-time_
    - Ne peut pas lancer d'exception _compile-time_
  - Utilisation de ```cpp dynamic_cast``` et ```cpp typeid```
  - Utilisation de ```cpp asm```
    - Si le code ```cpp asm``` n'est pas évalué en _compile-time_

#addproposal("P1064")
#addproposal("P1002")
#addproposal("P1330")
#addproposal("P1331")

== Structured binding

- Extension à tous les membres visibles
// structured binding sur les membres privés depuis une fonction membre ou amis
- Capture par les lambdas (copie et référence)
// En C++17, les lambdas ne peuvent pas capturer de structured binding

```cpp
tuple foo{5, 42};

auto[a, b] = foo;
auto f1 = [a] { return a; };
auto f2 = [=] { return b; };
```

- Déclaration ```cpp inline```, ```cpp extern```, ```cpp static```, ```cpp thread_local``` ou ```cpp constexpr``` possible
- Possibilité de marquer ```cpp [[ maybe_unused ]]```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ctuple%3E%0A%0Aint+main()%0A%7B%0A++std::tuple+foo%7B5,+42%7D%3B%0A%0A++auto%5Ba,+b%5D+%3D+foo%3B%0A++auto+f1+%3D+%5Ba%5D+%7B+return+a%3B+%7D%3B%0A++auto+f2+%3D+%5B%3D%5D+%7B+return+b%3B+%7D%3B%0A%0A++std::cout+%3C%3C+f1()+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+f2()+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0961")
#addproposal("P1091")
#addproposal("P1381")

== Structured binding

- Recherche de ```cpp get()``` : seules les fonctions membres templates dont le premier paramètre template n'est pas un type sont retenues

#noteblock("Motivation", text[
  Utiliser des classes possédant un ```cpp get()``` indépendant de l'interface _tuple-like_
])

```cpp
struct X : shared_ptr<int> { string foo; };
template<int N> string& get(X& x) {
  if constexpr(N==0) return x.foo; }
template<> class tuple_size<X> :
  public integral_constant<int, 1> {};
template<> class tuple_element<0, X> {
  public: using type = string; };

X x;
auto& [y] = x;
```

// Exemple invalide en C++17 à cause du get() de shared_ptr qui n'était pas utilisable mais empêchait de rechercher dans le namespace englobant. En C++20 cette fonction n'est pas retenue et on recherche dans le namespace

#addproposal("P0969")

== Non-Type Template Parameters

- Utilisation possible de classes
  - _strong structural equality_
    - Classes de base et membres non statiques avec un _defaulted_ ```cpp operator==```
    - Pas de référence
    - Pas de type flottant
  - Pas d'union

```cpp
template<chrono::seconds seconds>
class fixed_timer { ... };
```

// En C++17, il fallait utiliser un type entier, p.ex. size_t

```cpp
template<fixed_string Id>
class entity { ... };

entity<"hello"> e;
```

// En C++17, il faut utiliser un ensemble de char : template<char... Id>

#addproposal("P0732")

== Templates

- ```cpp typename``` optionnel lorsque seul un nom de type est possible

// Il ne sert qu'à lever des ambigüités

- Spécialisation possible sur des classes internes privées ou protégées
- ```cpp std::type_identity<>``` désactive la déduction de type

```cpp
template<class T>
void foo(T, T);

foo(4.2, 0); // erreur, int ou double
```

```cpp
template<class T>
void foo(T, type_identity_t<T>);

foo(4.2, 0); // OK, g<double>
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ctype_traits%3E%0A%0Atemplate%3Cclass+T%3E%0A%23if+1%0AT+foo(T+a,+std::type_identity_t%3CT%3E+b)%0A%23else%0AT+foo(T+a,+T+b)%0A%23endif%0A%7B%0A++return+a+%2B+b%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+foo(4.2,+3)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0846")
#addproposal("P0887")

== Templates

- Déduction de type sur les alias de template

```cpp
template<typename T>
using IntPair = std::pair<int, T>;

// C++ 17
IntPair<double> p0{1, 2.0};

// C++ 20
IntPair p1{1, 2.0};   // std::pair<int, double>
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cutility%3E%0A%0Atemplate%3Ctypename+T%3E%0Ausing+IntPair+%3D+std::pair%3Cint,+T%3E%3B%0A%0Aint+main()%0A%7B%0A++IntPair%3Cdouble%3E+p0%7B1,+2.0%7D%3B+%0A++IntPair+p1%7B1,+2.0%7D%3B+%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P1814")

== Paramètres ``` auto```

- Création de fonctions templates via ```cpp auto```

```cpp
void foo(auto a, auto b) { ... };
```

- Similaire	à la création de lambdas polymorphiques

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aauto+foo(auto+a,+auto+b)%0A%7B%0A++return+a+%2B+b%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+foo(4,+3)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Concepts -- Présentation

- Histoire ancienne et mouvementée
  - Prévu initialement pour C++0x
  - ... et cause des décalages successifs
  - Retrait à grand bruit de C++11
  - Finalement Concept lite TS publié en 2015
  - Intégration du TS acceptée en juillet 2017
// Mais pas en C++17, il fallait le support par les compilateurs avant pour valider le concept

#addproposal("P0734")
#addproposal("P0898")

== Concepts -- Présentation

- Contraintes sur les paramètres templates et l'inférence de type
  - Meilleurs diagnostics
  - Meilleure documentation du code
  - Aide à la déduction de type
  - Aide à la résolution de spécialisation
// Basé du coup sur un "nom" et non sur la structure (typage nominal/structurel)
- Propositions abandonnées / mises de côté
  - _Axiom_ : spécification de propriétés sémantiques d'un concept
  // Les concepts actuels se basent sur la structure et des propriétés syntaxiques (p.ex. l'opération d'addition est présent)
  // Exemple d'axiom : associativité ou commutativité
  // Intérêt des axiom : meilleure documentation, informations au compilateur (meilleurs avertissement et diagnostics, meilleures optimisations)
  - _Concept map_ : transformation d'un type non-compatible vers un concept
// Exemple de concept map : Utilisation de type définissant l'inégalité stricte et la comparaison vers un concept attendant l'inégalité large, implémentation du concept de pile (stack) par std::vector

#addproposal("P0734")
#addproposal("P0898")

== Concepts -- Utilisation template

- Utilisable via une _Requires clause_

```cpp
template<typename T> requires incrementable<T>
void foo(T);
```

... via une _Trailing requires clause_

```cpp
template<typename T>
void foo(T) requires incrementable<T>;
```

- ... via des paramètres templates contraints

```cpp
template<incrementable T>
void foo(T);
```

- ... ou via des combinaisons de ces syntaxes

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Atemplate%3Cstd::incrementable+T%3E%0Avoid+foo(T)%0A%7B%7D%0A%0Aint+main()%0A%7B%0A++foo(5)%3B%0A%23if+0%0A++foo(std::vector%3Cint%3E%7B1,+2,+3%7D)%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Atemplate%3Ctypename+T%3E%0Avoid+foo(T)+requires+std::incrementable%3CT%3E%0A%7B%7D%0A%0Aint+main()%0A%7B%0A++foo(5)%3B%0A%23if+0%0A++foo(std::vector%3Cint%3E%7B1,+2,+3%7D)%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Atemplate%3Ctypename+T%3E+requires+std::incrementable%3CT%3E%0Avoid+foo(T)%0A%7B%7D%0A%0Aint+main()%0A%7B%0A++foo(5)%3B%0A%23if+0%0A++foo(std::vector%3Cint%3E%7B1,+2,+3%7D)%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0734")
#addproposal("P0898")

== Concepts -- Utilisation template

- Utilisable depuis un concept nommé

```cpp
template<typename T> requires incrementable<T>
void foo(T);
```

- ... ou depuis des expressions

```cpp
template<typename T> requires requires (T x) { ++x; }
void foo(T);
```

```cpp
template<typename T> requires (sizeof(T) > 1)
void foo(T);
```

// Oui, requires est bien en double

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Atemplate%3Ctypename+T%3E+requires+(sizeof(T)+%3E+1)%0Avoid+foo(T)%0A%7B%7D%0A%0Aint+main()%0A%7B%0A++foo(5)%3B%0A%23if+0%0A++foo(!'a!')%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Atemplate%3Ctypename+T%3E+requires+requires+(T+x)+%7B+x%2B%2B%3B+%7D%0Avoid+foo(T)%0A%7B%7D%0A%0Aint+main()%0A%7B%0A++foo(5)%3B%0A%23if+0%0A++foo(std::vector%3Cint%3E%7B0,+1%7D)%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Atemplate%3Ctypename+T%3E+requires+std::incrementable%3CT%3E%0Avoid+foo(T)%0A%7B%7D%0A%0Aint+main()%0A%7B%0A++foo(5)%3B%0A%23if+0%0A++foo(std::vector%3Cint%3E%7B0,+1%7D)%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0734")
#addproposal("P0898")

== Concepts -- Utilisation template

- Peuvent être composés

```cpp
template<typename T>
requires (sizeof(T) > 1 && sizeof(T) <= 4)
void foo(T);
```

```cpp
template<typename T>
requires (sizeof(T) == 2 || sizeof(T) == 4)
		void foo(T);
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Atemplate%3Ctypename+T%3E%0Arequires+(sizeof(T)+%3D%3D+2+%7C%7C+sizeof(T)+%3D%3D+4)%0Avoid+foo(T)%0A%7B%7D%0A%0Aint+main()%0A%7B%0A++foo(5)%3B%0A%23if+0%0A++foo(!'a!')%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Atemplate%3Ctypename+T%3E%0Arequires+(sizeof(T)+%3E+1+%26%26+sizeof(T)+%3C%3D+4)%0Avoid+foo(T)%0A%7B%7D%0A%0Aint+main()%0A%7B%0A++foo(5)%3B%0A%23if+0%0A++foo(!'a!')%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0734")
#addproposal("P0898")

== Concepts -- Utilisation template

- Support des _parameters pack_

```cpp
template<Constraint... T>
void foo(T...);
```

```cpp
template<typename... T>
requires (Constraint<T> && ... && true)
void foo(T...);
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Atemplate%3Ctypename...+T%3E%0Arequires+(std::incrementable%3CT%3E+%26%26...+%26%26+true)%0Avoid+foo(T...)%0A%7B%7D%0A%0Aint+main()%0A%7B%0A++foo(5)%3B%0A++foo(5,+6,+7)%3B%0A%23if+0%0A++foo(std::vector%3Cint%3E%7B1,+2%7D)%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:6,endLineNumber:12,positionColumn:6,positionLineNumber:12,selectionStartColumn:6,selectionStartLineNumber:12,startColumn:6,startLineNumber:12),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Atemplate%3Cstd::incrementable...+T%3E%0Avoid+foo(T...)%0A%7B%7D%0A%0Aint+main()%0A%7B%0A++foo(5)%3B%0A++foo(5,+6,+7)%3B%0A%23if+0%0A++foo(std::vector%3Cint%3E%7B1,+2%7D)%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0734")
#addproposal("P0898")

== Concepts -- Utilisation inférence de type

- Contraintes sur les paramètres (lambdas et fonctions templates)

```cpp
[](Constraint auto a) {}
void foo(Constraint auto a);
```

- Contraintes sur les types de retour

```cpp
Constraint auto foo();
auto bar() -> Constraint decltype(auto);
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Astd::incrementable+auto+foo()+%0A%7B%0A%23if+1%0A++return+5%3B%0A%23else%0A++return+std::vector%3Cint%3E%7B%7D%3B%0A%23endif%0A%7D%0A%0Aauto+bar()+-%3E+std::incrementable++decltype(auto)%0A%7B%0A%23if+1%0A++return+5%3B%0A%23else%0A++return+std::vector%3Cint%3E%7B%7D%3B%0A%23endif%0A%7D%0A%0Aint+main()%0A%7B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Avoid+foo(std::incrementable+auto)%0A%7B%7D%0A%0Aint+main()%0A%7B%0A++foo(5)%3B%0A%23if+0%0A++foo(std::vector%3Cint%3E%7B%7D)%3B%0A%23endif%0A%0A++auto+bar+%3D+%5B%5D(std::incrementable+auto)+%7B%7D%3B%0A++bar(5)%3B%0A%23if+0%0A++bar(std::vector%3Cint%3E%7B%7D)%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0734")
#addproposal("P0898")

== Concepts -- Utilisation inférence de type

- Contraintes sur les variables

```cpp
Constraint auto bar = ...;
```

- Contraintes sur les _non-type template parameters_

```cpp
template<Constraint auto S>
void foo();
```

- Support des _parameters pack_

```cpp
void foo(Constraint auto... T);
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Avoid+foo(std::incrementable+auto...)%0A%7B%7D%0A%0Aint+main()%0A%7B%0A++foo(5)%3B%0A++foo(1,+2,+3)%3B%0A%23if+0%0A++foo(std::vector%3Cint%3E%7B%7D)%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Atemplate%3Cstd::incrementable+auto+S%3E%0Avoid+foo()%0A%7B%7D%0A%0Aint+main()%0A%7B%0A++foo%3C5%3E()%3B%0A%23if+0%0A++foo%3Cstd::vector%3Cint%3E%7B%7D%3E()%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Aint+main()%0A%7B%0A++std::incrementable+auto+foo+%3D+5%3B%0A%23if+0%0A++std::incrementable+auto+bar+%3D+std::vector%3Cint%3E%7B%7D%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic+-Wno-unused-variable',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0734")
#addproposal("P0898")

== Concepts -- Standard

- Nombreux concepts standards
  - Relations entre types : ```cpp same_as```, ```cpp derived_from```, ```cpp convertible_to```, ```cpp common_with```, ...
  - Types numériques : ```cpp integral```, ```cpp signed_integral```, ```cpp unsigned_integral```, ```cpp floating_point```, ...
  - Opérations supportées : ```cpp swappable```, ```cpp destructible```, ```cpp default_constructible```, ```cpp move_constructible```, ```cpp copy_constructible```, ...
  - Catégories de types : ```cpp movable```, ```cpp copyable```, ```cpp semiregular```, ```cpp regular```, ...
  // semiregular : copyable et default_constructible
  // regular : semiregular et equality_comparable

  - Comparaisons : ```cpp boolean```, ```cpp equality_comparable```, ```cpp totally_ordered```, ...
  - _Callable concepts_ : ```cpp invocable```, ```cpp predicate```, ```cpp strict_weak_order```, ...
  - ...

#addproposal("P0734")
#addproposal("P0898")

== Concepts -- Définition

- Peuvent être définis depuis des expressions

```cpp
template<typename T>
concept Addable = requires (T x) { x + x; };
```

```cpp
template <class T, class U = T>
concept Swappable = requires(T&& t, U&& u) {
  swap(forward<T>(t), forward<U>(u));
  swap(forward<U>(u), forward<T>(t)); };
```

#addproposal("P0734")
#addproposal("P0898")

== Concepts -- Définition

- Y compris en retirant des qualifieurs

```cpp
template<class T>
concept Addable = requires(
  const remove_reference_t<T>& a,
  const remove_reference_t<T>& b) { a + b; };
```

- Ou en imposant les types de retour

```cpp
template<class T>
concept Comparable = requires(T a, T b) {
  { a == b } -> boolean;
  { a != b } -> boolean; };
```

#addproposal("P0734")
#addproposal("P0898")

== Concepts -- Définition

- Depuis des _traits_

```cpp
template<class T>
concept integral = is_integral_v<T>;
```

```cpp
template<class T, class... Args>
concept constructible_from =
  destructible<T> && is_constructible_v<T, Args...>;
```

#addproposal("P0734")
#addproposal("P0898")

== Concepts -- Définition

- Depuis d'autres concepts

```cpp
template<class T> concept semiregular =
  copyable<T> && default_constructible<T>;
```

- En combinant différentes méthodes

```cpp
template<class T> concept totally_ordered =
  equality_comparable<T> &&
  requires(const remove_reference_t<T>& a,
           const remove_reference_t<T>& b) {
    { a < b } -> boolean;
    { a > b } -> boolean;
    { a <= b } -> boolean;
    { a >= b } -> boolean;
  };
```

#addproposal("P0734")
#addproposal("P0898")

== Attributs

- ```cpp [[ likely ]]``` et ```cpp [[ unlikely ]]``` probabilité de branches conditionnelles
// Fourni au compilateur des informations lui permettant des optimisations plus pertinentes
- ```cpp [[ no_unique_address ]]``` membre statique ne nécessitant pas une adresse unique
// Et permettre l'EMO (Empty Member Optimisation)
- Extension de ```cpp [[ nodiscard ]]``` aux constructeurs
  - Marquage ```cpp [[ nodiscard ]]``` des constructeurs autorisé
  - Vérification également lors des conversions via les constructeurs
- Possibilité d'associer un message à ```cpp [[ nodiscard ]]```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0A%5B%5B+nodiscard(%22Must+be+checked%22)+%5D%5D+static+int+foo()%0A%7B%0A++return+5%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++foo()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astruct+Bar+%7B%0A++%5B%5B+nodiscard+%5D%5DBar()+%7B%7D%0A%7D%3B%0A%0Aint+main()%0A%7B%0A%23if+0%0A++Bar+b%7B%7D%3B%0A%23else%0A++Bar%7B%7D%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0479")
#addproposal("P0840")
#addproposal("P1771")
#addproposal("P1301")

== Lambda

- Utilisables dans des contextes non évalués
// Contextes non évalués : sizeof(), typeid() ou decltype()
- Utilisation de paramètres templates pour les lambdas génériques
  - En complément de la syntaxe avec ```cpp auto```
  - Permet de récupérer le type

#noteblock("Usage", text[
  Spécification de contraintes sur paramètres : types identiques, itérateur, ...
])

```cpp
auto foo = []<typename T>(T first, T second) {
  return first + second; };
```

```cpp
auto foo = []<typename T>(vector<T> const& vec) {
  cout<< size(vec) << '\n';
  cout<< vec.capacity() << '\n';
};
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Aint+main()%0A%7B%0A++auto+foo+%3D+%5B%5D%3Ctypename+T%3E(std::vector%3CT%3E+vec)+%7B+return+std::size(vec)%3B+%7D%3B%0A%0A++std::cout+%3C%3C+foo(std::vector%3Cint%3E%7B1,+2,+3%7D)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+foo(std::vector%3Cdouble%3E%7B1.,+2.%7D)+%3C%3C+%22%5Cn%22%3B%0A%23if+0%0A++std::cout+%3C%3C+foo(5)+%3C%3C+%22%5Cn%22%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Aint+main()%0A%7B%0A++auto+foo+%3D+%5B%5D%3Ctypename+T%3E(T+first,+T+second)+%7B+return+first+%2B+second%3B+%7D%3B%0A%0A++std::cout+%3C%3C+foo(1,+5)+%3C%3C+%22%5Cn%22%3B%0A%23if+0%0A++std::cout+%3C%3C+foo(1.,+5)+%3C%3C+%22%5Cn%22%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0315")
#addproposal("P0428")

== Lambda

- Lambda _stateless_ assignables et constructibles par défaut
// stateless, c'est à dire qui ne capture rien

```cpp
auto greater = [](auto x,auto y) { return x > y; };

map<string, int, decltype(greater)> foo;
```

- Dépréciation de la capture implicite de ```cpp this``` par ```cpp [=]```
  - Capture explicite par ```cpp [=, this]```
  // this est capturé par référence
  - Capture implicite par ```cpp [&]``` toujours présente
- Capture de _structured binding_

#addproposal("P0624")
#addproposal("P0409")

== Lambda

- Expansion des _parameter packs_ lors de la capture

```cpp
template<class F, class... Args>
auto delay_invoke(F f, Args... args) {
  return [f=move(f),...args=move(args)]()->decltype(auto) {
    return invoke(f, args...);
  }
}
```

- Peuvent être ```cpp consteval```

#addproposal("P0780")

== Binding

- ```cpp std::bind_front()``` assigne les arguments fournis aux premiers paramètres de l'appelable

```cpp
int foo(int a, int b, int c, int d) { return a * b * c + d; }

auto baz = bind_front(&foo, 2, 3, 4);
baz(7);  // 31

// Equivalent a

auto bar = bind(&foo, 2, 3, 4, _1);
bar(6);  // 30
```

- ```cpp std::reference_wrapper``` accepte les types incomplets
// Exemple de types incomplets : forward declaration ou types abstraits

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Cfunctional%3E%0A%23include+%3Ciostream%3E%0A%0Aint+foo(int+a,+int+b,+int+c,+int+d)%0A%7B%0A++return+a+*+b+*+c+%2B+d%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+foo(2,+3,+4,+5)+%3C%3C+%22%5Cn%22%3B%0A%0A++auto+bar+%3D+std::bind(%26foo,+2,+3,+4,+std::placeholders::_1)%3B%0A++std::cout+%3C%3C+bar(6)+%3C%3C+%22%5Cn%22%3B%0A%0A++auto+baz+%3D+std::bind_front(%26foo,+2,+3,+4)%3B%0A++std::cout+%3C%3C+baz(7)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0356")
#addproposal("P0357")

== ``` std::atomic```

- ```cpp std::atomic<std::shared_ptr<T>>```
- ```cpp std::atomic<>``` sur les types flottant
- Initialisation par défaut de ```cpp std::atomic<>```
- ```cpp std::atomic_ref``` applique des modifications atomiques sur des données non-atomiques qu'il référence
- ```cpp wait()```, ```cpp notify_one()``` et ```cpp notify_all()``` pour attendre le changement d'état d'un ```cpp std::atomic```

#addproposal("P0718")
#addproposal("P0020")
#addproposal("P0883")
#addproposal("P0019")

== Thread

- Nouvelle variante ```cpp std::jthread```
  - Automatiquement arrêté et joint lors de la destruction

```cpp
int main() { thread t(foo); }  // Erreur (terminate)
```

// Il faut rajouter un appel à join() pour corriger ce problème

```cpp
int main() { jthread t(foo); } // OK
```

#list(marker: [], list(indent: 5pt, text[Peut être arrêté par l'appel à ```cpp request_stop()```]))

```cpp
void foo(stop_token st) {
  while(!st.stop_requested()) { ... }
}

jthread t(foo);
...
t.request_stop();
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cthread%3E%0A%23include+%3Cchrono%3E%0A%0Ausing+namespace+std::chrono_literals%3B%0A%0Avoid+foo(std::stop_token+st)%0A%7B%0A++while(!!st.stop_requested())%0A++%7B+%0A++++std::cout+%3C%3C+%22Foo%5Cn%22%3B%0A++++std::this_thread::sleep_for(500ms)%3B%0A++%7D%0A%7D%0A%0Aint+main()%0A%7B%0A++std::jthread+t(foo)%3B%0A++std::this_thread::sleep_for(2s)%3B%0A%0A++t.request_stop()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic+-pthread',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cthread%3E%0A%0Avoid+foo()%0A%7B%0A++std::cout+%3C%3C+%22Foo%5Cn%22%3B%0A%7D%0A%0Aint+main()%0A%7B%0A%23if+1%0A++std::jthread+t(foo)%3B%0A%23else%0A++std::thread+t(foo)%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic+-pthread',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0660")

== synchronisation -- sémaphores

- ```cpp std::counting_semaphore```
  - Création avec la valeur maximale de possesseurs
  - ```cpp max()``` retourne le nombre maximal de possesseurs
  - ```cpp release()``` relâche, une ou plusieurs fois, le sémaphore
  // Incrémente le compteur de la valeur en paramètre, 1 par défaut
  - ```cpp acquire()``` prend le sémaphore en attendant si besoin
  // Décrémente le compteur de 1 en attendant tant qu'il est nul
  - ```cpp try_acquire()``` tente de prendre le sémaphore et retourne le résultat de l'opération
  // Décrémente le compteur de 1 s'il n'est pas nul et retourne true dans ce cas, et false si le compteur est nul
  - ```cpp try_acquire_for()``` tente de prendre le sémaphore en attendant la durée donnée si besoin
  - ```cpp try_acquire_until()``` tente de prendre le sémaphore en attendant jusqu'à un temps donné si besoin
- ```cpp std::binary_semaphore```	instanciation de ```cpp std::counting_semaphore``` pour un unique possesseur

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cthread%3E%0A%23include+%3Cchrono%3E%0A%23include+%3Csemaphore%3E%0A+%0Astd::binary_semaphore+signalMainToThread%7B0%7D%3B%0Astd::binary_semaphore+signalThreadToMain%7B0%7D%3B%0A%0Ausing+namespace+std::literals%3B%0A%0Avoid+foo()%0A%7B%0A++signalMainToThread.acquire()%3B%0A++std::cout+%3C%3C+%22%5Bthread%5D+Reception+du+signal%5Cn%22%3B%0A+%0A++std::this_thread::sleep_for(2s)%3B%0A+%0A++std::cout+%3C%3C+%22%5Bthread%5D+Envoi+a+main%5Cn%22%3B%0A++signalThreadToMain.release()%3B%0A%7D%0A+%0Aint+main()%0A%7B%0A++std::thread+worker(foo)%3B%0A++std::this_thread::sleep_for(2s)%3B%0A%0A++std::cout+%3C%3C+%22%5Bmain%5D+Envoi+au+thread%5Cn%22%3B%0A++signalMainToThread.release()%3B%0A++signalThreadToMain.acquire()%3B%0A+%0A++std::cout+%3C%3C+%22%5Bmain%5D+Got+the+signal%5Cn%22%3B+//+response+message%0A++worker.join()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic+-pthread',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P1135")

== synchronisation -- latch

- ```cpp std::latch``` compteur descendant permettant de bloquer des threads tant qu'il n'a pas atteint zéro
  - Création avec la valeur initiale du compteur
  - ```cpp count_down()``` décrémente le compteur
  - ```cpp try_wait()``` indique si le compteur a atteint zéro
  - ```cpp wait()``` attend jusqu'à ce que le compteur atteigne zéro
  - ```cpp arrive_and_wait()``` décrémente le compteur et attend qu'il atteigne zéro

#alertblock("Pas d'incrément", text[
  Impossible d'incrémenter un ```cpp std::latch``` et de revenir à sa valeur initiale
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Clatch%3E%0A%23include+%3Cthread%3E%0A%0Aint+main()%0A%7B%0A++const+size_t+nbLatch+%3D+5%3B%0A++std::latch+l1(nbLatch)%3B%0A++std::latch+l2(1)%3B%0A%0A++auto+work+%3D+%5B%26%5D+(int+i)%0A++++++++++++++%7B%0A++++++++++++++++std::cout+%3C%3C+%22Entree+foo%22+%3C%3C+i+%3C%3C+%22%5Cn%22%3B%0A++++++++++++++++l1.count_down()%3B%0A++++++++++++++++l2.wait()%3B%0A++++++++++++++++std::cout+%3C%3C+%22Sortie+foo%22+%3C%3C+i+%3C%3C+%22%5Cn%22%3B%0A++++++++++++++%7D%3B%0A%0A++std::cout+%3C%3C+%22Demarrage%5Cn%22%3B%0A++std::jthread+t%5BnbLatch%5D%3B%0A++for(size_t+i+%3D+0%3B+i+%3C+nbLatch%3B+%2B%2Bi)%0A++%7B%0A++++t%5Bi%5D+%3D+std::jthread(work,+i)%3B%0A++%7D%0A%0A++l1.wait()%3B%0A++std::cout+%3C%3C+%22Thread+OK%5Cn%22%3B%0A++l2.count_down()%3B%0A%7D'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic+-pthread',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P1135")

== synchronisation -- barrière

- ```cpp std::barrier``` attend qu'un certain nombre de threads n'atteigne la barrière
  - Création avec le nombre de threads attendus
  - ```cpp arrive()``` décrémente le compteur
  - ```cpp wait()``` attend que le compteur atteigne zéro
  - ```cpp arrive_and_wait()``` décrémente le compteur et attend qu'il atteigne zéro
  - ```cpp arrive_and_drop()``` décrémente le compteur ainsi que la valeur initiale
  - Une fois zéro atteint, les threads en attente sont débloqués et le compteur reprend la valeur initiale décrémentée du nombre de threads "_droppés_"

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cbarrier%3E%0A%23include+%3Cthread%3E%0A%0Aint+main()%0A%7B%0A++const+size_t+nb+%3D+5%3B%0A++std::barrier+b(nb)%3B%0A%0A++auto+work+%3D+%5B%26%5D+(int+i)%0A++++++++++++++%7B%0A++++++++++++++++std::cout+%3C%3C+%22Entree+foo%22+%3C%3C+i+%3C%3C+%22%5Cn%22%3B%0A++++++++++++++++b.arrive_and_wait()%3B%0A++++++++++++++++std::cout+%3C%3C+%22Milieu+foo%22+%3C%3C+i+%3C%3C+%22%5Cn%22%3B%0A++++++++++++++++b.arrive_and_wait()%3B%0A++++++++++++++++std::cout+%3C%3C+%22Sortie+foo%22+%3C%3C+i+%3C%3C+%22%5Cn%22%3B%0A++++++++++++++%7D%3B%0A%0A++std::cout+%3C%3C+%22Demarrage%5Cn%22%3B%0A++std::jthread+t%5Bnb%5D%3B%0A++for(size_t+i+%3D+0%3B+i+%3C+nb%3B+%2B%2Bi)%0A++%7B%0A++++t%5Bi%5D+%3D+std::jthread(work,+i)%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic+-pthread',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P1135")

== Politique d'exécution

- Nouvelle politique d'exécution vectorisé ```cpp std::unsequenced_policy```

#addproposal("P1001")

== ``` std::coroutine``` -- Présentation

- Fonction dont l'exécution peut être suspendue et reprise
- Simplification du développement de code asynchrone
- TS publié en juillet 2017

#addproposal("P0912")

== ``` std::coroutine``` -- Définition

- Fonctions contenant
  - ```cpp co_await``` suspend l'exécution
  - ```cpp co_yield``` suspend l'exécution en retournant une valeur
  - ```cpp co_return``` termine la fonction
- Restrictions
  - Pas de ```cpp return```
  - Pas d'argument _variadic_
  - Pas de déduction de type sur le retour
  - Pas sur les constructeurs, destructeurs, fonctions ```cpp constexpr```

#addproposal("P0912")

== ``` std::coroutine``` -- Mécanismes

- _Promise_ utilisée pour renvoyer valeurs et exceptions
- _Coroutine state_ interne contenant promesse, paramètres, variables locales et état du point de suspension
- _Coroutine handle_ non possédant pour poursuivre ou détruire la coroutine
  - ```cpp operator bool()``` indique si le _handle_ gère effectivement une coroutine
  - ```cpp done()``` indique si la coroutine est suspendue dans son état final
  - ```cpp operator()``` et ```cpp resume()``` poursuit la coroutine
  - ```cpp destroy()``` détruit la coroutine
- Spécialisation de _coroutine handle_ sur une _promise_
  - ```cpp promise()``` accès à la promesse

#addproposal("P0912")

== ``` std::create_directory()```

- Échec de ```cpp std::create_directory()``` si l'élément terminal existe et n'est pas un répertoire

```cpp
create_directory("a/b/c");
// C++17
// Erreur si a ou b existe mais ne sont pas des repertoires
// Pas d'erreur si c existe mais n'est pas un repertoire

// C++20
// Erreur dans les deux cas
```

#addproposal("P1164")

== Constructeur de ``` std::variant```

- Contraintes sur le constructeur et l'opérateur d'affectation de ```cpp std::variant```
  - Pas de conversion en ```cpp bool```
  - Pas de _narrowing conversion_

#addproposal("P0608")

== ``` std::visit()```

- Possibilité d'expliciter le type de retour de ```cpp std::visit()```
  - Via un paramètre template
  - Sinon déduit de l'application du visiteur au premier paramètre

#addproposal("p0655")
