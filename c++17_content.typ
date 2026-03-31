#import "./model.typ": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

= C++17

== Présentation

- Approuvé en décembre 2017
- Dernier Working Draft : #link("https://wg21.link/std17")[N4659 #linklogo()]

#noteblock("Note", text[
  Voir #link("https://www.youtube.com/user/lefticus1/videos")[Vidéos C++ Weekly #linklogo()] (Jason Turner)
])

== Fonctionnalités supprimées

- Suppression des trigraphes (non dépréciés)

#noteblock("Note", text[
  Les digraphes ne sont pas concernés
])

- Suppression de ```cpp register``` (qui reste un mot réservé)
- Suppression des opérateurs d'incrément sur les booléens
- Suppression de ```cpp std::auto_ptr```
- Suppression de ```cpp std::random_shuffle()```
- Suppression des anciens mécanismes fonctionnels : ```cpp std::bind1st()```, ```cpp std::bind2nd()```, ...
- Suppression des spécifications d'exception

== ``` __has_include```

- Teste la présence d'un fichier d'en-tête
- Et donc la disponibilité d'une fonctionnalité

```cpp
#if __has_include(<optional>)
#  include <optional>
#  define OPT_ENABLE
#endif
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23if+__has_include(%3Coptional%3E)%0A%23++include+%3Coptional%3E%0A%23++define+OPT_ENABLE%0A%23endif%0A%0Aint+main()%0A%7B%0A%23ifdef+OPT_ENABLE%0A++std::cout+%3C%3C+%22Optional+enabled%5Cn%22%3B%0A%23else%0A++std::cout+%3C%3C+%22Optional+disabled%5Cn%22%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0061")

== ``` inline``` variable

- Sémantique ```cpp inline``` identique sur fonctions et variables
- Peut être définie, à l'identique, dans plusieurs unité de compilation
- Se comporte comme s'il n'y avait qu'une variable

```cpp
inline int foo = 42;
```

- ```cpp constexpr``` sur une donnée membre statique implique ```cpp inline```
- Utile pour initialiser des variables membres statiques non constantes

```cpp
class Foo { static inline int bar = 42; };
```

#alertblock("Don't", text[
  Ne justifie pas l'usage de variables globales
])

#addproposal("P0386")

== Nested namespace

- Simplification des imbrications de namespaces via l'opérateur ```cpp ::```

```cpp
namespace A {
namespace B {
namespace C {
...
}}}

// Devient

namespace A::B::C {
...
}
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Anamespace+A::B::C%0A%7B%0A++int+foo+%3D+5%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+A::B::C::foo+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("N4230")

== ``` static_assert```

- ```cpp static_assert``` sans message utilisateur

```cpp
static_assert(sizeof(int) == 3);
// Erreur de compilation
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++static_assert(sizeof(int)+%3D%3D+3)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("N3928")

== ``` if constexpr```

- Branchement évalué à la compilation

```cpp
if constexpr(cond)
{ ... }
else if constexpr(cond)
{ ... }
else
{ ... }
```

#noteblock("Motivation", text[
  Conditions d'arrêt plus simple avec les _variadic template_}

  Moins de spécialisations explicites
])

#noteblock("Note", text[
  Conditions intégralement évaluables au _compile-time_, pas de court-circuit

  // C'est à dire qu'en cas de condition composée (or, and), même si la première partie permet de résoudre la condition, il faut que le reste soit évaluable en compile-time
])

#addproposal("P0292")

== ``` if constexpr```

```cpp
template <typename T> auto foo(T t) {
if constexpr(is_pointer_v<T>)
  return *t;
else
  return t;
}

int a = 10, b = 5;
int* ptr = &b;
cout << foo(a) << ' ' << foo(ptr);  // 10 5
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Atemplate+%3Ctypename+T%3E+auto+foo(T+t)%0A%7B%0A++if+constexpr+(std::is_pointer_v%3CT%3E)%0A++++return+*t%3B%0A++else%0A++++return+t%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++int+a+%3D+10,+b+%3D+5%3B%0A++int*+ptr+%3D+%26b%3B%0A++std::cout+%3C%3C+foo(a)+%3C%3C+!'+!'+%3C%3C+foo(ptr)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0292")

== ``` if constexpr```

#noteblock("Note", text[
  Les branches doivent être syntaxiquement correctes

  ... mais pas nécessairement sémantiquement valides
])

#noteblock("Note", text[
  Les branches peuvent avoir des types retour différents sans remettre en cause la déduction de type retour
])

#adviceblock("Do", text[
  Préférez ```cpp if constexpr``` aux suites de spécialisations de template et SFINAE, aux imbrications de ternaires ou à ```cpp #if```
])

#addproposal("P0292")

== ``` if constexpr```

#noteblock(text[_hello world_ de la récursion], text[
  ```cpp
  template<int  N>
  constexpr int fibo(){ return fibo<N-1>()+fibo<N-2>(); }
  template<>
  constexpr int fibo<1>() { return 1; }
  template<>
  constexpr int fibo<0>() { return 0; }

  // Devient

  template<int N>
  constexpr int fibo() {
    if constexpr (N>=2) return fibo<N-1>()+fibo<N-2>();
    else return N;
  }
  ```
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Atemplate%3Cint+N%3E%0Aconstexpr+int+fibo()%0A%7B%0A++if+constexpr+(N%3E%3D2)%0A++++return+fibo%3CN-1%3E()%2Bfibo%3CN-2%3E()%3B%0A++else+return+N%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+fibo%3C8%3E()+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0292")

== ``` if``` init statement

- Initialisation dans le branchement
- Portée identique aux déclarations dans la condition

```cpp
if(int foo = 42; bar)  cout << foo;
else                   cout << -foo;
```

- Sémantiquement équivalent à

```cpp
{
  int foo = 42;
  if(bar)  cout << foo;
  else     cout << -foo;
}
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++int+bar+%3D+5%3B%0A%0A++if(int+foo+%3D+42%3B+bar)%0A++%7B%0A++++std::cout+%3C%3C+foo+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A++else%0A++%7B%0A++++std::cout+%3C%3C+-foo+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0305")

== ``` if``` init statement

- Alternative à certaines constructions peu lisibles

```cpp
if((bool ret = foo()) == true) ...
```

- ... injectant un symbole inutile au delà du branchement

```cpp
bool ret = foo();
if(ret) ...
```

- ... nécessitant l'introduction d'une portée supplémentaire

```cpp
{
  bool ret = foo();
  if(ret) ...
}
```

#addproposal("P0305")

== ``` switch``` init statement

- Initialisation dans le ```cpp switch()```
- Utilisable dans le corps du ```cpp switch()```

```cpp
switch(int foo = 42; bar) {
  ...
}
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++int+bar+%3D+5%3B%0A%0A++switch(int+foo+%3D+42%3B+bar)%0A++%7B%0A++++case+5:%0A++++++std::cout+%3C%3C+-foo+%3C%3C+%22%5Cn%22%3B%0A++++++break%3B%0A%0A++++default:%0A++++++std::cout+%3C%3C+foo+%3C%3C+%22%5Cn%22%3B%0A++++++break%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0305")

== Structured binding

- Décomposition automatique des types composés en multiples variables

```cpp
auto [liste de nom] = expression;
```

- Sur des types dont les données membres non statiques
  - Sont toutes publiques
  - Sont toutes des membres de l'objet ou de la même classe de base publique
  - Ne sont pas des unions anonymes
- Et sur les classes implémentant ```cpp get<>()```, ```cpp tuple_size``` et ```cpp tuple_element```
- Notamment ```cpp std::tuple```, ```cpp std::pair```, ```cpp std::array```

#addproposal("P0217")

== Structured binding

```cpp
tuple<int, long, string> foo();
auto [x,y,z] = foo();
```

```cpp
class Foo {
  const int i = 42;
  const string s{"Hello"};
  public: template <int N> auto& get() const {
    if constexpr(N == 0) { return i; }
    else { return s; } } };

template<> struct tuple_size<Foo>
  : integral_constant<size_t, 2> {};
template<size_t N> struct tuple_element<N, Foo> {
  using type = decltype(declval<Foo>().get<N>()); };

auto [ i, s ] = Foo{};
```

// Les définitions de tuple_size et tuple_element sont dans std

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ctuple%3E%0A%23include+%3Cstring%3E%0A%0Aclass+Foo%0A%7B%0Apublic:%0A++template+%3Cint+N%3E+auto%26+get()+const%0A++%7B%0A++++if+constexpr(N+%3D%3D+0)%0A++++%7B%0A++++++return+i%3B%0A++++%7D%0A++++else%0A++++%7B%0A++++++return+s%3B%0A++++%7D%0A++%7D%0A%0Aprivate:%0A++const+int+i+%3D+42%3B%0A++const+std::string+s%7B%22Hello%22%7D%3B%0A%7D%3B%0A%0Anamespace+std%0A%7B%0A++template%3C%3E%0A++struct+tuple_size%3CFoo%3E%0A++++:+std::integral_constant%3Cstd::size_t,+2%3E+%7B%7D%3B%0A%0A++template%3Cstd::size_t+N%3E%0A++struct+tuple_element%3CN,+Foo%3E%0A++%7B%0A++++using+type+%3D+decltype(std::declval%3CFoo%3E().get%3CN%3E())%3B%0A++%7D%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++const+auto+%5B+i,+s+%5D+%3D+Foo%7B%7D%3B%0A++std::cout+%3C%3C+i+%3C%3C+!'+!'+%3C%3C+s+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%23include+%3Ctuple%3E%0A%23include+%3Carray%3E%0A%23include+%3Cmap%3E%0A%23include+%3Cutility%3E%0A%0Ausing+namespace+std::literals%3B%0A%0Astatic+std::tuple%3Cint,+std::string%3E+foo()%0A%7B%0A++return+std::make_tuple(42,+%22Hello%22s)%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++auto+%5Bx,y%5D+%3D+foo()%3B%0A++std::cout+%3C%3C+x+%3C%3C+!'+!'+%3C%3C+y+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0217")

== Structured binding

- Compatible avec ```cpp const```

```cpp
tuple<int, long, string> foo();
const auto [x,y,z] = foo();
```

- Avec les références

```cpp
auto& [refX,refY,refZ] = monTuple;
```

#alertblock("Attention", text[
  La portée de l'objet référencé doit être supérieure à celle des références
])

#addproposal("P0217")

== Structured binding

- Avec _range-based for loop_

```cpp
map<int, string> myMap;
for(const auto& [k,v] : myMap)
{ ... }
```

- Avec _if init statement_

