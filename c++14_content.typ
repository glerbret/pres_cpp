#import "./model.typ": *

= C++14

== Présentation

- Approuvé le 16 août 2014
- Dernier _Working Draft_ : #link("https://wg21.link/std14")[N4140 #linklogo()]
- Dans la continuité de C++11
- Changements moins importants
- Mais loin d'une simple version correctrice

== ``` constexpr```

- Fonctions membres ```cpp constexpr``` plus implicitement ```cpp const```
- Relâchement des contraintes sur les fonctions ```cpp constexpr```
  - Variables locales (initialisées, ni ```cpp static```, ni ```cpp thread_local```)
  - Objets mutables créés lors l'évaluation de l'expression constante
  - ```cpp if```, ```cpp switch```, ```cpp while```, ```cpp for```, ```cpp do while```
- Application de ```cpp constexpr``` à plusieurs éléments de la bibliothèque standard

#addproposal("N3652")

== Généralisation de la déduction du type retour

- Utilisable sur les lambdas complexes

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:14,positionColumn:1,positionLineNumber:14,selectionStartColumn:1,selectionStartLineNumber:14,startColumn:1,startLineNumber:14),source:'%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++auto+foo+%3D+%5B%5D(int+x)%0A++%7B%0A++++if(x+%3E%3D+0)+return+2+*+x%3B%0A%09else+return+-2+*+x%3B%0A++%7D%3B%0A%0A++std::cout+%3C%3C+foo(5)+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+foo(-2)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    [](int x) {
      if(x >= 0) return 2 * x;
      else return -2 * x;
    };
    ```
  ],
)

- Mais aussi sur les fonctions

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:14,positionColumn:1,positionLineNumber:14,selectionStartColumn:1,selectionStartLineNumber:14,startColumn:1,startLineNumber:14),source:'%23include+%3Ciostream%3E%0A%0Astatic+auto+bar(int+x)%0A%7B%0A++if(x+%3E%3D+0)+return+2+*+x%3B%0A++else+return+-2+*+x%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+bar(5)+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+bar(-2)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    auto foo(int x) {
      if(x >= 0) return 2 * x;
      else return -2 * x;
    }
    ```
  ],
)

#addproposal("N3638")

== Généralisation de la déduction du type retour

- Y compris récursive

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astatic+auto+fact(unsigned+int+x)%0A%7B%0A++if(x+%3D%3D+0)+return+1U%3B%0A++else+return+x+*+fact(x-1)%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+fact(4)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    auto fact(unsigned int x) {
      if(x == 0) return 1U;
      else return x * fact(x - 1);
    }
    ```
  ],
)

#alertblock("Contraintes", text[
  Un ```cpp return``` doit précéder l'appel récursive

  Tous les chemins doivent avoir le même type de retour
])

#addproposal("N3638")

== ``` decltype(auto)```

- Déduction du type retour en conservant la référence

```cpp
string bar("bar");

string  foo1() { return string("foo"); }
string& bar1() { return bar; }

decltype(auto) foo2() { return foo1(); } // string
decltype(auto) bar2() { return bar1(); } // string&
auto foo3() { return foo1(); }           // string
auto bar3() { return bar1(); }           // string
```

#addproposal("N3638")

== Aggregate Initialisation

- Compatible avec l'initialisation par défaut des membres
- Initialisation par défaut des membres non explicitement initialisés

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astruct+Foo%0A%7B%0A++int+a%3B%0A++int+b+%3D+42%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++Foo+foo%7B6%7D%3B%0A++std::cout+%3C%3C+foo.a+%3C%3C+!'+!'+%3C%3C+foo.b+%3C%3C+!'%5Cn!'%3B%0A%0A++Foo+bar%7B6,+5%7D%3B%0A++std::cout+%3C%3C+bar.a+%3C%3C+!'+!'+%3C%3C+bar.b+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    struct Foo {int i, int j = 5};

    Foo foo{42};   // i = 42, j = 5
    ```
  ],
)

