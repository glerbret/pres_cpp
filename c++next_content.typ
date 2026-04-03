#import "./model.typ": *

= Et ensuite ?

== Présentation

- C++26 ne marque pas la fin des évolutions du C++
- Plusieurs sujets proposés et non pris en compte dans les versions actuelles
- Plusieurs TS publiés et non intégrés ou en cours d'étude

== TS -- _Networking_ TS

- Publié en avril 2018
- Partiellement basé sur ```cpp Boost.Asio```
- Gestion de _timer_
- Gestion de tampon et de flux orientés tampon
- Gestion de _sockets_ et de flux _socket_
- Gestion IPv4, IPv6, TCP, UDP
- Manipulation d'adresses IP
- Pas de protocoles de plus haut niveau actuellement
- Demande post-TS : gestion de la sécurité (a priori pas possible)
- Modèle asynchrone, différent de celui déjà présent en C++

#addproposal("n4771")
#addproposal("P2762")

== TS -- _Pattern matching_

- Utilisation du mot clé ```cpp match``` (ou ```cpp switch```, ```cpp inspect```) et du _wildcard_ ```cpp _``` (ou ```cpp __```)
- Utilisable sur les entiers

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:13,positionColumn:1,positionLineNumber:13,selectionStartColumn:1,selectionStartLineNumber:13,startColumn:1,startLineNumber:13),source:'%23include+%3Cprint%3E%0A%0Aint+main()%0A%7B%0A++int+x+%3D+1%3B%0A++x+match%0A++%7B%0A++++0++%3D%3E+std::print(%22Aucun%22)%3B%0A++++1++%3D%3E+std::print(%22Un%22)%3B%0A++++_++%3D%3E+std::print(%22Plusieurs%22)%3B%0A++%7D%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:clang_patmat,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+clang+(pattern+matching+-+P2688)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    x match {
      0 => print("Aucun");
      1 => print("Un");
      _ => print("Plusieurs");
    };
    ```
  ],
)

- Sur les chaînes de caractères

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:15,positionColumn:1,positionLineNumber:15,selectionStartColumn:1,selectionStartLineNumber:15,startColumn:1,startLineNumber:15),source:'%23include+%3Cprint%3E%0A%23include+%3Cstring%3E%0A%0Aint+main()%0A%7B%0A++std::string+x+%3D+%22un%22%3B%0A%0A++x+match%0A++%7B%0A++++%22zero%22+%3D%3E+std::print(%22Aucun%22)%3B%0A++++%22un%22+++%3D%3E+std::print(%22Un%22)%3B%0A++++_++++++%3D%3E+std::print(%22Plusieurs%22)%3B%0A++%7D%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:clang_patmat,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+clang+(pattern+matching+-+P2688)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    x match {
      "zero" => print("Aucun");
      "un"   => print("Un");
      _      => print("Plusieurs");
    };
    ```
  ],
)

#addproposal("P1371")
#addproposal("p2688")

== TS -- _Pattern matching_

- Sur les ```cpp std::tuple```, ```cpp std::pair```, ```cpp std::array``` et tuple-like

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:9,endLineNumber:13,positionColumn:9,positionLineNumber:13,selectionStartColumn:9,selectionStartLineNumber:13,startColumn:9,startLineNumber:13),source:'%23include+%3Cprint%3E%0A%23include+%3Ctuple%3E%0A%0Aint+main()%0A%7B%0A++std::tuple%3Cint,+int%3E+p%7B2,+0%7D%3B%0A%0A++p+match%0A++%7B%0A++++%5B0,+0%5D+%3D%3E+std::print(%22on+origin%22)%3B%0A++++%5B0,+let+y%5D+%3D%3E+std::print(%22on+y-axis%22)%3B%0A++++%5Blet+x,+0%5D+%3D%3E+std::print(%22on+x-axis%22)%3B%0A++++let+%5Bx,+y%5D+%3D%3E+std::print(%22%7B%7D,%7B%7D%22,+x,+y)%3B%0A++%7D%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:clang_patmat,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-Wall+-Wextra+-pedantic+-Wno-unused-variable',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+clang+(pattern+matching+-+P2688)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    p match {
      [0, 0] => print("on origin");
      [0, let y] => print("on y-axis");
      [let x, 0] => print("on x-axis");
      let [x, y] => print("{},{}", x, y);
    };
    ```
  ],
)

- Sur les ```cpp std::variant```, ```cpp std::any``` et ```cpp std::expected```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:14,positionColumn:1,positionLineNumber:14,selectionStartColumn:1,selectionStartLineNumber:14,startColumn:1,startLineNumber:14),source:'%23include+%3Cprint%3E%0A%23include+%3Cvariant%3E%0A%0Aint+main()%0A%7B%0A++++std::variant%3Cint,+float%3E+v%7B1%7D%3B%0A%0A++++v+match%0A++++%7B%0A%09++++int:+let+i+++%3D%3E+std::print(%22Entier+%7B%7D%22,+i)%3B%0A%09%09float:+let+f+%3D%3E+std::print(%22Reel+%7B%7D%22,+f)%3B%0A%09%7D%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:clang_patmat,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-Wall+-Wextra+-pedantic+-Wno-unused-variable',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+clang+(pattern+matching+-+P2688)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    v match {
      int: let i   => print("Entier {}", i);
      float: let f => print("Reel {}", f);
    };
    ```
  ],
)

#addproposal("P1371")
#addproposal("p2688")

== TS -- _Pattern matching_

