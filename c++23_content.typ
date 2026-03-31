#import "./model.typ": *

= C++23 "_Pandemic Edition_"

== Présentation

- Travaux techniques terminés en février 2023
- Approuvé en octobre 2024
- Dernier _Working Draft_ : #link("https://wg21.link/std23")[n4950 #linklogo()]

== Changements d'organisation du comité

- _ABI Review Group_ : étude des impacts des évolutions sur l'ABI
- _Study Group_ pour la liaison C/C++ (SG22)
- _Study Group_ _safety and security_ (SG23)

== Dépréciations et suppressions

- Suppression des fonctionnalités liées au support d'un GC
- Dépréciation de ```cpp std::aligned_storage``` et ```cpp std::aligned_union```
- Dépréciation de ```cpp std::std::numeric_limits::has_denorm```

#addproposal("p1413")

== Espaces en fin de ligne

- Espaces ignorés après le ```cpp \``` de séparation de ligne

```cpp
// Toujours une chaine vide en C++23
auto str = "\<space>
";
```

// Avant soit une chaîne vide, soit "\ " selon le compilateur

#addproposal("P2223")

== Label

- Label autorisé en fin de bloc
- Reprise d'une évolution C2X

```cpp
void foo(void) {
  int x;
  x = 1;
last:
}
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A+%0Avoid+foo(void)%0A%7B%0A++int+x%3B%0A++x+%3D+1%3B%0Alast:%0A%7D%0A%0Aint+main()%0A%7B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic+-Wno-unused',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P2324")

== Compilation conditionnelle

- Ajout de ```cpp #elifdef``` et ```cpp #elifndef```
- Équivalents à ```cpp #elif defined``` et ```cpp #elif not defined```

```cpp
#ifdef FOO
...
#elifdef BAR
...
#endif
```

- Se combinent avec ```cpp #if``` et ```cpp #elif```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A+%0A//%23define+FOO%0A//%23define+BAR%0A%0Aint+main()%0A%7B%0A%23ifdef+FOO%0A++std::cout+%3C%3C+%22FOO%5Cn%22%3B%0A%23elifdef+BAR%0A++std::cout+%3C%3C+%22BAR%5Cn%22%3B%0A%23else%0A++std::cout+%3C%3C+%22Autre%5Cn%22%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P2334")

== Avertissement

- ```cpp #warning``` génère un avertissement à la compilation

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A+%0Aint+main()%0A%7B%0A%23warning+%22Programme+vide%22%0A%0A%23if+0%0A%23error+%22Programme+vide%22%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P2437")

== Gestion explicite de la durée de vie

- ```cpp std::start_lifetime_as``` et ```cpp std::start_lifetime_as_array``` indiquent qu'un objet est créé mais sans initialisation

```cpp
struct X { int a, b; };

X* p = start_lifetime_as<X>(malloc(sizeof(struct X)));
p->a = 1;
p->b = 2;
```

#addproposal("P2590")
#addproposal("P2679")

== Types flottants étendus

- ```cpp std::float16_t```, ```cpp std::float32_t```, ```cpp std::float64_t```, ```cpp std::float128_t```
  - Types IEEE N-bit
  - Support optionnel
- ```cpp std::bfloat16_t```
  - Type IEEE binary16
  - Support optionnel
- Suffixes littéraux correspondants (```cpp f16```, ```cpp f32```, ```cpp f64```, ```cpp f128``` et ```cpp bf16```)
- Prise en compte par ```cpp std::format```, ```cpp std::ostream``` et ```cpp std::istream```
- Prise en compte par ```cpp std::numeric_limits``` et ```cpp std::is_floating_point```
- Ajout de surcharges dans ```cpp <cmath>```, ```cpp <complex>``` et ```cpp <atomic>```

#alertblock("Types indépendants", text[
  Types indépendants (pas d'alias) de ```cpp float```, ```cpp double``` ou ```cpp long double```
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstdfloat%3E%0A%0Aint+main()%0A%7B%0A++std::float16_t+foo+%3D+2.0f16%3B%0A++std::cout+%3C%3C+sizeof+foo+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P1467")

== Évolutions de ``` char8_t```

- Initialisation d'un tableau de ```cpp char``` ou d'```cpp unsigned char``` depuis une chaîne littérale UTF-8

#addproposal("P2513")

== Relâchement des contraintes de ``` wchar_t```

- Suppression de la contrainte

#noteblock(none, text[
  The values of type ```cpp wchar_t``` can represent distinct codes for all members of the largest extended character set specified among the supported locale
])

- Permet l'utilisation de ```cpp wchar_t``` pour représenter des caractères UTF-16 ou UCS-2 sur des systèmes supportant UTF-8
// Tous les codes points Unicode (21 bits) ne sont pas représentables sur un wchar_t 16 bits

#addproposal("P2460")

== Conversions

- Ajout d'une conversion implicite en booléen
  - Dans les ```cpp static_assert```
  - Dans les ```cpp if constexpr```

```cpp
// Valide en C++23, pas en C++20
if constexpr(flags & 0x01) { ... }
else { ... }
```

```cpp
// Valide en C++23, pas en C++20
template <std::size_t N>
class Foo { static_assert(N, "Message"); };
```

- ```cpp auto(x)``` et ```cpp auto{x}``` convertissent ```cpp x``` en _prvalue_
// C'est une decay-copy (copie faible ?)
// auto a = x construit une lvalue, non une prvalue
// Donc pas de const ni de volatile et les tableaux C deviennent des pointeurs

```cpp
const std::string& str = "hello";
auto(str); // std::string
```

#addproposal("P1401")
#addproposal("p0849")

== Énumérations

- ```cpp std::to_underlying``` convertit une énumération vers le type sous-jacent

```cpp
enum class FOO : uint32_t { A = 0xABCDEF };

auto bar = to_underlying(FOO::A); // uint32_t
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cutility%3E%0A%23include+%3Ccstdint%3E%0A%23include+%3Ctypeinfo%3E%0A%23include+%3Ccassert%3E%0A%0Aenum+class+FOO+:+uint32_t+%0A%7B+%0A++A+%3D+0xABCDEF,%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++auto+bar+%3D+std::to_underlying(FOO::A)%3B%0A%0A++assert(typeid(bar)+%3D%3D+typeid(uint32_t))%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P1682")

== ``` constexpr```

- Relâchement de contrainte sur les fonctions ```cpp constexpr```
  - Code non évalué au _compile-time_
    // Soit la fonction n'est en pratique jamais appelée au compile-time soit la branche contenant ce code n'est exécutée qu'au run-time
    - Variables non littérales
    - Utilisation de ```cpp goto```
    - Retour non littéral
    - Paramètres non littéraux
    - Appel de fonctions non ```cpp constexpr```
  - Code non évalué au _compile-time_ ou utilisable dans un contexte constant
    - Variables ```cpp static``` ou ```cpp thread_local```
  // P.ex. une variable static constexpr
  - Valeur non utilisée
    - Utilisation de pointeurs ou références inconnus
// P.ex. sizeof *ptr
- Conversion implicite de fonctions ```cpp constexpr``` en ```cpp consteval```
// Lorsque la fonction ne peut qu'être invoquée au compile-time
- Davantage de ```cpp constexpr``` dans la bibliothèque standard

#addproposal("P2242")
#addproposal("P2448")
#addproposal("P2647")
#addproposal("p2273")

== ``` if consteval```

- Branche prise en compte si le code est évalué au _compile-time_
- Peut appeler des fonctions immédiate
// P.ex. dans une fonction constexpr
- ```cpp else``` pour le code évalué au _run-time_

```cpp
consteval int foo(int i) { return i; }

constexpr int bar(int i) {
  if consteval { return foo(i) + 1; }
  else { return 42; } }
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aconsteval+int+foo(int+i)%0A%7B%0A++return+i%3B%0A%7D%0A%0Aconstexpr+int+bar(int+i)%0A%7B%0A++if+consteval%0A++%7B%0A++++return+foo(i)+%2B+1%3B%0A++%7D%0A++else%0A++%7B%0A++++return+42%3B%0A++%7D%0A%7D%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+bar(5)+%3C%3C+%22%5Cn%22%3B%0A%0A++constexpr+int+baz+%3D+bar(10)%3B%0A++std::cout+%3C%3C+baz+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P1938")

== ``` if consteval```

- Négation possible

```cpp
if not consteval { ... }

// Ou

if ! consteval { ... }
```

#alertblock("Attention", text[
  Accolades obligatoires, même avec une unique instruction
])

#addproposal("P1938")

== Sémantique de déplacement

- Simplification des règles de déplacement implicite
- ```cpp std::move_only_function``` équivalent _move-only_ de ```cpp std::function```

#addproposal("P2266")
#addproposal("P0288")

== Durée de vie des temporaires

- Extension de la durée de vie des objets temporaires créés dans l'initialisation d'un _range-based for loop_ jusqu'à la fin de la boucle