#addproposal("N3653")

== Itérateurs

- Fonctions libres ```cpp std::cbegin()``` et ```cpp std::cend()```
- Fonctions libres ```cpp std::rbegin()``` et ```cpp std::rend()```
- Fonctions libres ```cpp std::crbegin()``` et ```cpp std::crend()```
- _Null forward iterator_ ne référençant aucun conteneur valide

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Aint+main()%0A%7B%0A++auto+ni+%3D+std::vector%3Cint%3E::iterator()%3B%0A++auto+nd+%3D+std::vector%3Cdouble%3E::iterator()%3B%0A%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+(ni+%3D%3D+ni)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+(nd+!!%3D+nd)+%3C%3C+%22%5Cn%22%3B%0A%23if+0%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+(ni+%3D%3D+nd)+%3C%3C+%22%5Cn%22%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    auto ni = vector<int>::iterator();
    auto nd = vector<double>::iterator();

    ni == ni;  // true
    nd != nd;  // false
    ni == nd;  // Erreur de compilation
    ```
  ],
)

#alertblock("Attention", text[
  _Null forward iterator_ non comparables avec des itérateurs classiques
])

#addproposal("N3644")

== Recherche hétérogène

- Optimisation de la recherche hétérogène dans les conteneurs associatifs ordonnés
- Fourniture d'une classe exposant
  - Fonction de comparaison
  - _Tag_ ```cpp is_transparent```
- Suppression de conversions inutiles

#addproposal("N3657")

== Algorithmes

- Surcharge de ```cpp std::equal()```, ```cpp std::mismatch()``` et de ```cpp std::is_permutation()``` prenant deux paires complètes d'itérateurs

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:16,positionColumn:1,positionLineNumber:16,selectionStartColumn:1,selectionStartLineNumber:16,startColumn:1,startLineNumber:16),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B1,+2,+3%7D%3B%0A++std::vector%3Cint%3E+bar%7B10,+11,+12%7D%3B%0A++std::vector%3Cint%3E+baz%7B1,+2%7D%3B%0A%0A++std::cout+%3C%3C+std::boolalpha%3B%0A++std::cout+%3C%3C+std::equal(std::begin(foo),+std::end(foo),+std::begin(foo),+std::end(foo))+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::equal(std::begin(foo),+std::end(foo),+std::begin(bar),+std::end(bar))+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::equal(std::begin(foo),+std::end(foo),+std::begin(bar),+std::end(bar))+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo{1, 2, 3};
    vector<int> bar{10, 11};

    equal(begin(foo), end(foo), begin(bar), end(bar));
    ```
  ],
)

- ```cpp std::exchange()``` change la valeur d'un objet et retourne l'ancienne

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cutility%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B1,+2,+3%7D%3B%0A++std::vector%3Cint%3E+bar+%3D+std::exchange(foo,+%7B10,+11%7D)%3B%0A%0A++for(const+auto+e:+foo)%0A++%7B%0A++++std::cout+%3C%3C+e+%3C%3C+%22+%22%3B%0A++%7D%0A++std::cout+%3C%3C+%22%5Cn%22%3B%0A++for(const+auto+e:+bar)%0A++%7B%0A++++std::cout+%3C%3C+e+%3C%3C+%22+%22%3B%0A++%7D%0A++std::cout+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo{1, 2, 3};
    vector<int> bar = exchange(foo, {10, 11});
    // foo : 10 11, bar : 1, 2, 3
    ```
  ],
)

#noteblock("Dépréciation", text[
  Dépréciation de ```cpp std::random_shuffle()```
  // Remplacé par std::shuffle() qui permet un meilleur aléa
])

#addproposal("N3668")
#addproposal("N3671")

== Quoted string

- Insertion et extraction de chaînes avec guillemets

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%23include+%3Csstream%3E%0A%23include+%3Ciomanip%3E%0A%0Aint+main()%0A%7B%0A++std::string+foo+%3D+%22Chaine+avec+%5C%22guillemets%5C%22%22%3B%0A++std::cout+%3C%3C+foo+%3C%3C+%22%5Cn%22%3B%0A%0A++std::stringstream+ss%3B%0A++ss+%3C%3C+std::quoted(foo)%3B%0A++std::cout+%3C%3C+ss.str()+%3C%3C+%22%5Cn%22%3B%0A%0A++std::string+bar%3B%0A++ss+%3E%3E+std::quoted(bar)%3B%0A++std::cout+%3C%3C+bar+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    string foo = "Chaîne avec \"guillemets\"";
    cout << foo << "\n";      // Chaîne avec "guillemets"

    stringstream ss;
    ss << quoted(foo);
    cout << ss.str() << "\n"; // "Chaîne avec \"guillemets\""

    string bar;
    ss >> quoted(bar);
    cout << bar << "\n";      // Chaîne avec "guillemets"
    ```
  ],
)

