#import "./model.typ": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#show: slides.with(
  title: "C++",
  date: datetime.today().display("[day]/[month]/[year]"),
  authors: "Grégory Lerbret",
  footer: true,
  toc: true,
)

= Retour sur C++98 / C++03

== Rappels historiques

- Années 80 -- "C with classes" par Bjarne Stroustrup aux Bell Labs
- 1983 -- renommé C++
- 1985 -- première version publique de CFront
- 1985 -- première version de _The C++ Programming Language_
- 1998 -- première normalisation
- 2003 -- amendement
- 2007 -- publication du premier _Technical Report_ (TR1)

  // Les TR ne sont pas normatifs
  // An informative document containing information of a different kind from that normally published in a normative document

  - Partiellement implémenté par certains compilateurs ou Boost
  - Partiellement repris dans les normes suivantes et TS

// Les TS sont des documents normatifs ayant vocation a être intégrés dans la norme, essentiellement des preview
// TS : A normative document representing the technical consensus within an ISO committee

- Projet de TR2 finalement transposé en _Technical Specification_

== Philosophie du C++

- Multi-paradigme

// Procédural, objet, générique et Template metaprogramming

- Typage statique déclaratif
- Généraliste
- Initialement, ajout des classes au C
- Vaste sous-ensemble commun (proche du C) entre C et C++
- _Zero-overhead abstraction_
- Compatibilité ascendante forte mais pas absolue
- Évolutions par les bibliothèques plutôt que par le langage
- Pas de "magie" dans la bibliothèque standard

== Normalisation

- Normalisé par #link("http://www.open-std.org/JTC1/SC22/WG21/")[l'ISO (JTC1/SC22/WG21 #linklogo())]
- Comité distinct de celui du C

// C : Working group 14

- ... mais plusieurs membres en commun
- Pas de propriétaire du C++

// Donc libre de droit, mais la norme ISO définitive est payante

== Normalisation

- Actualité de normalisation, et du C++ en général : #link("https://isocpp.org/")[isocpp.org #linklogo()]

#alertblock("isocpp.org n'est pas le site du comité", text[
  - Site de _Standard C++ Foundation_ dont le but est la promotion du C++
  - Les deux sont cependant très proches et partagent de nombreux membres
])

- ... ainsi que les #link("https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines")[C++ Core Guidelines #linklogo()]
- #link("https://github.com/cplusplus")[Dépôt GIT #linklogo()] (brouillons et propositions)}
- Conférence annuelle #link("http://cppcon.org/")[cppcon #linklogo()]

== Norme et support

- Compilateurs
  - GCC -- #link("https://gcc.gnu.org/projects/cxx-status.html")[C++ Standards Support in GCC #linklogo()]
  - Clang -- #link("http://clang.llvm.org/cxx_status.html")[C++ Support in Clang #linklogo()]
  - Visual studio -- #link("https://docs.microsoft.com/fr-fr/cpp/overview/visual-cpp-language-conformance?view=msvc-160")[Conformité du langage Microsoft C++ #linklogo()]
- Bibliothèques standards
  - GCC -- #link("https://gcc.gnu.org/onlinedocs/libstdc++/manual/status.html")[status.html #linklogo()]
  - Clang -- #link("https://libcxx.llvm.org/")[C++ Standard Library #linklogo()]
- Vision globale -- #link("http://en.cppreference.com/w/cpp/compiler_support")[C++ compiler support #linklogo()]

#noteblock("Sites de référence C++", text[
  - #link("https://en.cppreference.com/w/")[cppreference.com #linklogo()]
  - #link("https://hackingcpp.com/")[hacking C++ #linklogo()]
])

== Erreurs -- Code retour

- Plusieurs variantes
  - Type de retour dédié
  - Valeur particulière notant un échec (```cpp NULL```, ```cpp -1```)
  - Récupération de la dernière erreur (```cpp errno```, ```cpp GetLastError()```)
- Nécessite "un test toutes les deux lignes"
- Gestion manuelle de la remontée de la pile d'appel
- Adapté au traitement local des erreurs, pas au traitement "plus haut"

#alertblock("Problèmes et limites", text[
  - Impact négatif sur la lisibilité
  - Souvent délaissée dans un contexte d'enseignement ou de formation
  - Beaucoup de code avec une gestion d'erreur déficiente
])

== Erreurs -- Exceptions

- Lancées par ```cpp throw```
- Attrapées par ```cpp catch()``` depuis un bloc ```cpp try```


```cpp
try {
  ...
  // Lancement d'une exception
  throw logic_error("Oups !");
  ...
}
catch(logic_error& e) {
  // Traitement de l'exception
  ...
}
```

== Erreurs -- Exceptions

- Type quelconque
- Idéalement héritant de ```cpp std::exception``` (via ```cpp std::logic_error```, ```cpp std::runtime_error``` ou autres)
- ```cpp catch(...)``` pour attraper les exceptions de tout type
- Compatibles avec le _stack unwinding_
- Pas de ```cpp finally```
- Appel de ```cpp std::terminate()``` si une exception n'est pas attrapée
- Utilisées par la bibliothèque standard (p.ex. ```cpp std::bad_alloc```)

== Erreurs -- Critiques des exceptions
- Critiquées, voire interdites, par certaines normes de codage (p.ex. : #link("https://google.github.io/styleguide/cppguide.html")[Google C++ Style Guide #linklogo()]
- Arguments très variés
  - "Je ne comprends pas", "Ça ne sert à rien", ...
  - Impact négatif sur les performances

#noteblock("À nuancer", text[
  - Initialement vrai
  - Actuellement, une exception non levée ne coûte quasiment rien
  - Souvent comparée à une non gestion d'erreur, est-ce pertinent ?
])

== Erreurs -- Critiques des exceptions

#list(marker: [ ], text[
  - Mauvais support par les différents outils
])

#noteblock("À nuancer", text[
  - Correctement supportées par les compilateurs actuels
  - Inégalement gérées par les outils d'analyse, de documentation, ...
])

#list(
  marker: [ ],
  text[
    - Code plus complexe à analyser

    //Complexité discutable : il faut une vision plus globale, donc plus complexe, pour suivre un programme. Mais le code local est plus simple vu qu'il n'est pas noyé de code dédié à la gestion d'erreur

    - Difficiles à introduire dans une large base de code sans exception

    // Argument de la difficulté d'introduction à nuancer toutefois avec la levée d'exception par la bibliothèque standard qui a lieu dans tous les cas (hors options particulières du compilateur)

    - Absence d'ABI normalisée
  ],
)

//Le problème d'ABI est plus large que les seules exceptions

== Erreurs -- Exception safety
- _No-throw guarantee_ : l'opération ne peut pas échouer

#adviceblock("Do", text[
  - Destructeurs et ```cpp swap()``` ne doivent pas lever d'exception
])

- _Strong exception safety_ : pas d'effet de bord, pas de fuite, état conservé
- _Basic exception safety_ : pas de fuite, invariants conservés
- _No exception safety_ : aucune garantie

== Erreurs -- Exception safety

#adviceblock("Do", text[
  - Privilégiez les garanties les plus fortes possibles
])

#alertblock("Don't", text[
  - Évitez la garantie faible
  - Évitez absolument le _No exception safety_
])

== Erreurs -- Exception safety

#adviceblock("Do", text[
  - Utilisez l'idiome _copy-and-swap_ pour la _Strong exception safety_
])

```cpp
class A {
public:
  A(const A&);
  A& operator=(A);
  friend void swap(A& lhs, A& rhs);  // Nothrow
};

A& A::operator=(A other) {           // Copy
  swap(*this, other);                // Swap
  return *this;
}
```
== Erreurs -- Exceptions et bonnes pratiques

#adviceblock("Do", text[
  - _Throw by value, catch by const reference_ (voir _C++ Coding Standards_, 73)
])

#adviceblock("Do", text[
  - Utilisez des types dédiés héritant de ```cpp std::exception```
  - Définissez des hiérarchies d'exceptions
])

#adviceblock("Do", text[
  - Capturez uniquement là où vous savez traiter l'erreur
])

== Erreurs -- Exceptions et bonnes pratiques

#alertblock("Don't", text[
  - N'utilisez jamais les exceptions pour contrôler le flux d'exécution
  - Ni pour gérer les "échecs attendus"
  - Réservez les exceptions au signalement d'erreurs
])

\ // Pour corriger une souci de mise en page avec le footer

== Erreurs -- ```cpp assert```

- Arrête le programme si l'expression est évalué à 0
- Affiche au moins l'expression, le fichier et la ligne

```cpp
assert(expression);
```

- Sans effet lorsque ```cpp NDEBUG``` est défini
  - Coût nul en _Release_
  - Inutilisable pour les erreurs d'exécution et le contrôle des entrées

#noteblock("Objectifs", text[
  - Traquer les erreurs de programmation et les violations de contrat interne
])

== Erreurs -- Conclusion

#adviceblock("Do", text[
  - Utilisez exceptions et codes retour pour les erreurs d'exécution et la vérification des données externes
  - Réservez ```cpp assert``` aux erreurs de programmation et à la vérification des contrats internes
])

#adviceblock("Do", text[
  - Préférez les exceptions aux codes retour (voir _C++ Coding Standards_, 72)
])


#alertblock("Don't", text[
  - Jamais d'```cpp assert``` pour les erreurs d'exécution et le contrôle des entrées
])

== Ressources -- Gestion manuelle

#alertblock(none, text[
  - Comment gérer les erreurs ?
])

- Solution C : _Single Entry Single Exit_, bloc unique de libération

```cpp
char* memory = malloc(50);
if(!memory) goto err;
...
err:
free(memory);
```
#list(
  marker: [ ],
  text[
    - Laborieux
    - Difficile à mettre en place en présence d'exceptions
  ],
)

== Ressources -- Gestion manuelle

#noteblock("Quiz : Comment éviter les fuites mémoires ?", ```cpp
char* memory1 = NULL;
char* memory2 = NULL;
...
memory1 = new char[50];
...
memory2 = new char[200];
...
delete[] memory1;
delete[] memory2;
```)

== Ressources -- Gestion manuelle

#alertblock(none, text[
  - Comment copier des classes possédant des ressources ?
])

- Constructeurs et opérateurs générés copient les adresses des pointeurs
- Une double libération est une erreur

```cpp
struct Foo {
public:
  Foo() : bar(new char[50]) {}
  ~Foo() { delete[] bar; }

private:
  char* bar;
};
```

== Ressources -- Bonnes pratiques

#adviceblock("Do", text[
  - Si une classe manipule une ressource brute, elle doit
    - Soit définir constructeur de copie et opérateur d'affectation
    - Soit les déclarer privés sans les définir (classe non copiable)
])

#adviceblock(text[_Big Rule of three_], text[
  - Si vous devez définir le constructeur de copie, l'opérateur d'affectation ou le destructeur, alors vous devriez définir les trois
])

// Forme canonique orthodoxe de Coplien
// Thèse de Coplien : Multi-paradigm Design


== Ressources -- RAII

// Resource Acquisition Is Initialization

- Acquisition des ressources lors de l'initialisation de l'objet
- Libération automatique lors de sa destruction

// Proche du try with resources de Java ou du with de Python

- Propriété intrinsèque des objets par design

// Contrairement à Java ou Python où c'est une propriété de l'usage

- Fonctionnement de la bibliothèque standard (conteneurs, fichiers, ...)
- Conséquences
  - Objets créés dans un état cohérent, testable et utilisable
  - Ressources automatiquement libérées à la destruction de l'objet

  // Et de façon déterministe

  - Capsules RAII copiables sans effort

#adviceblock("Do", text[
  - Utilisez RAII pour vos objets
])

== Ressources -- RAII

#adviceblock("Do", text[
  - Faites des constructeurs qui construisent des objets
    - Cohérents
    - Utilisables
    - Complètement initialisés
])

#alertblock("Don't", text[
  - Évitez les couples constructeur vide et fonction d'initialisation
  - Évitez les couples constructeur vide et ensemble de mutateurs
])

== Ressources -- Limites du RAII

#alertblock("Gestion des erreurs", text[
  - Pas d'erreur ni d'exception dans les destructeurs
  - La libération peut échouer (p.ex. ```cpp flush()``` lors de la fermeture de fichier)
])

```cpp
{
  ifstream src("input.txt");
  ofstream dst("output.txt");
  copy_files(src, dst);
}

remove_file(src);  // Potentielle perte de donnees
```

//Problème résolu en forçant l'écriture (flush) en fin de la fonction copy_files() et en remontant une exception en cas d'erreur

== Ressources -- Limites du RAII

#alertblock(```cpp std::auto_ptr```, text[
  - Copiable
  - La copie transfère la responsabilité de la ressource
])

```cpp
void foo(auto_ptr<int> bar) {}

auto_ptr<int> bar(new int(5));
foo(bar);
cout << *bar << "\n";  // Erreur : bar n'est plus utilisable
```

== Ressources -- Loi de Déméter

// À strictement parler, gestion de l'accès aux ressources pas de la libération

- Principe de connaissance minimale
- Un objet ```cpp A``` peut utiliser les services d'un deuxième objet ```cpp B```
- ... mais ne doit pas utiliser ```cpp B``` pour accéder à un troisième objet
- En particulier, une classe n'expose pas ses données

#noteblock("Exceptions", text[
  - Agrégats et conteneurs dont le rôle est de contenir des données
])

// Agrégat désigne ici des classes, ou structures, qui agrègent un ensemble de données ensembles sans comportement ni invariant. Ce n'est pas exactement la même chose que l'aggregate du standard}
// Certains utilisent aussi le terme d'agglomérat, ce qui évite la confusion

#noteblock("Objectifs", text[
  - Mise en place du RAII
  - Meilleure encapsulation
  - Respect des _patterns_ SOLID et GRASP
  - Meilleure lisibilité, maintenabilité et ré-utilisabilité
])

// Notamment le principe ouvert-fermé, l'inversion de dépendance et le couplage faible
// GRASP : General Responsibility Assignment Software Patterns (ou Principles)
// SOLID : SRP, OCP, LSP, ISP, DIP
// SRP : principe de responsabilité unique
// OCP : principe ouvert/fermé
// LSP : Principe de substitution de Liskov
// ISP : Principe de ségrégation des interfaces
// DIP : Principe d'inversion des dépendances

== Ressources -- Loi de Déméter

#adviceblock("Do, agrégats", text[
  - Préférez les structures aux classes
  - Laissez les membres publics
  - Fournissez, éventuellement, des constructeurs initialisant les données
])

#adviceblock("Do, conteneurs", text[
  - Respectez l'interface et la logique des conteneurs standards
])

#adviceblock("Do, classes de service", text[
  - Exposez des services, pas des données
  - Pas de données publiques
  - Limitez les accesseurs et les mutateurs
])

== Ressources -- Loi de Déméter

#noteblock("Conseils", text[
  - N'hésitez pas à étendre l'interface de classe avec des fonctions libres
  - Pensez à l'amitié pour cette interface étendue
  - Implémentez-la en terme de fonctions membres (p.ex. ```cpp +``` à partir de ```cpp+=```)
])

```cpp
class Foo {
public:
  Foo& operator+=(const Foo& other);
};

Foo operator+(Foo lhs, const Foo& rhs) {
  return lhs += rhs;
}
```

== Ressources -- Et le Garbage Collector ?

- Pas de GC dans le langage ni dans la bibliothèque standard
- Au moins un GC en bibliothèque tierce (#link("http://www.hboehm.info/gc/")[Hans Boehm #linklogo()])
- ... mais limité par manque de support par le langage
- Non déterministe : adapté à la mémoire pas aux autres ressources
- Particulièrement adapté à la gestion des structures cycliques
- D'autres avantages pour la mémoire (compactage, recyclage, ...)

// Mais ces fonctionnalités évoluées des GC ne sont probablement pas compatibles avec le fonctionnement du C++

#noteblock("Wait and see", text[
  - Un complément à RAII, pas un concurrent ni un remplaçant
  - Indisponible à ce jour
])

== Ressources -- Conclusion

#adviceblock("Do, RAII", text[
  - Préférez les classes RAII de la bibliothèque standard aux ressources brutes
  - Encapsulez les ressources dans des capsules RAII standards
  - Concevez vos classes en respectant le RAII
])

#adviceblock("Do, Déméter", text[
  - Respectez Déméter
])

== Ressources -- Conclusion

#alertblock("Don't", text[
  - Pas de ```cpp delete``` dans le code applicatif
])

#alertblock("Attention", text[
  - Sous Linux, méfiez-vous de l'_Optimistic Memory Allocator_

  // Retourne une adresse lors d'un new ou d'un malloc() sans allocation et avec peu de contrôle
  // Allocation uniquement lors de l'usage de la mémoire
  // Si manque de mémoire à ce moment : une application est tuée (probablement le demandeur ou la plus gourmande, influence du \textit{uptime}, de la priorité ou du propriétaire ?) mais jamais init
  // Pourquoi OMA : les logiciels demandent plus de mémoire que ce qu'ils utilisent réellement

  - Pensez à paramétrer correctement l'OS
])

== STL -- Standard Template Library
- Partie de la bibliothèque standard comprenant
  - Conteneurs et ```cpp std::basic_string```
  - Itérateurs
  - Algorithmes manipulation les données des conteneurs via les itérateurs

#noteblock("Note", text[
  - Quelques algorithmes manipulant directement des données (p.ex. ```cpp std::min()```)
])

- Conçue initialement par Alexander Stepanov
  - Promoteur de la programmation générique

  // Programmation générique : template en C++, generic en Java
  // Programmation générique = polymorphisme paramétrique

  - Sceptique vis à vis de la POO

// Pour Stepanov : POO = hoax (canular)
// Stepanov ne s'oppose pas à l'abstraction et à encapsulation mais à la façon dont la POO prétend y répondre

- Basée sur les templates, pas sur la POO

== STL -- Standard Template Library

#noteblock("Intérêts", text[
  - $n$ conteneurs et $m$ algorithmes, seulement $m$ implémentations
  - Tout nouvel algorithme est disponible sur tous les conteneurs compatibles
  - Tout nouveau conteneur bénéficie de tous les algorithmes compatibles
  - Changement de conteneur à effort réduit
])

#noteblock("Pour aller plus loin", text[
  - Voir _Effective STL_ de Scott Meyers
])

== STL -- Standard Template Library

#noteblock("À nuancer", text[
  - Algorithmes membres sur certains conteneurs
    - Accès par itérateurs insuffisant (p.ex. ```cpp std::list```)
    - Habitudes et historiques (p.ex. ```cpp std::string```)
    - Performances (p.ex. ```cpp map.find()```)
])

== STL Conteneurs -- Généralités

- Contiennent des objets copiables et non constants
- ... qui peuvent être les adresses d'autres objets

#alertblock("Conteneurs de pointeurs", text[
  - Pas de libération automatique des objets pointés
])

- ... accessibles via un itérateur
- Fourniture possible d'une politique d'allocation
- Vu des algorithmes, ce qui fournit une paire d'itérateurs, est un conteneur

== STL Conteneurs -- Conteneurs séquentiels
- ```cpp std::vector```
  - Tableau de taille variable d'éléments contigus
  - Accès indexé
  - Croissance en temps amorti
  - Modifications en fin de vecteur (coûteux ailleurs)
  - Compatible avec l'organisation mémoire des tableaux C

#alertblock(text[``` std::vector<bool>``` n'est pas un vecteur de booléen], text[
  - Ne remplit pas tous les pré-requis des conteneurs
  - ```cpp operator[]``` ne retourne pas le booléen mais un _proxy_ vers celui-ci
  - Voir _Effective STL_ item 18
])

== STL Conteneurs -- Conteneurs séquentiels

- ```cpp std::list```
  - Liste doublement chaînée
  - Accès bidirectionnel non indexé
  - Modification n'importe où à faible coût
  - Plusieurs algorithmes membres (tri, fusion, suppression, ...)

- ```cpp std::deque```
  - _Double-ended queue_
  - Proche de ```cpp std::vector``` mais extensible aux deux extrémités
  - Accès indexé
  - Éléments non nécessairement contigus
  - Non compatible avec l'organisation mémoire des tableaux C

== STL Conteneurs -- Conteneurs séquentiels
- ```cpp std::string```
  - Alias de ```cpp std::basic_string<char>```
  - Stockage de chaînes de caractères
  - Manipulation de _bytes_ et non de caractères encodés

#alertblock(text[```cpp std::string``` et UTF-8], text[
  - ```cpp length()``` et ```cpp size()``` retournent le nombre de _bytes_, pas de caractères
])

#list(
  marker: [ ],
  text[
    - Contiguïté non garantie, mais respectée en pratique

    // Contiguïté garantie en C++11 et suivant
    // Pas d'implémentation non contigüe connue

    - Variante ```cpp std::wstring``` pour les caractères larges
  ],
)

#alertblock("API trop riche", text[
  - Voir #link("http://www.gotw.ca/gotw/084.htm")[GotW \#84 : Monoliths "Unstrung" #linklogo()]
])

== STL Conteneurs -- Conteneurs associatifs

- Quatre saveurs
  - ```cpp std::map``` -- clés-valeurs, ordonné par la clé, unicité des clés
  - ```cpp std::multimap``` -- clés-valeurs, ordonné par la clé, multiplicité des clés
  - ```cpp std::set``` -- valeurs ordonnées et uniques
  - ```cpp std::multiset``` -- valeurs ordonnées et non-uniques

#noteblock("Implémentation", text[
  - Pas des tables de hachage
  - Généralement des arbres binaires de recherche balancés
  // red-black tree le plus souvent
])

- Critère d'ordre - #highlight[strict] - configurable (strictement inférieur par défaut)

- Algorithmes membres (recherche) pour les performances

== STL Conteneurs -- Adaptateurs
- Basés sur un autre conteneur pour proposer une API simplifiée
- Avantages et inconvénients du conteneur sous-jacent
- ```cpp std::stack```
  - Pile LIFO
  - Basée sur ```cpp std::vector```, ```cpp std::list``` ou ```cpp std::deque```
- ```cpp std::queue```
  - File FIFO
  - Basée sur ```cpp std::deque``` ou ```cpp std::list```
- ```cpp std::priority_queue```
  - File dont l'élément de tête est le plus grand
  - Basée sur ```cpp std::vector``` ou ```cpp std::deque```
  - Critère d'ordre configurable (strictement inférieur par défaut)

== STL Conteneurs -- Adaptateurs

```cpp
stack<int, vector<int> > foo;
for(int i=0; i<5; ++i) foo.push(i);

// Affiche 4 3 2 1 0
while(!foo.empty()) {
  cout << ' ' << foo.top();
  foo.pop();
}
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:4,endLineNumber:9,positionColumn:4,positionLineNumber:9,selectionStartColumn:4,selectionStartLineNumber:9,startColumn:4,startLineNumber:9),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cstack%3E%0A%0Aint+main()%0A%7B%0A++std::stack%3Cint,+std::vector%3Cint%3E+%3E+foo%3B%0A++for(int+i%3D0%3B+i%3C5%3B+%2B%2Bi)%0A++%7B%0A++++foo.push(i)%3B%0A++%7D%0A%0A++while(!!foo.empty())%0A++%7B%0A++++std::cout+%3C%3C+!'+!'+%3C%3C+foo.top()%3B%0A++++foo.pop()%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B98+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== STL Conteneurs -- conteneurs non-STL

- ```cpp std::bitset```
  - Tableau de bits de taille fixe
  - Conçu pour réduite l'empreinte mémoire
  - Pas d'itérateur ni d'interface STL

#noteblock(text[``` std::bitset``` vs. ``` std::vector<bool>```], text[
  - Objectif de gain mémoire adressé par ```cpp std::bitset```, pourquoi ```cpp std::vector<bool>``` n'est-il pas un vrai conteneur de booléen ?
])

== STL Conteneurs -- conteneurs non-STL

- Conteneurs non-standards
  - Listes simplement chaînées
  - Tables de hachage
  - Tableaux de taille fixe
  - Tampons circulaires
  - Arbres et graphes
  - Variantes de conteneurs STL

// Variantes ciblant un autre compromis : listes en tableau, ropes, map à plat, ...

== STL Conteneurs -- ```cpp std::pair```

- Couple de deux valeurs
- Pas un conteneur
  - Type de retour de la recherche sur les ```cpp std::map``` (couple clé-valeur)
  - Candidat pour construire des vecteurs indexés par un non-numérique
- ```cpp std::make_pair``` construit une paire

== STL Conteneurs -- Choix du conteneur

#adviceblock("Do, par défaut", text[
  - ```cpp std::string``` pour les chaînes de caractères
  - ```cpp std::vector```
])

#adviceblock("Do, performances", text[
  - Mesurez avec des données réelles sur la configuration cible
])

#alertblock("Flux d'octets", text[
  - Utilisez ```cpp std::vector<unsigned char>```
  - Pas ```cpp std::vector<char>``` encore moins ```cpp std::string```
])

== STL Conteneurs -- Choix du conteneur

#noteblock("Conseils", text[
  - Voir _Effective STL_ item 1
  - Voir #link("https://hackingcpp.com/cpp/design/which_std_sequence_container.png")[Which C++ Standard Sequence Container should I use? #linklogo()]
  - Pensez à ```cpp reserve()```
  - Une insertion en vrac suivie d'un tri peut être plus efficace qu'une insertion en place
  - Un vecteur de paires peut être un bon choix pour un ensemble de clés-valeurs
])

== STL Itérateurs -- Généralités

- Abstraction permettant le parcours des collections d'objets
- Interaction entre conteneurs et algorithmes
- Interface similaire à celle d'un pointeur
- Quatre types
  - ```cpp iterator``` et ```cpp const_iterator```
  - ```cpp reverse_iterator``` et ```cpp const_reverse_iterator```
- Itérateurs sur un conteneur : ```cpp begin()``` et ```cpp end()```
- Itérateurs inverses sur un conteneur : ```cpp rbegin()``` et ```cpp rend()```
- Les itérateurs d'une paire doivent appartenir au même conteneur

#alertblock("Itérateurs de fin", text[
  - Pointent un élément après le dernier
  - Ne doivent pas être déréférencés ni incrémentés
])

// Un élément après la fin permet de représenter des ensemble vide (si begin et end référence le même élément)

== STL Itérateurs -- Catégories et opérations

#grid(
  columns: (4fr, 1fr),
  //      inset: 10pt,
  align: (left, left),
  [
    - Opérations communes : copie, affectation, incrémentation
    - Hiérarchie de cinq catégories
      - _Input_ : égalité (```cpp ==``` et ```cpp !=```), lecture
      - _Output_ : écriture
      - _Forward_ : Parcours multiples
      - _Bidirectional_ : décrémentation
      - _Random access_
        - Déplacement arbitraire (```cpp +```, ```cpp -```, ```cpp +=```, ```cpp -=```, ```cpp []```)
        - Comparaison (```cpp <```, ```cpp <=```, ```cpp >```, ```cpp >=```)
  ],
  [
    #diagram(
      node-stroke: 0.06em,
      spacing: (-3.4em, 2em),
      label-size: 0.5em,
      node((0, 0), [Input], name: <input>, width: 3.5em),
      node((2, 0), [Output], name: <output>, width: 3.5em),
      node((1, 1), [Forward], shape: rect, name: <forward>, width: 7.5em),
      node((1, 2), [Bidirectional], shape: rect, name: <bidir>, width: 7.5em),
      node((1, 3), [Random Access], shape: rect, name: <random>, width: 7.5em),
      edge(
        <input.south>,
        ((), "|-", ((), 50%, <forward.north>)),
        ((), "-|", ((), 100%, <forward.north>)),
        <forward.north>,
        "<|-",
      ),
      edge(
        <output.south>,
        ((), "|-", ((), 50%, <forward.north>)),
        ((), "-|", ((), 100%, <forward.north>)),
        <forward.north>,
        "<|-",
      ),
      edge(<forward>, <bidir>, "<|-"),
      edge(<bidir>, <random>, "<|-"),
    )
  ],
)

#alertblock("Attention", text[
  Seules les versions mutables de _Forward_, _Bidirectional_ et _Random access_ itérateurs sont des _Output_ itérateurs
])

== STL Itérateurs -- Catégories et conteneurs

#table(
  columns: (1fr, 1fr),
  inset: 5pt,
  align: horizon,
  stroke: (x, y) => if y == 0 {
    (x: 1pt + black, y: 1pt + black)
  } else if y == 5 { (x: 1pt + black, bottom: 1pt + black) } else { (x: 1pt + black, bottom: 0.5pt + black) },
  table.header(
    table.cell(fill: main_color.lighten(60%), [*Conteneur*]),
    table.cell(fill: main_color.lighten(60%), [*Catégorie*])
  ),
  [```cpp std::vector``` ], [ _Random access_],
  [```cpp std::deque``` ], [ _Random access_],
  [```cpp std::list```], [ _Bidirectionnal_],
  [```cpp std::map``` et ```cpp std::multimap``` ], [ _Bidirectionnal_],
  [```cpp std::set``` et ```cpp std::multiset``` ], [ _Bidirectionnal_],
)

== STL Itérateurs -- Itérateurs d'insertion

- Adaptateur d'itérateurs
- De type _Output_
- Insertion de nouveaux éléments
  - En queue : ```cpp back_inserter```
  - En tête : ```cpp front_inserter```
  - À la position courante : ```cpp inserter```

== STL Algorithmes -- Foncteurs

- Instances de classe définissant ```cpp operator()```

```cpp
class LessThan {
public:
  explicit LessThan(int threshold) : m_threshold(threshold) {}
  bool operator() (int value) { return value <= m_threshold; }

  private:
    int const m_threshold;
  };

  LessThan func(10);
  cout << func(5) << "\n";   // 1
```

== STL Algorithmes -- Foncteurs

- Possèdent des données membres
- Foncteurs standards : ```cpp std::plus```, ```cpp std::minus```, ```cpp std::equal```, ```cpp std::less```, ...
- Constructibles
  - Depuis des pointeurs de fonctions : ```cpp std::prt_fun```
  - Depuis des fonctions membres : ```cpp std::mem_fun```, ```cpp std::mem_fun1```, ...
  - En niant d'autres foncteurs : ```cpp std::not1```, ```cpp std::not2```
  - En fixant des paramètres : ```cpp std::bind1st```, ```cpp std::bind2nd```

== STL Algorithmes -- Prédicats

- Appelables retournant un booléen (ou un type convertible en booléen)
- Utilisés par de nombreux algorithmes
- De nombreux algorithmes utilisent un prédicat par défaut (p.ex. ```cpp <``` ou ```cpp ==```)

== STL Algorithmes -- Parcours

- ```cpp std::for_each()``` parcourt un ensemble d'éléments
- ... et applique un traitement à chaque élément

```cpp
void print(int i) { cout << i << ' '; }

vector<int> foo{4, 5, 9 ,12};
for_each(foo.begin(), foo.end(), print);
```

- Version du _map_/_apply_ fonctionnel

== STL Algorithmes -- Parcours

- Retourne le foncteur passé en paramètre

```cpp
struct Aggregate {
  Aggregate() : m_sum(0) {}
  void operator() (int i) { m_sum += i; }
  int m_sum;
};

vector<int> foo{4, 5, 9 ,12};
for_each(foo.begin(), foo.end(), Aggregate()).m_sum; // 30
```

- Candidat pour le _fold_/_reduce_ fonctionnel
- Pas de sémantique, faible utilité


== STL Algorithmes -- Recherche linéaire

- ```cpp std::find()``` recherche une valeur
- ... et retourne un itérateur sur celle-ci
- .. ou l'itérateur de fin si la valeur n'est pas présente
	\end{itemize}

```cpp
vector<int> foo{4, 5, 9 ,12};
vector<int>::iterator it1;
vector<int>::iterator it2

it1 = find(foo.begin(), foo.end(), 5);   // it1 pointe sur foo[1]
it2 = find(foo.begin(), foo.end(), 19);  // Et it2 sur foo.end()
```

== STL Algorithmes -- Recherche linéaire

- ```cpp std::find_if()``` recherche depuis un prédicat

#noteblock(text[Variantes ```cpp _if```], text[
  - Les algorithmes suffixés par ```cpp _if``` utilisent un prédicat
])

- ```cpp std::find_first_of()``` recherche la première occurrence d'un élément
- ```cpp std::search()``` recherche la première occurrence d'un sous-ensemble
- ```cpp std::find_end()``` recherche la dernière occurrence d'un sous-ensemble
- ```cpp std::adjacent_find()``` recherche deux éléments consécutifs égaux
- ```cpp std::search_n()``` recherche la première suite de $n$ éléments consécutifs égaux à une valeur

#codesample("https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:18,positionColumn:1,positionLineNumber:18,selectionStartColumn:1,selectionStartLineNumber:18,startColumn:1,startLineNumber:18),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B2,+5,+2,+1,+8,+8,+6,+2,+8,+8,+8,+2%7D%3B%0A%0A++std::vector%3Cint%3E::iterator+it+%3D+find(foo.begin(),+foo.end(),+6)%3B%0A++std::cout+%3C%3C+*it+%3C%3C+!'+!'+%3C%3C+*(it%2B1)+%3C%3C+!'%5Cn!'%3B%0A%0A++std::vector%3Cint%3E::iterator+it2+%3D+std::adjacent_find(foo.begin(),+foo.end())%3B%0A++std::cout+%3C%3C+*it2+%3C%3C+!'+!'+%3C%3C+*(it2+-+1)+%3C%3C+!'+!'+%3C%3C+*(it2+%2B+2)+%3C%3C+!'%5Cn!'%3B%0A%0A++std::vector%3Cint%3E::iterator+it3+%3D+std::search_n(foo.begin(),+foo.end(),+3,+8)%3B%0A++std::cout+%3C%3C+*it3+%3C%3C+!'+!'+%3C%3C+*(it3+-+1)+%3C%3C+!'+!'+%3C%3C+*(it3+%2B+3)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4")


== STL Algorithmes -- Recherche dichotomique

- Pré-requis : ensemble trié
- ```cpp std::lower_bound()``` retourne un itérateur sur le premier élément non strictement inférieur à la valeur recherchée

// Formulation "n'est pas strictement inférieur" semble être une tournure compliquée pour supérieur ou égal, mais c'est précisément ce que fait la fonction et c'est important si on fourni un prédicat de comparaison

- ... et l'itérateur de fin si un tel élément n'existe pas

```cpp
vector<int> foo{4, 5, 7, 9, 12};

*lower_bound(foo.begin(), foo.end(), 6);  // 7
*lower_bound(foo.begin(), foo.end(), 9);  // 9
```

== STL Algorithmes -- Recherche dichotomique

- ```cpp std::upper_bound()``` retourne un itérateur sur le premier élément strictement supérieur à la valeur recherchée
- ```cpp std::equal_range()``` retourne la paire (```cpp std::lower_bound```, ```cpp std::upper_bound```)

#alertblock("Attention", text[
  - Le résultat retourné peut ne pas être la valeur recherchée
])

- ```cpp std::binary_search()``` indique si l'élément cherché est présent

== STL Algorithmes -- Recherche dichotomique

#alertblock("Attention", text[
  - Pas de fonction de recherche dichotomique retournant l'élément cherché
])

	```cpp
vector<int>::iterator foo(vector<int> vec, int val) {
vector<int>::iterator it = lower_bound(vec.begin(), vec.end(), val);
  if(it != vec.end() && *it == val) return it;
  else return vec.end();
}

vector<int> bar{1, 5, 8, 13, 25, 42};
foo(bar, 12);  // vec.end
foo(bar, 13);  // iterateur sur 13
```

#codesample("https://godbolt.org/#z:OYLghAFBqd5QCxAYwPYBMCmBRdBLAF1QCcAaPECAMzwBtMA7AQwFtMQByARg9KtQYEAysib0QXACx8BBAKoBnTAAUAHpwAMvAFYTStJg1DIApACYAQuYukl9ZATwDKjdAGFUtAK4sGe1wAyeAyYAHI%2BAEaYxCBmAJykAA6oCoRODB7evnrJqY4CQSHhLFEx8baY9vkMQgRMxASZPn5cFVXptfUEhWGR0bEJCnUNTdmtQ109xaUDAJS2qF7EyOwc5gDMwcjeWADUJutuTkPEmKwH2CYaAIIbWzuY%2B4cAbpgOJBdXt2abDNteewObjEwBIhAQLE%2BNy%2BwQIuxYTGCEFmXxMAHYrDddrshugQCBXu9iEDYRddvxUOiLNJdgBWUi7NEMhK7LhmdEAEQOmNuWP2GK%2B2OxuPxhKIxMOpPW2HxhGiTHFu0ITw5OIIeJAtFQAHdogB9CKLBjoaioVAAOiiwCR83JZvNrmRDIAbCj1jyhWqNWgvHCgUDdgAqZX%2Bw67MBrWluBgR7mC/lc6F8qnx4Xq0VvcUkwQXWUEeWKkPrVUizU6/WGrzG00Wq02hkUh3V21xN0eoWln1%2Bw4B4PdtwB2NRmNrd3xzmo5MCvlpjVij6SnPSvMFkhK7sl9MgLyJRIVo0mxt1hhOu0Wx0ttupr34rtPAdhvv3weR6OxsdTxO867YlMzm8gIkiISm4pbziBUoyiAcrEAqJAMmBmYLkcS5QTBcEStguynAoKoAZgACOXhiHqsFGJgNaWpg1onrajYXi6V7/p2iz9r2EA4eaNDEEMszPmGEbhhw/FuEGHGYAo5pKGgxp8aGolDm%2Bo7thO0Jol%2BHDzLQnC0rwfgcFopCoJwA6WNYOKLMsjwbDwpAEJomnzAA1iAtIaPonCSHpDlGZwvAKCA7n2QZmmkHAsBIJgqhvL68EUBA9TAAoyiGJUQgIDq%2Bm2WgLCJHQCrpClIS0OlmU%2BTleX0DESXMIkCgZQQpAVXQ0ShKwqy8M1VUAPK%2BqV2r6YZUVvNcxBJX5pDDcgtT4PpvD8IIIhiOwUgyIIigqOoIWkLorQGEYKDWNY%2Bh4BEAWQPMqCJNUAUcAAtLiBwcqYZmWFwXC7HdADqYi0J9X1RQQsG8KgrzEMQeBYOdTrEFWjhsAAKmatDQ/MCiWSsei4sERVpRlA2cLZQOYKstnarBiQOVpOnedtxkcNg0XILFxC7KoAAczp3c6ki7MAyDILsEBA1WTl8RAplWJYDK4IQa42bMvDBVoszzAgZxYDETouW5HkcF5pCDSDE0BUFVPUxwZi04Z9NK%2BbpBg6kziSEAA%3D%3D")