```cpp
const vector<int>& foo(const vector<int>& t) { return t; }
vector<int> bar( return vector<int>{1, 2, 3}; );

// Valide, duree de vie du retour de bar est etendu
for (auto e : foo(bar())) { ... }
```

#addproposal("P2718")

== init-statement

- ```cpp using``` possible dans l'_init-statement_ de ```cpp if```, ```cpp switch``` et ```cpp for```

```cpp
for(using T = int; T e : v)
{ ... }
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+v%7B1,+2,+5%7D%3B%0A+%0A++for(using+T+%3D+int%3B+T+e+:+v)%0A++%7B%0A++++std::cout+%3C%3C+e+%3C%3C+%22%5Cn%22%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P2360")

== Encodage

- Support des fichiers sources en UTF-8
- Encodage identique entre le préprocesseur et le code C++

#addproposal("P2295")
#addproposal("P2316")


== Suffixes littéraux

- Suffixe ```cpp uz``` pour ```cpp size_t```
- Suffixe ```cpp z``` pour le type entier signé correspondant à ```cpp size_t```
// Typiquement le retour de std::ssize()
// Correspond à ptrdiff_t ou ssize_t

- ```cpp z``` utilisable pour les littéraux binaires, octaux ou hexadécimaux de ```cpp size_t```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ctypeinfo%3E%0A%0Aint+main()%0A%7B%0A++auto+i+%3D+5uz%3B%0A++auto+j+%3D+5z%3B%0A%0A++std::cout+%3C%3C+std::boolalpha%3B%0A++std::cout+%3C%3C+(typeid(i)+%3D%3D+typeid(size_t))+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+(typeid(i)+%3D%3D+typeid(int))+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+(typeid(j)+%3D%3D+typeid(size_t))+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+(typeid(j)+%3D%3D+typeid(ptrdiff_t))+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0330")

== Chaînes littérales

- Plus de concaténation de chaînes littérales adjacentes d'encodage différent

```cpp
L"" u"";   // Invalide
L"" u8"";  // Invalide
L"" U"";   // Invalide
u8"" L"";  // Invalide
u8"" u"";  // Invalide
u8"" U"";  // Invalide
u"" L"";   // Invalide
u"" u8"";  // Invalide
u"" U"";   // Invalide
U"" L"";   // Invalide
U"" u"";   // Invalide
U"" u8"";  // Invalide
```

#noteblock("Et si ?", text[
  Si une des chaînes n'a pas d'encodage, on utilise celui de la seconde
])

#addproposal("P2201")

== Caractères littéraux

- Caractères Unicode conservés durant la phase du préprocesseur

```cpp
#define S(x) #x
// C++23 : "Köppe"
const char* s1 = S(Köppe);
const char* s2 = S(K\u00f6ppe);
```

- Suppression des caractères littéraux non codables ou multi-caractères
- Ajout de séquences d'échappement délimitées
  - ```cpp \u{}``` prenant un nombre arbitraire de chiffres hexadécimaux
  - ```cpp \x{}``` prenant un nombre arbitraire de chiffres hexadécimaux
  - ```cpp \o{}``` prenant un nombre arbitraire de chiffres octaux
- Ajout de séquences d'échappement nommés ```cpp \N{...}```

```cpp
cout << "\N{GREEK SMALL LETTER ETA WITH PSILI}";
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+%22%5CN%7BGREEK+SMALL+LETTER+ETA+WITH+PSILI%7D%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0A%23define+S(x)+%23x%0A%0Aint+main()%0A%7B%0A++const+char*+s1+%3D+S(K%C3%B6ppe)%3B%0A++const+char*+s2+%3D+S(K%5Cu00f6ppe)%3B%0A%0A++std::cout+%3C%3C+s1+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+s2+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P2314")
#addproposal("P2362")
#addproposal("P2290")
#addproposal("P2071")

== Évolutions des opérateurs d'égalité

- Modification des règles de résolution de ```cpp operator==``` et ```cpp operator!=```
- Corrige des ambiguïtés introduites par la réécriture de ```cpp ==``` et ```cpp !=``` en C++20
// En pratique, les compilateurs, notamment GCC, sont plus laxistes que ce qu'impose la norme et accepte silencieusement des cas ambigus
- ```cpp operator==``` est utilisé pour réécrire ```cpp operator!=``` et la forme inverse de ```cpp operator==``` uniquement si ```cpp operator!=``` n'existe pas

```cpp
struct Foo {
  bool operator==(const Foo&) { return true; }
  bool operator!=(const Foo&) { return false; }
};

// Ambigu en C++20
bool b = Foo{} != Foo{};
```

// Ambiguïté provoquée par l'absence de const, l'opérateur défini ne matche pas directement et deux réécritures (via operator== et via operator!=) sont éligibles

#addproposal("P2468")

== ``` operator[]``` multidimensionnel

- Définition de ```cpp operator[]``` avec aucun ou plusieurs arguments
- Y compris des arguments _variadic_

```cpp
T& operator[]();
T& operator[](size_t x, size_t y, size_t z);

foo[3, 2, 1] = 42
```

#addproposal("P2128")

== ``` operator[]``` multidimensionnel

#noteblock("Au-delà de C++23", text[
  - Réécritures
    - De ```cpp a[x][y][z]``` en ```cpp a[x, y, z]```
    - De ```cpp a(x, y, z)``` en ```cpp a[x][y][z]``` (et  ```cpp a(x)``` en ```cpp a[x]```)
    - De ```cpp a[x, y, z]``` en ```cpp a[x][y][z]```
  - Extension aux tableaux C, aux conteneurs standards existants et aux ```cpp operator[]``` non-membres
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Carray%3E%0A%0Atemplate+%3Ctypename+T,+std::size_t+Z,+std::size_t+Y,+std::size_t+X%3E%0Astruct+Array3d%0A%7B%0A++T%26+operator%5B%5D(std::size_t+z,+std::size_t+y,+std::size_t+x)%0A++%7B%0A++++return+foo%5Bz+*+Y+*+X+%2B+y+*+X+%2B+x%5D%3B%0A++%7D%0A%0A++std::array%3CT,+X+*+Y+*+Z%3E+foo%3B%0A%7D%3B%0A+%0Aint+main()%0A%7B%0A++Array3d%3Cint,+4,+3,+2%3E+bar%3B%0A++bar%5B3,+2,+1%5D+%3D+42%3B%0A++std::cout+%3C%3C+bar%5B3,+2,+1%5D+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P2128")

== Opérateurs ``` static```

- Possibilité de déclarer ```cpp static``` des ```cpp operator()```

```cpp
struct Foo {
  static constexpr bool operator()(int i, int j) { return i < j; }
};

static_assert(Foo::operator()(1, 2));
```

- Possibilité de déclarer ```cpp static``` des ```cpp operator[]```

```cpp
struct Foo {
  static int operator[](int i) { return v[i]; }
  static constexpr array<int, 4> v{5, 8, 9, 12};
};

cout << Foo::operator[](2) << "\n";
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Carray%3E%0A%0Astruct+Foo%0A%7B%0A%23if+1%0A++static+int+operator%5B%5D(int+i)%0A%23else%0A++int+operator%5B%5D(int+i)%0A%23endif%0A++%7B%0A++++return+v%5Bi%5D%3B%0A++%7D%0A%0A++static+constexpr+std::array%3Cint,+4%3E+v%7B5,+8,+9,+12%7D%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+Foo::operator%5B%5D(2)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astruct+Foo%0A%7B%0A%23if+1%0A++static+constexpr+bool+operator()(int+i,+int+j)%0A%23else%0A++constexpr+bool+operator()(int+i,+int+j)%0A%23endif%0A++%7B%0A++++return+i+%3C+j%3B%0A++%7D%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++static_assert(Foo::operator()(1,+2))%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P1169")
#addproposal("P2589")

== Évolutions des lambdas

- ```cpp ()``` optionnelles en l'absence de paramètres dans les lambdas mutables
// Optionnelles dans tous les autres cas en C++20 et précédents
- Utilisation du _name lookup_ du corps de la lambda pour son retour

```cpp
// Ne compile pas en C++20 et precedents
auto foo = [j=0]() mutable -> decltype(j) { return j++; };
```

// Auparavant, la résolution de nom du retour ne prenait pas en compte les variables capturées

- Ajout du support d'attributs pour les lambdas

```cpp
[] [[ attr ]] () ->int { return 42; };
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++int+j+%3D+0%3B%0A%0A++auto+foo+%3D+%5B%3D%5D+mutable+%7B+return+%2B%2Bj%3B+%7D%3B%0A++std::cout+%3C%3C+foo()+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P1102")
#addproposal("P2036")
#addproposal("P2173")

== Évolutions des lambdas

- Support des attributs ```cpp [[ nodiscard ]]```, ```cpp [[ deprecated ]]```, ```cpp [[ noreturn ]]```
- Lambdas ```cpp static``` : ```cpp operator()``` de l'objet généré est ```cpp static```

