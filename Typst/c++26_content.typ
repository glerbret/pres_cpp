#import "./model.typ": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/cetz:0.4.2"

== C++26

== Présentation

- Début formel des travaux en juin 2023
- Dernier _Working Draft_ : #link("https://wg21.link/std")[N5008 #linklogo()]

== Dépréciations
- Annulation de la dépréciation de ```cpp std::polymorphic_allocator::destroy```
- Dépréciation de ```cpp std::is_trivial``` et ```cpp std::is_trivial_v```
- Dépréciation de ```cpp memory_order::consume```
- Dépréciation de l'ellipse sans virgulant la précédant

#addproposal("p2875")
#addproposal("p3247")
#addproposal("p3475")
#addproposal("p3176")

== Suppressions

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

== En-têtes C23

- Support des en-têtes C23 ```cpp <stdbit.h>``` et ```cpp <stdckdint.h>```

#addproposal("p3370")

== Erroneous Behavior

- Nouveau type de comportement : _Erroneous Behavior_
- Code incorrect, mais bien défini
- Recommandation à l'implémentation de fournir un diagnostic (warning à la compilation, erreur au _runtime_, ...)
- Applicable aux lectures de variables non initialisées
  - Doit retourner une valeur "erronée"

// Valeur propre à l'implémentation, indiquant la non-initialisation
// En particulier pas la valeur précédente de la zone mémoire, ni 0

  - ... et non la valeur d'une autre variable récemment libérée

#addproposal("P2795")

== Undefined / unspecified / ill-formed

- La libération d'un pointeur sur un type incomplet devient _ill-formed_

// Auparavant, undefined behavior

- ```cpp std::observable_checkpoint()``` empêche la propagation de supposition basé sur de potentiels comportements indéfinis

```cpp
if (!p) cerr << "foo\n"; // Pas de suppression possible
observable_checkpoint();
if (!p) cerr << "bar\n"; // Suppression possible
*p += r;                 // p suppose non-nul
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

== Boucles infinies

- Les boucles infinies triviales ne sont plus des _Undefined Behavior_
- Alignement avec le comportement du C

```cpp
// Comportement indefini en C++23
while (true)
{}
```

#addproposal("P2809")

== Vérification statique

- Support de messages construits par ```cpp static_assert```

```cpp
static_assert(sizeof(Foo) == 1,
              format("Attendu 1, obtenu {}", sizeof(Foo)));
```

#alertblock(text[_Compile-time_], text[
  Uniquement des valeurs connues à la compilation
])

#alertblock("Dépendance", text[
  Nécessite que ```cpp std::format``` devienne ```cpp constexpr```
])

#addproposal("P2741")

// !!!!!!!!!!!!

== Lexer}

\begin{itemize}
\item Suppression de comportements indéfinis
\begin{itemize}
\item \textit{Universal characters} sur plusieurs lignes autorisés
\end{itemize}
\end{itemize}

```cpp
	int \\
	u\
	0\
	3\
	9\
	1 = 0;
```

\begin{itemize}
\item [] \begin{itemize}
\item Construction possible d'\textit{universal characters} par des macros
\end{itemize}
\end{itemize}

```cpp
	#define CONCAT(x, y) x ## y
	int CONCAT(\, u0393) = 0;
```

\begin{itemize}
\item [] \begin{itemize}
\item Une chaîne non terminée est une erreur
\end{itemize}
\end{itemize}

#addproposal{P2621}{https://wg21.link/P2621}


== Encodage}
\begin{itemize}
\item Ajout de ```cpp @```, ```cpp $``` et ```cpp ` ``` au jeu de caractères de base

// Ajoutés en C (C23)}
// Supportés par tous les encodages communément utilisés}

\item Caractères non-encodables sont mal formés

\item Identification de l'encodage
\begin{itemize}
\item ```cpp std::text_encoding::literal()``` : encodage du code
\item ```cpp std::text_encoding::environment()``` : encodage de l'environnement
\end{itemize}
\end{itemize}

\begin{codesample}
\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:3,positionColumn:1,positionLineNumber:3,selectionStartColumn:1,selectionStartLineNumber:3,startColumn:1,startLineNumber:3),source:'%23include+%3Ctext_encoding%3E%0A%23include+%3Ciostream%3E%0A%0Aint+main()+%0A%7B%0A++++std::cout+%3C%3C+std::text_encoding::literal().name()+%3C%3C+%22%5Cn%22%3B%0A++++std::cout+%3C%3C+std::text_encoding::environment().name()+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-Wall+-Wextra+-pedantic+-fcontracts+-std%3Dc%2B%2B26',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
\end{codesample}

#addproposal{P2558}{https://wg21.link/P2558}
#addproposal{P1854}{https://wg21.link/P1854}
#addproposal{p1885}{https://wg21.link/p1885}
#addproposal{p2862}{https://wg21.link/p2862}


== Saturation arithmetic}
\begin{itemize}
\item Fonctions ```cpp std::add_sat()```, ```cpp std::sub_sat()```, ```cpp std::mul_sat()```, ```cpp std::div_sat()``` et ```cpp std::saturate_cast()```
\item Les calculs dont le résultat est hors borne retournent les plus grandes ou plus petites valeurs représentables
\end{itemize}

```cpp
	add_sat(3, 4);                  // 7
	sub_sat(INT_MIN, 1);            // INT_MIN
	add_sat<unsigned char>(255, 4); // 255
```

\begin{codesample}
\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cnumeric%3E%0A%23include+%3Cclimits%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::add_sat(3,+4)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+INT_MIN+%3C%3C+%22+%22+%3C%3Cstd::sub_sat(INT_MIN,+1)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+static_cast%3Cint%3E(std::add_sat%3Cunsigned+char%3E(255,+4))+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B26+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
\end{codesample}

#addproposal{P0543}{https://wg21.link/P0543}



== Relocation}
\begin{itemize}
\item Nouvelle catégorie \textit{trivially relocatable} : déplaçable par copie bit à bit