- Sur les types polymorphiques

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:2,endLineNumber:24,positionColumn:2,positionLineNumber:24,selectionStartColumn:2,selectionStartLineNumber:24,startColumn:2,startLineNumber:24),source:'%23include+%3Cprint%3E%0A%23include+%3Ctuple%3E%0A%0Astruct+Shape+%7B%0A++++Shape()+%3D+default%3B%0A++++virtual+~Shape()+%3D+default%3B%0A%7D%3B%0A%0Astruct+Circle+:+Shape+%7B%0A++++int+r+%3D+8%3B%0A%7D%3B%0A%0Astruct+Rectangle+:+Shape+%7B%0A++++int+w+%3D+10%3B%0A++++int+h+%3D+5%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A%23if+1%0A++++Shape*+shape+%3D+new+Rectangle%3B%0A%23else%0A++++Shape*+shape+%3D+new+Circle%3B%0A%23endif%0A%0A++++*shape+match%0A++++%7B%0A++++++++Circle:+let+%5Br%5D+++++++%3D%3E+std::print(%22%7B%7D%22,+3.14+*+r+*+r)%3B%0A++++++++Rectangle:+let+%5Bw,+h%5D+%3D%3E+std::print(%22%7B%7D%22,+w+*+h)%3B%0A++++%7D%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:clang_patmat,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-Wall+-Wextra+-pedantic+-Wno-unused-variable',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+clang+(pattern+matching+-+P2688)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    shape match {
      Circle: let [r]       => print("{}", 3.14 * r * r);
      Rectangle: let [w, h] => print("{}", w * h);
    };
    ```
  ],
)

- Support des gardes

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:15,positionColumn:1,positionLineNumber:15,selectionStartColumn:1,selectionStartLineNumber:15,startColumn:1,startLineNumber:15),source:'%23include+%3Cprint%3E%0A%23include+%3Ctuple%3E%0A%0Aint+main()%0A%7B%0A++std::tuple%3Cint,+int%3E+p%7B2,+0%7D%3B%0A%0A++p+match%0A++%7B%0A++++let+%5Bx,+y%5D+if(x+%3E+y)+%3D%3E+std::print(%22%7B%7D+superieur+a+%7B%7D%22,+x,+y)%3B%0A++++let+%5Bx,+y%5D+if(x+%3D%3D+y)+%3D%3E+std::print(%22x+et+y+egaux%22)%3B%0A++++let+%5Bx,+y%5D+if(x+%3C+y)+%3D%3E+std::print(%22%7B%7D+inferieur+a+%7B%7D%22,+x,+y)%3B%0A++%7D%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:clang_patmat,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-Wall+-Wextra+-pedantic+-Wno-unused-variable',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+clang+(pattern+matching+-+P2688)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    p match {
      let [x, y] if(x > y) => print("{} superieur a {}", x, y);
    };
    ```
  ],
)

#alertblock("Attention", "Prise en compte de la première correspondance et non de la meilleure")

#addproposal("P1371")
#addproposal("p2688")

== TS -- _Library fundamentals 2_

- Partiellement intégré en C++17 et C++20
- ```cpp std::is_detected``` indique si un _template-id_ est bien formé
- Wrapper ```cpp std::propagate_const``` pour les pointeurs et _pointer-like_
- Pointeurs intelligents non possédants ```cpp std::observer_ptr```
- ```cpp std::ostream_joiner``` écrit des éléments dans un flux de sortie

```cpp
int foo[] = {1, 2, 3, 4, 5};
copy(begin(foo), end(foo), make_ostream_joiner(cout, ", "));
// "1, 2, 3, 4, 5"
```

#addproposal("N4617")

== TS -- _Library fundamentals 2_

- Générateur aléatoire propre au thread ```cpp std::default_random_engine``` initialisé dans un état non prédictif
  - ```cpp std::randint()``` génère un nombre entier dans une plage spécifiée
  - ```cpp std::reseed()``` modifie la graine de génération
  - ```cpp std::sample()``` choisit aléatoirement $n$ élément d'une séquence
  - ```cpp std::shuffle()``` réordonne aléatoirement les éléments d'un range

#addproposal("N4617")

== TS -- _Library fundamentals 3_

- _Scope Guard_ : enregistrement d'un foncteur appelé
  - à la sortie du scope : ```cpp std::scope_exit```
  - à la sortie du scope par une exception : ```cpp std::scope_fail```
  - à la sortie du scope hors exception : ```cpp std::scope_success```
- _RAII wrapper_ ```cpp std::unique_resource```

#addproposal("N4948")

== TS -- _Parallelism 2_

- Exception levée durant une exécution parallèle
- Politique d'exécution ```cpp vector_policy```

#addproposal("N4808")

== TS -- _Concurrency_

- Partiellement intégré à C++20, C++23 et C++26
- Versions de ```cpp std::future``` et ```cpp std::shared_future``` supportant les continuations
  - ```cpp is_ready()``` indique si l'état partagé est disponible
  - ```cpp then()``` attache une continuation à la future
- ```cpp std::when_any``` crée une future disponible lorsqu'une des futures contenues devient disponible
- ```cpp std::when_all``` crée une future disponible lorsque toutes les futures contenues sont disponibles
- ```cpp std::make_ready_future()``` crée une future contenant une valeur immédiatement disponible
- ```cpp std::make_exceptional_future()``` crée une future contenant une exception immédiatement disponible

#addproposal("P0159")
#addproposal("N4953")

== TS -- _Transactional Memory_

- Blocs synchronisés
- Blocs atomiques
- Fonction _transaction-safe_
- Attributs ```cpp [[optimize_for_synchronized]]```

#addproposal("N4514")
#addproposal("N4956")

== Dépréciation

- Modes d'arrondi (```cpp fesetround()```)
- Types de caractère signés dans ```cpp iostream```
- Notion ```cpp trivial```
- Conversions implicites entre ```cpp char8_t```, ```cpp char16_t``` et ```cpp char32_t```
- Paramètre template ```cpp std::char_traits``` de ```cpp std::basic_string```, ```cpp std::basic_string_view``` et des flux
- Conversion implicite de ```cpp bool``` vers un type caractère

#addproposal("p3695")
#addproposal("p3681")
#addproposal("p3765")

== Suppression

- Suppression d'éléments précédemment dépréciés
  - ```cpp volatile```
  - ```cpp std::allocator```
  - ```cpp std::basic_string::reserve()``` sans argument
  - _Unicode Conversion Facets_
  - _Locale Category Facets for Unicode_

== _Contracts_

- Contrats sur les fonctions virtuelles et héritage de ceux-ci
- Contrats sur les pointeurs de fonction et pointeurs de fonction membre
- Accès à la valeur initiale des paramètres dans les postconditions
- Comportement ```cpp assume``` : optimisation en supposant le contrat vrai
- Choix du comportement dans l'assertion du contrat
- Contrat _always-enforced_
- Postcondition sur les sorties non normales d'une fonction (exceptions)
- Contrats non évaluables au _run-time_
- Invariants
- Annotations de types _claim_ / _assertion_
- Label sur les contrats
- Messages de diagnostic fournis par l'utilisateur

#addproposal("p3400")
#addproposal("p3831")
#addproposal("p3099")
#addproposal("p3912")

== _Erroneous behavior_

- Applicable à l'absence de retour des fonctions d'affectations
- ```cpp std::erroneous()``` provoque un comportement erroné

#addproposal("p2973")
#addproposal("p3232")

== Mots-clés