== STL Algorithmes -- Comptage

- ```cpp std::count()``` compte le nombre d'éléments égaux à la valeur fournie

```cpp
vector<int> foo{4, 5, 3, 9, 5, 5 ,12};

count(foo.begin(), foo.end(), 5);  // 3
count(foo.begin(), foo.end(), 2);  // 0
```

- ```cpp std::count_if()``` compte le nombre d'éléments satisfaisant le prédicat

#codesample("https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:19,positionColumn:1,positionLineNumber:19,selectionStartColumn:1,selectionStartLineNumber:19,startColumn:1,startLineNumber:19),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Abool+compare(int+nb)%0A%7B%0A++return+nb+%3E%3D+5%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B2,+5,+2,+1,+8,+8,+6,+2,+8,+8,+8,+2%7D%3B%0A%0A++std::cout+%3C%3C+std::count(foo.begin(),+foo.end(),+8)+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::count(foo.begin(),+foo.end(),+7)+%3C%3C+!'%5Cn!'%3B%0A%0A++std::cout+%3C%3C+std::count_if(foo.begin(),+foo.end(),+compare)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4")

== STL Algorithmes -- Comparaison

- ```cpp std::equal()``` teste l'égalité de deux ensembles (valeur et position)

```cpp
vector<int> foo{4, 5, 9, 12};
vector<int> bar{4, 5, 12, 9};

equal(foo.begin(), foo.end(), foo.begin());  // true
equal(foo.begin(), foo.end(), var.begin());  // false
```

== STL Algorithmes -- Comparaison

#alertblock("Attention", text[
  - ```cpp std::equal()``` ne vérifie pas les tailles des deux ensembles
])

#noteblock(text[Et ```operator==``` ?], text[
  - ```cpp operator==``` sur des conteneurs teste la taille et le contenu
])

#adviceblock("Do", text[
  - Préférez ```cpp operator==``` à ```cpp std::equal()``` pour comparer un conteneur complet
])

== STL Algorithmes -- Comparaison

- ```cpp std::mistmatch()``` retourne une paire d'itérateurs sur les premiers éléments différents

```cpp
vector<int> foo{4, 5, 9, 13};
vector<int> var{4, 5, 12, 8};

mismatch(foo.begin(), foo.end(), bar.begin());  // 9 12
```

- ... ou l'itérateur de fin en cas d'égalité

#codesample("https://godbolt.org/#z:OYLghAFBqd5QCxAYwPYBMCmBRdBLAF1QCcAaPECAMzwBtMA7AQwFtMQByARg9KtQYEAysib0QXACx8BBAKoBnTAAUAHpwAMvAFYTStJg1DIApACYAQuYukl9ZATwDKjdAGFUtAK4sGe1wAyeAyYAHI%2BAEaYxCAAzLGkAA6oCoRODB7evnrJqY4CQSHhLFEx8baY9vkMQgRMxASZPn5cFVXptfUEhWGR0XEJCnUNTdmtQ109xaUDAJS2qF7EyOwc5rHByN5YANQmsW5OQ8SYrPvYJhoAguub25h7BwBumA4k55c3ZhsMW167%2BzcYmAJEICBYH2un2CBB2LCYwQgs0%2BJgA7FZrjsdkN0CAQC83sRATDzjt%2BKg0RZWjsAKykHYADnpZjRABF9hibpi9ujPlisTi8QSiESDiTYtgdhF6pTqXTGcy2Ry%2BfzBShFrDAYDsQRcSAIqhPGJEggmI83Nq1ZgAI5eMTUQ0AOiiwER8zJTtcSPp0uIzswroYSNm5u1YDWNLcDHDyu5At1eLQXk1B0tCf1hoMtBNZq1Bx2DtQj3ZsVZUvqIbzbh2Mcj0bWsU5WKVUO5lJV8b1wveYsEpN9svpCR2ZnpqKVjY7Or1SZTFvzaoNRuzptDC/TNrttEL/sD3o9qEdXvdvt3bsrqfztajMcnceniY1a%2Bri8zxtXVYL5OL%2BzLvov87Vte9axlczaouyrZgTyTaqum3aiocfYSuWRLonK9JMiO9KSBOsGdo%2BybPg%2BGbLjmxFWra9rkmeQbujRx4%2BvUtHBsRwG3vhJGzhR6ZLlm5GfoWP6lqhAFhhGN4NrBLZctB7b3mqCHEshkoDuhQ7MmOeFTmqiQIohimvCKykEOceKENETAivShmEiZZkgBZxBWT2konAoxYkSweAKPCBDIAgO4um69IMQw6D7qewV0cid7QQR6pEZ%2BABUEDuY6NDEEMYlXhwNZ5SlaWYAojpKGg4U5UBEkgXF4GQTcEGfBw8y0JwNK8H4HBaKQqCcBaljWNiizLA86w8KQBCaM18wANYgDSGj6JwkgdVNPWcLwCggItk1dc1pBwLASCYKorzJiQ5CUPUwAKMohiVEICCoAA7p141oCwiR0FZ6R3SEtCPS9nXdR9X30DEN3MIkChPQQpCg3Q0ShKwqy8Aj4MAPLJoDr1rSdrxXMQN0baQ%2BPILU%2BCdbw/CCCIYjsFIMiCIoKjqHtpC6K0BhGCg1jWPoeARFtkDzKgiTVFtHAALQ4r%2BpgDZYXBcDsUsAOpiLQKuqydBDObwqAvMQxB4FgwvesQXiCHgbAACqZmb8wKMNKx6DiwR/Q9T249wvC65gqzjc9zmJFNLVtat7O9Rw2Cncg53EDsqgMgAbFLyeSDswDIMgBa65bM0hhA/VWJY9K4IQJB7N8XCzL7ofzAgpxYDE3pzQtS0cCtpDA/rJNbTt9cd2YEfdVHdd7bM8yG6kziSEAA")

== STL Algorithmes -- Remplissage

- ```cpp std::fill()``` remplit l'ensemble avec la valeur fournie

```cpp
vector<int> foo(4);

fill(foo.begin(), foo.end(), 12);  // 12 12 12 12
```

- ```cpp std::fill_n()``` idem avec un ensemble défini par sa taille

#noteblock("Constructeur", text[
  - Remplissage des conteneurs séquentiels à la construction

```cpp
vector<int> foo(4, 12);
```
])

== STL Algorithmes -- Remplissage

- ```cpp std::generate()``` valorise les éléments à partir d'un générateur

```cpp
int gen() {
  static int i = 0;
  i += 5;
  return i;
}

vector<int> foo(4);
generate(foo.begin(), foo.end(), gen);  // 5 10 15 20
```

- ```cpp std::generate_n()``` idem avec un ensemble défini par sa taille

#codesample("https://godbolt.org/#z:OYLghAFBqd5QCxAYwPYBMCmBRdBLAF1QCcAaPECAMzwBtMA7AQwFtMQByARg9KtQYEAysib0QXACx8BBAKoBnTAAUAHpwAMvAFYTStJg1DIApACYAQuYukl9ZATwDKjdAGFUtAK4sGe1wAyeAyYAHI%2BAEaYxCAAzAAcpAAOqAqETgwe3r56KWmOAkEh4SxRMQm2mPYFDEIETMQEWT5%2BXJXVGXUNBEVhkdFxiQr1jc05bcPdvSVlgwCUtqhexMjsHOaxwcjeWADUJrFuTsPEmKwH2CYaAIIbWzuY%2B4cAbpgOJBdXt2abDNteewObjEwBIhAQLE%2BNy%2Bk0cyF2wQIu2AjAgcy%2BJgA7FYbrtdrC8PDEQingARXYaA44654vD7SwHckAVipXzxpwIywYCNZ0MxpIxN2JLCYwTRGOxbP2ktxePxBHQIBAr3exCBiIuu34qAgknRsWpcvlipANFotGoqFQADoosAxQstVbra40aRdpIzPrDXLhia0F4kUCgU7UCYmRZKUzycHDrswBx44nY25Q%2BGLFxwzHDiGE0mnm4Q9r02YswXc4m8ym0xHYmXqwnw24GI2DVKsQLobKsT68X6lSqiGrDhrYtg023ZX2FUqzbQAPoMCD9kARJjIADW8%2BCSka0UtqEd0g9sW9Uun/qWQZzceLEaj2cLcbzVZvqbvGfrb/zr6f76tJZfn%2BP7Jt%2BH51tG5bPusTLNq2PodoKNLSr2xoDm8Q7qoImrarq7qSHqvLIReSoBtewEfg%2BUGpi%2BoEUQBEaZpBDaVnRRYMRYpbMd%2BtHUTWFgQY%2BFZNi26yTshiFdhJMrEWhyoYR8I7YWOoa6meU5ySiITEEwBCYAetqYPaS6OtqLoMOgbrIow3p4gA9HZuxMrsXAaC5zlmJSGkrmRfGUUBFb5tWH5MUJ0FBWBHFcWFNGsX5HGCXxjawaJRF4pJtx8p21wcAstCcEyvB%2BBwWikKgnCFgylj4ksKyPBsPCkAQmi5QsG4gEyGj6JwkhFS1ZWcLwCggF1zUlblpBwLASCYKobyBiQ5CUA0wAKMohhVEICCoAA7sVjVoCwSR0LpGTrSEtBbbtxWlYdx30DEq3MEkCjbQQpB3XQ0ShKway8J9D0APKBlde39bNbzXMQq2DaQEPIHU%2BDFbw/CCCIYjsFIMiCIoKjqONpC6G0BhGCg1jWPoeARMNkALKgSQ1MNHAALR%2BoyphVRYACc8S7MzADqYi0Hz/OzQQOm8KgrzEMQeBYDTbrEF4gh4GwAAqVq0ArCwKLVqx6H6wTnZt21g9wvDi5gayNTtOlJC1eUFX1BPlRw2BzcgC3ELsqjxAAbMzfuSMiyDwhA4vKxucy7BAlVWJY7q4IQJD0rEXBzBbDsLAgZxYDEbrtZ13UcL1pA3ZLsPDaNWfF2Yzula7mfjXMCzS2kziSEAA%3D%3D%3D")

== STL Algorithmes -- Copie

- ```cpp std::copy()``` copie les éléments du début vers la fin

```cpp
vector<int> foo{4, 5, 9, 12};
vector<int> bar;

copy(foo.begin(), foo.end(), back_inserter(bar));
```

- ```cpp std::copy_backward()``` copie les éléments de la fin vers le début

#alertblock("Attention", text[
  - À la taille du second ensemble
  - Aux ensembles non-disjoints
])

#codesample("https://godbolt.org/#z:OYLghAFBqd5QCxAYwPYBMCmBRdBLAF1QCcAaPECAMzwBtMA7AQwFtMQByARg9KtQYEAysib0QXACx8BBAKoBnTAAUAHpwAMvAFYTStJg1DIApACYAQuYukl9ZATwDKjdAGFUtAK4sGe1wAyeAyYAHI%2BAEaYxCBmZqQADqgKhE4MHt6%2BekkpjgJBIeEsUTFxtpj2eQxCBEzEBBk%2BflzllWk1dQQFYZHRsfEKtfWNWS2Dnd1FJf0AlLaoXsTI7BzmAMzByN5YANQma25Og8SYrPvYJhoAguub25h7BwBumA4k55c3ZhsMW167%2BzcYmAJEICBYH2un2CBB2LCYwQgM0%2BJgA7FZrjsdoN0CAQC83sRATDzjt%2BKg0RYAKykHZmABstNRtK4ZjRABF9hibpi9ujPlisTi8QSiESDiS1tgdhE6lyBYLhShUAkAJ7UVCoAB0UWAiLmZM1WtcSNpStlyAA1gB9YJKerRCCy4gzZFrbmC7EEXHKrywwGAmVyqkWDQmKnsx5uQNgDg7WNRwPO8MWLjhyMBg7xuMJzNuINEkNsiOJrMJ3MHJPBixrdOl/Ox8NuBiN90Kjko3mUhVC70i15i4mCUnOiAADjdHsVfeVautFstAHc6ugNdrdfraeTjQxVwbnTu95Oe16fWg/fWCymwyW89n73fkyG07fK2Wc3HH9Xixm3w2P5eT41nWd6NlSzatlOvZngs/p/leIaSCB8Hlp%2B8FAVSyHRu%2BD7odW9JYTGAFfoWFiooR75Ni2qxtl2qKclC9GfBwcy0JwVK8H4HBaKQqCcNGljWNiCxLA86w8KQBCaCxcyWiAVIaPonCSJx0m8ZwvAKCAilSdxLGkHAsBIJgqivH6JDkJQdTAAoyiGBUQgIKgi5cRJaAsAkdBMFUdkhLQjnOVxPHuZ59AxDZzAJAoTkEKQIV0NEoSsCsvDxWFADyfoBS5akma8VzEDZGmkHlyA1PgXG8PwggiGI7BSDIgiKCo6h6aQugtAYRgoNY1j6HgERaZAcwqlUWkcAAtDi%2BzsqYgmWFwXA7BNADqYi0MtK0mQQxBMLwqAvMQxB4FgQ2msQXiCHgbAACqarQZ1zAoInLHoOLBL5DlOTl3C8DtmArBJi67Qk0msexqltXxHDYKZyDmcQOyqGO9ITfSkg7MAyDIDsEA7ZdlozLjAlWJYtK4IQJB7N8XAzH9YNzAgpxYDEppyQpSkcCppBBftxVaTpDOc2YkM8dD9N6a6pCHSkziSEAA%3D%3D%3D")

== STL Algorithmes -- Échange

- ```cpp std::swap()``` échange deux objets

```cpp
int x=10, y=20;   // x:10 y:20
swap(x,y);        // x:20 y:10
```

- ```cpp std::swap_ranges()``` échange des éléments de deux ensembles

```cpp
vector<int> foo (5,10); // foo: 10 10 10 10 10
vector<int> bar (5,33); // bar: 33 33 33 33 33

swap_ranges(foo.begin()+1, foo.end()-1, bar.begin());
// foo : 10 33 33 33 10
// bar : 10 10 10 33 33
```

- ```cpp std::iter_swap()``` échange deux objets pointés par des itérateurs

#codesample("https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:14,positionColumn:1,positionLineNumber:14,selectionStartColumn:1,selectionStartLineNumber:14,startColumn:1,startLineNumber:14),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo+(5,10)%3B%0A++std::vector%3Cint%3E+bar+(5,33)%3B%0A%0A++std::cout+%3C%3C+bar%5B0%5D+%3C%3C+%22+%22+%3C%3C+bar%5B1%5D+%3C%3C+%22+%22+%3C%3C+bar%5B2%5D+%3C%3C+%22+%22+%3C%3C+bar%5B3%5D+%3C%3C+%22+%22+%3C%3C+bar%5B4%5D+%3C%3C+%22%5Cn%22%3B%0A++std::swap_ranges(foo.begin()+%2B+1,+foo.end()+-+1,+bar.begin())%3B%0A++std::cout+%3C%3C+bar%5B0%5D+%3C%3C+%22+%22+%3C%3C+bar%5B1%5D+%3C%3C+%22+%22+%3C%3C+bar%5B2%5D+%3C%3C+%22+%22+%3C%3C+bar%5B3%5D+%3C%3C+%22+%22+%3C%3C+bar%5B4%5D+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B98+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4")

== STL Algorithmes -- Remplacement

- ```cpp std::replace()``` remplace toutes les occurrences d'une valeur par une autre

```cpp
vector<int> foo{4, 5, 7, 9 ,12, 5};

replace(foo.begin(), foo.end(), 5, 8);  // 4 8 7 9 12 8
```

- ```cpp std::replace_if()``` remplace toutes les éléments vérifiant le prédicat par une valeur donnée

== STL Algorithmes -- Remplacement

- ```cpp std::replace_copy()``` copie les éléments d'un ensemble en remplaçant toutes les occurrences d'une valeur par une autre

#noteblock(```cpp _copy```, text[
  - Les algorithmes suffixés par ```cpp _copy``` fonctionnent comme l'algorithme de base en troquant la modification en place contre une copie du résultat
])

- ```cpp std::replace_copy_if()``` copie les éléments d'un ensemble en remplaçant toutes les éléments vérifiant le prédicat par une valeur donnée

#codesample("https://godbolt.org/#z:OYLghAFBqd5QCxAYwPYBMCmBRdBLAF1QCcAaPECAMzwBtMA7AQwFtMQByARg9KtQYEAysib0QXACx8BBAKoBnTAAUAHpwAMvAFYTStJg1DIApACYAQuYukl9ZATwDKjdAGFUtAK4sGe1wAyeAyYAHI%2BAEaYxCCSAJykAA6oCoRODB7evnrJqY4CQSHhLFEx8baY9vkMQgRMxASZPn5cFVXptfUEhWGR0bEJCnUNTdmtQ109xaUDAJS2qF7EyOwc5gDMwcjeWADUJutuTkPEmKwH2CYaAIIbWzuY%2B4cAbpgOJBdXt2abDNteewObjEwBIhAQLE%2BNy%2BE0cyF2EVQnl2yAQbwA1hBggRdkxZl8TAB2Kw3Xa7U4EJYMXFPS7rAAiu0JBxJt0J9IJN2xuxYTGCEHx0OJXzJRNZZLJQ3QIBAr3exCB2Iuu34qDF0l2AFZSEydXFdqQuGYdZqiRz1uKJVKZadEgYVtQkQA6KLAfnzFXO1wCk06gAc%2BItIol/GIEFSAC9MAB9HG7PBPRkaFnxp5uT2oJ2RzAClPWax4QXXCX7YWkku7a0oRY4oFAjMmTUWPCNxl1w67MAcTtrIPl0Xs4OSgjS6teWuHetdxtuBjTvvF0sc6HlsVDysjmVyogKw5K9bYBvEjXa3W7fWG41as0s9dV232mN4KiOzOu9061VO70e1EY/2BpaZKhuGeBRrGZIJgcSYplBHZftmuYWvslgFkWJZrv2VqbmOE5uPWqqNs2rZplO3bzkBS53jhaDjqRHbTpqs4UcGN4roumGLsOo7bh8e6CMqhHHr6Z4XkaJo3guJZVrxu5HAJB4IvUt5YfemB2kwKzRmgiQAJ6vi6mBugwPoZt%2BDDoKZVYRJp6LRsESgNNEEA2cQHqngGKlcZ6YbZhBqbQbsybIXB6YIWBOaAShViWIW66cRWG6jrReEEUiREtpqbaTgx5G9pRbHeVWKX0emjHMflnLeSBflxnBMEhWmSnEFmEVIRY0VofFZbedxMole26auRlJGDT2PZeRhg6qTRNalRNTFzpVq7TWyy7XBw8y0Jwmq8H4HBaKQqCcPhqGWJWizLI8Gw8KQBCaJt8zoiAmoaPonCSHtD1HZwvAKCAb33Qdm2kHAsBIJgqhvOOJDkJQ9TAAoyiGJUQgIKgADu%2B23WgLCJHQTDVMjIS0GjmP7YduP4/QMSI8wiQKOjBCkFTdDRKErCrLwrM0wA8uOZNY99kNvNcxCI79pAi8gtT4PtvD8IIIhiOwUgyIIigqOowOkLorQGEYKD5pY%2Bh4BE/2QPMqCJNU/0cAAtFK0GmGdFhcFwuz2wA6mItCe17kMEMQTC8KgrzEMQeBYBbPrEF4gh4GwAAqSK0DH8wKJdKx6FKwTE6j6NC9wvBB5gqy3RjweJA9W07V9OvHRw2BQ8gMPELsqh%2BgAbPbXeSLswDIPCEBB/H6KzLsECnTFNi7LghAkCh6xcLMJc1/MaJMFgMQ%2Bs9r3vRwn2kBToeS/9gPrwfZj14djdr8DszzOHqTOJIQA%3D%3D")

== STL Algorithmes -- Suppression

- ```cpp std::remove()``` élimine les éléments égaux à une valeur donnée

```cpp
vector<int> foo{4, 5, 5, 5, 7, 9, 9, 5};

remove(foo.begin(), foo.end(), 5);    // 4 7 9 9 ...
```

#alertblock("Pas de suppression", text[
  - Ramène les éléments à conserver vers le début de l'ensemble
  - Retourne l'itérateur correspond à la nouvelle fin
])

// std::remove() ne supprime pas car les algorithmes ne peuvent pas modifier le conteneur, en particulier sa taille, mais seulement son contenu

#noteblock(text[Idiome _Erase-Remove_], text[
  - Suppression via un appel à ```cpp erase()``` après le nouvel itérateur de fin

```cpp
foo.erase(remove(foo.begin(), foo.end(), 5), foo.end());
```
])

#codesample("https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:16,positionColumn:1,positionLineNumber:16,selectionStartColumn:1,selectionStartLineNumber:16,startColumn:1,startLineNumber:16),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B4,+5,+5,+5,+7,+9,+9,+5%7D%3B%0A%0A++foo.erase(std::remove(foo.begin(),+foo.end(),+5),+foo.end())%3B%0A++for(size_t+i++%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4")

#codesample("https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:26,positionColumn:1,positionLineNumber:26,selectionStartColumn:1,selectionStartLineNumber:26,startColumn:1,startLineNumber:26),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Astatic+void+print(int+a)%0A%7B%0A++std::cout+%3C%3C+a+%3C%3C+!'+!'%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B4,+5,+5,+5,+7,+9,+9,+5%7D%3B%0A%0A++std::vector%3Cint%3E::iterator+it+%3D+std::remove(foo.begin(),+foo.end(),+5)%3B%0A++std::for_each(foo.begin(),+it,+print)%3B%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%0A%23if+0%0A++for(size_t+i++%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4")


== STL Algorithmes -- Suppression

- ```cpp std::remove_if()``` élimine les éléments vérifiant le prédicat
- ```cpp std::remove_copy()``` copie les éléments différents d'une valeur donnée
- ```cpp std::remove_copy_if()``` copie les éléments ne vérifiant pas le prédicat

== STL Algorithmes -- Suppression des doublons

- ```cpp std::unique()``` élimine les éléments consécutifs égaux sauf le premier

// Tout comme remove, les éléments ne sont pas supprimés du conteneur mais déplacé à la fin et l'itérateur correspondant est renvoyé
// L'ordre relatif est préservé, important si la comparaison ne se fait que sur une partie d'un élément composite

```cpp
vector<int> foo{4, 5, 5, 5, 7, 9, 9, 5};

unique(foo.begin(), foo.end());  // 4 5 7 9 5 ...
```

- ```cpp std::unique_copy()``` copie l'ensemble en ne conservant que le premier des éléments consécutifs égaux

#codesample("https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:26,positionColumn:1,positionLineNumber:26,selectionStartColumn:1,selectionStartLineNumber:26,startColumn:1,startLineNumber:26),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Astatic+void+print(int+a)%0A%7B%0A++std::cout+%3C%3C+a+%3C%3C+!'+!'%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B4,+5,+5,+5,+7,+9,+9,+5%7D%3B%0A%0A++std::vector%3Cint%3E::iterator+it+%3D+std::unique(foo.begin(),+foo.end())%3B%0A++std::for_each(foo.begin(),+it,+print)%3B%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%0A%23if+0%0A++for(size_t+i++%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4")

== STL Algorithmes -- Transformation

- ```cpp std::transform()``` applique une transformation aux éléments d'un ensemble

```cpp
int double_val(int i) { return 2 * i;}

vector<int> foo{4, 5, 7, 9};
vector<int> bar(4);
transform(foo.begin(), foo.end(), bar.begin(), double_val);
// 8 10 14 18
```

== STL Algorithmes -- Transformation

- Ou de deux ensembles en stockant le résultat dans un troisième

```cpp
vector<int> foo{4, 5, 7, 9};
vector<int> bar{2, 3, 6, 1};
vector<int> baz(4);

transform(foo.begin(), foo.end(), bar.begin(),
          baz.begin(), plus<int>());
// 6 8 13 10
```

#codesample("https://godbolt.org/#z:OYLghAFBqd5QCxAYwPYBMCmBRdBLAF1QCcAaPECAMzwBtMA7AQwFtMQByARg9KtQYEAysib0QXACx8BBAKoBnTAAUAHpwAMvAFYTStJg1DIApACYAQuYukl9ZATwDKjdAGFUtAK4sGe1wAyeAyYAHI%2BAEaYxCAAzADspAAOqAqETgwe3r56KWmOAkEh4SxRMQm2mPYFDEIETMQEWT5%2BXJXVGXUNBEVhkdFxiQr1jc05bcPdvSVlgwCUtqhexMjsHOaxwcjeWADUJrFuTsPEmKwH2CYaAIIbWzuY%2B4cAbpgOJBdXt2abDNteewObjEwBIhAQLE%2BNy%2Bk0cyF2wQIu3QSwi9AA%2Bs8xBBEQi5l8TPErDddrtTgRlgxdmZdgAqBEHYm3eIAEQJN1xLCYwQg%2BOhRK%2BpMJTNJpOG6BAIFe72IQMRF12/FQwukuwArKRdoldgBOQls2Ii0XiyXSoiyw7y2LYXYRBoQST4w3s66i3YmkAEYiGBT8YgsaioVAAOiiwB5C0VQeDrl5mrtxFDmHDDDjyNRGKxtCdRtJfogaQAXph0Ui8E8WbsNIyEU83LaGsGi5heTXrNY8HzXaLhYK3e6CBKUEskUCgQ3ZWqLHgTGrK2PDrswBwl%2BtnSSe6y%2B2LB5K0F5R4dx8vZ24GCf1939S6hQKNzuh2aPpbBAqlSrNRqtZq9VvL26PSfC0jlfa0J2FMxNViTUADZNS4a9/2NXcpTec05VAm07ULB0cxvZChy9H0/QDJUkxTNMyNjSME3IiN4yYQs6NTSMPSSbwFAwggLl5PD7yjYgCzwYtS1rA5K2rQ0xMXbCm2Elsc32SwOy7N1e34h89xHOtx2w2dp1necj0XZdV0Zbd9i3fiPX3Q83GPdY1TPC8jWvfk2RuDgFloTg1V4PwOC0UhUE4ezlMsd0lhWR4Nh4UgCE0LyFgAaxANUNH0ThJH8xLgs4XgFBADKEsCrzSDgWAkEwVQ3gPEhyEoBpgAUZRDCqIQEFQAB3AK4rQFgkjoJgalakJaA67qAqC/rBvoGJmuYJIFE6ghSBmuholCVg1l4da5oAeQPCaety6q3muYhmvy0gzuQOp8AC3h%2BEEEQxHYKQZEERQVHUUrSF0NoDCMFB20sfQ8AiQrIAWVAkhqQqOAAWnFcTTHCiwuC4XZEYAdTEWhsZx6qiN4VBXmIYg8CwKG42ILxBDwNgABUg1oGmFgUKLVj0cVglG9rOpO7heC9TA1jirrvSSRLvN8nK/pCjhsBq5A6uIXZVAADhgxGYMkXZgGQeEIC9enkrmXYIDCqwwd2XBCBIJTYi4OYRZlhYEDOLAYjjVL0syjhstIKbSeuwrivdgOzHloLFbd0q5gWcm0mcSQgA%3D%3D")

== STL Algorithmes -- Rotation

- ```cpp std::rotate()``` effectue une rotation de l'ensemble, le nouveau début étant fourni par un itérateur

```cpp
vector<int> foo{4, 5, 7, 9, 12};

rotate(foo.begin(), foo.begin() + 2, foo.end());  // 7 9 12 4 5
```

- ```cpp std::rotate_copy()``` effectue une rotation et copie le résultat

#codesample("https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:16,positionColumn:1,positionLineNumber:16,selectionStartColumn:1,selectionStartLineNumber:16,startColumn:1,startLineNumber:16),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B4,+5,+7,+9,+12%7D%3B%0A%0A++std::rotate(foo.begin(),+foo.begin()+%2B+2,+foo.end())%3B%0A++for(size_t+i+%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4")

== STL Algorithmes -- Partitionnement

- ```cpp std::partition()``` réordonne l'ensemble pour que les éléments vérifiant le prédicat soit avant ceux ne le vérifiant pas ...

```cpp
bool is_odd(int i) { return (i % 2) == 1; }
vector<int> foo{4, 13, 28, 9 , 54};

partition(foo.begin(), foo.end(), is_odd);
// 9 13 28 4 54 ou 9 13 4 28 54 ou ...)
```

- ... et retourne un itérateur sur le début de la seconde partie

#alertblock("Attention", text[
  - Ordre relatif non conservé
])

== STL Algorithmes -- Partitionnement

- ```cpp std::stable_partition()``` partitionne en conservant l'ordre relatif

```cpp
vector<int> foo{4, 13, 28, 9 , 54};

stable_partition(foo.begin(), foo.end(), is_odd);  // 13 9 4 28 54
```

#noteblock("Deux fonctions ?", text[
  - Stabilité coûteuse en temps et pas toujours nécessaire
])

== STL Algorithmes -- Partitionnement

- ```cpp std::nth_element()``` réordonne les éléments
  - Élément sur l'itérateur pivot est celui qui serait à cette place si l'ensemble était trié
  - Éléments avant ne sont pas supérieurs
  - Éléments après ne sont pas inférieurs
  - Pas d'ordre particulier au sein des deux sous-ensembles

// Formulation "pas supérieur" étrange mais gère le cas des égalités avec le pivot et la sémantique de l'opérateur fourni

```cpp
vector<int> foo{9, 8, 7, 6, 5, 4, 3, 2, 1};

nth_element(foo.begin(), foo.begin() + 3, foo.end());
// 2 1 3 4 5 9 6 7 8
```

#codesample("https://godbolt.org/#z:OYLghAFBqd5QCxAYwPYBMCmBRdBLAF1QCcAaPECAMzwBtMA7AQwFtMQByARg9KtQYEAysib0QXACx8BBAKoBnTAAUAHpwAMvAFYTStJg1DIApACYAQuYukl9ZATwDKjdAGFUtAK4sGe1wAyeAyYAHI%2BAEaYxCCSAKykAA6oCoRODB7evnrJqY4CQSHhLFEx8baY9vkMQgRMxASZPn5cFVXptfUEhWGR0bEJCnUNTdmtQ109xaUDAJS2qF7EyOwc5gDMwcjeWADUJutuTkPEmKwH2CYaAIIbWzuY%2B4cAbpgOJBdXt2abDNteewObjEwBIhAQLE%2BNy%2BE0cyF2EVQnl2eAUAH0MOgIMECCjZl8TAB2Kw3Xa7U4EJYMXbY8xxMz49YAEQOTK4BxJt0JLOhNxxuxYTGCEHx0OJXzJRM5ZLJQ3QIBAr3exCBOIuu34qCl0l2XHWpF2ZgAHAaAJy7A1xSRElnrTkSmVyhWJLppATUJEAOiiwGF8w1XtcIoNqIx6HQjOlMv4xAgqQAXpg0bi8E8mbsNByUU83AHUJ6E5gRVnrNY8KLrjL9uLSVXdk6UItcUCgXmTHELHh2%2BmW4ddmAOP21naHZLuaP6wR5Y2vM3Dq2B%2B23AxFyPazaCeua5XHVOFUqiCrDmr1tg28SdXqDcazRbdlaN2vbrXZXuQBMIvQ0S6Gm6GB78x9P0DU1T0g39UNMUjCcYzjPBE2TbNWQzLNU1bUDC2LO19ksMsKyrKUJ1fac0FnHN0KRdtO27ci%2BwHIcOQnDcX0nEim1o3NFziZdVyjZjnx3QiWIbA8PmPQR1U1KVTQNE1dkJA0ADZLQNHV9UNA12XHJ8JwbQQEDRSpMDYQQAO9TBfX/f1QKAqycIsXZ1NA8DoJY2DC0QtDmRQ7CvNzDD4KLSN7LwpjtzrViFVIuc3AorUOy7OIe3nOjB14sKeR3YiovY3tOLWbiV2HPjxzFTKOHmWhODiXg/A4LRSFQThYtwyx60WZZHg2HhSAITQKvmABrEA4g0fROEkWr%2BsazheAUEAxr6%2BqKtIOBYCQTBVDeWcSHISh6mABRlEMSohAQVAAHc6p6tAWESOgmGqY6QloM7Lrqhrbvu%2BgYkO5hEgUc6CFIL66GiUJWFWXhQZ%2BgB5Wc3qu6bNrea5iEO2bSBR5BanwOreH4QQRDEdgpBkQRFBUdRltIXRWgMIwUFLSx9DwCJ5sgeZUESap5o4ABaOVWVMVqLC4Lhdn5gB1MRaElqXNoIYgmF4VBXmIYg8CwDng2ILxBDwNgABUkVoHX5gUDqVj0OVgme07zqR7heCVzBVh6i7lcSfrKuqqaaaajhsC25AduIXZVCNRT%2BcUyRdmAZB4QgJX9cG2YaRaqwWd2XBCBIHD1i4WYXZ9%2BYEDOLAYmDYbRvGjhJtID7Vcx%2BbFtLuuzH9hrA5L5bZnmdXUmcSQgA%3D")

== STL Algorithmes -- Tri

- ```cpp std::sort()``` trie un ensemble

```cpp
vector<int> foo{4, 13, 28, 9 , 54};

sort(foo.begin(), foo.end());  // 4 9 13 28 54
```

#alertblock("Attention", text[
  - Ordre relatif non conservé
])

- ```cpp std::stable_sort()``` trie l'ensemble en conservant l'ordre relatif

== STL Algorithmes -- Tri

- ```cpp std::partial_sort()``` réordonne l'ensemble de manière à ce que les éléments situés avant un itérateur pivot soient les plus petits éléments de l'ensemble ordonnés par ordre croissant ...

```cpp
vector<int> foo{9, 8, 7, 6, 5, 4, 3, 2, 1};

partial_sort(foo.begin(), foo.begin() + 3, foo.end());
// 1 2 3 9 8 7 6 5 4
```

- ... les autres éléments n'ont pas d'ordre particulier
- ```cpp std::partial_sort_copy()``` copie l'ensemble ordonné à l'image de ```cpp std::partial_sort()```

#codesample("https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:29,positionColumn:1,positionLineNumber:29,selectionStartColumn:1,selectionStartLineNumber:29,startColumn:1,startLineNumber:29),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B4,+13,+28,+9+,+54%7D%3B%0A%0A++++std::sort(foo.begin(),+foo.end())%3B%0A++++for(size_t+i+%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++++%7B%0A++++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+!'+!'%3B%0A++++%7D%0A++++std::cout+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B9,+8,+7,+6,+5,+4,+3,+2,+1%7D%3B%0A%0A++++std::partial_sort(foo.begin(),+foo.begin()+%2B+3,+foo.end())%3B%0A++++for(size_t+i+%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++++%7B%0A++++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+!'+!'%3B%0A++++%7D%0A++++std::cout+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4")

== STL Algorithmes -- Mélange

- ```cpp std::random_shuffle()``` réordonne aléatoirement l'ensemble

```cpp
vector<int> foo{9, 8, 7, 6, 5, 4, 3, 2, 1};

random_shuffle(foo.begin(), foo.end());
// 1 8 3 7 9 4 2 6 5
// ou ...
```

#codesample("https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:15,positionColumn:1,positionLineNumber:15,selectionStartColumn:1,selectionStartLineNumber:15,startColumn:1,startLineNumber:15),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B9,+8,+7,+6,+5,+4,+3,+2,+1%7D%3B%0A%0A++std::random_shuffle(foo.begin(),+foo.end())%3B%0A++for(size_t+i+%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4")

== STL Algorithmes -- Fusion

- ```cpp std::merge()``` fusionne deux ensembles triés dans un troisième

```cpp
vector<int> foo{1, 5, 6, 8};
vector<int> bar{2, 5};
vector<int> baz;

merge(foo.begin(), foo.end(), bar.begin(), bar.end(),
      back_inserter(baz));      // 1 2 5 5 6 8
```

- ```cpp std::inplace_merge()``` fusionne deux sous-ensembles sur place