// Opération généralement implémentable par un simple ```cpp memcpy()```}
// L'idée est de permettre certaines optimisations sur les objets correspondants}

\item Objet implicitement \textit{trivially relocatable} si toutes ces classes de base et membres non-statiques le sont
\item ```cpp trivially_relocatable_if_eligible``` sur les classes pour les marquer \textit{trivially relocatable}
\item Traits ```cpp std::is_trivially_relocatable``` et ```cpp std::is_nothrow_relocatable```
\item Fonction ```cpp std::trivially_relocate()``` effectue ce déplacement trivial
\item Fonction ```cpp std::relocate()``` appelle ```cpp std::trivially_relocate()``` ou le constructeur par déplacement selon l'objet
\end{itemize}

#addproposal{P2786}{https://wg21.link/P2786}



== Replaceability}
\begin{itemize}
\item Nouvelle catégorie \textit{replaceable type} : destruction puis construction depuis une autre instance est équivalent à assigner depuis une autre instance
\item Objet implicitement \textit{replaceable} si il n'est pas ```cpp const``` ni ```cpp volatile``` et si toutes ces classes de bases et membres non-statiques sont \textit{replaceable}

// ```cpp std::vector<>``` suppose déjà que les objets qu'il manipule sont \textit{replaceable}, contrairement à ```cpp std::swap()```}

\item ```cpp replaceable_if_eligible``` sur les classes pour les marquer \textit{replaceable}
\item Trait ```cpp std::is_replaceable```
\end{itemize}

#addproposal{P2786}{https://wg21.link/P2786}



== \mintinline[style=white]{cpp}```std::indirect<T>``` - \mintinline[style=white]{cpp}```std::polymorphic<T>```}
\begin{itemize}
\item ```cpp std::indirect<T>``` encapsule des objets de type ```cpp T```
\item ```cpp std::polymorphic<T>``` encapsule des objets héritant de ```cpp T```
\item Wrappers à sémantique de valeur d'objets alloués dynamiquement
\begin{itemize}
\item Copie profonde
\item Propagation de ```cpp const```
\end{itemize}
\end{itemize}

#addproposal{P3019}{https://wg21.link/P3019}


== Placeholders}
\begin{itemize}
\item Joker ```cpp _``` pour des variables inutilisées
\end{itemize}

```cpp
	auto _ = foo();  // Equivalent a [[maybe_unused]] auto _ = foo();
```

```cpp
	std::lock_guard _(mutex);
```

```cpp
	auto  [x, y, _] = f();
```

\begin{itemize}
\item ```cpp std::ignore``` pour ignorer un retour de fonction
\end{itemize}

```cpp
	std::ignore = f();
```

\begin{codesample}
\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:6,endLineNumber:12,positionColumn:6,positionLineNumber:12,selectionStartColumn:6,selectionStartLineNumber:12,startColumn:6,startLineNumber:12),source:'%23include+%3Ciostream%3E%0A%23include+%3Cnumeric%3E%0A%23include+%3Cclimits%3E%0A%0A%5B%5Bnodiscard%5D%5Dint+foo()%0A%7B%0A++return+42%3B%0A%7D%0A%0Aint+main()%0A%7B%0A%23if+1%0A++foo()%3B%0A%23else%0A++std::ignore+%3D+foo()%3B%0A%23endif%0A%7D%0A'),l:'5',n:'1',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B26+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cnumeric%3E%0A%23include+%3Cclimits%3E%0A%0Aint+foo()%0A%7B%0A++return+42%3B%0A%7D%0A%0Aint+main()%0A%7B%0A%23if+1%0A++auto+bar+%3D+foo()%3B%0A%23else%0A++auto+_+%3D+foo()%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B26+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
\end{codesample}

#addproposal{P2169}{https://wg21.link/P2169}
#addproposal{p2968}{https://wg21.link/p2968}


== Structured binding}
\begin{itemize}
\item Utilisable comme condition dans les ```cpp if```, ```cpp while```, ```cpp for``` et ```cpp switch```
\end{itemize}

```cpp
	struct Foo {
	  int a, b;
	  operator bool () const { return a != b; }};

	  if(auto [a, b] = Foo{...})
	  // Equivalent a
	  if(auto [a, b] = Foo{...}; a != b)
```

\begin{codesample}
\sample{https://godbolt.org/#z:OYLghAFBqd5QCxAYwPYBMCmBRdBLAF1QCcAaPECAMzwBtMA7AQwFtMQByARg9KtQYEAysib0QXACx8BBAKoBnTAAUAHpwAMvAFYTStJg1DIApACYAQuYukl9ZATwDKjdAGFUtAK4sGIMwAcpK4AMngMmAByPgBGmMQSAGykAA6oCoRODB7evv5BaRmOAmER0SxxCVzJdpgOWUIETMQEOT5%2BgbaY9sUMjc0EpVGx8Um2TS1teZ0KE4PhwxWj1QCUtqhexMjsHOYAzOHI3lgA1CZ7bk6zxJis59gmGgCCj0/XXg4nAGKoqGfPJgA7FZnicTuECCcmOcQU8wRCTjEYa9XmDMKoUrQ8MhCCdUCl4kwiMREb9aCcICsTmgGLNUWdgf84WCTjcCJsGFCTmAwOcACKI5Gghl8lGA0V7WGvBEsJjhSli2HwqgQJheIhnACsFiYpEFmoF/O%2BvyBFjMes1QL5K3ppvpYNm6BAKA2kPObndXPdnvMZm5vL2hrMfu9F0RZwuPuDJk1bgYvqFzKt9O6SltwPtJ0dzrQ6ojHrDTHzUZDgaNvuLYZilbcZ2jsfj0cl6dFAOFeBVao1MZ1eqRBojAp%2BqFN5pOZitNuFduFDoITpdedDtaLy7rfp55eDNfDa4TDYTzen4pTtDTx6VLOzi7dkcLO4r/K3pYLtere/rccPl%2BTbZe4o4NZaE4TVeD8DgtFIVBOA9SxrCzDYtkwOs9h4UgCE0QC1gAaxATUNH0ThJDAzCoM4XgFBAAiMIgwDSDgWAkHROp1RIchKGaYAFGUQxuiEBBUAAd3AtC0BYFI6CJLIeIiWh%2BKE8DILEiT6ASLjmBSBQBIIUhlLoeJIlYHZeD01SAHl1Xk4TSOY5AnmILjyOCVQ6kafBwN4fhBBEMR2CkGRBEUFR1Fo0hdC4fRDGMaxrH0PAYkoyA1nxXpKI4ABaR1%2BVMODLDMZATnSgB1MRyWK9ECGIIt0oJdBDEcZBeFQAA3eJiDwLBEspUhiC8QQ8DYAAVMkurWBREO2PRHXCGS%2BIE6zuF4SrMB2NDBKqlJMKAkCSNC6COGwFzkFYklVACRJ0sSSQTmAZACogSq%2BuwqkIFgqxLD1XBCBIFCuBWJatrWBBbiwBJutw/DCI4YjSEUpqnMo6jAahsxdsg/aAdolY1la4gMmcSQgA}
\end{codesample}

#addproposal{p0963}{https://wg21.link/p0963}



== Structured binding}
\begin{itemize}
\item Utilisation de \textit{parameters pack} dans les \textit{structures bindings}
\end{itemize}