```cpp
if(auto [iter, succeeded] = myMap.insert(value); succeeded)
{ ... }
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%23include+%3Ctuple%3E%0A%23include+%3Carray%3E%0A%23include+%3Cmap%3E%0A%23include+%3Cutility%3E%0A%0Ausing+namespace+std::literals%3B%0A%0Aint+main()%0A%7B%0A++std::map%3Cint,+std::string%3E+myMap%7B%7B1,+%22Un%22s%7D,+%7B2,+%22Deux%22s%7D%7D%3B%0A%0A++if(auto+%5Biter,+succeeded%5D+%3D+myMap.insert(std::pair%3Cint,+std::string%3E(3,+%22Trois%22s))%3B+succeeded)%0A++%7B%0A++++std::cout+%3C%3C+iter-%3Esecond+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%23include+%3Ctuple%3E%0A%23include+%3Carray%3E%0A%23include+%3Cmap%3E%0A%23include+%3Cutility%3E%0A%0Ausing+namespace+std::literals%3B%0A%0Aint+main()%0A%7B%0A++std::map%3Cint,+std::string%3E+myMap%7B%7B1,+%22Un%22s%7D,+%7B2,+%22Deux%22s%7D%7D%3B%0A%0A++for(const+auto%26+%5Bk,v%5D+:+myMap)%0A++%7B%0A++++std::cout+%3C%3C+k+%3C%3C+%22+:+%22+%3C%3C+v+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0217")

== Structured binding

#noteblock("Objectif", text[
  Meilleure lisibilité

  Remplacement de ```cpp std::tie()```
])

#noteblock("Nom", text[
  Déstructuration (_destructuring_) dans d'autres langages
])

#noteblock("Et ensuite ?", text[
  Premier pas vers les types algébriques de données et le _pattern matching_
])

// Type algébrique : type somme de types produit
// Type produit : analogue sur les types du produit cartésien sur les ensembles
// Type somme : analogue sur les types de l'union disjointe

#alertblock("Limite", text[
  Pas de capture de _structured binding_ par les lambdas
])

// Possible de passer par la capture généralisée

#addproposal("P0217")

== Ordre d'évaluation

- Ordre d'évaluation fixé
  - De gauche à droite pour les expressions post-fixées
  - De droite à gauche pour les affectations
  - De gauche à droite pour les décalages

```cpp
// a avant b
a.b;
a->b,
b op= a;
a[b];
a << b;
a >> b;
```
#addproposal("P0145")

== Ordre d'évaluation

- Évaluation complète d'un paramètre avant celle du suivant

```cpp
f(a(x), b, c(y));
// Lorsque x est evalue, a(x) l'est avant b, y ou c(y)
```

#alertblock("Ordre des paramètres", text[
  Ordre d'évaluation des paramètres toujours non fixé
])

#addproposal("P0145")

== Élision de copie

- Élision garantie pour les objets créés dans l'instruction de retour

```cpp
T f() {
  return T{};  // Pas de copie
}
```

```cpp
T g() {
  T t;
  return t;    // Copie potentielle eludee
}
```

#addproposal("P0135")

== Élision de copie

- Élision garantie lors de la définition d'une variable locale

```cpp
T t = f();   // Pas de copie
```

- Même en l'absence de constructeur par copie

#noteblock("Note", text[
  Élision de copies possibles avant C++17, garanties maintenant
])

#addproposal("P0135")

== Aggregate Initialisation

- Généralisation aux classes dérivées
- Incluant l'initialisation de la classe de base

```cpp
struct Foo { int i; };
struct Bar : Foo { double l; };

Bar bar{{42}, 1.25};
Bar baz{{}, 1.25};   // Foo non intialise
```

#alertblock("Attention", text[
  Uniquement sur de l'héritage public non virtuel

  Pas de constructeur fourni par l'utilisateur (y compris hérité)

  Pas de donnée membre non statique privée ou protégée

  Pas de fonction virtuelle
])

// Bref, les autres restrictions continuent de s'appliquer
// Pour résumer, C++14 a levé l'interdiction de membres initialisés par défaut, et C++17 assoupli celle sur "pas d'héritage"

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astruct+Foo%0A%7B%0A++int+i%3B%0A%7D%3B%0A%0Astruct+Bar+:+Foo%0A%7B%0A++double+l%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++Bar+bar%7B%7B42%7D,+1.25%7D%3B%0A++Bar+baz%7B%7B%7D,+1.25%7D%3B%0A%0A++std::cout+%3C%3C+bar.i+%3C%3C+!'+!'+%3C%3C+bar.l+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+baz.i+%3C%3C+!'+!'+%3C%3C+baz.l+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("p0017")

== Déduction de type et Initializer list

- Évolution des règles de déduction sur les listes entre accolades
  - _Direct initialisation_ : déduction d'une valeur
  // S'il y a une unique valeur. C'est une erreur sinon
  - _Copy initialisation_ : déduction d'un ```cpp initializer_list```
// Si tous les éléments sont du même type. C'est une erreur sinon

```cpp
auto x1 = {1, 2};   // std::initializer_list<int>
auto x2 = {1, 2.0}; // Erreur : types différents
auto x3{1, 2};      // Erreur : multiples elements
auto x4 = {3};      // std::initializer_list<int>
int x = {3};        // int
auto x5{3};         // int
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ccassert%3E%0A%0Aint+main()%0A%7B%0A++%7B%0A++++auto+x+%3D+%7B1,+2%7D%3B%0A++++assert(typeid(x)+%3D%3D+typeid(std::initializer_list%3Cint%3E))%3B%0A++%7D%0A%0A%23if+0%0A++%7B%0A++++auto+x+%3D+%7B1,+2.0%7D%3B%0A++%7D%0A%23endif%0A%0A%23if+0%0A++%7B%0A++auto+x%7B1,+2%7D%3B%0A++%7D%0A%23endif%0A%0A++%7B%0A++++auto+x+%3D+%7B3%7D%3B%0A++++assert(typeid(x)+%3D%3D+typeid(std::initializer_list%3Cint%3E))%3B%0A++%7D%0A%0A++%7B%0A++++int+x+%3D+%7B3%7D%3B%0A++++assert(typeid(x)+%3D%3D+typeid(int))%3B%0A++%7D%0A%0A++%7B%0A++++auto+x%7B3%7D%3B%0A++++assert(typeid(x)+%3D%3D+typeid(int))%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic+-Wno-unused-variable',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("N3922")

== Initialisation des énumérations fortement typées

- Initialisation possible d'```cpp enum class``` avec une constante du type sous-jacent

```cpp
enum class Foo : unsigned int { Invalid = 0 };
Foo foo{42};
Foo bar = Foo{42};
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aenum+class+Foo+:+unsigned+int%0A%7B%0A++Invalid+%3D+0,%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++Foo+foo%7B42%7D%3B%0A++Foo+bar+%3D+Foo%7B42%7D%3B%0A%0A++std::cout+%3C%3C+static_cast%3Cunsigned+int%3E(foo)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+static_cast%3Cunsigned+int%3E(bar)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0138")

== Initialisation des énumérations fortement typées

- Pas de relâchement du typage par ailleurs
- En particulier, pas de copie ni d'affectation depuis un entier

```cpp
Foo foo;
foo = 42;       // Erreur
```

- Ni d'initialisation avec la syntaxe ```cpp =```

```cpp
Foo foo = 42;   // Erreur
Foo bar = {42}; // Erreur
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aenum+class+Foo+:+unsigned+int%0A%7B%0A++Invalid+%3D+0,%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++Foo+foo+%3D+42%3B%0A++Foo+bar+%3D+%7B42%7D%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic+-Wno-unused-variable',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aenum+class+Foo+:+unsigned+int%0A%7B%0A++Invalid+%3D+0,%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++Foo+foo%3B%0A++foo+%3D+42%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0138")

== ``` std::byte```

- Stockage de bits
- Pas un type caractère ni arithmétique
- Remplace les solutions à base de ```cpp unsigned char```
- Supporte les opérations binaires (décalage, et, ou, non)
- Supporte les constructions depuis un type entier
- ... et les conversions vers des entiers (```cpp std::to_integer()```)
- Mais pas les opérations arithmétiques

```cpp
std::byte b{5};
b |= std::byte{2};
b <<= 2;
std::to_integer<unsigned int>(b); // 28-1C
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ccstddef%3E%0A%23include+%3Ciomanip%3E%0A%0Aint+main()%0A%7B%0A++std::byte+b%7B5%7D%3B%0A++std::cout+%3C%3C+std::hex+%3C%3C+std::setw(2)+%3C%3C+std::setfill(!'0!')%3B%0A++std::cout+%3C%3C+std::to_integer%3Cunsigned+int%3E(b)+%3C%3C+!'%5Cn!'%3B%0A%0A++b+%7C%3D+std::byte%7B2%7D%3B%0A++std::cout+%3C%3C+std::hex+%3C%3C+std::setw(2)+%3C%3C+std::setfill(!'0!')%3B%0A++std::cout+%3C%3C+std::to_integer%3Cunsigned+int%3E(b)+%3C%3C+!'%5Cn!'%3B%0A%0A++b+%3C%3C%3D+2%3B%0A++std::cout+%3C%3C+std::hex+%3C%3C+std::setw(2)+%3C%3C+std::setfill(!'0!')%3B%0A++std::cout+%3C%3C+std::to_integer%3Cunsigned+int%3E(b)+%3C%3C+!'%5Cn!'%3B%0A%0A%23if+0%0A++b+%2B%3D+std::byte%7B2%7D%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0298")

== Conteneurs associatifs : déplacement de nœuds

- Déplacement de nœuds entre conteneurs associatifs de même type
- Objet _node handle_ : stockage et accès au nœud
  - Déplaçable mais non copiable
  - Modification possible de la clé
  - Destruction du nœud lors de sa destruction
- ```cpp extract()``` extrait le nœud du premier conteneur
  - Nœud identifié par sa clé ou par un itérateur
  - Retourne un _node handle_
- Surcharge de ```cpp insert()``` prenant un _node handle_ en paramètre
  - Retourne une structure indiquant la réussite ou non de l'insertion
  - ... et, en cas d'échec, le _node handle_

#addproposal("P0083")

== Conteneurs associatifs : déplacement de nœuds

```cpp
map<int, string> foo {{1,"foo1"}, {2,"foo2"}};
map<int, string> bar {{2,"bar2"}};

bar.insert(foo.extract(1));
// foo : {{2,"foo2"}}
// bar : {{1,"foo1"}, {2,"bar2"}}

auto r = bar.insert(foo.extract(2));  // Echec
// foo : {}
// bar : {{1,"foo1"}, {2,"bar2"}}
// r.inserted : false, r.node : {2,"foo2"}