#codesample("https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:31,positionColumn:1,positionLineNumber:31,selectionStartColumn:1,selectionStartLineNumber:31,startColumn:1,startLineNumber:31),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B1,+5,+6,+8%7D%3B%0A++++std::vector%3Cint%3E+bar%7B2,+5%7D%3B%0A++++std::vector%3Cint%3E+baz%3B%0A%0A++++std::merge(foo.begin(),+foo.end(),+bar.begin(),+bar.end(),+std::back_inserter(baz))%3B%0A++++for(size_t+i+%3D+0%3B+i+%3C+baz.size()%3B+%2B%2Bi)%0A++++%7B%0A++++++std::cout+%3C%3C+baz%5Bi%5D+%3C%3C+!'+!'%3B%0A++++%7D%0A++++std::cout+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B1,+5,+6,+8,+2,+5%7D%3B%0A%0A++++std::inplace_merge(foo.begin(),+foo.begin()+%2B+4,+foo.end())%3B%0A++++for(size_t+i+%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++++%7B%0A++++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+!'+!'%3B%0A++++%7D%0A++++std::cout+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4")

== STL Algorithmes -- Opérations ensemblistes

#alertblock("Attention", text[
  - Ensembles sans répétition de valeur
  - Ensembles triés
])

- ```cpp std::includes()``` vérifie si tous les éléments sont présents dans un autre ensemble

```cpp
vector<int> foo{1, 5, 6, 8};
vector<int> bar{2, 5};
vector<int> baz{1, 6};

includes(foo.begin(), foo.end(), bar.begin(), bar.end());  // faux
includes(foo.begin(), foo.end(), baz.begin(), baz.end());  // vrai
```

== STL Algorithmes -- Opérations ensemblistes

- ```cpp std::set_union()``` : union de deux ensembles

```cpp
vector<int> foo{1, 5, 6, 8};
vector<int> bar{2, 5};
vector<int> baz;

set_union(foo.begin(), foo.end(), bar.begin(),
          bar.end(), back_inserter(baz));   // 1 2 5 6 8
```
- ```cpp std::set_intersection()``` : intersection de deux ensembles
- ```cpp std::set_difference()``` : différence de deux ensembles
- ```cpp std::set_symmetric_difference()``` : différence symétrique de deux ensembles

// set_difference() conserve les éléments présents dans le premier ensemble mais pas dans le second alors que set_symmetric_difference() conserve les éléments présents dans un des ensembles mais pas dans l'autre}

#codesample("https://godbolt.org/#z:OYLghAFBqd5QCxAYwPYBMCmBRdBLAF1QCcAaPECAMzwBtMA7AQwFtMQByARg9KtQYEAysib0QXACx8BBAKoBnTAAUAHpwAMvAFYTStJg1DIApACYAQuYukl9ZATwDKjdAGFUtAK4sGe1wAyeAyYAHI%2BAEaYxCAAbAAcpAAOqAqETgwe3r56KWmOAkEh4SxRMQm2mPYFDEIETMQEWT5%2BXJXVGXUNBEVhkdFxiQr1jc05bcPdvSVlgwCUtqhexMjsHOYAzMHI3lgA1CYbbk7DxJish9gmGgCCm9u7mAdHAG6YDiSX13dmWww7Xn2hzcYmAJEICBYX1u32CBD2LCYwQgc2%2BJgA7FZbnsDpjvjiccN0CAQG8PsRgXDLnt%2BKgMRY2nsAKykPaxVnxDEAEUOWJuBL2RJJZKIFKOVI22D2EQa9LMrKZ3N5%2BIJQtJ71FlME1JlAC96YzYkqNnyVYSCMSUEt4cDgYKLSSIqhPGIkggmM83Ha1Q9AZgFNRnQA6KLAZELGnB1wo1ky4ghzBhhgx6UNIPRuZzT12sDrJluBi55XY1UOq1eG1Hb1lp0u2huj22o72y2%2BrAB2kJpMpzsZ2NMXVd8P9wcZrNNtx7Iv5wvrE0qpUwkv0s0t4Uaz7i7WSyN0zGMllsjnGvkCtUizfHbdSuNyhUn1fnjdiq8EHUD4t3Evmy1KAgAfS8BgMkDVAh2TCNewYdAUzjcDYLTPtU2QABrf9giURpoggPVM0/AV%2BGICA0l1TB/3hPBni5PYNF5PZKLtPUgxIzAUTo6xrDwVFv1xU8BTXctKy9Zs9RMJkLDwMTqInKcOFk/CCUXflS0tNAK2zZtpwLIt52XdEeSXZSVx4p9yS1N8d1pA0FVZdk9k5fSFJ/dczK3Cyb1lTF5WZB8TLLC8XwlDz9V0r9lOckA/3QwRoiUBwQM7UNh13dNoIQ%2BMkog/t4yQmVUOizCCGw3DUVCgiSGIvBSPI%2BiqJouiGJEgdmKq1jSosA5LE47jwt41cIrUoTGI/cTJKZaSq00uSdL4nElLPMtBo0yctNnBSlIXPE/MtALzOpKz9xso97N83rTM1Nz3wpLz70csqVJci7X3fELTW2kkovwKgqGiRhVlA%2BDIKjNKIzgzL0tSmDQaYfKMOiIqiJKpzIyIliasa6jaJNWrhsHFi2OxjjLC41djN6gbrWW1N9VGqSqdzeT7rmxz3sE%2Bm820uc%2BI2vTZoE3bLss51rOZWzjzuvnzsvILU2uixvMVCXH38589p3UTQuV39MAAhQAE8WDYAhiDwZB/y%2Bn6zn%2BVjEsTZKoKh7LAad3KYbQuGsMRgc8KZlHKuqii6qxjrGsnJj8fazqrGJnqBTJ/iBKWmTRNp8b2cZvn5oetmZNWmbNoMu4WZuDgFloTgmV4PwOC0UhUE4L0ussQUlhWJ5Nh4UgCE0UuFhQkAmQ0fROEkKue7rzheAUEAh%2B7mvS9IOBYCQTBVHeCsSHISgGmABRlEMKohAQVAAHdq87tAWCSOgmBqfeQloI/T%2Br2vL%2Bv%2BgYl35gkgUY%2BCFIN%2BdBoihFYGsXggCP4AHkKxPzPuPVe7wbjEF3pPUgCDkB1HwNXXg/BBAiDEOwKQMhBCKBUOoeepBdBtAMEYFARMbC0DwBEaekAFioCSDUaeHAAC0RJDhclME3BkXA9jcIAOpiFoKIsRq9jZMF4KgN4xATbtngAsYgQFHBsAACrOloCwmMChW6rD0ESYI99D7HzgdwXgxtMBrE7ifYgTAkg9zLhXMeFD64cGwGvZAG9iB7FUPEWI3DYiSD2MAZAyA9gQGNkBFCWYICN2jjYPYuBCAkE6hsLgcxbFuIWAgc4WAYgxn7oPYeHBR6kBfgo1B09Z4FMqWYTxtdvH5PnpmUgSi0jOEkEAA%3D%3D%3D")

== STL Algorithmes -- Gestion de tas

#noteblock("Tas", text[
  - Structure permettant la récupération de l'élément de plus grande valeur
])

- ```cpp std::make_heap()``` forme un tas depuis un ensemble
- ```cpp std::pop_heap()``` déplace l'élément de plus haute valeur en fin d'ensemble
- ```cpp std::push_heap()``` ajoute l'élément en fin d'ensemble au tas

#noteblock("Structure", text[
  - ```cpp std::pop_heap()``` et ```cpp std::push_heap()``` maintiennent la structure de tas
])

- ```cpp std::sort_heap()``` tri le tas

#codesample("https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:27,positionColumn:1,positionLineNumber:27,selectionStartColumn:1,selectionStartLineNumber:27,startColumn:1,startLineNumber:27),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B10,20,30,5,15%7D%3B%0A%0A++std::make_heap(foo.begin(),+foo.end())%3B%0A++std::cout+%3C%3C+foo.front()+%3C%3C+!'%5Cn!'%3B%0A%0A++std::pop_heap(foo.begin(),+foo.end())%3B%0A++foo.pop_back()%3B%0A++std::cout+%3C%3C+foo.front()+%3C%3C+!'%5Cn!'%3B%0A%0A++foo.push_back(99)%3B%0A++std::push_heap(foo.begin(),+foo.end())%3B%0A++std::cout+%3C%3C+foo.front()+%3C%3C+!'%5Cn!'%3B%0A%0A++std::sort_heap(foo.begin(),+foo.end())%3B%0A++for(size_t+i+%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4")

== STL Algorithmes -- Min-max

- ```cpp std::min()``` détermine le minimum de deux éléments
- ```cpp std::max()``` détermine le maximum de deux éléments

```cpp
min(52, 6);  // 6
max(52, 6);  // 52
```

- ```cpp std::min_element()``` détermine le plus petit élément d'un ensemble

```cpp
vector<int> foo{18, 5, 6, 8};

min_element(foo.begin(), foo.end()); // Sur 5
```

- ```cpp std::max_element()``` détermine le plus grand élément d'un ensemble

#codesample("https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:10,positionColumn:1,positionLineNumber:10,selectionStartColumn:1,selectionStartLineNumber:10,startColumn:1,startLineNumber:10),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B18,+5,+6,+8%7D%3B%0A%0A++std::cout+%3C%3C+*std::min_element(foo.begin(),+foo.end())+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+*std::max_element(foo.begin(),+foo.end())+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4")

== STL Algorithmes -- Numérique

- ```cpp std::accumulate()``` "ajoute" tous les éléments de l'ensemble

```cpp
vector<int> foo{18, 5, 6, 8};

accumulate(foo.begin(), foo.end(), 1, multiplies<int>()); // 4320
```

- Opérateur et valeur initiale configurables
- _Reduce_/_fold_ fonctionnel


== STL Algorithmes -- Numérique

- ```cpp std::adjacent_difference()``` "différence" entre chaque élément et son prédécesseur

```cpp
vector<int> foo{18, 5, 6, 8};
vector<int> bar;

// 18 -13 1 2
adjacent_difference(foo.begin(), foo.end(),
                    back_inserter(bar), minus<int>());
```

- Opérateur configurable


== STL Algorithmes -- Numérique

- ```cpp std::inner_product()``` : "produit scalaire" de deux ensembles

```cpp
vector<int> foo{1, 2, 3, 4};
vector<int> bar{2, 3, 4, 5};

inner_product(foo.begin(), foo.end(), bar.begin(), 0); // 40
```

- Opérateurs et valeur configurables

== STL Algorithmes -- Numérique

- ```cpp std::partial_sum()``` : "somme" partielle d'un ensemble
- Chaque élément résultant est la somme des éléments d'indice inférieur ou égal de l'ensemble de départ

```cpp
vector<int> foo{1, 2, 3, 4};
vector<int> bar;

// 1 3 6 10
partial_sum(foo.begin(), foo.end(), back_inserter(bar));
```

- Opérateur configurable

#codesample("https://godbolt.org/#z:OYLghAFBqd5QCxAYwPYBMCmBRdBLAF1QCcAaPECAMzwBtMA7AQwFtMQByARg9KtQYEAysib0QXACx8BBAKoBnTAAUAHpwAMvAFYTStJg1DIApACYAQuYukl9ZATwDKjdAGFUtAK4sGe1wAyeAyYAHI%2BAEaYxCAArAAcpAAOqAqETgwe3r56KWmOAkEh4SxRMQm2mPYFDEIETMQEWT5%2BXJXVGXUNBEVhkdFxiQr1jc05bcPdvSVlgwCUtqhexMjsHOYAzMHI3lgA1CYbbk7DxJish9gmGgCCm9u7mAdHAG6YDiSX13dmWww7Xn2hzcDB80Twpg2V1u32CBD2LCYwQgc2%2BJgA7FZbnsDpjvjiccN0CAQG8PsRgXDLnt%2BKgMRYuIk9rFSHsAGys%2BIYgAihyxNwJeyJJLQXnhwOBQoIxJATGQyB8XgMBEw1FQqAAdFFgMiFjT1RrXCjWW0pTKWErHElaHhMApKYJLii5s83JKwOtYiCPXz8bjeTDsbj%2BYLhaT3kQKUcqVD9XTMYzWSz2Zyeb6g4TpSSyZGHQRqREGum7hmzSSmOhtHLGAQAPr4KhUaKMVZqzXa3Ws2mGhjoY17QvIADWteCSka0QgheIerDLGCXnt0cdUOdxcF/GIEDSAC9MLX4Xhnty9ho%2BXsj5Lpxrd6rURsLAdLNY8KjS/S/aGsygluKjlei1iCw8BMWITwlI49g9KD1gfT9/XgsNRT/N1IJ9L0GB9OCgzTQMBWDRDvxzT5l3zWNaXpU0zFZDZWUkNNsPwzMZWIqNjhXbAByLTFqL2Wi9mkZkGP5QiZWQ11JTDYIQmIWskmIDAvAcNstUwHUGH7bsjT1a8Ow0vUNBdCC3Bg0DvVgkMELwnEP1LMNWLzakKITVleP4%2Bj0V5RivxYiMSPYsjOOnYtRJJJJujwMRawUHwVL0zSDW01lBxHMdohVLdpzme9LJxTdtzwPcDwvY9T3PS9IOvW8UXPawXzfJiCNLZiRV/CTKsA4DQPA/80I4UzvIJXDGqQtrjNMjCsMs4a0V%2BPAqDKoMAHolr2AAxOVI1tWh6D9WyRqIvy2JjTjnIZVyaLo4TQvDclHNjYLGJu8LGki2hoti7t4r1LTe37FLRwYccMqnBpZ2/C1aCtG07Xu7A10GvKSAKorD1Ks8HxKgDiBvQq71q59LFfeD9sFFqfzFdqTOCoCQLAqmYIG3KrIOsSxt6kz0PM9cWc2Vx5rRTzvg4BZaE4WJeD8DgtFIVBODdQnHwUJYVieTYeFIAhNBFhYhziDR9E4SRJe12XOF4BQQANrXpZF0g4FgJBMFUd4xRIchKAaYAFGUQwqiEBBUAAdyljW0BYJI6CYGpfZCWgA%2BDqWZfDyP6Bib3mCSBRA4IUgU7oaJQlYNZeHztOAHkxQTkPTed94bmIb3zdIOvkDqfApd4fhBBEMR2CkGRBEUFR1Ft0hdDaAwjBQOrLH0PAIktyAFlQJIaktjgAFoiUOblTEVrguD2TeAHUxFoY%2BT%2BdghiCYXhUDeYhiDwLAl%2BNYgvEEPA2AAFXVWg34LGVssVYegiTBFjv7QONduC8BvpgNYGsg63ySNrUW4sTZjzlhwbALsFSRj2KoeIbJN5skkHsYA8o9gQBvp/IcLoIAKysHPPYuBCAkCfBsLgcw4FoIWAgc4WAYjGj1rEA2YsODG1IEne%2BzdLbWz4YbDgZhMEy2wbw222VSCPzSM4SQQA%3D%3D%3D")

== STL Algorithmes -- Au delà des conteneurs

- Itérateurs définissables hors des conteneurs
  - Abstraction du parcours
  - Sémantique de pointeurs
- Algorithmes indépendants du conteneur
- Utilisables sur d'autres ensembles de données

== STL Algorithmes -- Au delà des conteneurs

- Tableaux C
  - Pas un conteneur

//Il contient mais est très différent des conteneurs classiques : frustre, minimaliste, rudimentaire, pas de réelle sémantique, peu d'intelligence

    - Sémantique : Tableau ou pointeur ? Statique ou dynamique ?
    - Service : Taille ? Copie ?
  - Simple pointeur comme itérateur
    - Début : adresse du premier élément
    - Fin : adresse suivant le dernier élément

```cpp
int foo[4];

fill(foo, foo + 4, 5);  // 5 5 5 5
```

== STL Algorithmes -- Au delà des conteneurs

- Flux
  - ```cpp istream_iterator``` : \textit{input} itérateur
    - Début : depuis un flux entrant
    - Fin : constructeur par défaut
  - ```cpp ostream_iterator``` : \textit{output} itérateur
	  - Depuis un flux sortant, séparateur configurable

	```cpp
		vector<int> foo{5, 6, 12, 89};
		ostream_iterator<int> out_it (cout, ", ");

		copy(foo.begin(), foo.end(), out_it); // 5, 6, 12, 89,
	```

#alertblock("Attention", text[
  - Séparateur ajouté après chaque élément, y compris le dernier
])

- Buffers de flux : ```cpp istreambuf_iterator``` et ```cpp ostreambuf_iterator```

#codesample("https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:13,positionColumn:1,positionLineNumber:13,selectionStartColumn:1,selectionStartLineNumber:13,startColumn:1,startLineNumber:13),source:'%23include+%3Ciostream%3E%0A%23include+%3Citerator%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B5,+6,+12,+89%7D%3B%0A++std::ostream_iterator%3Cint%3E+out_it+(std::cout,+%22,+%22)%3B%0A%0A++std::copy(foo.begin(),+foo.end(),+out_it)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4")

== STL Conclusion
#adviceblock("Do", text[
  - Préférez les conteneurs aux tableaux C
])

#alertblock("Attention", text[
  - ```cpp operator[]``` ne vérifie pas les bornes

// Une implémentation peut mettre une assertion dessus et produire une erreur à l'exécution en debug, p.ex. sur les TU, et une implémentation de qualité devrait le faire
])

#alertblock("Don't", text[
  - N'utilisez pas d'itérateur invalidé
])

#alertblock("Attention", text[
  - Pas objets polymorphiques dans les conteneurs
  - Ou via des pointeurs intelligents
])

== STL Conclusion

#adviceblock("Do, performances", text[
  - Mesurez !
])

#noteblock("Conseils, performances", text[
  - Réfléchissez à votre utilisation des données

// Utilisation des données : zone critique/non critique, découpage d'algorithmes, données particulières (triées, lourdes à copier), compromis temps/mémoire, stabilité (tri), mise en cache, ...

  - Méfiez-vous des complexités brutes

// La complexité n'est pas ou peu significative pour de petits volumes de données, p.ex. les tris par insertion ou sélection (O($n^{2}$)) plus efficaces que des tris en O($n\ln n$)}
// Les complexités moyennes ne sont pas pertinentes pour des données particuliers, p.ex. tri par insertion efficace sur ensembles presque triés, peu de permutation du tri par sélection donc efficace pour des données lourdes à déplacer}
])

#adviceblock("Do", text[
- Préférez les algorithmes standards aux algorithmes tierces et maisons
])

#noteblock("Bémol, performances", text[
  - Algorithmes standards généralement bons, mais pas optimaux dans toutes les situations
])

== STL Conclusion

#adviceblock("Do", text[
  - Faites vos propres algorithmes plutôt que des boucles
  - Faites des algorithmes génériques et compatibles
])

#adviceblock("Do, sémantique", text[
  - Le bon algorithme pour la bonne opération
  - Définissez la sémantique de vos algorithmes et choisissez un nom explicite
])

#adviceblock("Do", text[
  - Préférez les prédicats purs
])

== STL Conclusion

#adviceblock("Do", text[
  - Vérifiez que les ensembles de destination aient une taille suffisante
])

#adviceblock("Do", text[
  - Vérifiez les pré-conditions des algorithmes (p.ex. ensemble trié)
  - Vérifiez le type d'itérateur requis
  - Vérifiez les complexités garanties
])

#noteblock("Aller plus loin", text[
  - Voir #link("https://github.com/CppCon/CppCon2016/blob/master/Presentations/STL%20Algorithms/STL%20Algorithms%20-%20Marshall%20Clow%20-%20CppCon%202016.pdf")[STL Algorithms #linklogo() (Marshall Clow)]
])

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

== Dépréciations et suppressions}

- Dépréciation de ```cpp register```

#addproposal("n4193")

== Export templates

- Suppression des \textit{export templates}
- ```cpp export``` reste un mot-clé réservé

#noteblock("Compatibilité", text[
  - Rupture de comptabilité ascendante
  - Implémenté sur un unique compilateur et inutilisé en pratique

// Un seul front end EDG, utilisé par deux compilateurs (Comeau et ICC) mais la fonctionnalité n'était pas active chez Intel
// Suppression soutenue par l'équipe d'EDG
])

#noteblock("Motivations", text[
  - Voir #link("http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2003/n1426.pdf")[N1426 #linklogo()]

// En gros les motivations sont : peu utile, peu demandé, compliqué à implémenter et compliqué à utiliser}
])

#addproposal("N1426")

== Nouveaux types entiers

- Hérités de C99

#noteblock("Depuis C99", text[
  - Ainsi que _variadic macro_, ```cpp __func__```, concaténation de chaînes littérales, ...
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
  - Pas fournie par l'utilisateur
  - Pas de fonction virtuelle ni de classe de base virtuelle
  - Opération des classes de bases et des membres non-statiques est triviale
])

#addproposal("n2342")

== POD Généralisé -- Classe POD C++11

#noteblock("Autre formulation", text[
  - Copie, déplacement, affectation et destruction générés implicitement
  - Pas de fonction ni de classe de base virtuelle
  - Classes de base et membres non-statiques _trivially copyable_
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

#noteblock("En résumé", text[
  - Organisation mémoire similaire aux structures C
])

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


```cpp
namespace V1 { void foo() { cout << "V1\n"; } }

inline namespace V2 { void foo() { cout << "V2\n"; } }

V1::foo();  // Affiche V1
V2::foo();  // Affiche V2
foo();      // Affiche V2
```

#noteblock("Motivation", text[
  - Évolution de bibliothèques et conservation des versions précédentes
])

#codesample("https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:26,startColumn:1,startLineNumber:26),source:'%23include+%3Ciostream%3E%0A%0Anamespace+V1%0A%7B%0A++static+void+foo()%0A++%7B%0A++++std::cout+%3C%3C+%22V1%5Cn%22%3B%0A++%7D%0A%7D%0A%0Ainline+namespace+V2%0A%7B%0A++static+void+foo()%0A++%7B%0A++++std::cout+%3C%3C+%22V2%5Cn%22%3B%0A++%7D%0A%7D%0A%0Aint+main()%0A%7B%0A++V1::foo()%3B%0A++V2::foo()%3B%0A%0A++foo()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4")

#addproposal("N2535")



== ``` 0``` ou ``` NULL``` ?

- C++ 98 : ```cpp 0``` ou ```cpp NULL```

// En C++, NULL est un define sur 0 (ou équivalent), ne peut pas être (void*)0 comme en C

- Cohabite mal avec les surcharges

#noteblock("Quiz : Quelle surcharge est éligible ?", text[
```cpp
void foo(char*) { cout << "chaine\n"; }
void foo(int) { cout << "entier\n"; }

foo(0);
foo(NULL);
```
])

== ``` 0``` ou ``` NULL``` ? ``` nullptr``` !

- C++ 11 : ```cpp nullptr```
  - Unique pointeur du type ```cpp nullptr_t```
  - Conversion implicite de ```cpp nullptr_t``` vers tout type de pointeur

```cpp
void foo(char*) { cout << "chaine\n"; }
void foo(int) { cout << "entier\n"; }

foo(0);        // Version int
foo(nullptr);  // Version pointeur
```

#adviceblock("Do", text[
  - Utilisez ```cpp nullptr``` plutôt que ```cpp 0``` ou ```cpp NULL```
])

#codesample("https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astatic+void+foo(char*)%0A%7B%0A++std::cout+%3C%3C+%22chaine%5Cn%22%3B%0A%7D%0A%0Astatic+void+foo(int)%0A%7B%0A++std::cout+%3C%3C+%22entier%5Cn%22%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++foo(0)%3B%0A%23if+1%0A++foo(NULL)%3B%0A%23else%0A++foo(nullptr)%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4")

#addproposal("N2431")

== ``` static_assert```

- Assertion vérifiée à la compilation

```cpp
static_assert(sizeof(int) == 3, "Taille incorrecte");
// Erreur de compilation indiquant "Taille incorrecte"
```

#adviceblock("Do", text[
  - Utilisez ```cpp static_assert``` pour vérifier à la compilation ce qui peut l'être
])

#adviceblock("Do", text[
  - Préférez les vérifications _compile-time_ ou _link-time_ aux vérifications _run-time_
])

#codesample("https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++static_assert(sizeof(int)+%3D%3D+3,+%22Taille+incorrecte%22)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4")

#addproposal("N1720")



== \mintinline[style=white]{cpp}```constexpr```}
	\begin{itemize}
		\item Indique une expression constante
		\item Donc évaluable et utilisable à la compilation
		\item Implicitement ```cpp const```
		\item Fonctions ```cpp constexpr``` implicitement ```cpp inline```
		\item Contenu des fonctions ```cpp constexpr``` limité
		\begin{itemize}
			\item ```cpp static_assert```
			\item ```cpp typedef```
			\item ```cpp using```
			\item Exactement une expression ```cpp return```
		\end{itemize}