```cpp
	tuple<X, Y, Z> f();

	auto [...xs] = f();
	auto [x, ...rest] = f();
	auto [x,y,z, ...rest] = f();
	auto [x, ...rest, z] = f();
	auto [...a, ...b] = f();  // ill-formed
```

#addproposal{p1061}{https://wg21.link/p1061}


== \mintinline[style=white]{cpp}```delete```}
\begin{itemize}
\item Ajout d'un message à ```cpp =delete```
\item Permet d'indiquer la raison de la suppression
\item Et d'obtenir de meilleures erreurs de compilation
\end{itemize}

```cpp
	void foo() = delete("Unsafe, use bar");

	// Avertisselent: use of deleted function 'void foo()': Unsafe, use bar
	foo();
```

\begin{codesample}
\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:40,endLineNumber:3,positionColumn:40,positionLineNumber:3,selectionStartColumn:1,selectionStartLineNumber:3,startColumn:1,startLineNumber:3),source:'%23include+%3Ciostream%3E%0A%0Avoid+foo()+%3D+delete(%22Unsafe,+use+bar%22)%3B%0A%0Aint+main()%0A%7B%0A+++foo()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B26+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
\end{codesample}

#addproposal{P2573}{https://wg21.link/P2573}



== Variadic friends}
\begin{itemize}
\item Possibilité de déclaré ```cpp friend``` un \textit{parameter pack}
\end{itemize}

```cpp
	template <typename... Ts>
	class Bar {
	  friend Ts...;  // Invalide en C++23
	  ...
	};
```

#addproposal{P2893}{https://wg21.link/P2893}


== Template}
\begin{itemize}
\item Utilisation de concepts ou de variable template comme paramètres template
\end{itemize}

```cpp
	template<template <typename T> concept C,
	         template <typename T> auto V>
	struct S{};

	template <typename T> concept Concept = true;
	template <typename T> constexpr auto Var = 42;

	S<Concept, Var> s;
```

#addproposal{P2841}{https://wg21.link/P2841}


== Gestion d'erreur}
\begin{itemize}
\item Récupération des informations contenues dans un ```cpp std::exception_ptr```
\begin{itemize}
\item ```cpp exception_ptr_cast``` converti un ```cpp std::exception_ptr``` en un pointeur sur une exception
\end{itemize}
\end{itemize}

#addproposal{P2927}{https://wg21.link/p2927}


== Conteneurs}
\begin{itemize}
\item Nouveaux conteneurs
\begin{itemize}
\item Vecteur de capacité fixée en \textit{compile-time} ```cpp std::inplace_vector```

// Contrairement à ```cpp std::array``` la taille n'est pas fixée, seule la capacité l'est, et donc utilisable pour des éléments \og sans valeur par défaut\fg{}}

\item \textit{Bucket array} ```cpp std::hive``` : plusieurs blocs d'éléments liés entre eux avec un indicateur sur l'état de chaque élément (actif / effacé)

\end{itemize}
\item Possibilité d'utiliser ```cpp std::weak_ptr``` en tant que clé de conteneur associatif
\end{itemize}

#addproposal{p0843}{https://wg21.link/p0843}
#addproposal{P0447}{https://wg21.link/p0447}
#addproposal{P1901}{https://wg21.link/P1901}
#addproposal{P2630}{https://wg21.link/P2630}



== \mintinline[style=white]{cpp}```std::span```}
\begin{itemize}
\item Ajout de ```cpp at()``` à ```cpp std::span```
\item Ajout de ```cpp at()``` à ```cpp std::mdspan```
\item ```cpp std::submdspan()``` retourne une vue sur un sous-ensemble d'un ```cpp std::mdspan```
\item Nouveaux layouts pour ```cpp std::mdspan``` : ```cpp layout_left_padded``` et ```cpp layout_right_padded```
\item Ajout de ```cpp dextents``` à ```cpp std::mdspan```
\end{itemize}

```cpp
	mdspan<float, extents<dynamic_extent, dynamic_extent,
	dynamic_extent>> foo;
	// Devient
	mdspan<float, dextents<3>> foo;
```

\begin{codesample}
\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:35,endLineNumber:10,positionColumn:35,positionLineNumber:10,selectionStartColumn:35,selectionStartLineNumber:10,startColumn:35,startLineNumber:10),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cspan%3E%0A%0Aint+main()%0A%7B%0A+++std::vector%3Cint%3E+foo%7B1,+5,+42,+68,+33%7D%3B%0A+++std::span+bar%7Bstd::begin(foo)+%2B+1,+std::end(foo)%7D%3B%0A%0A+++std::cout+%3C%3C+bar.at(1)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B26+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
\end{codesample}