r.node.key() = 3;
bar.insert(r.position, std::move(r.node));
// foo : {}
// bar : {{1,"foo1"}, {2,"bar2"}, {3,"bar2"}}
```

#codesample(
  "https://godbolt.org/#z:OYLghAFBqd5QCxAYwPYBMCmBRdBLAF1QCcAaPECAMzwBtMA7AQwFtMQByARg9KtQYEAysib0QXACx8BBAKoBnTAAUAHpwAMvAFYTStJg1DIApACYAQuYukl9ZATwDKjdAGFUtAK4sGe1wAyeAyYAHI%2BAEaYxHoADqgKhE4MHt6%2BcQlJAkEh4SxRMVy2mPaOAkIETMQEqT5%2BRXaYDskVVQQ5YZHRegqV1bXpDX3twZ353VwAlLaoXsTI7BzmAMzByN5YANQmy25OvcSYrDvYJhoAgitrG5jbuyxMsSdnl2arDOteWztuB8HAzwuL2CBE2D2CEEmLxMAHYrBdNpteugQCAHk9diDSEiCCiQH8jCdNvxUNs4bCLEVzGYSVxqbCACLYilmUjUklmekwhmMnbw86I5Go9E/LE4vEEgHLbCbCJVMlWOGs6ly4icsyc7m85b8l6I1UAOmCSmq1FQqANmFUBGITAcECmUJ1euJJAgaAYvU2TC8RHMADZtgBWCwAa1IADcTEGGZsQK7UFCEQqXYLcai0L67m4fptQ9nc2AOABaIsF3abCPltybMtFvku3nJoUoWagn6FpZBtwMevO5P8YjugRen1%2BsyB6NhyPR2Px1VJgUp5NpvGZ9u7XP5jsVouljjVyuHutLftLptLlvrw/07sMYsP6M9%2Blnl1j0nEO6xw3G6IEM0WlaNp2v%2BZiTE6/KIoOw6eqC74BsG05RjGcYJouiIUqm4oZm2h7bpuu4lmWO41lWJG1gefaQWSPLNumrZZuR9Z3lRLrQR6o6%2BqgCFTuGyFzrKVTocuS6rjhjEETW%2BE5oR%2B6HmRkkURRDbJheYkMRuMk1sxPasXRa64eRLYROaBi0LECBMIexBGp6f6YOgx6UQe5E2QwGCYAaoaYAAnpCTlKa5BruVgBrorEDn%2BUxXa6ae1FXoZinUg%2BxZPgwL66smbkeV5vlRcssbLCpS4/nZpo2fEiRlAw2ItiwqARpgEDZVg4HFVBbocXBXE8SGfGzqhJLCZhK7YRpeFOXJ5EKVpSl6eeWr6eJmmdml80dUOXXej1E6If1KHzkJjbkqNCUSbN0mdlNikzZ2ylnhhi2XvR17RWtcXQk9HDTLQnBBrwfgcFopCoJwOaWNYSKzPMtwrDwpAEJo33TKGIBBho%2BicJIANIyDnC8AoIAY4jQPfaQcCwEgVpNFxZAUBAVTAAoyiGCUQgIKgADugPw2gLCxHQTDVSzIS0OzXOA8DfMC/QMRM8wsQKBzBCkNLdDRKErCLLwauywA8r64vc7j1PIOcxBM/jpCmxU%2BCA7w/CCCIYjsFIMiCIoKjqKTpC6EUBhGCg1jWPoeARITkDTKgsTVYTJbIjsDKmBDlhcDCmzFgA6mItAZ5nQG2hnEXoIYjjILwDXRMQeBYBHkKkMQXiCHgbAACqmXX0wKNDCw9LiwQi2zHPG9wvA2pgizw5ztqxEjP1/TjPugxw2CqDTRCfqoAAc/rFv6kibMAyDIJsEA2k3oaTKf4NWJY2K4IQJDbG8Uxj3P0wIEcWAxPXqPo5jHBsakElhXK2hNibvwAWYRewNl5v1JuBSM0REjOEkEAA",
)

== Fusion de conteneurs associatif

- ```cpp merge()``` fusionne le contenu de conteneurs associatifs

```cpp
map<int, string> foo {{1,"foo1"}, {2,"foo2"}};
map<int, string> bar {{3,"bar2"}};

foo.merge(bar);
// foo : {{1,"foo1"}, {2,"foo2"}, {3,"bar2"}}
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cmap%3E%0A%23include+%3Cstring%3E%0A%0Aint+main()%0A%7B%0A++std::map%3Cint,+std::string%3E+foo+%7B%7B1,%22foo1%22%7D,+%7B2,%22foo2%22%7D%7D%3B%0A++std::map%3Cint,+std::string%3E+bar+%7B%7B3,%22bar2%22%7D%7D%3B%0A%0A++foo.merge(bar)%3B%0A++for(const+auto%26+%5Bk,v%5D+:+foo)%0A++%7B%0A++++std::cout+%3C%3C+k+%3C%3C+!'-!'+%3C%3C+v+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+%22%5Cn%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0083")

== ``` std::map``` et ``` std::unordered_map```

- ```cpp try_emplace()``` tente de construire en place
- ... sans effet, même pas un "vol" de la valeur, si la clé existe déjà
- ```cpp insert_or_assign()``` ajoute ou modifie un élément

```cpp
map<int, string> foo {{1,"foo1"}, {2,"foo2"}};
foo.insert_or_assign(3, "foo3");
// foo : {{1,"foo1"}, {2,"foo2"}, {3,"foo3"}}

foo.insert_or_assign(2, "foo2bis");
// foo : {{1,"foo1"}, {2,"foo2bis"}, {3,"foo3"}}
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cmap%3E%0A%23include+%3Cstring%3E%0A%0Aint+main()%0A%7B%0A++std::map%3Cint,+std::string%3E+foo+%7B%7B1,%22foo1%22%7D,+%7B2,%22foo2%22%7D%7D%3B%0A%0A++foo.insert_or_assign(3,+%22foo3%22)%3B%0A++for(const+auto%26+%5Bk,v%5D+:+foo)%0A++%7B%0A++++std::cout+%3C%3C+k+%3C%3C+!'-!'+%3C%3C+v+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%0A++foo.insert_or_assign(2,+%22foo2bis%22)%3B%0A++for(const+auto%26+%5Bk,v%5D+:+foo)%0A++%7B%0A++++std::cout+%3C%3C+k+%3C%3C+!'-!'+%3C%3C+v+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("n4279")

// !!!!!!!!!!!!!!!!!!!!!!

== ``` emplace_back()```, ``` emplace_front()```

- Retournent une référence sur l'élément ajouté

```cpp
vector<...> foo;

foo.emplace_back(...);                // C++14 et precedents
auto& val = foo.back();

auto& val = foo.emplace_back(...);    // C++17
```

```cpp
vector<vector<int>> foo;
foo.emplace_back(3, 1).push_back(42); // foo : {{1 1 1 42}}
```

#noteblock("Note", text[
  ```cpp emplace()``` renvoie toujours un itérateur
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cstd::vector%3Cint%3E%3E+foo%3B%0A++foo.emplace_back(3,+1).push_back(42)%3B%0A%0A++for(const+auto%26+vec:+foo)%0A++%7B%0A++++for(const+auto+it:+vec)%0A++++%7B%0A++++++std::cout+%3C%3C+it+%3C%3C+%22+%22%3B%0A++++%7D%0A++++std::cout+%3C%3C+%22%5Cn%22%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0084")

== Fonctions libres de manipulation

- ```cpp std::size()```
  - Conteneurs : résultat de la fonction membre ```cpp size()```
  - Tableau C : taille du tableau
  - ```cpp initializer_list``` : résultat de la fonction membre ```cpp size()```
- ```cpp std::empty()```
  - Conteneurs : résultat de la fonction membre ```cpp empty()```
  - Tableau C : ```cpp false```
  - ```cpp initializer_list``` : ```cpp size() == 0```
- ```cpp std::data()```
  - Conteneurs : résultat de la fonction membre ```cpp data()```
  - Tableau C : pointeur sur le premier élément
  - ```cpp initializer_list``` : itérateur sur le premier élément

#addproposal("n4280")

== ``` ContiguousIterator```

- Basé sur ```cpp RandomAccessIterator```
- Mais sur des conteneurs à stockage contigu
- Itérateur associé à
  - ```cpp std::vector```
  - ```cpp std::array```
  - ```cpp std::basic_string```
  - ```cpp std::valarray```
  - Aux tableaux C

#noteblock("Motivations", text[
  Utilisation avec des API C

  Utilisation  de ```cpp memcpy``` et ```cpp memset```
])

#addproposal("n4284")

== Limitation de plage de valeurs

- ```cpp std::clamp()``` ramène une valeur dans une plage donnée
  - Retourne la borne inférieure si la valeur lui est inférieure
  - Retourne la borne supérieure si la valeur lui est supérieure
  - Retourne la valeur sinon

```cpp
clamp(1, 18, 42);   // 18
clamp(54, 18, 42);  // 42
clamp(25, 18, 42);  // 25
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::clamp(1,+18,+42)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::clamp(54,+18,+42)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::clamp(25,+18,+42)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0025")

== ``` std::to_chars()``` et ``` std::from_chars()```

- Conversions entre chaînes C pré-allouées et nombre

```cpp
char str[25];
to_chars(begin(str), end(str), 12.5);

double val;
from_chars(begin(str), end(str), val);
```

- Retournent un pointeur sur la partie non utilisée de la chaîne
// C'est à dire sur le caractères suivant le dernier écrit pour to_chars ou le premier non converti pour from_chars()
- Et un code erreur

#alertblock("API bas-niveau", text[
  Pas d'exception, pas de gestion mémoire, pas de locale
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ccharconv%3E%0A%0Aint+main()%0A%7B%0A++char+str%5B25%5D+%3D+%22%22%3B%0A++std::to_chars(std::begin(str),+std::end(str),+12.5)%3B%0A++std::cout+%3C%3C+str+%3C%3C+%22%5Cn%22%3B%0A%0A++double+val+%3D+0%3B%0A++std::from_chars(std::begin(str),+std::end(str),+val)%3B%0A++std::cout+%3C%3C+val+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0067")

== ``` std::variant```

- Union _type-safe_ contenant une valeur d'un type choisi parmi $n$
- Type contenu dépend de la valeur assignée

#alertblock("Restrictions", text[
  Ne peut pas contenir de références, de tableaux C, ```cpp void``` ni être vide
  // Mais peut contenir plusieurs fois le même type (avec des qualifiers cv identiques ou non)
  // Contenir plusieurs fois le même type peut être utile dans le cadre de code template
  // Mais peut contenir des std::array<> (alternative aux tableaux C) et des std::reference_wrapper<> (alternative aux références)

  ```cpp std::variant``` _default-constructible_ seulement si le premier type l'est
  // Le std::variant contient alors le premier type initialisé par défaut
])

#noteblock(text[``` std::monostate```], text[
  Permet d'émuler des ```cpp std::variant``` vides
  // Les ```cpp std::variant``` vides peuvent être utile dans le cas de code template

  Rend un ```cpp std::variant``` _default constructible_
  // Si std::monostate est le premier élément du std::variant, celui-ci devient default-constructible
])

#adviceblock("Do", text[
  Préférez ```cpp std::variant``` aux unions brutes
])

#addproposal("P0088")

== ``` std::variant```

- ```cpp get<>()``` récupère la valeur depuis l'index ou le nom du type
- Et lève une exception si le type demandé n'est pas correct
- ```cpp get_if<>()``` retourne un pointeur sur la valeur ou ```cpp nullptr```
- ```cpp std::holds_alternative<>()``` teste le type contenu
- ```cpp index()``` retourne l'index d'un type donnée
- Construction en-place

```cpp
variant<int, float, string> v{in_place_index<0>, 10};
```

#addproposal("P0088")

== ``` std::variant```

```cpp
variant<int, float, string> v, w;
v = "xyzzy";         // string
v = 12;              // int

int i = get<int>(v); // ok

w = get<int>(v);     // ok, assignation
w = get<0>(v);       // ok, assignation
w = v;               // ok, assignation

get<double>(v);      // erreur de compilation
get<3>(v);           // erreur de compilation

get<float>(w);       // exception : w contient un int
```