- Conversion de macros en mots-clés
  - ```cpp assert```
  - ```cpp offsetof```
- Réservation des identifiants commençant par ```cpp @``` aux annotations

#addproposal("p3254")

== ``` using```

- Accolades pour grouper les déclarations  ```cpp using```

```cpp
using std::chrono::{duration, time_point, duration_cast};
```

#addproposal("p3485")

== Syntaxe

- Autorisation des _trailing commas_ dans davantage de contexte : paramètre de fonction, paramètres templates, _structure bindings_, ...

#addproposal("p3776")

== Encodage

- Ajout des algorithmes Unicode
// Algorithmes défini par Unicode pour travailler sur les séquences de code points
- Support d'Unicode (UTF-8, UTF-16 et UTF-32) dans la bibliothèque standard
- Support des alias _figment_ et _abbreviation_ des noms de caractère

#addproposal("p3733")

== ``` std::arguments```

- Manipulation des arguments du programme
- Arguments accessibles dans tous le programme, pas uniquement ```cpp main()```
- Gestion de l'encodage

#addproposal("p3474")

== Littéraux

- _f-literal_
  - Chaînes littérales contenant des _placeholders_
  - Similaires au _f-string_ Python

```cpp
int a = 5;
auto b = f"Value : {a}";
```

- Utilisation du préfixe ```cpp 0o``` pour les nombres octaux (dépréciation de ```cpp 0```)

#addproposal("p3412")
#addproposal("P0085")

== Types

- Relâchement des restrictions sur les ```cpp typedef _t```
- Vérification _compile-time_ que deux types ont la même représentation mémoire
- Type _fixed point decimal_
- Entiers larges ```cpp wide_integer<128, unsigned>```
- ```cpp std::int_least128_t```
- Nombres rationnels
- Possibilité de définir des objets ```cpp constexpr```
- _Zero-initialisation_ des objets _automatic storage duration_
- Entiers non signés pour lesquels l'_overflow_ est un UB
- ```cpp std::initializer_list``` déplaçables
- Détection et gestion des débordements

#addproposal("P3003")
#addproposal("P3018")
#addproposal("p2966")
#addproposal("p3140")

== Types

- Gestion des arrondis
- Support obligatoire de ```cpp intptr_t``` et ```cpp uintptr_t```
- Types flottants compatible ISO/IEC 60559:2020 (résultats davantage reproductibles)
- Amélioration des nombres flottants
- ```cpp CHAR_BIT``` impérativement égal à 8 ("_There are exactly 8 bits in a byte_")
// Auparavant obligatoirement supérieur ou égal à 8, contraint par les plages garanties de signed char et unsigned char, mais pas d'autres contraintes (même pas multiple de 8)
- Entiers de $n$ bits similaires à ```cpp _BitInt``` du C
- ```cpp std::to_signed``` et ```cpp std::to_unsigned``` permet d'obtenir le type signé/non signé correspondant au type initial
- Suppression de ```cpp trivially_relocatable_if_eligible``` et ```cpp replaceable_if_eligible``` et redesing de la fonctionnalité

#addproposal("p3248")
#addproposal("p3375")
#addproposal("p3477")
#addproposal("p3635")
#addproposal("p3639")
#addproposal("p3666")
#addproposal("p3643")
#addproposal("P3715")
#addproposal("p3823")

== Support des unités physiques

- Gestion des quantités et dimensions
- Supports des unités de base, dérivées, multiples et sous-multiples
- Conversions et opérations entre unités

```cpp
static_assert(10km / 2 == 5km);

static_assert(1h == 3600s);
static_assert(1km + 1m == 1001m);

static_assert(1km / 1s == 1000mps);
static_assert(2kmph * 2h == 4km);
static_assert(2km / 2kmph == 1h);

static_assert(1000 / 1s == 1kHz);

static_assert(10km / 5km == 2);
```

#addproposal("p1935")
#addproposal("P2980")
#addproposal("P2981")
#addproposal("P2982")
#addproposal("p3045")

== Représentation mémoire

- Accès aux octets sous-jacents d'un objet
  - Nouvelle catégorie d'objet _contiguous-layout_
    - Types scalaires et des classes sans fonction ni base virtuelle
    - N'hérite pas d'objet non _contiguous-layout_
    - Contiguïté garantie
  - Représentation sous forme de tableau
  - Obtention d'un pointeur sur la représentation via ```cpp reinterpret_cast``` vers ```cpp char*```, ```cpp unsigned char*``` ou ```cpp std::byte*```
  - Conversion pointeur sur représentation vers pointeur sur objet via ```cpp reinterpret_cast```

== _Shadowing_

- Masquage avec un type ```cpp void``` pour empêcher l'utilisation de la variable masquée
- Initialisation de la nouvelle variable avec l'ancienne variable de même nom
- Masquage sans création d'une nouvelle portée
- Conversion conditionnelle

```cpp
auto foo = optional<string>{"Foo"};
if(foo as string) { /* foo: string& */ }
else { /* foo: optional<string> */ }
```

- Constification d'un conteneur dans un _range-based for loop_

```cpp
vector<string> foo{"1", "2", "3"};
cfor(auto &bar : foo) { /* foo est constant */ }
```

#addproposal("P2951")

== ``` __COUNTER__```

- Normalisation de la macro ```cpp __COUNTER__```
- Incrémentée à chaque invocation

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:9,positionColumn:1,positionLineNumber:9,selectionStartColumn:1,selectionStartLineNumber:9,startColumn:1,startLineNumber:9),source:'%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+__COUNTER__+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+__COUNTER__+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+__COUNTER__+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B26+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    cout << __COUNTER__ << "\n";	// 0
    cout << __COUNTER__ << "\n";	// 1
    cout << __COUNTER__ << "\n";	// 2
    ```
  ],
)

#addproposal("P3384")

== Contrôle de flux

- Ajout d'une instruction à ```cpp break``` appelé lors de la sortie de la boucle
// Alignement sur des évolutions C en cours
- Ajout d'une boucle ```cpp do_until```
- Version _generator-based_ de _for loop_

```cpp
struct generator { ... }

for(int i: generator())
{ ... }
```

- ```cpp break label``` et ```cpp continue label``` appliqués à une boucle englobante

```cpp
outer: for(...) {
  for(...) {
    if (...) {
      break outer; } } }