\note[item]{Et des \textit{null statements}, mais ça n'a pas d'intérêt}
	\end{itemize}

	```cpp
		constexpr int foo() { return 42; }

		char bar[foo()];
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astatic+constexpr+int+foo()%0A%7B%0A++return+42%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++char+bar%5Bfoo()%5D+%3D+%22azerty%22%3B%0A%0A++std::cout+%3C%3C+bar+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{N2235}{https://wg21.link/N2235}



== \mintinline[style=white]{cpp}```constexpr```}
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

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astatic+constexpr+int+foo()%0A%7B%0A++return+42%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++int+a+%3D+42%3B%0A++switch(a)%0A++%7B%0A++++case+foo():%0A++++++std::cout+%3C%3C+%22case+foo%5Cn%22%3B%0A++++++break%3B%0A%0A++++default:%0A++++++std::cout+%3C%3C+%22defuault%5Cn%22%3B%0A++++++break%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{N2235}{https://wg21.link/N2235}



== \mintinline[style=white]{cpp}```constexpr```}
	\begin{itemize}
		\item Sous certaines conditions restrictives, ```cpp const``` sur une variable est suffisant

\note[item]{type entier ou énumération, initialisé à la déclaration par une expression constante}
	\end{itemize}

	```cpp
		const int a = 42;
		char bar[a];
	```

	\begin{alertblock}{\textit{Variable-Length Array}}
		\begin{itemize}
			\item Pas de rapport entre VLA et ```cpp constexpr```
			\item VLA est un mécanisme \textit{run-time}
		\end{itemize}
	\end{alertblock}

\note[item]{VLA est une fonctionnalité C, non reprise en C++, mais proposée sous forme d'extension par certains compilateurs. Elle consiste à accepter les tableaux de taille définie au \textit{run-time}}

	\begin{exampleblock}{Do}
		\begin{itemize}
			\item Déclarez ```cpp constexpr``` les constantes et fonctions évaluables en \textit{compile-time}
		\end{itemize}
	\end{exampleblock}

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:13,endLineNumber:6,positionColumn:13,positionLineNumber:6,selectionStartColumn:13,selectionStartLineNumber:6,startColumn:13,startLineNumber:6),source:'%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++const+int+a+%3D+42%3B%0A++char+bar%5Ba%5D+%3D+%22azerty%22%3B%0A%0A++std::cout+%3C%3C+bar+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== Extended \mintinline[style=white]{cpp}```sizeof```}
	\begin{itemize}
		\item ```cpp sizeof``` sur des membres non statiques
	\end{itemize}

	```cpp
		struct Foo { int bar; };

		// Valide en C++11, mal-forme en C++98/03
		cout << sizeof Foo::bar;
	```

\note[item]{Mal-formé (\textit{ill-formed}) n'implique pas une erreur de compilation ni même un avertissement, seulement que ce n'est pas correct vu de la norme}

	\begin{block}{Note}
		\begin{itemize}
			\item En pratique, cet exemple compile en mode C++98 sous GCC
		\end{itemize}
	\end{block}

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astruct+Foo%0A%7B%0A++int+bar%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+sizeof+Foo::bar+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{n2253}{https://wg21.link/n2253}


== Sémantique de déplacement}
	\begin{itemize}
		\item Deux constats
		\begin{itemize}
			\item Copie potentiellement coûteuse ou impossible
			\item Copie inutile lorsque l'objet source est immédiatement détruit
		\end{itemize}
	\end{itemize}

	\begin{block}{Optimisation des copies}
		\begin{itemize}
			\item Partiellement adressé en C++98/03 par l'élision de copie et (N)RVO
		\end{itemize}
	\end{block}

	\begin{itemize}
		\item Échange de données légères plutôt que copie profonde
		\item Déplacement seulement si
		\begin{itemize}
			\item Type déplaçable
			\item Instance sur le point d'être détruite ou explicitement déplacée
		\end{itemize}
	\end{itemize}

	\begin{alertblock}{Attention}
		\begin{itemize}
			\item Les données ne sont plus présentes dans l'objet initial
		\end{itemize}
	\end{alertblock}

	\addproposal{N2118}{https://wg21.link/N2118}
	\addproposal{n2439}{https://wg21.link/n2439}
	\addproposal{N2844}{https://wg21.link/N2844}
	\addproposal{N3053}{https://wg21.link/N3053}



== Sémantique de déplacement}
	\begin{itemize}
		\item Copie
	\end{itemize}
/*
	\begin{picture}(0,0)(-50,0)
		% Boites
		\put(20,0){\framebox(30,8)[c]{\tiny Vecteur 1}}
		\put(50,0){\framebox(20,8)[c]{\tiny Cap n}}
		\put(70,0){\framebox(20,8)[c]{\tiny Taille m}}

		\put(110,0){\framebox(30,8)[c]{\tiny Vecteur 2}}
		\put(140,0){\framebox(20,8)[c]{\tiny Cap 0}}
		\put(160,0){\framebox(20,8)[c]{\tiny Taille 0}}

		\put(50,-16){\framebox(14,8)[c]{\tiny Obj\textsubscript{1}}}
		\put(64,-16){\framebox(14,8)[c]{\tiny Obj\textsubscript{2}}}
		\put(78,-16){\framebox(14,8)[c]{\tiny ...}}
		\put(92,-16){\framebox(14,8)[c]{\tiny Obj\textsubscript{m}}}

		\put(140,-16){\framebox(14,8)[c]{\tiny $null$}}

		% Fleches
		\put(35,0){\line(0,-1){12}}
		\put(35,-12){\vector(1,0){15}}

		\put(125,0){\line(0,-1){12}}
		\put(125,-12){\vector(1,0){15}}
	\end{picture}
*/
	\addproposal{N2118}{https://wg21.link/N2118}
	\addproposal{n2439}{https://wg21.link/n2439}
	\addproposal{N2844}{https://wg21.link/N2844}
	\addproposal{N3053}{https://wg21.link/N3053}



== Sémantique de déplacement}
	\begin{itemize}
		\item Copie
	\end{itemize}
/*
	\begin{picture}(0,0)(-50,0)
		% Boites
		\put(20,0){\framebox(30,8)[c]{\tiny Vecteur 1}}
		\put(50,0){\framebox(20,8)[c]{\tiny Cap n}}
		\put(70,0){\framebox(20,8)[c]{\tiny Taille m}}

		\put(110,0){\framebox(30,8)[c]{\tiny Vecteur 2}}
		\put(140,0){\framebox(20,8)[c]{\tiny Cap 0}}
		\put(160,0){\framebox(20,8)[c]{\tiny Taille 0}}

		\put(50,-16){\framebox(14,8)[c]{\tiny Obj\textsubscript{1}}}
		\put(64,-16){\framebox(14,8)[c]{\tiny Obj\textsubscript{2}}}
		\put(78,-16){\framebox(14,8)[c]{\tiny ...}}
		\put(92,-16){\framebox(14,8)[c]{\tiny Obj\textsubscript{m}}}

		\put(140,-16){\framebox(14,8)[c]{\tiny $null$}}

		% Fleches
		\put(35,0){\line(0,-1){12}}
		\put(35,-12){\vector(1,0){15}}

		\put(125,0){\line(0,-1){12}}
		\put(125,-12){\vector(1,0){15}}

		% Texte
		\put(0,-25){\tiny \color{teal}Allocation}

		% Boites
		\put(20,-35){\framebox(30,8)[c]{\tiny Vecteur 1}}
		\put(50,-35){\framebox(20,8)[c]{\tiny Cap n}}
		\put(70,-35){\framebox(20,8)[c]{\tiny Taille m}}

		\put(110,-35){\framebox(30,8)[c]{\tiny Vecteur 2}}
		\put(140,-35){\framebox(20,8)[c]{\tiny Cap n}}
		\put(160,-35){\framebox(20,8)[c]{\tiny Taille 0}}

		\put(50,-51){\framebox(14,8)[c]{\tiny Obj\textsubscript{1}}}
		\put(64,-51){\framebox(14,8)[c]{\tiny Obj\textsubscript{2}}}
		\put(78,-51){\framebox(14,8)[c]{\tiny ...}}
		\put(92,-51){\framebox(14,8)[c]{\tiny Obj\textsubscript{m}}}

		\put(140,-51){\framebox(14,8)[c]{\tiny }}
		\put(154,-51){\framebox(14,8)[c]{\tiny }}
		\put(168,-51){\framebox(14,8)[c]{\tiny }}
		\put(182,-51){\framebox(14,8)[c]{\tiny }}

		% Fleches
		\put(35,-35){\line(0,-1){12}}
		\put(35,-47){\vector(1,0){15}}

		\put(125,-35){\line(0,-1){12}}
		\put(125,-47){\vector(1,0){15}}
	\end{picture}
*/
	\addproposal{N2118}{https://wg21.link/N2118}
	\addproposal{n2439}{https://wg21.link/n2439}
	\addproposal{N2844}{https://wg21.link/N2844}
	\addproposal{N3053}{https://wg21.link/N3053}



== Sémantique de déplacement}
	\begin{itemize}
		\item Copie
	\end{itemize}
/*
	\begin{picture}(0,0)(-50,0)
		% Boites
		\put(20,0){\framebox(30,8)[c]{\tiny Vecteur 1}}
		\put(50,0){\framebox(20,8)[c]{\tiny Cap n}}
		\put(70,0){\framebox(20,8)[c]{\tiny Taille m}}

		\put(110,0){\framebox(30,8)[c]{\tiny Vecteur 2}}
		\put(140,0){\framebox(20,8)[c]{\tiny Cap 0}}
		\put(160,0){\framebox(20,8)[c]{\tiny Taille 0}}

		\put(50,-16){\framebox(14,8)[c]{\tiny Obj\textsubscript{1}}}
		\put(64,-16){\framebox(14,8)[c]{\tiny Obj\textsubscript{2}}}
		\put(78,-16){\framebox(14,8)[c]{\tiny ...}}
		\put(92,-16){\framebox(14,8)[c]{\tiny Obj\textsubscript{m}}}

		\put(140,-16){\framebox(14,8)[c]{\tiny $null$}}

		% Fleches
		\put(35,0){\line(0,-1){12}}
		\put(35,-12){\vector(1,0){15}}

		\put(125,0){\line(0,-1){12}}
		\put(125,-12){\vector(1,0){15}}

		% Texte
		\put(0,-25){\tiny \color{teal}Allocation}

		% Boites
		\put(20,-35){\framebox(30,8)[c]{\tiny Vecteur 1}}
		\put(50,-35){\framebox(20,8)[c]{\tiny Cap n}}
		\put(70,-35){\framebox(20,8)[c]{\tiny Taille m}}

		\put(110,-35){\framebox(30,8)[c]{\tiny Vecteur 2}}
		\put(140,-35){\framebox(20,8)[c]{\tiny Cap n}}
		\put(160,-35){\framebox(20,8)[c]{\tiny Taille 0}}

		\put(50,-51){\framebox(14,8)[c]{\tiny Obj\textsubscript{1}}}
		\put(64,-51){\framebox(14,8)[c]{\tiny Obj\textsubscript{2}}}
		\put(78,-51){\framebox(14,8)[c]{\tiny ...}}
		\put(92,-51){\framebox(14,8)[c]{\tiny Obj\textsubscript{m}}}

		\put(140,-51){\framebox(14,8)[c]{\tiny }}
		\put(154,-51){\framebox(14,8)[c]{\tiny }}
		\put(168,-51){\framebox(14,8)[c]{\tiny }}
		\put(182,-51){\framebox(14,8)[c]{\tiny }}

		% Fleches
		\put(35,-35){\line(0,-1){12}}
		\put(35,-47){\vector(1,0){15}}

		\put(125,-35){\line(0,-1){12}}
		\put(125,-47){\vector(1,0){15}}

		% Texte
		\put(0,-60){\tiny \color{teal}Copie des éléments}

		% Boites
		\put(20,-70){\framebox(30,8)[c]{\tiny Vecteur 1}}
		\put(50,-70){\framebox(20,8)[c]{\tiny Cap n}}
		\put(70,-70){\framebox(20,8)[c]{\tiny Taille m}}

		\put(110,-70){\framebox(30,8)[c]{\tiny Vecteur 2}}
		\put(140,-70){\framebox(20,8)[c]{\tiny Cap n}}
		\put(160,-70){\framebox(20,8)[c]{\tiny Taille 1}}

		\put(50,-86){\framebox(14,8)[c]{\tiny Obj\textsubscript{1}}}
		\put(64,-86){\framebox(14,8)[c]{\tiny Obj\textsubscript{2}}}
		\put(78,-86){\framebox(14,8)[c]{\tiny ...}}
		\put(92,-86){\framebox(14,8)[c]{\tiny Obj\textsubscript{m}}}

		\put(140,-86){\framebox(14,8)[c]{\tiny Obj\textsubscript{1}}}
		\put(154,-86){\framebox(14,8)[c]{\tiny }}
		\put(168,-86){\framebox(14,8)[c]{\tiny }}
		\put(182,-86){\framebox(14,8)[c]{\tiny }}

		% Fleches
		\put(35,-70){\line(0,-1){12}}
		\put(35,-82){\vector(1,0){15}}

		\put(125,-70){\line(0,-1){12}}
		\put(125,-82){\vector(1,0){15}}
	\end{picture}
*/
	\addproposal{N2118}{https://wg21.link/N2118}
	\addproposal{n2439}{https://wg21.link/n2439}
	\addproposal{N2844}{https://wg21.link/N2844}
	\addproposal{N3053}{https://wg21.link/N3053}



== Sémantique de déplacement}
	\begin{itemize}
		\item Copie
	\end{itemize}
/*
	\begin{picture}(0,0)(-50,0)
		% Boites
		\put(20,0){\framebox(30,8)[c]{\tiny Vecteur 1}}
		\put(50,0){\framebox(20,8)[c]{\tiny Cap n}}
		\put(70,0){\framebox(20,8)[c]{\tiny Taille m}}

		\put(110,0){\framebox(30,8)[c]{\tiny Vecteur 2}}
		\put(140,0){\framebox(20,8)[c]{\tiny Cap 0}}
		\put(160,0){\framebox(20,8)[c]{\tiny Taille 0}}

		\put(50,-16){\framebox(14,8)[c]{\tiny Obj\textsubscript{1}}}
		\put(64,-16){\framebox(14,8)[c]{\tiny Obj\textsubscript{2}}}
		\put(78,-16){\framebox(14,8)[c]{\tiny ...}}
		\put(92,-16){\framebox(14,8)[c]{\tiny Obj\textsubscript{m}}}

		\put(140,-16){\framebox(14,8)[c]{\tiny $null$}}

		% Fleches
		\put(35,0){\line(0,-1){12}}
		\put(35,-12){\vector(1,0){15}}

		\put(125,0){\line(0,-1){12}}
		\put(125,-12){\vector(1,0){15}}

		% Texte
		\put(0,-25){\tiny \color{teal}Allocation}

		% Boites
		\put(20,-35){\framebox(30,8)[c]{\tiny Vecteur 1}}
		\put(50,-35){\framebox(20,8)[c]{\tiny Cap n}}
		\put(70,-35){\framebox(20,8)[c]{\tiny Taille m}}

		\put(110,-35){\framebox(30,8)[c]{\tiny Vecteur 2}}
		\put(140,-35){\framebox(20,8)[c]{\tiny Cap n}}
		\put(160,-35){\framebox(20,8)[c]{\tiny Taille 0}}

		\put(50,-51){\framebox(14,8)[c]{\tiny Obj\textsubscript{1}}}
		\put(64,-51){\framebox(14,8)[c]{\tiny Obj\textsubscript{2}}}
		\put(78,-51){\framebox(14,8)[c]{\tiny ...}}
		\put(92,-51){\framebox(14,8)[c]{\tiny Obj\textsubscript{m}}}

		\put(140,-51){\framebox(14,8)[c]{\tiny }}
		\put(154,-51){\framebox(14,8)[c]{\tiny }}
		\put(168,-51){\framebox(14,8)[c]{\tiny }}
		\put(182,-51){\framebox(14,8)[c]{\tiny }}

		% Fleches
		\put(35,-35){\line(0,-1){12}}
		\put(35,-47){\vector(1,0){15}}

		\put(125,-35){\line(0,-1){12}}
		\put(125,-47){\vector(1,0){15}}

		% Texte
		\put(0,-60){\tiny \color{teal}Copie des éléments}

		% Boites
		\put(20,-70){\framebox(30,8)[c]{\tiny Vecteur 1}}
		\put(50,-70){\framebox(20,8)[c]{\tiny Cap n}}
		\put(70,-70){\framebox(20,8)[c]{\tiny Taille m}}

		\put(110,-70){\framebox(30,8)[c]{\tiny Vecteur 2}}
		\put(140,-70){\framebox(20,8)[c]{\tiny Cap n}}
		\put(160,-70){\framebox(20,8)[c]{\tiny Taille 1}}

		\put(50,-86){\framebox(14,8)[c]{\tiny Obj\textsubscript{1}}}
		\put(64,-86){\framebox(14,8)[c]{\tiny Obj\textsubscript{2}}}
		\put(78,-86){\framebox(14,8)[c]{\tiny ...}}
		\put(92,-86){\framebox(14,8)[c]{\tiny Obj\textsubscript{m}}}

		\put(140,-86){\framebox(14,8)[c]{\tiny Obj\textsubscript{1}}}
		\put(154,-86){\framebox(14,8)[c]{\tiny }}
		\put(168,-86){\framebox(14,8)[c]{\tiny }}
		\put(182,-86){\framebox(14,8)[c]{\tiny }}

		% Fleches
		\put(35,-70){\line(0,-1){12}}
		\put(35,-82){\vector(1,0){15}}

		\put(125,-70){\line(0,-1){12}}
		\put(125,-82){\vector(1,0){15}}

		% Texte
		\put(107,-100){...}

		% Boites
		\put(20,-114){\framebox(30,8)[c]{\tiny Vecteur 1}}
		\put(50,-114){\framebox(20,8)[c]{\tiny Cap n}}
		\put(70,-114){\framebox(20,8)[c]{\tiny Taille m}}

		\put(110,-114){\framebox(30,8)[c]{\tiny Vecteur 2}}
		\put(140,-114){\framebox(20,8)[c]{\tiny Cap n}}
		\put(160,-114){\framebox(20,8)[c]{\tiny Taille m}}

		\put(50,-130){\framebox(14,8)[c]{\tiny Obj\textsubscript{1}}}
		\put(64,-130){\framebox(14,8)[c]{\tiny Obj\textsubscript{2}}}
		\put(78,-130){\framebox(14,8)[c]{\tiny ...}}
		\put(92,-130){\framebox(14,8)[c]{\tiny Obj\textsubscript{m}}}

		\put(140,-130){\framebox(14,8)[c]{\tiny Obj\textsubscript{1}}}
		\put(154,-130){\framebox(14,8)[c]{\tiny Obj\textsubscript{2}}}
		\put(168,-130){\framebox(14,8)[c]{\tiny ...}}
		\put(182,-130){\framebox(14,8)[c]{\tiny Obj\textsubscript{m}}}

		% Fleches
		\put(35,-114){\line(0,-1){12}}
		\put(35,-126){\vector(1,0){15}}

		\put(125,-114){\line(0,-1){12}}
		\put(125,-126){\vector(1,0){15}}
	\end{picture}
*/
	\addproposal{N2118}{https://wg21.link/N2118}
	\addproposal{n2439}{https://wg21.link/n2439}
	\addproposal{N2844}{https://wg21.link/N2844}
	\addproposal{N3053}{https://wg21.link/N3053}



== Sémantique de déplacement}
	\begin{itemize}
		\item Déplacement
	\end{itemize}
/*
	\begin{picture}(0,0)(-50,0)
		% Boites
		\put(20,0){\framebox(30,8)[c]{\tiny Vecteur 1}}
		\put(50,0){\framebox(20,8)[c]{\tiny Cap n}}
		\put(70,0){\framebox(20,8)[c]{\tiny Taille m}}

		\put(110,0){\framebox(30,8)[c]{\tiny Vecteur 2}}
		\put(140,0){\framebox(20,8)[c]{\tiny Cap 0}}
		\put(160,0){\framebox(20,8)[c]{\tiny Taille 0}}

		\put(50,-16){\framebox(14,8)[c]{\tiny Obj\textsubscript{1}}}
		\put(64,-16){\framebox(14,8)[c]{\tiny Obj\textsubscript{2}}}
		\put(78,-16){\framebox(14,8)[c]{\tiny ...}}
		\put(92,-16){\framebox(14,8)[c]{\tiny Obj\textsubscript{m}}}

		\put(140,-16){\framebox(14,8)[c]{\tiny $null$}}

		% Fleches
		\put(35,0){\line(0,-1){12}}
		\put(35,-12){\vector(1,0){15}}

		\put(125,0){\line(0,-1){12}}
		\put(125,-12){\vector(1,0){15}}
	\end{picture}
*/
	\addproposal{N2118}{https://wg21.link/N2118}
	\addproposal{n2439}{https://wg21.link/n2439}
	\addproposal{N2844}{https://wg21.link/N2844}
	\addproposal{N3053}{https://wg21.link/N3053}



== Sémantique de déplacement}
	\begin{itemize}
		\item Déplacement
	\end{itemize}
/*
	\begin{picture}(0,0)(-50,0)
		% Boites
		\put(20,0){\framebox(30,8)[c]{\tiny Vecteur 1}}
		\put(50,0){\framebox(20,8)[c]{\tiny Cap n}}
		\put(70,0){\framebox(20,8)[c]{\tiny Taille m}}

		\put(110,0){\framebox(30,8)[c]{\tiny Vecteur 2}}
		\put(140,0){\framebox(20,8)[c]{\tiny Cap 0}}
		\put(160,0){\framebox(20,8)[c]{\tiny Taille 0}}

		\put(50,-16){\framebox(14,8)[c]{\tiny Obj\textsubscript{1}}}
		\put(64,-16){\framebox(14,8)[c]{\tiny Obj\textsubscript{2}}}
		\put(78,-16){\framebox(14,8)[c]{\tiny ...}}
		\put(92,-16){\framebox(14,8)[c]{\tiny Obj\textsubscript{m}}}

		\put(140,-16){\framebox(14,8)[c]{\tiny $null$}}

		% Fleches
		\put(35,0){\line(0,-1){12}}
		\put(35,-12){\vector(1,0){15}}

		\put(125,0){\line(0,-1){12}}
		\put(125,-12){\vector(1,0){15}}

		% Texte
		\put(0,-25){\tiny \color{teal}Permutation}

		% Boites
		\put(20,-35){\framebox(30,8)[c]{\tiny Vecteur 1}}
		\put(50,-35){\framebox(20,8)[c]{\tiny Cap 0}}
		\put(70,-35){\framebox(20,8)[c]{\tiny Taille 0}}

		\put(110,-35){\framebox(30,8)[c]{\tiny Vecteur 2}}
		\put(140,-35){\framebox(20,8)[c]{\tiny Cap n}}
		\put(160,-35){\framebox(20,8)[c]{\tiny Taille m}}

		\put(50,-51){\framebox(14,8)[c]{\tiny Obj\textsubscript{1}}}
		\put(64,-51){\framebox(14,8)[c]{\tiny Obj\textsubscript{2}}}
		\put(78,-51){\framebox(14,8)[c]{\tiny ...}}
		\put(92,-51){\framebox(14,8)[c]{\tiny Obj\textsubscript{m}}}

		\put(140,-51){\framebox(14,8)[c]{\tiny $null$}}

		% Fleches
		\put(35,-35){\line(0,-1){20}}
		\put(35,-55){\line(1,0){95}}
		\put(130,-55){\line(0,1){8}}
		\put(130,-47){\vector(1,0){10}}

		\put(125,-35){\line(0,-1){4}}
		\put(125,-39){\line(-1,0){85}}
		\put(40,-39){\line(0,-1){8}}
		\put(40,-47){\vector(1,0){10}}
	\end{picture}
*/
	\addproposal{N2118}{https://wg21.link/N2118}
	\addproposal{n2439}{https://wg21.link/n2439}
	\addproposal{N2844}{https://wg21.link/N2844}
	\addproposal{N3053}{https://wg21.link/N3053}



== Sémantique de déplacement}
	\begin{itemize}
		\item \textit{rvalue reference}
		\begin{itemize}
			\item Référence sur un objet temporaire ou sur le point d'être détruit
			\item Noté par une double esperluette : ```cpp T&& value```
		\end{itemize}
		\item Deux fonctions de conversion
		\begin{itemize}
			\item ```cpp std::move()``` convertit le paramètre en \textit{rvalue}

\note[item]{```cpp std::move()``` force la sémantique de déplacement sur l'objet}

			\item ```cpp std::forward()``` convertit le paramètre en \textit{rvalue} s'il n'est pas une \textit{lvalue reference}
		\end{itemize}
	\end{itemize}

	\begin{block}{\textit{rvalue}, \textit{lvalue}, \ldots{} ?}
		\begin{itemize}
			\item Voir \href{http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2012/n3337.pdf}{N3337\linklogo} §3.10
		\end{itemize}
	\end{block}

	\begin{block}{\mintinline[style=white]{cpp}```std::forward()``` ?}
		\begin{itemize}
			\item \textit{perfect forwarding} (Voir \href{http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2002/n1385.htm}{N1385\linklogo})
		\end{itemize}
	\end{block}

	\addproposal{N2118}{https://wg21.link/N2118}
	\addproposal{n2439}{https://wg21.link/n2439}
	\addproposal{N2844}{https://wg21.link/N2844}
	\addproposal{N3053}{https://wg21.link/N3053}



== Sémantique de déplacement}
	\begin{itemize}
		\item Rendre une classe déplaçable
		\begin{itemize}
			\item Constructeur par déplacement ```cpp T(const T&&)```
			\item Opérateur d'affectation par déplacement ```cpp T& operator=(const T&&)```
		\end{itemize}
	\end{itemize}

	\begin{block}{Génération implicite}
		\begin{itemize}
			\item Pas de constructeur par copie, d'opérateur d'affectation, de destructeur, ni l'autre déplacement \textit{user-declared}
		\end{itemize}
	\end{block}

	\begin{alertblock}{\textit{user-declared} ? \textit{user-provided} ?}
		\begin{itemize}
			\item \textit{user-declared} : fonction déclarée par l'utilisateur, y compris ```cpp =default```
			\item \textit{user-provided} : corps de la fonction fourni par l'utilisateur
		\end{itemize}
	\end{alertblock}

	\addproposal{N2118}{https://wg21.link/N2118}
	\addproposal{n2439}{https://wg21.link/n2439}
	\addproposal{N2844}{https://wg21.link/N2844}
	\addproposal{N3053}{https://wg21.link/N3053}



== Sémantique de déplacement}
	\begin{block}{\textit{Rule of five}}
		\begin{itemize}
			\item Si une classe déclare destructeur, constructeur par copie ou par déplacement, affectation par copie ou par déplacement, alors elle doit définir les cinq

\note[item]{Contrairement à \textit{Rule of three}, l'absence des constructeur et opérateur d'affectation par déplacement n'est pas une erreur grave, mais une optimisation manquée}
		\end{itemize}
	\end{block}

	\begin{block}{\textit{Rule of zero}}
		\begin{itemize}
			\item Lorsque c'est possible, n'en définissez aucune

\note[item]{\textit{Rule of zero} s'applique typiquement aux classes sans gestion explicite d'\textit{ownership}, c'est à dire sans membres qu'il faut explicitement libérés, fermés, \ldots{}. Ce qui devrait être le cas par défaut}
		\end{itemize}
	\end{block}

	\begin{block}{Pour aller plus loin}
		\begin{itemize}
			\item Voir \href{https://github.com/cppp-france/CPPP-19/blob/master/elegance_style_epure_et_classe-Loic_Joly/elegance_style_epure_et_classe-Loic_Joly.pdf}{Élégance, style épuré et classe\linklogo (Loïc Joly)}
		\end{itemize}
	\end{block}

	\addproposal{N2118}{https://wg21.link/N2118}
	\addproposal{n2439}{https://wg21.link/n2439}
	\addproposal{N2844}{https://wg21.link/N2844}
	\addproposal{N3053}{https://wg21.link/N3053}



== Sémantique de déplacement}
	\begin{block}{Dans la bibliothèque standard}
		\begin{itemize}
			\item Nombreuses classes standards déplaçables (thread, flux, \ldots{})

\note[item]{Mutex et lock ne sont pas copiables ni déplaçables}

			\item Évolution de contraintes : déplaçable plutôt que copiable

\note[item]{Évolution des contraintes notamment pour les conteneurs et les algorithmes}

			\item Implémentations utilisant le déplacement si possible
		\end{itemize}
	\end{block}

	\addproposal{N2118}{https://wg21.link/N2118}
	\addproposal{n2439}{https://wg21.link/n2439}
	\addproposal{N2844}{https://wg21.link/N2844}
	\addproposal{N3053}{https://wg21.link/N3053}



== Initializer list}
	\begin{itemize}
		\item Initialisation des conteneurs
	\end{itemize}

	```cpp
		vector<int> foo;
		foo.push_back(1);
		foo.push_back(56);
		foo.push_back(18);
		foo.push_back(3);

		// Devient

		vector<int> foo{1, 56, 18, 3};
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B1,+56,+18,+3%7D%3B%0A%0A++std::cout+%3C%3C+foo.size()+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{N2672}{https://wg21.link/N2672}



== Initializer list}
	\begin{itemize}
		\item Classe ```cpp std::initializer_list``` pour accéder aux valeurs de la liste
	\end{itemize}

	\begin{alertblock}{Accéder, pas contenir !}
		\begin{itemize}
			\item ```cpp std::initializer_list``` référence mais ne contient pas les valeurs
			\item Valeurs contenues dans un tableau temporaire de même durée de vie
			\item Copier un ```cpp std::initializer_list``` ne copie pas les données
		\end{itemize}
	\end{alertblock}

	\begin{itemize}
		\item Fonctions membres ```cpp size()```, ```cpp begin()```, ```cpp end()```
		\item Construction automatique depuis une liste de valeurs entre accolades
	\end{itemize}

	\addproposal{N2672}{https://wg21.link/N2672}



== Initializer list}
	\begin{itemize}
		\item Constructeurs peuvent prendre un ```cpp std::initializer_list``` en paramètre
	\end{itemize}

	```cpp
		MaClasse(initializer_list<value_type> itemList);
	```

	\begin{itemize}
		\item Ainsi que toute autre fonction
		\item Intégré aux conteneurs de la bibliothèque standard
	\end{itemize}

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cinitializer_list%3E%0A%0Astruct+Foo%0A%7B%0A++Foo(std::initializer_list%3Cint%3E+l)+:+m_vec(l)%0A++%7B%0A++++std::cout+%3C%3C+l.size()+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0A++void+append(std::initializer_list%3Cint%3E+l)%0A++%7B%0A++++for(std::initializer_list%3Cint%3E::iterator+it+%3D+l.begin()%3B+it+!!%3D+l.end()%3B+%2B%2Bit)%0A++++%7B%0A++++++m_vec.push_back(*it)%3B%0A++++%7D%0A++%7D%0A%0A++std::vector%3Cint%3E+m_vec%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++Foo+foo+%3D+%7B1,+2,+3,+4,+5%7D%3B%0A++for(size_t+i+%3D+0%3B+i+%3C+foo.m_vec.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+foo.m_vec%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%0A++foo.append(%7B6,+7,+8%7D)%3B%0A++for(size_t+i+%3D+0%3B+i+%3C+foo.m_vec.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+foo.m_vec%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{N2672}{https://wg21.link/N2672}



\frametitle{Initializer list}
	\begin{exampleblock}{Do}
		\begin{itemize}
			\item Préférez ```cpp std::initializer_list``` aux insertions successives
		\end{itemize}
	\end{exampleblock}

	\begin{alertblock}{Don't}
		\begin{itemize}
			\item N'utilisez pas ```cpp std::initializer_list``` pour copier ou transformer
			\item Utilisez les algorithmes et constructeurs idoines
		\end{itemize}
	\end{alertblock}



== Uniform Initialization}
	\begin{itemize}
		\item Plusieurs types d'initialisation en C++98/03
	\end{itemize}

	```cpp
		int a = 2;
		int b(2);
		int c[] = {1, 2, 3};
		int d;
	```



== Uniform Initialization}
	\begin{itemize}
		\item Mais aucune de générique
	\end{itemize}

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

\note[item]{L'initialisation de ```cpp Foo``` fonctionne car c'est un POD (pas de classe de base, pas de virtuel, etc.)}



== Uniform Initialization}
	\begin{itemize}
		\item En C++ 11, l'initialisation via ```cpp {}``` est générique
	\end{itemize}

	```cpp
		int a[] = {1, 2, 3};         // OK
		Foo b = {5};                 // OK
		vector<int> c = {1, 2, 3};   // OK
		int d = {8};                 // OK
		int e = {};                  // OK
	```

	\begin{itemize}
		\item Avec ou sans ```cpp =```
	\end{itemize}

	```cpp
		int a[]{1, 2, 3};            // OK
		Foo b{5};                    // OK
		vector<int> c{1, 2, 3};      // OK
		int d{8};                    // OK
		int e{};                     // OK
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Astruct+Foo+%0A%7B%0A++int+foo%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++int+a%5B%5D+%3D+%7B1,+2,+3%7D%3B%0A++Foo+b+%3D+%7B5%7D%3B%0A++std::vector%3Cint%3E+c+%3D+%7B1,+2,+3%7D%3B%0A++int+d%7B8%7D%3B%0A++int+e%7B%7D%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra+-Wno-unused-variable+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== Uniform Initialization}
	\begin{itemize}
		\item Dans différents contextes
	\end{itemize}

	```cpp
		int* p = new int{4};
		long l = long{2};

		void f(int);
		f({2});
	```



== Uniform Initialization}
	\begin{alertblock}{Attention}
		\begin{itemize}
			\item Pas de troncature avec ```cpp {}```
		\end{itemize}

		```cpp
			int foo{2.5};  // Erreur
		```
	\end{alertblock}

	\begin{alertblock}{Attention}
		\begin{itemize}
			\item Si le constructeur par ```cpp std::initializer_list``` existe, il est utilisé
		\end{itemize}

		```cpp
			vector<int> foo{2};  // 2
			vector<int> foo(2);  // 0 0
		```
	\end{alertblock}



== Uniform Initialization}
	\begin{alertblock}{Contraintes sur l'initialisation d'agrégats}
		\begin{itemize}
			\item Pas d'héritage
			\item Pas de constructeur fourni par l'utilisateur
			\item Pas d'initialisation \textit{brace-or-equal-initializers}
			\item Pas de fonction virtuelle ni de membre non statique protégé ou privé
		\end{itemize}
	\end{alertblock}

	\begin{exampleblock}{Do}
		\begin{itemize}
			\item Préférez l'initialisation ```cpp {}``` aux autres formes
		\end{itemize}
	\end{exampleblock}



== \mintinline[style=white]{cpp}```auto```}
	\begin{itemize}
		\item Déduction (ou inférence) de type depuis l'initialisation
	\end{itemize}

	\begin{alertblock}{Attention}
		\begin{itemize}
			\item Inférence de type $\neq$ typage dynamique
			\item Inférence de type $\neq$ typage faible
			\item Typage dynamique $\neq$ typage faible
		\end{itemize}
	\end{alertblock}

	\begin{block}{Vocabulaire}
		\begin{itemize}
			\item Statique : type porté par la variable et ne varie pas
			\item Dynamique : type porté par la valeur
			\item Absence : variable non typée, type imposé par l'opération
		\end{itemize}
	\end{block}

	\addproposal{N1984}{https://wg21.link/N1984}
	\addproposal{n1737}{https://wg21.link/n1737}
	\addproposal{n2546}{https://wg21.link/n2546}



== \mintinline[style=white]{cpp}```auto```}
	\begin{itemize}
		\item ```cpp auto``` définit une variable dont le type est déduit
	\end{itemize}

	```cpp
		auto i = 2;  // int
	```

	\begin{itemize}
		\item Règles de déduction proches de celles des templates
		\item Listes entre accolades inférées comme des ```cpp std::initializer_list```
	\end{itemize}

	\begin{alertblock}{Attention}
		\begin{itemize}
			\item Référence, ```cpp const``` et ```cpp volatile``` perdus durant la déduction
		\end{itemize}

		```cpp
			const int i = 2;
			auto j = i;  // int
		```
	\end{alertblock}

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ctypeinfo%3E%0A%23include+%3Ccassert%3E%0A%0Aint+main()%0A%7B%0A++auto+i+%3D+2%3B+%0A++assert(typeid(i)+%3D%3D+typeid(int))%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{N1984}{https://wg21.link/N1984}
	\addproposal{n1737}{https://wg21.link/n1737}
	\addproposal{n2546}{https://wg21.link/n2546}



== \mintinline[style=white]{cpp}```auto```}
	\begin{itemize}
		\item Combinaison possible avec ```cpp const```, ```cpp volatile``` ou ```cpp &```
	\end{itemize}

	```cpp
		const auto i = 2;

		int j = 3;
		auto& k = j;
	```

	\begin{itemize}
		\item Typer explicitement l'initialiseur permet de forcer le type déduit
	\end{itemize}

	```cpp
		// unsigned long
		auto i = static_cast<unsigned long>(2);
		auto j = 2UL
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ctypeinfo%3E%0A%23include+%3Ccassert%3E%0A%0Aint+main()%0A%7B%0A++auto+i+%3D+static_cast%3Cunsigned+long%3E(2)%3B%0A++assert(typeid(i)+%3D%3D+typeid(unsigned+long))%3B%0A++%0A++auto+j+%3D+2UL%3B%0A++assert(typeid(j)+%3D%3D+typeid(unsigned+long))%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{N1984}{https://wg21.link/N1984}
	\addproposal{n1737}{https://wg21.link/n1737}
	\addproposal{n2546}{https://wg21.link/n2546}



== \mintinline[style=white]{cpp}```auto```}
	\begin{itemize}
		\item Tendance forte \textit{Almost Always Auto} (AAA)
	\end{itemize}

	\begin{block}{Pour aller plus loin}
		\begin{itemize}
			\item Voir \href{https://herbsutter.com/2013/08/12/gotw-94-solution-aaa-style-almost-always-auto/}{GotW 94 : AAA Style\linklogo}
		\end{itemize}
	\end{block}

	\begin{itemize}
		\item Plusieurs avantages
		\begin{itemize}
			\item Variables forcément initialisées
			\item Typage correct et précis
			\item Garanties conservées au fil des corrections et refactoring
			\item Généricité et simplification du code
		\end{itemize}
	\end{itemize}

	\pause

	\begin{block}{Quiz}
		\begin{itemize}
			\item Type de retour de ```cpp std::list<std::string>::size()``` ?
		\end{itemize}
	\end{block}



== \mintinline[style=white]{cpp}```auto```}
	\begin{itemize}
		\item Limitations - solutions
		\begin{itemize}
			\item Erreur de déduction - typage explicite de l'initialiseur
			\item Initialisation impossible - ```cpp decltype```
			\item Interfaces, rôles, contexte - concepts ?

\note[item]{Mais il faut attendre C++20 pour avoir les concepts}
		\end{itemize}
	\end{itemize}

	\begin{alertblock}{Compatibilité}
		\begin{itemize}
			\item ```cpp auto``` présent en C++98/03 avec un sens radicalement différent
		\end{itemize}

\note[item]{Sens en C++98/03 : variable de type automatique (c'est à dire sur la pile) par opposition à statique (cas par défaut et donc inutilisé en pratique)}
	\end{alertblock}



== \mintinline[style=white]{cpp}```decltype```}
	\begin{itemize}
		\item Déduction du type d'une variable ou d'une expression
		\item Permet donc la création d'une variable du même type
	\end{itemize}

	```cpp
		int a;
		long b;

		decltype(a) c;         // int
		decltype(a + b) d;     // long
	```

	\begin{itemize}
		\item Généralement, déduction sans aucune modification du type

\note[item]{Donc conservation des références, ```cpp const```, etc.}

		\item Depuis une \textit{lvalue} de type ```cpp T``` autre qu'un nom de variable : ```cpp T&```
	\end{itemize}

	```cpp
		decltype( (a) ) e;     // int&
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ctypeinfo%3E%0A%23include+%3Ccassert%3E%0A%0Aint+main()%0A%7B%0A++int+a%3B%0A++long+b%3B%0A%0A++decltype+(a)+c%3B%0A++decltype+(a+%2B+b)+d%3B%0A%0A++assert(typeid(c)+%3D%3D+typeid(int))%3B%0A++assert(typeid(d)+%3D%3D+typeid(long))%3B%0A%0A%23if+0%0A++decltype(+(a)+)+e%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{N2343}{https://wg21.link/N2343}
	\addproposal{N3276}{https://wg21.link/N3276}



== \mintinline[style=white]{cpp}```declval```}
	\begin{itemize}
		\item Utilisation de fonctions membres dans ```cpp decltype``` sans instance
		\item Typiquement sur des templates acceptant des types sans constructeur commun mais avec une fonction membre commune
	\end{itemize}

	```cpp
		struct foo {
		  foo(const foo&) {}
		  int bar () const { return 1; }
		};

		decltype(foo().bar()) a = 5;               // Erreur
		decltype(std::declval<foo>().bar()) b = 5; // OK, int
	```

	\begin{alertblock}{Attention}
		\begin{itemize}
			\item Uniquement dans des contextes non évalués
		\end{itemize}
	\end{alertblock}

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Cutility%3E%0A%23include+%3Ctypeinfo%3E%0A%23include+%3Ccassert%3E%0A%0Astruct+foo%0A%7B%0A++foo(const+foo%26)+%7B%7D%0A++int+bar()+const+%7B+return+1%3B+%7D%0A%7D%3B%0A%0Aint+main()%0A%7B%0A%23if+0%0A++decltype(foo().bar())+a+%3D+5%3B%0A%23endif%0A++decltype(std::declval%3Cfoo%3E().bar())+b+%3D+5%3B%0A%0A++assert(typeid(b)+%3D%3D+typeid(int))%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== Déduction du type retour}
	\begin{itemize}
		\item Combinaison de ```cpp auto``` et ```cpp decltype```
	\end{itemize}

	```cpp
		auto add(int a, int b) -> decltype(a + b) {
		  return a + b;
		}
	```

	\begin{itemize}
		\item Particulièrement utiles pour des fonctions templates
	\end{itemize}

	\begin{block}{Quiz : \mintinline[style=white]{cpp}```T```, \mintinline[style=white]{cpp}```U``` ou autre ?}
		```cpp
			template<typename T, typename U> ??? add(T a, U b) {
			  return a + b;
			}
		```
	\end{block}

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Cutility%3E%0A%23include+%3Ctypeinfo%3E%0A%23include+%3Ccassert%3E%0A%0Aauto+add(int+a,+int+b)+-%3E+decltype(a+%2B+b)+%0A%7B%0A++return+a+%2B+b%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++auto+i+%3D+add(1,+3)%3B%0A++assert(typeid(i)+%3D%3D+typeid(int))%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{n2541}{https://wg21.link/n2541}



== Déduction du type retour}
	\begin{block}{Solution}
		\begin{itemize}
			\item Pas de bonne réponse en typage explicite

\note[item]{Une solution historique : un seul type template et on compte sur les conversions implicites voire on demande des conversions explicites}

			\item Mais l'inférence de type vient à notre secours
		\end{itemize}
	\end{block}

	```cpp
		template<typename T, typename U>
		auto add(T a, U b) -> decltype(a + b) {
		  return a + b;
		}
	```

	\begin{exampleblock}{do}
		\begin{itemize}
			\item Utilisez la déduction du type retour dans vos fonctions templates
		\end{itemize}
	\end{exampleblock}

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Cutility%3E%0A%23include+%3Ctypeinfo%3E%0A%23include+%3Ccassert%3E%0A%0Atemplate%3Ctypename+T,+typename+U%3E%0Aauto+add(T+a,+U+b)+-%3E+decltype(a+%2B+b)%0A%7B%0A++return+a+%2B+b%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++auto+i+%3D+add(1UL,+3)%3B%0A++assert(typeid(i)+%3D%3D+typeid(unsigned+long))%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{n2541}{https://wg21.link/n2541}



== \mintinline[style=white]{cpp}```std::array```}
	\begin{itemize}
		\item ```cpp std::array```
		\begin{itemize}
			\item Tableau de taille fixe connue à la compilation
			\item Éléments contigus
			\item Accès indexé
		\end{itemize}
	\end{itemize}

	```cpp
		array<int, 8> foo{2, 5, 9, 8, 2, 6, 8, 9};

		accumulate(foo.begin(), foo.end(), 0); // 49
	```

	```cpp
		array<int, 8> foo{2, 5, 9, 8, 2, 6, 8, 9, 17};
		// Erreur de compilation
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Carray%3E%0A%23include+%3Cnumeric%3E%0A%0Aint+main()%0A%7B%0A++std::array%3Cint,+8%3E+foo%7B2,+5,+9,+8,+2,+6,+8,+9,+17%7D%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Carray%3E%0A%23include+%3Cnumeric%3E%0A%0Aint+main()%0A%7B%0A++std::array%3Cint,+8%3E+foo%7B2,+5,+9,+8,+2,+6,+8,+9%7D%3B%0A++std::cout+%3C%3C+std::accumulate(foo.begin(),+foo.end(),+0)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{n1836}{https://wg21.link/n1836}



== \mintinline[style=white]{cpp}```std::array```}
	\begin{itemize}
		\item[]\begin{itemize}
			\item Vérification des index à la compilation
		\end{itemize}
	\end{itemize}

	```cpp
		array<int, 8> foo{2, 5, 9, 8, 2, 6, 8, 9};

		get<2>(foo);  // 9
		get<8>(foo);  // Erreur de compilation
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Carray%3E%0A%0Aint+main()%0A%7B%0A++std::array%3Cint,+8%3E+foo%7B2,+5,+9,+8,+2,+6,+8,+9%7D%3B%0A++std::cout+%3C%3C+std::get%3C2%3E(foo)+%3C%3C+!'%5Cn!'%3B%0A%23if+0%0A++std::cout+%3C%3C+std::get%3C8%3E(foo)+%3C%3C+!'%5Cn!'%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{n1836}{https://wg21.link/n1836}



\frametitle{\mintinline[style=white]{cpp}```std::forward_list```}
	\begin{itemize}
		\item Liste simplement chaînée ```cpp std::forward_list```
	\end{itemize}

	```cpp
		forward_list<int> foo{2, 5, 9, 8, 2, 6, 8, 9, 12};

		accumulate(foo.begin(), foo.end(), 0); // 61
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cforward_list%3E%0A%23include+%3Cnumeric%3E%0A%0Aint+main()%0A%7B%0A++std::forward_list%3Cint%3E+foo%7B2,+5,+9,+8,+2,+6,+8,+9,+12%7D%3B%0A%0A++std::cout+%3C%3C+std::accumulate(foo.begin(),+foo.end(),+0)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== Conteneurs associatifs}
	\begin{itemize}
		\item Conteneurs associatifs sous forme de tables de hachage
		\begin{itemize}
			\item ```cpp std::unordered_map```
			\item ```cpp std::unordered_multimap```
			\item ```cpp std::unordered_set```
			\item ```cpp std::unordered_multiset```
		\end{itemize}
		\item Versions non ordonnées de ```cpp std::map```, ```cpp std::set```, \ldots{}
	\end{itemize}

	\begin{block}{\mintinline[style=white]{cpp}```unordered_<XXX>``` ?}
		\begin{itemize}
			\item Nombreuses implémentations ```cpp hash_<XXX>``` existantes
			\item Structures fondamentalement non ordonnées
		\end{itemize}
	\end{block}

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%23include+%3Cunordered_map%3E%0A%0Aint+main()%0A%7B%0A++std::unordered_map%3Cint,+std::string%3E+foo%7B%7B5,+%22Une+chaine%22%7D,+%7B42,+%22La+reponse%22%7D%7D%3B%0A%0A++std::cout+%3C%3C++foo%5B42%5D+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{n1836}{https://wg21.link/n1836}



== \mintinline[style=white]{cpp}```shrink_to_fit()```}
	\begin{itemize}
		\item ```cpp shrink_to_fit()``` réduit la capacité des ```cpp std::vector```, ```cpp std::deque``` et ```cpp std::string``` à leur taille
	\end{itemize}

\note[item]{Pour être précis, ce n'est pas nécessairement exactement à la taille ça peut être plus grand - à la discrétion de l'implémentation (performances, cohérence, \ldots{}) -, mais l'idée est là}

	```cpp
		vector<int> foo{12, 25};

		foo.reserve(15);      // Taille : 2, capacite : 15
		foo.shrink_to_fit();  // Taille : 2, capacite : 2
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B12,+25%7D%3B%0A++foo.reserve(15)%3B%0A++std::cout+%3C%3C+foo.size()+%3C%3C+%22+/+%22+%3C%3C+foo.capacity()+%3C%3C+!'%5Cn!'%3B%0A%0A++foo.shrink_to_fit()%3B%0A++std::cout+%3C%3C+foo.size()+%3C%3C+%22+/+%22+%3C%3C+foo.capacity()+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== \mintinline[style=white]{cpp}```data()```}
	\begin{itemize}
		\item ```cpp data()``` récupère le \og tableau C\fg{} d'un ```cpp std::vector```
	\end{itemize}

	\begin{block}{\mintinline[style=white]{cpp}```foo.data()``` ou \mintinline[style=white]{cpp}```&foo[0]``` ?}
		\begin{itemize}
			\item Comportement identique
			\item Préférez ```cpp foo.data()``` sémantiquement plus clair
		\end{itemize}
	\end{block}

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Avoid+bar(const+int*+data,+const+size_t+size)%0A%7B%0A++for(size_t+i+%3D+0%3B+i+%3C+size%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+data%5Bi%5D+%3C%3C+%22%5Cn%22%3B%0A++%7D%0A%7D%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B12,+25%7D%3B%0A%0A++bar(foo.data(),+foo.size())%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== \mintinline[style=white]{cpp}```emplace()```}
	\begin{itemize}
		\item ```cpp emplace()```, ```cpp emplace_back()``` et ```cpp emplace_front()``` construisent dans le conteneur depuis les paramètres d'un des constructeurs de l'élément
	\end{itemize}

	```cpp
		class Point {
		public:
		  Point(int a, int b);
		};

		vector<Point> foo;
		foo.emplace_back(2, 5);
	```

	\begin{block}{Objectif}
		\begin{itemize}
			\item Éliminer des copies inutiles et gagner en performance
		\end{itemize}
	\end{block}

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Aclass+Point+%0A%7B%0Apublic:%0A++Point(int+a,+int+b)%0A++++:+m_a(a)%0A++++,+m_b(b)%0A++%7B%0A++%7D%0A%0A++int+m_a%3B%0A++int+m_b%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++std::vector%3CPoint%3E+foo%3B%0A++foo.emplace_back(2,+5)%3B%0A%0A++std::cout+%3C%3C+foo%5B0%5D.m_a+%3C%3C+%22+%22+%3C%3C+foo%5B0%5D.m_b+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== \mintinline[style=white]{cpp}```std::string```}
	\begin{itemize}
		\item Évolutions de ```cpp std::string```
		\begin{itemize}
			\item Éléments obligatoirement contigus
			\item ```cpp data()``` retourne une chaîne C valide (synonyme à ```cpp c_str()```)

\note[item]{En C++98, ```cpp data()``` renvoyait les caractères de la chaîne mais pas nécessairement sous forme d'une chaîne C valide (pas obligatoirement de 0 terminal)}

			\item ```cpp front()``` retourne le premier caractère d'une chaîne
			\item ```cpp back()``` retourne le dernier caractère d'une chaîne
			\item ```cpp pop_back()``` supprime le dernier caractère d'une chaîne
			\item Interdiction du \textit{Copy-on-Write}
		\end{itemize}
	\end{itemize}



== \mintinline[style=white]{cpp}```std::bitset```}
	\begin{itemize}
		\item Évolutions de ```cpp std::bitset```
		\begin{itemize}
			\item ```cpp all()``` teste si tous les bits sont levés
			\item ```cpp to_ullong()``` convertit en ```cpp unsigned long long```
		\end{itemize}
	\end{itemize}

	```cpp
		bitset<5> foo;
		foo.all();        // False

		foo.set(2);
		foo.to_ullong();  // 4

		foo.set();
		foo.all();        // True
		foo.to_ullong();  // 31
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cbitset%3E%0A%0Aint+main()%0A%7B%0A++std::bitset%3C5%3E+foo%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+foo.all()+%3C%3C+!'%5Cn!'%3B%0A%0A++foo.set(2)%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+foo.all()+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+foo.to_ullong()+%3C%3C+!'%5Cn!'%3B%0A%0A++foo.set()%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+foo.all()+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+foo.to_ullong()+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== Conteneurs - Choix}
	\begin{exampleblock}{Do}
		\begin{itemize}
			\item Préférez ```cpp std::array``` lorsque la taille est fixe et connue
			\item Sinon préférez ```cpp std::vector```
		\end{itemize}
	\end{exampleblock}


== Itérateurs}
	\begin{itemize}
		\item Fonctions membres ```cpp cbegin()```, ```cpp cend()```, ```cpp crbegin()``` et ```cpp crend()``` retournant des ```cpp const_iterator```

\note[item]{Les fonctions ```cpp begin()```, ```cpp end()```, etc. retournent des ```cpp const_iterator``` si le conteneur est ```cpp const```, des ```cpp iterator``` dans le cas contraire}

		\item Fonctions libres ```cpp std::begin()``` et ```cpp std::end()```
		\begin{itemize}
			\item Conteneur : appel des fonctions membres
			\item Tableau C : adresse du premier élément et suivant le dernier élément
		\end{itemize}
	\end{itemize}

	```cpp
		int foo[] = {1, 2, 3, 4};
		vector<int> bar{2, 3, 4, 5};

		accumulate(begin(foo), end(foo), 0);  // 10
		accumulate(begin(bar), end(bar), 0);  // 14
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cnumeric%3E%0A%0Ausing+std::begin%3B%0Ausing+std::end%3B%0A%0Aint+main()%0A%7B%0A++int+foo%5B%5D+%3D+%7B1,+2,+3,+4%7D%3B%0A++std::vector%3Cint%3E+bar%7B2,+3,+4,+5%7D%3B%0A%0A++std::cout+%3C%3C+std::accumulate(begin(foo),+end(foo),+0)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::accumulate(begin(bar),+end(bar),+0)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== Itérateurs}
	\begin{itemize}
		\item [] \begin{itemize}
			\item Compatibles avec les conteneurs non-STL proposant ```cpp begin()``` et ```cpp end()```
			\item Surchargeable sans modification du conteneur pour les autres
		\end{itemize}
	\end{itemize}

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

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cnumeric%3E%0A%0Ausing+std::begin%3B%0Ausing+std::end%3B%0A%0Aclass+Foo+%0A%7B%0Apublic:%0A++int*+first()+%7B+return+std::begin(m_data)%3B+%7D%3B%0A++int*+last()+%7B+return+std::end(m_data)%3B+%7D%3B%0A%0Aprivate:%0A++static+int+m_data%5B3%5D%3B%0A%7D%3B%0A%0Aint+Foo::m_data%5B3%5D+%3D+%7B5,+8,+12%7D%3B%0A%0Aint*+begin(Foo%26+foo)%0A%7B%0A++return+foo.first()%3B%0A%7D%0A%0Aint*+end(Foo%26+foo)%0A%7B%0A++return+foo.last()%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++Foo+foo%3B%0A%0A++std::cout+%3C%3C+std::accumulate(begin(foo),+end(foo),+0)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== Itérateurs}
	\begin{block}{Conseils}
		\begin{itemize}
			\item ```cpp using std::begin``` et ```cpp using std::end``` permet l'ADL malgré la surcharge
		\end{itemize}
	\end{block}

	\begin{alertblock}{Don't}
		\begin{itemize}
			\item N'ouvrez pas le namespace ```cpp std``` pour spécialiser
		\end{itemize}
	\end{alertblock}

	\begin{exampleblock}{Do}
		\begin{itemize}
			\item Préférez ```cpp std::begin()``` et ```cpp std::end()``` aux fonctions membres
		\end{itemize}
	\end{exampleblock}



== Itérateurs}
	\begin{itemize}
		\item ```cpp std::prev()``` et ```cpp std::next()``` retournent l'itérateur suivant ou précédent
		\item Adaptateur d'itérateur ```cpp std::move_iterator``` retournant des \textit{rvalue reference} lors du déréférencement
	\end{itemize}

	```cpp
		vector<string> foo(3), bar{"one","two","three"};

		typedef vector<string>::iterator Iter;

		copy(move_iterator<Iter>(bar.begin()),
		     move_iterator<Iter>(bar.end()),
		     foo.begin());
		// foo : "one" "two" "three"
		// bar : "" "" ""
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cstring%3E%0A%23include+%3Calgorithm%3E%0A%0Atypedef+std::vector%3Cstd::string%3E::iterator+Iter%3B%0A%0Aint+main()%0A%7B%0A++std::vector%3Cstd::string%3E+foo(3)%3B%0A++std::vector%3Cstd::string%3E+bar%7B%22one%22,%22two%22,%22three%22%7D%3B%0A++std::copy(std::move_iterator%3CIter%3E(bar.begin()),+std::move_iterator%3CIter%3E(bar.end()),+foo.begin())%3B%0A%0A++for(size_t+i+%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+%22!'%22+%3C%3C+foo%5Bi%5D+%3C%3C+%22!'+%22%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A++for(size_t+i+%3D+0%3B+i+%3C+bar.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+%22!'%22+%3C%3C+bar%5Bi%5D+%3C%3C+%22!'+%22%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:55.14360313315927,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:44.85639686684073,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cstring%3E%0A%0Atypedef+std::vector%3Cstd::string%3E::iterator+Iter%3B%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B5,+3,+8,+12%7D%3B%0A%0A++auto+it+%3D+std::begin(foo)%3B%0A++std::cout+%3C%3C+*it+%3C%3C+%22+%22+%3C%3C+*next(it)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:55.14360313315927,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:44.85639686684073,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}


== Foncteurs prédéfinis}
	\begin{itemize}
		\item Et bit à bit ```cpp std::bit_and()```
		\item Ou inclusif bit à bit ```cpp std::bit_or()```
		\item Ou exclusif bit à bit ```cpp std::bit_xor()```
	\end{itemize}

	```cpp
		vector<unsigned char> foo{0x10, 0x20, 0x30};
		vector<unsigned char> bar{0xFF, 0x25, 0x00};
		vector<unsigned char> baz;

		transform(begin(foo), end(foo), begin(bar), back_inserter(baz),
		          bit_and<unsigned char>());  // baz : 0x10, 0x20, 0x00

		transform(begin(foo), end(foo), begin(bar), back_inserter(baz),
		          bit_or<unsigned char>());   // baz : 0xFF, 0x25, 0x30

		transform(begin(foo), end(foo), begin(bar), back_inserter(baz),
		          bit_xor<unsigned char>());  // baz : 0xEF, 0x05, 0x30
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ciomanip%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cunsigned+char%3E+foo%7B0x10,+0x20,+0x30%7D%3B%0A++std::vector%3Cunsigned+char%3E+bar%7B0xFF,+0x25,+0x00%7D%3B%0A++std::vector%3Cunsigned+char%3E+baz%3B%0A%0A++std::transform(std::begin(foo),+std::end(foo),+std::begin(bar),+std::back_inserter(baz),+std::bit_xor%3Cunsigned+char%3E())%3B%0A%0A++for(size_t+i+%3D+0%3B+i+%3C+baz.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+std::hex+%3C%3C+std::setfill(!'0!')+%3C%3C+std::setw(2)+%3C%3C+static_cast%3Cunsigned+int%3E(baz%5Bi%5D)+%3C%3C+%22+%22%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:55.14360313315927,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'1',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:44.85639686684073,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ciomanip%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cunsigned+char%3E+foo%7B0x10,+0x20,+0x30%7D%3B%0A++std::vector%3Cunsigned+char%3E+bar%7B0xFF,+0x25,+0x00%7D%3B%0A++std::vector%3Cunsigned+char%3E+baz%3B%0A++std::transform(std::begin(foo),+std::end(foo),+std::begin(bar),+std::back_inserter(baz),+std::bit_or%3Cunsigned+char%3E())%3B%0A%0A++for(size_t+i+%3D+0%3B+i+%3C+baz.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+std::hex+%3C%3C+std::setfill(!'0!')+%3C%3C+std::setw(2)+%3C%3C+static_cast%3Cunsigned+int%3E(baz%5Bi%5D)+%3C%3C+%22+%22%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:55.14360313315927,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:44.85639686684073,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ciomanip%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cunsigned+char%3E+foo%7B0x10,+0x20,+0x30%7D%3B%0A++std::vector%3Cunsigned+char%3E+bar%7B0xFF,+0x25,+0x00%7D%3B%0A++std::vector%3Cunsigned+char%3E+baz%3B%0A%0A++std::transform(std::begin(foo),+std::end(foo),+std::begin(bar),+std::back_inserter(baz),+std::bit_and%3Cunsigned+char%3E())%3B%0A%0A++for(size_t+i+%3D+0%3B+i+%3C+baz.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+std::hex+%3C%3C+std::setfill(!'0!')+%3C%3C+std::setw(2)+%3C%3C+static_cast%3Cunsigned+int%3E(baz%5Bi%5D)+%3C%3C+%22+%22%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:55.14360313315927,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:44.85639686684073,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== Algorithmes -- Recherche linéaire}
	\begin{itemize}
		\item ```cpp std::find_if_not()``` recherche le premier élément ne vérifiant pas le prédicat
	\end{itemize}

	```cpp
		vector<int> foo{1, 4, 5, 9, 12};

		find_if_not(begin(foo), end(foo), is_odd); // 4
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Astatic+bool+is_odd(int+i)%0A%7B%0A++return+(i+%25+2)+%3D%3D+1%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B1,+4,+5,+9,+12%7D%3B%0A++std::cout+%3C%3C+*std::find_if_not(std::begin(foo),+std::end(foo),+is_odd)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:55.14360313315927,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:44.85639686684073,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== Algorithmes -- Comparaison}
	\begin{itemize}
		\item ```cpp std::all_of()``` teste si tous les éléments de l'ensemble vérifient un prédicat
		\item Retourne vrai si l'ensemble est vide
	\end{itemize}

	```cpp
		vector<int> foo{1, 4, 5, 9, 12};
		vector<int> bar{1, 5, 9};
		vector<int> baz{4, 12};

		all_of(begin(foo), end(foo), is_odd); // False
		all_of(begin(bar), end(bar), is_odd); // True
		all_of(begin(baz), end(baz), is_odd); // False
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Ausing+std::begin%3B%0Ausing+std::end%3B%0A%0Astatic+bool+is_odd(int+i)%0A%7B%0A++return+(i+%25+2)+%3D%3D+1%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B1,+4,+5,+9,+12%7D%3B%0A++++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::all_of(begin(foo),+end(foo),+is_odd)+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B1,+5,+9%7D%3B%0A++++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::all_of(begin(foo),+end(foo),+is_odd)+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B4,+12%7D%3B%0A++++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::all_of(begin(foo),+end(foo),+is_odd)+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== Algorithmes -- Comparaison}
	\begin{itemize}
		\item ```cpp std::any_of()``` teste si au moins un élément vérifie un prédicat
		\item Retourne faux si l'ensemble est vide
	\end{itemize}

	```cpp
		vector<int> foo{1, 4, 5, 9, 12};
		vector<int> bar{1, 5, 9};
		vector<int> baz{4, 12};

		any_of(begin(foo), end(foo), is_odd); // True
		any_of(begin(bar), end(bar), is_odd); // True
		any_of(begin(baz), end(baz), is_odd); // False
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Ausing+std::begin%3B%0Ausing+std::end%3B%0A%0Astatic+bool+is_odd(int+i)%0A%7B%0A++return+(i+%25+2)+%3D%3D+1%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B1,+4,+5,+9,+12%7D%3B%0A++++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::any_of(begin(foo),+end(foo),+is_odd)+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B1,+5,+9%7D%3B%0A++++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::any_of(begin(foo),+end(foo),+is_odd)+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B4,+12%7D%3B%0A++++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::any_of(begin(foo),+end(foo),+is_odd)+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== Algorithmes -- Comparaison}
	\begin{itemize}
		\item ```cpp std::none_of()``` teste si aucun élément ne vérifie le prédicat
		\item Retourne vrai si l'ensemble est vide
	\end{itemize}

	```cpp
		vector<int> foo{1, 4, 5, 9, 12};
		vector<int> bar{1, 5, 9};
		vector<int> baz{4, 12};

		none_of(begin(foo), end(foo), is_odd); // False
		none_of(begin(bar), end(bar), is_odd); // False
		none_of(begin(baz), end(baz), is_odd); // True
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Ausing+std::begin%3B%0Ausing+std::end%3B%0A%0Astatic+bool+is_odd(int+i)%0A%7B%0A++return+(i+%25+2)+%3D%3D+1%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B1,+4,+5,+9,+12%7D%3B%0A++++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::none_of(begin(foo),+end(foo),+is_odd)+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B1,+5,+9%7D%3B%0A++++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::none_of(begin(foo),+end(foo),+is_odd)+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B4,+12%7D%3B%0A++++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::none_of(begin(foo),+end(foo),+is_odd)+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== Algorithmes -- Permutation}
	\begin{itemize}
		\item ```cpp std::is_permutation()``` teste si un ensemble est la permutation d'un autre
	\end{itemize}

	```cpp
		vector<int> foo{1, 4, 5, 9, 12};
		vector<int> bar{1, 5, 4, 9, 12};
		vector<int> baz{5, 4, 3, 9, 1};

		is_permutation(begin(foo), end(foo), begin(bar)); // true
		is_permutation(begin(foo), end(foo), begin(baz)); // false
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Ausing+std::begin%3B%0Ausing+std::end%3B%0A%0Aint+main()%0A%7B%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B1,+4,+5,+9,+12%7D%3B%0A++++std::vector%3Cint%3E+bar%7B5,+4,+12,+9,+1%7D%3B%0A%0A++++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_permutation(begin(foo),+end(foo),+begin(bar))+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B1,+4,+5,+9,+12%7D%3B%0A++++std::vector%3Cint%3E+bar%7B5,+4,+12,+7,+1%7D%3B%0A%0A++++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_permutation(begin(foo),+end(foo),+begin(bar))+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== Algorithmes -- Copie}
	\begin{itemize}
		\item ```cpp std::copy_n()``` copie les n premiers éléments d'un ensemble
	\end{itemize}

	```cpp
		vector<int> foo{1, 4, 5, 9, 12}, bar;

		copy_n(begin(foo), 3, back_inserter(bar)); // 1 4 5
	```

	\begin{itemize}
		\item ```cpp std::copy_if()``` copie les éléments vérifiant un prédicat
	\end{itemize}

	```cpp
		vector<int> foo{1, 4, 5, 9, 12}, bar;

		copy_if(begin(foo), end(foo), back_inserter(bar), is_odd); // 1 5 9
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Astatic+bool+is_odd(int+i)%0A%7B%0A++return+(i+%25+2)+%3D%3D+1%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B1,+4,+5,+9,+12%7D%3B%0A++std::vector%3Cint%3E+bar%3B%0A%0A++std::copy_if(std::begin(foo),+std::end(foo),+std::back_inserter(bar),+is_odd)%3B%0A%0A++for(size_t+i+%3D+0%3B+i+%3C+bar.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+bar%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B1,+4,+5,+9,+12%7D%3B%0A++std::vector%3Cint%3E+bar%3B%0A%0A++std::copy_n(std::begin(foo),+4,+std::back_inserter(bar))%3B%0A%0A++for(size_t+i+%3D+0%3B+i+%3C+bar.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+bar%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== Algorithmes -- Déplacement}
	\begin{itemize}
		\item ```cpp std::move()``` déplace les éléments d'un ensemble du début vers la fin
	\end{itemize}

	```cpp
		vector<string> foo{"aa", "bb", "cc"};
		vector<string> bar;

		move(begin(foo), end(foo), back_inserter(bar));
		// foo : "", "", ""
		// bar : "aa", "bb", "cc"
	```

	\begin{itemize}
		\item ```cpp std::move_backward()``` déplace les éléments de la fin vers le début
		\item Versions \og déplacement\fg{} de ```cpp std::copy()``` et ```cpp std::copy_backward()```
	\end{itemize}

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cstring%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cstd::string%3E+foo%7B%22aa%22,+%22bb%22,+%22cc%22%7D%3B%0A++std::vector%3Cstd::string%3E+bar%3B%0A%0A++std::move(std::begin(foo),+std::end(foo),+std::back_inserter(bar))%3B%0A%0A++for(size_t+i+%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+%22!'%22+%3C%3C+foo%5Bi%5D+%3C%3C+%22!'+%22%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A++for(size_t+i+%3D+0%3B+i+%3C+bar.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+%22!'%22+%3C%3C+bar%5Bi%5D+%3C%3C+%22!'+%22%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== Algorithmes -- Partitionnement}
	\begin{itemize}
		\item ```cpp std::is_partitioned()``` indique si un ensemble est partitionné

\note[item]{C'est à dire si les éléments vérifiant un prédicat sont avant ceux ne le vérifiant pas}
	\end{itemize}

	```cpp
		vector<int> foo{4, 5, 9, 12};
		vector<int> bar{9, 5, 4, 12};

		is_partitioned(begin(foo), end(foo), is_odd); // false
		is_partitioned(begin(bar), end(bar), is_odd); // true
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Astatic+bool+is_odd(int+i)%0A%7B%0A++return+(i+%25+2)+%3D%3D+1%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B4,+5,+9,+12%7D%3B%0A++std::vector%3Cint%3E+bar%7B9,+5,+4,+12%7D%3B%0A%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_partitioned(std::begin(foo),+std::end(foo),+is_odd)+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_partitioned(std::begin(bar),+std::end(bar),+is_odd)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== Algorithmes -- Partitionnement}
	\begin{itemize}
		\item ```cpp std::partition_copy()``` copie l'ensemble en le partitionnant
		\item ```cpp std::partition_point()``` retourne le point de partition d'un ensemble partitionné
		\begin{itemize}
			\item C'est à dire le premier élément ne vérifiant pas le prédicat
		\end{itemize}
	\end{itemize}

	```cpp
		vector<int> foo{9, 5, 4, 12};

		partition_point(begin(foo), end(foo), is_odd); // 4
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Astatic+bool+is_odd(int+i)%0A%7B%0A++return+(i+%25+2)+%3D%3D+1%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B9,+5,+4,+12%7D%3B%0A%0A++std::cout+%3C%3C+*std::partition_point(std::begin(foo),+std::end(foo),+is_odd)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== Algorithmes -- Tri}
	\begin{itemize}
		\item ```cpp std::is_sorted()``` indique si l'ensemble est ordonnée (ordre ascendant)
	\end{itemize}

\note[item]{Possibilité de fournir un foncteur de comparaison (```cpp <``` par défaut)}

	```cpp
		vector<int> foo{4, 5, 9, 12};
		vector<int> bar{9, 5, 4, 12};

		is_sorted(begin(foo), end(foo)); // true
		is_sorted(begin(bar), end(bar)); // false
	```

	\begin{itemize}
		\item ```cpp std::is_sorted_until()``` détermine le premier élément mal placé
	\end{itemize}

	```cpp
		vector<int> foo{4, 5, 9, 3, 12};

		is_sorted_until(begin(foo), end(foo)); // 3
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B4,+5,+9,+3,+12%7D%3B%0A%0A++std::cout+%3C%3C+*std::is_sorted_until(std::begin(foo),+std::end(foo))+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B4,+5,+9,+12%7D%3B%0A++std::vector%3Cint%3E+bar%7B9,+5,+4,+12%7D%3B%0A%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_sorted(std::begin(foo),+std::end(foo))+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_sorted(std::begin(bar),+std::end(bar))+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== Algorithmes -- Mélange}
	\begin{itemize}
		\item ```cpp std::shuffle()``` mélange l'ensemble grâce à un générateur de nombre aléatoire uniforme
	\end{itemize}

	```cpp
		vector<int> foo{4, 5, 9, 12};
		unsigned seed = now().time_since_epoch().count();

		shuffle(begin(foo), end(foo), default_random_engine(seed));
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%23include+%3Cchrono%3E%0A%23include+%3Crandom%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B4,+5,+9,+12%7D%3B%0A++unsigned+seed+%3D+std::chrono::system_clock::now().time_since_epoch().count()%3B%0A%0A++std::shuffle(std::begin(foo),+std::end(foo),+std::default_random_engine(seed))%3B%0A++for(size_t+i+%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== Algorithmes -- Gestion de tas}
	\begin{itemize}
		\item ```cpp std::is_heap()``` indique si l'ensemble forme un tas
	\end{itemize}

	```cpp
		vector<int> foo{4, 5, 9, 3, 12};

		is_heap(begin(foo), end(foo));  // false
		make_heap(begin(foo), end(foo));
		is_heap(begin(foo), end(foo));  // true
	```

	\begin{itemize}
		\item ```cpp std::is_heap_until()``` indique le premier élément qui n'est pas dans la position correspondant à un tas
	\end{itemize}

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B4,+5,+9,+3,+12%7D%3B%0A%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_heap(std::begin(foo),+std::end(foo))+%3C%3C+!'%5Cn!'%3B%0A++std::make_heap(std::begin(foo),+std::end(foo))%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_heap(std::begin(foo),+std::end(foo))+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== Algorithmes -- Min-max}
	\begin{itemize}
		\item ```cpp std::minmax()``` retourne la paire constituée du plus petit et du plus grand de deux éléments
	\end{itemize}

	```cpp
		minmax(5, 2); // 2 - 5
	```

	\begin{itemize}
		\item ```cpp std::minmax_element()``` retourne la paire constituée des itérateurs sur le plus petit et le plus grand élément d'un ensemble
	\end{itemize}

	```cpp
		vector<int> foo{18, 5, 6, 8};

		minmax_element(foo.begin(), foo.end()); // 5 - 18
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%23include+%3Cutility%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B18,+5,+6,+8%7D%3B%0A++auto+p+%3D+std::minmax_element(std::begin(foo),+std::end(foo))%3B%0A%0A++std::cout+%3C%3C+*(p.first)+%3C%3C+%22+%22+%3C%3C+*(p.second)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== Algorithmes -- Numérique}
	\begin{itemize}
		\item ```cpp std::iota()``` affecte des valeurs successives aux éléments d'un ensemble
	\end{itemize}

	```cpp
		vector<int> foo(5);

		iota(begin(foo), end(foo), 50); // 50 51 52 53 54
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cnumeric%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo(5)%3B%0A++%0A++std::iota(std::begin(foo),+std::end(foo),+50)%3B%0A++for(size_t+i+%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== Algorithmes -- Conclusion}
	\begin{exampleblock}{Do}
		\begin{itemize}
			\item Continuez à suivre les règles C++98/03 à propos des algorithmes
		\end{itemize}
	\end{exampleblock}

	\begin{exampleblock}{Do}
		\begin{itemize}
			\item Privilégiez la sémantique lorsque plusieurs algorithmes sont utilisables
		\end{itemize}
	\end{exampleblock}


== Range-based for loop}
	\begin{itemize}
		\item Itération sur un conteneur complet
	\end{itemize}

	```cpp
		vector<int> foo{4, 8, 12, 37};

		for(int var : foo)
		  cout << var << " ";    // Affiche 4 8 12 37
	```

	\begin{itemize}
		\item Compatible avec ```cpp auto```
	\end{itemize}

	```cpp
		vector<int> foo{4, 8, 12, 37};

		for(auto var : foo)
		  cout << var << " ";    // Affiche 4 8 12 37
	```

	\begin{itemize}
		\item Utilisable sur tout conteneur
		\begin{itemize}
			\item Exposant ```cpp begin()``` et ```cpp end()```
			\item Utilisable avec ```cpp std::begin()``` et ```cpp std::end()```
		\end{itemize}
	\end{itemize}

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B4,+8,+12,+37%7D%3B%0A%0A++for(auto+var+:+foo)%0A++%7B%0A++++std::cout+%3C%3C+var+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B4,+8,+12,+37%7D%3B%0A%0A++for(int+var+:+foo)%0A++%7B%0A++++std::cout+%3C%3C+var+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{N2930}{https://wg21.link/N2930}
	\addproposal{N3271}{https://wg21.link/N3271}



== Range-based for loop}
	\begin{alertblock}{Modification des éléments}
		\begin{itemize}
			\item La variable d'itération doit être une référence
		\end{itemize}

		```cpp
			vector<int> foo(4);

			for(auto& var : foo)
			  var = 5;    // foo : 5 5 5 5
  		```
	\end{alertblock}

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo(4)%3B%0A%0A++for(auto%26+var+:+foo)%0A++%7B%0A++++var+%3D+5%3B%0A++%7D%0A%0A++for(auto+var+:+foo)%0A++%7B%0A++++std::cout+%3C%3C+var+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{N2930}{https://wg21.link/N2930}
	\addproposal{N3271}{https://wg21.link/N3271}



== Range-based for loop}
	\begin{exampleblock}{Do}
		\begin{itemize}
			\item Préférez \textit{range-based for loop} aux boucles classiques et à ```cpp std::for_each()```
		\end{itemize}
	\end{exampleblock}

\note[item]{```cpp std::for_each()``` n'a plus d'intérêt en C++11 mais redevient utile en C++17 avec les politiques d'exécution parallélisées}

	\begin{block}{Conseils}
		\begin{itemize}
			\item Contrairement à ```cpp for```, l'indice de l'itération n'est pas disponible
			\item Malgré tout, préférez la \textit{range-based for loop} avec un indice externe à ```cpp for```
		\end{itemize}
	\end{block}

	\begin{exampleblock}{Do}
		\begin{itemize}
			\item Utilisez l'inférence de type sur la variable d'itération
		\end{itemize}
	\end{exampleblock}


== \mintinline[style=white]{cpp}```std::string``` et conversions}
	\begin{itemize}
		\item Fonctions de conversion d'une chaîne de caractères en un nombre
		\begin{itemize}
			\item ```cpp std::stoi()``` vers ```cpp int```
			\item ```cpp std::stol()``` vers ```cpp long```
			\item ```cpp std::stoul()``` vers ```cpp unsigned long```
			\item ```cpp std::stoll()``` vers ```cpp long long```
			\item ```cpp std::stoull()``` vers ```cpp unsigned long long```
			\item ```cpp std::stof()``` vers ```cpp float```
			\item ```cpp std::stod()``` vers ```cpp double```
			\item ```cpp std::stold()``` vers ```cpp long double```
		\end{itemize}
	\end{itemize}

	```cpp
		stoi("56"); // 56
	```

	\begin{itemize}
		\item S'arrêtent sur le premier caractère non convertible
	\end{itemize}

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%0Aint+main()%0A%7B%0A++int+a+%3D+std::stoi(%2242%22)%3B%0A%0A++std::cout+%3C%3C+a+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== \mintinline[style=white]{cpp}```std::string``` et conversions}
	\begin{itemize}
		\item ```cpp std::to_string()``` convertit d'un nombre en une chaîne de caractères
	\end{itemize}

	```cpp
		to_string(56); // "56"
	```

	\begin{itemize}
		\item ```cpp std::to_wstring()``` convertit vers une chaîne de caractères larges
	\end{itemize}

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%0Aint+main()%0A%7B%0A++std::string+b+%3D+std::to_string(56)%3B%0A%0A++std::cout+%3C%3C+b+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== \mintinline[style=white]{cpp}```std::string``` et conversions}
	\begin{alertblock}{Attention}
		\begin{itemize}
			\item Pas de fonction ```cpp std::stoui()``` de conversion vers un ```cpp unsigned int```
		\end{itemize}
	\end{alertblock}

	\begin{exampleblock}{Do}
		\begin{itemize}
			\item Préférez ```cpp std::sto...()``` à ```cpp sscanf()```, ```cpp atoi()``` ou ```cpp strto...()```
		\end{itemize}
	\end{exampleblock}

	\begin{exampleblock}{Do}
		\begin{itemize}
			\item Préférez ```cpp std::to_string()``` à ```cpp snprintf()``` ou ```cpp itoa()```
		\end{itemize}
	\end{exampleblock}

	\begin{block}{Alternative et complément}
		\begin{itemize}
			\item ```cpp Boost.Lexical_cast``` permet de telles conversions et quelques autres
		\end{itemize}
	\end{block}


== Chaînes de caractères UTF}
	\begin{itemize}
		\item ```cpp char``` doit pouvoir contenir un encodage 8 bits UTF-8

\note[item]{Pas de garantie en C++98/03, implémentation-defined}

		\item ```cpp char16_t``` représente un code point 16 bits
		\item ```cpp char32_t``` représente un code point 32 bits
		\item ```cpp std::u16string``` spécialisation de ```cpp basic_string``` pour caractères 16 bits
		\item ```cpp std::u32string``` spécialisation de ```cpp basic_string``` pour caractères 32 bits
		\item Même interface que ```cpp std::string```
	\end{itemize}

	\addproposal{N2249}{https://wg21.link/N2249}


== Nouvelles chaînes littérales}
	\begin{itemize}
		\item Chaînes littérales UTF-8, UTF-16 et UTF32
	\end{itemize}

	```cpp
		string u8str     = u8"UTF-8 string";
		u16string u16str = u"UTF-16 string";
		u32string u32str = U"UTF-32 string";
	```

	\addproposal{N2442}{https://wg21.link/N2442}



== Nouvelles chaînes littérales}
	\begin{itemize}
		\item Chaînes littérales brutes (sans interprétation des échappements)

\note[item]{Utile pour écrire des expressions rationnelles, des commandes shell ou autres qui ont aussi leurs échappements}

		\begin{itemize}
			\item Préfixées par ```cpp R```
			\item Encadrées par une paire de parenthèses
			\item Éventuellement complétées d'un délimiteur
		\end{itemize}
	\end{itemize}

	```cpp
		// Affiche Message\n en une seule \n ligne
		cout << R"(Message\n en une seule \n ligne)";
		cout << R"--(Message\n en une seule \n ligne)--";
	```

	\begin{itemize}
		\item Composition possible des deux type de chaînes littérales
	\end{itemize}

	```cpp
		u8R"(Message\n en une seule \n ligne)";
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+R%22(Message%5Cn+en+une+seule+%5Cn+ligne)%22+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+R%22--(Message%5Cn+en+une+seule+%5Cn+ligne)--%22+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+u8R%22(Message%5Cn+en+une+seule+%5Cn+ligne)%22+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{N2442}{https://wg21.link/N2442}


== User-defined literals}
	\begin{itemize}
		\item Possibilité de définir des littéraux \og utilisateur\fg{}
		\item Nombre (entier ou réel), caractère ou chaîne suffixé par un identifiant
		\item Identifiants non standards préfixés par ```cpp _```
		\item Définit via ```cpp operator""suffixe```
	\end{itemize}

	\begin{block}{Motivations}
		\begin{itemize}
			\item Pas de conversion implicite
			\item Expressivité