#alertblock("Limites", text[
  ```cpp static``` et ```cpp mutable``` sont mutuellement exclusifs

  Liste de capture vide
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++auto+foo+%3D+%5B%5D+%5B%5B+deprecated+%5D%5D+%7B+return+2%3B+%7D%3B%0A++std::cout+%3C%3C+foo()+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P1102")
#addproposal("P2036")
#addproposal("P2173")

== ``` std::invoke_r()```

- Similaire à ```cpp std::invoke()```
- Retour convertit vers le premier paramètre template
- Ou ignoré si le premier paramètre template est ```cpp void```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cfunctional%3E%0A%0Aint+main()%0A%7B%0A++auto+foo+%3D+%5B%5D+%7B+return+2UL%3B+%7D%3B%0A%0A++auto+i+%3D+foo()%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+(typeid(i)+%3D%3D+typeid(unsigned+long))+%3C%3C+%22%5Cn%22%3B%0A%0A++auto+j+%3D+std::invoke_r%3Cint%3E(foo)%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+(typeid(j)+%3D%3D+typeid(unsigned+long))+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+(typeid(j)+%3D%3D+typeid(int))+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P2136")

== Évolutions des attributs

- Duplication possible d'un attribut dans une liste d'attributs

```cpp
// Valide en C++23, pas en C++20
[[ nodiscard, nodiscard ]]
int foo();
```

#addproposal("P2156")

== Nouveaux attributs

- ```cpp [[ assume(expression) ]]``` permet au compilateur d'optimiser en supposant la véracité de l'expression

#alertblock("Contrainte", text[
  Expression doit être vraie à l'emplacement de ```cpp assume```
  // UB dans le cas contraire
])

#addproposal("P1774")

== Layout

- Suppression de la possibilité donnée aux compilateurs de réordonner les données d'accessibilité différente

#addproposal("P1847")

== Paramètre ``` this``` explicite / deducing ``` this```

- Limitation ses surcharges ```cpp const``` / non ```cpp const``` de fonctions membres
- Utilisation d'un premier paramètre, préfixé ```cpp this```, notant l'instance de classe

```cpp
struct Foo {
  void bar(this Foo const&);
}
```

#alertblock("Restrictions", text[
  Ne peuvent pas être ```cpp virtual``` ni ```cpp static```

  Ne peuvent pas avoir de _cv-qualifier_ ni de _ref-qualifier_
])

#addproposal("P0847")

== Paramètre ``` this``` explicite / deducing ``` this```

- Utilisation des règles classiques de déduction de types

```cpp
struct Foo {
  template <typename Self>
  void bar(this Self&&, int);
};

void ex(Foo& foo, D& d) {
  foo.bar(1);       // Self=Foo&
  move(foo).bar(2); // Self=Foo
}
```

#addproposal("P0847")

== Paramètre ``` this``` explicite / deducing ``` this```

- Permet le passage de ```cpp this``` par valeur

```cpp
struct Foo {
  void bar()(this Foo, int i);
};

Foo{}(4);
```

#addproposal("P0847")

== Déduction dans les constructeurs hérités

- Déduction des paramètres templates d'un constructeur hérité

```cpp
template <typename T> struct A {
  A(T);
};
template <typename T> struct B : public A<T> {
  using A<T>::A;
};

B b(42);   // OK B<int>
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Atemplate+%3Ctypename+T%3E+struct+A%0A%7B%0A++A(T)+%7B%7D%0A%7D%3B%0A%0Atemplate+%3Ctypename+T%3E+struct+B+:+public+A%3CT%3E%0A%7B%0A++using+A%3CT%3E::A%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++B+b(42)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P2582")

== ``` noexcept```

- Ajout de ```cpp noexcept``` à plusieurs fonctions de la bibliothèque standard

== Traits

- ```cpp std::is_scoped_enum``` indique si un type est un ```cpp enum class```

```cpp
class A {};
enum E {};
enum struct Es {};
enum class Ec : int {};

is_scoped_enum_v<A>;    // Faux
is_scoped_enum_v<E>;    // Faux
is_scoped_enum_v<Es>;   // Vrai
is_scoped_enum_v<Ec>;   // Vrai
is_scoped_enum_v<int>;  // Faux
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ctype_traits%3E%0A%0Aclass+A%0A%7B%0A%7D%3B%0A%0Aenum+E%0A%7B%0A%7D%3B%0A%0Aenum+struct+Es+%0A%7B%0A%7D%3B%0A%0Aenum+class+Ec+:+int+%0A%7B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::boolalpha%3B%0A++std::cout+%3C%3C+std::is_scoped_enum_v%3CA%3E+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::is_scoped_enum_v%3CE%3E+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::is_scoped_enum_v%3CEs%3E+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::is_scoped_enum_v%3CEc%3E+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::is_scoped_enum_v%3Cint%3E+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P1048")

== Traits

- ```cpp std::is_implicit_lifetime``` indique si un objet à une durée de vie implicite
- ```cpp std::reference_constructs_from_temporary``` et ```cpp std::reference_converts_from_temporary``` indiquent si la référence est construite depuis un temporaire

#addproposal("P2674")
#addproposal("P2255")

== Chaînes de caractères

- ```cpp contains()``` teste la présence d'une sous-chaîne dans une chaîne ou une vue

```cpp
string foo = "Hello world";
foo.contains("Hello");   // true
foo.contains("monde");   // false

string_view bar = foo;
bar.contains("Hello");   // true
bar.contains("monde");   // false
```

- Interdiction de la construction de ```cpp std::string``` depuis ```cpp nullptr```
// Erreur de compilation, avant c'était un comportement indéfini
- Construction de ```cpp std::string_view``` depuis un range
- Ajout de la contrainte trivialement copiable à ```cpp std::string_view```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%23include+%3Cstring_view%3E%0A%0Aint+main()%0A%7B%0A++const+std::string+foo+%3D+%22Hello+world%22%3B%0A++std::cout+%3C%3C+std::boolalpha%3B%0A++std::cout+%3C%3C+foo.contains(%22Hello%22)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+foo.contains(%22monde%22)+%3C%3C+%22%5Cn%22%3B%0A%0A++std::string_view+bar+%3D+foo%3B%0A++std::cout+%3C%3C+bar.contains(%22Hello%22)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+bar.contains(%22monde%22)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P1679")
#addproposal("P2166")
#addproposal("P1989")
#addproposal("P2251")

== Chaînes de caractères

- ```cpp resize_and_overwrite()``` redimensionne et met à jour une chaîne
  - Allocation d'un tableau de ```cpp count + 1``` caractères
  - Copie du contenu de la chaîne dans ce tableau
  - Appel à la fonction pour valoriser les caractères et déterminer la taille finale
  - Mise à jour du contenu de la chaîne avec celui du tableau

```cpp
string foo = "Hello ", bar = "world!";

foo.resize_and_overwrite(20,
  [sz = foo.size(), bar] (char* buf, size_t buf_size) {
    auto to_copy = min(buf_size - sz, bar.size());
    memcpy(buf + sz, bar.data(), to_copy);
    return sz + to_copy; });   // Hello world!
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%23include+%3Calgorithm%3E%0A%23include+%3Ccstring%3E%0A%0Aint+main()%0A%7B%0A++std::string+foo+%3D+%22Hello+%22%3B%0A++std::string+bar+%3D+%22world!!%22%3B%0A%0A++foo.resize_and_overwrite(20,+%0A++++++++++++++++++++++++++%5Bsz+%3D+foo.size(),+bar%5D+(char*+buf,+size_t+buf_size)+%0A++++++++++++++++++++++++++%7B%0A++++++++++++++++++++++++++++auto+to_copy+%3D+std::min(buf_size+-+sz,+bar.size())%3B%0A++++++++++++++++++++++++++++memcpy(buf+%2B+sz,+bar.data(),+to_copy)%3B%0A++++++++++++++++++++++++++++return+sz+%2B+to_copy%3B+%7D)%3B%0A%0A++std::cout+%3C%3C+foo++%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P1072")

== ``` std::span```

- Ajout de la contrainte trivialement copiable

#addproposal("P2251")

== ``` std::pair``` et ``` std::tuple```

- Construction de ```cpp std::pair``` depuis un _braced initializers_
// Code auparavant valide mais inefficace

```cpp
pair<string, vector<string>> foo("hello", {});
```

- Construction de ```cpp std::tuple``` et ```cpp std::pair``` depuis un _tuple-like_

```cpp
pair<int, double> foo = tuple{1, 3.0};
tuple<int, int> bar = array{1, 3};
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cutility%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cstring%3E%0A%0Aint+main()%0A%7B%0A++std::pair%3Cstd::string,+std::vector%3Cstd::string%3E%3E+foo(%22hello%22,+%7B%7D)%3B%0A++std::cout+%3C%3C+foo.first+%3C%3C+%22+%22+%3C%3C+std::size(foo.second)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P1951")
#addproposal("P2165")

== ``` std::stack``` et ``` std::queue```

- Création de ```cpp std::stack``` et ```cpp std::queue``` depuis une paire d'itérateurs