```

#addproposal("P2881")
#addproposal("p3568")

== Contrôle de flux

- Ajout d'une expression à _range-based for loop_ évalué à chaque fin d'itération

```cpp
for(int i = 0; auto x : e; ++i) { ... }
```

- Ranged if-statement
  - Similaire au range-for si le range n'est pas vide
  - Appel du contenu du ```cpp else``` si le range est vide

#addproposal("p3784")

== _do expression_

- Ajout des _do expression_ : instructions traités comme une expression

```cpp
int x = do { do return 42; };
```

#list(
  marker: [],
  list(indent: 5pt, text[
    Améliorations et simplifications des coroutines, du _pattern matching_, ...]),
  list(indent: 5pt, text[
    Introduit un nouveau scope mais pas de nouveau _function scope_]),
  list(indent: 5pt, text[
    ```cpp do return``` pour retourner une valeur dans un _do expression_]),
  list(indent: 5pt, "Possibilité d'expliciter le type de retour"),
)

#addproposal("P2806")

== ``` static_assert```

- Retarder à l'instanciation l'échec de ```cpp static_assert(false)``` dans des templates

```cpp
// C++20 : echec de compilation systematique
template<typenameT>int my_func(constT&) {
  if constexpr(is_integral_v<T>) { return 1; }
  else if constexpr(is_convertible_v<string, T>) { return 2 ; }
  else { static_assert(false); }
}
```

#addproposal("P2593")

== Évolutions des fonctions

- _Unified Call Syntax_
  - ```cpp x.f(...)``` tente d'appeler ```cpp f(x, ...)``` si ```cpp x.f(...)``` n'est pas valide
  - ```cpp p->f(...)``` tente d'appeler ```cpp f(p, ...)``` si ```cpp p->f(...)``` n'est pas valide
  - Si ```cpp f(x, ...)``` n'est pas valide, ```cpp f(x, ...)``` tente d'appeler
    - ```cpp x->f(...)``` si ```cpp operator->``` existe pour ```cpp x```
    - ```cpp x.f(...)``` sinon
  - Généralisation de ```cpp std::begin()``` et co. dans le langage
- Possibilité pour les fonctions ```cpp va_start``` de ne prendre aucun argument
- Élision de copie des objets de retour nommés (NRVO) garantie
// NRVO : Named Return Value Optimization
// RVO déjà garantie en C++17 pour des prvalues
// Optimisation déjà réalisée par certains compilateurs
- Paramètres ```cpp constexpr``` et _maybe_ ```cpp constexpr```
- Fonctions _heap-free_
- Retour ```cpp std::move(x)``` éligible au NRVO si ```cpp x``` l'est

#addproposal("P3021")
#addproposal("p2966")
#addproposal("p1045")

== Évolutions des fonctions

- Possibilité de déterminer l'appelant
- Arguments nommés

```cpp
void foo(int a, int b, int c, int d, bool e = false);

foo(b: 10, a: 100, c: 640, d: 480);
foo(100, 10, d: 480, e: false, c: 640);
```

- Fourniture d'un paramètre à ```cpp inline```
  - ```cpp std::noinline``` : désactivation de l'inlining
  - ```cpp std::normal_inline``` : comportement actuel, incitation (équivalent à ```cpp inline``` sans paramètre)
  - ```cpp std::always_inline``` : force l'inlining
- _Multi-methods_ et _Open-method_

#addproposal("p2966")
#addproposal("p3676")
#addproposal("n2216")

== Contexte d'appel

- ```cpp __local_ctx``` récupère la contexte d'appel local
- Ajout à ```cpp std::source_location::current()``` d'un paramètre valorisé par défaut à ```cpp __local_ctx```
// Permet d'encapsuler std::source_location::current() tout en lui fournissant le contexte d'appel de la classe l'encapsulant

#addproposal("p3802")

== Opérateurs

- Surcharge de ```cpp operator.```
  - Si l'opérateur est défini, les opérations sont transférés à son résultat
  - ... sauf celles définies comme fonctions membres
  - Réalisation de _smart reference_ (p.ex. _proxy_)
- Surcharge de ```cpp operator?:```
- ```cpp operator??``` pour tester ```cpp std::expected```
- Évolutions des opérateurs de comparaison et de ```cpp operator<=>```
  - Dépréciation des conversions entre énumération et flottant
  - Dépréciation des conversions entre énumérations
  - Dépréciation de la comparaison "_two-way_" entre types tableaux
  - Comparaison _three-way_ entre _unscoped_ énumération et type entier
- Interdiction de l'appel de ```cpp operator=``` sur des temporaires
// Interdit sur les types built-in mais possible sur les autres, avec tous les problèmes que ça peut poser

#addproposal("P2561")

== Opérateurs

- Génération d'opérateurs à la demande via ```cpp =default```
  - ```cpp operatorX=``` à partir de ```cpp operatorX```
  - incrément et décrément préfixés à partir de l'addition et de la soustraction
  - incrément et décrément suffixés à partir des versions préfixés
  - ```cpp operator->``` et ```cpp operator->*``` à partir de ```cpp operator*``` et ```cpp operator.```
// A priori, operator-> et operator->* générés par défaut, génération désactivable avec =delete
- Ajout de ```cpp operator[]``` à ```cpp std::initializer_list```
- Opérateur pipeline ```cpp operator|>```

```cpp
x|>f(y); // Equivalent a f(x, y);
```

#addproposal("p3834")
#addproposal("p3668")
#addproposal("P2952")

== Opérateurs

- ```cpp operator template()``` : extension du support des _non-type template parameters_
- Opérateur d'implication ```cpp operator=>()```

```cpp
p => q; // Equivalent a !p || q;
```

- Opérateur ```cpp nameof```
- Amélioration de la syntaxe pour les surcharges de ```cpp ++``` et ```cpp --``` (```cpp prefix``` / ```cpp postfix```)
- Possibilité d'utiliser ```cpp auto``` ou ```cpp auto&``` comme retour d'opérateur ```cpp =default```

- Opérateur unaire postfixé ~ pour permuter un booléen

```cpp
flag~; // Equivalent a flag = !flag
```

#addproposal("P2971")
#addproposal("p2966")
#addproposal("p3883")

== _Structured binding_

- Support du _structured binding_ sur ```cpp std::extents```

#addproposal("P2906")

== Classes

- Qualificateurs autorisés sur les constructeurs
  - Constructeurs ```cpp const``` pour construire systématiquement des objets constants
  - Constructeurs non ```cpp const``` peuvent construire des objets constants ou non
- Déduction template dans les constructeurs d'agrégats et les alias
- _Layout_ des classes
  - Contrôle du _layout_ pour privilégier taille, ordre de déclaration, visibilité, vitesse, ordre alphabétique, lignes de cache ou règles d'une version antérieure du C++ ou d'un autre langage
  - Contrôle de l'alignement (remplaçant de ```cpp #pragma pack(N)```)