\note[item]{Exemple d'expressivité : des classes de \og quantité\fg{} avec des \textit{user-defined literals} pour les unités}
		\end{itemize}
	\end{block}

	\addproposal{N2765}{https://wg21.link/N2765}



== User-defined literals}
	\begin{itemize}
		\item Littéraux brutes : chaîne C entièrement analysée par l'opérateur
	\end{itemize}

	```cpp
		class Foo {
		public: explicit Foo(int a) : m_a{a} {}
		private: int m_a; };

		Foo operator""_b(const char* str) {
		  unsigned long long a = 0;
		  for(size_t i = 0; str[i]; ++i)
		    a = (a * 2) + (str[i] - '0');
		  return Foo(a); }

		Foo foo = 6        // Erreur de compilation
		Foo bar = 0110_b;  // 6
	```

	\begin{alertblock}{Restrictions}
		\begin{itemize}
			\item Uniquement pour les littéraux numériques
		\end{itemize}
	\end{alertblock}

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%0Aclass+Foo%0A%7B%0Apublic:%0A++explicit+Foo(int+a)%0A++++:+m_a%7Ba%7D%0A++%7B%7D%0A%0A++void+print()%0A++%7B%0A++++std::cout+%3C%3C+m_a+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0Aprivate:%0A++int+m_a%3B%0A%7D%3B%0A%0Astatic+Foo+operator%22%22_b(const+char*+str)%0A%7B%0A++unsigned+long+long+a+%3D+0%3B%0A++for(size_t+i+%3D+0%3B+str%5Bi%5D%3B+%2B%2Bi)%0A++%7B%0A++++a+%3D+(a+*+2)+%2B+(str%5Bi%5D+-+!'0!')%3B%0A++%7D%0A++return+Foo(a)%3B%0A%7D%0A%0Aint+main()%0A%7B%0A%23if+0%0A++Foo+foo+%3D+6%3B%0A%23else%0A++Foo+foo+%3D+0110_b%3B%0A%23endif%0A++foo.print()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{N2765}{https://wg21.link/N2765}



== User-defined literals}
	\begin{itemize}
		\item Littéraux préparés par le compilateur
		\begin{itemize}
			\item Littéraux entiers : ```cpp unsigned long long int```
			\item Littéraux réels : ```cpp long double```
			\item Littéraux caractères : ```cpp char```, ```cpp wchar_t```, ```cpp char16_t``` ou ```cpp char32_t```
			\item Chaînes littérales : couple pointeur sur caractères et ```cpp size_t```
		\end{itemize}
	\end{itemize}

	```cpp
		Foo operator""_f(unsigned long long int a) {
		  return Foo(a); }

		Foo operator""_f(const char* str, size_t) {
		  return Foo(std::stoull(str)); }

		Foo baz = 12_f;    // OK
		Foo bar = "12"_f;  // OK
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%0Aclass+Foo%0A%7B%0Apublic:%0A++explicit+Foo(int+a)%0A++++:+m_a%7Ba%7D%0A++%7B%7D%0A%0A++void+print()%0A++%7B%0A++++std::cout+%3C%3C+m_a+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0Aprivate:%0A++int+m_a%3B%0A%7D%3B%0A%0Astatic+Foo+operator+%22%22+_f(unsigned+long+long+int+a)%0A%7B%0A++return+Foo(a)%3B%0A%7D%0A%0Astatic+Foo+operator%22%22_f(const+char*+str,+size_t+/*+length+*/)%0A%7B%0A++return+Foo(std::stoull(str))%3B%0A%7D%0A%0Aint+main()%0A%7B%0A%23if+0%0A++Foo+foo+%3D+12%3B%0A%23endif%0A%0A++Foo+bar+%3D+12_f%3B%0A++bar.print()%3B%0A%0A++Foo+baz+%3D+%2212%22_f%3B%0A++baz.print()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{N2765}{https://wg21.link/N2765}


== \mintinline[style=white]{cpp}```std::tuple```}
	\begin{itemize}
		\item Collection d'objets de type divers
		\item Généralisation de ```cpp std::pair```
	\end{itemize}

	```cpp
		tuple<int, char, long> foo;
	```

	\begin{itemize}
		\item ```cpp std::make_tuple()``` construit un ```cpp std::tuple```
	\end{itemize}

	```cpp
		tuple<int, char, long> foo = make_tuple(5, 'e', 98L);
	```

	\begin{block}{\mintinline[style=white]{cpp}```std::make_tuple``` ou constructeur ?}
		\begin{itemize}
			\item ```cpp std::make_tuple()``` permet la déduction de types, pas le constructeur
		\end{itemize}

		```cpp
			auto foo{5, 'e', 98L};              // KO
			auto bar = make_tuple(5, 'e', 98L); // OK
		```
	\end{block}

	\addproposal{n1836}{https://wg21.link/n1836}



== \mintinline[style=white]{cpp}```std::tuple```}
	\begin{itemize}
		\item Fonction de déstructuration ```cpp std::tie()```
		\item Et une constante pour ignorer des éléments ```cpp std::ignore```
	\end{itemize}

	```cpp
		int a; long b;
		tie(a, ignore, b) = foo;
	```

\note[item]{C++17 introduit les \textit{structured binding} qui améliore grandement la déstructuration en proposant une syntaxe plus simple et claire}

	\begin{itemize}
		\item ```cpp std::get<>()``` accède aux éléments du ```cpp std::tuple``` par l'indice
	\end{itemize}

	```cpp
		char c = get<1>(foo);
	```

	\begin{alertblock}{Attention}
		\begin{itemize}
			\item Les indices commencent à 0
		\end{itemize}
	\end{alertblock}

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%23include+%3Ctuple%3E%0A%0Aint+main()%0A%7B%0A++std::tuple%3Cint,+std::string,+double%3E+foo+%3D+std::make_tuple(42,+%22FOO%22,+25.2)%3B%0A%0A++std::string+c+%3D+std::get%3C1%3E(foo)%3B%0A++std::cout+%3C%3C+c+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%23include+%3Ctuple%3E%0A%0Aint+main()%0A%7B%0A++std::tuple%3Cint,+std::string,+double%3E+foo+%3D+std::make_tuple(42,+%22FOO%22,+25.2)%3B%0A%0A++int+a%3B%0A++double+b%3B%0A%0A++std::tie(a,+std::ignore,+b)+%3D+foo%3B%0A++std::cout+%3C%3C+a+%3C%3C+!'+!'+%3C%3C+b+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{n1836}{https://wg21.link/n1836}



== \mintinline[style=white]{cpp}```std::tuple```}
	\begin{itemize}
		\item ```cpp std::tuple_cat()``` concatène deux ```cpp std::tuple```
	\end{itemize}

	```cpp
		auto foo = make_tuple(5, 'e');
		auto bar = make_tuple(98L, 'r');
		auto baz = tuple_cat(foo, bar);               // 5 'e' 98L 'r'
	```

	\begin{itemize}
		\item Classe représentant la taille ```cpp std::tuple_size```
	\end{itemize}

	```cpp
		tuple_size<decltype(baz)>::value;             // 4
	```

	\begin{itemize}
		\item Classe représentant le type des éléments ```cpp std::tuple_element```
	\end{itemize}

	```cpp
		tuple_element<0, decltype(baz)>::type first;  // int
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%23include+%3Ctuple%3E%0A%0Aint+main()%0A%7B%0A++std::tuple%3Cint,+std::string,+double%3E+foo+%3D+std::make_tuple(42,+%22FOO%22,+25.2)%3B%0A++auto+bar+%3D+std::make_tuple(12,+5UL)%3B%0A++auto+baz+%3D+std::tuple_cat(foo,+bar)%3B%0A%0A++std::cout+%3C%3C+std::tuple_size%3Cdecltype(baz)%3E::value+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{n1836}{https://wg21.link/n1836}



== \mintinline[style=white]{cpp}```std::tuple```}
	\begin{alertblock}{Don't}
		\begin{itemize}
			\item N'utilisez pas ```cpp std::tuple``` pour remplacer une structure
			\item ```cpp std::tuple``` regroupe localement des éléments sans lien sémantique
		\end{itemize}
	\end{alertblock}

	\begin{exampleblock}{Do}
		\begin{itemize}
			\item Préférez un ```cpp std::tuple``` de retour aux paramètres \og{}\textit{OUT}\fg{}
		\end{itemize}
	\end{exampleblock}


== \mintinline[style=white]{cpp}```fstream```}
	\begin{itemize}
		\item Construction depuis des ```cpp std::string```
	\end{itemize}

	```cpp
		string filename{"foo.txt"};

		// C++ 98
		ofstream file(filename.c_str());

		// C++ 11
		ofstream file{filename};
	```


== \mintinline[style=white]{cpp}```=default``` et \mintinline[style=white]{cpp}```=delete```}
	\begin{itemize}
		\item Applicables aux fonctions générées implicitement le compilateur
		\begin{itemize}
			\item Constructeur par défaut, par copie et par déplacement
			\item Destructeur
			\item Opérateur d'affectation
			\item Opérateur d'affectation par déplacement
		\end{itemize}
		\item ```cpp =default``` force le compilateur à générer l'implémentation triviale
		\item ```cpp =delete``` désactive la génération implicite de la fonction
		\item ```cpp =delete``` peut aussi s'appliquer aux fonctions héritées pour les supprimer
	\end{itemize}

	```cpp
		class Foo {
		  public: Foo(int) {}
		  public: Foo() = default;

		  private: Foo(const Foo&) = delete;
		  private: Foo& operator=(const Foo&) = delete;
		};
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aclass+Foo%0A%7B%0Apublic:%0A++Foo(int)+%7B%7D%0A%23if+1%0A++Foo()+%3D+default%3B%0A%23endif%0A%0Aprivate:%0A++Foo(const+Foo%26)+%3D+delete%3B%0A++Foo%26+operator%3D(const+Foo%26)+%3D+delete%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++Foo+foo%3B%0A++Foo+bar(5)%3B%0A%23if+0%0A++Foo+baz(bar)%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra+-Wno-unused-variable',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{N2346}{https://wg21.link/N2346}



== \mintinline[style=white]{cpp}```=default``` et \mintinline[style=white]{cpp}```=delete```}
	\begin{exampleblock}{Do}
		\begin{itemize}
			\item Préférez ```cpp =default``` à une implémentation manuelle avec le même effet
		\end{itemize}
	\end{exampleblock}

	\begin{exampleblock}{Do}
		\begin{itemize}
			\item Préférez ```cpp =delete``` à une déclaration privée sans définition
		\end{itemize}
	\end{exampleblock}

	\begin{block}{\mintinline[style=white]{cpp}```=default``` ou non définition ?}
		\begin{itemize}
			\item Consensus plutôt du côté de la non-définition
			\item Intérêt documentaire réel à ```cpp =default```
		\end{itemize}
	\end{block}



== Initialisation par défaut des membres}
	\begin{itemize}
		\item Initialisation des membres lors de la déclaration
	\end{itemize}

	```cpp
		struct Foo {
		  Foo() {}
		  int m_a{2};
		};
	```

	\begin{alertblock}{Restriction}
		\begin{itemize}
			\item Pas d'initialisation avec ```cpp ()```
			\item Initialisation avec ```cpp =``` uniquement sur des types copiables
		\end{itemize}
	\end{alertblock}

	\begin{exampleblock}{Do}
		\begin{itemize}
			\item Préférez l'initialisation des membres à l'initialisation par constructeurs pour les initialisations avec une valeur connue à la compilation
		\end{itemize}
	\end{exampleblock}

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astruct+Foo%0A%7B%0A++Foo()%0A++%7B%7D%0A%0A++int+m_a%7B2%7D%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++Foo+foo%3B%0A%0A++std::cout+%3C%3C+foo.m_a+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{N2756}{https://wg21.link/N2756}



== Délégation de constructeur}
	\begin{itemize}
		\item Utilisation d'un constructeur dans l'implémentation d'un second
		\item \ldots{} en \og l'initialisant\fg{} dans la liste d'initialisation
	\end{itemize}

	```cpp
		struct Foo {
		  Foo(int a) : m_a(a) {}
		  Foo() : Foo(2) {}
		  int m_a;
		};
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aclass+Foo%0A%7B%0Apublic:%0A++Foo(int+a)%0A++++:+m_a(a)%0A++%7B%0A++%7D%0A%0A++Foo()%0A++++:+Foo(2)%0A++%7B%0A++%7D%0A%0A++void+print()%0A++%7B%0A++++std::cout+%3C%3C+m_a+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0Aprivate:%0A++int+m_a%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++Foo+foo(4)%3B%0A++Foo+bar%3B%0A%0A++foo.print()%3B%0A++bar.print()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{N1986}{https://wg21.link/N1986}



== Délégation de constructeur}
	\begin{exampleblock}{Do}
		\begin{itemize}
			\item Utilisez la délégation de constructeur pour mutualiser le code commun
		\end{itemize}
	\end{exampleblock}

	\begin{alertblock}{Don't}
		\begin{itemize}
			\item Évitez la délégation pour l'initialisation constante de membres
			\item Préférez l'initialisation par défaut des membres
		\end{itemize}
	\end{alertblock}



== Héritage de constructeur}
	\begin{itemize}
		\item Indique que la classe hérite des constructeurs de la classe mère
		\item Génération du constructeur correspondant par le compilateur
		\begin{itemize}
			\item Paramètres du constructeur de base
			\item Appelle le constructeur de base correspondant
			\item Initialise les membres sans fournir de paramètres
		\end{itemize}
	\end{itemize}

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

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astruct+Foo%0A%7B%0A++Foo()%0A++%7B%7D%0A%0A++Foo(int+a)%0A++++:+m_a(a)%0A++%7B%7D%0A%0A++int+m_a%7B2%7D%3B%0A%7D%3B%0A%0Astruct+Bar+:+Foo%0A%7B%0A++using+Foo::Foo%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++%7B%0A++++Foo+foo%3B%0A++++Foo+bar(4)%3B%0A%0A++++std::cout+%3C%3C+foo.m_a+%3C%3C+!'+!'+%3C%3C+bar.m_a+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0A++%7B%0A++++Bar+foo%3B%0A++++Bar+bar(4)%3B%0A%0A++++std::cout+%3C%3C+foo.m_a+%3C%3C+!'+!'+%3C%3C+bar.m_a+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{N2540}{https://wg21.link/N2540}



== Héritage de constructeur}
	\begin{itemize}
		\item Redéfinition possible dans la classe dérivée
	\end{itemize}

	```cpp
		struct Bar : Foo {
		  using Foo::Foo;
		  Bar() : Foo(5) {}
		};
	```

	\begin{alertblock}{Valeurs par défaut}
		\begin{itemize}
			\item Génération de toutes les combinaisons de constructeurs sans valeur par défaut correspondantes au constructeur de base avec des valeurs par défaut
		\end{itemize}