#addproposal{P2821}{https://wg21.link/p2821}
#addproposal{p3383}{https://wg21.link/p3383}
#addproposal{p3355}{https://wg21.link/p3355}
#addproposal{P2642}{https://wg21.link/P2642}
#addproposal{p2389}{https://wg21.link/p2389}



== Chaînes de caractères}
\begin{itemize}
\item Support de ```cpp std::string_view``` par ```cpp std::stringstream```
\item Interfaçage de ```cpp std::bitset``` avec ```cpp std::string_view```
\item Concaténation de ```cpp std::string``` et ```cpp std::string_view```
\end{itemize}

\begin{codesample}
\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:11,endLineNumber:9,positionColumn:11,positionLineNumber:9,selectionStartColumn:11,selectionStartLineNumber:9,startColumn:11,startLineNumber:9),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%23include+%3Cstring_view%3E%0A%0Aint+main()%0A%7B%0A++++const+std::string+foo%7B%22Hello%22%7D%3B%0A++++const+std::string+bar%7B%22Salut+world!!%22%7D%3B%0A++++const+std::string_view+baz%7Bstd::begin(bar)+%2B+5,+std::end(bar)%7D%3B%0A%0A++++std::cout+%3C%3C+foo+%2B+baz+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B26+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
\end{codesample}

#addproposal{P2495}{https://wg21.link/P2495}
#addproposal{P2697}{https://wg21.link/P2697}
#addproposal{P2591}{https://wg21.link/P2591}



== Initializer-list}
\begin{itemize}
\item \textit{static storage} possible pour les \textit{braced-initializer-list}

// Évite de copier les données depuis le static storage vers le tableau sous-jacent de l'\textit{initializer list} puis vers le conteneur}

\item ```cpp std::span``` sur les \textit{braced-initializer-list}
\end{itemize}

\begin{codesample}
\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:23,endLineNumber:9,positionColumn:23,positionLineNumber:9,selectionStartColumn:23,selectionStartLineNumber:9,startColumn:23,startLineNumber:9),source:'%23include+%3Ciostream%3E%0A%23include+%3Cspan%3E%0A%0Aint+main()%0A%7B%0A++++auto+foo+%3D+%7B5,+7,+12,+42%7D%3B%0A++++const+std::span+bar+%3D+foo%3B%0A%0A++++std::cout+%3C%3C+bar%5B3%5D+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B26+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
\end{codesample}

#addproposal{P2752}{https://wg21.link/P2752}
#addproposal{P2447}{https://wg21.link/P2447}



== ```cpp reference_wrapper```}
\begin{itemize}
\item Comparaison de ```cpp std::reference_wrapper```
\end{itemize}

#addproposal{P2944}{https://wg21.link/P2944}


== Tuples}
\begin{itemize}
\item ```cpp std::complex``` deviennent des \textit{tuple-like}
\end{itemize}

\begin{codesample}
\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:45,endLineNumber:10,positionColumn:45,positionLineNumber:10,selectionStartColumn:45,selectionStartLineNumber:10,startColumn:45,startLineNumber:10),source:'%23include+%3Ciostream%3E%0A%23include+%3Ccomplex%3E%0A%0Aint+main()%0A%7B%0A++++const+std::complex%3Cint%3E+foo%7B1,+5%7D%3B%0A++++std::cout+%3C%3C+std::get%3C1%3E(foo)+%3C%3C+%22%5Cn%22%3B%0A%0A++++const+auto+%5Ba,+b%5D+%3D+foo%3B%0A++++std::cout+%3C%3C+%22(%22+%3C%3C+a+%3C%3C+%22,+%22+%3C%3C+b+%3C%3C+%22)%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B26+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
\end{codesample}

#addproposal{p2819}{https://wg21.link/p2819}


== \mintinline[style=white]{cpp}```std::optional```}
\begin{itemize}
\item Support des références par ```cpp std::optional```
\item ```cpp optional<T&>``` trivialement copiable
\end{itemize}

#addproposal{p2988}{https://wg21.link/p2988}
#addproposal{p3836}{https://wg21.link/p3836}


== Algèbre linéaire}
\begin{itemize}
\item Basé sur un sous-ensemble de #link{https://www.netlib.org/blas/}{BLAS#linklogo()}
\item Multiples opérations
\begin{itemize}
\item Somme de vecteurs
\item Multiplication de vecteurs ou de matrices par un scalaire
\item Produit de vecteurs et de matrices
\item Triangularisation de matrices
\item Rotation de plans
\end{itemize}
\item Plusieurs formats de stockage des matrices
\end{itemize}

```cpp
	vector<double> x_vec{1., 2., 3., 4., 5.};
	mdspan x(x_vec.data(), 5);

	linalg::scale(2.0, x); // x = 2.0 * x
```

#addproposal{P1673}{https://wg21.link/P1673}
#addproposal{p3050}{https://wg21.link/p3050}
#addproposal{p3222}{https://wg21.link/p3222}



== Algorithmes}
\begin{itemize}
\item Algorithmes appelables avec des \textit{list-initialization}
\end{itemize}

```cpp
	struct Foo { int x; int y; };
	vector<Foo> v{ ... };

	find(begin(v), end(v), {3, 4}); // Foo{3, 4} en C++23
```