- Constructeurs par déplacement ```cpp =bitcopies```
- Extension de ```cpp =delete``` à d'autres construction (variables template)
- Classes de base ```cpp std::noncopyable``` et ```cpp std::nonmovable```

#addproposal("P2763")
#addproposal("P2895")
#addproposal("p2966")

== Classes

- Mécanisme de conversion tableau de structures vers structure de tableaux
// AoS plus lisible et facile à maintenir mais SoA souvent plus efficace
- Destructeurs ```cpp consteval```
- Données statiques dans les classes locales non nommées
- Génération par défaut des opérateurs d'affectation des classes ayant des données ```cpp const``` ou ```cpp &``` depuis le constructeur par copie par défaut

#addproposal("p2966")
#addproposal("p3421")
#addproposal("p3588")
#addproposal("p3812")

== Énumération

- Ajout d'énumérations _flag-only_
- Fonctions membres sur les énumérations

#addproposal("p2966")

== Gestion d'erreur

- Exceptions légères (_Zero-overhead deterministic exceptions_)
- Objet standard pour le retour d'erreur (```cpp status_code``` et ```cpp error```)

#addproposal("P1028")

== Conteneurs

- Nouveaux conteneurs
  - Tableaux multidimensionnels ```cpp std::mdarray```
  - Queue concurrente
  - Vecteur utilisant un buffer externe
  - Conteneurs intrusifs : conteneurs non possédants
  // Intrusif car les mécanismes nécessaires au conteneur (p.ex. les pointeurs de chaînage des listes) sont dans l'objet que gère le conteneur, généralement via héritage
  - Conteneurs ```cpp inplace``` avec une capacité fixe
  - Vecteurs optimisés pour les petites tailles
- Contrôle de la politique de croissance des vecteurs
- Ajout de ```cpp push_front()``` à ```cpp std::vector```
- Allocateur pour ```cpp std::inplace_vector```
- Comparaison entre ```cpp std::inplace_vector``` de capacités différentes

#addproposal("P1684")
#addproposal("P0260")
#addproposal("P3001")
#addproposal("p2966")
#addproposal("p3147")
#addproposal("p3160")
#addproposal("p3698")

== Conteneurs

- ```cpp span``` de taille fixe
- Relâchement des contraintes sur les tableaux C
  - Initialisation des tableaux d'agrégats
  - Copies de tableaux
  - Tableau comme type de retour
- Correction de dysfonctionnements de ```cpp std::flat_map``` et ```cpp std::flat_set```
- Ajout de ```cpp get()```, ```cpp get_ref()``` et ```cpp get_as()``` à ```cpp std::map``` et ```cpp std::unordered_map``` : récupération de la valeur associée à une clé
- Support des graphes et des algorithmes de manipulation des graphes
- Initialisation de tableau via une expansion de pattern

```cpp
// Initialisation de tous les elements a 5
int a[42] = { 5... };
```

#addproposal("p3567")
#addproposal("P2767")
#addproposal("p3126")
#addproposal("p3127")
#addproposal("p3128")
#addproposal("p3129")
#addproposal("p3130")
#addproposal("p3131")
#addproposal("p3337")
#addproposal("P3110")

== Conteneurs

- Support des _node-handle_ par ```cpp std::list``` et ```cpp std::forward_list```
- Ajout de ```cpp pop_value()``` à ```cpp std::stack```, ```cpp std::queue``` et ```cpp std::priority_queue```
- Fonction libre d'accès "range-checked" à un élément ```cpp std::at()```
- Uniformisation de ```cpp std::span``` et ```cpp std::string_view```
  - Ajout de ```cpp remove_prefix()``` et ```cpp remove_suffix()``` à ```cpp std::span```
  - Ajout de ```cpp first()``` et ```cpp last()``` à ```cpp std::string_view```
- Ajout de garanties à ```cpp std::array```
- Précision sur le comportement des ```cpp std::array``` de taille nulle
- Ajout de ```cpp reserve()``` et ```cpp capacity()``` à ```cpp std::flat_map``` et ```cpp std::flat_set```
- Ajout du _tuple-protocol_ au span de taille fixe
- Création de _subspan_ à partir d'_offsets_ et d'_extents_ _compile-time_

#addproposal("p3049")
#addproposal("p3182")
#addproposal("p3404")
#addproposal("p3729")
#addproposal("p3737")
#addproposal("p3779")
#addproposal("p3786")
#addproposal("p3880")

== Conteneurs

- ```cpp std::is_pointer_between()``` ou ```cpp std::is_pointer_in_range()``` vérifie si un pointeur appartient à une plage mémoire

#noteblock(
  "Note",
  "Vérifie que l'adresse est dans la plage définie par les bornes, mais aussi que les trois adresses appartiennent au même objet",
)

#addproposal("p3852")
#addproposal("p3952")

== Chaînes de caractères

- Construction de ```cpp std::string_view``` depuis des chaînes implicites
- Prise en charge de ```cpp std::string_view``` par ```cpp std::from_chars```
- Modification du constructeur de ```cpp std::string``` depuis un caractère pour interdire les autres numériques (entiers ou flottants)
- Voire dépréciation de la construction d'un ```cpp std::string``` depuis un caractère
- ```cpp fixed_string``` : chaîne de caractères utilisable au compile-time
- Ajout de ```cpp first()``` et de ```cpp last()``` à ```cpp std::string``` et ```cpp std::string_view``` pour récupérer les $n$ premiers ou derniers caractères
- ```cpp std::zstring_view``` équivalent à ```cpp std::string_view``` garantissant la présence d'un ```cpp \0``` terminal
- Sentinelle pour les chaînes null-terminée, pour l'usage de range sur ces chaînes
- ```cpp std::cstring_view``` : vue systématiquement _null-terminated_

#addproposal("p3094")
#addproposal("p3283")
#addproposal("P3655")
#addproposal("P3710")
#addproposal("p3862")

== _Tuples_

- Récupération d'un index depuis un type pour ```cpp std::variant``` et ```cpp std::tuple```
- Utilisation de tableaux C comme _tuple-like_
- Utilisation d'_aggregates_ comme _tuple-like_
- Amélioration de l'ergonomie d'accès aux champs des ```cpp std::tuple```

```cpp
t[0ic] // Equivalent a std::get<0>(t)
```