\note[item]{Ainsi ```cpp Foo(int, int = 2)``` va injecter ```cpp Bar(int)``` et ```cpp Bar(int, int)```}
	\end{alertblock}

	\begin{alertblock}{Héritage multiple}
		\begin{itemize}
			\item Héritage impossible de deux constructeurs avec la même signature
		\end{itemize}
	\end{alertblock}

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astruct+Foo%0A%7B%0A++Foo()%0A++%7B%7D%0A%0A++Foo(int+a)%0A++++:+m_a(a)%0A++%7B%7D%0A%0A++int+m_a%7B2%7D%3B%0A%7D%3B%0A%0Astruct+Bar+:+Foo%0A%7B%0A++using+Foo::Foo%3B%0A++Bar()%0A++++:+Foo(5)+%0A++%7B%7D%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++Bar+foo%3B%0A++Bar+bar(4)%3B%0A%0A++std::cout+%3C%3C+foo.m_a+%3C%3C+!'+!'+%3C%3C+bar.m_a+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{N2540}{https://wg21.link/N2540}



== \mintinline[style=white]{cpp}```override```}
	\begin{itemize}
		\item Indique la redéfinition d'une fonction d'une classe de base
	\end{itemize}

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

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%0Astruct+Foo%0A%7B%0A++Foo()%0A++%7B%7D%0A%0A++virtual+void+f(int)%0A++%7B%7D%0A%7D%3B%0A%0Astruct+Bar+:+Foo%0A%7B%0A++Bar()%0A++%7B%7D%0A%0A++void+f(int)+override%0A++%7B%7D%0A%7D%3B%0A%0Aint+main()%0A%7B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{N2928}{https://wg21.link/N2928}
	\addproposal{N3206}{https://wg21.link/N3206}
	\addproposal{N3272}{https://wg21.link/N3272}



== \mintinline[style=white]{cpp}```override```}
	\begin{itemize}
		\item Provoque une erreur de compilation si
		\begin{itemize}
			\item La fonction n'existe pas dans la classe de base
			\item La fonction de la classe de base n'est pas virtuelle
		\end{itemize}
	\end{itemize}

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

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astruct+Foo%0A%7B%0A++Foo()+%0A++%7B%7D%0A%0A++virtual+void+f(int)%0A++%7B%7D%0A%0A++virtual+void+g(int)+const%0A++%7B%7D%0A%0A++void+h(int)%0A++%7B%7D%0A%7D%3B%0A%0Astruct+Bar+:+Foo%0A%7B%0A++Bar()%0A++%7B%7D%0A%0A++void+f(float)+override%0A++%7B%7D%0A%0A++void+g(int)+override%0A++%7B%7D%0A%0A++void+h(int)+override%0A++%7B%7D%0A%0A++void+i(int)+override%0A++%7B%7D%0A%7D%3B%0A%0Aint+main()%0A%7B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{N2928}{https://wg21.link/N2928}
	\addproposal{N3206}{https://wg21.link/N3206}
	\addproposal{N3272}{https://wg21.link/N3272}



== \mintinline[style=white]{cpp}```override```}
	\begin{block}{Objectifs}
		\begin{itemize}
			\item Documentaire
			\item Détection des non-reports de modifications lors d'un refactoring
			\item Détection des redéfinitions involontaires
		\end{itemize}
	\end{block}

	\begin{exampleblock}{Do}
		\begin{itemize}
			\item Marquez ```cpp override``` les fonctions que vous redéfinissez
		\end{itemize}
	\end{exampleblock}

	\begin{exampleblock}{Do}
		\begin{itemize}
			\item Utilisez ```cpp virtual``` à la base de l'arbre d'héritage
			\item Utilisez ```cpp override``` sur les redéfinitions
		\end{itemize}

\note[item]{Si une fonction est virtuelle, toutes ces redéfinitions le sont qu'elles soient ou non marquées comme tel}
	\end{exampleblock}



== \mintinline[style=white]{cpp}```final```}
	\begin{itemize}
		\item Indique qu'une classe ne peut pas être dérivée
	\end{itemize}

	```cpp
		struct Foo final {
		  virtual void f(int);
		};

		struct Bar : Foo {   // Erreur
		  void f(int);
		};
	```

	\begin{itemize}
		\item Aussi bien via l'héritage public que privé
	\end{itemize}

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astruct+Foo+final%0A%7B%0A++Foo()%0A++%7B%7D%0A%7D%3B%0A%0Astruct+Bar+:+Foo%0A%7B%0A++Bar()%0A++%7B%7D%0A%7D%3B%0A%0Aint+main()%0A%7B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{N3206}{https://wg21.link/N3206}
	\addproposal{N3272}{https://wg21.link/N3272}



== \mintinline[style=white]{cpp}```final```}
	\begin{itemize}
		\item Ou qu'une fonction ne peut plus être redéfinie
	\end{itemize}

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

	\begin{exampleblock}{Do}
		\begin{itemize}
			\item Utilisez ```cpp final``` avec parcimonie
		\end{itemize}
	\end{exampleblock}

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astruct+Foo%0A%7B%0A++Foo()%0A++%7B%7D%0A%0A++virtual+void+f(int)%0A++%7B%7D%0A%7D%3B%0A%0Astruct+Bar+:+Foo%0A%7B%0A++Bar()%0A++%7B%7D%0A%0A++virtual+void+f(int)+final%0A++%7B%7D%0A%7D%3B%0A%0Astruct+Baz+:+Bar%0A%7B%0A++Baz()%0A++%7B%7D%0A%0A++virtual+void+f(int)%0A++%7B%7D%0A%7D%3B%0A%0Aint+main()%0A%7B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{N3206}{https://wg21.link/N3206}
	\addproposal{N3272}{https://wg21.link/N3272}



== Opérateurs de conversion explicite}
	\begin{itemize}
		\item Extension de ```cpp explicit``` aux opérateurs de conversion
		\item \ldots{} qui ne définissent alors plus de conversion implicite
	\end{itemize}

	```cpp
		struct Foo { operator int() { return 5; } };

		Foo f;
		int a = f;                    // OK
		int b = static_cast<int>(f);  // OK
	```

	```cpp
		struct Foo { explicit operator int() { return 5; } };

		Foo f;
		int a = f;                    // Erreur
		int b = static_cast<int>(f);  // OK
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astruct+Foo%0A%7B%0A++operator+int()%0A++%7B%0A++++return+5%3B%0A++%7D%0A%7D%3B%0A%0Astruct+Bar%0A%7B%0A++explicit+operator+int()%0A++%7B%0A++++return+5%3B%0A++%7D%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++%7B%0A++++Foo+f%3B%0A++++int+a+%3D+f%3B%0A++++int+b+%3D+static_cast%3Cint%3E(f)%3B%0A++++std::cout+%3C%3C+a+%3C%3C+!'+!'+%3C%3C+b+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0A++%7B%0A++++Bar+f%3B%0A%23if+1%0A++++int+a+%3D+f%3B%0A%23endif%0A++++int+b+%3D+static_cast%3Cint%3E(f)%3B%0A++++std::cout+%3C%3C+b+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{N2437}{https://wg21.link/N2437}


== \mintinline[style=white]{cpp}```noexcept```}
	\begin{itemize}
		\item Indique qu'une fonction ne jette pas d'exception

\note[item]{Rôle documentaire et permet au compilateur d'effectuer certaines optimisations (p. ex. sur le choix entre déplacement et copie)}
\note[item]{Appelle ```cpp std::terminate()``` lorsque la fonction ne respecte pas son contrat et lance une exception}
\note[item]{```cpp std::terminate()``` appelle le \textit{handler} correspondant qui par défaut est ```cpp std::abort()``` qui arrête violemment le programme}
	\end{itemize}

	```cpp
		void foo() noexcept {}
	```

	\begin{itemize}
		\item Pilotable par une expression booléenne
	\end{itemize}

	```cpp
		void foo() noexcept(true) {}
	```

	\begin{block}{Dépréciation}
		\begin{itemize}
			\item Les spécifications d'exception sont dépréciées
			\item Voir \href{http://www.gotw.ca/publications/mill22.htm}{A Pragmatic Look at Exception Specifications\linklogo} (Herb Sutter)
		\end{itemize}

\note[item]{En pratique, seule ```cpp throw()``` était utilisée et utilisable et a été remplacée par ```cpp noexcept```}
	\end{block}

	\addproposal{N3050}{https://wg21.link/N3050}



== \mintinline[style=white]{cpp}```noexcept```}
	\begin{itemize}
		\item Opérateur ```cpp noexcept()``` teste, au \textit{compile-time}, si une expression peut ou non lever une exception
		\item Pour l'appel de fonction, teste si la fonction est ```cpp noexcept```
	\end{itemize}

	```cpp
		noexcept(foo()); // true
	```

	\begin{exampleblock}{Do}
		\begin{itemize}
			\item Marquez ```cpp noexcept``` les fonctions qui sémantiquement ne jette pas d'exception
		\end{itemize}
	\end{exampleblock}

	\addproposal{N3050}{https://wg21.link/N3050}



== Conversion exception - pointeur}
	\begin{itemize}
		\item Quasi-pointeur ```cpp std::exception_ptr``` à responsabilité partagée sur une exception
		\item ```cpp std::current_exception()``` récupère un pointeur sur l'exception courante
		\item ```cpp std::rethrow_exception()``` relance l'exception contenue dans ```cpp std::exception_ptr```
		\item ```cpp std::make_exception_ptr()``` construit ```cpp std::exception_ptr``` depuis une exception
	\end{itemize}

	\addproposal{n2179}{https://wg21.link/n2179}



== Conversion exception - pointeur}
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

	\begin{block}{Motivation}
		\begin{itemize}
			\item Faire passer la barrière des threads aux exceptions
		\end{itemize}
	\end{block}

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cexception%3E%0A%0Avoid+foo()%0A%7B%0A++throw+42%3B%0A%7D%0A%0Avoid+bar(std::exception_ptr+e)%0A%7B%0A++std::rethrow_exception(e)%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++try%0A++%7B%0A++++foo()%3B%0A++%7D%0A++catch(...)%0A++%7B%0A++++std::exception_ptr+e+%3D+std::current_exception()%3B%0A++++bar(e)%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:54.83028720626631,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:45.16971279373369,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{n2179}{https://wg21.link/n2179}



== Nested exception}
	\begin{itemize}
		\item ```cpp std::nested_exception``` contient une exception imbriquée
		\item ```cpp nested_ptr()``` récupère un pointeur sur l'exception imbriquée
		\item ```cpp rethrow_nested()``` relance l'exception imbriquée
		\item ```cpp std::rethrow_if_nested()``` relance l'exception imbriquée si elle existe
		\item ```cpp std::throw_with_nested()``` lance une exception embarquant l'exception courante
	\end{itemize}

	```cpp
		void foo() {
		  try { throw 42; }
		  catch(...) { throw_with_nested(logic_error("bar")); }
		}

		try { foo(); }
		catch(logic_error &e) { std::rethrow_if_nested(e); }
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cexception%3E%0A%0Avoid+foo()+%0A%7B%0A++try+%0A++%7B+%0A++++throw+42%3B%0A++%7D%0A++catch(...)%0A++%7B+%0A++++std::throw_with_nested(std::logic_error(%22bar%22))%3B%0A++%7D%0A%7D%0A%0Aint+main()%0A%7B%0A++try%0A++%7B%0A++++foo()%3B%0A++%7D%0A++catch(std::logic_error+%26e)%0A++%7B%0A%23if+0%0A++++std::rethrow_if_nested(e)%3B%0A%23else%0A++++throw%3B%0A%23endif%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}


== \mintinline[style=white]{cpp}```enum class```}
	\begin{itemize}
		\item Énumérations mieux typées
		\item Sans conversions implicites
		\item Énumérés locaux à l'énumération
	\end{itemize}

	```cpp
		enum class Foo { BAR1, BAR2 };

		Foo foo = Foo::BAR1;
	```

	\begin{itemize}
		\item Possibilité de fournir le type sous-jacent

\note[item]{Sur les énumérations classiques aussi}
	\end{itemize}

	```cpp
		enum class Foo : unsigned char { BAR1, BAR2 };
	```

	\begin{itemize}
		\item ```cpp std::underlying_type``` permet de récupérer ce type sous-jacent
	\end{itemize}

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ctype_traits%3E%0A%0Aenum+class+Foo+:+unsigned+int%0A%7B+%0A++BAR1,%0A++BAR2,%0A%7D%3B%0A%0Aint+main()%0A%7B%0A%23if+0%0A++Foo+foo+%3D+BAR2%3B%0A%23else%0A++Foo+foo+%3D+Foo::BAR2%3B%0A%23endif%0A%0A%23if+0%0A++std::cout+%3C%3C+foo+%3C%3C+%22%5Cn%22%3B%0A%23else%0A++std::cout+%3C%3C+static_cast%3Cstd::underlying_type%3CFoo%3E::type%3E(foo)+%3C%3C+%22%5Cn%22%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{N2347}{https://wg21.link/N2347}



== \mintinline[style=white]{cpp}```enum class```}
	\begin{exampleblock}{Do}
		\begin{itemize}
			\item Préférez les énumérations fortement typées
		\end{itemize}
	\end{exampleblock}

	\begin{block}{Bémol}
		\begin{itemize}
			\item Pas de méthode simple et robuste pour récupérer la valeur ou l'intitulé de l'énuméré
		\end{itemize}
	\end{block}


== \mintinline[style=white]{cpp}```std::function```}
\note[item]{Fonction de première classe (\og first-class citizens\fg{}) : utilisables comme paramètre ou retour de fonction}
\note[item]{Fonction d'ordre supérieur : prend en paramètre ou retourne une autre fonction}

	\begin{itemize}
		\item Encapsule un appelable de n'importe quel type
	\end{itemize}

	```cpp
		int foo(int, int);

		function<int(int, int)> bar = foo;
	```

	\begin{itemize}
		\item Copiable
		\item Peut être passer en paramètre ou retourner par une fonction
	\end{itemize}

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cfunctional%3E%0A%0Aint+foo(int+a,+int+b)%0A%7B%0A++return+a+%2B+b%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::function%3Cint(int,+int)%3E+bar+%3D+foo%3B%0A%0A++std::cout+%3C%3C+bar(1,2)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{n1836}{https://wg21.link/n1836}



== \mintinline[style=white]{cpp}```std::mem_fn```}
	\begin{itemize}
		\item Convertit une fonction membre en \textit{function object} prenant une instance en paramètre
	\end{itemize}

	```cpp
		struct Foo { int f(int a) { return 2 * a; } };

		Foo foo;
		function<int(Foo, int)> bar = mem_fn(&Foo::f);
		bar(foo, 5);   // 10
	```

	\begin{block}{Note}
		\begin{itemize}
			\item Type de retour non spécifié mais stockable dans ```cpp std::function```
		\end{itemize}
	\end{block}

	\begin{block}{Dépréciation}
		\begin{itemize}
			\item Dépréciation de ```cpp std::mem_fun```, ```cpp std::ptr_fun``` et consorts
		\end{itemize}

\note[item]{Série de fonctions templates convertissant des fonctions membres, des pointeurs de fonction, etc. en foncteur utilisable dans les algorithmes}
\note[item]{Leur grosse limitation venait du nombre de paramètres limités (0 ou 1)}
	\end{block}

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cfunctional%3E%0A%0Astruct+Foo%0A%7B%0A++int+f(int+a)%0A++%7B%0A++++return+2+*+a%3B%0A++%7D%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++Foo+foo%3B%0A++std::function%3Cint(Foo,+int)%3E+bar+%3D+std::mem_fn(%26Foo::f)%3B%0A%0A++std::cout+%3C%3C+bar(foo,+5)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{n1836}{https://wg21.link/n1836}



== \mintinline[style=white]{cpp}```std::bind```}
	\begin{itemize}
		\item Construction de \textit{function object} en liant des paramètres à un appelable
		\item \textit{Placeholders} ```cpp std::placholders::_1```, ```cpp std::placholders::_2```, \ldots{} pour lier les paramètres du \textit{function object} à l'appelable
	\end{itemize}

	```cpp
		int foo(int a, int b) { return (a - 1) * b; }

		function<int(int)> bar = bind(&foo, _1, 2);
		bar(3);               // 4

		auto baz = bind(&foo, _2, _1);
		baz(3, 2, 1, 2, 3);   // 3
	```

\note[item]{Avec auto, il est possible de passer autant de paramètres surnuméraires que souhaiter}

	\begin{block}{Dépréciation}
		\begin{itemize}
			\item Dépréciation de ```cpp std::bind1st``` et ```cpp std::bind2nd```
		\end{itemize}

\note[item]{Version C++98 mais limités car ne pouvait que convertir une fonction binaire en fonction unaire en liant le premier ou le second paramètre}
	\end{block}

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cfunctional%3E%0A%0Astatic+int+foo(int+a,+int+b)%0A%7B%0A++return+(a+-+1)+*+b%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::function%3Cint(int)%3E+bar+%3D+std::bind(%26foo,+std::placeholders::_1,+2)%3B%0A++std::cout+%3C%3C+bar(3)+%3C%3C+!'%5Cn!'%3B%0A%0A++auto+baz+%3D+std::bind(%26foo,+std::placeholders::_2,+std::placeholders::_1)%3B%0A++std::cout+%3C%3C+baz(3,+2,+1,+2,+3)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{n1836}{https://wg21.link/n1836}



== lambda et fermeture}
	\begin{block}{Vocabulaire}
		\begin{itemize}
			\item Lambda : fonction anonyme
			\item Fermeture : capture des variables libres de l'environnement lexical
		\end{itemize}
	\end{block}

	\begin{itemize}
		\item ```cpp [capture](paramètres) spécificateurs -> type_retour {instructions}```
	\end{itemize}

	```cpp
		int bar = 4;
		auto foo = [&bar] (int a) -> int { bar *= a; return a; };

		int baz = foo(5);  // bar : 20, baz : 5
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++int+bar+%3D+4%3B%0A++auto+foo+%3D+%5B%26bar%5D+(int+a)+-%3E+int+%7B+bar+*%3D+a%3B+return+a%3B%7D%3B%0A%0A++std::cout+%3C%3C+foo(5)+%3C%3C+!'+!'+%3C%3C+bar+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{N2550}{https://wg21.link/N2550}
	\addproposal{N2658}{https://wg21.link/N2658}
	\addproposal{N2927}{https://wg21.link/N2927}



== lambda et fermeture}
	\begin{itemize}
		\item Capture
		\begin{itemize}
			\item{} ```cpp []``` : pas de capture
			\item{} ```cpp [x]``` : capture x par valeur
			\item{} ```cpp [&y]``` : capture y par référence
			\item{} ```cpp [=]```  : capture tout par valeur
			\item{} ```cpp [&]``` : capture tout par référence
			\item{} ```cpp [x, &y]``` : capture x par valeur et y par référence
			\item{} ```cpp [=, &z]``` : capture z par référence et le reste par copie
			\item{} ```cpp [&, z]``` : capture z par valeur et le reste par référence
		\end{itemize}
		\item La capture de variables membres se fait par la capture de  ```cpp this```
		\begin{itemize}
			\item Soit explicitement via ```cpp [this]```
		\end{itemize}
	\end{itemize}

	\begin{alertblock}{Capture de \mintinline[style=white]{cpp}```this```}
		\begin{itemize}
			\item Capture du pointeur, non de l'objet
		\end{itemize}
	\end{alertblock}

	\begin{itemize}
		\item [] \begin{itemize}
			\item Soit via ```cpp [=]``` ou ```cpp [&]```
		\end{itemize}
	\end{itemize}

	\addproposal{N2550}{https://wg21.link/N2550}
	\addproposal{N2658}{https://wg21.link/N2658}
	\addproposal{N2927}{https://wg21.link/N2927}



== lambda et fermeture}
	\begin{itemize}
		\item Préservation de la constante des variables capturées

\note[item]{Même avec ```cpp mutable```}

		\item Pas de capture des variables globales et statiques
	\end{itemize}

	\begin{alertblock}{Attention}
		\begin{itemize}
			\item Par défaut, les variables capturées par copie ne sont pas modifiables
		\end{itemize}

		```cpp
			int i = 5;

			auto foo = [=] () { cout << ++i << "\n"; };          // Erreur
			auto bar = [=] () mutable { cout << ++i << "\n"; };  // OK
		```

\note[item]{Bien entendu dans le cas de mutable, ce qui est modifié est bien la copie, pas la variable originale}
	\end{alertblock}

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++int+i+%3D+5%3B%0A%0A%23if+1%0A++auto+foo+%3D+%5B%3D%5D+()+%7B+std::cout+%3C%3C+%2B%2Bi+%3C%3C+%22%5Cn%22%3B+%7D%3B%0A++foo()%3B%0A%23endif%0A%0A++auto+bar+%3D+%5B%3D%5D+()+mutable+%7B+std::cout+%3C%3C+%2B%2Bi+%3C%3C+%22%5Cn%22%3B+%7D%3B%0A++bar()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{N2550}{https://wg21.link/N2550}
	\addproposal{N2658}{https://wg21.link/N2658}
	\addproposal{N2927}{https://wg21.link/N2927}



== lambda et fermeture}
	\begin{itemize}
		\item Spécificateurs
		\begin{itemize}
			\item ```cpp mutable``` : modification possible des variables capturées par copie
			\item ```cpp noexcept``` : ne lève pas d'exception
		\end{itemize}

		\item Omission possible du type de retour si
		\begin{itemize}
			\item Unique instruction
			\item Un ```cpp return```
		\end{itemize}

		\item Omission possible d'une liste de paramètres vide
	\end{itemize}

	```cpp
		auto foo = [] { return 5; };
	```

	\begin{alertblock}{Exception}
		\begin{itemize}
			\item Omission impossible si la lambda est ```cpp mutable```
		\end{itemize}
	\end{alertblock}

	\addproposal{N2550}{https://wg21.link/N2550}
	\addproposal{N2658}{https://wg21.link/N2658}
	\addproposal{N2927}{https://wg21.link/N2927}



== lambda, \mintinline[style=white]{cpp}```std::function```, \ldots{} - Conclusion}
	\begin{exampleblock}{Do}
		\begin{itemize}
			\item Préférez les lambdas aux ```cpp std::function```
			\item Préférez les lambdas à ```cpp std::bind()```
		\end{itemize}
	\end{exampleblock}

\note[item]{Les lambdas sont généralement plus efficaces}

	\begin{block}{Motivations}
		\begin{itemize}
			\item Lisibilité, expressivité et performances
			\item Voir \href{https://github.com/boostcon/cppnow_presentations_2016/blob/master/00_tuesday/practical_performance_practices.pdf}{Practical Performance Practices\linklogo}
		\end{itemize}

\note[item]{Entre autres, il y a aussi des remarques intéressantes sur le choix des conteneurs, des pointeurs intelligents, sur ```cpp std::endl```, etc.}
	\end{block}

	\begin{alertblock}{Attention}
		\begin{itemize}
			\item Prenez garde à la durée de vie des variables capturées par référence
		\end{itemize}
	\end{alertblock}



== \mintinline[style=white]{cpp}```std::reference_wrapper```}
	\begin{itemize}
		\item Encapsule un objet en émulant une référence
		\item Construction par ```cpp std::ref()``` et ```cpp std::cref()```
		\item Copiable
	\end{itemize}

	```cpp
		int a{10};
		reference_wrapper<int> aref = ref(a);

		aref++; // a : 11
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cfunctional%3E%0A%0Aint+main()%0A%7B%0A++int+a%7B10%7D%3B%0A%0A++std::reference_wrapper%3Cint%3E+aref+%3D+std::ref(a)%3B%0A++aref%2B%2B%3B%0A++std::cout+%3C%3C+a+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{n1836}{https://wg21.link/n1836}


== Double chevron}
	\begin{itemize}
		\item C++98/03 : ```cpp >>``` est toujours l'opérateur de décalage
		\item C++11 : peut être une double fermeture de template
	\end{itemize}

	```cpp
		vector<vector<int>> foo;
		// Invalide en C++98/03
		// Valide en C++11
	```

\note[item]{En C++98/03, il fallait un espace entre les deux >}

	\begin{itemize}
		\item Utilisation de parenthèses pour forcer l'interprétation en tant qu'opérateur
	\end{itemize}

	```cpp
		vector<array<int, (0x10 >> 3) >> foo;
	```

	\addproposal{N1757}{https://wg21.link/N1757}



== Alias de template}
	\begin{itemize}
		\item En C++98/03, ```cpp typedef``` définit des alias sur des templates
		\item \ldots{} seulement si tous les paramètres templates sont explicites
	\end{itemize}

	```cpp
		template <typename T, typename U, int V>
		class Foo;

		typedef Foo<int, int, 5> Baz;  // OK

		template <typename U>
		typedef Foo<int, U, 5> Bar;    // Incorrect
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Atemplate+%3Ctypename+T,+typename+U,+int+V%3E%0Aclass+Foo%0A%7B%0A%7D%3B%0A%0Atypedef+Foo%3Cint,+int,+5%3E+Baz%3B%0A%0A%23if+0%0Atemplate+%3Ctypename+U%3E%0Atypedef+Foo%3Cint,+U,+5%3E+Bar%3B%0A%23endif%0A%0Aint+main()%0A%7B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{N2258}{https://wg21.link/N2258}



== Alias de template}
	\begin{itemize}
		\item ```cpp using``` permet la création d'alias ne définissant que certains paramètres
	\end{itemize}

	```cpp
		template <typename U>
		using Bar = Foo<int, U, 5>;
	```

	\begin{block}{\mintinline[style=white]{cpp}```using``` de types}
		\begin{itemize}
			\item ```cpp using``` n'est pas réservé aux templates
		\end{itemize}

		```cpp
			using Error = int;
		```
	\end{block}

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Atemplate+%3Ctypename+T,+typename+U,+int+V%3E%0Aclass+Foo%0A%7B%0A%7D%3B%0A%0Ausing+Baz+%3D+Foo%3Cint,+int,+5%3E%3B%0A%0Atemplate+%3Ctypename+U%3E%0Ausing+Bar+%3D+Foo%3Cint,+U,+5%3E%3B%0A%0Aint+main()%0A%7B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{N2258}{https://wg21.link/N2258}



== Extern template}
	\begin{itemize}
		\item Indique que le template est instancié dans une autre unité de compilation
		\item Inutile de l'instancier ici
	\end{itemize}

	```cpp
		extern template class std::vector<int>;
	```

	\begin{block}{Objectif}
		\begin{itemize}
			\item Réduction du temps de compilation
		\end{itemize}
	\end{block}

	\addproposal{N1987}{https://wg21.link/N1987}



== Variadic template}
	\begin{itemize}
		\item Template à nombre de paramètres variable
		\item Définition avec ```cpp typename...```
	\end{itemize}

	```cpp
		template<typename... Args>
		class Foo;
	```

	\begin{itemize}
		\item Récupération de la liste avec ```cpp ...```
	\end{itemize}

	```cpp
		template<typename... Args>
		void bar(Args... parameters);
	```

	\addproposal{N2242}{https://wg21.link/N2242}
	\addproposal{N2555}{https://wg21.link/N2555}



== Variadic template}
	\begin{itemize}
		\item Récupération de la taille avec ```cpp sizeof...```
	\end{itemize}

	```cpp
		template<typename... Args>
		class Foo {
		public:
		  static const unsigned int size = sizeof...(Args);
		};
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%0Atemplate%3Ctypename...+Args%3E%0Aclass+Foo%0A%7B%0Apublic:%0A++static+const+unsigned+int+size+%3D+sizeof...(Args)%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+Foo%3Cint,+int,+long%3E::size+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{N2242}{https://wg21.link/N2242}
	\addproposal{N2555}{https://wg21.link/N2555}



== Variadic template}
	\begin{itemize}
		\item Utilisation récursive par spécialisation
	\end{itemize}

	```cpp
		// Condition d'arret
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

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%0A//+Condition+d!'arret%0Atemplate%3Ctypename+T%3E%0AT+sum(T+val)%0A%7B%0A++return+val%3B%0A%7D%0A%0Atemplate%3Ctypename+T,+typename...+Args%3E%0AT+sum(T+val,+Args...+values)%0A%7B%0A++return+val+%2B+sum(values...)%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+sum(1,+5,+56,+9)+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+sum(std::string(%22Un%22),+std::string(%22Deux%22))+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{N2242}{https://wg21.link/N2242}
	\addproposal{N2555}{https://wg21.link/N2555}



== Variadic template}
	\begin{itemize}
		\item Ou expansion sur une expression et une fonction d'expansion
	\end{itemize}

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

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%0Atemplate%3Ctypename...+T%3E+%0Avoid+pass(T%26%26...)%0A%7B%0A%7D%0A%0Aint+total+%3D+0%3B%0Aint+foo(int+i)%0A%7B%0A++total+%2B%3D+i%3B%0A++return+i%3B%0A%7D%0A%0Atemplate%3Ctypename...+T%3E%0Aint+sum(T...+t)%0A%7B%0A++pass((foo(t))...)%3B+%0A++return+total%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+sum(1,+2,+3,+5)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{N2242}{https://wg21.link/N2242}
	\addproposal{N2555}{https://wg21.link/N2555}



== Variadic template}
	\begin{alertblock}{Contraintes de l'expansion}
		\begin{itemize}
			\item Paramètre unique
			\item Ne retournant pas ```cpp void```
			\item Pas d'ordre garanti
		\end{itemize}
	\end{alertblock}

	\begin{itemize}
		\item Candidat naturel ```cpp std::initializer_list```
		\item \ldots{} constructible depuis un \textit{variadic template}
	\end{itemize}

	```cpp
		template<typename... T>
		int foo(T... t) {
		  initializer_list<int>{ t... };
		}

		foo(1, 2, 3, 5);
	```

	\addproposal{N2242}{https://wg21.link/N2242}
	\addproposal{N2555}{https://wg21.link/N2555}



== Variadic template}
	\begin{itemize}
		\item \ldots{} qui règle le problème de l'ordre
	\end{itemize}

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

\note[item]{,0 permet de régler le souci du retour void}

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aint+total+%3D+0%3B%0Aint+foo(int+i)%0A%7B%0A++total+%2B%3D+i%3B%0A++return+i%3B%0A%7D%0A%0Atemplate%3Ctypename...+T%3E%0Aint+sum(T...+t)%0A%7B%0A++std::initializer_list%3Cint%3E%7B+(foo(t),+0)...+%7D%3B%0A++return+total%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+sum(1,+2,+3,+5)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{N2242}{https://wg21.link/N2242}
	\addproposal{N2555}{https://wg21.link/N2555}



== Variadic template}
	\begin{itemize}
		\item \ldots{} sur n'importe quelle expression prenant un paramètre

\note[item]{Donc appelle de fonction ou lambda mais aussi simple expression}
	\end{itemize}

	```cpp
		template<typename... T>
		auto sum(T... t) {
		  typename common_type<T...>::type result{};
		  initializer_list<int>{ (result += t, 0)... };
		  return result;
		}

		sum(1, 2, 3, 5);  // 11
	```

	```cpp
		template<typename... T>
		void print(T... t) {
		  initializer_list<int>{ (cout << t << " ", 0)... };
		}

		print(1, 2, 3, 5);
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%0Atemplate%3Ctypename+...+T%3E%0Atypename+std::common_type%3CT...%3E::type+sum(T+...+t)%0A%7B%0A++typename+std::common_type%3CT...%3E::type+result%7B%7D%3B%0A++std::initializer_list%3Cint%3E%7B+(result+%2B%3D+t,+0)...+%7D%3B%0A++return+result%3B%0A%7D%0A%0Atemplate%3Ctypename+...+T%3E%0Avoid+print(T+...+t)%0A%7B%0A++std::initializer_list%3Cint%3E%7B+(std::cout+%3C%3C+t+%3C%3C+%22+%22,+0)...+%7D%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+sum(1,+2,+3,+5)+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+sum(std::string(%22Un%22),+std::string(%22Deux%22))+%3C%3C+!'%5Cn!'%3B%0A%0A++print(1,+2,+3,+5)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{N2242}{https://wg21.link/N2242}
	\addproposal{N2555}{https://wg21.link/N2555}



== \mintinline[style=white]{cpp}```std::enable_if```}
	\begin{itemize}
		\item Classe template sur une expression booléenne et un type
		\item Définition du type seulement si l'expression booléenne est vraie
		\item Templates disponibles uniquement pour certains types
	\end{itemize}

	```cpp
		template<class T,
		typename enable_if<is_integral<T>::value, T>::type* = nullptr>
		void foo(T data) { }

		foo(42);
		foo("azert");    // Erreur
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ctype_traits%3E%0A%0Atemplate%3Cclass+T,+typename+std::enable_if%3Cstd::is_integral%3CT%3E::value,+T%3E::type*+%3D+nullptr%3E%0Avoid+foo(T+data)%0A%7B%0A++std::cout+%3C%3C+data+%3C%3C+%22%5Cn%22%3B%0A%7D%0A%0Atemplate%3Cclass+T,+typename+std::enable_if%3C!!std::is_integral%3CT%3E::value,+T%3E::type*+%3D+nullptr%3E%0Avoid+bar(T)%0A%7B%0A++std::cout+%3C%3C+%22Generique%5Cn%22%3B%0A%7D%0A%0Atemplate%3Cclass+T,typename+std::enable_if%3Cstd::is_integral%3CT%3E::value,+T%3E::type*+%3D+nullptr%3E%0Avoid+bar(T)%0A%7B%0A++std::cout+%3C%3C+%22Entier%5Cn%22%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++foo(42)%3B%0A%23if+0%0A++foo(%22azert%22)%3B%0A%23endif%0A%0A++bar(42)%3B%0A++bar(%22azert%22)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== Types locaux en arguments templates}
	\begin{itemize}
		\item Utilisation des types locaux non-nommés comme arguments templates
	\end{itemize}

	```cpp
		vector<int> foo)
		struct Less {
		  bool operator()(int a, int b) { return a < b; }
		};

		sort(foo.begin(), foo.end(), Less());
	```

	\begin{itemize}
		\item Y compris des lambdas
	\end{itemize}

	```cpp
		sort(foo.begin(), foo.end(),
		     [] (int a, int b) { return a < b; });
 	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B5,+2,+8,+12,+3%7D%3B%0A++std::sort(foo.begin(),+foo.end(),+%5B%5D+(int+a,+int+b)+%7B+return+a+%3C+b%3B+%7D)%3B%0A%0A++for(size_t+i+%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+%22+%22%3B%0A++%7D%0A++std::cout+%3C%3C+%22%5Cn%22%3B%0A%7D%0A%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Astruct+Less%0A%7B%0A++bool+operator()(int+a,+int+b)%0A++%7B%0A++++return+a+%3C+b%3B%0A++%7D%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B5,+2,+8,+12,+3%7D%3B%0A++std::sort(foo.begin(),+foo.end(),+Less())%3B%0A%0A++for(size_t+i+%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+%22+%22%3B%0A++%7D%0A++std::cout+%3C%3C+%22%5Cn%22%3B%0A%7D%0A%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

 	\addproposal{N2657}{https://wg21.link/N2657}


== Type traits -- Helper}
	\begin{itemize}
		\item Constante \textit{compile-time} ```cpp std::integral_constant```
		\item ```cpp std::integral_constant``` booléen vrai ```cpp true_type```
		\item ```cpp std::integral_constant``` booléen faux ```cpp false_type```
	\end{itemize}

	```cpp
		template <unsigned n>
		struct factorial
		  : integral_constant<int, n*factorial<n-1>::value> {};

		template <>
		struct factorial<0>
		  : integral_constant<int, 1> {};

		factorial<5>::value;  // 120 en compile-time
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ctype_traits%3E%0A%0Atemplate+%3Cunsigned+n%3E%0Astruct+factorial+:+std::integral_constant%3Cint,+n*factorial%3Cn-1%3E::value%3E+%0A%7B%7D%3B%0A%0Atemplate+%3C%3E%0Astruct+factorial%3C0%3E+:+std::integral_constant%3Cint,+1%3E%0A%7B%7D%3B%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+factorial%3C5%3E::value+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{n1836}{https://wg21.link/n1836}



== Type traits -- Trait}
	\begin{itemize}
		\item Détermine, à la compilation, les caractéristiques des types
		\item ```cpp std::is_array``` : tableau C
	\end{itemize}

	```cpp
		is_array<int>::value;        // false
		is_array<int[3]>::value;     // true
	```

	\begin{itemize}
		\item ```cpp std::is_integral``` : type entier
	\end{itemize}

	```cpp
		is_integral<short>::value;   // true
		is_integral<string>::value;  // false
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%23include+%3Ctype_traits%3E%0A%0Aint+main()%0A%7B%0A%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_array%3Cint%3E::value+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_array%3Cint%5B3%5D%3E::value+%3C%3C+!'%5Cn!'%3B%0A%0A++std::cout+%3C%3C+std::is_integral%3Cshort%3E::value+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::is_integral%3Cstd::string%3E::value+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{n1836}{https://wg21.link/n1836}



== Type traits -- Trait}
	\begin{itemize}
		\item ```cpp std::is_fundamental``` : type fondamental (entier, réel, ```cpp void``` ou ```cpp nullptr_t```)
	\end{itemize}

	```cpp
		is_fundamental<short>::value;   // true
		is_fundamental<string>::value;  // false
		is_fundamental<void*>::value;   // false
	```

	\begin{itemize}
		\item ```cpp std::is_const``` : type constant
	\end{itemize}

	```cpp
		is_const<const short>::value;  // true
		is_const<string>::value;       // false
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%23include+%3Ctype_traits%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_fundamental%3Cshort%3E::value+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_fundamental%3Cstd::string%3E::value+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_fundamental%3Cvoid*%3E::value+%3C%3C+!'%5Cn!'%3B%0A%0A++std::cout+%3C%3C+std::is_const%3Cconst+short%3E::value+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::is_const%3Cstd::string%3E::value+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{n1836}{https://wg21.link/n1836}



== Type traits -- Trait}
	\begin{itemize}
		\item ```cpp std::is_base_of``` : base d'un autre type
	\end{itemize}

	```cpp
		struct Foo {};
		struct Bar : Foo {};

		is_base_of<int, int>::value;        // false
		is_base_of<string, string>::value;  // true
		is_base_of<Foo, Bar>::value;        // true
		is_base_of<Bar, Foo>::value;        // false
	```

	\begin{itemize}
		\item Et bien d'autres \ldots{}
	\end{itemize}

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%23include+%3Ctype_traits%3E%0A%0Astruct+Foo%0A%7B%7D%3B%0A%0Astruct+Bar+:+Foo%0A%7B%7D%3B%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_base_of%3Cint,+int%3E::value+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_base_of%3Cstd::string,+std::string%3E::value+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_base_of%3CFoo,+Bar%3E::value+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_base_of%3CBar,+Foo%3E::value+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{n1836}{https://wg21.link/n1836}



== Type traits -- Transformations}
	\begin{itemize}
		\item Construction d'un type par transformation d'un type existant
		\item ```cpp std::add_const``` : type ```cpp const```
	\end{itemize}

	```cpp
		typedef add_const<int>::type A;         // const int
		typedef add_const<const int>::type B;   // const int
		typedef add_const<const int*>::type C;  // const int* const
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ctype_traits%3E%0A%0Atypedef+std::add_const%3Cint%3E::type+A%3B%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_const%3CA%3E::value+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{n1836}{https://wg21.link/n1836}



== Type traits -- Transformations}
	\begin{itemize}
		\item ```cpp std::make_unsigned``` : type non signé correspondant
	\end{itemize}

	```cpp
		enum Foo {bar};

		typedef make_unsigned<int>::type A;             // unsigned int
		typedef make_unsigned<unsigned>::type B;        // unsigned int
		typedef make_unsigned<const unsigned>::type C;  // const unsigned int
		typedef make_unsigned<Foo>::type D;             // unsigned int
	```

	\begin{itemize}
		\item Et bien d'autres \ldots{}
	\end{itemize}

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ctype_traits%3E%0A%0Aenum+Foo%0A%7B%0A++bar%0A%7D%3B%0A%0Atypedef+std::make_unsigned%3Cint%3E::type+A%3B%0Atypedef+std::make_unsigned%3CFoo%3E::type+B%3B%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_unsigned%3Cint%3E::value+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_unsigned%3CFoo%3E::value+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_unsigned%3CA%3E::value+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_unsigned%3CB%3E::value+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{n1836}{https://wg21.link/n1836}


== Pointeurs intelligents}
	\begin{itemize}
		\item RAII appliqué aux pointeurs et aux ressources allouées
		\item Objets à sémantique de pointeur gérant la durée de vie des objets
		\item Garantie de libération
		\item Garantie de cohérence
		\item Historiquement
		\begin{itemize}
			\item ```cpp std::auto_ptr```
			\item ```cpp boost::scoped_ptr``` et ```cpp boost::scoped_array```
		\end{itemize}
	\end{itemize}



== Pointeurs intelligents -- \mintinline[style=white]{cpp}```std::unique_ptr```}
	\begin{itemize}
		\item Responsabilité exclusive
		\item Non copiable, mais déplaçable
		\item Testable
	\end{itemize}

	```cpp
		unique_ptr<int> p(new int);
		*p = 42;
	```

	\begin{itemize}
		\item ```cpp release()``` relâche la responsabilité de la ressource

\note[item]{La ressource n'est pas libérée, mais le pointeur n'en a plus la responsabilité (pointeur brut retourné)}

		\item ```cpp reset()``` change la ressource possédée

\note[item]{L'objet précédemment pointé est libéré}
\note[item]{Possible de fournir un pointeur ```cpp nullptr``` à ```cpp reset()``` (valeur par défaut) pour simplement libérer l'objet contenu}

		\item ```cpp get()``` récupère un pointeur brut sur la ressource

\note[item]{P.ex. pour appeler une API C}
	\end{itemize}

	\begin{alertblock}{Attention}
		\begin{itemize}
			\item Ne pas utilisez le pointeur retourné par ```cpp get()``` pour libérer la ressource
		\end{itemize}
	\end{alertblock}



== Pointeurs intelligents -- \mintinline[style=white]{cpp}```std::unique_ptr```}
	\begin{itemize}
		\item Fourniture possible de la fonction de libération
	\end{itemize}

	```cpp
		FILE *fp = fopen("foo.txt", "w");
		unique_ptr<FILE, int(*)(FILE*)> p(fp, &fclose);
	```

	\begin{itemize}
		\item Spécialisation pour les tableaux C
		\begin{itemize}
			\item Sans ```cpp *``` et ```cpp ->```
			\item Mais avec ```cpp []```
		\end{itemize}
	\end{itemize}

	```cpp
		std::unique_ptr<int[]> foo (new int[5]);
		for(int i=0; i<5; ++i) foo[i] = i;
	```

	\begin{block}{Dépréciation}
		\begin{itemize}
			\item Dépréciation de ```cpp std::auto_ptr```
		\end{itemize}
	\end{block}



== Pointeurs intelligents -- \mintinline[style=white]{cpp}```std::shared_ptr```}
	\begin{itemize}
		\item Responsabilité partagée de la ressource
		\item Comptage de références
		\item Copiable (incrémentation du compteur de références)
		\item Testable
	\end{itemize}

	```cpp
		shared_ptr<int> p(new int());
		*p = 42;
	```

	\begin{itemize}
		\item ```cpp reset()``` change la ressource possédée

\note[item]{Avec ajustement des compteurs de références et libération si nécessaire}

		\item ```cpp use_count()``` retourne le nombre de possesseurs de la ressource
		\item ```cpp unique()``` indique si la possession est unique
		\item Fourniture possible de la fonction de libération
	\end{itemize}

	\addproposal{n1836}{https://wg21.link/n1836}



== Pointeurs intelligents -- \mintinline[style=white]{cpp}```std::make_shared()```}
	\begin{itemize}
		\item Allocation et construction de l'objet dans le ```cpp std::shared_ptr```
	\end{itemize}

	```cpp
		shared_ptr<int> p = make_shared<int>(42);
	```

	\begin{block}{Objectifs}
		\begin{itemize}
			\item Pas de ```cpp new``` explicite, plus robuste
		\end{itemize}

		```cpp
			// Fuite possible en cas d'exception depuis bar()
			foo(shared_ptr<int>(new int(42)), bar());
		```

		\begin{itemize}
			\item Allocation unique pour la ressource et le compteur de référence
		\end{itemize}
	\end{block}

	\begin{exampleblock}{Do}
		\begin{itemize}
			\item Utilisez ```cpp std::make_shared()``` pour construire vos ```cpp std::shared_ptr```
		\end{itemize}
	\end{exampleblock}



== Pointeurs intelligents -- \mintinline[style=white]{cpp}```std::weak_ptr```}
	\begin{itemize}
		\item Aucune responsabilité sur la ressource
		\item Collabore avec ```cpp std::shared_ptr```
		\item \ldots{} sans impact sur le comptage de références
		\item Pas de création depuis un pointeur nu
	\end{itemize}

	\begin{block}{Objectif}
		\begin{itemize}
			\item Rompre les cycles
		\end{itemize}
	\end{block}

	```cpp
		shared_ptr<int> sp(new int(20));
		weak_ptr<int> wp(sp);
	```

	\addproposal{n1836}{https://wg21.link/n1836}



== Pointeurs intelligents -- \mintinline[style=white]{cpp}```std::weak_ptr```}
	\begin{itemize}
		\item Pas d'accès à la ressource
		\item Convertible en ```cpp std::shared_ptr``` via ```cpp lock()```

\note[item]{Retourne un ```cpp std::shared_ptr``` vide si la ressource n'existe plus}
	\end{itemize}

	```cpp
		shared_ptr<int> sp = wp.lock();
	```

	\begin{itemize}
		\item ```cpp reset()``` vide le pointeur
		\item ```cpp use_count()``` retourne le nombre de possesseurs de la ressource

\note[item]{Possesseurs aux nombres desquels notre ```cpp std::weak_ptr``` n'appartient pas}

		\item ```cpp expired()``` indique si le ```cpp std::weak_ptr``` ne référence plus une ressource valide

\note[item]{Soit il pointe sur rien, soit la ressource a été libérée car n'avait plus de ```cpp std::shared_ptr``` sur elle}
	\end{itemize}

	\addproposal{n1836}{https://wg21.link/n1836}



== Pointeurs intelligents -- Conclusion}
	\begin{alertblock}{Don't}
		\begin{itemize}
			\item N'utilisez pas de pointeurs bruts possédants
		\end{itemize}
	\end{alertblock}

	\begin{exampleblock}{Do}
		\begin{itemize}
			\item Réfléchissez à la responsabilité de vos ressources
		\end{itemize}
	\end{exampleblock}

	\begin{exampleblock}{Do}
		\begin{itemize}
			\item Préférez ```cpp std::unique_ptr``` à ```cpp std::shared_ptr```
			\item Préférez une responsabilité unique à une responsabilité partagée
		\end{itemize}
	\end{exampleblock}



== Pointeurs intelligents -- Conclusion}
	\begin{exampleblock}{Do}
		\begin{itemize}
			\item Brisez les cycles à l'aide de ```cpp std::weak_ptr```
		\end{itemize}
	\end{exampleblock}

	\begin{alertblock}{Attention}
		\begin{itemize}
			\item Passez par un ```cpp std::unique_ptr``` temporaire intermédiaire pour insérer des éléments dans un conteneur de ```cpp std::unique_ptr```
			\item Voir \href{https://accu.org/index.php/journals/2271}{Overload 134 - C++ Antipatterns\linklogo}
		\end{itemize}

\note[item]{```cpp push_back``` d'un pointeur brute n'est pas possible et ```cpp emplace_back``` peut échouer en laissant fuir le pointeur}
	\end{alertblock}

	\begin{exampleblock}{Do}
		\begin{itemize}
			\item Transférez au plus tôt la responsabilité à un pointeur intelligent
		\end{itemize}
	\end{exampleblock}



== Pointeurs intelligents -- Conclusion}
	\begin{block}{Pour aller plus loin}
		\begin{itemize}
			\item Voir \href{http://loic-joly.developpez.com/tutoriels/cpp/smart-pointers/}{Pointeurs intelligents\linklogo (Loïc Joly)}
		\end{itemize}
	\end{block}

	\begin{block}{Sous silence}
		\begin{itemize}
			\item Allocateurs, mémoire non-initialisée, alignement, \ldots{}
		\end{itemize}
	\end{block}

	\begin{block}{Mais aussi}
		\begin{itemize}
			\item Support minimal des \textit{Garbage Collector}

\note[item]{Support enlevé en C++23 : trop restrictif, inutilisé, conceptions très différentes et variés dans les langages à GC}

			\item Mais pas de GC standard
		\end{itemize}
	\end{block}


== Attributs}
	\begin{itemize}
		\item Syntaxe standard pour les directives de compilation \textit{inlines}
		\item \ldots{} y compris celles spécifiques à un compilateur
		\item Remplace la directive ```cpp #pragma```
		\item Et les mots-clé propriétaires (```cpp __attribute__```, ```cpp __declspec```)
	\end{itemize}

	```cpp
		[[ attribut ]]
	```

	\begin{itemize}
		\item Peut être multiple
	\end{itemize}

	```cpp
		[[ attribut1, attribut2 ]]
	```

	\addproposal{N2761}{https://wg21.link/N2761}



== Attributs}
	\begin{itemize}
		\item Peut prendre des arguments
	\end{itemize}

	```cpp
		[[ attribut(arg1, arg2) ]]
	```

	\begin{itemize}
		\item Peut être dans un namespace et spécifique à une implémentation
	\end{itemize}

	```cpp
		[[ vendor::attribut ]]
	```

	\begin{block}{Exemple}
		les attributs ```cpp gsl``` des \og C++ Core Guidelines Checker\fg{} de Microsoft

		```cpp
			[[ gsl::suppress(26400) ]]
		```
	\end{block}

	\addproposal{N2761}{https://wg21.link/N2761}



== Attributs}
	\begin{itemize}
		\item Placé après le nom pour les entités nommées
	\end{itemize}

	```cpp
		int [[ attribut1 ]] i [[ attribut2 ]];
		// Attribut1 s'applique au type
		// Attribut2 s'applique a i
	```

	\begin{itemize}
		\item Placé avant l'entité sinon
	\end{itemize}

	```cpp
		[[ attribut ]] return i;
		// Attribut s'applique au return
	```

	\begin{exampleblock}{Bonus}
		\begin{itemize}
			\item Aussi une information à destination des développeurs
		\end{itemize}
	\end{exampleblock}

	\addproposal{N2761}{https://wg21.link/N2761}



== Attribut \mintinline[style=white]{cpp}```[[ noreturn ]]```}
	\begin{itemize}
		\item Indique qu'une fonction ne retourne pas
	\end{itemize}

	```cpp
		[[ noreturn ]] void foo() { throw "error"; }
	```

	\begin{alertblock}{Attention}
		\begin{itemize}
			\item Qui ne retourne pas
			\item Pas qui ne retourne rien
		\end{itemize}
	\end{alertblock}

	\begin{block}{Usage}
		\begin{itemize}
			\item Boucle infinie, sortie de l'application, exception systématique
		\end{itemize}
	\end{block}

	\begin{block}{Sous silence}
		\begin{itemize}
			\item ```cpp [[ carries_dependency ]]```
		\end{itemize}
	\end{block}

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cexception%3E%0A%0A%5B%5B+noreturn+%5D%5D+void+foo()%0A%7B%0A%23if+0%0A++throw+std::runtime_error(%22foo%22)%3B%0A%23endif%0A%7D%0A%0Aint+main()%0A%7B%0A++foo()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}


== Rapport}

\note[item]{La rapport est dans le type, pas dans les valeurs ou les instances}

	\begin{itemize}
		\item ```cpp std::ratio``` représente un rapport entre deux nombres
		\item Numérateur et dénominateur sont des paramètres templates
		\item ```cpp num``` accède au numérateur
		\item ```cpp den``` accède au dénominateur
	\end{itemize}

	```cpp
		ratio<6, 2> r;
		cout << r.num << "/" << r.den;   // 3/1
	```

	\begin{itemize}
		\item Instanciations standards des préfixes du système international d'unités
		\begin{itemize}
			\item yocto, zepto, atto, femto, pico, nano, micro, milli, centi, déci
			\item déca, hecto, kilo, méga, giga, téra, péta, exa, zetta, yotta
		\end{itemize}
	\end{itemize}

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cratio%3E%0A%0Aint+main()%0A%7B%0A++std::ratio%3C6,+2%3E+r%3B%0A++std::cout+%3C%3C+r.num+%3C%3C+!'/!'+%3C%3C+r.den+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== Rapport}
	\begin{itemize}
		\item Méta-fonctions arithmétiques
		\begin{itemize}
			\item ```cpp std::ratio_add()```, ```cpp std::ratio_subtract()```
			\item ```cpp std::ratio_multiply()```, ```cpp std::ratio_divide()```
		\end{itemize}

\note[item]{Méta car elles agissent sur les types et non sur les valeurs}
	\end{itemize}

	```cpp
		ratio_add<ratio<6, 2>, ratio<2, 3>> r;
		cout << r.num << "/" << r.den;   // 11/3
	```

	\begin{itemize}
		\item Méta-fonctions de comparaison
		\begin{itemize}
			\item ```cpp std::ratio_equal()```, ```cpp std::ratio_not_equal()```
			\item ```cpp std::ratio_less()```, ```cpp std::ratio_less_equal()```
			\item ```cpp std::ratio_greater()``` et ```cpp std::ratio_greater_equal()```
		\end{itemize}
	\end{itemize}

	```cpp
		ratio_less_equal<ratio<6, 2>, ratio<2, 3>>::value;  // false
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cratio%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::boolalpha+%0A++++++++++++%3C%3C+std::ratio_less_equal%3Cstd::ratio%3C6,+2%3E,+std::ratio%3C2,+3%3E%3E::value+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cratio%3E%0A%0Aint+main()%0A%7B%0A++std::ratio_add%3Cstd::ratio%3C6,+2%3E,+std::ratio%3C2,+3%3E%3E+r%3B%0A%0A++std::cout+%3C%3C+r.num+%3C%3C+!'/!'+%3C%3C+r.den+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}


== Durées}
	\begin{itemize}
		\item Classe template ```cpp std::chrono::duration```
		\item Unité dépendante d'un ratio avec la seconde
		\item Instanciations standards \textit{hours}, \textit{minutes}, \textit{seconds}, \textit{milliseconds}, \textit{microseconds} et \textit{nanosecond}
	\end{itemize}

	```cpp
		milliseconds foo(12000);  // 12000 ms
		foo.count();              // 12000
	```

	\begin{itemize}
		\item ```cpp count()``` retourne la valeur
		\item ```cpp period``` est le type représentant le ratio
	\end{itemize}

	```cpp
		milliseconds foo(12000);
		foo.count() * milliseconds::period::num /
		              milliseconds::period::den;  // 12
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cchrono%3E%0A%0Aint+main()%0A%7B%0A++std::chrono::milliseconds+foo(12000)%3B%0A%0A++std::cout+%3C%3C+foo.count()+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+foo.count()+*+std::chrono::milliseconds::period::num+/+std::chrono::milliseconds::period::den+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== Durées}
	\begin{itemize}
		\item Opérateurs de manipulation des durées (ajout, suppression, \ldots{})
	\end{itemize}

	```cpp
		milliseconds foo(500);
		milliseconds bar(10);
		foo += bar;   // 510
		foo /= 2;     // 255
	```

	\begin{itemize}
		\item Opérateurs de comparaison entre durées
		\item ```cpp zero()``` crée une durée nulle
		\item ```cpp min()``` crée la plus petite valeur possible
		\item ```cpp max()``` crée la plus grande valeur possible
	\end{itemize}

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cchrono%3E%0A%0Aint+main()%0A%7B%0A++std::chrono::milliseconds+foo(500)%3B%0A++std::chrono::milliseconds+bar(10)%3B%0A%0A++foo+%2B%3D+bar%3B%0A++std::cout+%3C%3C+foo.count()+%3C%3C+!'%5Cn!'%3B%0A%0A++foo+/%3D+2%3B%0A++std::cout+%3C%3C+foo.count()+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== Temps relatif}
	\begin{itemize}
		\item ```cpp std::chrono::time_point``` temps relatif depuis l'epoch
	\end{itemize}

	\begin{block}{Epoch}
		\begin{itemize}
			\item Origine des temps de l'OS (1 janvier 1970 00h00 sur Unix)
		\end{itemize}
	\end{block}

	\begin{itemize}
		\item ```cpp time_since_epoch()``` retourne la durée depuis l'epoch
		\item Opérateurs d'ajout et de suppression d'une durée
		\item Opérateurs de comparaison entre ```cpp time_point```
		\item ```cpp min()``` retourne le plus petit temps relatif
		\item ```cpp max()``` retourne le plus grand temps relatif
	\end{itemize}



== Horloges}
	\begin{itemize}
		\item Horloge temps-réel du système ```cpp std::chrono::system_clock```
		\item ```cpp now()``` récupère temps courant
	\end{itemize}

	```cpp
		system_clock::time_point today = system_clock::now();
		today.time_since_epoch().count();
	```

	\begin{itemize}
		\item ```cpp to_time_t()``` converti en ```cpp time_t```
		\item ```cpp fromtime_t()``` construit depuis ```cpp time_t```
	\end{itemize}

	```cpp
		system_clock::time_point today = system_clock::now();
		time_t tt = system_clock::to_time_t(today);
		ctime(&tt);
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cchrono%3E%0A%0Aint+main()%0A%7B%0A++std::chrono::system_clock::time_point+today+%3D+std::chrono::system_clock::now()%3B%0A%0A++time_t+tt+%3D+std::chrono::system_clock::to_time_t(today)%3B%0A++std::cout+%3C%3C+ctime(%26tt)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cchrono%3E%0A%0Aint+main()%0A%7B%0A++std::chrono::system_clock::time_point+today+%3D+std::chrono::system_clock::now()%3B%0A++std::cout+%3C%3C+today.time_since_epoch().count()+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== Horloges}
	\begin{itemize}
		\item Horloge monotone de mesure des intervalles ```cpp std::chrono::steady_clock```

\note[item]{Monotone, c'est à dire que cette horloge n'est jamais réglée, en particulier une mise à l'heure durant la mesure n'a pas d'impact sur la mesure}
\note[item]{Pas le cas de ```cpp std::chrono::system_clock``` qui mesure le temps par rapport à epoch et dont la valeur est impactée par la mise à l'heure}
\note[item]{A priori, sous Linux, pas d'appel système pour récupérer la valeur}

		\item ```cpp now()``` récupère temps courant
	\end{itemize}

	```cpp
		steady_clock::time_point t1 = steady_clock::now();
		...
		steady_clock::time_point t2 = steady_clock::now();
		duration<double> time_span =
		duration_cast<duration<double>>(t2 - t1);
	```



== Horloges}
	\begin{itemize}
		\item Horloge avec le plus petit intervalle entre deux \textit{ticks} ```cpp std::chrono::high_resolution_clock```
		\item Possible synonyme de ```cpp std::chrono::system_clock``` ou ```cpp std::chrono::steady_clock```
	\end{itemize}

	\begin{exampleblock}{Do}
		\begin{itemize}
			\item Préférez ```cpp std::clock::duration``` aux entiers pour manipuler les durées
		\end{itemize}
	\end{exampleblock}

	\begin{alertblock}{Attention}
		\begin{itemize}
			\item N'espérez pas une précision arbitrairement grande des horloges
		\end{itemize}
	\end{alertblock}


== Thread Local Storage}
	\begin{itemize}
		\item Spécificateur de classe de stockage ```cpp thread_local```
		\item Influant sur la durée de stockage
		\item Compatible avec ```cpp static``` et ```cpp extern```
		\item Rend propres au thread des objets normalement partagés

\note[item]{Typiquement des variables globales ou statiques}
\note[item]{C'est à dire qu'il y a une instance de la variable par thread}

		\item Instance propre au thread créée à la création du thread
		\item Valeur initiale héritée du thread créateur
	\end{itemize}

	```cpp
		thread_local int foo = 0;
	```

	\addproposal{N2659}{https://wg21.link/N2659}



== Variables atomiques -- \mintinline[style=white]{cpp}```std::atomic```}
	\begin{itemize}
		\item Encapsulation de types de base fournissant des opérations atomiques
		\item Atomicité de l'affectation, de l'incrémentation et de la décrémentation
	\end{itemize}

	```cpp
		atomic<int> foo{5};
		++foo;
	```

	\begin{itemize}
		\item ```cpp store()``` stocke une nouvelle valeur
		\item ```cpp load()``` lit la valeur
		\item ```cpp exchange()``` met à jour et retourne la valeur avant modification
	\end{itemize}

	\addproposal{N2427}{https://wg21.link/N2427}



== Variables atomiques -- \mintinline[style=white]{cpp}```std::atomic```}
	\begin{itemize}
		\item ```cpp compare_exchange_weak``` et ```cpp compare_exchange_strong```

\note[item]{Différence \textit{weak} / \textit{strong} : \textit{weak} peu échouer dans certains cas. Lorsque cela se produit, aucune valeur n'est modifiée}

		\begin{itemize}
			\item Si ```cpp std::atomic``` est égal à la valeur attendue, il est mis à jour avec une valeur fournie
			\item Sinon, il n'est pas modifié et la valeur attendue prends la valeur de ```cpp std::atomic```
		\end{itemize}
	\end{itemize}

	```cpp
		atomic<int> foo{5};
		int bar{5};

		foo.compare_exchange_strong(bar, 10);  // foo : 10, bar : 5
		foo.compare_exchange_strong(bar, 8);   // foo : 10, bar : 10
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Catomic%3E%0A%0Aint+main()%0A%7B%0A++std::atomic%3Cint%3E+foo%7B5%7D%3B%0A++int+bar%7B5%7D%3B%0A%0A++foo.compare_exchange_strong(bar,+10)%3B%0A++std::cout+%3C%3C+foo+%3C%3C+%22+%22+%3C%3C+bar+%3C%3C+%22%5Cn%22%3B%0A++foo.compare_exchange_strong(bar,+8)%3B%0A++std::cout+%3C%3C+foo+%3C%3C+%22+%22+%3C%3C+bar+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== Variables atomiques -- \mintinline[style=white]{cpp}```std::atomic```}
	\begin{itemize}
		\item ```cpp fetch_add()``` addition et retour de la valeur avant modification
	\end{itemize}

	```cpp
		atomic<int> foo{5};

		cout << foo.fetch_add(10) << " ";
		cout << foo;        // Affiche 5 15
	```

	\begin{itemize}
		\item ```cpp fetch_sub()``` soustraction et retour de la valeur avant modification
		\item ```cpp fetch_and()``` et binaire et retour de la valeur avant modification
		\item ```cpp fetch_or()``` ou binaire et retour de la valeur avant modification
		\item ```cpp fetch_xor()``` ou exclusif et retour de la valeur avant modification
	\end{itemize}

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Catomic%3E%0A%0Aint+main()%0A%7B%0A++std::atomic%3Cint%3E+foo%7B5%7D%3B%0A%0A++std::cout+%3C%3C+foo.fetch_add(10)+%3C%3C+%22+%22%3B%0A++std::cout+%3C%3C+foo%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== Variables atomiques -- \mintinline[style=white]{cpp}```std::atomic```}
	\begin{itemize}
		\item Plusieurs instanciations standards (```cpp std::atomic_bool```, ```cpp std::atomic_int```, \ldots{})
	\end{itemize}

	\begin{block}{Mais aussi}
		\begin{itemize}
			\item Plusieurs fonctions \og C-style\fg{}, similaires aux fonctions membres de ```cpp std::atomic```, manipulant atomiquement des données
		\end{itemize}
	\end{block}