\begin{codesample}
\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:62,endLineNumber:20,positionColumn:61,positionLineNumber:20,selectionStartColumn:62,selectionStartLineNumber:20,startColumn:61,startLineNumber:20),source:'%23include+%3Ciostream%3E%0A%23include+%3Calgorithm%3E%0A%23include+%3Cvector%3E%0A%0Astruct+Foo%0A%7B%0A++++int+x%3B%0A++++int+y%3B%0A%0A++++bool+operator%3D%3D(const+Foo%26+rhs)+const%0A++++%7B%0A++++++++return+x+%3D%3D+rhs.x+%26%26+y+%3D%3D+rhs.y%3B%0A++++%7D%0A%7D%3B%0A%0Aint+main()%0A%7B%0A%09const+std::vector%3CFoo%3E+foo%7B%7B1,+2%7D,+%7B3,+4%7D,+%7B3,+5%7D,+%7B7,+12%7D%7D%3B%0A%0A%09const+auto+it+%3D+std::find(std::begin(foo),+std::end(foo),+%7B3,+4%7D)%3B%0A++++std::cout+%3C%3C+std::boolalpha+%3C%3C+(it+!!%3D+std::end(foo))+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B26+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
\end{codesample}

#addproposal{P2248}{https://wg21.link/P2248}




== \mintinline[style=white]{cpp}```std::visit()```}
\begin{itemize}
\item Versions membres de ```cpp std::visit()``` et ```cpp std::visit_format_arg()```
\end{itemize}

#addproposal{P2637}{https://wg21.link/P2637}


== Ranges}
\begin{itemize}
\item ```cpp std::views::concat``` concatène plusieurs ranges
\end{itemize}

```cpp
	vector<int> v1{1,2,3}, v2{4,5}, v3{};
	array a{6,7,8};

	// 1, 2, 3, 4, 5, 6, 7, 8
	views::concat(v1, v2, v3, a);
```

\begin{itemize}
\item API de génération de nombres aléatoires
\end{itemize}

```cpp
	array<int, 10> a;
	mt19937 g(777);

	ranges::generate_random(a, g);
```

\begin{codesample}
\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:16,positionColumn:1,positionLineNumber:16,selectionStartColumn:1,selectionStartLineNumber:16,startColumn:1,startLineNumber:16),source:'%23include+%3Ciostream%3E%0A%23include+%3Cranges%3E%0A%23include+%3Cvector%3E%0A%23include+%3Carray%3E%0A%0Aint+main()%0A%7B%0A%09std::vector%3Cint%3E+v1%7B1,2,3%7D,+v2%7B4,5%7D,+v3%7B%7D%3B%0A%09std::array+a%7B6,7,8%7D%3B%0A%0A%09for(const+auto+i:+std::views::concat(v1,+v2,+v3,+a))%0A++++%7B%0A++++++++std::cout+%3C%3C+i+%3C%3C+%22+%22%3B%0A++++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B26+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
\end{codesample}

#addproposal{P2542}{https://wg21.link/P2542}
#addproposal{P1068}{https://wg21.link/P1068}



== Ranges}
\begin{itemize}
\item ```cpp std::views::cache_latest``` met en cache le résultat du dernier déréférencement de l'itérateur sous-jacent
\item ```cpp std::views::to_input``` convertit un range en \textit{input-only} range
\item ```cpp std::ranges::reserve_hint()``` permet de réserver la mémoire pour des \textit{non-sized} ranges dont la taille peut être approximer
\item Concept ```cpp approximately_sized_range``` supporte ```cpp std::ranges::reserve_hint()```
\item Construction d'une ```cpp sub-string_view``` depuis ```cpp std::string```
\item ```cpp views::indices()``` : séquence d'entiers de 0 à $n - 1$
\end{itemize}

#addproposal{p3138}{https://wg21.link/p3138}
#addproposal{p3137}{https://wg21.link/p3137}
#addproposal{p2846}{https://wg21.link/p2846}
#addproposal{p3044}{https://wg21.link/p3044}
#addproposal{p3060}{https://wg21.link/p3060}



== Ranges}
\begin{itemize}
\item Traitement de ```cpp std::optional``` comme un range similaire à ```cpp single_view```
\end{itemize}

```cpp
	optional<int> empty;
	for(int i: empty) { std::cout << i; } // Vide

	optional<int> not_empty;
	for(int i: not_empty) { std::cout << i; } // Un element
```

\begin{itemize}
\item Ajout du choix de l'algorithme de parallélisme aux ranges
\end{itemize}

#addproposal{p3168}{https://wg21.link/p3168}
#addproposal{p3179}{https://wg21.link/p3179}


== Ratio}
\begin{itemize}
\item Ajout des préfixes ```cpp quecto```, ```cpp ronto```, ```cpp ronna``` et ```cpp quetta```
\end{itemize}

#addproposal{P2734}{https://wg21.link/P2734}


== \mintinline[style=white]{cpp}```constexpr```}
\begin{itemize}
\item Davantage de ```cpp constexpr``` dans la bibliothèque standard
\item Conversion depuis ```cpp void*``` dans des contextes ```cpp constexpr```
\begin{itemize}
\item ```cpp std::format()``` au compile-time
\item ```cpp std::function_ref```, ```cpp std::function``` et ```cpp std::any``` ```cpp constexpr```
\end{itemize}
\item Utilisation ```cpp constexpr``` de
\begin{itemize}
\item \textit{Structured bindings}
\item ```cpp atomic```
\item Placement ```cpp new```
\item Conteneurs et adaptateurs
\item Héritage virtuel
\item ```cpp std::shared_ptr```
\item Spécialisations ```cpp std::atomic``` des \textit{smart pointers}
\end{itemize}
\end{itemize}

#addproposal{P2738}{https://wg21.link/P2738}
#addproposal{P2686}{https://wg21.link/P2686}
#addproposal{P3309}{https://wg21.link/P3309}
#addproposal{p2747}{https://wg21.link/p2747}
#addproposal{p3372}{https://wg21.link/p3372}
#addproposal{p3533}{https://wg21.link/p3533}
#addproposal{p3037}{https://wg21.link/p3037}



== Exceptions}
\begin{itemize}
\item Possibilité de lancer des exceptions dans des fonctions ```cpp consteval```
\begin{itemize}
\item Erreur de compilation si l'exception est lancé lors d'une évaluation \textit{compile-time}
\end{itemize}
\end{itemize}

#addproposal{P3068}{https://wg21.link/P3068}
#addproposal{P3378}{https://wg21.link/P3378}