#addproposal("p2527")
#addproposal("p2141")

== ``` std::optional```

- ```cpp value_or_construct()``` : construction paresseuse de l'alternative
- ```cpp value_or_else()``` : appel paresseux d'une fonction en l'absence de valeur

#addproposal("p3413")

== ``` std::expect```

- Ajout de ```cpp has_error()```

#addproposal("p3798")

== _Guarded objects_

- Classes templates imposant la prise d'un lock avant l'utilisation d'un objet

#noteblock("Motivation", "Éviter l'oubli de verrouillage d'un mutex avant l'utilisation d'un objet partagé")

#addproposal("p3497")

== Itérateurs

- API itérateurs de génération des nombres aléatoire
- ```cpp std::iterator_interface``` pour la définition de nouveaux itérateurs

#addproposal("p2727")

== Algorithmes

- ```cpp std::find_last()``` recherche depuis la fin d'un conteneur
- ```cpp std::is_uniqued``` test l'absence de deux valeurs consécutives identiques
- Gestion des UUID
- Fonctions statistiques (moyenne, médiane, variance, ...)
- Améliorations du générateur aléatoire
- Ajout de fonctions "simples" pour la génération de nombres aléatoires
- Manipulation de bits : ```cpp bit_reverse```, ```cpp bit_repeat```, ```cpp bit_compress```, ```cpp bit_expand```, ```cpp next_bit_permutation``` et ```cpp prev_bit_permutation```
- Fonctions membres ```cpp one()```, ```cpp countl_zero()```, ```cpp countl_one()```, ```cpp countr_zero()```, ```cpp countr_one()```, ```cpp rotl()```, ```cpp rotr()``` et ```cpp reverse()``` à ```cpp std::bitset```
- ```cpp std::first_factor``` retourne le plus petit facteur premier d'un nombre
- ```cpp std::uninitialized_relocate```, ```cpp std::uninitialized_relocate_n``` et  ```cpp std::uninitialized_relocate_backward```

#addproposal("P2848")
#addproposal("p1708")
#addproposal("p2681")
#addproposal("p3689")
#addproposal("p3104")
#addproposal("p3103")
#addproposal("p3133")
#addproposal("p3516")

== Algorithmes

- ```cpp std::isqrt()``` : racine entière d'un nombre positif
// Plus grand entier dont le carré est inférieur ou égal au nombre initial
- ```cpp std::clmul()``` : multiplication sans retenu (_XOR multiplication_)
- Fonctions de manipulation de caractères
  - ```cpp is_ascii```, ```cpp is_ascii_alpha```, ```cpp is_ascii_alphanumeric```, ...
  - ```cpp ascii_to_lower```, ```cpp ascii_to_upper```
  - ```cpp ascii_case_insensitive_compare```, ```cpp ascii_case_insensitive_equal```
  - Alternative plus riche et robuste aux fonctions de ```cpp <cctype>```
// Support de ```cpp char8_t```, ```cpp char16_t``` et ```cpp char32_t```, fonction ```cpp constexpr```, meilleure gestion typage}
- Support des différents types de caractères (```cpp char8_t```, ```cpp char16_t```, ```cpp char32_t``` et ```cpp wchar_t```) par ```cpp std::to_chars()``` et ```cpp std::from_chars()```
- Fonctions libres de manipulation de _string_view-like_
  - ```cpp std::starts_with()``` et ```cpp std::ends_with()```
  - ```cpp std::join()```
  - ```cpp std::is_null_or_empty()```

#addproposal("p3605")
#addproposal("p3642")
#addproposal("p3688")
#addproposal("p3711")
#addproposal("p3735")
#addproposal("p3724")
#addproposal("p3876")

== Algorithmes

- ```cpp std::partial_sort_n``` et ```cpp std::nth_element_n``` prenant un nombre d'éléments
- Divisions entières avec choix du mode d'arrondi (vers $0$, vers $plus.minus infinity$, ...)
- Suppression de la contrainte de régularité sur les prédicats de ```cpp std::find_if()```, ```cpp std::remove_if()```, ```cpp std::all_of()```, ```cpp std::any_of()```, ...
// Le prédicat n'est plus tenu de fournir toujours le même résultat pour un élément donné, car chaque élément n'est parcouru qu'une fois
- ```cpp std::shl()``` et ```cpp std::shr()``` : décalage de bits
- ```cpp msb_to_mask``` construit le masque permet de récupérer le bit de poids fort
- Gestion du mode d'arrondi sur les calculs avec des ```cpp float```
- Ajout des fonctions de manipulation de ```cpp float``` et ```cpp double``` de C23 (```cpp std::iscanonical()```, ```cpp std::iszero()```, ```cpp std::fadd()```, ...)

#addproposal("p3734")
#addproposal("p3793")
#addproposal("p3764")
#addproposal("p3864")
#addproposal("p3935")

== _Ranges_

- Ajout d'un paramètre ```cpp pas``` à ```cpp std::iota_view```
- Utilisation de ```cpp std::get_element<>``` comme point de configuration

```cpp
// Tri sur le premier element du tuple
vector<tuple<int, int>> v{{3,1},{2,4},{1,7}};

ranges::sort(v, less{}, get_element<0>);
```

- Plusieurs nouveaux adaptateurs : ```cpp adjacent_filter```, ```cpp adjacent_remove_if```, ```cpp c_str```, ```cpp generate```, ...
- ```cpp views::maybe``` contient 0 ou 1 élément d'un objet
- ```cpp views::nullable``` adapte un type nullable en un range du type sous-jacent
- Levée des restriction de ```cpp range::to``` pour accepter les vues

#addproposal("p2769")
#addproposal("p1255")
#addproposal("p3544")

== _Ranges_

- ```cpp views::scan``` : version paresseuse de ```cpp std::inclusive_scan```
- ```cpp ranges::any_view``` : vue type-erasure
- ```cpp ranges::views::slice``` : prends une tranche d'un range
- Support d'une sentinelle pour les chaînes null-terminées
- Surcharge range de
  - ```cpp reduce()```, ```cpp transform_reduce()```
  - ```cpp inclusive_scan()```, ```cpp transform_inclusive_scan()```
  - ```cpp exclusive_scan()```, ```cpp transform_exclusive_scan()```
- ```cpp ranges::sum()```, ```cpp ranges::product()``` et ```cpp ranges::dot()``` (produit scalaire)
// Ces trois fonctions sont des spécialisations range::reduce() et range::transform_reduce() pour l'addition et la multiplication
- ```cpp views::cycle()``` répète un range