```cpp
vector<int> v{1, 3, 7, 13};
queue q(begin(v), end(v));
stack s(begin(v), end(v));
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cqueue%3E%0A%23include+%3Cstack%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+v%7B1,+3,+7,+13%7D%3B%0A%0A++std::queue+q(std::begin(v),+std::end(v))%3B%0A++std::stack+s(std::begin(v),+std::end(v))%3B%0A%0A++std::cout+%3C%3C+q.front()+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+s.top()+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P1425")

== Conteneurs associatifs

- Surcharge de ```cpp erase()``` et ```cpp extract()``` ne créant pas de clés temporaires
- Adaptateurs associatifs de conteneurs
  - ```cpp std::flat_map``` et ```cpp std::flat_multimap```
  - ```cpp std::flat_set``` et ```cpp std::flat_multiset```
    - Adapte un conteneur séquentiel pour présenter une API de conteneur associatif
    - Davantage _cache-friendly_
    - Clés et valeurs stockées dans deux conteneurs différents

#addproposal("P2077")
#addproposal("P0429")
#addproposal("P1222")

== ``` std::mdspan```

- Vues multidimensionnelles
- Possibilité de fournir un _layout_ configurable
- Trois _memory layouts_ standards
  - ```cpp layout_right``` : _layout_ du C et du C++, lignes puis colonnes
  - ```cpp layout_left``` : _layout_ de Fortran ou Matlab, colonnes puis lignes
  - ```cpp layout_stride```
- Accès à un élément via ```cpp operator[]``` multi-paramètres (```cpp [x,y,z]```)

#addproposal("P0009")
#addproposal("P2599")
#addproposal("P2604")
#addproposal("P2613")
#addproposal("P2763")

== Évolutions des itérateurs

- Corrections de ```cpp iterator_category``` et ```cpp counted_iterator```
- ```cpp std::move_iterator<T*>``` doit être un _random access iterator_
- Modification des exigences sur les itérateurs des algorithmes "non ranges" pour permettre l'utilisation de vues

#addproposal("P2259")
#addproposal("P2278")
#addproposal("P2408")
#addproposal("P2520")

== ``` std::byteswap()```

- Inverse les octets d'un entier

```cpp
uint16_t i = 0xCAFE;
byteswap(i);   // 0xFECA

uint32_t j = 0xDEADBEEFu;
byteswap(j);   // 0xEFBEADDE
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ccstdint%3E%0A%23include+%3Cbit%3E%0A%0Aint+main()%0A%7B%0A++uint16_t+i+%3D+0xCAFE%3B%0A++std::cout+%3C%3C+std::hex+%3C%3C+std::byteswap(i)+%3C%3C+%22%5Cn%22%3B%0A%0A++uint32_t+j+%3D+0xDEADBEEFu%3B%0A++std::cout+%3C%3C+std::hex+%3C%3C+std::byteswap(j)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P1272")

== Évolutions des flux

- ```cpp spanstream``` remplaçant de ```cpp strstream``` utilisant un ```cpp std::span``` comme buffer
- Support du mode exclusif à ```cpp std::fstream```

#addproposal("P0448")
#addproposal("P2467")

== Évolutions de ``` std::format```

- Ajout du concept ```cpp formatable```
- Vérification des chaînes de format au _compile-time_
- Ajout du type ```cpp ?``` pour afficher les chaînes échappées
- Formateur de ```cpp std::chrono``` _locale-independent_ par défaut

```cpp
format("{:%S}", 4s + 200ms);   // C++20 : 04,200 / C++23 : 04.200
format("{:L%S}", 4s + 200ms);  // C++20 : exception / C++23 : 04,200
```

#addproposal("p2216")
#addproposal("P2572")
#addproposal("P2419")
#addproposal("P2372")
#addproposal("p2585")

== Évolutions de ``` std::format```

- Formatage des types ```cpp std::generator```_-like_
- Formatage des ```cpp std::pair``` et ```cpp std::tuple```
- Formatage de ```cpp std::vector<bool>::reference```
- Formatage des ranges et des conteneurs :
  - ```cpp std::map``` et équivalent : ```cpp {k1: v1, k2: v2}```
  - ```cpp std::set``` et équivalent : ```cpp {v1, v2}```
  - ```cpp std::vector```, ```cpp std::list```, ... : ```cpp [v1, v2]```
- Formatage des ```cpp std::thread::id```
- Formatage des ```cpp std::stacktrace```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%23include+%3Cthread%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7B%7D%22,+std::this_thread::get_id())+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B%7D%22,+std::thread::id%7B%7D)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:clang1701,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic+-stdlib%3Dlibc%2B%2B',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+clang+17.0.1+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cmap%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7B%7D%22,+std::vector%3Cint%3E%7B5,+56%7D)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B::%23x%7D%22,+std::vector%3Cint%3E%7B5,+56%7D)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B%7D%22,+std::map%3Cint,+int%3E%7B%7B1,+5%7D,+%7B8,+56%7D%7D)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:clang1701,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic+-stdlib%3Dlibc%2B%2B',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+clang+17.0.1+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%23include+%3Ctuple%3E%0A%23include+%3Cstring%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7B%7D%22,+std::tuple%3Cint,+long,+std::string%3E%7B5,+56L,+%22foo%22%7D)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:clang1701,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic+-stdlib%3Dlibc%2B%2B',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+clang+17.0.1+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P2418")
#addproposal("P2286")
#addproposal("P2693")

== ``` std::print```

- ```cpp std::print()``` écrit directement dans ```cpp std::cout```

```cpp
cout << format("Hello, {}!", name);

// Devient

print("Hello, {}!", name);
```

- ```cpp std::println()``` ajoute en outre un saut de ligne

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cprint%3E%0A%0Aint+main()%0A%7B%0A++std::print(%22Hello,+%7B%7D!!%22,+%22foo%22)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:clang1701,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic+-stdlib%3Dlibc%2B%2B',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+clang+17.0.1+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P2093")
#addproposal("P2539")

== ``` std::out_ptr``` et ``` std::inout_ptr```

- Abstractions entre _smart pointers_ et API C modifiant un pointeur
  - Création d'un pointeur de pointeur temporaire depuis le _smart pointer_
  - Automatisation des appels à ```cpp reset()``` et ```cpp release()```
  - _Exception-safe_ : _smart pointer_ rétabli au retour de l'API C
  // Pas d'exception dans le code C++ avant le rétablissement du smart pointer
  - Permet le passage comme pointeur C ```cpp void*``` ou ```cpp void**```
  - Permet la conversion vers un type de pointeur arbitraire
- ```cpp std::out_ptr``` permet la modification de l'adresse contenu dans le _smart pointer_ sans l'utiliser
- ```cpp std::inout_ptr``` permet la modification et l'utilisation de l'adresse contenu dans le _smart pointer_

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ccstdlib%3E%0A%23include+%3Cmemory%3E%0A%0Avoid+alloc(int**+ptr)%0A%7B%0A++*ptr+%3D+static_cast%3Cint*%3E(malloc(5+*+sizeof(int)))%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::unique_ptr%3Cint,+void+(*)(void*)%3E+foo(0,+free)%3B%0A++std::cout+%3C%3C+foo.get()+%3C%3C+%22%5Cn%22%3B%0A++alloc(std::out_ptr(foo))%3B%0A++std::cout+%3C%3C+foo.get()+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P1132")

== Bibliothèque de Stacktrace

- Basée sur ```cpp Boost.stacktrace```
- ```cpp current()``` récupère la _stacktrace_ courante
- Manipulation d'une _stacktrace_
  - ```cpp empty()``` teste la présente d'entrée
  - ```cpp size()``` retourne le nombre d'entrée de la _stacktrace_
  - ```cpp begin()```, ```cpp end()```, ... retournent les itérateurs sur les entrées
  - ```cpp operator[]``` accède à une entrée donnée
  - ```cpp to_string()``` retourne la description de la _stacktrace_
  - ```cpp operator<<``` affiche la _stacktrace_

#addproposal("P0881")
#addproposal("P2301")

== Bibliothèque de Stacktrace

- Manipulation des entrées de la _stacktrace_
  - ```cpp description()``` retourne la description de l'entrée
  - ```cpp source_file()``` retourne le nom de la fonction
  - ```cpp source_line()``` retourne la ligne