== Parameters pack}
\begin{itemize}
\item Indexation des \textit{packs}
\end{itemize}

```cpp
	template <typename... T>
	constexpr auto first_plus_last(T... values) -> T...[0] {
	  return T...[0](values...[0] + values...[sizeof...(values)-1]);
	}

	first_plus_last(1, 2, 10);  // 11
```

\begin{codesample}
\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:13,positionColumn:1,positionLineNumber:13,selectionStartColumn:1,selectionStartLineNumber:13,startColumn:1,startLineNumber:13),source:'%23include+%3Ciostream%3E%0A%0Atemplate+%3Ctypename...+T%3E%0Avoid+first_plus_last(T...+values)%0A%7B%0A++std::cout+%3C%3C+T...%5B0%5D(values...%5B0%5D+%2B+values...%5Bsizeof...(values)-1%5D)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++first_plus_last(1,+2,+10)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B26+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
\end{codesample}

#addproposal{P2662}{https://wg21.link/P2662}


== lifetime}
\begin{itemize}
\item ```cpp std::is_within_lifetime()``` indique si l'objet pointé est vivant
\item ... en particulier si un membre d'une union est active
\end{itemize}

#addproposal{P2641}{https://wg21.link/P2641}


== Gestion mémoire}
\begin{itemize}
\item \textit{hazard pointers} : unique écrivain, multiples lecteurs
\item Structure de donnée \textit{read-copy update}
\begin{itemize}
\item Une mise à jour entraine une copie
\item Chaque thread utilise soit l'ancienne soit la nouvelle version
\item Donc une version cohérente
\end{itemize}
\end{itemize}

#addproposal{P2530}{https://wg21.link/P2530}
#addproposal{P2545}{https://wg21.link/P2545}



== SIMD (Single Instruction on Multiple Data)}
\begin{itemize}
\item Intégration de ```cpp simd```
\item ```cpp simd<T>``` se comporte comme ```cpp T``` mais manipule plusieurs valeurs simultanément
\end{itemize}

```cpp
	native_simd<int> a = 1;                           // 1 1 1 1
	native_simd<int> b([](int i) { return i - 2; });  // -2 -1 0 1
	auto c = a + b;                                   // -1 0 1 2
	auto d = c * c;                                   // 1 0 1 4
	auto e = reduce(d);                               // 6
```

#addproposal{p1928}{https://wg21.link/p1928}
#addproposal{P3430}{https://wg21.link/P3430}
#addproposal{P3441}{https://wg21.link/P3441}
#addproposal{P3287}{https://wg21.link/P3287}
#addproposal{P2663}{https://wg21.link/P2663}
#addproposal{P2933}{https://wg21.link/P2933}


== Traits}
\begin{itemize}
\item Trait ```cpp std::is_virtual_base_of``` indiquant si une classe est une classe de base virtuelle d'une autre
\end{itemize}

#addproposal{p2985}{https://wg21.link/p2985}


== Type appelable}
\begin{itemize}
\item ```cpp std::copiable_function``` pour les fonctions copiables
\item ```cpp std::function_ref```
\begin{itemize}
\item Type référence pour le passage d'appelable à une fonction
\item Plus générique et moins gourmand que ```cpp std::function``` et équivalents

// Les fonctions n'ont pas besoin d'être copiables ni déplaçables}
\end{itemize}
\end{itemize}

#addproposal{P2548}{https://wg21.link/P2548}
#addproposal{P0792}{https://wg21.link/P0792}



== Binding}
\begin{itemize}
\item Surcharge de ```cpp std::bind_front()``` et ```cpp std::bind_back()``` prenant l'appelable en paramètre template
\item Surcharge de ```cpp std::not_fn()``` prenant l'appelable en paramètre template
\end{itemize}

```cpp
	struct S { void foo() {...} };

	bind_front(&S::foo, s, p1, p2);
	// devient
	bind_front<&S::foo>(s, p1, p2);
```

#addproposal{p2714}{https://wg21.link/p2714}


== Attributs}
\begin{itemize}
\item Attributs sur les structured binding
\end{itemize}

```cpp
	auto [a, b [[attribute]], c] = foo();
```

\begin{itemize}
\item ```cpp [[indeterminate]]``` indique qu'une variable non initialisée a une valeur indéterminé
\begin{itemize}
\item Conséquence de l'introduction d'\textit{Erroneous Behavior}
\item Permet de revenir au comportement pré-C++26
\end{itemize}
\end{itemize}

```cpp
	int x [[indeterminate]]; // indeterminate value
	int y;                   // erroneous value

	f(x); // undefined behavior
	f(y); // erroneous behavior
```

#addproposal{P0609}{https://wg21.link/P0609}
#addproposal{p2795}{https://wg21.link/p2795}


== \mintinline[style=white]{cpp}```std::format```}
\begin{itemize}
\item Possibilité de fournir une chaîne de format au \textit{runtime}
\item Amélioration du support de ```cpp std::filesystem::path```
\begin{itemize}
\item Présence de caractères d'échappement (p.ex. \mintinline[escapeinside=``````]{cpp}{```\textbackslash```n})
			\item Support de caractère UTF-8
		\end{itemize}
	\end{itemize}

	```cpp
		string str = "{}";
		format(runtime_format(str), 42);
	```

	\begin{itemize}
		\item Redéfinition de ```cpp std::to_string``` en terme de ```cpp std::format```
		\item Davantage de vérifications \textit{compile-time} du type des arguments
		\begin{itemize}
			\item Déjà le cas de la majorité des erreurs
			\item ... mais pas de toutes
		\end{itemize}
	\end{itemize}

	```cpp
		format("{:>{}}", "hello", "10");
		// Erreur run-time
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%23include+%3Cstring%3E%0A%0Aint+main()%0A%7B%0A++std::string+str+%3D+%22%7B%7D%22%3B%0A++std::cout+%3C%3C+std::format(std::runtime_format(str),+42)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B26+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	#addproposal{p2905}{https://wg21.link/p2905}
	#addproposal{P2918}{https://wg21.link/P2918}
	#addproposal{P2845}{https://wg21.link/P2845}
	#addproposal{p2909}{https://wg21.link/p2909}
	#addproposal{P2587}{https://wg21.link/P2587}
	#addproposal{P2757}{https://wg21.link/P2757}



== \mintinline[style=white]{cpp}```std::format```}
	\begin{itemize}
		\item Formatage des pointeurs
	\end{itemize}

	```cpp
		format("{:#018X}", reinterpret_cast<uintptr_t>(&i));
		// 0X00007FFE0325C4E4
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++int+i+%3D+0%3B%0A++std::cout+%3C%3C+std::format(%22%7B:%23018X%7D%22,+reinterpret_cast%3Cuintptr_t%3E(%26i))%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B26+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	#addproposal{P2510}{https://wg21.link/P2510}