== Variables atomiques -- \mintinline[style=white]{cpp}```std::atomic_flag```}
	\begin{itemize}
		\item Gestion atomique de \textit{flags}
		\item Non copiable, non déplaçable, \textit{lock free}
		\item ```cpp clear()``` remet à 0 le \textit{flag}
		\item ```cpp test_and_set()``` lève le \textit{flag} et retourne sa valeur avant modification
	\end{itemize}

	```cpp
		atomic_flag foo = ATOMIC_FLAG_INIT;

		foo.test_and_set();  // false
		foo.test_and_set();  // true
		foo.clear();
		foo.test_and_set();  // false
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Catomic%3E%0A%0Aint+main()%0A%7B%0A++std::atomic_flag+foo+%3D+ATOMIC_FLAG_INIT%3B%0A%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+foo.test_and_set()+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+foo.test_and_set()+%3C%3C+%22%5Cn%22%3B%0A++foo.clear()%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+foo.test_and_set()+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== Threads -- \mintinline[style=white]{cpp}```std::thread```}
	\begin{itemize}
		\item Représente un fil d'exécution
		\item Déplaçable mais non copiable
		\item Constructible depuis une fonction et sa liste de paramètre
	\end{itemize}

	```cpp
		void foo(int);

		thread t(foo, 10);
	```

	\begin{itemize}
		\item Thread initialisé démarre immédiatement
		\item ```cpp joignable()``` indique si le thread est joignable
		\begin{itemize}
			\item Pas construit par défaut
			\item Pas été déplacé
			\item Ni joint ni détaché
		\end{itemize}
	\end{itemize}



== Threads -- \mintinline[style=white]{cpp}```std::thread```}
	\begin{itemize}
		\item ```cpp join()``` attend la fin d'exécution du thread
		\item ```cpp detach()``` détache le thread
	\end{itemize}

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

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cthread%3E%0A%23include+%3Cchrono%3E%0A%0Avoid+foo(size_t+imax)%0A%7B%0A++for(size_t+i+%3D+0%3B+i+%3C+imax%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+%22thread+%22+%3C%3C+i+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%7D%0A%0Aint+main()%0A%7B%0A++size_t+imax+%3D+40%3B%0A++std::thread+t(foo,+imax)%3B%0A%0A++for(size_t+i+%3D+0%3B+i+%3C+imax%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+%22main+%22+%3C%3C+i+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A++t.join()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== Threads -- \mintinline[style=white]{cpp}```std::this_thread```}
	\begin{itemize}
		\item Représente le thread courant
		\item ```cpp yield()``` permet de \og passer son tour\fg{}

\note[item]{C'est à dire d'indiquer à l'ordonnanceur qu'il peut replanifier}

		\item ```cpp sleep_for()``` suspend l'exécution sur la durée spécifiée
	\end{itemize}

	```cpp
		this_thread::sleep_for(chrono::seconds(5));
	```

	\begin{itemize}
		\item ```cpp sleep_until()``` suspend le thread jusqu'au temps demandé
	\end{itemize}

	\begin{alertblock}{Attention}
		\begin{itemize}
			\item Ne vous attendez pas à des attentes arbitrairement précises
		\end{itemize}

\note[item]{À l'échéance, le thread n'interrompt pas les autres pour reprendre la main}
	\end{alertblock}

	\begin{block}{Attentes passives}
		\begin{itemize}
			\item Les autres threads continuent de s'exécuter
		\end{itemize}
	\end{block}

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cthread%3E%0A%23include+%3Cchrono%3E%0A%0Aint+main()%0A%7B%0A++std::this_thread::sleep_for(std::chrono::seconds(5))%3B%0A++std::cout+%3C%3C+%22Main%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== Mutex -- \mintinline[style=white]{cpp}```std::mutex```}
	\begin{itemize}
		\item Verrou pour l'accès exclusif à une section de code
		\item ```cpp lock()``` verrouille le mutex
		\item \ldots{} en attendant sa libération s'il est déjà verrouillé
		\item ```cpp try_lock()``` verrouille le mutex s'il est libre, retourne ```cpp false``` sinon
		\item ```cpp unlock()``` relâche le mutex
	\end{itemize}

	\begin{alertblock}{Attention}
		\begin{itemize}
			\item ```cpp lock()``` sur un mutex verrouillé par le même thread provoque un \textit{deadlock}
		\end{itemize}
	\end{alertblock}

	\begin{itemize}
		\item ```cpp std::recursive_mutex``` variante verrouillable plusieurs fois par un même thread

\note[item]{Il faut le relâcher autant de fois pour qu'il soit effectivement non verrouillé}
	\end{itemize}

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cthread%3E%0A%23include+%3Cchrono%3E%0A%23include+%3Cmutex%3E%0A%0Astd::mutex+g_mutex%3B%0A%0Avoid+foo(size_t+imax)%0A%7B%0A++for(size_t+i+%3D+0%3B+i+%3C+imax%3B+%2B%2Bi)%0A++%7B%0A++++g_mutex.lock()%3B%0A++++std::cout+%3C%3C+%22thread+%22+%3C%3C+i+%3C%3C+!'%5Cn!'%3B%0A++++g_mutex.unlock()%3B%0A++++std::this_thread::sleep_for(std::chrono::milliseconds(10))%3B%0A++%7D%0A%7D%0A%0Aint+main()%0A%7B%0A++size_t+imax+%3D+40%3B%0A++std::thread+t(foo,+imax)%3B%0A%0A++for(size_t+i+%3D+0%3B+i+%3C+imax%3B+%2B%2Bi)%0A++%7B%0A++++g_mutex.lock()%3B%0A++++std::cout+%3C%3C+%22main+%22+%3C%3C+i+%3C%3C+!'%5Cn!'%3B%0A++++g_mutex.unlock()%3B%0A++++std::this_thread::sleep_for(std::chrono::milliseconds(10))%3B%0A++%7D%0A++t.join()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== Mutex -- \mintinline[style=white]{cpp}```std::timed_mutex```}
	\begin{itemize}
		\item Similaire à ```cpp std::mutex```
		\item \ldots{} proposant en complément des \textit{try lock} temporisés
		\item ```cpp try_lock_for()``` attend, si le mutex est verrouillé, la libération de celui-ci ou l'expiration d'une durée
		\item ```cpp try_lock_until()``` attend, si le mutex est verrouillé, la libération de celui-ci ou l'atteinte d'un temps
		\item ```cpp std::recursive_timed_mutex``` est une variante de ```cpp std::timed_mutex``` verrouillable plusieurs fois par un même thread
	\end{itemize}



== Mutex -- \mintinline[style=white]{cpp}```std::lock_guard```}
	\begin{itemize}
		\item Capsule RAII sur les mutex
		\item Constructible uniquement depuis un mutex
		\item Verrouille le mutex à la création et le relâche à la destruction
	\end{itemize}

	```cpp
		mutex mtx;
		{
		  lock_guard<mutex> lock(mtx);  // Prise du mutex
		  ...
		}  // Liberation du mutex
	```

	\begin{block}{Note}
		\begin{itemize}
			\item Gestion du mutex entièrement confiée au \textit{lock}
		\end{itemize}
	\end{block}

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cthread%3E%0A%23include+%3Cchrono%3E%0A%23include+%3Cmutex%3E%0A%0Astd::mutex+mtx%3B%0A%0Avoid+foo(size_t+imax)%0A%7B%0A++for(size_t+i+%3D+0%3B+i+%3C+imax%3B+%2B%2Bi)%0A++%7B%0A++++%7B%0A++++++std::lock_guard%3Cstd::mutex%3E+lock(mtx)%3B%0A++++++std::cout+%3C%3C+%22thread+%22+%3C%3C+i+%3C%3C+!'%5Cn!'%3B%0A++++%7D%0A++++std::this_thread::sleep_for(std::chrono::milliseconds(10))%3B%0A++%7D%0A%7D%0A%0Aint+main()%0A%7B%0A++size_t+imax+%3D+40%3B%0A++std::thread+t(foo,+imax)%3B%0A%0A++for(size_t+i+%3D+0%3B+i+%3C+imax%3B+%2B%2Bi)%0A++%7B%0A++++%7B%0A++++++std::lock_guard%3Cstd::mutex%3E+lock(mtx)%3B%0A++++++std::cout+%3C%3C+%22main+%22+%3C%3C+i+%3C%3C+!'%5Cn!'%3B%0A++++%7D%0A++++std::this_thread::sleep_for(std::chrono::milliseconds(10))%3B%0A++%7D%0A++t.join()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== Mutex -- \mintinline[style=white]{cpp}```std::unique_lock```}
	\begin{itemize}
		\item Capsule RAII des mutex
		\item Supporte les mutex verrouillés ou non
		\item Relâche le mutex à la destruction
		\item Expose les méthodes de verrouillage et libération des mutex
	\end{itemize}

	```cpp
		mutex mtx;
		{
		  unique_lock<mutex> lock(mtx, defer_lock);
		  ...
		  lock.lock();  // Prise du mutex
		  ...
		}  // Liberation du mutex
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cthread%3E%0A%23include+%3Cchrono%3E%0A%23include+%3Cmutex%3E%0A%0Astd::mutex+mtx%3B%0A%0Avoid+foo(size_t+imax)%0A%7B%0A++for(size_t+i+%3D+0%3B+i+%3C+imax%3B+%2B%2Bi)%0A++%7B%0A++++%7B%0A++++++std::unique_lock%3Cstd::mutex%3E+lock(mtx,+std::defer_lock)%3B%0A++++++lock.lock()%3B%0A++++++std::cout+%3C%3C+%22thread+%22+%3C%3C+i+%3C%3C+!'%5Cn!'%3B%0A++++%7D%0A++++std::this_thread::sleep_for(std::chrono::milliseconds(10))%3B%0A++%7D%0A%7D%0A%0Aint+main()%0A%7B%0A++size_t+imax+%3D+40%3B%0A++std::thread+t(foo,+imax)%3B%0A%0A++for(size_t+i+%3D+0%3B+i+%3C+imax%3B+%2B%2Bi)%0A++%7B%0A++++%7B%0A++++++std::lock_guard%3Cstd::mutex%3E+lock(mtx)%3B%0A++++++std::cout+%3C%3C+%22main+%22+%3C%3C+i+%3C%3C+!'%5Cn!'%3B%0A++++%7D%0A++++std::this_thread::sleep_for(std::chrono::milliseconds(10))%3B%0A++%7D%0A++t.join()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== Mutex -- \mintinline[style=white]{cpp}```std::unique_lock```}
	\begin{itemize}
		\item Comportements multiples à de la création
		\begin{itemize}
			\item Verrouillage immédiat
			\item Tentative de verrouillage
			\item Acquisition sans verrouillage
			\item Acquisition d'un mutex déjà verrouillé
		\end{itemize}
		\item ```cpp mutex()``` retourne le mutex associé
		\item ```cpp owns_lock()``` teste si le \textit{lock} a un mutex associé et l'a verrouillé
		\item ```cpp operator bool()``` encapsule ```cpp owns_lock()```
	\end{itemize}

	\begin{block}{Note}
		\begin{itemize}
			\item Gestion du mutex conservée, garantie de libération
		\end{itemize}
	\end{block}