#addproposal("N3654")

== Littéraux binaires

- Support des littéraux binaires préfixés par ```cpp 0b```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++int+foo+%3D+0b101010%3B%0A%0A++std::cout+%3C%3C+foo+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    int foo = 0b101010; // 42
    ```
  ],
)

#addproposal("N3472")

== Séparateurs

- Utilisation possible de ```cpp '``` dans les nombres littéraux

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+0b0010!'1010+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+1!'000+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+010!'00+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    int foo = 0b0010'1010;  // 42
    int bar = 1'000;        // 1000
    int baz = 010'00;       // 512
    ```
  ],
)

#noteblock("Note", text[
  Purement esthétique, aucune sémantique ni place réservée
])

#addproposal("N3781")

== User-defined literals standards

- Suffixe ```cpp s``` sur les chaînes : ```cpp std::string```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%0Ausing+namespace+std::literals%3B%0A%0Aint+main()%0A%7B%0A++auto+s1+%3D+%22Abcd%22%3B%0A++auto+s2+%3D+%22Abcd%22s%3B%0A%0A++std::cout+%3C%3C+std::boolalpha%3B%0A++std::cout+%3C%3C+(typeid(s1)+%3D%3D+typeid(std::string))+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+(typeid(s1)+%3D%3D+typeid(const+char*))+%3C%3C+%22%5Cn%22%3B%0A%0A++std::cout+%3C%3C+(typeid(s2)+%3D%3D+typeid(std::string))+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    auto foo = "abcd"s;   // string
    ```
  ],
)

#noteblock("Note", text[
  Remplace ```cpp std::string{"abcd"}```
])

#alertblock("Attention", text[
  Nécessite l'utilisation de ```cpp using namespace std::literals```
])

#addproposal("N3642")

== User-defined literals standards

- Suffixe ```cpp h```, ```cpp min```, ```cpp s```, ```cpp ms```, ```cpp us``` et ```cpp ns``` : ```cpp std::chrono::duration```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cchrono%3E%0A%0Ausing+namespace+std::literals%3B%0A%0Aint+main()%0A%7B%0A++auto+foo+%3D+60s%3B+++//+chrono::seconds%0A++auto+bar+%3D+5min%3B++//+chrono::minutes%0A%0A++std::cout+%3C%3C+(foo+%2B+bar).count()+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    auto foo = 60s;   // chrono::seconds
    auto bar = 5min;  // chrono::minutes
    ```
  ],
)

#addproposal("N3642")

== User-defined literals standards

- Suffixe ``` if``` : nombre imaginaire de type ```cpp std::complex<float>```
- Suffixe ``` i``` : nombre imaginaire de type ```cpp std::complex<double>```
- Suffixe ``` il``` : nombre imaginaire de type ```cpp std::complex<long double>```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ccomplex%3E%0A%0Ausing+namespace+std::literals%3B%0A%0Aint+main()%0A%7B%0A++auto+foo+%3D+5i%3B%0A%0A++std::cout+%3C%3C+foo.real()+%3C%3C+%22+-+%22+%3C%3C+foo.imag()+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    auto foo = 5i;  // complex<double>
    ```
  ],
)