== \mintinline[style=white]{cpp}```std::print```}
	\begin{itemize}
		\item Impression de ligne vide
	\end{itemize}

	```cpp
		println();
		// println("") en C++23
	```

	\begin{itemize}
		\item Optimisation de ```cpp std::print()```
	\end{itemize}

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:16,endLineNumber:2,positionColumn:16,positionLineNumber:2,selectionStartColumn:16,selectionStartLineNumber:2,startColumn:16,startLineNumber:2),source:'%23include+%3Ciostream%3E%0A%23include+%3Cprint%3E%0A%0Aint+main()%0A%7B%0A++++std::println(%22ligne+1%22)%3B%0A++++std::println()%3B%0A++++std::println(%22ligne+3%22)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B26+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	#addproposal{P3142}{https://wg21.link/P3142}
	#addproposal{p3107}{https://wg21.link/p3107}
	#addproposal{p3235}{https://wg21.link/p3235}


\subsection*{Durées et temps}

== Durées et temps}
	\begin{itemize}
		\item Spécialisation de ```cpp std::hash``` pour ```cpp std::chrono```
	\end{itemize}

	#addproposal{P2592}{https://wg21.link/P2592}


\subsection*{Système de fichiers}

== Accès bas-niveaux aux IO}
	\begin{itemize}
		\item Alias ```cpp native_handle_type``` sur le descripteur de fichier de la plateforme
		\item ```cpp native_handle()``` retourne ce descripteur
	\end{itemize}

	#addproposal{P1759}{https://wg21.link/P1759}


\subsection*{Concurrence}

== Concurrence}
	\begin{itemize}
		\item Version ```cpp atomic``` de minimum et maximum
		\item Obtention de l'adresse de l'objet référencé par ```cpp std::atomic_ref``` via ```cpp address()```
		\item ```cpp std::execution``` : gestion d'exécution asynchrone
		\begin{itemize}
			\item Basé sur des \textit{schedulers}, \textit{senders} et \textit{receivers}
			\item Et un ensemble d'algorithmes asynchrones
		\end{itemize}
		\item ```cpp std::async_scope``` : RAII sur du code non séquentiel et non \textit{stack-based}
		\item Contexte d'exécution asynchrone standard (interface aux pools de thread)
		\item Type pour contenir les \textit{coroutine tasks} : ```cpp std::execution::task```
		\item ```cpp std::store_XXX()``` équivalents à ```cpp std::fetch_XXX()``` ne retournant pas l'ancienne valeur
	\end{itemize}

	#addproposal{P0493}{https://wg21.link/P0493}
	#addproposal{p3008}{https://wg21.link/p3008}
	#addproposal{p2835}{https://wg21.link/p2835}
	#addproposal{p2300}{https://wg21.link/p2300}
	#addproposal{p3325}{https://wg21.link/p3325}
	#addproposal{p3149}{https://wg21.link/p3149}
	#addproposal{p2079}{https://wg21.link/p2079}
	#addproposal{p3552}{https://wg21.link/p3552}
	#addproposal{p3111}{https://wg21.link/p3111}


\subsection*{Générateurs aléatoires}

== Générateurs}
	\begin{itemize}
		\item Ajout des moteurs \textit{counter based Philox}
	\end{itemize}

	#addproposal{p2075}{https://wg21.link/p2075}


\subsection*{Contract}

== Contrats - Présentation}
	\begin{itemize}
		\item Support de la programmation par contrat
		\item Remplace la vérification via ```cpp assert```
		\item Et la documentation via commentaires \mintinline[escapeinside=``````]{cpp}{```@```pre}, \mintinline[escapeinside=``````]{cpp}{```@```post} et \mintinline[escapeinside=``````]{cpp}{```@```invariant}
\item Intégration des contrats à la bibliothèque standard
\begin{itemize}
\item Vérification des bornes
\item Présence d'un élément avant accès (```cpp std::optional```, ```cpp std::expected```)
\end{itemize}
\end{itemize}

#noteblock{Note}
Version plutôt minimale des contrats
\end{block}

#noteblock{Note}
Paramètres et variables définies hors du contrat sont constants lors de la vérification des contrats
\end{block}

#addproposal{P2900}{https://wg21.link/P2900}



== Contrats - Présentation}
#alertblock{Nombreuses critiques}
\begin{itemize}
\item #link{https://wg21.link/p3909}{P3909 : Contracts should go into a White Paper - even at this late point}
\item #link{https://wg21.link/p3851}{P3851 : Position on contracts assertion for C++26}
\item #link{https://wg21.link/P4043}{P4043 : Are C++ Contracts Ready to Ship in C++26?}
\item #link{https://wg21.link/p4020}{P4020 : Concerns about contract assertions}
\end{itemize}

\end{alertblock}




== Contrats - Présentation}
\begin{itemize}
\item Fonctions non supportées (futures propositions)
\begin{itemize}
\item Préconditions et postconditions sur les fonctions virtuelles
\item Préconditions et postconditions sur les pointeurs de fonction
\item Accès à la valeur originale des paramètres dans les postconditions
\item Sémantique ```cpp assume``` sur les contrats non vérifiés