#codesample(
  "https://godbolt.org/#z:OYLghAFBqd5QCxAYwPYBMCmBRdBLAF1QCcAaPECAMzwBtMA7AQwFtMQByARg9KtQYEAysib0QXACx8BBAKoBnTAAUAHpwAMvAFYTStJg1DIApACYAQuYukl9ZATwDKjdAGFUtAK4sGe1wAyeAyYAHI%2BAEaYxHoADqgKhE4MHt6%2BcQlJAkEh4SxRMVy2mPaOAkIETMQEqT5%2BRXaYDskVVQQ5YZHRegqV1bXpDX3twZ353VwAlLaoXsTI7BzmAMzByN5YANQmy25OvcSYrDvYJhoAgitrG5jbuwfBwCdnl2arDOteWztuAG5NRGIzwuVw%2BNzufyqeEMBGBlwuwQImxYTGCEEmLxMAHYrBdNpteugQCBflCYT9EaRNlRaKgmAQqYTiQ8jCdNr8qQB3Ha4874353AAi2zMZlUAE8AF6S8XmMw8l74wmbYloLxIn4/AkEIkgYCYWH3HXMgjER4nCC/SYQrVgJYAVjcDDtCpBePZQs2XHly15Sp1KpQsw1uy1TL1BopggtVptu02LsdzqWvsx7s5nvD%2BsNe2jy2wloxqfdytVwbjbm1uuzUcNBc51s18cTTpdxfhfM2GZ2wqzkd2GhjRb9VcDapDbjDxojOcRFobFYTDtbKd5iq7nt%2Brs7paD6sXfdnefrjdDzeXye3mLeeCom0HJenNd26FmEXoQ%2B3/ur/bcy0/7YrK4t5pq8qx3g%2BO5Pr%2BNJ0nWEANlebzAVQmJYoKLwcNMtCcPavB%2BBwWikKgnCTpY1gErM8y3CsPCkAQmhYdMADWID2ho%2BicJI%2BGMcRnC8AoIAcQxhFYaQcCwEgmCqE06okOQlBVMACjKIYJRCAgqCcgRdFoCwsR0PSySqSEtAaVpBFEXpBn0DEynMLECiaQy1l0NEoSsIsvCubZADy6rmdpvHSU05zEMp/GkCFyAVPgBG8PwggiGI7BSDIgiKCo6iiaQuhFAYRgoNY1j6HgESCZA0yoLEZQMIJHAALSEj2pjkZYXBYpsDUAOpiLQXXddJppMF1sSYOgMJ4MgvCoP8xBmlgFXoqQxBeIIeBsAAKqgnhLdMChUQsPQ6sEJnqZpQXcLwpqYIsdGcsQTCxIx2G4TxOUkRw2AycgcnEJsqgABwAGwNcDkibMAyDIJsECmmtzHWhAZFWJYVK4IQJAissUzXS90wIEcWAxMtrHsZxHDcaQlkzZFgnCfjFNmO9RGfXjomTNMc2JM4khAA",
)

#addproposal("P0088")

== ``` std::variant```

- ```cpp std::visit()``` permet l'appel sur le type réellement contenu

```cpp
vector<variant<int, string>> v{5, 10, "hello"};

for(auto item : v)
  visit([](auto&& arg){cout << arg;}, item);
```

#alertblock("Attention", text[
  Appelable valide pour tous les types du ```cpp std::variant```
  // Et ce peut être une structure/classe présentant une surcharge de operator() pour chacun des types}
])

#noteblock("Alternative à C++17", text[
  Utilisez ```cpp Boost.Variant```
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cvariant%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cstd::variant%3Cint,+std::string%3E%3E+v%7B5,+10,+%22hello%22%7D%3B%0A%0A++for(auto+item+:+v)%0A++%7B%0A++++std::visit(%5B%5D(auto%26%26+arg)%7Bstd::cout+%3C%3C+arg+%3C%3C+!'+!'%3B%7D,+item)%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0088")

== Pack expansion sur ``` using```

- Expansion du _parameter pack_ dans les _using declaration_

```cpp
struct Foo {
  int operator()(int i) { return 10 + i; }
};

struct Bar {
  int operator()(const string& s) { return s.size(); }
};

template <typename... Ts> struct Baz : Ts... {
  using Ts::operator()...;
};

Baz<Foo, Bar> baz;
baz(5);        // 15
baz("azerty"); // 6
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%0Astruct+Foo%0A%7B%0A++int+operator()(int+i)%0A++%7B%0A++++return+10+%2B+i%3B%0A++%7D%0A%7D%3B%0A%0Astruct+Bar%0A%7B%0A++int+operator()(const+std::string%26+s)%0A++%7B%0A++++return+s.size()%3B%0A++%7D%0A%7D%3B%0A%0Atemplate+%3Ctypename...+Ts%3E%0Astruct+Baz+:+Ts...%0A%7B%0A++using+Ts::operator()...%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++Baz%3CFoo,+Bar%3E+baz%3B%0A++std::cout+%3C%3C+baz(5)+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+baz(%22azerty%22)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0195")

== Fold expression

- Application d'un opérateur binaire à un _parameter pack_
- Support du _right fold_ et du _left fold_

```cpp
(pack op ...);  // right fold
(... op pack);  // left fold
```

- Éventuellement avec un valeur initiale

```cpp
(pack op ... op init);
(init op ... op pack);
```

#addproposal("P0036")

== Fold expression

#columns(2)[#align(center)[
    #block(stroke: 0.05em + black, inset: (x: 1em, bottom: 1em, top: 0.5em), radius: 0.4em, text[_Right fold_
      #v(2em)

      #diagram(spacing: (0.5em, 0.5em), {
        node((0, 1), "1")
        node((1, 0), "f")
        node((2, 1), "f")
        node((1, 2), "2")
        node((3, 2), "f")
        node((2, 3), "3")
        node((4, 3), "f")
        node((3, 4), "4")
        node((5, 4), "z")

        edge((0, 1), (1, 0))
        edge((1, 0), (2, 1))
        edge((1, 2), (2, 1))
        edge((2, 1), (3, 2))
        edge((2, 3), (3, 2))
        edge((3, 2), (4, 3))
        edge((3, 4), (4, 3))
        edge((4, 3), (5, 4))
      })])
  ]
  #colbreak()

  #align(center)[
    #block(stroke: 0.05em + black, inset: (x: 1em, bottom: 1em, top: 0.5em), radius: 0.4em, text[
      _Left fold_
      #v(2em)

      #diagram(spacing: (0.5em, 0.5em), {
        node((0, 4), "z")
        node((1, 3), "f")
        node((2, 4), "1")
        node((2, 2), "f")
        node((3, 3), "2")
        node((3, 1), "f")
        node((4, 2), "3")
        node((4, 0), "f")
        node((5, 1), "4")

        edge((0, 4), (1, 3))
        edge((2, 4), (1, 3))
        edge((1, 3), (2, 2))
        edge((2, 2), (3, 3))
        edge((2, 2), (3, 1))
        edge((3, 1), (4, 2))
        edge((3, 1), (4, 0))
        edge((4, 0), (5, 1))
      })])]]

#addproposal("P0036")

== Fold expression

```cpp
template<typename... Args>
bool all(Args... args) { return (... && args); }

bool b = all(true, true, true, false);
// ((true && true) && true) && false
```

```cpp
template<typename... Args>
long long sum(Args... args) { return (args + ...); }

long long b = sum(1, 2, 3, 4);
// 1 + (2 + (3 + 4))
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Atemplate%3Ctypename...+Args%3E%0Along+long+sum(Args...+args)%0A%7B%0A++return+(args+%2B+...)%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+sum(1,+2,+3,+4)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Atemplate%3Ctypename...+Args%3E%0Abool+all(Args...+args)%0A%7B%0A++return+(...+%26%26+args)%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+all(true,+true,+true,+false)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0036")

== Fold expression

#alertblock(text[_left fold_ ou _right fold_ ?], text[
  ```cpp
  template<typename... Args>
  double div(Args... args) { return (... / args); }

  div(1.0, 2.0, 3.0);      // 0.166667
  // (1.0 / 2.0) / 3.0
  ```

  ```cpp
  template<typename... Args>
  double div(Args... args) { return (args / ...); }

  div(1.0, 2.0, 3.0);      // 1.5
  // 1.0 / (2.0 / 3.0)
  ```
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Atemplate%3Ctypename...+Args%3E%0Adouble+ldiv(Args...+args)%0A%7B%0A++return+(...+/+args)%3B%0A%7D%0A%0Atemplate%3Ctypename...+Args%3E%0Adouble+rdiv(Args...+args)%0A%7B%0A++return+(args+/+...)%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+ldiv(1.0,+2.0,+3.0)+%3C%3C+!'+!'+%3C%3C+rdiv(1.0,+2.0,+3.0)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0036")

== Fold expression

- Si le _parameter pack_ est vide, le résultat est
  - ```cpp true``` pour l'opérateur ```cpp &&```
  - ```cpp false``` pour l'opérateur ```cpp ||```
  - ```cpp void()``` pour l'opérateur ```cpp ,```

#alertblock("Attention", text[
  Un _parameter pack_ vide est une erreur pour les autres opérateurs
])

#addproposal("P0036")

== Fold expression

- Compatible avec des opérateurs non arithmétiques ni logiques

```cpp
template<typename ...Args>
void FoldPrint(Args&&... args) {
  (cout << ... << forward<Args>(args)) << '\n'; }

FoldPrint(10, 'a', "ert"s);
```

- Y compris "```cpp ,```" qui va donner une séquence d'actions

```cpp
template<typename T, typename... Args>
void push_back_vec(std::vector<T>& v, Args&&... args) {
  (v.push_back(args), ...); }

vector<int> foo;
push_back_vec(foo, 10, 20, 56);
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Atemplate%3Ctypename+T,+typename...+Args%3E%0Avoid+push_back_vec(std::vector%3CT%3E%26+v,+Args%26%26...+args)%0A%7B%0A++(v.push_back(args),+...)%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%3B%0A++push_back_vec(foo,+10,+20,+56)%3B%0A++for(auto+i+:+foo)%0A++%7B%0A++++std::cout+%3C%3C+i+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%0Ausing+namespace+std::literals%3B%0A%0Atemplate%3Ctypename+...Args%3E%0Avoid+FoldPrint(Args%26%26...+args)%0A%7B%0A++(std::cout+%3C%3C+...+%3C%3C+std::forward%3CArgs%3E(args))+%3C%3C+!'%5Cn!'%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++FoldPrint(10,+!'a!',+%22ert%22s)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0036")

== Contraintes du range-based for loop

- Utilisation possible de types différents pour ```cpp begin``` et ```cpp end```
- Permet de traiter des paires d'itérateurs
- ... mais aussi un itérateur et une taille
- ... ou un itérateur et une sentinelle de fin
- Compatible avec les travaux sur Range TS

#addproposal("P0184")

== Héritage de constructeurs

- Visibilité des constructeurs hérités avec leurs paramètres par défaut
// En C++11, les constructeurs avec paramètres par défaut (ou ellipses) étaient injectés en omettant valeurs par défaut (version avec le paramètre sans valeur par défaut et version sans le paramètre) et ellipse
- Comportement identique aux autres fonctions héritées
// Le choix C++11 posait davantage de problèmes (pas de redéfinition avec valeur par défaut possible, multiples constructeurs par copie/déplacement, erreur de SFINAE, etc.)

#alertblock("Compatibilité", text[
  Casse du code C++11 valide
])

```cpp
struct Foo { Foo(int a, int b = 0); };
struct Bar : Foo { Bar(int a); using Foo::Foo; };
struct Baz : Foo { Baz(int a, int b = 0); using Foo::Foo; };