== Mutex -- Gestion multiple}
	\begin{itemize}
		\item ```cpp std::lock()``` verrouille tous les mutex passés en paramètre
		\item \ldots{} sans produire de \textit{deadlock}
	\end{itemize}

	```cpp
		mutex mtx1, mtx2;
		lock(mtx1, mtx2);
	```

	\begin{itemize}
		\item ```cpp std::try_lock``` tente de verrouiller dans l'ordre tous les mutex passés en paramètre
		\item \ldots{} et relâche les mutex déjà pris en cas d'échec sur l'un d'eux
	\end{itemize}

	\begin{codesample}
		\sample{https://godbolt.org/#z:OYLghAFBqd5QCxAYwPYBMCmBRdBLAF1QCcAaPECAMzwBtMA7AQwFtMQByARg9KtQYEAysib0QXACx8BBAKoBnTAAUAHpwAMvAFYTStJg1DIApACYAQuYukl9ZATwDKjdAGFUtAK4sGe1wAyeAyYAHI%2BAEaYxHoADqgKhE4MHt6%2BcQlJAkEh4SxRMVy2mPaOAkIETMQEqT5%2BRXaYDskVVQQ5YZHRegqV1bXpDX3twZ353VwAlLaoXsTI7BzmAMzByN5YANQmy25OvcSYrDvYJhoAgitrG5jbuwQIh0zoJ2eXZqsM615bO27IjwEqFeFyuXxudzcLC8BEwqhBlwuvXQIBA0Nhqk2LAIqiKWJxZh2VlBFwAbqg8OhNvxUBBEgAvTAAfQImzwLCYqkmbxMAHZiedNtSSHS8IyWWy7gARTYaImSv5sjnw5YWbaWax4bkXIV8gVC3X8t4Gg3I1G0VDIADWTOAXiqL12ZrRMLhJ02FutXAg2Nx3NVxpNm2daBhkMV5jMDye6C46rM4d2Ct2irASwArG4GGmiYHDVK88GCCiQA88AoWY8jiWFPRMLEmfxiHTi6iAcQgaiWHRaOWmgJ0AoIFwNJN/frtryC6CpzyyRSqREqqLxaz2ZztZcjTrhc2Gcy19LZfK8JClZz5dZNZvDRPb4Whc7PTa7Q6/s70W7ltgPZarWYfQJccHyLEtQ1ZP4IzMKMq2eBNI0TNxkzcVMMyzHMAx3fNC2dMsK2jatUVrTB60bEUQ0BBhUC7Hs%2BzQBhB2HdMx1zHc%2BWnLcOLeYJWQ5YIIE3PVA33CV10xHYZUkOVMMFUDUQI55NgIb0aVIc8uVY2TcNgqkCAApcyHU4CSVkpsVwPZMZWktVT0VMTLw1SwtUDISsMnO9TVbEBn0A3E1N9MxjNkk0nz/W17WIR03A/V0VR/Z9vV9PFnWeVBYgIJlnyCoM5O8sLX0i98vM/OLf2tACArUlL0DSjKss0nKQ1mCCUyTSM%2BIYeNEOQ1CTEzbMlhkk12Jwry8MrGMiLrBszIojsqJo2heyUejGJHFihsnDihWUgA6bQKQYASGqUsx9sO46ZJGi4OGmWhOHTXg/A4LRSGojgUMctUFFmeZbhWHhSAITRbumK0QHTDR9E4SQnpBt7OF4BQQCh4GXtu0g4FgJA4SaGESHISgqmABRlEMEohAQVAAHdnsBtAWFiOgmDKBgyZCWhKZp57XoZpn6BiEnmFiBQqYIUg%2BboaJQlYRZeElgWAHkYS52n4dx5BzmIEnEdIDWKnwZ7eH4QQRDEdgpBkQRFBUdR0dIXQigMIwUCvSx9DwCJkcgaZauSZGOAAWmRCTTC%2Brg40DgB1MRaE2aO4QIYgmF4VBSWiYhKUwb2BNIYgvEEdlMAAFVQTwc%2BmH65gWHpi2CdmKaptXuF4JOSM4QHqeT2IQbuh64ft97sFUPGiGITZVAADgANkD6fJE2YBkGQTYICTgurUmVfPqsd3NlwQgSHVZYplb3vpgQatulz8HIehjhYdIHnU915HUfP%2B%2BzAH173rP9Gx1IOnYgiRnCSCAA%3D%3D}
	\end{codesample}



== Mutex -- \mintinline[style=white]{cpp}```std::call_once()```}
	\begin{itemize}
		\item Garantit l'appel unique (pour un \textit{flag} donnée) de la fonction en paramètre
		\item Si la fonction a déjà été exécutée, ```cpp std::call_once()``` retourne sans exécuter la fonction
		\item Si la fonction est en cours d'exécution, ```cpp std::call_once()``` attend la fin de cette exécution avant de retourner
	\end{itemize}

	```cpp
		void foo(int, char);

		once_flag flag;
		call_once(flag, foo, 42, 'r');
	```

	\begin{block}{Cas d'utilisation}
		\begin{itemize}
			\item Appelle par un unique thread d'une fonction d'initialisation
		\end{itemize}
	\end{block}

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cmutex%3E%0A%0Avoid+foo(int+a,+char+b)%0A%7B%0A++std::cout+%3C%3C+a+%3C%3C+%22-%22+%3C%3C+b+%3C%3C+%22%5Cn%22%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::once_flag+flag%3B%0A++std::once_flag+other%3B%0A%0A++std::call_once(flag,+foo,+42,+!'r!')%3B%0A++std::call_once(flag,+foo,+43,+!'s!')%3B%0A++std::call_once(other,+foo,+44,+!'t!')%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== Variables conditionnelles -- Principe}
	\begin{itemize}
		\item Mise en attente du thread sur la variable conditionnelle
		\item Réveil du thread lors de la notification de la variable
		\item Protection par verrou
		\begin{itemize}
			\item Prise du verrou avant l'appel à la fonction d'attente
			\item Relâchement du verrou par la fonction
			\item Reprise du verrou lors de la notification avant le déblocage du thread
		\end{itemize}
	\end{itemize}



== Variables conditionnelles -- \mintinline[style=white]{cpp}```std::condition_variable```}
	\begin{itemize}
		\item Uniquement avec ```cpp std::unique_lock```
		\item ```cpp wait()``` met en attente le thread
	\end{itemize}

	```cpp
		mutex mtx;
		condition_variable cv;

		unique_lock<std::mutex> lck(mtx);
		cv.wait(lck);
	```

	\begin{block}{Note}
		\begin{itemize}
			\item Possibilité de fournir un prédicat
			\begin{itemize}
				\item Blocage seulement s'il retourne ```cpp false```
				\item Déblocage seulement s'il retourne ```cpp true```
			\end{itemize}
		\end{itemize}
	\end{block}



== Variables conditionnelles -- \mintinline[style=white]{cpp}```std::condition_variable```}
	\begin{itemize}
		\item ```cpp wait_for()``` met en attente le thread, au maximum la durée donnée
		\item ```cpp wait_until()``` met en attente le thread, au maximum jusqu'au temps donné
	\end{itemize}

	\begin{block}{Note}
		\begin{itemize}
			\item ```cpp wait_for()``` et ```cpp wait_until()``` indique si l'exécution a repris suite à un timeout
		\end{itemize}
	\end{block}



== Variables conditionnelles -- \mintinline[style=white]{cpp}```std::condition_variable```}
	\begin{itemize}
		\item ```cpp notify_one()``` notifie un des threads en attente sur la variable conditionnelle
	\end{itemize}

	\begin{alertblock}{Attention}
		\begin{itemize}
			\item Impossible de choisir quel thread notifié avec ```cpp notify_one()```
	\end{itemize}
	\end{alertblock}

	\begin{itemize}
		\item ```cpp notify_all()``` notifie tous les threads en attente
		\item ```cpp std::condition_variable_any``` similaire à ```cpp std::condition_variable```
		\item \ldots{} sans être limité à ```cpp std::unique_lock```
		\item ```cpp std::notify_all_at_thread_exit()```
		\begin{itemize}
			\item Indique de notifier tous les threads à la fin du thread courant
			\item Prend un verrou qui sera libéré à la fin du thread
		\end{itemize}
	\end{itemize}



== Variables conditionnelles -- \mintinline[style=white]{cpp}```std::condition_variable```}
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

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cthread%3E%0A%23include+%3Cchrono%3E%0A%23include+%3Cmutex%3E%0A%23include+%3Ccondition_variable%3E%0A%0Astd::mutex+mtx%3B%0Astd::condition_variable+cv%3B%0A%0Avoid+print_id(int+id)%0A%7B%0A++std::unique_lock%3Cstd::mutex%3E+lck(mtx)%3B%0A++cv.wait(lck)%3B%0A++std::cout+%3C%3C+%22thread+%22+%3C%3C+id+%3C%3C+!'%5Cn!'%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::thread+threads%5B10%5D%3B%0A%0A++for(int+i+%3D+0%3B+i%3C10%3B+%2B%2Bi)%0A++%7B%0A++++threads%5Bi%5D+%3D+std::thread(print_id,+i)%3B%0A++%7D%0A++std::this_thread::sleep_for(std::chrono::seconds(5))%3B%0A++cv.notify_all()%3B%0A%0A++for(auto%26+th+:+threads)%0A++%7B%0A++++th.join()%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== Futures et promise -- Principe}
	\begin{itemize}
		\item ```cpp std::promise``` contient une valeur
		\begin{itemize}
			\item Disponible ultérieurement
			\item Récupérable, éventuellement dans un autre thread, via ```cpp std::future```
		\end{itemize}
		\item ```cpp std::future``` permet la récupération d'une valeur disponible ultérieurement
		\begin{itemize}
			\item Depuis un ```cpp std::promise```
			\item Depuis un appel asynchrone ou différé de fonction
		\end{itemize}
		\item Mécanismes asynchrones
		\item ```cpp std::future``` définissent des points de synchronisation
	\end{itemize}

	\begin{block}{Note}
		\begin{itemize}
			\item ```cpp std::promise``` et ```cpp std::future``` peuvent également manipuler des exceptions
		\end{itemize}
	\end{block}



== Futures et promise -- \mintinline[style=white]{cpp}```std::future```}
	\begin{itemize}
		\item Utilisable uniquement s'il est valide (associé à un état partagé)
		\item Construit valide que par certaines fonctions fournisseuses
		\item Déplaçable mais non copiable
		\item Prêt lorsque la valeur, ou une exception, est disponible
		\item ```cpp valid()``` teste s'il est valide
		\item ```cpp wait()``` attend qu'il soit prêt
		\item ```cpp wait_for()``` attend qu'il soit prêt, au plus la durée donnée
		\item ```cpp wait_until()``` attend qu'il soit prêt, au plus jusqu'au temps donné
		\item ```cpp get()``` attend qu'il soit prêt, retourne la valeur (ou lève l'exception) et libère l'état partagé
	\end{itemize}



== Futures et promise -- \mintinline[style=white]{cpp}```std::future```}
	\begin{itemize}
		\item ```cpp share()``` construit un ```cpp std::shared_future``` depuis le ```cpp std::future```
	\end{itemize}

	\begin{alertblock}{Attention}
		\begin{itemize}
			\item Après un appel à ```cpp share()```, le ```cpp std::future``` n'est plus valide
		\end{itemize}
	\end{alertblock}

	\begin{itemize}
		\item ```cpp std::shared_future``` similaires à ```cpp std::future```
		\begin{itemize}
			\item Mais copiables
			\item Responsabilité partagée sur l'état partagé
			\item Valeur lisible à plusieurs reprises
		\end{itemize}
	\end{itemize}



== Futures et promise -- \mintinline[style=white]{cpp}```std::async()```}
	\begin{itemize}
		\item Appelle la fonction fournie
		\item Et retourne, sans attendre la fin de l'exécution, un ```cpp std::future```
		\item ```cpp std::future``` permettant de récupérer la valeur de retour de la fonction
	\end{itemize}

	\begin{block}{Note}
		\begin{itemize}
			\item Deux politiques d'exécution de la fonction appelée
			\begin{itemize}
				\item Exécution asynchrone
				\item Exécution différée à l'appel de ```cpp wait()``` ou ```cpp get()```
			\end{itemize}
			\item Par défaut le choix est laissé à l'implémentation
		\end{itemize}
	\end{block}



== Futures et promise -- \mintinline[style=white]{cpp}```std::async()```}
	```cpp
		int foo() {
		  this_thread::sleep_for(chrono::seconds(5));
		  return 10;
		}

		future<int> bar = async(launch::async, foo);
		...
		cout << bar.get() << "\n";
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cthread%3E%0A%23include+%3Cchrono%3E%0A%23include+%3Cfuture%3E%0A%0Aint+foo()%0A%7B%0A++std::cout+%3C%3C+%22Begin+foo%5Cn%22%3B%0A++std::this_thread::sleep_for(std::chrono::seconds(5))%3B%0A++std::cout+%3C%3C+%22End+foo%5Cn%22%3B%0A++return+10%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::future%3Cint%3E+bar+%3D+async(std::launch::async,+foo)%3B%0A++std::cout+%3C%3C+%22Attente%5Cn%22%3B%0A++std::this_thread::sleep_for(std::chrono::seconds(1))%3B%0A++std::cout+%3C%3C+%22Attente%5Cn%22%3B%0A++std::cout+%3C%3C+bar.get()+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:49.99999999999999,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:49.99999999999999,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== Futures et promise -- \mintinline[style=white]{cpp}```std::promise```}
	\begin{itemize}
		\item Objet que l'on promet de valoriser ultérieurement
		\item Déplaçable mais non copiable
		\item Partage un état avec le ```cpp std::future``` associé
		\item ```cpp get_future()``` retourne le ```cpp std::future``` associé
	\end{itemize}

	\begin{alertblock}{Attention}
		\begin{itemize}
			\item Un seul ```cpp std::future``` par ```cpp std::promise``` peut être récupéré
		\end{itemize}
	\end{alertblock}



== Futures et promise -- \mintinline[style=white]{cpp}```std::promise```}
	\begin{itemize}
		\item ```cpp set_value()``` affecte une valeur et passe l'état partagé à prêt
		\item ```cpp set_exception()``` affecte une exception et passe l'état partagé à prêt
		\item ```cpp set_value_at_thread_exit()``` affecte une valeur, l'état partagé passera à prêt à la fin du thread
		\item ```cpp set_exception_at_thread_exit()``` affecte une exception, l'état partagé passera à prêt à la fin du thread
	\end{itemize}



== Futures et promise -- \mintinline[style=white]{cpp}```std::promise```}
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

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cthread%3E%0A%23include+%3Cchrono%3E%0A%23include+%3Cfuture%3E%0A%0Avoid+foo(std::future%3Cint%3E%26+fut)%0A%7B%0A++int+x+%3D+fut.get()%3B%0A++std::cout+%3C%3C+x+%3C%3C+!'%5Cn!'%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::promise%3Cint%3E+prom%3B%0A++std::future%3Cint%3E+fut+%3D+prom.get_future()%3B%0A++std::thread+th1(foo,+ref(fut))%3B%0A%0A++std::this_thread::sleep_for(std::chrono::seconds(2))%3B%0A%0A++prom.set_value(10)%3B%0A++th1.join()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:49.99999999999999,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:49.99999999999999,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== Futures et promise -- \mintinline[style=white]{cpp}```std::packaged_task```}
	\begin{itemize}
		\item Encapsulation d'un appelable similaire à ```cpp std::function```
		\item \ldots{} dont la valeur de retour est récupérable par un ```cpp std::future```
		\item Partage un état avec le ```cpp std::future``` associé
		\item ```cpp valid()``` teste s'il est associé à un état partagé (contient un appelable)
		\item ```cpp get_future()``` retourne le ```cpp std::future``` associé
	\end{itemize}

	\begin{alertblock}{Attention}
		\begin{itemize}
			\item Un seul ```cpp std::future``` par ```cpp std::packaged_task``` peut être récupéré
		\end{itemize}
	\end{alertblock}



== Futures et promise -- \mintinline[style=white]{cpp}```std::packaged_task```}
	\begin{itemize}
		\item ```cpp operator()``` appelle l'appelable, affecte sa valeur de retour (ou l'exception levée) au ```cpp std::future``` et passe l'état partagé à prêt
		\item ```cpp reset()``` réinitialise l'état partagé en conservant l'appelable
	\end{itemize}

	\begin{block}{note}
		\begin{itemize}
			\item ```cpp reset()``` permet d'appeler une nouvelle fois l'appelable
		\end{itemize}
	\end{block}

	\begin{itemize}
		\item ```cpp make_ready_at_thread_exit()``` appelle l'appelable et affecte sa valeur de retour (ou l'exception levée), l'état partagé passera à prêt à la fin
	\end{itemize}



== Futures et promise -- \mintinline[style=white]{cpp}```std::packaged_task```}
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

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:8,endLineNumber:21,positionColumn:8,positionLineNumber:21,selectionStartColumn:8,selectionStartLineNumber:21,startColumn:8,startLineNumber:21),source:'%23include+%3Ciostream%3E%0A%23include+%3Cthread%3E%0A%23include+%3Cchrono%3E%0A%23include+%3Cfuture%3E%0A%0Avoid+foo(std::future%3Cint%3E%26+fut)%0A%7B%0A++int+x+%3D+fut.get()%3B%0A++std::cout+%3C%3C+x+%3C%3C+!'%5Cn!'%3B%0A%7D%0A%0Aint+bar()%0A%7B%0A++return+10%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::packaged_task%3Cint()%3E+tsk(bar)%3B%0A++std::future%3Cint%3E+fut+%3D+tsk.get_future()%3B%0A++std::thread+th1(foo,+std::ref(fut))%3B%0A%0A++std::this_thread::sleep_for(std::chrono::seconds(2))%3B%0A%0A++tsk()%3B%0A++th1.join()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:49.99999999999999,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:49.99999999999999,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}



== Conclusion}
	\begin{exampleblock}{Do, dans cet ordre}
		\begin{itemize}
			\item Évitez de partager variables et ressources
			\item Préférez les partages en lecture seule
			\item Préférez les structures de données gérant les accès concurrents

\note[item]{```cpp std::atomic```, conteneur \textit{lock-free}, conteneur \textit{thread-safe}, etc.}

			\item Protégez l'accès par mutex ou autres barrières
		\end{itemize}
	\end{exampleblock}

	\begin{exampleblock}{Do}
		\begin{itemize}
			\item Encapsulez les mutex dans des ```cpp std::lock_guard``` ou ```cpp std::unique_lock```
		\end{itemize}
	\end{exampleblock}



== Conclusion}
	\begin{exampleblock}{Do}
		\begin{itemize}
			\item Analysez vos cas d'utilisation pour choisir le bon outil
		\end{itemize}
	\end{exampleblock}

	\begin{alertblock}{Attention}
		\begin{itemize}
			\item Très faibles garanties de \textit{thread-safety} de la part des conteneurs standards
		\end{itemize}

\note[item]{En gros plusieurs threads peuvent lire un même conteneur et plusieurs threads peuvent lire ou écrire simultanément des conteneurs différents sans problème et c'est à peu prés tout}
	\end{alertblock}

	\begin{exampleblock}{Do}
		\begin{itemize}
			\item ```cpp Boost.Lockfree``` pour des structures de données \textit{thread-safe} et \textit{lock-free}
		\end{itemize}
	\end{exampleblock}

	\begin{block}{Pour aller plus loin}
		\begin{itemize}
			\item Voir \textit{C++ Concurrency in action} d'Anthony Williams
		\end{itemize}

\note[item]{Anthony Williams est coauteur des propositions de \textit{multi-threading} dans C++11 et co-auteur de ```cpp Boost.Thread```}
	\end{block}


== Expressions rationnelles (regex)}
	\begin{itemize}
		\item ```cpp std::basic_regex``` représente une expression rationnelle
		\item Instanciations standards ```cpp std::regex``` et ```cpp std::wregex```
		\item Construite depuis une chaîne représentant l'expression
		\item \ldots{} et des drapeaux de configuration
		\begin{itemize}
			\item Grammaire : \underline{ECMAScript}, basic POSIX, extended POSIX, awk, grep, egrep
			\item Case sensitive ou non
			\item Prise en compte de la locale
			\item \ldots{}
		\end{itemize}
	\end{itemize}

	```cpp
		regex foo("[0-9A-Z]+", icase);
	```

	\addproposal{n1836}{https://wg21.link/n1836}
	\addproposal{N1429}{https://wg21.link/N1429}



== Expressions rationnelles (regex)}
	\begin{itemize}
		\item```cpp std::regex_search()``` recherche
	\end{itemize}

	```cpp
		regex r("[0-9]+");
		regex_search(string("123"), r);         // true
		regex_search(string("abcd123efg"), r);  // true
		regex_search(string("abcdefg"), r);     // false
	```

	\begin{itemize}
		\item ```cpp std::regex_match()``` vérifie la correspondance
	\end{itemize}

	```cpp
		regex r("[0-9]+");
		regex_match(string("123"), r);          // true
		regex_match(string("abcd123efg"), r);   // false
		regex_match(string("abcdefg"), r);      // false
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cregex%3E%0A%0Aint+main()%0A%7B%0A++std::regex+r(%22%5B0-9%5D%2B%22)%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::regex_match(std::string(%22123%22),+r)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::regex_match(std::string(%22abcd123efg%22),+r)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::regex_match(std::string(%22abcdefg%22),+r)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:49.99999999999999,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:49.99999999999999,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cregex%3E%0A%0Aint+main()%0A%7B%0A++std::regex+r(%22%5B0-9%5D%2B%22)%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::regex_search(std::string(%22123%22),+r)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::regex_search(std::string(%22abcd123efg%22),+r)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::regex_search(std::string(%22abcdefg%22),+r)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:49.99999999999999,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:49.99999999999999,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{n1836}{https://wg21.link/n1836}
	\addproposal{N1429}{https://wg21.link/N1429}



== Expressions rationnelles (regex)}
	\begin{itemize}
		\item Capture de sous-expressions dans ```cpp std::match_results```
		\item Instanciations standards ```cpp std::cmatch```, ```cpp std::wcmatch```, ```cpp std::smatch``` et ```cpp std::wsmatch```
		\item ```cpp empty()``` teste la vacuité de la capture
		\item ```cpp size()``` retourne le nombre de captures
		\item Itérateurs sur les captures
		\item Sur chaque élément capturé
		\begin{itemize}
			\item ```cpp str()``` : la chaîne capturée
			\item ```cpp length()``` : sa longueur
			\item ```cpp position()``` : sa position dans la chaîne de recherche
			\item ```cpp suffix()``` : la séquence de caractères suivant la capture
			\item ```cpp prefix()``` : la séquence de caractères précédant la capture
		\end{itemize}
	\end{itemize}

	\addproposal{n1836}{https://wg21.link/n1836}
	\addproposal{N1429}{https://wg21.link/N1429}



== Expressions rationnelles (regex)}
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

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cregex%3E%0A%0Aint+main()%0A%7B%0A++std::string+s(%22abcd123efg%22)%3B%0A++std::regex+r(%22%5B0-9%5D%2B%22)%3B%0A++std::smatch+m%3B%0A%0A++std::regex_search(s,+m,+r)%3B%0A++std::cout+%3C%3C+m.size()+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+m.str(0)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+m.position(0)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+m.prefix()+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+m.suffix()+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:49.99999999999999,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:49.99999999999999,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{n1836}{https://wg21.link/n1836}
	\addproposal{N1429}{https://wg21.link/N1429}



== Expressions rationnelles (regex)}
	\begin{itemize}
		\item Fonction de remplacement : ```cpp std::regex_replace()```
	\end{itemize}

	```cpp
		string s("abcd123efg");
		regex r("[0-9]+");
		regex_replace(s, r, "-"); // abcd-efg
	```

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cregex%3E%0A%0Aint+main()%0A%7B%0A++std::string+s(%22abcd123efg%22)%3B%0A++std::regex+r(%22%5B0-9%5D%2B%22)%3B%0A++std::cout+%3C%3C+std::regex_replace(s,+r,+%22-%22)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:49.99999999999999,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:49.99999999999999,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{n1836}{https://wg21.link/n1836}
	\addproposal{N1429}{https://wg21.link/N1429}



== Expressions rationnelles (regex)}
	\begin{exampleblock}{Do}
		\begin{itemize}
			\item Préférez les expressions rationnelles aux analyseurs \og à la main\fg{}
		\end{itemize}
	\end{exampleblock}

	\begin{alertblock}{Don't}
		\begin{itemize}
			\item N'utilisez pas les expressions rationnelles pour les traitements triviaux
			\item Préférez les algorithmes
		\end{itemize}
 	\end{alertblock}

	\begin{block}{Conseil}
		\begin{itemize}
			\item Encapsulez les expressions rationnelles ayant une sémantique claire et utilisées plusieurs fois dans une fonction dédiée au nom évocateur
		\end{itemize}
	\end{block}

	\begin{block}{Performance}
		\begin{itemize}
			\item Construction très coûteuse de l'expression rationnelle
		\end{itemize}
	\end{block}


== Nombres aléatoires}
	\begin{itemize}
		\item Générateurs pseudo-aléatoires initialisés par une graine (congruence linéaire, Mersenne, \ldots{})
		\item Générateur aléatoire
	\end{itemize}

	\begin{alertblock}{Attention}
		\begin{itemize}
			\item Peut ne pas être présent sur certaines implémentations
			\item Peut être un générateur pseudo-aléatoire (entropie nulle) sur d'autres
		\end{itemize}
	\end{alertblock}

	\begin{itemize}
		\item Distributions adaptant la séquence d'un générateur pour respecter une distribution particulière (uniforme, normale, binomiale, de Poisson, \ldots{})
		\item Fonction de normalisation ramenant la séquence générée dans [0,1)
	\end{itemize}

	\addproposal{n1836}{https://wg21.link/n1836}



== Nombres aléatoires}
	```cpp
		default_random_engine gen;
		uniform_int_distribution<int> distribution(0,9);
		gen.seed(system_clock::now().time_since_epoch().count());

		// Nombre aleatoire entre 0 et 9
		distribution(gen);
	```

	\begin{exampleblock}{Do}
		\begin{itemize}
			\item Préférez ces générateurs et distributions à ```cpp rand()```
		\end{itemize}
	\end{exampleblock}

	\begin{block}{Quiz}
		Comment générer un tirage équiprobable entre 6 et 42 avec ```cpp rand()```
	\end{block}

	\begin{codesample}
		\sample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Crandom%3E%0A%23include+%3Cchrono%3E%0A%0Aint+main()%0A%7B%0A++std::default_random_engine+generator%3B%0A++std::uniform_int_distribution%3Cint%3E+distribution(0,9)%3B%0A%0A++generator.seed(std::chrono::system_clock::now().time_since_epoch().count())%3B%0A++std::cout+%3C%3C+distribution(generator)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}
	\end{codesample}

	\addproposal{n1836}{https://wg21.link/n1836}

\end{document}

= C++14

= C++17

= C++20