#addproposal("p3351")
#addproposal("p3411")
#addproposal("p3216")
#addproposal("p3705")
#addproposal("p3732")
#addproposal("p3806")

== _Ranges_

- Opérations ensemblistes ```cpp views::set_difference```, ```cpp views::set_intersection```, ```cpp views::set_union``` et ```cpp views::set_symmetric_difference```
- ```cpp static_sized_range``` : raffinement de ```cpp sized_range``` lorsque la taille est connu au _compile-time_

#addproposal("p3741")
#addproposal("p3928")

== Traits

- Trait ```cpp std::is_narrowing_convertible```
- Traits et fonctions pour garantir des conversions sans perte
  - ```cpp is_value_preserving_convertible_v```
- Trait indiquant si un type _trivially default constructible_ peut être initialisé en mettant tous les octets à 0
- Amélioration de l'ergonomie de ```cpp std::integral_constant<int>```
- ```cpp std::is_always_exhaustive``` indique qu'un objet ne contient pas de bit de padding
- ```cpp is_bitwise_trivially_relocatable```
- ```cpp std::is_vector_bool_reference<T>```

#addproposal("p0870")
#addproposal("p2782")
#addproposal("P2509")
#addproposal("p3707")
#addproposal("p3780")
#addproposal("p3719")

== Lambda

- Capture mutable partielle par les lambdas
- Capture effectuée dans l'ordre des déclarations
- Lambda avec capture assignable par copie ou déplacement si les entités capturées sont assignables

#addproposal("p3847")
#addproposal("p3963")

== ``` std::function```

- ```cpp std::inplace_function``` : pendant de ```cpp std::function``` sans allocation
- ```cpp std::function_ptr_t``` : pointeur générique sur une fonction
- ```cpp std::constructor<T>()``` convertit un ensemble de constructeurs en function object

#addproposal("p2828")
#addproposal("p2986")
#addproposal("p2966")
#addproposal("p3841")

== Attributs

- Attributs sur les expressions
- Attributs sur les contrats
- Réservation des attributs sans namespace et avec le namespace ```cpp std```
- Possibilité d'implémenter des attributs utilisateurs

== Attributs

- Nouveaux attributs
  - ```cpp [[invalidate_dereferencing]]``` : ```cpp *ptr``` et ```cpp ptr->``` inutilisables après l'appel
  // P.ex. sur realloc
  - ```cpp [[invalidate]]``` : ```cpp ptr```, ```cpp *ptr``` et ```cpp ptr->``` inutilisables après l'appel
  // P.ex. sur cpp free
  - ```cpp [[no_copy]]``` : types et fonctions ne permettant pas la copie (mais le déplacement et le RVO)
  - ```cpp [[rvo]]``` : fonctions utilisables uniquement dans un contexte RVO
  - ```cpp [[side_effect_free]]``` ou ```cpp [[pure]]```
  - ```cpp [[trivially_relocatable]]```
  - ```cpp [[discard]]``` indique qu'un retour de fonction est volontairement ignoré

#addproposal("p2992")
#addproposal("p2966")

== _Expansion statement_

- Répétition d'une expression au _compile-time_
  - Duplication de l'expression pour chaque élément (pas de boucle)
  - Utilisable avec des éléments de type différent
  - Utilisable sur ```cpp std::tuple```, ```cpp std::array```, classes destructurables, ...

```cpp
auto foo = make_tuple(0, 'a', 3.14);

for... (auto elem : tup)
  cout << elem << "\n";
```

== _Parameters pack_

- Déclaration possible partout où une variable peut être déclarée

```cpp
template <typename... Ts>
struct Foo { Ts... elems; };
```

- _Slicing_ de _packs_

```cpp
auto x = Foo(a1, [:]t1..., [3:]t2..., a2);
bar([1:]t1..., a3, [0]t1);
```

#addproposal("p2994")
#addproposal("p2662")

== _Parameters pack_

- _Pack_ de taille fixe

```cpp
template<unsigned int N> struct my_vector {
  my_vector(int...[N] v) : values{v...} {}
};
```

- _Variadic function_ homogène

```cpp
template <class T>
void f(T... vs);
```

// La fonction prend un nombre quelconque de paramètres, mais tous du type T

- _Unpack_ de ```cpp std::tuple``` à la volée

```cpp
int sum(int x, int y, int z) { return x + y + z; }

tuple<int, int, int> point{1, 2, 3};
int s = sum(point.elems...);
```

== ``` std::format```

- Amélioration du support de ```cpp std::chrono::time_point```
  - ```cpp %s``` : nombre de ticks depuis l'epoch
  - Ajout de précision aux secondes pour le formatage des fractions de secondes
  - ```cpp %f``` : fractions de secondes
- Ajout de formateurs
  - Valeurs atomiques
  - Générateurs aléatoires et distributions
  - _Smart pointers_
  - ```cpp std::optional```, ```cpp std::variant```, ```cpp std::any``` et ```cpp std::expected```
  - ```cpp std::mdspan```, ```cpp std::flat_map``` et ```cpp std::flat_set```
  - ```cpp charN_t```
  - ```cpp std::error_code``` et ```cpp std::error_category```

#addproposal("p2945")
#addproposal("p3015")
#addproposal("p2930")
#addproposal("p3258")
#addproposal("p3070")
#addproposal("p3885")

== ``` std::format```

- ```cpp std::format_as()``` : formateurs personnalisés basé sur un autre type (p.ex. formatage d'enum comme entiers)
- String interpolation : donnée à formater dans la chaîne de format

```cpp
std::println(t"val : {x}");
// Equivalent a
std::println("val : {}", x);
```

#addproposal("p3951")

== ``` std::dump```

- Imprime les paramètres de la fonction

```cpp
std::dump(arg1, arg2, ..., argn);
// Equivalent a
std::println("{} {} ... {}", arg1, arg2, ..., argn);
```

== ``` std::scan```

- Pendant du formatage de texte introduit en C++20
- Alternative sûre et robuste à ```cpp sscanf()```
- Extensible aux types utilisateurs
- Compatible avec les itérateurs et les ranges

```cpp
string key;
int value;
scan("answer = 42", "{} = {}", key, value);
//    ~~~~~~~~~~~~~  ~~~~~~~~~  ~~~~~~~~~~
//        entree       format    arguments
// key : "answer", value : 42
```

```cpp
string key;
chrono::seconds time;
scan("start = 10:30", "{0} = {1:%H:%M}", key, time);
```

== Durées et temps

- Ajout d'une fonction membre ```cpp resolution()``` aux horloges
- Ajout d'horloges _coarses_ moins précises mais plus rapides

#addproposal("p3382")

== Templates

- Instanciation possible de templates au _runtime_ (JIT limité aux templates)
// P.ex. pour des matrices dont la taille n'est pas connue à la compilation
- Paramètre template universel
// Utile pour la création de méta-fonctions template high-order, pour avoir des static_assert(false) dépendants et pour certains tests sur les types
- Templates dans les classes locales
- Rendre les ```cpp <>``` vides optionnels
- Déduction du type via l'affectation du retour de la fonction

```cpp
template <typename T> T foo {}
double bar = foo<deduce>();
```

#addproposal("p2989")
#addproposal("p3747")

== Concepts

- Concept pour les algorithmes numériques
- ```cpp std::integer``` pour les nombres entiers
- ```cpp std::signed_integer``` et ```cpp std::unsigned_integer```

#noteblock(text[``` std::integer``` vs. ``` std::integral```], text[
  ```cpp char``` et ```cpp bool``` ne sont pas des ```cpp std::integer```
])