Bar bar(0); // Ambigu (OK en C++11)
Baz baz(0); // OK (Ambigu en C++11)
```

#addproposal("P0136")

== ``` noexcept```

- ```cpp noexcept``` fait partie du type des fonctions

```cpp
void use_func(void (*func)() noexcept);
void my_func();

use_func(&my_func);       // Ne compile plus
```

// Une surcharge sans ```cpp noexcept``` doit être ajoutée

- Les fonctions ```cpp noexcept``` peuvent être convertie en fonctions non ```cpp noexcept```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23if+1%0Avoid+use_func(void+(*func)()+noexcept)%0A%23else%0Avoid+use_func(void+(*func)())%0A%23endif%0A%7B%7D%0A%0Avoid+my_func()%0A%7B%7D%0A%0Aint+main()%0A%7B%0A++use_func(%26my_func)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic+-Wno-unused-parameter',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0012")

== ``` std::uncaught_exceptions()```

- Retourne le nombre d'exceptions lancées (ou relancées) et non encore attrapées du thread courant

```cpp
if(uncaught_exceptions())
{ ... }
```

#noteblock("Motivation", text[
  Comportement différent d'un destructeur en présence d'exception
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cexception%3E%0A%0Astruct+Foo%0A%7B%0A++Foo()+%3D+default%3B%0A++~Foo()%0A++%7B%0A++++std::cout+%3C%3C+std::uncaught_exceptions()%3B%0A++%7D%0A%7D%3B%0A%0Avoid+bar()%0A%7B%0A++Foo+foo%3B%0A%23if+0%0A++throw+std::exception()%3B%0A%23endif%0A%7D%0A%0Aint+main()%0A%7B%0A++try%0A++%7B%0A++++bar()%3B%0A++%7D%0A++catch(...)%0A++%7B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("N4259")

== Caractères littéraux UTF-8

- Caractère UTF-8 préfixé par ```cpp u8```
- Erreur si le caractère n'est pas représentable par un unique code point UTF-8

```cpp
char x = u8'x';
```

#addproposal("N4267")

== Déduction de template dans les constructeurs

- Déduction des paramètres templates d'une classe à la construction
- Plus de déclaration explicite des paramètres templates
- Ni de _make helpers_
// Avant la déduction ne fonctionnait que pour les fonctions membres, pas pour les constructeurs

```cpp
pair p(2, 4.5);     // pair<int, double> p(2, 4.5);
tuple t(4, 3, 2.5); // auto t = make_tuple(4, 3, 2.5);
```

#alertblock("Attention", text[
  Ne permet pas la déduction partielle

  ```cpp
  tuple<int> t(1, 2, 3);  // Erreur
  ```
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ctuple%3E%0A%23include+%3Cutility%3E%0A%0Aint+main()%0A%7B%0A++std::pair+p(2,+4.5)%3B%0A++std::tuple+t(4,+3,+2.5)%3B%0A++std::cout+%3C%3C+p.second+%3C%3C+%22+%22+%3C%3C+std::get%3C0%3E(t)+%3C%3C+%22%5Cn%22%3B%0A%0A%23if+0%0A++std::tuple%3Cint%3E+t(1,+2,+3)%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0091")

== Déduction de template dans les constructeurs

- Permet de fournir une lambda en paramètre template sans la déclarer

```cpp
template<class Func> struct Foo {
  Foo(Func f) : func(f) {}
  Func func;
};

Foo([&](int i) { ... });
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ctuple%3E%0A%23include+%3Cutility%3E%0A%0Atemplate%3Cclass+Func%3E+struct+Foo%0A%7B%0A++Foo(Func+f)+:+func(f)%0A++%7B%0A++%7D%0A%0A++void+operator()+(int+i)%0A++%7B%0A++++func(i)%3B%0A++%7D%0A%0A++Func+func%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++int+a+%3D+2%3B%0A++Foo+foo(%5B%26%5D(int+i)+%7Bstd::cout+%3C%3C+a+*+i+%3C%3C+!'%5Cn!'%3B%7D)%3B%0A++foo(5)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0091")

== ``` template <auto>```

- Déduction du type des paramètres templates numériques

```cpp
template <auto value> void foo() {}
foo<10>();  // int
```

```cpp
template <typename Type, Type value> constexpr Type FOO = value;
constexpr auto const foo = FOO<int, 100>;

// Devient

template <auto value> constexpr auto FOO = value;
constexpr auto foo = FOO<100>;
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Atemplate+%3Cauto+value%3E+constexpr+auto+FOO+%3D+value%3B%0A%0Aint+main()%0A%7B%0A++constexpr+auto+foo+%3D+FOO%3C100%3E%3B%0A++std::cout+%3C%3C+foo+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0127")

== Template et contraintes d'utilisation

- ```cpp typename``` autorisé dans les déclarations de _template template parameters_

```cpp
template <template <typename> typename C, typename T>
//                            ^^^^^^^^
struct Foo { C<T> data; };

Foo<vector, int> bar;
```

// Auparavant, il fallait obligatoirement utiliser class, alors que typename était valide partout ailleurs

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Atemplate+%3Ctemplate+%3Ctypename%3E+typename+C,+typename+T%3E%0Astruct+Foo%0A%7B%0A++C%3CT%3E+data%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++Foo%3Cstd::vector,+int%3E+bar%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Capture de ``` *this```

- Capture ```cpp *this``` par valeur

```cpp
[*this]() { ... }
[=, *this]() { ... }
```

```cpp
struct Foo {
  auto bar() { return [*this] { cout << s << '\n'; }; }
  string s;
};

auto baz = Foo{"baz"}.bar();
baz();     // Affiche baz
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%0Astruct+Foo%0A%7B%0A++auto+bar()%0A++%7B%0A++++return+%5B*this%5D+%7B+std::cout+%3C%3C+s+%3C%3C+!'%5Cn!'%3B+%7D%3B%0A++%7D%0A%0A++std::string+s%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++auto+baz+%3D+Foo%7B%22baz%22%7D.bar()%3B%0A++baz()%3B%0A%7D'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0018")

== Lambdas et expressions constantes

- Lambdas autorisées dans les expressions constantes
- Si l'initialisation de chaque capture est possible dans l'expression constante

```cpp
constexpr int AddEleven(int n) {
  return [n] { return n + 11; }();
}

AddEleven(5);   // 16
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aconstexpr+int+AddEleven(int+n)%0A%7B%0A++return+%5Bn%5D+%7B+return+n+%2B+11%3B+%7D()%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+AddEleven(5)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0170")

== Lambdas et expressions constantes

- Déclaration ```cpp constexpr``` de lambda possible
- Explicitement via ```cpp constexpr```

```cpp
auto ID = [] (int n) constexpr { return n; };
constexpr int I = ID(3);
```

- Implicitement ```cpp constexpr``` lorsque les exigences sont satisfaites

```cpp
auto ID = [] (int n) { return n; };
constexpr int I = ID(3);
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++auto+ID+%3D+%5B%5D+(int+n)+%7B+return+n%3B+%7D%3B%0A++constexpr+int+I+%3D+ID(3)%3B%0A++std::cout+%3C%3C+I+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++auto+ID+%3D+%5B%5D+(int+n)+constexpr+%7B+return+n%3B+%7D%3B%0A++constexpr+int+I+%3D+ID(3)%3B%0A++std::cout+%3C%3C+I+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0170")

== Lambdas et expressions constantes

- Fermeture de type littéral si les données sont des littéraux

```cpp
constexpr auto add = [] (int n, int m) {
  auto L = [=] { return n; };
  auto R = [=] { return m; };
  return [=] { return L() + R(); };
};

add(3, 4)()   // 7
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++constexpr+auto+add+%3D+%5B%5D+(int+n,+int+m)%0A++%7B%0A++++auto+L+%3D+%5B%3D%5D+%7B+return+n%3B+%7D%3B%0A++++auto+R+%3D+%5B%3D%5D+%7B+return+m%3B+%7D%3B%0A++++return+%5B%3D%5D+%7B+return+L()+%2B+R()%3B+%7D%3B%0A++%7D%3B%0A%0A++std::cout+%3C%3C+add(3,+4)()+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0170")

== ``` std::invoke()```

- Appelle l'appelable fourni en paramètre
- ... en fournissant la liste de paramètres
- ... et en retournant le retour de l'appelable

```cpp
int foo(int i) {
  return i + 42;
}

invoke(&foo, 8);  // 50
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cfunctional%3E%0A%0Aint+foo(int+i)%0A%7B%0A++return+i+%2B+42%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::invoke(%26foo,+8)+%3C%3C+%22%5Cn%22%3B++//+50%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("n4169")

== ``` std::invoke()```

- Fonctionne également avec des fonctions membres
- ... le premier paramètre fourni est l'objet à utiliser

```cpp
struct Foo {
  int bar(int i) { return i + 42; }
};

Foo foo;
invoke(&Foo::bar, foo, 8);  // 50
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cfunctional%3E%0A%0Astruct+Bar%0A%7B%0A++int+baz(int+i)%0A++%7B%0A++++return+i+%2B+42%3B%0A++%7D%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++Bar+bar%3B%0A++std::cout+%3C%3C+std::invoke(%26Bar::baz,+bar,+8)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("n4169")

== ``` std::not_fn()```

- Construction de _function object_ en niant un appelable

```cpp
bool LessThan10(int a) { return a < 10; }

vector<int> foo = { 1, 6, 3, 8, 14, 42, 2 };
count_if(begin(foo), end(foo), not_fn(LessThan10)); // 2
```

#noteblock("Dépréciation", text[
  Dépréciation de ```cpp std::not1``` et ```cpp std::not2```
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%23include+%3Cfunctional%3E%0A%0Abool+LessThan10(int+a)%0A%7B%0A++return+a+%3C+10%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo+%3D+%7B+1,+6,+3,+8,+14,+42,+2+%7D%3B%0A++std::cout+%3C%3C+std::count_if(begin(foo),+end(foo),+std::not_fn(LessThan10))+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("p0005")
#addproposal("p0358")

== Alias de traits

- Ajout du suffixe ```cpp _v``` aux traits de la forme ```cpp is_...```
- Suppression de ```cpp ::value```

```cpp
template <typename T>
enable_if_t<is_integral<T>::value, T>
sqrt(T t);

// Devient

template <typename T>
enable_if_t<is_integral_v<T>, T>
sqrt(T t);
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ccmath%3E%0A%0Atemplate+%3Ctypename+T%3E%0Astd::enable_if_t%3Cstd::is_integral_v%3CT%3E,+T%3E%0Asqrt(T+t)%0A%7B%0A++return+std::sqrt(t)%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+sqrt(25)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0006")

== Nouveaux traits