#addproposal("N3642")

== Adressage des ``` std::tuple``` par le type

- Utilisation du type plutôt que de l'indice

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:9,positionColumn:1,positionLineNumber:9,selectionStartColumn:1,selectionStartLineNumber:9,startColumn:1,startLineNumber:9),source:'%23include+%3Ciostream%3E%0A%23include+%3Ctuple%3E%0A%0Aint+main()%0A%7B%0A++std::tuple%3Cint,+long,+long%3E+foo%7B42,+58L,+9L%7D%3B%0A%0A++std::cout+%3C%3C+std::get%3Cint%3E(foo)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    tuple<int, long, long> foo{42, 58L, 9L};

    get<int>(foo);  // 42
    ```
  ],
)

#alertblock("Attention", text[
  Uniquement s'il n'y a qu'une occurrence du type dans le ```cpp std::tuple```
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:9,positionColumn:1,positionLineNumber:9,selectionStartColumn:1,selectionStartLineNumber:9,startColumn:1,startLineNumber:9),source:'%23include+%3Ciostream%3E%0A%23include+%3Ctuple%3E%0A%0Aint+main()%0A%7B%0A++std::tuple%3Cint,+long,+long%3E+foo%7B42,+58L,+9L%7D%3B%0A%0A++std::cout+%3C%3C+std::get%3Clong%3E(foo)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    get<long>(foo);  // Erreur
    ```
  ],
)

#addproposal("N3670")

== Variable template

- Généralisation des templates aux variables
- Y compris les spécialisations

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Atemplate%3Ctypename+T%3E%0Aconstexpr+T+PI+%3D+T(3.1415926535897932385)%3B%0A%0Atemplate%3C%3E%0Aconstexpr+const+char*+PI%3Cconst+char*%3E+%3D+%22pi%22%3B%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+PI%3Cint%3E+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+PI%3Cdouble%3E+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+PI%3Cconst+char*%3E+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    template<typename T>
    constexpr T PI = T(3.1415926535897932385);

    template<>
    constexpr const char* PI<const char*> = "pi";

    PI<int>;          // 3
    PI<double>;       // 3.14159
    PI<const char*>;  // pi
    ```
  ],
)

#addproposal("N3651")

== Generic lambdas

- Lambdas utilisables sur différents types de paramètres
- Déduction du type des paramètres déclarés ```cpp auto```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%0Ausing+namespace+std::literals%3B%0A%0Aint+main()%0A%7B%0A++auto+foo+%3D+%5B%5D+(auto+in)+%7B+std::cout+%3C%3C+in+%3C%3C+!'%5Cn!'%3B+%7D%3B%0A%0A++foo(2)%3B%0A++foo(%22azerty%22s)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    auto foo = [] (auto in) { cout << in << '\n'; };

    foo(2);
    foo("azerty"s);
    ```
  ],
)

#addproposal("N3649")

== Variadic lambdas