```cpp
auto trace = stacktrace::current();
for(const auto& entry: trace) {
  cout << "Description: " << entry.description() << "\n";
  cout << "file: " << entry.source_file() << "\n";
  cout << "line: " << entry.source_line() << "\n";
  cout << "------------------------------------" << "\n";
}
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Cstacktrace%3E%0A%23include+%3Ciostream%3E%0A%0Avoid+foo()%0A%7B%0A++auto+trace+%3D+std::stacktrace::current()%3B%0A++for+(const+auto%26+entry:+trace)%0A++%7B%0A++++std::cout+%3C%3C+%22Description:+%22+%3C%3C+entry.description()+%3C%3C+%22%5Cn%22%3B%0A++++std::cout+%3C%3C+%22file:+%22+%3C%3C+entry.source_file()+%3C%3C+%22%5Cn%22%3B%0A++++std::cout+%3C%3C+%22line:+%22+%3C%3C+entry.source_line()+%3C%3C+%22%5Cn%22%3B%0A++++std::cout+%3C%3C+%22------------------------------------%22+%3C%3C+%22%5Cn%22%3B%0A++%7D%0A%7D%0A%0Aint+main()%0A%7B%0A++foo()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic+-lstdc%2B%2Bexp',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0881")
#addproposal("P2301")

== ``` std::unreachable()```

- ```cpp std::unreachable()``` indique que la localisation n'est pas atteignable
- Permet d'optimiser en supposant que le code ne sera pas atteint
- Comportement indéfini si ```cpp std::unreachable()``` est appelé

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cutility%3E%0A%0Aint+main()%0A%7B%0A++int+i+%3D+1%3B%0A%0A++if(i+%3E+0)%0A++%7B%0A++++std::cout+%3C%3C+%22OK%5Cn%22%3B%0A++%7D%0A++else%0A++%7B%0A++++std::unreachable()%3B%0A++++std::cout+%3C%3C+%22Unreachable%5Cn%22%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0627")

== Atomiques

- Support des ```cpp atomics``` C

#addproposal("P0943")

== ``` time_point::clock```

- Relâchement des contraintes sur ```cpp time_point::clock```
  - Plus grande flexibilité du type d'horloge
  - Horloges _stateful_, horloges externes
  - Représentation d'un _time of day_ par un ```cpp time_point``` particulier

#addproposal("P2212")

== ``` std::variant```

- Héritage possible de ```cpp std::variant```
- ```cpp std::visit()``` restreints aux ```cpp std::variant```

#addproposal("P2162")

== Opérations monadiques de ``` std::optional```

- ```cpp transform()``` modifie la valeur contenu dans un ```cpp std::optional```
  // Peut modifier aussi éventuellement le type}
  - Retourne un ```cpp std::optional``` vide s'il n'y a pas de valeur stockée
  - Retourne le résultat de la fonction sinon

```cpp
optional<string> foo = "Abcdef", bar;

foo.transform([](auto&& s) { return s.size(); });  // 6
bar.transform([](auto&& s) { return s.size(); });  // Vide
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Coptional%3E%0A%23include+%3Cstring%3E%0A%0Aint+main()%0A%7B%0A++std::optional%3Cstd::string%3E+foo+%3D+%22Abcdef%22%3B%0A++std::optional%3Cstd::string%3E+bar%3B%0A%0A++auto+baz+%3D+foo.transform(%5B%5D(auto%26%26+s)+%7B+return+s.size()%3B+%7D)%3B%0A++if(baz)%0A++%7B%0A++++std::cout+%3C%3C+*baz+%3C%3C+%22%5Cn%22%3B%0A++%7D%0A++else%0A++%7B%0A++++std::cout+%3C%3C+%22Vide%5Cn%22%3B%0A++%7D%0A%0A++baz+%3D+bar.transform(%5B%5D(auto%26%26+s)+%7B+return+s.size()%3B+%7D)%3B%0A++if(baz)%0A++%7B%0A++++std::cout+%3C%3C+*baz+%3C%3C+%22%5Cn%22%3B%0A++%7D%0A++else%0A++%7B%0A++++std::cout+%3C%3C+%22Vide%5Cn%22%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0798")

== Opérations monadiques de ``` std::optional```

- ```cpp and_then()``` dérive une fonction pour retourner un ```cpp std::optional```

```cpp
auto func = [] (int i) -> optional<int> { return 2 * i; };
optional<int> foo = 42, bar;

foo.and_then(func);  // 84
bar.and_then(func);  // Vide
```

#alertblock("Retour de fonction", text[
  Le retour de la fonction doit être une spécialisation de ```cpp std::optional```
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Coptional%3E%0A%0Aint+main()%0A%7B%0A++auto+func+%3D+%5B%5D+(int+i)+-%3E+std::optional%3Cint%3E+%7B+return+2+*+i%3B+%7D%3B%0A++std::optional%3Cint%3E+foo+%3D+42%3B%0A++std::optional%3Cint%3E+bar%3B%0A%0A++auto+baz+%3D+foo.and_then(func)%3B%0A++if(baz)%0A++%7B%0A++++std::cout+%3C%3C+*baz+%3C%3C+%22%5Cn%22%3B%0A++%7D%0A++else%0A++%7B%0A++++std::cout+%3C%3C+%22Vide%5Cn%22%3B%0A++%7D%0A%0A++baz+%3D+bar.and_then(func)%3B%0A++if(baz)%0A++%7B%0A++++std::cout+%3C%3C+*baz+%3C%3C+%22%5Cn%22%3B%0A++%7D%0A++else%0A++%7B%0A++++std::cout+%3C%3C+%22Vide%5Cn%22%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0798")

== Opérations monadiques de ``` std::optional```

- ```cpp or_else()```
  - Retourne le ```cpp std::optional``` s'il a une valeur
  - Appelle une fonction sinon

```cpp
auto func = [] -> optional<string> { return "Oups!"; };

optional<string> foo = "Abcdef", bar;

foo.or_else(func);  // Abcdef
bar.or_else(func);  // Oups!
```

#alertblock("Retour de fonction", text[
  Le retour de la fonction doit être une spécialisation de ```cpp std::optional```
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Coptional%3E%0A%0Aint+main()%0A%7B%0A++auto+func+%3D+%5B%5D+-%3E+std::optional%3Cstd::string%3E+%7B+return+%22Oups!!%22%3B+%7D%3B%0A++std::optional%3Cstd::string%3E+foo+%3D+%22Abcdef%22%3B%0A++std::optional%3Cstd::string%3E+bar%3B%0A%0A++std::cout+%3C%3C+*foo.or_else(func)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+*bar.or_else(func)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0798")


== ``` std::expected```

- Classe ```cpp std::expected<T, E>``` contenant
  - Soit une valeur de type ```cpp T```
  - Soit une erreur de type ```cpp E```
- ```cpp operator bool()``` et ```cpp has_value()``` indiquent si l'objet contient une valeur
- ```cpp operator->``` et ```cpp operator*``` accèdent à la valeur
- ```cpp value()``` retourne la valeur
- ```cpp error()``` retourne l'erreur