- Nouveaux traits
  - ```cpp is_swappable_with```, ```cpp is_swappable```, ```cpp is_nothrow_swappable_with``` et ```cpp is_nothrow_swappable``` : objets échangeables
  - ```cpp is_callable``` et ```cpp is_nothrow_callable``` : objet appelable
  - ```cpp void_t``` conversion en ```cpp void```
- Méta-fonctions sur les traits
  - ```cpp std::conjunction``` : et logique entre traits
  - ```cpp std::disjunction``` : ou logique entre traits
  - ```cpp std::negation``` : négation d'un trait

```cpp
// foo disponible si tous ls Ts... ont le meme type
template<typename T, typename... Ts>
enable_if_t<conjunction_v<is_same<T, Ts>...>>
foo(T, Ts...) {}
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ctype_traits%3E%0A%0Atemplate%3Ctypename+T,+typename...+Ts%3E%0Astd::enable_if_t%3Cstd::conjunction_v%3Cstd::is_same%3CT,+Ts%3E...%3E%3E%0Afoo(T,+Ts...)%0A%7B%7D%0A%0Aint+main()%0A%7B%0A++foo(5,+12,+8,+65)%3B%0A%23if+0%0A++foo(5,+12,+8.,+65)%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0185")
#addproposal("P0013")

== Gestion des attributs

- Usage étendu aux déclarations de ```cpp namespace```

```cpp
namespace [[ Attribut ]] foo {}
```

- Et aux valeurs d'une énumération

```cpp
enum foo {
  FOO_1 [[ Attribut ]],
  FOO_2
};
```

#addproposal("N4266")

== Gestion des attributs

- Attributs inconnus doivent être ignorés
// Clarification de la norme, auparavant un compilateur pouvait lever une erreur car rien n'était précisé
- ```cpp using``` des attributs non standards

```cpp
[[ nsp::kernel, nsp::target(cpu,gpu) ]]
foo();

// Devient

[[ using nsp: kernel, target(cpu,gpu) ]]
foo();
```

#addproposal("P0283")
#addproposal("P0028")

== Attribut ``` [[ fallthrough ]]```

- Dans un ```cpp switch``` avant un ```cpp case``` ou ```cpp default```
- Indique qu'un cas se poursuit intentionnellement dans le cas suivant
- Incitation à ne pas lever d'avertissement dans ce cas

```cpp
switch(foo) {
  case 1:
  case 2:
    ...
[[ fallthrough ]];
  case 3:   // Idealement : pas de warning
    ...
  case 4:   // Idealement : warning
    ...
    break;
}
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++int+foo+%3D+1%3B%0A%0A++switch(foo)%0A++%7B%0A++++case+1:%0A++++case+2:%0A++++++std::cout+%3C%3C+%22Cas+1-2%5Cn%22%3B%0A%23if+1%0A++++++%5B%5B+fallthrough+%5D%5D%3B%0A%23endif%0A%0A++++case+3:%0A++++++std::cout+%3C%3C+%22Cas+3%5Cn%22%3B%0A%0A++++case+4:%0A++++++std::cout+%3C%3C+%22Cas+4%5Cn%22%3B%0A++++++break%3B%0A%0A++++default:%0A++++++std::cout+%3C%3C+%22Cas+default%5Cn%22%3B%0A++++++break%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0188")

== Attribut ``` [[ nodiscard ]]```

- Indique qu'un retour de fonction ne devrait pas être ignorée
- Incitation à lever un avertissement dans le cas contraire
- Sur la déclaration de fonction

```cpp
[[ nodiscard ]] int foo() { return 5; }

foo();  // Idealement : warning
```

#noteblock("Note", text[
  Conversion implicite en ```cpp void``` pour supprimer l'avertissement

  ```cpp
  (void)foo();
  ```
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0A%5B%5B+nodiscard+%5D%5D+static+int+foo()%0A%7B%0A++return+5%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++foo()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0189")

== Attribut ``` [[ nodiscard ]]```

- ... ou sur un type (classe, structure ou énumération)

```cpp
struct [[ nodiscard ]] Bar {};
Bar baz() { return Bar{}; }

baz();  // Idealement : warning
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astruct+%5B%5B+nodiscard+%5D%5D+Bar%0A%7B%0A%7D%3B%0A%0Astatic+Bar+baz()%0A%7B%0A++return+Bar%7B%7D%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++baz()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0189")

== Attribut ``` [[ maybe_unused ]]```

- Sur une classe, structure, fonction, variable, paramètre, ...
- Indique qu'un élément peut ne pas être utilisé
- Incitation à ne pas lever d'avertissement en cas de non-utilisation

```cpp
[[ maybe_unused ]]
int foo([[ maybe_unused ]] int a,
        [[ maybe_unused ]] long b) {}
```

#noteblock("Avant C++17", text[
  Ne pas nommer les paramètres non utilisés
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0A%23if+0%0A%5B%5B+maybe_unused+%5D%5D+static+int+foo(%5B%5B+maybe_unused+%5D%5Dint+a,%0A++++++++++++++++++++++++++++++++++%5B%5B+maybe_unused+%5D%5D+int+b)%0A%23else%0Astatic+int+foo(int+a,%0A+++++++++++++++int+b)%0A%23endif%0A%7B%0A++return+0%3B%0A%7D%0A%0Aint+main()%0A%7B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0212")

== Attributs C++17 - Conclusion

#adviceblock("Do", text[
  Utilisez les attributs pour indiquer vos intentions
  // Au delà de l'information pour le compilateur et d'autres outils, c'est aussi une documentation à l'intention des lecteurs et correcteurs
])

#noteblock("Au delà du compilateur", text[
  Prise en compte par d'autres outils souhaitable
])

== ``` std::shared_mutex```

- Similaire à ```cpp std::mutex``` avec deux niveaux d'accès
  - Exclusif : possible si le verrou n'est pas pris
  - Partagé : possible si le verrou n'est pas pris en exclusif
- API identique à ```cpp std::mutex``` pour l'accès exclusif
- API similaire pour l'accès partagé
  - ```cpp lock_shared```
  - ```cpp try_lock_shared```
  - ```cpp unlock_shared```

#noteblock("Note", text[
  Équivalent _non-timed_ de ```cpp std::shared_timed_mutex```
])

#addproposal("N4508")

== ``` std::scoped_lock```

- Acquisition de plusieurs mutex

```cpp
mutex first_mutex;
mutex second_mutex;

scoped_lock lck(first_mutex, second_mutex);
```

#addproposal("P0156")

== ``` std::apply()```

- Appel de fonction depuis un _tuple-like_ d'argument

```cpp
void foo(int a, long b, string c) { ... }

tuple bar{42, 5L, "bar"s};
apply(foo, bar);
```

- Fonctionne sur tout ce qui supporte ```cpp std::get()``` et ```cpp std::tuple_size```
- Notamment ```cpp std::pair``` et ```cpp std::array```

```cpp
void foo(int a, int b, int c) { ... }

array<int, 3> bar{1, 54, 3};
apply(foo, bar);
```

- ```cpp std::make_from_tuple()``` construit un objet depuis un _tuple-like_

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Carray%3E%0A%0Astatic+void+foo(int+a,+int+b,+int+c)%0A%7B%0A++std::cout+%3C%3C+a+%3C%3C+!'+!'+%3C%3C+b+%3C%3C+!'+!'+%3C%3C+c+%3C%3C+!'%5Cn!'%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::array%3Cint,+3%3E+bar%7B42,+5,+12%7D%3B%0A++std::apply(foo,+bar)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ctuple%3E%0A%23include+%3Cstring%3E%0A%0Ausing+namespace+std::literals%3B%0A%0Astatic+void+foo(int+a,+long+b,+std::string+c)%0A%7B%0A++std::cout+%3C%3C+a+%3C%3C+!'+!'+%3C%3C+b+%3C%3C+!'+!'+%3C%3C+c+%3C%3C+!'%5Cn!'%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::tuple+baz%7B42,+5L,+%22bar%22s%7D%3B%0A++std::apply(foo,+baz)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0220")

== ``` std::optional```

- Gestion d'objet dont la présence est optionnelle

#alertblock("Restriction", text[
  Ne peut pas contenir des références, des tableaux C, ```cpp void``` ni être vide
])

- Interface similaire à un pointeur
  - Testable via ```cpp operator bool()```
  - Accès à l'objet via ```cpp operator*```
  - Accès à un membre via ```cpp operator->```

#alertblock("Attention", text[
  ```cpp operator*``` ou ```cpp operator->``` indéfini sur un ```cpp std::optional``` vide
])


#list(marker: [ ], text[
  - ```cpp std::nullopt``` indique l'absence de l'objet
])

#addproposal("P0220")

== ``` std::optional```

- ```cpp value()``` retourne la valeur ou lève l'exception ```cpp std::bad_optional_access```
- ```cpp value_or()``` retourne la valeur ou une valeur par défaut

#codesample(
  "https://godbolt.org/#z:OYLghAFBqd5QCxAYwPYBMCmBRdBLAF1QCcAaPECAMzwBtMA7AQwFtMQByARg9KtQYEAysib0QXACx8BBAKoBnTAAUAHpwAMvAFYTStJg1DIApACYAQuYukl9ZATwDKjdAGFUtAK4sGe1wAyeAyYAHI%2BAEaYxHoADqgKhE4MHt6%2BcQlJAkEh4SxRMVy2mPaOAkIETMQEqT5%2BRXaYDskVVQQ5YZHRegqV1bXpDX3twZ353VwAlLaoXsTI7BzmAMzByN5YANQmy25OvcSYrDvYJhoAgitrG5jbu6ixZcy0J2eXF71MjsibveggIAeTzEOz2ghOm34qAgwQImyYkzeJgA7FYLptNngqBAmHdsJsNIj0RjNocCHMGPCdmjzhiSko3iTSZhycRKX8AQwvLRaEDqUjkQARJEXWGbFhMYIQImXVGM7Zy4kYjmAx7JMSbCJVO6CyGoaGSMyI5Y0plYiBa4gypnKgj/FCzOGg0GbABUlrubhdYCWAFY3AwffylZt6Zh5UyVWgvE7di7zGYAG54LAmf0MBPB960kkqoHq2iapgALx1euhAFojVmzditcXrTao47PS73SXW7tNkH00GTRHQ7QGSHbfbo7GvV2E8nU%2BnM/3iSjhRd5SjTbm7QD8wINR6drqoRAq8b1xiCMQAJ4DtcD0cA8edtxF4gAOkTYi8mGlj%2B7foDfdPBVlxzDFRAIZAEAgNAGF6X5NxALV0AAfW3Z4kKYZAFgUBRzAANlDRsMRvEc4LHFtnS7TAXwAdwQL5vwop8e3/JYFxAoDVyFEUc2I9i8zVHdCz3ZYD31I9qzYyN4IfRjnzfD9MBQ4gIENSYf2YwNWPXJduJ0i4OGmWhOF9Xg/A4LRSFQTgvUsaxflmeZbhWHhSAITQDOmABrEBfQ0fROEkUz3MszheAUEA/Lc8yDNIOBYCQTBVCaGMSHISgqmABRlEMEohAQVBqLMly0BYWI6C%2BZJspCWg8oKsyLJKsr6BiTLmFiBR8oIUhGroaJQlYRZeB65qAHkY1qwrgsSppzmITLQtIabkAqfAzN4fhBBEMR2CkGRBEUFR1Gi0hdCKAwjBQaxrH0PAInCyBplQ8KOArP591MWzLC4ZFNgrAB1MRC3%2BxLz1xCtYkwdBDG%2BXhUETaJiBTTB7ulUhiC8QQ8DYAAVfUh3gaYFAchYejtYIqty/LJu4Xhz0wRYXOo4gmFidzDOMoLjqsjhsCS5AUuITZVAADlwitcMkTZgEwzYIHPDHPLUiAbKsSxSE2XBCBIbYzGWKZabZ6YECOLAYlR7zfP8jhAtIerYYW8LIsNq2zE5izuYN6LJmmeHiESZxJCAA%3D",
)

#addproposal("P0220")

== ``` std::optional```

- Supporte la déduction de type

```cpp
optional foo(10);  // std::optional<int>
```

- Supporte la construction en-place

```cpp
optional<complex<double>> foo{in_place, 3.0, 4.0};
```

- Y compris depuis un ```cpp std::initializer_list```

```cpp
	optional<vector<int>> foo(in_place, {1, 2, 3});