#addproposal("p3003")
#addproposal("p3701")

== Concepts

- ```cpp either``` et ```cpp neither```

```cpp
void func(either<char, short> auto) {...}
// Equivalent a
template<typename T>
requires(same_as<T, char> or same_as<T, short>)
void func(T) {...}
```

```cpp
void func(neither<short, int> auto) {...}
// Equivalent a
template<typename T>
requires(not same_as<T, short> and not same_as<T, int>)
void func(T) {...}
```

#addproposal("p3625")

== Réflexion

- Méta-classes
  - Construction de types de classes (dont les classes elles-mêmes) ayant
    - Des contraintes
    - Des comportements par défaut
    - Des opérations par défaut
  - ```cpp class```, ```cpp struct```, ```cpp enum class```, _interface_, _value type_
- Bindings vers d'autres langages (JS, Python) via ces mécanismes
- Retour d'un ```cpp std::string``` par ```cpp identifier_of()```

#addproposal("p3947")

== _Type erasure_

- Programmation polymorphique via _type erasure_ : _Proxy_, _Facade_, _Addresser_
// Alternative à la POO et programmation fonctionnelle éliminant certaines de leurs limites

== Références

- Ajout de références possédantes, ```cpp T~```, gérant la destruction de l'objet référencé
- _Reallocation constructor_ transférant la responsabilité de l'objet initial à l'objet créé : ```cpp T::T(T~)```

#addproposal("p2839")

== Pointeurs

- Suppression de ```cpp NULL``` et interdiction de ```cpp 0``` comme pointeur nul
- Surcharge de ```cpp new``` retournant la taille réellement allouée
- ```cpp pointer_in_range``` vérifie si un pointeur est dans une plage

#addproposal("p0901")
#addproposal("p3234")

== Pointeurs intelligents

- ```cpp std::retain_ptr``` pointeur intrusif manipulant le comptage de référence interne
- Création de pointeurs intelligents avec une valeur par défaut
- Comparaison entre pointeurs intelligents et pointeurs nus
- Retour covariant avec ```cpp std::unique_ptr<T>``` (comme ```cpp T*```)
- Amélioration des _hazard pointers_
- Conversion de ```cpp std::unique_ptr``` : ```cpp const_pointer_cast``` et ```cpp dynamic_pointer_cast```

#addproposal("p2966")
#addproposal("p3135")
#addproposal("p3139")

== Contrôle mémoire

- Mécanismes de sécurité de l'usage mémoire
  - _Aliasing_
  - Suivi des dépendances
  - Annotation de types
  - Gestion de _lifetime_
- Accès à la taille réellement allouée
- Spécificateur de stockage des temporaires
  - ```cpp constinit```
  - ```cpp variable_scope```
  - ```cpp block_scope``` : durée de vie des littéraux C
  - ```cpp statement_scope``` : durée de vie des temporaires en C++
- Seuils d'allocation SOO (_Small Object Optimization_)

#addproposal("p2771")
#addproposal("p2966")
#addproposal("P3810")

== Concurrence

- Invocation concurrente
- ```cpp std::volatile_load<T>``` et ```cpp std::volatile_store<T>```
- Gestion des processus, de la communication avec ceux-ci et des _pipes_
- ```cpp std::fiber_context``` : changement de contexte _stackfull_ sans besoin de _scheduler_
- Ajout d'un nom aux threads et mutex
- Contrôle de la priorité et de la taille de pile des threads
- Déclaration ```cpp const``` des fonctions ```cpp lock()``` et ```cpp unlock()``` des mutex
// Pour ne pas devoir déclaré mutable tous les mutex. Déjà le cas dans d'autres langages, p.ex. Rust
- ```cpp std::try_lock_until()``` et ```cpp std::try_lock_for()```
- ```cpp std::multi_lock``` wrapper RAII gérant plusieurs mutex (comme ```cpp std::scoped_lock```) et proposant toutes les fonctionnalités de ```cpp std::unique_lock``` (verrouillage différé, _try lock_, ...)

#addproposal("p2689")
#addproposal("p0876")
#addproposal("p2019")
#addproposal("p3022")
#addproposal("p2966")
#addproposal("p3703")
#addproposal("p3832")
#addproposal("P3833")

== Coroutines

- Bibliothèques de support des coroutines
- ```cpp std::lazy<T>``` permettant l'évaluation différée
- Unification et amélioration des API asynchrones

== Regex

- Ajout de regex _compile-time_

== Interface utilisateur

- Support des entrées/sorties audio
- ```cpp std::web_view``` API fournissant une fenêtre dans laquelle le programme peut injecter des composants web (ou être appelé via _callback_)

== Module

- Exigences d'ABI sur les modules
- Communication d'informations aux outils de _build_ par les modules
- Gestion de la compatibilité ascendante via la configuration d'un _epoch_ au niveau d'un module pour activer des évolutions brisant la compatibilité
- Possibilité d'exporter des macros depuis des modules nommés

#addproposal("p2978")
#addproposal("p3686")

== Compilation et implémentation

- Remplaçant à ```cpp #ifdef``` ... ```cpp #endif```
- API d'interaction avec le système de build et le compilateur
- Ajout d'un offset à ```cpp #embed```
- Imposition de l'ordre des paramètres de ```cpp #embed```

#addproposal("p2978")
#addproposal("p2966")
#addproposal("p3540")
#addproposal("p3731")