// Permettait au compilateur d'optimiser en fonction du contrat}

\item Définition de la sémantique dans la déclaration du contrat
\item Définition de propriété du contrat dans la déclaration du contrat
\item Postconditions sur les fonctions ne sortant pas
\item Postconditions sur les sorties par exception
\item Contrats non évaluables au runtime
\item État du contrat utilisable hors du contrat
\item Invariants
\end{itemize}
\end{itemize}



== Contrats - Préconditions}
\begin{itemize}
\item Sur les déclarations de fonctions et coroutines
\item Introduites par le mot-clé contextuel ```cpp pre```
\item Évaluées après l'initialisation des paramètres et avant le corps de la fonction
\item Dans l'ordre des déclarations
\end{itemize}

```cpp
	int f(int i)
	pre (i >= 0)
	{...}
```



== Contrats - Postconditions}
\begin{itemize}
\item Sur les déclarations de fonctions et coroutines
\item Introduites par le mot-clé contextuel ```cpp post```
\item Évaluées lors d'une sortie normale de fonction
\item Après la destruction des variables locales
\item Dans l'ordre des déclarations
\item Récupération de la valeur de retour dans une variable précédant la condition
\end{itemize}

```cpp
	int f(int i)
	post (r: r > 0)
	{...}
```

#noteblock{Note}
\begin{itemize}
\item Seuls les paramètres ```cpp const``` ou de type référence sont utilisables
\end{itemize}
\end{block}



== Contrats - Assertions}
\begin{itemize}
\item Dans le corps des fonctions
\item Introduite par le mot-clé ```cpp contract_assert```
\end{itemize}

```cpp
	int f(int i)
	pre (i >= 0)
	post (r: r > 0) {
	  contract_assert (i >= 0);
	  return i + 1; }
```

\begin{codesample}
\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:6,endLineNumber:17,positionColumn:5,positionLineNumber:17,selectionStartColumn:6,selectionStartLineNumber:17,startColumn:5,startLineNumber:17),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%0Aconstexpr+int+foo(int+a,+int+b)%0A++%5B%5Bpre:+a+%3E+0+%26%26+b+%3E+0%5D%5D%0A++%5B%5Bpost+r:+r+%3E+10%5D%5D%0A%7B%0A++++return+a+/+b%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+foo(120,+3)+%3C%3C+%22%5Cn%22%3B%0A%23if+0%0A++std::cout+%3C%3C+foo(6,+3)+%3C%3C+%22%5Cn%22%3B%0A%23endif%0A%23if+1%0A++std::cout+%3C%3C+foo(120,+0)+%3C%3C+%22%5Cn%22%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:g152,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-Wall+-Wextra+-pedantic+-fcontracts+-Wno-unused-parameter',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',wrap:'1'),l:'5',n:'0',o:'Executor+x86-64+gcc+15.2+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
\end{codesample}



== Contrats - Sémantiques}
\begin{itemize}
\item Plusieurs sémantiques
\begin{itemize}
\item ```cpp ignore``` : contrat non vérifié
\item ```cpp observe``` : appel au \textit{handler} de violation de contrat et poursuite
\item ```cpp enforce``` : appel au \textit{handler} de violation de contrat et terminaison
\item ```cpp quick_enforce``` : terminaison

// ```cpp enforce``` : arrêt systématique}
// ```cpp observe``` : on laisse le \textit{handler} décider}
\end{itemize}
\item Si la violation est détectée à la compilation
\begin{itemize}
\item ```cpp observe``` : warning
\item ```cpp enforce``` et ```cpp quick_enforce``` : erreur
\end{itemize}
\item Possibilité de remplacer le \textit{handler} par défaut :
\begin{itemize}
\item Fonction ```cpp handle_contract_violation```
\item Paramètre de type ```cpp std::contracts::contract_violation```
\end{itemize}
\end{itemize}


== Reflection}
\begin{itemize}
\item Support de la réflexion statique
\begin{itemize}
\item Un type opaque ```cpp std::meta::info``` pour représenter les éléments du programme
\item Un opérateur de réflexion ```cpp ^^```
\item Plusieurs méta-fonctions de réflexion
\item Une construction de production des éléments ```cpp [: refl :]```
\end{itemize}
\item Introspection
\item Méta-programmation et code \textit{compile-time}
\item Injection
\item Construction de données statiques depuis du \textit{compile-time} : ```cpp std::define_static_string```, ```cpp std::define_static_object``` et ```cpp std::define_static_array```
\end{itemize}

#addproposal{p2996}{https://wg21.link/p2996}
#addproposal{p3096}{https://wg21.link/p3096}
#addproposal{p1306}{https://wg21.link/p1306}
#addproposal{p3491}{https://wg21.link/p3491}
#addproposal{p3293}{https://wg21.link/p3293}
#addproposal{p3394}{https://wg21.link/p3394}
#addproposal{p3560}{https://wg21.link/p3560}



== Reflection}
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


== Modules}
\begin{itemize}
\item Suppression de l'expansion de macros dans les déclarations de module
\end{itemize}

#addproposal{P3034}{https://wg21.link/P3034}



== Compilation et implémentation}
\begin{itemize}
\item ```cpp #embed``` ressources externes disponibles au \textit{runtime}
\end{itemize}

```cpp
	const unsigned char foo[] = {
	  #embed "foo.png"
	};
```

#addproposal{p1967}{https://wg21.link/p1967}



== Debug}
\begin{itemize}
\item ```cpp std::breakpoint()``` : point d'arrêt dans le programme
\item ```cpp std::breakpoint_if_debugging``` : point d'arrêt si l'exécution se fait dans un debugger
\item ```cpp std::is_debugger_present()``` permet de savoir si l'exécution se fait dans un debugger
\end{itemize}

#addproposal{P2546}{https://wg21.link/P2546}

\end{document}