```

- Existence du _helper_ ```cpp std::make_optional```

```cpp
auto foo = make_optional(3.0);
auto bar = make_optional<complex<double>>(3.0, 4.0);
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Coptional%3E%0A%23include+%3Cutility%3E%0A%23include+%3Ccomplex%3E%0A%0Aint+main()%0A%7B%0A++auto+foo+%3D+std::make_optional%3Cstd::complex%3Cdouble%3E%3E(5.0,+6.0)%3B%0A++std::cout+%3C%3C+*foo+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Coptional%3E%0A%23include+%3Cutility%3E%0A%23include+%3Cvector%3E%0A%0Aint+main()%0A%7B%0A++std::optional%3Cstd::vector%3Cint%3E%3E+bar(std::in_place,+%7B1,+2,+3%7D)%3B%0A++for(const+auto+it+:+*bar)%0A++++std::cout+%3C%3C+it+%3C%3C+!'+!'%3B%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Coptional%3E%0A%23include+%3Cutility%3E%0A%23include+%3Ccomplex%3E%0A%0Aint+main()%0A%7B%0A++std::optional%3Cstd::complex%3Cdouble%3E%3E+foo%7Bstd::in_place,+3.0,+4.0%7D%3B%0A++std::cout+%3C%3C+*foo+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0220")

== ``` std::optional```

- Changement de la valeur via ```cpp reset()```, ```cpp swap()```, ```cpp emplace()``` ou ```cpp operator=```
- Comparaison naturelle des valeurs contenues

```cpp
optional<int> deux(2), dix(10);

dix > deux;       // true
dix < deux;       // false
dix == 10;        // true
```

- En prenant en compte ```cpp std::nullopt```

```cpp
optional<int> none, dix(10);

dix > none;       // true
dix < none;       // false
none == 10;       // false
none == nullopt;  // true
```

// std::nullopt est inférieur à toutes valeurs

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Coptional%3E%0A%23include+%3Cutility%3E%0A%0Aint+main()%0A%7B%0A++std::optional%3Cint%3E+none%3B%0A++std::optional%3Cint%3E+dix(10)%3B%0A%0A++std::cout+%3C%3C+std::boolalpha%3B%0A++std::cout+%3C%3C+(dix+%3E+none)+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+(dix+%3C+none)+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+(none+%3D%3D+10)+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+(none+%3D%3D+std::nullopt)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Coptional%3E%0A%23include+%3Cutility%3E%0A%0Aint+main()%0A%7B%0A++std::optional%3Cint%3E+deux(2)%3B%0A++std::optional%3Cint%3E+dix(10)%3B%0A%0A++std::cout+%3C%3C+std::boolalpha%3B%0A++std::cout+%3C%3C+(dix+%3E+deux)+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+(dix+%3C+deux)+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+(dix+%3D%3D+10)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0220")

== ``` std::optional```

#alertblock(text[``` std::optional<bool>``` ? ``` std::optional<T*>``` ?], text[
  Utilisez des booléens "trois états" (```cpp Boost.tribool```)

  Utilisez des pointeurs bruts
])

#adviceblock("Do", text[
  Préférez ```cpp std::optional``` aux pointeurs bruts pour les données optionnelles
])

#noteblock("Alternative à C++17", text[
  Utilisez ```cpp Boost.Optional```
])

#addproposal("P0220")

== ``` std::any```

- ```cpp void*``` _type-safe_ contenant un objet de n'importe quel type (ou vide)
- Implémentation de _Type-erasure_
- Type contenu dépend de la valeur assignée

```cpp
any a = 1;  // int
a = 3.14;   // double
a = true;   // bool
```

#addproposal("P0220")

== ``` std::any```

- ```cpp any_cast<Type>()``` récupère la valeur
- ... et lève une exception si le type demandé n'est pas correct

```cpp
any a = 1;
any_cast<int>(a);               // 1
any_cast<bool>(a);              // std::bad_any_cast
```

- ou récupère l'adresse
- ... et retourne ```cpp nullptr``` si le type demandé n'est pas correct

```cpp
any a = 1;
int* foo = any_cast<int>(&a);
int* foo = any_cast<bool>(&a);  // nullptr
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cany%3E%0A%0Aint+main()%0A%7B%0A++std::any+a+%3D+1%3B%0A++std::cout+%3C%3C+std::any_cast%3Cint%3E(%26a)+%3C%3C+%22+-+%22+%3C%3C+*std::any_cast%3Cint%3E(%26a)+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::any_cast%3Cdouble%3E(%26a)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cany%3E%0A%0Aint+main()%0A%7B%0A++std::any+a+%3D+1%3B%0A++std::cout+%3C%3C+std::any_cast%3Cint%3E(a)+%3C%3C+!'%5Cn!'%3B%0A%0A%23if+0%0A++std::cout+%3C%3C+std::any_cast%3Cbool%3E(a)+%3C%3C+!'%5Cn!'%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0220")

== ``` std::any```

- Supporte la construction en-place

```cpp
any a(in_place_type<complex<double>>, 3.0, 4.0);
```

- _Helper_ ```cpp std::make_any```

```cpp
any a = make_any<complex<double>>(3.0, 4.0);
```

- Changement de valeur, éventuellement de type, via l'affectation

```cpp
std::any a = 1;
a = 3.14;
```

- ... ou ```cpp emplace()```

```cpp
a.emplace<std::complex<double>>(3.0, 4.0);
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cany%3E%0A%23include+%3Ccomplex%3E%0A%0Aint+main()%0A%7B%0A++std::any+a+%3D+1%3B%0A++std::cout+%3C%3C+std::any_cast%3Cint%3E(a)+%3C%3C+!'%5Cn!'%3B%0A%0A++a.emplace%3Cstd::complex%3Cdouble%3E%3E(3.0,+4.0)%3B%0A++std::cout+%3C%3C+std::any_cast%3Cstd::complex%3Cdouble%3E%3E(a)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cany%3E%0A%0Aint+main()%0A%7B%0A++std::any+a+%3D+1%3B%0A++std::cout+%3C%3C+std::any_cast%3Cint%3E(a)+%3C%3C+!'%5Cn!'%3B%0A%0A++a+%3D+3.14%3B%0A++std::cout+%3C%3C+std::any_cast%3Cdouble%3E(a)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cany%3E%0A%23include+%3Ccomplex%3E%0A%0Aint+main()%0A%7B%0A++std::any+a+%3D+std::make_any%3Cstd::complex%3Cdouble%3E%3E(3.0,+4.0)%3B%0A++std::cout+%3C%3C+std::any_cast%3Cstd::complex%3Cdouble%3E%3E(a)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cany%3E%0A%23include+%3Ccomplex%3E%0A%0Aint+main()%0A%7B%0A++std::any+a(std::in_place_type%3Cstd::complex%3Cdouble%3E%3E,+3.0,+4.0)%3B%0A++std::cout+%3C%3C+std::any_cast%3Cstd::complex%3Cdouble%3E%3E(a)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0220")

== ``` std::any```

- ```cpp reset()``` vide le contenu
- ```cpp has_value()``` teste la vacuité
- ```cpp type()``` récupère l'information du type courant
// L'information de type récupérée ainsi est implementation-dependant et non utilisable tel quel mais peut être comparé au retour de type_id

#noteblock("Alternative à C++17", text[
  Utilisez ```cpp Boost.Any```
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cany%3E%0A%0Aint+main()%0A%7B%0A++std::any+a%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+a.has_value()+%3C%3C+!'%5Cn!'%3B%0A%0A++a+%3D+5%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+a.has_value()+%3C%3C!'+!'+%3C%3C+a.type().name()+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0220")

== ``` std::string_view```

- Vue sur une séquence contiguë de caractères
- Quatre spécialisations standards (une par type de caractères)
- Référence non possédante sur une séquence pré-existante
- Pas de modification de la séquence depuis la vue
- Constructible depuis ```cpp std::string```, une chaîne C ou un pointeur et une taille

#alertblock("Attention", text[
  Pas de ```cpp \0``` terminal systématique

  La chaîne référencée doit vivre au moins aussi longtemps que la vue
])

#addproposal("P0220")
#addproposal("N3921")

== ``` std::string_view```

- ```cpp operator[]```, ```cpp at()```, ```cpp front()```, ```cpp back()```, ```cpp data()``` accèdent aux caractères
- ```cpp remove_prefix()``` et ```cpp remove_suffix()``` modification les bornes
- ```cpp size()```, ```cpp length()``` et  ```cpp max_size()``` accèdent à la taille et à la taille maiximale
- ```cpp empty()``` teste la vacuité
- ```cpp to_string()``` construction une chaîne depuis la vue
- ```cpp copy()``` copie une partie de la vue
- ```cpp substr()``` construit une vue sur une sous-partie
- ```cpp compare()``` compare avec une autre vue ou une chaîne
- ```cpp find()```, ```cpp rfind()```, ```cpp find_first_of()```, ```cpp find_last_of()```, ```cpp find_first_not_of()```, ```cpp find_last_not_of()``` recherchent
- ```cpp ==```, ```cpp !=```, ```cpp <=```, ```cpp >=```, ```cpp <``` et ```cpp >``` effectuent une comparaison lexicographique
- ```cpp operator<<``` affiche la sous-chaîne

#addproposal("P0220")
#addproposal("N3921")

== ``` std::string_view```

```cpp
string foo = "Lorem ipsum dolor sit amet";

string_view bar(&foo[0], 11);
cout << bar.size() << " - " << bar << '\n';  // 11 - Lorem ipsum

bar.remove_suffix(6);
cout << bar.size() << " - " << bar << '\n';  // 5 - Lorem
```