- Lambda à nombre de paramètres variable
- Suffixe ```cpp ...``` à ```cpp auto```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%0Ausing+namespace+std::literals%3B%0A%0Aint+main()%0A%7B%0A++auto+foo+%3D+%5B%5D+(auto...+args)+%7B+std::cout+%3C%3C+sizeof...(args)+%3C%3C+!'%5Cn!'%3B+%7D%3B%0A%0A++foo(2)%3B%0A++foo(2,+3,+4)%3B%0A++foo(%22azerty%22s)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    auto foo = [] (auto... args) {
      std::cout << sizeof...(args) << '\n';
    };

    foo(2);           // 1
    foo(2, 3, 4);     // 3
    foo("azerty"s);   // 1
    ```
  ],
)

#addproposal("N3649")

== Capture généralisée

- Création de variables capturées depuis des variables locales ou des constantes

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++int+foo+%3D+42%3B%0A%0A++auto+bar+%3D+%5B+%26x+%3D+foo+%5D()+%7B+--x%3B+%7D%3B%0A++bar()%3B%0A++std::cout+%3C%3C+foo+%3C%3C+%22%5Cn%22%3B%0A%0A++auto+baz+%3D+%5B+y+%3D+10+%5D()+%7B+return+y%3B+%7D%3B%0A++std::cout+%3C%3C+baz()+%3C%3C+%22%5Cn%22%3B%0A%0A++auto+qux+%3D+%5B+z+%3D+2+*+foo+%5D()+%7B+return+z%3B+%7D%3B%0A++std::cout+%3C%3C+qux()+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    int foo = 42;

    auto bar = [ &x = foo ]() { --x; };
    bar();  // foo : 41

    auto baz = [ y = 10 ]() { return y; };
    baz();  // 10

    auto qux = [ z = 2 * foo ]() { return z; };
    qux();  // 82
    ```
  ],
)

#addproposal("N3648")

== Capture généralisée

- Capture par déplacement

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cmemory%3E%0A%0Aint+main()%0A%7B%0A++auto+foo+%3D+std::make_unique%3Cint%3E(42)%3B%0A++auto+bar+%3D+%5B+foo+%3D+std::move(foo)+%5D(int+i)+%7B+std::cout+%3C%3C+*foo+*+i+%3C%3C+!'%5Cn!'%3B+%7D%3B%0A%0A++bar(5)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    auto foo = make_unique<int>(42);
    auto bar = [ foo = move(foo) ](int i) {
      cout << *foo * i << '\n';
    };

    bar(5);  // Affiche 210
    ```
  ],
)

- Capture des variables membres

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:18,positionColumn:1,positionLineNumber:18,selectionStartColumn:1,selectionStartLineNumber:18,startColumn:1,startLineNumber:18),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%0Astruct+Bar%0A%7B%0A++auto+foo()+%7B+return+%5Bs%3Ds%5D+%7B+std::cout+%3C%3C+s+%3C%3C+!'%5Cn!'%3B+%7D%3B+%7D%0A%0A++std::string+s%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++Bar+bar%3B%0A++bar.s+%3D+%22Test%22%3B%0A%0A++bar.foo()()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    struct Bar {
      auto foo() { return [s=s] { cout << s << '\n'; }; }

      string s;
    };
    ```
  ],
)

#addproposal("N3648")

== Améliorations des lambdas

- Type de retour complètement facultatif
// Il n'y a plus les restrictions de C++11 (une seule instruction, de type return)
- Conversion possible de lambda sans capture en pointeur de fonction
// Donc passable à des fonctions C attendant un pointeur de fonction en paramètre

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:12,positionColumn:1,positionLineNumber:12,selectionStartColumn:1,selectionStartLineNumber:12,startColumn:1,startLineNumber:12),source:'%23include+%3Ciostream%3E%0A%0Avoid+foo(void(*+bar)(int))%0A%7B%0A++bar(5)%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++foo(%5B%5D(int+x)+%7B+std::cout+%3C%3C+x+%3C%3C+%22%5Cn%22%3B+%7D)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    void foo(void(* bar)(int))

    foo([](int x) { cout << x << "\n"; });
    ```
  ],
)

- Peuvent être ```cpp noexcept```
- Ajout des paramètres par défaut aux lambdas

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++auto+foo+%3D+%5B%5D+(int+bar+%3D+12)+%7B+std::cout+%3C%3C+bar+%3C%3C+%22%5Cn%22%3B+%7D%3B%0A%0A++foo()%3B%0A++foo(5)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    auto foo = [] (int bar = 12) { cout << bar << "\n"; };
    ```
  ],
)