```cpp
expected<int, string> e = foo(5);
if(e)
  cout << e.value();
else
  cout << e.error();
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cexpected%3E%0A%23include+%3Cstring%3E%0A%0Astd::expected%3Cint,+std::string%3E+foo(int+i)%0A%7B%0A++if(i+%3E+0)%0A++%7B%0A++++return+i%3B%0A++%7D%0A++else%0A++%7B%0A++++return+std::unexpected%7B%22Nul%22%7D%3B%0A++%7D%0A%7D%0A%0Aint+main()%0A%7B%0A++std::expected%3Cint,+std::string%3E+e+%3D+foo(5)%3B%0A%0A++if(e)%0A++%7B%0A++++std::cout+%3C%3C+%22Val+:+%22+%3C%3C+e.value()+%3C%3C+%22%5Cn%22%3B%0A++%7D%0A++else%0A++%7B%0A++++std::cout+%3C%3C+%22Erreur+:+%22+%3C%3C+e.error()+%3C%3C+%22%5Cn%22%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0323")
#addproposal("P2549")

== ``` std::expected```

- ```cpp value_or()``` retourne
  - La valeur si présente
  - La valeur reçue en paramètre sinon
- ```cpp transform()``` modifie la valeur contenu dans un ```cpp std::expected```
- ```cpp and_then()``` dérive une fonction pour retourner un ```cpp std::expected```
- ```cpp or_else()```
  - Retourne la valeur si elle est présente
  - Appelle une fonction avec l'erreur sinon

#alertblock("Retour de fonction", text[
  Le retour de   ```cpp and_then()``` et ```cpp or_else()``` doit être  ```cpp std::expected```
])

#codesample(
  "https://godbolt.org/#z:OYLghAFBqd5QCxAYwPYBMCmBRdBLAF1QCcAaPECAMzwBtMA7AQwFtMQByARg9KtQYEAysib0QXACx8BBAKoBnTAAUAHpwAMvAFYTStJg1DIApACYAQuYukl9ZATwDKjdAGFUtAK4sGe1wAyeAyYAHI%2BAEaYxHoADqgKhE4MHt6%2BcQlJAkEh4SxRMVy2mPaOAkIETMQEqT5%2BRXaYDskVVQQ5YZHRegqV1bXpDX3twZ353VwAlLaoXsTI7BzmAMzByN5YANQmy25OvcSYrDvYJhoAgitrG5jbu5iqsU0EmOgnZ5dmqwzrXls7bgOwWA7wuH166BAIAeTwcrwBwQIpE2EKhQKMJ02/FQEERmzwkw%2BJgA7FYLpt8VRcXdsJsNITydtSR8KRTDgQ5gx8TsyecKSSACIszYlJTCkm81mbdmclEESEgLwhR7PeHMsxmcK0cxmQU88XEoVgw1Ei54lhMYIQBmXZmMpheIhYpXIO4C7YAVisHvdEDQDF6coV6JBZgAbCLiMQSJNNgBaTGo6EquFvXaI5FJkOY4VSvOsiVBqFoR13NwA7YagDyXliCjAYErZjLFei0eILd2TZMHrcDB1PO2jPzI%2BlmA5xC5ca4g71y0lReTsJeab2gkz8rRBGIwMxtx27uxEA9hPnwqTMNVq4zi%2Bzy1pmGbB5FADoSAB9UWYagu0%2B84V4FSj42lKSYlgQnZuE2ABqYibCATaQSKZgvgAbmIXjfrGAIVgOvb9hq%2BqMl%2BuaLuBSE6tgUaYHM8GIThXaPi%2BbYkNaFGEfhA5nsaRrnBw0y0JwHq8H4HBaKQqCcOWljWCiszzPuXw8KQBCaPx0wANYgB6Gj6JwkgiWpEmcLwCggLpqlifxpBwLASAPE0jokOQlBVMACjKIYJRCAgqAAO6icpaAsLEdBMGUDCeSEtA%2Bf5onicFoX0DE7nMHWvlIoldDRKErCLLwWXJTWwi%2BQFRkOcg5zEO5JmkBVFT4KJvD8IIIhiOwUgyIIigqOoVmkLoRQGEYKDWNY%2Bh4BEZmQNMqCxBFZkcHGEIHqYMmWF88YAOpiLQ20PNuTDxk86CGI4yC8KgqFtngWDTdapDEEqjhsAAKqgnj3dMCjyQsPTysEUXeaVgW8H5xBMLEnA8AJQmGf1kkcNgqiOUQHaqAAHGGcZhpImzAMgroQNuSoabGEDSVYljIrghAkJWyxTLwllaJM0wIEcWAxA9Wk6XpHAGaQ8WXbVZkWWpbP82Y8PiYjzMS9M13EIkziSEAA",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cexpected%3E%0A%23include+%3Cstring%3E%0A%0Astd::expected%3Cint,+std::string%3E+foo(int+i)%0A%7B%0A++if(i+%3E+0)%0A++%7B%0A++++return+i%3B%0A++%7D%0A++else%0A++%7B%0A++++return+std::unexpected%7B%22Nul%22%7D%3B%0A++%7D%0A%7D%0A%0Aint+main()%0A%7B%0A++auto+func+%3D+%5B%5D+(int+i)+-%3E+std::expected%3Cint,+std::string%3E+%0A++++++++++++++%7B+return+2+*+i%3B+%7D%3B%0A++std::expected%3Cint,+std::string%3E+e+%3D+foo(5)%3B%0A++std::expected%3Cint,+std::string%3E+e2+%3D+e.and_then(func)%3B%0A%0A++if(e2)%0A++%7B%0A++++std::cout+%3C%3C+%22Val+:+%22+%3C%3C+e2.value()+%3C%3C+%22%5Cn%22%3B%0A++%7D%0A++else%0A++%7B%0A++++std::cout+%3C%3C+%22Erreur+:+%22+%3C%3C+e2.error()+%3C%3C+%22%5Cn%22%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cexpected%3E%0A%23include+%3Cstring%3E%0A%0Astd::expected%3Cint,+std::string%3E+foo(int+i)%0A%7B%0A++if(i+%3E+0)%0A++%7B%0A++++return+i%3B%0A++%7D%0A++else%0A++%7B%0A++++return+std::unexpected%7B%22Nul%22%7D%3B%0A++%7D%0A%7D%0A%0Aint+main()%0A%7B%0A++std::expected%3Cint,+std::string%3E+e+%3D+foo(5)%3B%0A++std::expected%3Cint,+std::string%3E+e2+%3D+e.transform(%5B%5D+(int+i)+%7B+return+2+*+i%3B+%7D)%3B%0A%0A++if(e2)%0A++%7B%0A++++std::cout+%3C%3C+%22Val+:+%22+%3C%3C+e2.value()+%3C%3C+%22%5Cn%22%3B%0A++%7D%0A++else%0A++%7B%0A++++std::cout+%3C%3C+%22Erreur+:+%22+%3C%3C+e2.error()+%3C%3C+%22%5Cn%22%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cexpected%3E%0A%23include+%3Cstring%3E%0A%0Astd::expected%3Cint,+std::string%3E+foo(int+i)%0A%7B%0A++if(i+%3E+0)%0A++%7B%0A++++return+i%3B%0A++%7D%0A++else%0A++%7B%0A++++return+std::unexpected%7B%22Nul%22%7D%3B%0A++%7D%0A%7D%0A%0Aint+main()%0A%7B%0A++++std::expected%3Cint,+std::string%3E+e+%3D+foo(5)%3B%0A++++std::cout+%3C%3C+%22Val+:+%22+%3C%3C+e.value_or(-1)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P2505")

== ``` std::expected```

- ```cpp error_or()``` retourne
  - L'erreur si la valeur n'est pas présente
  - Le paramètre sinon
- ```cpp transform_error()```
  - Retourne la valeur si elle est présente
  - Appelle une fonction avec l'erreur sinon

#codesample(
  "https://godbolt.org/#z:OYLghAFBqd5QCxAYwPYBMCmBRdBLAF1QCcAaPECAMzwBtMA7AQwFtMQByARg9KtQYEAysib0QXACx8BBAKoBnTAAUAHpwAMvAFYTStJg1DIApACYAQuYukl9ZATwDKjdAGFUtAK4sGe1wAyeAyYAHI%2BAEaYxHoADqgKhE4MHt6%2BcQlJAkEh4SxRMVy2mPaOAkIETMQEqT5%2BRXaYDskVVQQ5YZHRegqV1bXpDX3twZ353VwAlLaoXsTI7BzmAMzByN5YANQmy25OvcSYrDvYJhoAgitrG5jbu5iqsU0EmOgnZ5dmqwzrXls7bgOwWA7wuVx%2BNzubmQQKMoM%2B31%2B/12YmAJEICBY8PBSNuAMI0SYRGI2IuvXQIBADyeDle%2BMEpE25MpsJBy2wm34qAgwQImzwkw%2BJgA7FYLpt%2BVQeXcORpBeLtqKPhKJYcCHMGPydmLzhKRQARZWbEpKI0inUqzZqjVMggUkBeEKPZ50pVmMzhWjmMwG7Vm4WGsEBoUXXmbFhMYIQeWXJUKpheIicx3IO767YAVisGfTEDQDF6tvtrPMADYmZNtgrLTWVeaq7ra02JcyQKzNrMCH7q82a62CMRDAp%2BMQWBBW1FgFGFNMi5TXOPZxOmMgANYAfWCSmq0QgndnRt7R6PJizp/1EEdiWAIXQm2QCCq98FoqtmHVxE1/dmsSexDzgrLBYirpoBFrHpa1qfh2ibdo2EG%2BkBIaNq21Ium8uy8oyrYluyxpppyqDchmYFGqhzq0hhewMnObYDsCJzGmYBGYAAdAOQ4jiw67RMQJDUCmpFggqeBSpgZgxnqcbwbRaCJlCALbO6ABqYibCASnMQCiniaxABuYheJg0YKbsmmnm4DDenBUmBo2JqYP64EtnalJyXy2lmd62DEIcczqZppluExrG8fxlaecF1kZpZ1lIQqvpBnZHDTLQnAZrwfgcFopCoJwbjWNYTKzPMeJfDwpAEJoKXTKuIAZho%2BicJImXVblnC8AoICNVV2UpaQcCwEgDxNImJDkJQVTAAoyiGCUQgIKgADuWUVWgLCxHQRLJLNIS0Aty1ZTl62bfQMTTcwsQKItBCkCddDRKErCLLw91nQA8omB0rW1I3IOcxDTR1pB/RU%2BBZbw/CCCIYjsFIMiCIoKjqH1pC6EUBhGCghWWPoeARF1kDTKgsRlAWnAALTkjs%2BqmJY1hfJsFMAOpiLQTPMw8HFM086CGI4yC8Kgem8XgWCE9GpDEI6jhsAAKkRtAS9MCglQsPR2sEu3zYtP3cLwS2DrEnA8Kl6WtajeUcNgqijcSmyqAAHKWFOlpImzAMgqYQAOjqrpWEAFfTuObLghAkEpyxTLwvVaJM0wIEcWAxJLdUNU1HAtaQR1C8DXU9dV8cZ2YFs5VbMeF9MIvEIkziSEAA",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cexpected%3E%0A%23include+%3Cstring%3E%0A%0Astd::expected%3Cint,+std::string%3E+foo(int+i)%0A%7B%0A++if(i+%3E+0)%0A++%7B%0A++++return+i%3B%0A++%7D%0A++else%0A++%7B%0A++++return+std::unexpected%7B%22Nul%22%7D%3B%0A++%7D%0A%7D%0A%0Aint+main()%0A%7B%0A++std::expected%3Cint,+std::string%3E+e+%3D+foo(5)%3B%0A++std::cout+%3C%3C+e.error_or(%22Oups%22)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P2505")

== ``` std::unexpected```

- Classe template ```cpp std::unexpected<E>``` contenant une erreur
- ```cpp error()``` retourne l'erreur
- Permet de construire un ```cpp std::expected``` indiquant une erreur

```cpp
expected<double, int> foo = unexpected(3);