#adviceblock("Performances", text[
  Souvent meilleures que les fonctionnalités équivalentes de ```cpp string```

  Mais pas toujours, donc mesurez
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%23include+%3Cstring_view%3E%0A%0Aint+main()%0A%7B%0A++%7B%0A++++std::string+foo+%3D+%22Lorem+ipsum+dolor+sit+amet,+consectetur+adipiscing+elit.+Sed+non+risus.%22%3B%0A%0A++++std::string_view+bar(%26foo%5B0%5D,+11)%3B%0A++++std::cout+%3C%3C+bar.size()+%3C%3C+%22+-+%22+%3C%3C+bar+%3C%3C+!'%5Cn!'%3B%0A%0A++++foo%5B0%5D+%3D+!'l!'%3B%0A++++std::cout+%3C%3C+bar.size()+%3C%3C+%22+-+%22+%3C%3C+bar+%3C%3C+!'%5Cn!'%3B%0A++++std::cout+%3C%3C+bar%5B0%5D+%3C%3C+!'%5Cn!'%3B%0A%0A++++bar.remove_suffix(6)%3B%0A++++std::cout+%3C%3C+bar.size()+%3C%3C+%22+-+%22+%3C%3C+bar+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0A++%7B%0A++++char+foo%5B3%5D+%3D+%7B!'B!',+!'a!',+!'r!'%7D%3B%0A++++std::string_view+bar(foo,+sizeof+foo)%3B%0A++++std::cout+%3C%3C+bar.size()+%3C%3C+%22+-+%22+%3C%3C+bar+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0220")
#addproposal("N3921")

== Mémoire

- ```cpp std::shared_ptr``` et ```cpp std::weak_ptr``` sur des tableaux

```cpp
std::shared_ptr<int[]> foo(new int[10]);
```

#alertblock(text[Pas de ``` std::make_shared()```], text[
  ```cpp std::make_shared()``` ne supporte pas les tableaux en C++17
])

- Évolutions des allocateurs
// Type-erased allocator, polymorphic allocator, {memory ressources
// Gestion de l'alignement des Over-Aligned Data
- Classe de gestion de pools de ressources (synchronisés ou non)

#noteblock("Note", text[
  Pointeur intelligent sans responsabilité dans le TS ```cpp observer_ptr```

  Mais pas dans le périmètre accepté pour C++17
])

#addproposal("P0414")
#addproposal("P0035")

== Algorithmes

- Recherche d'une séquence dans une autre
  - Foncteurs de recherche : _default_, Boyer-Moore et Boyer-Moore-Horspoll
  - ```cpp std::search()``` encapsule l'appel à un des foncteurs
- Échantillonnage
  - ```cpp std::sample()``` extrait aléatoirement n éléments d'un ensemble

```cpp
string in = "abcdefgh", out;
sample(begin(in), end(in), back_inserter(out),
       5, mt19937{random_device{}()});
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%23include+%3Calgorithm%3E%0A%23include+%3Crandom%3E%0A%23include+%3Cctime%3E%0A%0Aint+main()%0A%7B%0A++std::string+in+%3D+%22abcdefgh%22%3B%0A++std::string+out%3B%0A++std::mt19937+gen%7Bstatic_cast%3Cunsigned+long%3E(time(nullptr))%7D%3B%0A++std::sample(std::begin(in),+std::end(in),+std::back_inserter(out),+5,+gen)%3B%0A%0A++for(auto+it+:+out)%0A++%7B%0A++++std::cout+%3C%3C+it+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0220")

== PGCD et PPCM

- Ajout des fonctions ```cpp std::gcd()``` et ```cpp std::lcm()```
- Initialement prévu pour des versions ultérieures
- ... mais suffisamment simples et élémentaires pour C++17

```cpp
gcd(12, 18);   // 6
lcm(12, 18);   // 36
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cnumeric%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::gcd(12,+18)+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::lcm(12,+18)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0295")

== Filesystem TS

- Gestion des systèmes de fichiers
- Adapté à l'OS et au système de fichiers utilisés
- Manipulation des chemins et noms de fichiers
- ```cpp std::fstream``` constructible depuis ```cpp path```

```cpp
path foo("/home/foo");
path bar(foo / "bar.txt");
bar.filename();    // bar.txt
bar.extension();   // .txt
bar.native();      // std::string
bar.c_str();       // const char*
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cnumeric%3E%0A%23include+%3Cfilesystem%3E%0A%0Aint+main()%0A%7B%0A++std::filesystem::path+foo(%22/home/foo%22)%3B%0A++std::filesystem::path+bar(foo+/+%22bar.txt%22)%3B%0A%0A++std::cout+%3C%3C+bar.filename()+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+bar.extension()+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+bar.native()+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+bar.c_str()+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0218")

== Filesystem TS

- Manipulation des répertoires, des fichiers et de leurs méta-datas
  - Copie : ```cpp copy_file()```, ```cpp copy()```
  - Création de répertoires : ```cpp create_directory()```, ```cpp create_directories()```
  // Différence : création du répertoire final seulement ou de tous les répertoires intermédiaires nécessaires
  - Création des liens : ```cpp create_symlink()```, ```cpp create_hard_link()```
  - Test d'existence : ```cpp exists()```
  - Taille : ```cpp file_size()```
  - Type : ```cpp is_regular_file()```, ```cpp is_directory()```, ```cpp is_symlink()```, ```cpp is_fifo()```, ```cpp is_socket()```, ...
  - Permissions : ```cpp permissions()```
  - Date de dernière écriture : ```cpp last_write_time()```

#addproposal("P0218")

== Filesystem TS

#list(marker: [ ], text[
  - Suppression : ```cpp remove()```, ```cpp remove_all()```
  // Différence remove et remove_all : suppression récursive pour le second
  - Changement de nom : ```cpp rename()```
  - Changement de taille : ```cpp resize_file()```
  - Chemin du répertoire temporaire : ```cpp temp_directory_path()```
  - Chemin du répertoire courant : ```cpp current_path()```
])

#addproposal("P0218")

== Filesystem TS

- Parcours de répertoires
  - Entrée du répertoire : ```cpp directory_entry```
  - Itérateurs pour le parcours
    - Parcours simple : ```cpp directory_iterator```
    - Parcours récursif : ```cpp recursive_directory_iterator```
  - Construction de l'itérateur de début depuis le chemin du répertoire
  - Construction de l'itérateur de fin par défaut

#adviceblock("Do", text[
  Utilisez _Filesystem_ plutôt que les API C ou systèmes
])

#noteblock("Alternative à C++17", text[
  Utilisez ```cpp Boost.Filesystem```
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Cfilesystem%3E%0A%23include+%3Cfstream%3E%0A%23include+%3Ciostream%3E%0A+%0Aint+main()%0A%7B%0A++std::filesystem::current_path(std::filesystem::temp_directory_path())%3B%0A++std::filesystem::create_directories(%22foo/bar%22)%3B%0A++std::ofstream(%22foo/baz.txt%22)%3B%0A++std::filesystem::create_symlink(%22bar%22,+%22foo/foo%22)%3B%0A%0A++for+(auto+const%26+dir_entry+:+std::filesystem::recursive_directory_iterator(%22foo%22))%0A++%7B%0A++++std::cout+%3C%3C+dir_entry+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A+%0A++std::filesystem::remove_all(%22foo%22)%3B%0A%7D'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0218")

== Parallelism TS

- Surcharges parallèles de nombreux algorithmes standards
- Politiques d'exécution (séquentielle, parallèle et parallèle + vectorisée)

```cpp
void bar(int i);

vector<int> foo {0, 5, 42, 58};
for_each(execution::par, begin(foo), end(foo), bar);
```

#alertblock("Attention", text[
  Pas de gestion intrinsèque des accès concurrents
])

#addproposal("P0024")

== Parallelism TS

- ```cpp std::for_each_n()``` parcours un ensemble défini par l'itérateur de début et sa taille
// En soi, ce n'est pas lié au parallélisme mais cet algorithme apparait avec ce TS
- ```cpp std::reduce()``` "ajoute" tous les éléments de l'ensemble

#noteblock(text[``` std::reduce()``` ou ``` std::accumulate()``` ?], text[
  Ordre des "additions" non spécifié dans le cas de ```cpp std::reduce()```
  // Le résultat n'est donc pas déterministe dans le cas d'opérations non associatives ou non commutatives (car std::reduce() regroupe et réarrange les opérations)
  // Mais rend cet algorithme parallélisable contrairement à std::accumulate()
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cnumeric%3E%0A%23include+%3Cexecution%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo+%7B5,+42,+58%7D%3B%0A%0A++std::cout+%3C%3C+std::reduce(std::execution::seq,+std::begin(foo),+std::end(foo))+%3C%3C+%22%5Cn%22%3B%0A%7D%0A+'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo+%7B5,+42,+58%7D%3B%0A%0A++std::for_each_n(std::begin(foo),+std::size(foo),+%5B%5D+(int+i)+%7B+std::cout+%3C%3C+i+%3C%3C+%22%5Cn%22%3B+%7D)%3B%0A%7D%0A+'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0024")

== Parallelism TS

- ```cpp std::exclusive_scan()``` construit un ensemble où chaque élément est égal à la somme des éléments de rang strictement inférieur de l'ensemble initial et d'une valeur initiale

```cpp
vector<int> foo {5, 42, 58}, bar;

exclusive_scan(begin(foo), end(foo), back_inserter(bar), 8);
// bar : 8 13 55
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cnumeric%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo+%7B5,+42,+58%7D%3B%0A++std::vector%3Cint%3E+bar%3B%0A%0A++std::exclusive_scan(std::begin(foo),+std::end(foo),+std::back_inserter(bar),+8)%3B%0A%0A++for+(const+auto+it+:+bar)%0A++%7B%0A%09++std::cout+%3C%3C+it+%3C%3C+%22+%22%3B%0A++%7D%0A++std::cout+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0024")

== Parallelism TS

- ```cpp std::inclusive_scan()``` construit un ensemble où chaque élément est égal à la somme des éléments de rang inférieur ou égal de l'ensemble initial et d'une valeur initiale (si présente)

```cpp
vector<int> foo {5, 42, 58};
vector<int> bar;

inclusive_scan(begin(foo), end(foo), back_inserter(bar));
// bar : 5 47 105
```

// exclusive_scan et inclusive_scan sont proche de partial_sum mais sans garanti d'ordre des "additions" avec résultat indéterminé en cas d'opérations non associatives (idem reduce() / accumulate())

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cnumeric%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo+%7B5,+42,+58%7D%3B%0A++std::vector%3Cint%3E+bar%3B%0A%0A++std::inclusive_scan(std::begin(foo),+std::end(foo),+std::back_inserter(bar))%3B%0A%0A++for+(const+auto+it+:+bar)%0A++%7B%0A%09++std::cout+%3C%3C+it+%3C%3C+%22+%22%3B%0A++%7D%0A++std::cout+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0024")

== Parallelism TS

- ```cpp std::transform_reduce()``` : ```cpp std::reduce()``` sur des éléments préalablement transformés
- ```cpp std::transform_exclusive_scan()``` : ```cpp std::exclusive_scan()``` sur des éléments préalablement transformés
- ```cpp std::transform_inclusive_scan()``` : ```cpp std::inclusive_scan()``` sur des éléments préalablement transformés

#noteblock("Note", text[
  Transformation non appliquée à la graine
])

#addproposal("P0024")

== Mathematical Special Functions

- Une longue histoire datant du TR1
- Ajout de fonctions mathématiques particulières
  - Fonctions cylindriques de Bessel
  - Fonctions de Neumann
  - Polynômes de Legendre
  - Polynômes de Hermite
  - Polynômes de Laguerre
  - ...

#addproposal("P0226")