== ``` std::is_final```

- Indique si la classe est finale ou non

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ctype_traits%3E%0A%0Aclass+Foo%0A%7B%7D%3B%0A%0Aclass+Bar+final%0A%7B%7D%3B%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::boolalpha%3B%0A++std::cout+%3C%3C+std::is_final%3CFoo%3E::value+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::is_final%3CBar%3E::value+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    class Foo {};
    class Bar final {};

    is_final<Foo>::value;   // false
    is_final<Bar>::value;   // true
    ```
  ],
)

== Alias transformation

- Simplification de l'usage des transformations de types
- Ajout du suffixe ```cpp _t``` aux transformations
- Suppression de ```cpp typename``` et ```cpp ::type```

```cpp
typedef add_const<int>::type A;
typedef add_const<const int>::type B;
typedef add_const<const int*>::type C;

// Deviennent

add_const_t<int> A;
add_const_t<const int> B;
add_const_t<const int*> C;
```

== ``` std::make_unique```

- Allocation et construction de l'objet dans le ```cpp std::unique_ptr```

```cpp
unique_ptr<int> foo = make_unique<int>(42);
```

#alertblock("Don't", text[
  Plus de ```cpp new``` dans le code applicatif
])

#noteblock("Note", text[
  Utilisable pour construire dans un conteneur
])

#addproposal("N3656")

== Attribut ``` [[ deprecated ]]```

- Indique qu'une entité (variable, fonction, classe, ...) est dépréciée
- Émission possible d'avertissement sur l'utilisation d'une entité ```cpp deprecated```
// Possible car il n'y a pas d'obligation dans la norme

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0A%5B%5B+deprecated+%5D%5D%0Astatic+void+bar()%0A%7B%0A%7D%0A%0Aclass+%5B%5B+deprecated+%5D%5D+Baz%0A%7B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++bar()%3B%0A%0A++Baz+baz%3B%0A%0A++%5B%5B+deprecated+%5D%5D%0A++int+foo%7B42%7D%3B%0A++std::cout+%3C%3C+foo+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    [[ deprecated ]]
    void bar() {}

    class [[ deprecated ]] Baz {};

    [[ deprecated ]]
    int foo{42};
    ```
  ],
)

#addproposal("N3760")

== Attribut ``` [[ deprecated ]]```

- Possibilité de fournir un message explicatif

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0A%5B%5B+deprecated(%22Utilisez+Foo%22)+%5D%5D%0Astatic+void+bar()%0A%7B%0A%7D%0A%0Aint+main()%0A%7B%0A++bar()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    [[ deprecated("Utilisez Foo") ]]
    void bar() {}
    ```
  ],
)

```shell
warning: 'void bar()' is deprecated: Utilisez Foo
```

#addproposal("N3760")

== ``` std::shared_timed_mutex```

- Similaire à ```cpp std::timed_mutex``` avec deux niveaux d'accès
  - Exclusif : possible si le verrou n'est pas pris
  - Partagé : possible si le verrou n'est pas pris en exclusif
- Même API que ```cpp std::timed_mutex``` pour l'accès exclusif
- API similaire pour l'accès partagé

#alertblock("Attention", text[
  Un thread ne doit pas prendre un mutex qu'il possède déjà

  Même en accès partagé
])

#addproposal("N3659")

== ``` std::shared_lock```

- Capsule RAII sur les mutex partagés
- Support des mutex verrouillés ou non
- Relâche le mutex à la destruction
- Similaire à ```cpp std::unique_lock``` mais en accès partagée

```cpp
shared_timed_mutex foo;
{
  shared_lock<shared_timed_mutex> bar(foo, defer_lock);
  ...
  bar.lock();  // Prise du mutex
  ...
}  // Liberation du mutex
```

#addproposal("N3659")