// Vrai
if (!foo) { ... }

// Vrai
if (foo == unexpected(3)) { ... }
```
#addproposal("P0323")
#addproposal("P2549")

== Évolutions des ranges et vues

- Ajout de ```cpp starts_with()``` et ```cpp ends_with()``` aux ranges
- Ajout de ```cpp contains()``` aux ranges

```cpp
auto foo = views::iota(0, 50);
auto bar = views::iota(0, 30);

ranges::starts_with(foo, bar); // Vrai
ranges::contains(foo, 4);      // Vrai
ranges::contains(foo, 70);     // Faux
```

- Relâchement des contraintes sur les _range adaptors_ pour accepter les types _move-only_
- Relâchement des contraintes sur ```cpp join_view``` permettant le support de davantage de ranges
// Avant seulement des ranges de glvalues ranges (vues ou non) et des ranges de prvalues views
// Maintenant aussi des ranges de prvalues non view ranges

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:8,positionColumn:1,positionLineNumber:8,selectionStartColumn:1,selectionStartLineNumber:8,startColumn:1,startLineNumber:8),source:'%23include+%3Ciostream%3E%0A%23include+%3Calgorithm%3E%0A%23include+%3Cranges%3E%0A%0Aint+main()%0A%7B%0A++auto+foo+%3D+std::ranges::views::iota(0,+50)%3B%0A%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::ranges::contains(foo,+4)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::ranges::contains(foo,+70)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P2278")

== Évolutions des ranges et vues

- Suppression de la contrainte _default constructible_ pour les vues
- ```cpp std::ranges::to<>()``` construit un conteneur depuis une vue

```cpp
auto v = views::iota('a') ``` views::take(10);
auto vec = v ``` ranges::to<vector>();
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:16,positionColumn:1,positionLineNumber:16,selectionStartColumn:1,selectionStartLineNumber:16,startColumn:1,startLineNumber:16),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cranges%3E%0A%0Aint+main()%0A%7B%0A++auto+v+%3D+std::ranges::views::iota(!'a!')+%7C+std::ranges::views::take(10)%3B%0A++auto+vec+%3D+v+%7C+std::ranges::to%3Cstd::vector%3E()%3B%0A%0A++std::cout+%3C%3C+vec.size()+%3C%3C+%22%5Cn%22%3B%0A++for(auto+c:+vec)%0A++%7B%0A++++std::cout+%3C%3C+c%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P1206")

== Nouveaux ranges et range adaptors

- ```cpp std::views::zip()``` fusionne plusieurs ranges en un range de tuple

```cpp
auto x = vector{1, 2};
auto y = list<string>{"Aa", "Bb", "Cc"};
auto z = array{'A', 'B', 'C', 'D'};

// 1 Aa A
// 2 Bb B
for(tuple<int&, string&, char&> e : zip(x, y, z))
  cout << get<0>(e) << ' ' << get<1>(e) << ' ' << get<2>(e) << '\n';
```

- ```cpp std::views::zip_transform()``` fusionnent plusieurs ranges via une transformation

```cpp
zip_transform(multiplies{}, iota(2, 5), iota(6, 9)); // 12, 21, 32
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:11,positionColumn:1,positionLineNumber:11,selectionStartColumn:1,selectionStartLineNumber:11,startColumn:1,startLineNumber:11),source:'%23include+%3Ciostream%3E%0A%23include+%3Cranges%3E%0A%0Aint+main()%0A%7B%0A++for(auto+i+:+std::views::zip_transform(std::multiplies%7B%7D,+std::views::iota(2,+5),+std::views::iota(6,+9)))%0A++%7B%0A++++std::cout+%3C%3C+i+%3C%3C+!'+!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:19,positionColumn:1,positionLineNumber:19,selectionStartColumn:1,selectionStartLineNumber:19,startColumn:1,startLineNumber:19),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Clist%3E%0A%23include+%3Carray%3E%0A%23include+%3Ctuple%3E%0A%23include+%3Cranges%3E%0A%0Aint+main()%0A%7B%0A++auto+x+%3D+std::vector%7B1,+2%7D%3B%0A++auto+y+%3D+std::list%3Cstd::string%3E%7B%22Aa%22,+%22Bb%22,+%22Cc%22%7D%3B%0A++auto+z+%3D+std::array%7B!'A!',+!'B!',+!'C!',+!'D!'%7D%3B%0A%0A++for(std::tuple%3Cint%26,+std::string%26,+char%26%3E+e+:+std::ranges::views::zip(x,+y,+z))%0A++%7B%0A++++std::cout+%3C%3C+std::get%3C0%3E(e)+%3C%3C+!'+!'+%3C%3C+std::get%3C1%3E(e)+%3C%3C+!'+!'+%3C%3C+std::get%3C2%3E(e)+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("p2321")

== Nouveaux ranges et range adaptors

- ```cpp std::views::adjacent()``` construit des ranges de $N$ éléments consécutifs
- ```cpp std::views::pairwise()``` construit des ranges de 2 éléments consécutifs

```cpp
iota(1, 6) | adjacent<3>; // [1, 2, 3] [2, 3, 4] [3, 4, 5]
```

- ```cpp std::views::adjacent_transform()``` et ```cpp std::views::pairwise_transform()``` construisent un range en appliquant une transformation aux éléments adjacents

```cpp
iota(2, 6) | adjacent_transform<2>(std::plus{}); // 5, 7, 9
```

- ```cpp std::views::join_with()``` : ```cpp std::views::join()``` en précisant le séparateur

```cpp
vector<string> vs = {"the", "quick", "brown", "fox"};

vs | join_with('-'); // the-quick-brown-fox
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:15,positionColumn:1,positionLineNumber:15,selectionStartColumn:1,selectionStartLineNumber:15,startColumn:1,startLineNumber:15),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cstring%3E%0A%23include+%3Cranges%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cstd::string%3E+vs+%3D+%7B%22the%22,+%22quick%22,+%22brown%22,+%22fox%22%7D%3B%0A++auto+v+%3D+vs+%7C+std::ranges::views::join_with(!'-!')%3B%0A%0A++for(auto+c+:+v)%0A++%7B%0A++++std::cout+%3C%3C+c%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:87,endLineNumber:6,positionColumn:87,positionLineNumber:6,selectionStartColumn:87,selectionStartLineNumber:6,startColumn:87,startLineNumber:6),source:'%23include+%3Ciostream%3E%0A%23include+%3Cranges%3E%0A%0Aint+main()%0A%7B%0A++for(auto+i+:+std::views::iota(2,+6)+%7C+std::views::adjacent_transform%3C2%3E(std::plus%7B%7D))%0A++%7B%0A++++std::cout+%3C%3C+i+%3C%3C+%22+%22%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:12,positionColumn:1,positionLineNumber:12,selectionStartColumn:1,selectionStartLineNumber:12,startColumn:1,startLineNumber:12),source:'%23include+%3Ciostream%3E%0A%23include+%3Cranges%3E%0A%0Aint+main()%0A%7B%0A++auto+rg+%3D+std::views::iota(1,+6)+%7C+std::views::adjacent%3C3%3E%3B%0A++for(auto+i+:+rg)%0A++%7B%0A++++std::cout+%3C%3C+std::get%3C0%3E(i)+%3C%3C+%22-%22+%3C%3C+std::get%3C1%3E(i)+%3C%3C+%22-%22+%3C%3C+std::get%3C2%3E(i)+%3C%3C+%22%5Cn%22%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("p2321")
#addproposal("p2441")

== Nouveaux ranges et range adaptors

- ```cpp std::ranges::shift_left()``` et ```cpp std::ranges::shift_right()```
- ```cpp std::views::chunck()``` coupe un range en blocs de $N$ éléments

```cpp
vector<int> vs = {1, 2, 2, 3, 0, 4, 5, 2};

vs | chunk(3);   // [[1, 2, 2], [3, 0, 4], [5, 2]]
```

- ```cpp std::views::chunck_by()``` découpe un range en fonction d'un prédicat

```cpp
vector<int> vs = {1, 2, 2, 3, 0, 4, 5, 2};

vs | chunk_by(less_equal{});   // [[1, 2, 2, 3], [0, 4, 5], [2]]
```

- ```cpp std::views::slide()``` : ```cpp std::views::adjacent()``` avec une taille _run-time_

```cpp
iota(1, 6) | slide(3); // [1, 2, 3] [2, 3, 4] [3, 4, 5]
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:5,endLineNumber:13,positionColumn:5,positionLineNumber:13,selectionStartColumn:5,selectionStartLineNumber:13,startColumn:5,startLineNumber:13),source:'%23include+%3Ciostream%3E%0A%23include+%3Cranges%3E%0A%0Aint+main()%0A%7B%0A++auto+rg+%3D+std::views::iota(1,+6)+%7C+std::views::slide(3)%3B%0A++for(auto+i:+rg)%0A++%7B%0A++++for(auto+j:+i)%0A++++%7B%0A++++++std::cout+%3C%3C+j+%3C%3C+%22+%22%3B%0A++++%7D%0A++++std::cout+%3C%3C+%22%5Cn%22%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:65,endLineNumber:9,positionColumn:65,positionLineNumber:9,selectionStartColumn:65,selectionStartLineNumber:9,startColumn:65,startLineNumber:9),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cstring%3E%0A%23include+%3Cranges%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+vs+%3D+%7B1,+2,+2,+3,+0,+4,+5,+2%7D%3B%0A++auto+v+%3D+vs+%7C+std::ranges::views::chunk_by(std::less_equal%7B%7D)%3B%0A%0A++for+(const+auto+subrange:+v)%0A++%7B%0A++++for(const+auto+c:+subrange)%0A++++%7B%0A++++++std::cout+%3C%3C+c+%3C%3C+%22+%22%3B%0A++++%7D%0A++++std::cout+%3C%3C+%22%5Cn%22%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:44,endLineNumber:9,positionColumn:44,positionLineNumber:9,selectionStartColumn:44,selectionStartLineNumber:9,startColumn:44,startLineNumber:9),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cstring%3E%0A%23include+%3Cranges%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+vs+%3D+%7B1,+2,+2,+3,+0,+4,+5,+2%7D%3B%0A++auto+v+%3D+vs+%7C+std::ranges::views::chunk(3)%3B%0A%0A++for+(const+auto+subrange:+v)%0A++%7B%0A++++for(const+auto+c:+subrange)%0A++++%7B%0A++++++std::cout+%3C%3C+c+%3C%3C+%22+%22%3B%0A++++%7D%0A++++std::cout+%3C%3C+%22%5Cn%22%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P2440")
#addproposal("p2443")

== Nouveaux ranges et range adaptors

- ```cpp std::views::find_last()```/```cpp find_last_if()```/```cpp find_last_if_not()```
- ```cpp std::views::stride()``` conserve un élément sur $n$

```cpp
views::iota(1, 13) | views::stride(3);  // 1 4 7 10
```

- ```cpp std::ranges::fold_left()```/```cpp fold_left_first()```/```cpp fold_left_with_iter()```
- ```cpp std::ranges::fold_right()```/```cpp fold_right_last()```/```cpp fold_right_with_iter()```

```cpp
vector<double> v = {0.25, 0.75};

ranges::fold_left(v, 1, plus()); // 2
```

- ```cpp std::views::cartesian_product()``` : produit cartésien de plusieurs ranges

```cpp
cartesian_product(iota(2, 4), iota(6, 9));
// (2, 6) (2, 7) (2, 8) (3, 6) (3, 7) (3, 8)
```
#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:35,endLineNumber:8,positionColumn:35,positionLineNumber:8,selectionStartColumn:35,selectionStartLineNumber:8,startColumn:35,startLineNumber:8),source:'%23include+%3Ciostream%3E%0A%23include+%3Cranges%3E%0A%0Aint+main()%0A%7B%0A++for(auto+i:+std::views::cartesian_product(std::views::iota(2,+4),+std::views::iota(6,+9)))%0A++%7B%0A++++std::cout+%3C%3C+std::get%3C0%3E(i)+%3C%3C+%22-%22+%3C%3C+std::get%3C1%3E(i)+%3C%3C+%22%5Cn%22%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:11,positionColumn:1,positionLineNumber:11,selectionStartColumn:1,selectionStartLineNumber:11,startColumn:1,startLineNumber:11),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cranges%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cdouble%3E+v+%3D+%7B0.25,+0.75%7D%3B%0A++std::cout+%3C%3C+std::ranges::fold_left(v,+1,+std::plus())%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:26,endLineNumber:12,positionColumn:26,positionLineNumber:12,selectionStartColumn:26,selectionStartLineNumber:12,startColumn:26,startLineNumber:12),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cranges%3E%0A%0Aint+main()%0A%7B%0A++auto+v+%3D+std::ranges::views::iota(1,+13)+%7C+std::ranges::views::stride(3)%3B%0A++auto+vec+%3D+v+%7C+std::ranges::to%3Cstd::vector%3E()%3B%0A%0A++for(auto+c:+vec)%0A++%7B%0A++++std::cout+%3C%3C+c+%3C%3C+%22+%22%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)


#addproposal("P1223")
#addproposal("P2322")
#addproposal("P2374")
#addproposal("P2540")

== Nouveaux ranges et range adaptors

- ```cpp std::views::as_rvalue()``` convertit les éléments en _r-value_
- ```cpp std::views::as_const()``` constifie les éléments
- ```cpp std::views::repeat()``` répète $n$ fois une valeur

```cpp
views::repeat(17, 4);  // 17 17 17 17
```

- ```cpp std::views::enumerate()``` : vue index/valeur depuis un range de valeurs
  - Manipulation d'un index dans un _range-based for loop_ sans gestion explicite
  - Construction de ```cpp std::map``` depuis un ```cpp std::vector``` avec l'index pour clé

```cpp
"hello" | std::views::enumerate; // (0:h) (1:e) (2:l) (3:l) (4:o)
```

- Améliorations de ```cpp std::views::split()```
- Corrections de ```cpp std::ranges::istream_view()```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:54,endLineNumber:9,positionColumn:54,positionLineNumber:9,selectionStartColumn:19,selectionStartLineNumber:7,startColumn:19,startLineNumber:7),source:'%23include+%3Ciostream%3E%0A%23include+%3Cranges%3E%0A%23include+%3Cstring%3E%0A%0Aint+main()%0A%7B%0A++std::string+s+%3D+%22hello%22%3B%0A%0A++for(auto+%5Bindex,+value%5D:+s+%7C+std::views::enumerate)%0A++%7B%0A++++std::cout+%3C%3C+index+%3C%3C+%22:%22+%3C%3C+value+%3C%3C+%22%5Cn%22%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:9,positionColumn:1,positionLineNumber:9,selectionStartColumn:1,selectionStartLineNumber:9,startColumn:1,startLineNumber:9),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cranges%3E%0A%0Aint+main()%0A%7B%0A++auto+vec+%3D+std::ranges::views::repeat(17,+4)+%7C+std::ranges::to%3Cstd::vector%3E()%3B%0A%0A++for(auto+c:+vec)%0A++%7B%0A++++std::cout+%3C%3C+c+%3C%3C+%22+%22%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P2446")
#addproposal("p2474")
#addproposal("p2164")

== ``` borrowed_range```

- Nouveau concept de range : ```cpp borrowed_range```
- Range dont les itérateurs sur celui-ci reste valide après sa destruction
- Des ranges inconditionnellement _borrowed_ : ```cpp ref_view```, ```cpp string_view```, ```cpp empty_view``` et ```cpp iota_view```
- Des ranges conditionnellement _borrowed_, selon la vue sous-jacente : ```cpp take_view```, ```cpp drop_view```, ...

#addproposal("P2017")

== Range adaptors définis par l'utilisateur

- Classe de base ```cpp std::ranges::range_adaptor_closure<t>```
- Adaptateur de fonction ```cpp std::bind_back()```

```cpp
bind_back(f, ys...)(xs...);

// Equivalent a

f(xs..., ys...);
```

#addproposal("P2387")

== Modules

- Module ```cpp std``` importe tout le namespace ```cpp std``` (C++ et _wrappers_ C)
- Module ```cpp std.compat``` importe tout le namespace ```cpp std``` et le namespace globale des _wrappers_ C

#addproposal("P2465")

== ``` std::generator```

- Générateur de coroutines synchrones

```cpp
generator<int> gen(int n) {
  for (int a = 0; a < n; ++a)
    co_yield a; }

auto g = gen(5);
for(auto i: g) {
  cout << i << " "; }
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:18,positionColumn:1,positionLineNumber:18,selectionStartColumn:1,selectionStartLineNumber:18,startColumn:1,startLineNumber:18),source:'%23include+%3Cgenerator%3E%0A%23include+%3Ciostream%3E%0A%0Astd::generator%3Cint%3E+gen(int+n)%0A%7B%0A++for+(int+a+%3D+0%3B+a+%3C+n%3B+%2B%2Ba)%0A++++++co_yield+a%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++auto+g+%3D+gen(5)%3B%0A++for(auto+i:+g)%0A++%7B%0A++++std::cout+%3C%3C+i+%3C%3C+%22+%22%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B23+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P2502")
#addproposal("P2787")
