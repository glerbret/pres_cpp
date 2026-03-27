#import "./model.typ": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/cetz:0.4.2"

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
    table.cell(fill: main_color.lighten(60%), [*Catégorie*]),
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

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:18,positionColumn:1,positionLineNumber:18,selectionStartColumn:1,selectionStartLineNumber:18,startColumn:1,startLineNumber:18),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B2,+5,+2,+1,+8,+8,+6,+2,+8,+8,+8,+2%7D%3B%0A%0A++std::vector%3Cint%3E::iterator+it+%3D+find(foo.begin(),+foo.end(),+6)%3B%0A++std::cout+%3C%3C+*it+%3C%3C+!'+!'+%3C%3C+*(it%2B1)+%3C%3C+!'%5Cn!'%3B%0A%0A++std::vector%3Cint%3E::iterator+it2+%3D+std::adjacent_find(foo.begin(),+foo.end())%3B%0A++std::cout+%3C%3C+*it2+%3C%3C+!'+!'+%3C%3C+*(it2+-+1)+%3C%3C+!'+!'+%3C%3C+*(it2+%2B+2)+%3C%3C+!'%5Cn!'%3B%0A%0A++std::vector%3Cint%3E::iterator+it3+%3D+std::search_n(foo.begin(),+foo.end(),+3,+8)%3B%0A++std::cout+%3C%3C+*it3+%3C%3C+!'+!'+%3C%3C+*(it3+-+1)+%3C%3C+!'+!'+%3C%3C+*(it3+%2B+3)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)


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

#codesample(
  "https://godbolt.org/#z:OYLghAFBqd5QCxAYwPYBMCmBRdBLAF1QCcAaPECAMzwBtMA7AQwFtMQByARg9KtQYEAysib0QXACx8BBAKoBnTAAUAHpwAMvAFYTStJg1DIApACYAQuYukl9ZATwDKjdAGFUtAK4sGe1wAyeAyYAHI%2BAEaYxCBmAJykAA6oCoRODB7evnrJqY4CQSHhLFEx8baY9vkMQgRMxASZPn5cFVXptfUEhWGR0bEJCnUNTdmtQ109xaUDAJS2qF7EyOwc5gDMwcjeWADUJutuTkPEmKwH2CYaAIIbWzuY%2B4cAbpgOJBdXt2abDNteewObjEwBIhAQLE%2BNy%2BwQIuxYTGCEFmXxMAHYrDddrshugQCBXu9iEDYRddvxUOiLNJdgBWUi7NEMhK7LhmdEAEQOmNuWP2GK%2B2OxuPxhKIxMOpPW2HxhGiTHFu0ITw5OIIeJAtFQAHdogB9CKLBjoaioVAAOiiwCR83JZvNrmRDIAbCj1jyhWqNWgvHCgUDdgAqZX%2Bw67MBrWluBgR7mC/lc6F8qnx4Xq0VvcUkwQXWUEeWKkPrVUizU6/WGrzG00Wq02hkUh3V21xN0eoWln1%2Bw4B4PdtwB2NRmNrd3xzmo5MCvlpjVij6SnPSvMFkhK7sl9MgLyJRIVo0mxt1hhOu0Wx0ttupr34rtPAdhvv3weR6OxsdTxO867YlMzm8gIkiISm4pbziBUoyiAcrEAqJAMmBmYLkcS5QTBcEStguynAoKoAZgACOXhiHqsFGJgNaWpg1onrajYXi6V7/p2iz9r2EA4eaNDEEMszPmGEbhhw/FuEGHGYAo5pKGgxp8aGolDm%2Bo7thO0Jol%2BHDzLQnC0rwfgcFopCoJwA6WNYOKLMsjwbDwpAEJomnzAA1iAtIaPonCSHpDlGZwvAKCA7n2QZmmkHAsBIJgqhvL68EUBA9TAAoyiGJUQgIDq%2Bm2WgLCJHQCrpClIS0OlmU%2BTleX0DESXMIkCgZQQpAVXQ0ShKwqy8M1VUAPK%2BqV2r6YZUVvNcxBJX5pDDcgtT4PpvD8IIIhiOwUgyIIigqOoIWkLorQGEYKDWNY%2Bh4BEAWQPMqCJNUAUcAAtLiBwcqYZmWFwXC7HdADqYi0J9X1RQQsG8KgrzEMQeBYOdTrEFWjhsAAKmatDQ/MCiWSsei4sERVpRlA2cLZQOYKstnarBiQOVpOnedtxkcNg0XILFxC7KoAAczp3c6ki7MAyDILsEBA1WTl8RAplWJYDK4IQa42bMvDBVoszzAgZxYDETouW5HkcF5pCDSDE0BUFVPUxwZi04Z9NK%2BbpBg6kziSEAA%3D%3D",
)

== STL Algorithmes -- Comptage

- ```cpp std::count()``` compte le nombre d'éléments égaux à la valeur fournie

```cpp
vector<int> foo{4, 5, 3, 9, 5, 5 ,12};

count(foo.begin(), foo.end(), 5);  // 3
count(foo.begin(), foo.end(), 2);  // 0
```

- ```cpp std::count_if()``` compte le nombre d'éléments satisfaisant le prédicat

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:19,positionColumn:1,positionLineNumber:19,selectionStartColumn:1,selectionStartLineNumber:19,startColumn:1,startLineNumber:19),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Abool+compare(int+nb)%0A%7B%0A++return+nb+%3E%3D+5%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B2,+5,+2,+1,+8,+8,+6,+2,+8,+8,+8,+2%7D%3B%0A%0A++std::cout+%3C%3C+std::count(foo.begin(),+foo.end(),+8)+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::count(foo.begin(),+foo.end(),+7)+%3C%3C+!'%5Cn!'%3B%0A%0A++std::cout+%3C%3C+std::count_if(foo.begin(),+foo.end(),+compare)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

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

#codesample(
  "https://godbolt.org/#z:OYLghAFBqd5QCxAYwPYBMCmBRdBLAF1QCcAaPECAMzwBtMA7AQwFtMQByARg9KtQYEAysib0QXACx8BBAKoBnTAAUAHpwAMvAFYTStJg1DIApACYAQuYukl9ZATwDKjdAGFUtAK4sGe1wAyeAyYAHI%2BAEaYxCAAzLGkAA6oCoRODB7evnrJqY4CQSHhLFEx8baY9vkMQgRMxASZPn5cFVXptfUEhWGR0XEJCnUNTdmtQ109xaUDAJS2qF7EyOwc5rHByN5YANQmsW5OQ8SYrPvYJhoAguub25h7BwBumA4k55c3ZhsMW167%2BzcYmAJEICBYH2un2CBB2LCYwQgs0%2BJgA7FZrjsdkN0CAQC83sRATDzjt%2BKg0RZWjsAKykHYADnpZjRABF9hibpi9ujPlisTi8QSiESDiTYtgdhF6pTqXTGcy2Ry%2BfzBShFrDAYDsQRcSAIqhPGJEggmI83Nq1ZgAI5eMTUQ0AOiiwER8zJTtcSPp0uIzswroYSNm5u1YDWNLcDHDyu5At1eLQXk1B0tCf1hoMtBNZq1Bx2DtQj3ZsVZUvqIbzbh2Mcj0bWsU5WKVUO5lJV8b1wveYsEpN9svpCR2ZnpqKVjY7Or1SZTFvzaoNRuzptDC/TNrttEL/sD3o9qEdXvdvt3bsrqfztajMcnceniY1a%2Bri8zxtXVYL5OL%2BzLvov87Vte9axlczaouyrZgTyTaqum3aiocfYSuWRLonK9JMiO9KSBOsGdo%2BybPg%2BGbLjmxFWra9rkmeQbujRx4%2BvUtHBsRwG3vhJGzhR6ZLlm5GfoWP6lqhAFhhGN4NrBLZctB7b3mqCHEshkoDuhQ7MmOeFTmqiQIohimvCKykEOceKENETAivShmEiZZkgBZxBWT2konAoxYkSweAKPCBDIAgO4um69IMQw6D7qewV0cid7QQR6pEZ%2BABUEDuY6NDEEMYlXhwNZ5SlaWYAojpKGg4U5UBEkgXF4GQTcEGfBw8y0JwNK8H4HBaKQqCcBaljWNiizLA86w8KQBCaM18wANYgDSGj6JwkgdVNPWcLwCggItk1dc1pBwLASCYKorzJiQ5CUPUwAKMohiVEICCoAA7p141oCwiR0FZ6R3SEtCPS9nXdR9X30DEN3MIkChPQQpCg3Q0ShKwqy8Aj4MAPLJoDr1rSdrxXMQN0baQ%2BPILU%2BCdbw/CCCIYjsFIMiCIoKjqHtpC6K0BhGCg1jWPoeARFtkDzKgiTVFtHAALQ4r%2BpgDZYXBcDsUsAOpiLQKuqydBDObwqAvMQxB4FgwvesQXiCHgbAACqZmb8wKMNKx6DiwR/Q9T249wvC65gqzjc9zmJFNLVtat7O9Rw2Cncg53EDsqgMgAbFLyeSDswDIMgBa65bM0hhA/VWJY9K4IQJB7N8XCzL7ofzAgpxYDE3pzQtS0cCtpDA/rJNbTt9cd2YEfdVHdd7bM8yG6kziSEAA",
)

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

#codesample(
  "https://godbolt.org/#z:OYLghAFBqd5QCxAYwPYBMCmBRdBLAF1QCcAaPECAMzwBtMA7AQwFtMQByARg9KtQYEAysib0QXACx8BBAKoBnTAAUAHpwAMvAFYTStJg1DIApACYAQuYukl9ZATwDKjdAGFUtAK4sGe1wAyeAyYAHI%2BAEaYxCAAzAAcpAAOqAqETgwe3r56KWmOAkEh4SxRMQm2mPYFDEIETMQEWT5%2BXJXVGXUNBEVhkdFxiQr1jc05bcPdvSVlgwCUtqhexMjsHOaxwcjeWADUJrFuTsPEmKwH2CYaAIIbWzuY%2B4cAbpgOJBdXt2abDNteewObjEwBIhAQLE%2BNy%2Bk0cyF2wQIu2AjAgcy%2BJgA7FYbrtdrC8PDEQingARXYaA44654vD7SwHckAVipXzxpwIywYCNZ0MxpIxN2JLCYwTRGOxbP2ktxePxBHQIBAr3exCBiIuu34qAgknRsWpcvlipANFotGoqFQADoosAxQstVbra40aRdpIzPrDXLhia0F4kUCgU7UCYmRZKUzycHDrswBx44nY25Q%2BGLFxwzHDiGE0mnm4Q9r02YswXc4m8ym0xHYmXqwnw24GI2DVKsQLobKsT68X6lSqiGrDhrYtg023ZX2FUqzbQAPoMCD9kARJjIADW8%2BCSka0UtqEd0g9sW9Uun/qWQZzceLEaj2cLcbzVZvqbvGfrb/zr6f76tJZfn%2BP7Jt%2BH51tG5bPusTLNq2PodoKNLSr2xoDm8Q7qoImrarq7qSHqvLIReSoBtewEfg%2BUGpi%2BoEUQBEaZpBDaVnRRYMRYpbMd%2BtHUTWFgQY%2BFZNi26yTshiFdhJMrEWhyoYR8I7YWOoa6meU5ySiITEEwBCYAetqYPaS6OtqLoMOgbrIow3p4gA9HZuxMrsXAaC5zlmJSGkrmRfGUUBFb5tWH5MUJ0FBWBHFcWFNGsX5HGCXxjawaJRF4pJtx8p21wcAstCcEyvB%2BBwWikKgnCFgylj4ksKyPBsPCkAQmi5QsG4gEyGj6JwkhFS1ZWcLwCggF1zUlblpBwLASCYKobyBiQ5CUA0wAKMohhVEICCoAA7sVjVoCwSR0LpGTrSEtBbbtxWlYdx30DEq3MEkCjbQQpB3XQ0ShKway8J9D0APKBlde39bNbzXMQq2DaQEPIHU%2BDFbw/CCCIYjsFIMiCIoKjqONpC6G0BhGCg1jWPoeARMNkALKgSQ1MNHAALR%2BoyphVRYACc8S7MzADqYi0Hz/OzQQOm8KgrzEMQeBYDTbrEF4gh4GwAAqVq0ArCwKLVqx6H6wTnZt21g9wvDi5gayNTtOlJC1eUFX1BPlRw2BzcgC3ELsqjxAAbMzfuSMiyDwhA4vKxucy7BAlVWJY7q4IQJD0rEXBzBbDsLAgZxYDEbrtZ13UcL1pA3ZLsPDaNWfF2Yzula7mfjXMCzS2kziSEAA%3D%3D%3D",
)

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

#codesample(
  "https://godbolt.org/#z:OYLghAFBqd5QCxAYwPYBMCmBRdBLAF1QCcAaPECAMzwBtMA7AQwFtMQByARg9KtQYEAysib0QXACx8BBAKoBnTAAUAHpwAMvAFYTStJg1DIApACYAQuYukl9ZATwDKjdAGFUtAK4sGe1wAyeAyYAHI%2BAEaYxCBmZqQADqgKhE4MHt6%2BekkpjgJBIeEsUTFxtpj2eQxCBEzEBBk%2BflzllWk1dQQFYZHRsfEKtfWNWS2Dnd1FJf0AlLaoXsTI7BzmAMzByN5YANQma25Og8SYrPvYJhoAguub25h7BwBumA4k55c3ZhsMW167%2BzcYmAJEICBYH2un2CBB2LCYwQgM0%2BJgA7FZrjsdoN0CAQC83sRATDzjt%2BKg0RYAKykHZmABstNRtK4ZjRABF9hibpi9ujPlisTi8QSiESDiS1tgdhE6lyBYLhShUAkAJ7UVCoAB0UWAiLmZM1WtcSNpStlyAA1gB9YJKerRCCy4gzZFrbmC7EEXHKrywwGAmVyqkWDQmKnsx5uQNgDg7WNRwPO8MWLjhyMBg7xuMJzNuINEkNsiOJrMJ3MHJPBixrdOl/Ox8NuBiN90Kjko3mUhVC70i15i4mCUnOiAADjdHsVfeVautFstAHc6ugNdrdfraeTjQxVwbnTu95Oe16fWg/fWCymwyW89n73fkyG07fK2Wc3HH9Xixm3w2P5eT41nWd6NlSzatlOvZngs/p/leIaSCB8Hlp%2B8FAVSyHRu%2BD7odW9JYTGAFfoWFiooR75Ni2qxtl2qKclC9GfBwcy0JwVK8H4HBaKQqCcNGljWNiCxLA86w8KQBCaCxcyWiAVIaPonCSJx0m8ZwvAKCAilSdxLGkHAsBIJgqivH6JDkJQdTAAoyiGBUQgIKgi5cRJaAsAkdBMFUdkhLQjnOVxPHuZ59AxDZzAJAoTkEKQIV0NEoSsCsvDxWFADyfoBS5akma8VzEDZGmkHlyA1PgXG8PwggiGI7BSDIgiKCo6h6aQugtAYRgoNY1j6HgERaZAcwqlUWkcAAtDi%2BzsqYgmWFwXA7BNADqYi0MtK0mQQxBMLwqAvMQxB4FgQ2msQXiCHgbAACqarQZ1zAoInLHoOLBL5DlOTl3C8DtmArBJi67Qk0msexqltXxHDYKZyDmcQOyqGO9ITfSkg7MAyDIDsEA7ZdlozLjAlWJYtK4IQJB7N8XAzH9YNzAgpxYDEppyQpSkcCppBBftxVaTpDOc2YkM8dD9N6a6pCHSkziSEAA%3D%3D%3D",
)

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

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:14,positionColumn:1,positionLineNumber:14,selectionStartColumn:1,selectionStartLineNumber:14,startColumn:1,startLineNumber:14),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo+(5,10)%3B%0A++std::vector%3Cint%3E+bar+(5,33)%3B%0A%0A++std::cout+%3C%3C+bar%5B0%5D+%3C%3C+%22+%22+%3C%3C+bar%5B1%5D+%3C%3C+%22+%22+%3C%3C+bar%5B2%5D+%3C%3C+%22+%22+%3C%3C+bar%5B3%5D+%3C%3C+%22+%22+%3C%3C+bar%5B4%5D+%3C%3C+%22%5Cn%22%3B%0A++std::swap_ranges(foo.begin()+%2B+1,+foo.end()+-+1,+bar.begin())%3B%0A++std::cout+%3C%3C+bar%5B0%5D+%3C%3C+%22+%22+%3C%3C+bar%5B1%5D+%3C%3C+%22+%22+%3C%3C+bar%5B2%5D+%3C%3C+%22+%22+%3C%3C+bar%5B3%5D+%3C%3C+%22+%22+%3C%3C+bar%5B4%5D+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B98+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

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

#codesample(
  "https://godbolt.org/#z:OYLghAFBqd5QCxAYwPYBMCmBRdBLAF1QCcAaPECAMzwBtMA7AQwFtMQByARg9KtQYEAysib0QXACx8BBAKoBnTAAUAHpwAMvAFYTStJg1DIApACYAQuYukl9ZATwDKjdAGFUtAK4sGe1wAyeAyYAHI%2BAEaYxCCSAJykAA6oCoRODB7evnrJqY4CQSHhLFEx8baY9vkMQgRMxASZPn5cFVXptfUEhWGR0bEJCnUNTdmtQ109xaUDAJS2qF7EyOwc5gDMwcjeWADUJutuTkPEmKwH2CYaAIIbWzuY%2B4cAbpgOJBdXt2abDNteewObjEwBIhAQLE%2BNy%2BE0cyF2EVQnl2yAQbwA1hBggRdkxZl8TAB2Kw3Xa7U4EJYMXFPS7rAAiu0JBxJt0J9IJN2xuxYTGCEHx0OJXzJRNZZLJQ3QIBAr3exCB2Iuu34qDF0l2AFZSEydXFdqQuGYdZqiRz1uKJVKZadEgYVtQkQA6KLAfnzFXO1wCk06gAc%2BItIol/GIEFSAC9MAB9HG7PBPRkaFnxp5uT2oJ2RzAClPWax4QXXCX7YWkku7a0oRY4oFAjMmTUWPCNxl1w67MAcTtrIPl0Xs4OSgjS6teWuHetdxtuBjTvvF0sc6HlsVDysjmVyogKw5K9bYBvEjXa3W7fWG41as0s9dV232mN4KiOzOu9061VO70e1EY/2BpaZKhuGeBRrGZIJgcSYplBHZftmuYWvslgFkWJZrv2VqbmOE5uPWqqNs2rZplO3bzkBS53jhaDjqRHbTpqs4UcGN4roumGLsOo7bh8e6CMqhHHr6Z4XkaJo3guJZVrxu5HAJB4IvUt5YfemB2kwKzRmgiQAJ6vi6mBugwPoZt%2BDDoKZVYRJp6LRsESgNNEEA2cQHqngGKlcZ6YbZhBqbQbsybIXB6YIWBOaAShViWIW66cRWG6jrReEEUiREtpqbaTgx5G9pRbHeVWKX0emjHMflnLeSBflxnBMEhWmSnEFmEVIRY0VofFZbedxMole26auRlJGDT2PZeRhg6qTRNalRNTFzpVq7TWyy7XBw8y0Jwmq8H4HBaKQqCcPhqGWJWizLI8Gw8KQBCaJt8zoiAmoaPonCSHtD1HZwvAKCAb33Qdm2kHAsBIJgqhvOOJDkJQ9TAAoyiGJUQgIKgADu%2B23WgLCJHQTDVMjIS0GjmP7YduP4/QMSI8wiQKOjBCkFTdDRKErCrLwrM0wA8uOZNY99kNvNcxCI79pAi8gtT4PtvD8IIIhiOwUgyIIigqOowOkLorQGEYKD5pY%2Bh4BE/2QPMqCJNU/0cAAtFK0GmGdFhcFwuz2wA6mItCe17kMEMQTC8KgrzEMQeBYBbPrEF4gh4GwAAqSK0DH8wKJdKx6FKwTE6j6NC9wvBB5gqy3RjweJA9W07V9OvHRw2BQ8gMPELsqh%2BgAbPbXeSLswDIPCEBB/H6KzLsECnTFNi7LghAkCh6xcLMJc1/MaJMFgMQ%2Bs9r3vRwn2kBToeS/9gPrwfZj14djdr8DszzOHqTOJIQA%3D%3D",
)

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

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:16,positionColumn:1,positionLineNumber:16,selectionStartColumn:1,selectionStartLineNumber:16,startColumn:1,startLineNumber:16),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B4,+5,+5,+5,+7,+9,+9,+5%7D%3B%0A%0A++foo.erase(std::remove(foo.begin(),+foo.end(),+5),+foo.end())%3B%0A++for(size_t+i++%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:26,positionColumn:1,positionLineNumber:26,selectionStartColumn:1,selectionStartLineNumber:26,startColumn:1,startLineNumber:26),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Astatic+void+print(int+a)%0A%7B%0A++std::cout+%3C%3C+a+%3C%3C+!'+!'%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B4,+5,+5,+5,+7,+9,+9,+5%7D%3B%0A%0A++std::vector%3Cint%3E::iterator+it+%3D+std::remove(foo.begin(),+foo.end(),+5)%3B%0A++std::for_each(foo.begin(),+it,+print)%3B%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%0A%23if+0%0A++for(size_t+i++%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)


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

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:26,positionColumn:1,positionLineNumber:26,selectionStartColumn:1,selectionStartLineNumber:26,startColumn:1,startLineNumber:26),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Astatic+void+print(int+a)%0A%7B%0A++std::cout+%3C%3C+a+%3C%3C+!'+!'%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B4,+5,+5,+5,+7,+9,+9,+5%7D%3B%0A%0A++std::vector%3Cint%3E::iterator+it+%3D+std::unique(foo.begin(),+foo.end())%3B%0A++std::for_each(foo.begin(),+it,+print)%3B%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%0A%23if+0%0A++for(size_t+i++%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

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

#codesample(
  "https://godbolt.org/#z:OYLghAFBqd5QCxAYwPYBMCmBRdBLAF1QCcAaPECAMzwBtMA7AQwFtMQByARg9KtQYEAysib0QXACx8BBAKoBnTAAUAHpwAMvAFYTStJg1DIApACYAQuYukl9ZATwDKjdAGFUtAK4sGe1wAyeAyYAHI%2BAEaYxCAAzADspAAOqAqETgwe3r56KWmOAkEh4SxRMQm2mPYFDEIETMQEWT5%2BXJXVGXUNBEVhkdFxiQr1jc05bcPdvSVlgwCUtqhexMjsHOaxwcjeWADUJrFuTsPEmKwH2CYaAIIbWzuY%2B4cAbpgOJBdXt2abDNteewObjEwBIhAQLE%2BNy%2Bk0cyF2wQIu3QSwi9AA%2Bs8xBBEQi5l8TPErDddrtTgRlgxdmZdgAqBEHYm3eIAEQJN1xLCYwQg%2BOhRK%2BpMJTNJpOG6BAIFe72IQMRF12/FQwukuwArKRdoldgBOQls2Ii0XiyXSoiyw7y2LYXYRBoQST4w3s66i3YmkAEYiGBT8YgsaioVAAOiiwB5C0VQeDrl5mrtxFDmHDDDjyNRGKxtCdRtJfogaQAXph0Ui8E8WbsNIyEU83LaGsGi5heTXrNY8HzXaLhYK3e6CBKUEskUCgQ3ZWqLHgTGrK2PDrswBwl%2BtnSSe6y%2B2LB5K0F5R4dx8vZ24GCf1939S6hQKNzuh2aPpbBAqlSrNRqtZq9VvL26PSfC0jlfa0J2FMxNViTUADZNS4a9/2NXcpTec05VAm07ULB0cxvZChy9H0/QDJUkxTNMyNjSME3IiN4yYQs6NTSMPSSbwFAwggLl5PD7yjYgCzwYtS1rA5K2rQ0xMXbCm2Elsc32SwOy7N1e34h89xHOtx2w2dp1necj0XZdV0Zbd9i3fiPX3Q83GPdY1TPC8jWvfk2RuDgFloTg1V4PwOC0UhUE4ezlMsd0lhWR4Nh4UgCE0LyFgAaxANUNH0ThJH8xLgs4XgFBADKEsCrzSDgWAkEwVQ3gPEhyEoBpgAUZRDCqIQEFQAB3AK4rQFgkjoJgalakJaA67qAqC/rBvoGJmuYJIFE6ghSBmuholCVg1l4da5oAeQPCaety6q3muYhmvy0gzuQOp8AC3h%2BEEEQxHYKQZEERQVHUUrSF0NoDCMFB20sfQ8AiQrIAWVAkhqQqOAAWnFcTTHCiwuC4XZEYAdTEWhsZx6qiN4VBXmIYg8CwKG42ILxBDwNgABUg1oGmFgUKLVj0cVglG9rOpO7heC9TA1jirrvSSRLvN8nK/pCjhsBq5A6uIXZVAADhgxGYMkXZgGQeEIC9enkrmXYIDCqwwd2XBCBIJTYi4OYRZlhYEDOLAYjjVL0syjhstIKbSeuwrivdgOzHloLFbd0q5gWcm0mcSQgA%3D%3D",
)

== STL Algorithmes -- Rotation

- ```cpp std::rotate()``` effectue une rotation de l'ensemble, le nouveau début étant fourni par un itérateur

```cpp
vector<int> foo{4, 5, 7, 9, 12};

rotate(foo.begin(), foo.begin() + 2, foo.end());  // 7 9 12 4 5
```

- ```cpp std::rotate_copy()``` effectue une rotation et copie le résultat

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:16,positionColumn:1,positionLineNumber:16,selectionStartColumn:1,selectionStartLineNumber:16,startColumn:1,startLineNumber:16),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B4,+5,+7,+9,+12%7D%3B%0A%0A++std::rotate(foo.begin(),+foo.begin()+%2B+2,+foo.end())%3B%0A++for(size_t+i+%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

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

#codesample(
  "https://godbolt.org/#z:OYLghAFBqd5QCxAYwPYBMCmBRdBLAF1QCcAaPECAMzwBtMA7AQwFtMQByARg9KtQYEAysib0QXACx8BBAKoBnTAAUAHpwAMvAFYTStJg1DIApACYAQuYukl9ZATwDKjdAGFUtAK4sGe1wAyeAyYAHI%2BAEaYxCCSAKykAA6oCoRODB7evnrJqY4CQSHhLFEx8baY9vkMQgRMxASZPn5cFVXptfUEhWGR0bEJCnUNTdmtQ109xaUDAJS2qF7EyOwc5gDMwcjeWADUJutuTkPEmKwH2CYaAIIbWzuY%2B4cAbpgOJBdXt2abDNteewObjEwBIhAQLE%2BNy%2BE0cyF2EVQnl2eAUAH0MOgIMECCjZl8TAB2Kw3Xa7U4EJYMXbY8xxMz49YAEQOTK4BxJt0JLOhNxxuxYTGCEHx0OJXzJRM5ZLJQ3QIBAr3exCBOIuu34qCl0l2XHWpF2ZgAHAaAJy7A1xSRElnrTkSmVyhWJLppATUJEAOiiwGF8w1XtcIoNqIx6HQjOlMv4xAgqQAXpg0bi8E8mbsNByUU83AHUJ6E5gRVnrNY8KLrjL9uLSVXdk6UItcUCgXmTHELHh2%2BmW4ddmAOP21naHZLuaP6wR5Y2vM3Dq2B%2B23AxFyPazaCeua5XHVOFUqiCrDmr1tg28SdXqDcazRbdlaN2vbrXZXuQBMIvQ0S6Gm6GB78x9P0DU1T0g39UNMUjCcYzjPBE2TbNWQzLNU1bUDC2LO19ksMsKyrKUJ1fac0FnHN0KRdtO27ci%2BwHIcOQnDcX0nEim1o3NFziZdVyjZjnx3QiWIbA8PmPQR1U1KVTQNE1dkJA0ADZLQNHV9UNA12XHJ8JwbQQEDRSpMDYQQAO9TBfX/f1QKAqycIsXZ1NA8DoJY2DC0QtDmRQ7CvNzDD4KLSN7LwpjtzrViFVIuc3AorUOy7OIe3nOjB14sKeR3YiovY3tOLWbiV2HPjxzFTKOHmWhODiXg/A4LRSFQThYtwyx60WZZHg2HhSAITQKvmABrEA4g0fROEkWr%2BsazheAUEAxr6%2BqKtIOBYCQTBVDeWcSHISh6mABRlEMSohAQVAAHc6p6tAWESOgmGqY6QloM7Lrqhrbvu%2BgYkO5hEgUc6CFIL66GiUJWFWXhQZ%2BgB5Wc3qu6bNrea5iEO2bSBR5BanwOreH4QQRDEdgpBkQRFBUdRltIXRWgMIwUFLSx9DwCJ5sgeZUESap5o4ABaOVWVMVqLC4Lhdn5gB1MRaElqXNoIYgmF4VBXmIYg8CwDng2ILxBDwNgABUkVoHX5gUDqVj0OVgme07zqR7heCVzBVh6i7lcSfrKuqqaaaajhsC25AduIXZVCNRT%2BcUyRdmAZB4QgJX9cG2YaRaqwWd2XBCBIHD1i4WYXZ9%2BYEDOLAYmDYbRvGjhJtID7Vcx%2BbFtLuuzH9hrA5L5bZnmdXUmcSQgA%3D",
)

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

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:29,positionColumn:1,positionLineNumber:29,selectionStartColumn:1,selectionStartLineNumber:29,startColumn:1,startLineNumber:29),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B4,+13,+28,+9+,+54%7D%3B%0A%0A++++std::sort(foo.begin(),+foo.end())%3B%0A++++for(size_t+i+%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++++%7B%0A++++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+!'+!'%3B%0A++++%7D%0A++++std::cout+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B9,+8,+7,+6,+5,+4,+3,+2,+1%7D%3B%0A%0A++++std::partial_sort(foo.begin(),+foo.begin()+%2B+3,+foo.end())%3B%0A++++for(size_t+i+%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++++%7B%0A++++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+!'+!'%3B%0A++++%7D%0A++++std::cout+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== STL Algorithmes -- Mélange

- ```cpp std::random_shuffle()``` réordonne aléatoirement l'ensemble

```cpp
vector<int> foo{9, 8, 7, 6, 5, 4, 3, 2, 1};

random_shuffle(foo.begin(), foo.end());
// 1 8 3 7 9 4 2 6 5
// ou ...
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:15,positionColumn:1,positionLineNumber:15,selectionStartColumn:1,selectionStartLineNumber:15,startColumn:1,startLineNumber:15),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B9,+8,+7,+6,+5,+4,+3,+2,+1%7D%3B%0A%0A++std::random_shuffle(foo.begin(),+foo.end())%3B%0A++for(size_t+i+%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

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

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:31,positionColumn:1,positionLineNumber:31,selectionStartColumn:1,selectionStartLineNumber:31,startColumn:1,startLineNumber:31),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B1,+5,+6,+8%7D%3B%0A++++std::vector%3Cint%3E+bar%7B2,+5%7D%3B%0A++++std::vector%3Cint%3E+baz%3B%0A%0A++++std::merge(foo.begin(),+foo.end(),+bar.begin(),+bar.end(),+std::back_inserter(baz))%3B%0A++++for(size_t+i+%3D+0%3B+i+%3C+baz.size()%3B+%2B%2Bi)%0A++++%7B%0A++++++std::cout+%3C%3C+baz%5Bi%5D+%3C%3C+!'+!'%3B%0A++++%7D%0A++++std::cout+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B1,+5,+6,+8,+2,+5%7D%3B%0A%0A++++std::inplace_merge(foo.begin(),+foo.begin()+%2B+4,+foo.end())%3B%0A++++for(size_t+i+%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++++%7B%0A++++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+!'+!'%3B%0A++++%7D%0A++++std::cout+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

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

#codesample(
  "https://godbolt.org/#z:OYLghAFBqd5QCxAYwPYBMCmBRdBLAF1QCcAaPECAMzwBtMA7AQwFtMQByARg9KtQYEAysib0QXACx8BBAKoBnTAAUAHpwAMvAFYTStJg1DIApACYAQuYukl9ZATwDKjdAGFUtAK4sGe1wAyeAyYAHI%2BAEaYxCAAbAAcpAAOqAqETgwe3r56KWmOAkEh4SxRMQm2mPYFDEIETMQEWT5%2BXJXVGXUNBEVhkdFxiQr1jc05bcPdvSVlgwCUtqhexMjsHOYAzMHI3lgA1CYbbk7DxJish9gmGgCCm9u7mAdHAG6YDiSX13dmWww7Xn2hzcYmAJEICBYX1u32CBD2LCYwQgc2%2BJgA7FZbnsDpjvjiccN0CAQG8PsRgXDLnt%2BKgMRY2nsAKykPaxVnxDEAEUOWJuBL2RJJZKIFKOVI22D2EQa9LMrKZ3N5%2BIJQtJ71FlME1JlAC96YzYkqNnyVYSCMSUEt4cDgYKLSSIqhPGIkggmM83Ha1Q9AZgFNRnQA6KLAZELGnB1wo1ky4ghzBhhgx6UNIPRuZzT12sDrJluBi55XY1UOq1eG1Hb1lp0u2huj22o72y2%2BrAB2kJpMpzsZ2NMXVd8P9wcZrNNtx7Iv5wvrE0qpUwkv0s0t4Uaz7i7WSyN0zGMllsjnGvkCtUizfHbdSuNyhUn1fnjdiq8EHUD4t3Evmy1KAgAfS8BgMkDVAh2TCNewYdAUzjcDYLTPtU2QABrf9giURpoggPVM0/AV%2BGICA0l1TB/3hPBni5PYNF5PZKLtPUgxIzAUTo6xrDwVFv1xU8BTXctKy9Zs9RMJkLDwMTqInKcOFk/CCUXflS0tNAK2zZtpwLIt52XdEeSXZSVx4p9yS1N8d1pA0FVZdk9k5fSFJ/dczK3Cyb1lTF5WZB8TLLC8XwlDz9V0r9lOckA/3QwRoiUBwQM7UNh13dNoIQ%2BMkog/t4yQmVUOizCCGw3DUVCgiSGIvBSPI%2BiqJouiGJEgdmKq1jSosA5LE47jwt41cIrUoTGI/cTJKZaSq00uSdL4nElLPMtBo0yctNnBSlIXPE/MtALzOpKz9xso97N83rTM1Nz3wpLz70csqVJci7X3fELTW2kkovwKgqGiRhVlA%2BDIKjNKIzgzL0tSmDQaYfKMOiIqiJKpzIyIliasa6jaJNWrhsHFi2OxjjLC41djN6gbrWW1N9VGqSqdzeT7rmxz3sE%2Bm820uc%2BI2vTZoE3bLss51rOZWzjzuvnzsvILU2uixvMVCXH38589p3UTQuV39MAAhQAE8WDYAhiDwZB/y%2Bn6zn%2BVjEsTZKoKh7LAad3KYbQuGsMRgc8KZlHKuqii6qxjrGsnJj8fazqrGJnqBTJ/iBKWmTRNp8b2cZvn5oetmZNWmbNoMu4WZuDgFloTgmV4PwOC0UhUE4L0ussQUlhWJ5Nh4UgCE0UuFhQkAmQ0fROEkKue7rzheAUEAh%2B7mvS9IOBYCQTBVHeCsSHISgGmABRlEMKohAQVAAHdq87tAWCSOgmBqfeQloI/T%2Br2vL%2Bv%2BgYl35gkgUY%2BCFIN%2BdBoihFYGsXggCP4AHkKxPzPuPVe7wbjEF3pPUgCDkB1HwNXXg/BBAiDEOwKQMhBCKBUOoeepBdBtAMEYFARMbC0DwBEaekAFioCSDUaeHAAC0RJDhclME3BkXA9jcIAOpiFoKIsRq9jZMF4KgN4xATbtngAsYgQFHBsAACrOloCwmMChW6rD0ESYI99D7HzgdwXgxtMBrE7ifYgTAkg9zLhXMeFD64cGwGvZAG9iB7FUPEWI3DYiSD2MAZAyA9gQGNkBFCWYICN2jjYPYuBCAkE6hsLgcxbFuIWAgc4WAYgxn7oPYeHBR6kBfgo1B09Z4FMqWYTxtdvH5PnpmUgSi0jOEkEAA%3D%3D%3D",
)

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

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:27,positionColumn:1,positionLineNumber:27,selectionStartColumn:1,selectionStartLineNumber:27,startColumn:1,startLineNumber:27),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B10,20,30,5,15%7D%3B%0A%0A++std::make_heap(foo.begin(),+foo.end())%3B%0A++std::cout+%3C%3C+foo.front()+%3C%3C+!'%5Cn!'%3B%0A%0A++std::pop_heap(foo.begin(),+foo.end())%3B%0A++foo.pop_back()%3B%0A++std::cout+%3C%3C+foo.front()+%3C%3C+!'%5Cn!'%3B%0A%0A++foo.push_back(99)%3B%0A++std::push_heap(foo.begin(),+foo.end())%3B%0A++std::cout+%3C%3C+foo.front()+%3C%3C+!'%5Cn!'%3B%0A%0A++std::sort_heap(foo.begin(),+foo.end())%3B%0A++for(size_t+i+%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

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

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:10,positionColumn:1,positionLineNumber:10,selectionStartColumn:1,selectionStartLineNumber:10,startColumn:1,startLineNumber:10),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B18,+5,+6,+8%7D%3B%0A%0A++std::cout+%3C%3C+*std::min_element(foo.begin(),+foo.end())+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+*std::max_element(foo.begin(),+foo.end())+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

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

#codesample(
  "https://godbolt.org/#z:OYLghAFBqd5QCxAYwPYBMCmBRdBLAF1QCcAaPECAMzwBtMA7AQwFtMQByARg9KtQYEAysib0QXACx8BBAKoBnTAAUAHpwAMvAFYTStJg1DIApACYAQuYukl9ZATwDKjdAGFUtAK4sGe1wAyeAyYAHI%2BAEaYxCAArAAcpAAOqAqETgwe3r56KWmOAkEh4SxRMQm2mPYFDEIETMQEWT5%2BXJXVGXUNBEVhkdFxiQr1jc05bcPdvSVlgwCUtqhexMjsHOYAzMHI3lgA1CYbbk7DxJish9gmGgCCm9u7mAdHAG6YDiSX13dmWww7Xn2hzcDB80Twpg2V1u32CBD2LCYwQgc2%2BJgA7FZbnsDpjvjiccN0CAQG8PsRgXDLnt%2BKgMRYuIk9rFSHsAGys%2BIYgAihyxNwJeyJJLQXnhwOBQoIxJATGQyB8XgMBEw1FQqAAdFFgMiFjT1RrXCjWW0pTKWErHElaHhMApKYJLii5s83JKwOtYiCPXz8bjeTDsbj%2BYLhaT3kQKUcqVD9XTMYzWSz2Zyeb6g4TpSSyZGHQRqREGum7hmzSSmOhtHLGAQAPr4KhUaKMVZqzXa3Ws2mGhjoY17QvIADWteCSka0QgheIerDLGCXnt0cdUOdxcF/GIEDSAC9MLX4Xhnty9ho%2BXsj5Lpxrd6rURsLAdLNY8KjS/S/aGsygluKjlei1iCw8BMWITwlI49g9KD1gfT9/XgsNRT/N1IJ9L0GB9OCgzTQMBWDRDvxzT5l3zWNaXpU0zFZDZWUkNNsPwzMZWIqNjhXbAByLTFqL2Wi9mkZkGP5QiZWQ11JTDYIQmIWskmIDAvAcNstUwHUGH7bsjT1a8Ow0vUNBdCC3Bg0DvVgkMELwnEP1LMNWLzakKITVleP4%2Bj0V5RivxYiMSPYsjOOnYtRJJJJujwMRawUHwVL0zSDW01lBxHMdohVLdpzme9LJxTdtzwPcDwvY9T3PS9IOvW8UXPawXzfJiCNLZiRV/CTKsA4DQPA/80I4UzvIJXDGqQtrjNMjCsMs4a0V%2BPAqDKoMAHolr2AAxOVI1tWh6D9WyRqIvy2JjTjnIZVyaLo4TQvDclHNjYLGJu8LGki2hoti7t4r1LTe37FLRwYccMqnBpZ2/C1aCtG07Xu7A10GvKSAKorD1Ks8HxKgDiBvQq71q59LFfeD9sFFqfzFdqTOCoCQLAqmYIG3KrIOsSxt6kz0PM9cWc2Vx5rRTzvg4BZaE4WJeD8DgtFIVBODdQnHwUJYVieTYeFIAhNBFhYhziDR9E4SRJe12XOF4BQQANrXpZF0g4FgJBMFUd4xRIchKAaYAFGUQwqiEBBUAAdyljW0BYJI6CYGpfZCWgA%2BDqWZfDyP6Bib3mCSBRA4IUgU7oaJQlYNZeHztOAHkxQTkPTed94bmIb3zdIOvkDqfApd4fhBBEMR2CkGRBEUFR1Ft0hdDaAwjBQOrLH0PAIktyAFlQJIaktjgAFoiUOblTEVrguD2TeAHUxFoY%2BT%2BdghiCYXhUDeYhiDwLAl%2BNYgvEEPA2AAFXVWg34LGVssVYegiTBFjv7QONduC8BvpgNYGsg63ySNrUW4sTZjzlhwbALsFSRj2KoeIbJN5skkHsYA8o9gQBvp/IcLoIAKysHPPYuBCAkCfBsLgcw4FoIWAgc4WAYjGj1rEA2YsODG1IEne%2BzdLbWz4YbDgZhMEy2wbw222VSCPzSM4SQQA%3D%3D%3D",
)

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

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:13,positionColumn:1,positionLineNumber:13,selectionStartColumn:1,selectionStartLineNumber:13,startColumn:1,startLineNumber:13),source:'%23include+%3Ciostream%3E%0A%23include+%3Citerator%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B5,+6,+12,+89%7D%3B%0A++std::ostream_iterator%3Cint%3E+out_it+(std::cout,+%22,+%22)%3B%0A%0A++std::copy(foo.begin(),+foo.end(),+out_it)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

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

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:26,startColumn:1,startLineNumber:26),source:'%23include+%3Ciostream%3E%0A%0Anamespace+V1%0A%7B%0A++static+void+foo()%0A++%7B%0A++++std::cout+%3C%3C+%22V1%5Cn%22%3B%0A++%7D%0A%7D%0A%0Ainline+namespace+V2%0A%7B%0A++static+void+foo()%0A++%7B%0A++++std::cout+%3C%3C+%22V2%5Cn%22%3B%0A++%7D%0A%7D%0A%0Aint+main()%0A%7B%0A++V1::foo()%3B%0A++V2::foo()%3B%0A%0A++foo()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

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

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astatic+void+foo(char*)%0A%7B%0A++std::cout+%3C%3C+%22chaine%5Cn%22%3B%0A%7D%0A%0Astatic+void+foo(int)%0A%7B%0A++std::cout+%3C%3C+%22entier%5Cn%22%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++foo(0)%3B%0A%23if+1%0A++foo(NULL)%3B%0A%23else%0A++foo(nullptr)%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

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

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++static_assert(sizeof(int)+%3D%3D+3,+%22Taille+incorrecte%22)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

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

```cpp
constexpr int foo() { return 42; }

char bar[foo()];
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astatic+constexpr+int+foo()%0A%7B%0A++return+42%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++char+bar%5Bfoo()%5D+%3D+%22azerty%22%3B%0A%0A++std::cout+%3C%3C+bar+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("N2235")

== ``` constexpr```

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

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astatic+constexpr+int+foo()%0A%7B%0A++return+42%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++int+a+%3D+42%3B%0A++switch(a)%0A++%7B%0A++++case+foo():%0A++++++std::cout+%3C%3C+%22case+foo%5Cn%22%3B%0A++++++break%3B%0A%0A++++default:%0A++++++std::cout+%3C%3C+%22defuault%5Cn%22%3B%0A++++++break%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("N2235")

== ``` constexpr```

- Sous certaines conditions restrictives, ```cpp const``` sur une variable est suffisant

// type entier ou énumération, initialisé à la déclaration par une expression constante

```cpp
const int a = 42;
char bar[a];
```

#alertblock(text[_Variable-Length Array_], text[
  - Pas de rapport entre VLA et ```cpp constexpr```
  - VLA est un mécanisme _run-time_
])

// VLA est une fonctionnalité C, non reprise en C++, mais proposée sous forme d'extension par certains compilateurs. Elle consiste à accepter les tableaux de taille définie au run-time

#adviceblock("Do", text[
  - Déclarez ```cpp constexpr``` les constantes et fonctions évaluables en _compile-time_
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:13,endLineNumber:6,positionColumn:13,positionLineNumber:6,selectionStartColumn:13,selectionStartLineNumber:6,startColumn:13,startLineNumber:6),source:'%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++const+int+a+%3D+42%3B%0A++char+bar%5Ba%5D+%3D+%22azerty%22%3B%0A%0A++std::cout+%3C%3C+bar+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Extended ``` sizeof```}

- ```cpp sizeof``` sur des membres non statiques


```cpp
struct Foo { int bar; };

// Valide en C++11, mal-forme en C++98/03
cout << sizeof Foo::bar;
```

// Mal-formé (ill-formed) n'implique pas une erreur de compilation ni même un avertissement, seulement que ce n'est pas correct vu de la norme

#noteblock("Note", text[
  - En pratique, cet exemple compile en mode C++98 sous GCC
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astruct+Foo%0A%7B%0A++int+bar%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+sizeof+Foo::bar+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("n2253")

== Sémantique de déplacement

- Deux constats
  - Copie potentiellement coûteuse ou impossible
  - Copie inutile lorsque l'objet source est immédiatement détruit

#noteblock("Optimisation des copies", text[
  - Partiellement adressé en C++98/03 par l'élision de copie et (N)RVO
])

- Échange de données légères plutôt que copie profonde
- Déplacement seulement si
  - Type déplaçable
  - Instance sur le point d'être détruite ou explicitement déplacée

#alertblock("Attention", text[
  - Les données ne sont plus présentes dans l'objet initial
])

#addproposal("N2118")
#addproposal("n2439")
#addproposal("N2844")
#addproposal("N3053")

== Sémantique de déplacement}

- Copie

// TODO

#cetz.canvas(length: 1em, {
  import cetz.draw: *
  // Your drawing code goes here

  // Draw a rect from A(0, 0) to B(1, 1)
  rect((0, 0), (1, 1), name: "a")
  rect((1, 0), (2, 1))

  rect((1, -1), (2, -1.5))
  content("a", [A])
  // Show the points
  set-style(content: (frame: "circle", padding: 1pt, fill: white))
  content((0, 0), [A])
  content((1, 1), [B])
})

/*
  #diagram(
    node-stroke: 0.06em,
    spacing: (0em, 2em),
    label-size: 0.5em,

    node(
      (0, 0),
      inset: 0em,
      [#table(
        columns: (10fr, 9fr, 9fr),
        align: horizon,
        stroke: 0.4pt + black,
        text(weight: "regular")[Vecteur 1], text(weight: "regular")[Cap n], text(weight: "regular")[Taille n],
      )],
      name: <vec1>,
      width: 15em,
    ),

    node((1, 0), [], name: <spacer>, width: 1em, stroke: 1em),

    node(
      (2, 0),
      inset: 0em,
      [#table(
        columns: (10fr, 9fr, 9fr),
        align: horizon,
        stroke: 0.4pt + black,
        text(weight: "regular")[Vecteur 2], text(weight: "regular")[Cap 0], text(weight: "regular")[Taille 0],
      )],
      name: <vec2>,
      width: 15em,
    ),

    node(
      (rel: (0,0) to),
//(0,1),
      inset: 0em,
      [#table(
        columns: (1fr, 1fr, 1fr, 1fr),
        align: horizon,
        stroke: 0.4pt + black,
        text(weight: "regular")[Obj1], text(weight: "regular")[Obj2], text(weight: "regular")[...],text(weight: "regular")[Objn],
      )],
      name: <vec2>,
      width: 10em,

    ),

    node(
      (2, 1),
      inset: 0em,
      [#table(
        columns: (1fr),
        align: horizon,
        stroke: 0.4pt + black,
        text(weight: "regular")[_null_],
      )],
      name: <vec2>,
      width: 2.5em,
    ),


    //      node((1,1), [Obj1],name: <tail2>, width: 3em),
    //      node((2,1), [Obj2],name: <tail2>, width: 3em),
    //      node((3,1), [...],name: <tail2>, width: 3em),
    //      node((4,1), [Objn],name: <tail2>, width: 3em),
*/
/*      node((0, 0), [Input], name: <input>, width: 3.5em),
  node((2, 0), [Output], name: <output>, width: 3.5em),
  node((1, 1), [Forward], shape: rect, name: <forward>, width: 7.5em),
  node((1, 2), [Bidirectional], shape: rect, name: <bidir>, width: 7.5em),
  node((1, 3), [Random Access], shape: rect, name: <random>, width: 7.5em),
  edge(
    <input.south>,
    ((), "```-", ((), 50%, <forward.north>)),
    ((), "-```", ((), 100%, <forward.north>)),
    <forward.north>,
    "<```-",
  ),
  edge(
    <output.south>,
    ((), "```-", ((), 50%, <forward.north>)),
    ((), "-```", ((), 100%, <forward.north>)),
    <forward.north>,
    "<```-",
  ),
  edge(<forward>, <bidir>, "<```-"),
  edge(<bidir>, <random>, "<```-"),
)*/

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

== Sémantique de déplacement}

- Copie

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



== Sémantique de déplacement}

- Copie

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



== Sémantique de déplacement}

- Copie

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



== Sémantique de déplacement}

- Déplacement

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



== Sémantique de déplacement}

- Déplacement

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


== Sémantique de déplacement

- _rvalue reference_
  - Référence sur un objet temporaire ou sur le point d'être détruit
  - Noté par une double esperluette : ```cpp T&& value```
- Deux fonctions de conversion
  - ```cpp std::move()``` convertit le paramètre en _rvalue_

  // std::move force la sémantique de déplacement sur l'objet}

  - ```cpp std::forward()``` convertit le paramètre en _rvalue_ s'il n'est pas une _lvalue reference_

#noteblock(text[_rvalue_, _lvalue_, ... ?}], text[
  - Voir #link("http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2012/n3337.pdf")[N3337 #linklogo() §3.10]
])

#noteblock(text[``` std::forward()``` ?}], text[
  - _perfect forwarding_ (Voir #link("http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2002/n1385.htm")[N1385 #linklogo])
])

== Sémantique de déplacement

- Rendre une classe déplaçable
  - Constructeur par déplacement ```cpp T(const T&&)```
  - Opérateur d'affectation par déplacement ```cpp T& operator=(const T&&)```

#noteblock("Génération implicite", text[
  - Pas de constructeur par copie, d'opérateur d'affectation, de destructeur, ni l'autre déplacement _user-declared_
])

#alertblock(text[_user-declared_ ? _user-provided_ ?], text[
  - _user-declared_ : fonction déclarée par l'utilisateur, y compris ```cpp =default```
  - _user-provided_ : corps de la fonction fourni par l'utilisateur
])

== Sémantique de déplacement}

#noteblock(text[_Rule of five_], text[
  - Si une classe déclare destructeur, constructeur par copie ou par déplacement, affectation par copie ou par déplacement, alors elle doit définir les cinq

  // Contrairement à Rule of three, l'absence des constructeur et opérateur d'affectation par déplacement n'est pas une erreur grave, mais une optimisation manquée
])

#noteblock(text[_Rule of zero_], text[
  - Lorsque c'est possible, n'en définissez aucune

  // Rule of zero s'applique typiquement aux classes sans gestion explicite d'ownership, c'est à dire sans membres qu'il faut explicitement libérés, fermés, ... Ce qui devrait être le cas par défaut
])

#noteblock("Pour aller plus loin", text[
  - Voir #link("https://github.com/cppp-france/CPPP-19/blob/master/elegance_style_epure_et_classe-Loic_Joly/elegance_style_epure_et_classe-Loic_Joly.pdf")[Élégance, style épuré et classe #linklogo() (Loïc Joly)]
])

== Sémantique de déplacement}

#noteblock("Dans la bibliothèque standard", text[
  - Nombreuses classes standards déplaçables (thread, flux, ...)

  // Mutex et lock ne sont pas copiables ni déplaçables

  - Évolution de contraintes : déplaçable plutôt que copiable

  // Évolution des contraintes notamment pour les conteneurs et les algorithmes

  - Implémentations utilisant le déplacement si possible
])

\

== Initializer list

- Initialisation des conteneurs

```cpp
vector<int> foo;
foo.push_back(1);
foo.push_back(56);
foo.push_back(18);
foo.push_back(3);

// Devient

vector<int> foo{1, 56, 18, 3};
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B1,+56,+18,+3%7D%3B%0A%0A++std::cout+%3C%3C+foo.size()+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("N2672")

== Initializer list

- Classe ```cpp std::initializer_list``` pour accéder aux valeurs de la liste

#alertblock("Accéder, pas contenir !", text[
  - ```cpp std::initializer_list``` référence mais ne contient pas les valeurs
  - Valeurs contenues dans un tableau temporaire de même durée de vie
  - Copier un ```cpp std::initializer_list``` ne copie pas les données
])

- Fonctions membres ```cpp size()```, ```cpp begin()```, ```cpp end()```
- Construction automatique depuis une liste de valeurs entre accolades

== Initializer list

- Constructeurs peuvent prendre un ```cpp std::initializer_list``` en paramètre

```cpp
MaClasse(initializer_list<value_type> itemList);
```

- Ainsi que toute autre fonction
- Intégré aux conteneurs de la bibliothèque standard

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cinitializer_list%3E%0A%0Astruct+Foo%0A%7B%0A++Foo(std::initializer_list%3Cint%3E+l)+:+m_vec(l)%0A++%7B%0A++++std::cout+%3C%3C+l.size()+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0A++void+append(std::initializer_list%3Cint%3E+l)%0A++%7B%0A++++for(std::initializer_list%3Cint%3E::iterator+it+%3D+l.begin()%3B+it+!!%3D+l.end()%3B+%2B%2Bit)%0A++++%7B%0A++++++m_vec.push_back(*it)%3B%0A++++%7D%0A++%7D%0A%0A++std::vector%3Cint%3E+m_vec%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++Foo+foo+%3D+%7B1,+2,+3,+4,+5%7D%3B%0A++for(size_t+i+%3D+0%3B+i+%3C+foo.m_vec.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+foo.m_vec%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%0A++foo.append(%7B6,+7,+8%7D)%3B%0A++for(size_t+i+%3D+0%3B+i+%3C+foo.m_vec.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+foo.m_vec%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)


== Initializer list

#adviceblock("Do", text[
  - Préférez ```cpp std::initializer_list``` aux insertions successives
])

#alertblock("Don't", text[
  - N'utilisez pas ```cpp std::initializer_list``` pour copier ou transformer
  - Utilisez les algorithmes et constructeurs idoines
])

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
  - Pas de troncature avec ```cpp {}```

  ```cpp
  int foo{2.5};  // Erreur
  ```
])

#alertblock("Attention", text[
  - Si le constructeur par ```cpp std::initializer_list``` existe, il est utilisé

  ```cpp
  vector<int> foo{2};  // 2
  vector<int> foo(2);  // 0 0
  ```
])

== Uniform Initialization

#alertblock("Contraintes sur l'initialisation d'agrégats", text[
  - Pas d'héritage
  - Pas de constructeur fourni par l'utilisateur
  - Pas d'initialisation _brace-or-equal-initializers_
  - Pas de fonction virtuelle ni de membre non statique protégé ou privé
])

#adviceblock("Do", text[
  - Préférez l'initialisation ```cpp {}``` aux autres formes
])

== ``` auto```

- Déduction (ou inférence) de type depuis l'initialisation

#alertblock("Attention", text[
  - Inférence de type $\neq$ typage dynamique
  - Inférence de type $\neq$ typage faible
  - Typage dynamique $\neq$ typage faible
])

#noteblock("Vocabulaire", text[
  - Statique : type porté par la variable et ne varie pas
  - Dynamique : type porté par la valeur
  - Absence : variable non typée, type imposé par l'opération
])

#addproposal("N1984")
#addproposal("n1737")
#addproposal("n2546")

== ``` auto```

- ```cpp auto``` définit une variable dont le type est déduit

```cpp
auto i = 2;  // int
```

- Règles de déduction proches de celles des templates
- Listes entre accolades inférées comme des ```cpp std::initializer_list```

#alertblock("Attention", text[
  - Référence, ```cpp const``` et ```cpp volatile``` perdus durant la déduction

  ```cpp
  const int i = 2;
  auto j = i;  // int
  ```
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ctypeinfo%3E%0A%23include+%3Ccassert%3E%0A%0Aint+main()%0A%7B%0A++auto+i+%3D+2%3B+%0A++assert(typeid(i)+%3D%3D+typeid(int))%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== ``` auto```

- Combinaison possible avec ```cpp const```, ```cpp volatile``` ou ```cpp &```

```cpp
const auto i = 2;

int j = 3;
auto& k = j;
```

- Typer explicitement l'initialiseur permet de forcer le type déduit

```cpp
// unsigned long
auto i = static_cast<unsigned long>(2);
auto j = 2UL
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ctypeinfo%3E%0A%23include+%3Ccassert%3E%0A%0Aint+main()%0A%7B%0A++auto+i+%3D+static_cast%3Cunsigned+long%3E(2)%3B%0A++assert(typeid(i)+%3D%3D+typeid(unsigned+long))%3B%0A++%0A++auto+j+%3D+2UL%3B%0A++assert(typeid(j)+%3D%3D+typeid(unsigned+long))%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== ``` auto```

- Tendance forte "Almost Always Auto" (AAA)

#noteblock("Pour aller plus loin", text[
  - Voir #link("href{https://herbsutter.com/2013/08/12/gotw-94-solution-aaa-style-almost-always-auto/")[GotW 94 : AAA Style #linklogo()]
])

- Plusieurs avantages
  - Variables forcément initialisées
  - Typage correct et précis
  - Garanties conservées au fil des corrections et refactoring
  - Généricité et simplification du code

#noteblock("Quiz", text[
  - Type de retour de ```cpp std::list<std::string>::size()``` ?
])

== ``` auto```

- Limitations - solutions
  - Erreur de déduction - typage explicite de l'initialiseur
  - Initialisation impossible - ```cpp decltype```
  - Interfaces, rôles, contexte - concepts ?

//Mais il faut attendre C++20 pour avoir les concepts

#alertblock("Compatibilité", text[
  - ```cpp auto``` présent en C++98/03 avec un sens radicalement différent

  // Sens en C++98/03 : variable de type automatique (c'est à dire sur la pile) par opposition à statique (cas par défaut et donc inutilisé en pratique)
])

== ``` decltype```

- Déduction du type d'une variable ou d'une expression
- Permet donc la création d'une variable du même type

```cpp
int a;
long b;

decltype(a) c;         // int
decltype(a + b) d;     // long
```

- Généralement, déduction sans aucune modification du type
// Donc conservation des références, const, etc.
- Depuis une _lvalue_ de type ```cpp T``` autre qu'un nom de variable : ```cpp T&```

```cpp
decltype( (a) ) e;     // int&
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ctypeinfo%3E%0A%23include+%3Ccassert%3E%0A%0Aint+main()%0A%7B%0A++int+a%3B%0A++long+b%3B%0A%0A++decltype+(a)+c%3B%0A++decltype+(a+%2B+b)+d%3B%0A%0A++assert(typeid(c)+%3D%3D+typeid(int))%3B%0A++assert(typeid(d)+%3D%3D+typeid(long))%3B%0A%0A%23if+0%0A++decltype(+(a)+)+e%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("N2343")
#addproposal("N3276")

== ``` declval```

- Utilisation de fonctions membres dans ```cpp decltype``` sans instance
- Typiquement sur des templates acceptant des types sans constructeur commun mais avec une fonction membre commune

```cpp
struct foo {
  foo(const foo&) {}
  int bar () const { return 1; }
};

decltype(foo().bar()) a = 5;               // Erreur
decltype(std::declval<foo>().bar()) b = 5; // OK, int
```

#alertblock("Attention", text[
  - Uniquement dans des contextes non évalués
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Cutility%3E%0A%23include+%3Ctypeinfo%3E%0A%23include+%3Ccassert%3E%0A%0Astruct+foo%0A%7B%0A++foo(const+foo%26)+%7B%7D%0A++int+bar()+const+%7B+return+1%3B+%7D%0A%7D%3B%0A%0Aint+main()%0A%7B%0A%23if+0%0A++decltype(foo().bar())+a+%3D+5%3B%0A%23endif%0A++decltype(std::declval%3Cfoo%3E().bar())+b+%3D+5%3B%0A%0A++assert(typeid(b)+%3D%3D+typeid(int))%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Déduction du type retour

- Combinaison de ```cpp auto``` et ```cpp decltype```

```cpp
auto add(int a, int b) -> decltype(a + b) {
  return a + b;
}
```

- Particulièrement utiles pour des fonctions templates

#noteblock(text[Quiz : ``` T```, ``` U``` ou autre ?], text[
  ```cpp
  template<typename T, typename U> ??? add(T a, U b) {
    return a + b;
  }
  ```
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Cutility%3E%0A%23include+%3Ctypeinfo%3E%0A%23include+%3Ccassert%3E%0A%0Aauto+add(int+a,+int+b)+-%3E+decltype(a+%2B+b)+%0A%7B%0A++return+a+%2B+b%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++auto+i+%3D+add(1,+3)%3B%0A++assert(typeid(i)+%3D%3D+typeid(int))%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("n2541")

== Déduction du type retour}

#noteblock("Solution", text[
  - Pas de bonne réponse en typage explicite
  // Une solution historique : un seul type template et on compte sur les conversions implicites voire on demande des conversions explicites
  - Mais l'inférence de type vient à notre secours
])

```cpp
template<typename T, typename U>
auto add(T a, U b) -> decltype(a + b) {
  return a + b;
}
```

#adviceblock("do", text[
  - Utilisez la déduction du type retour dans vos fonctions templates
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Cutility%3E%0A%23include+%3Ctypeinfo%3E%0A%23include+%3Ccassert%3E%0A%0Atemplate%3Ctypename+T,+typename+U%3E%0Aauto+add(T+a,+U+b)+-%3E+decltype(a+%2B+b)%0A%7B%0A++return+a+%2B+b%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++auto+i+%3D+add(1UL,+3)%3B%0A++assert(typeid(i)+%3D%3D+typeid(unsigned+long))%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("n2541")

== ``` std::array```

- ```cpp std::array```
  - Tableau de taille fixe connue à la compilation
  - Éléments contigus
  - Accès indexé

```cpp
array<int, 8> foo{2, 5, 9, 8, 2, 6, 8, 9};

accumulate(foo.begin(), foo.end(), 0); // 49
```

```cpp
array<int, 8> foo{2, 5, 9, 8, 2, 6, 8, 9, 17};
// Erreur de compilation
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Carray%3E%0A%23include+%3Cnumeric%3E%0A%0Aint+main()%0A%7B%0A++std::array%3Cint,+8%3E+foo%7B2,+5,+9,+8,+2,+6,+8,+9,+17%7D%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Carray%3E%0A%23include+%3Cnumeric%3E%0A%0Aint+main()%0A%7B%0A++std::array%3Cint,+8%3E+foo%7B2,+5,+9,+8,+2,+6,+8,+9%7D%3B%0A++std::cout+%3C%3C+std::accumulate(foo.begin(),+foo.end(),+0)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("n1836")

== ``` std::array```


#list(marker: [ ], text[
  - Vérification des index à la compilation
])

```cpp
array<int, 8> foo{2, 5, 9, 8, 2, 6, 8, 9};

get<2>(foo);  // 9
get<8>(foo);  // Erreur de compilation
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Carray%3E%0A%0Aint+main()%0A%7B%0A++std::array%3Cint,+8%3E+foo%7B2,+5,+9,+8,+2,+6,+8,+9%7D%3B%0A++std::cout+%3C%3C+std::get%3C2%3E(foo)+%3C%3C+!'%5Cn!'%3B%0A%23if+0%0A++std::cout+%3C%3C+std::get%3C8%3E(foo)+%3C%3C+!'%5Cn!'%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("n1836")

== ``` std::forward_list```

- Liste simplement chaînée ```cpp std::forward_list```

```cpp
forward_list<int> foo{2, 5, 9, 8, 2, 6, 8, 9, 12};

accumulate(foo.begin(), foo.end(), 0); // 61
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cforward_list%3E%0A%23include+%3Cnumeric%3E%0A%0Aint+main()%0A%7B%0A++std::forward_list%3Cint%3E+foo%7B2,+5,+9,+8,+2,+6,+8,+9,+12%7D%3B%0A%0A++std::cout+%3C%3C+std::accumulate(foo.begin(),+foo.end(),+0)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Conteneurs associatifs

- Conteneurs associatifs sous forme de tables de hachage
  - ```cpp std::unordered_map```
  - ```cpp std::unordered_multimap```
  - ```cpp std::unordered_set```
  - ```cpp std::unordered_multiset```
- Versions non ordonnées de ```cpp std::map```, ```cpp std::set```, ...

#noteblock(text[``` unordered_<XXX>``` ?], text[
  - Nombreuses implémentations ```cpp hash_<XXX>``` existantes
  - Structures fondamentalement non ordonnées
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%23include+%3Cunordered_map%3E%0A%0Aint+main()%0A%7B%0A++std::unordered_map%3Cint,+std::string%3E+foo%7B%7B5,+%22Une+chaine%22%7D,+%7B42,+%22La+reponse%22%7D%7D%3B%0A%0A++std::cout+%3C%3C++foo%5B42%5D+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("n1836")

== ``` shrink_to_fit()```

- ```cpp shrink_to_fit()``` réduit la capacité des ```cpp std::vector```, ```cpp std::deque``` et ```cpp std::string``` à leur taille
// Pour être précis, ce n'est pas nécessairement exactement à la taille ça peut être plus grand - à la discrétion de l'implémentation (performances, cohérence, ...) -, mais l'idée est là

```cpp
vector<int> foo{12, 25};

foo.reserve(15);      // Taille : 2, capacite : 15
foo.shrink_to_fit();  // Taille : 2, capacite : 2
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B12,+25%7D%3B%0A++foo.reserve(15)%3B%0A++std::cout+%3C%3C+foo.size()+%3C%3C+%22+/+%22+%3C%3C+foo.capacity()+%3C%3C+!'%5Cn!'%3B%0A%0A++foo.shrink_to_fit()%3B%0A++std::cout+%3C%3C+foo.size()+%3C%3C+%22+/+%22+%3C%3C+foo.capacity()+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== ``` data()```

- ```cpp data()``` récupère le "tableau C" d'un ```cpp std::vector```

#noteblock(text[``` foo.data()``` ou ``` &foo[0]``` ?], text[
  - Comportement identique
  - Préférez ```cpp foo.data()``` sémantiquement plus clair
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Avoid+bar(const+int*+data,+const+size_t+size)%0A%7B%0A++for(size_t+i+%3D+0%3B+i+%3C+size%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+data%5Bi%5D+%3C%3C+%22%5Cn%22%3B%0A++%7D%0A%7D%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B12,+25%7D%3B%0A%0A++bar(foo.data(),+foo.size())%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== ``` emplace()```

- ```cpp emplace()```, ```cpp emplace_back()``` et ```cpp emplace_front()``` construisent dans le conteneur depuis les paramètres d'un des constructeurs de l'élément

```cpp
class Point {
public:
  Point(int a, int b);
};

vector<Point> foo;
foo.emplace_back(2, 5);
```

#noteblock("Objectif", text[
  - Éliminer des copies inutiles et gagner en performance
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Aclass+Point+%0A%7B%0Apublic:%0A++Point(int+a,+int+b)%0A++++:+m_a(a)%0A++++,+m_b(b)%0A++%7B%0A++%7D%0A%0A++int+m_a%3B%0A++int+m_b%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++std::vector%3CPoint%3E+foo%3B%0A++foo.emplace_back(2,+5)%3B%0A%0A++std::cout+%3C%3C+foo%5B0%5D.m_a+%3C%3C+%22+%22+%3C%3C+foo%5B0%5D.m_b+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

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

```cpp
bitset<5> foo;
foo.all();        // False

foo.set(2);
foo.to_ullong();  // 4

foo.set();
foo.all();        // True
foo.to_ullong();  // 31
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cbitset%3E%0A%0Aint+main()%0A%7B%0A++std::bitset%3C5%3E+foo%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+foo.all()+%3C%3C+!'%5Cn!'%3B%0A%0A++foo.set(2)%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+foo.all()+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+foo.to_ullong()+%3C%3C+!'%5Cn!'%3B%0A%0A++foo.set()%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+foo.all()+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+foo.to_ullong()+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Conteneurs - Choix

#adviceblock("Do", text[
  - Préférez ```cpp std::array``` lorsque la taille est fixe et connue
  - Sinon préférez ```cpp std::vector```
])

\

== Itérateurs

- Fonctions membres ```cpp cbegin()```, ```cpp cend()```, ```cpp crbegin()``` et ```cpp crend()``` retournant des ```cpp const_iterator```
// Les fonctions begin(), end(), etc. retournent des const_iterator si le conteneur est const, des iterator dans le cas contraire
- Fonctions libres ```cpp std::begin()``` et ```cpp std::end()```
  - Conteneur : appel des fonctions membres
  - Tableau C : adresse du premier élément et suivant le dernier élément

```cpp
int foo[] = {1, 2, 3, 4};
vector<int> bar{2, 3, 4, 5};

accumulate(begin(foo), end(foo), 0);  // 10
accumulate(begin(bar), end(bar), 0);  // 14
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cnumeric%3E%0A%0Ausing+std::begin%3B%0Ausing+std::end%3B%0A%0Aint+main()%0A%7B%0A++int+foo%5B%5D+%3D+%7B1,+2,+3,+4%7D%3B%0A++std::vector%3Cint%3E+bar%7B2,+3,+4,+5%7D%3B%0A%0A++std::cout+%3C%3C+std::accumulate(begin(foo),+end(foo),+0)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::accumulate(begin(bar),+end(bar),+0)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Itérateurs

#list(marker: [ ], text[
  - Compatibles avec les conteneurs non-STL proposant ```cpp begin()``` et ```cpp end()```
  - Surchargeable sans modification du conteneur pour les autres
])

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

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cnumeric%3E%0A%0Ausing+std::begin%3B%0Ausing+std::end%3B%0A%0Aclass+Foo+%0A%7B%0Apublic:%0A++int*+first()+%7B+return+std::begin(m_data)%3B+%7D%3B%0A++int*+last()+%7B+return+std::end(m_data)%3B+%7D%3B%0A%0Aprivate:%0A++static+int+m_data%5B3%5D%3B%0A%7D%3B%0A%0Aint+Foo::m_data%5B3%5D+%3D+%7B5,+8,+12%7D%3B%0A%0Aint*+begin(Foo%26+foo)%0A%7B%0A++return+foo.first()%3B%0A%7D%0A%0Aint*+end(Foo%26+foo)%0A%7B%0A++return+foo.last()%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++Foo+foo%3B%0A%0A++std::cout+%3C%3C+std::accumulate(begin(foo),+end(foo),+0)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Itérateurs

#noteblock("Conseils", text[
  - ```cpp using std::begin``` et ```cpp using std::end``` permet l'ADL malgré la surcharge
])

#alertblock("Don't", text[
  - N'ouvrez pas le namespace ```cpp std``` pour spécialiser
])

#adviceblock("Do", text[
  - Préférez ```cpp std::begin()``` et ```cpp std::end()``` aux fonctions membres
])

== Itérateurs

- ```cpp std::prev()``` et ```cpp std::next()``` retournent l'itérateur suivant ou précédent
- Adaptateur d'itérateur ```cpp std::move_iterator``` retournant des _rvalue reference_ lors du déréférencement

```cpp
vector<string> foo(3), bar{"one","two","three"};

typedef vector<string>::iterator Iter;

copy(move_iterator<Iter>(bar.begin()),
     move_iterator<Iter>(bar.end()),
     foo.begin());
// foo : "one" "two" "three"
// bar : "" "" ""
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cstring%3E%0A%23include+%3Calgorithm%3E%0A%0Atypedef+std::vector%3Cstd::string%3E::iterator+Iter%3B%0A%0Aint+main()%0A%7B%0A++std::vector%3Cstd::string%3E+foo(3)%3B%0A++std::vector%3Cstd::string%3E+bar%7B%22one%22,%22two%22,%22three%22%7D%3B%0A++std::copy(std::move_iterator%3CIter%3E(bar.begin()),+std::move_iterator%3CIter%3E(bar.end()),+foo.begin())%3B%0A%0A++for(size_t+i+%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+%22!'%22+%3C%3C+foo%5Bi%5D+%3C%3C+%22!'+%22%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A++for(size_t+i+%3D+0%3B+i+%3C+bar.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+%22!'%22+%3C%3C+bar%5Bi%5D+%3C%3C+%22!'+%22%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:55.14360313315927,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:44.85639686684073,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cstring%3E%0A%0Atypedef+std::vector%3Cstd::string%3E::iterator+Iter%3B%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B5,+3,+8,+12%7D%3B%0A%0A++auto+it+%3D+std::begin(foo)%3B%0A++std::cout+%3C%3C+*it+%3C%3C+%22+%22+%3C%3C+*next(it)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:55.14360313315927,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:44.85639686684073,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Foncteurs prédéfinis

- Et bit à bit ```cpp std::bit_and()```
- Ou inclusif bit à bit ```cpp std::bit_or()```
- Ou exclusif bit à bit ```cpp std::bit_xor()```

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

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ciomanip%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cunsigned+char%3E+foo%7B0x10,+0x20,+0x30%7D%3B%0A++std::vector%3Cunsigned+char%3E+bar%7B0xFF,+0x25,+0x00%7D%3B%0A++std::vector%3Cunsigned+char%3E+baz%3B%0A%0A++std::transform(std::begin(foo),+std::end(foo),+std::begin(bar),+std::back_inserter(baz),+std::bit_xor%3Cunsigned+char%3E())%3B%0A%0A++for(size_t+i+%3D+0%3B+i+%3C+baz.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+std::hex+%3C%3C+std::setfill(!'0!')+%3C%3C+std::setw(2)+%3C%3C+static_cast%3Cunsigned+int%3E(baz%5Bi%5D)+%3C%3C+%22+%22%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:55.14360313315927,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'1',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:44.85639686684073,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ciomanip%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cunsigned+char%3E+foo%7B0x10,+0x20,+0x30%7D%3B%0A++std::vector%3Cunsigned+char%3E+bar%7B0xFF,+0x25,+0x00%7D%3B%0A++std::vector%3Cunsigned+char%3E+baz%3B%0A++std::transform(std::begin(foo),+std::end(foo),+std::begin(bar),+std::back_inserter(baz),+std::bit_or%3Cunsigned+char%3E())%3B%0A%0A++for(size_t+i+%3D+0%3B+i+%3C+baz.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+std::hex+%3C%3C+std::setfill(!'0!')+%3C%3C+std::setw(2)+%3C%3C+static_cast%3Cunsigned+int%3E(baz%5Bi%5D)+%3C%3C+%22+%22%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:55.14360313315927,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:44.85639686684073,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ciomanip%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cunsigned+char%3E+foo%7B0x10,+0x20,+0x30%7D%3B%0A++std::vector%3Cunsigned+char%3E+bar%7B0xFF,+0x25,+0x00%7D%3B%0A++std::vector%3Cunsigned+char%3E+baz%3B%0A%0A++std::transform(std::begin(foo),+std::end(foo),+std::begin(bar),+std::back_inserter(baz),+std::bit_and%3Cunsigned+char%3E())%3B%0A%0A++for(size_t+i+%3D+0%3B+i+%3C+baz.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+std::hex+%3C%3C+std::setfill(!'0!')+%3C%3C+std::setw(2)+%3C%3C+static_cast%3Cunsigned+int%3E(baz%5Bi%5D)+%3C%3C+%22+%22%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:55.14360313315927,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:44.85639686684073,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Algorithmes -- Recherche linéaire

- ```cpp std::find_if_not()``` recherche le premier élément ne vérifiant pas le prédicat

```cpp
vector<int> foo{1, 4, 5, 9, 12};

find_if_not(begin(foo), end(foo), is_odd); // 4
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Astatic+bool+is_odd(int+i)%0A%7B%0A++return+(i+%25+2)+%3D%3D+1%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B1,+4,+5,+9,+12%7D%3B%0A++std::cout+%3C%3C+*std::find_if_not(std::begin(foo),+std::end(foo),+is_odd)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:55.14360313315927,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:44.85639686684073,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Algorithmes -- Comparaison

- ```cpp std::all_of()``` teste si tous les éléments de l'ensemble vérifient un prédicat
- Retourne vrai si l'ensemble est vide

```cpp
vector<int> foo{1, 4, 5, 9, 12};
vector<int> bar{1, 5, 9};
vector<int> baz{4, 12};

all_of(begin(foo), end(foo), is_odd); // False
all_of(begin(bar), end(bar), is_odd); // True
all_of(begin(baz), end(baz), is_odd); // False
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Ausing+std::begin%3B%0Ausing+std::end%3B%0A%0Astatic+bool+is_odd(int+i)%0A%7B%0A++return+(i+%25+2)+%3D%3D+1%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B1,+4,+5,+9,+12%7D%3B%0A++++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::all_of(begin(foo),+end(foo),+is_odd)+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B1,+5,+9%7D%3B%0A++++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::all_of(begin(foo),+end(foo),+is_odd)+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B4,+12%7D%3B%0A++++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::all_of(begin(foo),+end(foo),+is_odd)+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Algorithmes -- Comparaison

- ```cpp std::any_of()``` teste si au moins un élément vérifie un prédicat
- Retourne faux si l'ensemble est vide

```cpp
vector<int> foo{1, 4, 5, 9, 12};
vector<int> bar{1, 5, 9};
vector<int> baz{4, 12};

any_of(begin(foo), end(foo), is_odd); // True
any_of(begin(bar), end(bar), is_odd); // True
any_of(begin(baz), end(baz), is_odd); // False
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Ausing+std::begin%3B%0Ausing+std::end%3B%0A%0Astatic+bool+is_odd(int+i)%0A%7B%0A++return+(i+%25+2)+%3D%3D+1%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B1,+4,+5,+9,+12%7D%3B%0A++++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::any_of(begin(foo),+end(foo),+is_odd)+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B1,+5,+9%7D%3B%0A++++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::any_of(begin(foo),+end(foo),+is_odd)+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B4,+12%7D%3B%0A++++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::any_of(begin(foo),+end(foo),+is_odd)+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Algorithmes -- Comparaison

- ```cpp std::none_of()``` teste si aucun élément ne vérifie le prédicat
- Retourne vrai si l'ensemble est vide

```cpp
vector<int> foo{1, 4, 5, 9, 12};
vector<int> bar{1, 5, 9};
vector<int> baz{4, 12};

none_of(begin(foo), end(foo), is_odd); // False
none_of(begin(bar), end(bar), is_odd); // False
none_of(begin(baz), end(baz), is_odd); // True
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Ausing+std::begin%3B%0Ausing+std::end%3B%0A%0Astatic+bool+is_odd(int+i)%0A%7B%0A++return+(i+%25+2)+%3D%3D+1%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B1,+4,+5,+9,+12%7D%3B%0A++++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::none_of(begin(foo),+end(foo),+is_odd)+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B1,+5,+9%7D%3B%0A++++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::none_of(begin(foo),+end(foo),+is_odd)+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B4,+12%7D%3B%0A++++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::none_of(begin(foo),+end(foo),+is_odd)+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Algorithmes -- Permutation

- ```cpp std::is_permutation()``` teste si un ensemble est la permutation d'un autre

```cpp
vector<int> foo{1, 4, 5, 9, 12};
vector<int> bar{1, 5, 4, 9, 12};
vector<int> baz{5, 4, 3, 9, 1};

is_permutation(begin(foo), end(foo), begin(bar)); // true
is_permutation(begin(foo), end(foo), begin(baz)); // false
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Ausing+std::begin%3B%0Ausing+std::end%3B%0A%0Aint+main()%0A%7B%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B1,+4,+5,+9,+12%7D%3B%0A++++std::vector%3Cint%3E+bar%7B5,+4,+12,+9,+1%7D%3B%0A%0A++++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_permutation(begin(foo),+end(foo),+begin(bar))+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B1,+4,+5,+9,+12%7D%3B%0A++++std::vector%3Cint%3E+bar%7B5,+4,+12,+7,+1%7D%3B%0A%0A++++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_permutation(begin(foo),+end(foo),+begin(bar))+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Algorithmes -- Copie

- ```cpp std::copy_n()``` copie les n premiers éléments d'un ensemble

```cpp
vector<int> foo{1, 4, 5, 9, 12}, bar;

copy_n(begin(foo), 3, back_inserter(bar)); // 1 4 5
```

- ```cpp std::copy_if()``` copie les éléments vérifiant un prédicat

```cpp
vector<int> foo{1, 4, 5, 9, 12}, bar;

copy_if(begin(foo), end(foo), back_inserter(bar), is_odd); // 1 5 9
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Astatic+bool+is_odd(int+i)%0A%7B%0A++return+(i+%25+2)+%3D%3D+1%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B1,+4,+5,+9,+12%7D%3B%0A++std::vector%3Cint%3E+bar%3B%0A%0A++std::copy_if(std::begin(foo),+std::end(foo),+std::back_inserter(bar),+is_odd)%3B%0A%0A++for(size_t+i+%3D+0%3B+i+%3C+bar.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+bar%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B1,+4,+5,+9,+12%7D%3B%0A++std::vector%3Cint%3E+bar%3B%0A%0A++std::copy_n(std::begin(foo),+4,+std::back_inserter(bar))%3B%0A%0A++for(size_t+i+%3D+0%3B+i+%3C+bar.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+bar%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Algorithmes -- Déplacement

- ```cpp std::move()``` déplace les éléments d'un ensemble du début vers la fin

```cpp
vector<string> foo{"aa", "bb", "cc"};
vector<string> bar;

move(begin(foo), end(foo), back_inserter(bar));
// foo : "", "", ""
// bar : "aa", "bb", "cc"
```

- ```cpp std::move_backward()``` déplace les éléments de la fin vers le début
- Versions "déplacement" de ```cpp std::copy()``` et ```cpp std::copy_backward()```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cstring%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cstd::string%3E+foo%7B%22aa%22,+%22bb%22,+%22cc%22%7D%3B%0A++std::vector%3Cstd::string%3E+bar%3B%0A%0A++std::move(std::begin(foo),+std::end(foo),+std::back_inserter(bar))%3B%0A%0A++for(size_t+i+%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+%22!'%22+%3C%3C+foo%5Bi%5D+%3C%3C+%22!'+%22%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A++for(size_t+i+%3D+0%3B+i+%3C+bar.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+%22!'%22+%3C%3C+bar%5Bi%5D+%3C%3C+%22!'+%22%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Algorithmes -- Partitionnement

- ```cpp std::is_partitioned()``` indique si un ensemble est partitionné
// C'est à dire si les éléments vérifiant un prédicat sont avant ceux ne le vérifiant pas

```cpp
vector<int> foo{4, 5, 9, 12};
vector<int> bar{9, 5, 4, 12};

is_partitioned(begin(foo), end(foo), is_odd); // false
is_partitioned(begin(bar), end(bar), is_odd); // true
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Astatic+bool+is_odd(int+i)%0A%7B%0A++return+(i+%25+2)+%3D%3D+1%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B4,+5,+9,+12%7D%3B%0A++std::vector%3Cint%3E+bar%7B9,+5,+4,+12%7D%3B%0A%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_partitioned(std::begin(foo),+std::end(foo),+is_odd)+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_partitioned(std::begin(bar),+std::end(bar),+is_odd)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Algorithmes -- Partitionnement

- ```cpp std::partition_copy()``` copie l'ensemble en le partitionnant
- ```cpp std::partition_point()``` retourne le point de partition d'un ensemble partitionné
  - C'est à dire le premier élément ne vérifiant pas le prédicat

```cpp
vector<int> foo{9, 5, 4, 12};

partition_point(begin(foo), end(foo), is_odd); // 4
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Astatic+bool+is_odd(int+i)%0A%7B%0A++return+(i+%25+2)+%3D%3D+1%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B9,+5,+4,+12%7D%3B%0A%0A++std::cout+%3C%3C+*std::partition_point(std::begin(foo),+std::end(foo),+is_odd)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Algorithmes -- Tri

- ```cpp std::is_sorted()``` indique si l'ensemble est ordonnée (ordre ascendant)
// Possibilité de fournir un foncteur de comparaison (< par défaut)

```cpp
vector<int> foo{4, 5, 9, 12};
vector<int> bar{9, 5, 4, 12};

is_sorted(begin(foo), end(foo)); // true
is_sorted(begin(bar), end(bar)); // false
```

- ```cpp std::is_sorted_until()``` détermine le premier élément mal placé

```cpp
vector<int> foo{4, 5, 9, 3, 12};

is_sorted_until(begin(foo), end(foo)); // 3
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B4,+5,+9,+3,+12%7D%3B%0A%0A++std::cout+%3C%3C+*std::is_sorted_until(std::begin(foo),+std::end(foo))+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B4,+5,+9,+12%7D%3B%0A++std::vector%3Cint%3E+bar%7B9,+5,+4,+12%7D%3B%0A%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_sorted(std::begin(foo),+std::end(foo))+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_sorted(std::begin(bar),+std::end(bar))+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Algorithmes -- Mélange

- ```cpp std::shuffle()``` mélange l'ensemble grâce à un générateur de nombre aléatoire uniforme

```cpp
vector<int> foo{4, 5, 9, 12};
unsigned seed = now().time_since_epoch().count();

shuffle(begin(foo), end(foo), default_random_engine(seed));
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%23include+%3Cchrono%3E%0A%23include+%3Crandom%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B4,+5,+9,+12%7D%3B%0A++unsigned+seed+%3D+std::chrono::system_clock::now().time_since_epoch().count()%3B%0A%0A++std::shuffle(std::begin(foo),+std::end(foo),+std::default_random_engine(seed))%3B%0A++for(size_t+i+%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Algorithmes -- Gestion de tas

- ```cpp std::is_heap()``` indique si l'ensemble forme un tas

```cpp
vector<int> foo{4, 5, 9, 3, 12};

is_heap(begin(foo), end(foo));  // false
make_heap(begin(foo), end(foo));
is_heap(begin(foo), end(foo));  // true
```

- ```cpp std::is_heap_until()``` indique le premier élément qui n'est pas dans la position correspondant à un tas

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B4,+5,+9,+3,+12%7D%3B%0A%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_heap(std::begin(foo),+std::end(foo))+%3C%3C+!'%5Cn!'%3B%0A++std::make_heap(std::begin(foo),+std::end(foo))%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_heap(std::begin(foo),+std::end(foo))+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Algorithmes -- Min-max

- ```cpp std::minmax()``` retourne la paire constituée du plus petit et du plus grand de deux éléments

```cpp
minmax(5, 2); // 2 - 5
```

- ```cpp std::minmax_element()``` retourne la paire constituée des itérateurs sur le plus petit et le plus grand élément d'un ensemble

```cpp
vector<int> foo{18, 5, 6, 8};

minmax_element(foo.begin(), foo.end()); // 5 - 18
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%23include+%3Cutility%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B18,+5,+6,+8%7D%3B%0A++auto+p+%3D+std::minmax_element(std::begin(foo),+std::end(foo))%3B%0A%0A++std::cout+%3C%3C+*(p.first)+%3C%3C+%22+%22+%3C%3C+*(p.second)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Algorithmes -- Numérique

- ```cpp std::iota()``` affecte des valeurs successives aux éléments d'un ensemble

```cpp
vector<int> foo(5);

iota(begin(foo), end(foo), 50); // 50 51 52 53 54
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cnumeric%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo(5)%3B%0A++%0A++std::iota(std::begin(foo),+std::end(foo),+50)%3B%0A++for(size_t+i+%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Algorithmes -- Conclusion

#adviceblock("Do", text[
  - Continuez à suivre les règles C++98/03 à propos des algorithmes
])

#adviceblock("Do", text[
  - Privilégiez la sémantique lorsque plusieurs algorithmes sont utilisables
])

== Range-based for loop

- Itération sur un conteneur complet

```cpp
vector<int> foo{4, 8, 12, 37};

for(int var : foo)
  cout << var << " ";    // Affiche 4 8 12 37
```

- Compatible avec ```cpp auto```

```cpp
vector<int> foo{4, 8, 12, 37};

for(auto var : foo)
  cout << var << " ";    // Affiche 4 8 12 37
```

- Utilisable sur tout conteneur
  - Exposant ```cpp begin()``` et ```cpp end()```
  - Utilisable avec ```cpp std::begin()``` et ```cpp std::end()```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B4,+8,+12,+37%7D%3B%0A%0A++for(auto+var+:+foo)%0A++%7B%0A++++std::cout+%3C%3C+var+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B4,+8,+12,+37%7D%3B%0A%0A++for(int+var+:+foo)%0A++%7B%0A++++std::cout+%3C%3C+var+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("N2930")
#addproposal("N3271")

== Range-based for loop

#alertblock("Modification des éléments", text[
  - La variable d'itération doit être une référence

  ```cpp
  vector<int> foo(4);

  for(auto& var : foo)
    var = 5;    // foo : 5 5 5 5
  ```
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo(4)%3B%0A%0A++for(auto%26+var+:+foo)%0A++%7B%0A++++var+%3D+5%3B%0A++%7D%0A%0A++for(auto+var+:+foo)%0A++%7B%0A++++std::cout+%3C%3C+var+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Range-based for loop

#adviceblock("Do", text[
  - Préférez _range-based for loop_ aux boucles classiques et à ```cpp std::for_each()```
])

// std::for_each() n'a plus d'intérêt en C++11 mais redevient utile en C++17 avec les politiques d'exécution parallélisées

#noteblock("Conseils", text[
  - Contrairement à ```cpp for```, l'indice de l'itération n'est pas disponible
  - Malgré tout, préférez la _range-based for loop_ avec un indice externe à ```cpp for```
])

#adviceblock("Do", text[
  - Utilisez l'inférence de type sur la variable d'itération
])

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

```cpp
stoi("56"); // 56
```

- S'arrêtent sur le premier caractère non convertible

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%0Aint+main()%0A%7B%0A++int+a+%3D+std::stoi(%2242%22)%3B%0A%0A++std::cout+%3C%3C+a+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== ``` std::string``` et conversions

- ```cpp std::to_string()``` convertit d'un nombre en une chaîne de caractères

```cpp
to_string(56); // "56"
```

- ```cpp std::to_wstring()``` convertit vers une chaîne de caractères larges

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%0Aint+main()%0A%7B%0A++std::string+b+%3D+std::to_string(56)%3B%0A%0A++std::cout+%3C%3C+b+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== ``` std::string``` et conversions

#alertblock("Attention", text[
  - Pas de fonction ```cpp std::stoui()``` de conversion vers un ```cpp unsigned int```
])

#adviceblock("Do", text[
  - Préférez ```cpp std::sto...()``` à ```cpp sscanf()```, ```cpp atoi()``` ou ```cpp strto...()```
])

#adviceblock("Do", text[
  - Préférez ```cpp std::to_string()``` à ```cpp snprintf()``` ou ```cpp itoa()```
])

#noteblock("Alternative et complément", text[
  - ```cpp Boost.Lexical_cast``` permet de telles conversions et quelques autres
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

```cpp
// Affiche Message\n en une seule \n ligne
cout << R"(Message\n en une seule \n ligne)";
cout << R"--(Message\n en une seule \n ligne)--";
```

- Composition possible des deux type de chaînes littérales

```cpp
u8R"(Message\n en une seule \n ligne)";
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+R%22(Message%5Cn+en+une+seule+%5Cn+ligne)%22+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+R%22--(Message%5Cn+en+une+seule+%5Cn+ligne)--%22+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+u8R%22(Message%5Cn+en+une+seule+%5Cn+ligne)%22+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("N2442")

== User-defined literals

- Possibilité de définir des littéraux "utilisateur"
- Nombre (entier ou réel), caractère ou chaîne suffixé par un identifiant
- Identifiants non standards préfixés par ```cpp _```
- Définit via ```cpp operator""suffixe```

#noteblock("Motivations", text[
  - Pas de conversion implicite
  - Expressivité
  // Exemple d'expressivité : des classes de "quantité" avec des user-defined literals pour les unités
])

#addproposal("N2765")

== User-defined literals

- Littéraux brutes : chaîne C entièrement analysée par l'opérateur

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

#alertblock("Restrictions", text[
  - Uniquement pour les littéraux numériques
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%0Aclass+Foo%0A%7B%0Apublic:%0A++explicit+Foo(int+a)%0A++++:+m_a%7Ba%7D%0A++%7B%7D%0A%0A++void+print()%0A++%7B%0A++++std::cout+%3C%3C+m_a+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0Aprivate:%0A++int+m_a%3B%0A%7D%3B%0A%0Astatic+Foo+operator%22%22_b(const+char*+str)%0A%7B%0A++unsigned+long+long+a+%3D+0%3B%0A++for(size_t+i+%3D+0%3B+str%5Bi%5D%3B+%2B%2Bi)%0A++%7B%0A++++a+%3D+(a+*+2)+%2B+(str%5Bi%5D+-+!'0!')%3B%0A++%7D%0A++return+Foo(a)%3B%0A%7D%0A%0Aint+main()%0A%7B%0A%23if+0%0A++Foo+foo+%3D+6%3B%0A%23else%0A++Foo+foo+%3D+0110_b%3B%0A%23endif%0A++foo.print()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("N2765")

== User-defined literals

- Littéraux préparés par le compilateur
  - Littéraux entiers : ```cpp unsigned long long int```
  - Littéraux réels : ```cpp long double```
  - Littéraux caractères : ```cpp char```, ```cpp wchar_t```, ```cpp char16_t``` ou ```cpp char32_t```
  - Chaînes littérales : couple pointeur sur caractères et ```cpp size_t```

```cpp
Foo operator""_f(unsigned long long int a) {
  return Foo(a); }

Foo operator""_f(const char* str, size_t) {
  return Foo(std::stoull(str)); }

Foo baz = 12_f;    // OK
Foo bar = "12"_f;  // OK
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%0Aclass+Foo%0A%7B%0Apublic:%0A++explicit+Foo(int+a)%0A++++:+m_a%7Ba%7D%0A++%7B%7D%0A%0A++void+print()%0A++%7B%0A++++std::cout+%3C%3C+m_a+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0Aprivate:%0A++int+m_a%3B%0A%7D%3B%0A%0Astatic+Foo+operator+%22%22+_f(unsigned+long+long+int+a)%0A%7B%0A++return+Foo(a)%3B%0A%7D%0A%0Astatic+Foo+operator%22%22_f(const+char*+str,+size_t+/*+length+*/)%0A%7B%0A++return+Foo(std::stoull(str))%3B%0A%7D%0A%0Aint+main()%0A%7B%0A%23if+0%0A++Foo+foo+%3D+12%3B%0A%23endif%0A%0A++Foo+bar+%3D+12_f%3B%0A++bar.print()%3B%0A%0A++Foo+baz+%3D+%2212%22_f%3B%0A++baz.print()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
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
  - ```cpp std::make_tuple()``` permet la déduction de types, pas le constructeur

  ```cpp
  auto foo{5, 'e', 98L};              // KO
  auto bar = make_tuple(5, 'e', 98L); // OK
  ```
])

#addproposal("n1836")

== ``` std::tuple```

- Fonction de déstructuration ```cpp std::tie()```
- Et une constante pour ignorer des éléments ```cpp std::ignore```

```cpp
int a; long b;
tie(a, ignore, b) = foo;
```

// C++17 introduit les structured binding qui améliore grandement la déstructuration en proposant une syntaxe plus simple et claire

- ```cpp std::get<>()``` accède aux éléments du ```cpp std::tuple``` par l'indice

```cpp
char c = get<1>(foo);
```

#alertblock("Attention", text[
  - Les indices commencent à 0
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%23include+%3Ctuple%3E%0A%0Aint+main()%0A%7B%0A++std::tuple%3Cint,+std::string,+double%3E+foo+%3D+std::make_tuple(42,+%22FOO%22,+25.2)%3B%0A%0A++std::string+c+%3D+std::get%3C1%3E(foo)%3B%0A++std::cout+%3C%3C+c+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%23include+%3Ctuple%3E%0A%0Aint+main()%0A%7B%0A++std::tuple%3Cint,+std::string,+double%3E+foo+%3D+std::make_tuple(42,+%22FOO%22,+25.2)%3B%0A%0A++int+a%3B%0A++double+b%3B%0A%0A++std::tie(a,+std::ignore,+b)+%3D+foo%3B%0A++std::cout+%3C%3C+a+%3C%3C+!'+!'+%3C%3C+b+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("n1836")

== ``` std::tuple```

- ```cpp std::tuple_cat()``` concatène deux ```cpp std::tuple```

```cpp
auto foo = make_tuple(5, 'e');
auto bar = make_tuple(98L, 'r');
auto baz = tuple_cat(foo, bar);               // 5 'e' 98L 'r'
```

- Classe représentant la taille ```cpp std::tuple_size```

```cpp
	tuple_size<decltype(baz)>::value;             // 4
```

- Classe représentant le type des éléments ```cpp std::tuple_element```

```cpp
tuple_element<0, decltype(baz)>::type first;  // int
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%23include+%3Ctuple%3E%0A%0Aint+main()%0A%7B%0A++std::tuple%3Cint,+std::string,+double%3E+foo+%3D+std::make_tuple(42,+%22FOO%22,+25.2)%3B%0A++auto+bar+%3D+std::make_tuple(12,+5UL)%3B%0A++auto+baz+%3D+std::tuple_cat(foo,+bar)%3B%0A%0A++std::cout+%3C%3C+std::tuple_size%3Cdecltype(baz)%3E::value+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("n1836")

== ``` std::tuple```

#alertblock("Don't", text[
  - N'utilisez pas ```cpp std::tuple``` pour remplacer une structure
  - ```cpp std::tuple``` regroupe localement des éléments sans lien sémantique
])

#adviceblock("Do", text[
  - Préférez un ```cpp std::tuple``` de retour aux paramètres "_OUT_"
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

```cpp
class Foo {
  public: Foo(int) {}
  public: Foo() = default;

  private: Foo(const Foo&) = delete;
  private: Foo& operator=(const Foo&) = delete;
};
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aclass+Foo%0A%7B%0Apublic:%0A++Foo(int)+%7B%7D%0A%23if+1%0A++Foo()+%3D+default%3B%0A%23endif%0A%0Aprivate:%0A++Foo(const+Foo%26)+%3D+delete%3B%0A++Foo%26+operator%3D(const+Foo%26)+%3D+delete%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++Foo+foo%3B%0A++Foo+bar(5)%3B%0A%23if+0%0A++Foo+baz(bar)%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra+-Wno-unused-variable',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== ``` =default``` et ``` =delete```

#adviceblock("Do", text[
  - Préférez ```cpp =default``` à une implémentation manuelle avec le même effet
])

#adviceblock("Do", text[
  - Préférez ```cpp =delete``` à une déclaration privée sans définition
])

#noteblock(text[``` =default``` ou non définition ?], text[
  - Consensus plutôt du côté de la non-définition
  - Intérêt documentaire réel à ```cpp =default```
])

== Initialisation par défaut des membres

- Initialisation des membres lors de la déclaration

```cpp
struct Foo {
  Foo() {}
  int m_a{2};
};
```

#alertblock("Restriction", text[
  - Pas d'initialisation avec ```cpp ()```
  - Initialisation avec ```cpp =``` uniquement sur des types copiables
])

#adviceblock("Do", text[
  - Préférez l'initialisation des membres à l'initialisation par constructeurs pour les initialisations avec une valeur connue à la compilation
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astruct+Foo%0A%7B%0A++Foo()%0A++%7B%7D%0A%0A++int+m_a%7B2%7D%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++Foo+foo%3B%0A%0A++std::cout+%3C%3C+foo.m_a+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("N2756")

== Délégation de constructeur

- Utilisation d'un constructeur dans l'implémentation d'un second
- ... en 'l'initialisant' dans la liste d'initialisation

```cpp
struct Foo {
  Foo(int a) : m_a(a) {}
  Foo() : Foo(2) {}
  int m_a;
};
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aclass+Foo%0A%7B%0Apublic:%0A++Foo(int+a)%0A++++:+m_a(a)%0A++%7B%0A++%7D%0A%0A++Foo()%0A++++:+Foo(2)%0A++%7B%0A++%7D%0A%0A++void+print()%0A++%7B%0A++++std::cout+%3C%3C+m_a+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0Aprivate:%0A++int+m_a%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++Foo+foo(4)%3B%0A++Foo+bar%3B%0A%0A++foo.print()%3B%0A++bar.print()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("N1986")

== Délégation de constructeur

#adviceblock("Do", text[
  - Utilisez la délégation de constructeur pour mutualiser le code commun
])

#alertblock("Don't", text[
  - Évitez la délégation pour l'initialisation constante de membres
  - Préférez l'initialisation par défaut des membres
])

== Héritage de constructeur

- Indique que la classe hérite des constructeurs de la classe mère
- Génération du constructeur correspondant par le compilateur
  - Paramètres du constructeur de base
  - Appelle le constructeur de base correspondant
  - Initialise les membres sans fournir de paramètres

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

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astruct+Foo%0A%7B%0A++Foo()%0A++%7B%7D%0A%0A++Foo(int+a)%0A++++:+m_a(a)%0A++%7B%7D%0A%0A++int+m_a%7B2%7D%3B%0A%7D%3B%0A%0Astruct+Bar+:+Foo%0A%7B%0A++using+Foo::Foo%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++%7B%0A++++Foo+foo%3B%0A++++Foo+bar(4)%3B%0A%0A++++std::cout+%3C%3C+foo.m_a+%3C%3C+!'+!'+%3C%3C+bar.m_a+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0A++%7B%0A++++Bar+foo%3B%0A++++Bar+bar(4)%3B%0A%0A++++std::cout+%3C%3C+foo.m_a+%3C%3C+!'+!'+%3C%3C+bar.m_a+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("N2540")

== Héritage de constructeur

- Redéfinition possible dans la classe dérivée

```cpp
struct Bar : Foo {
  using Foo::Foo;
  Bar() : Foo(5) {}
};
```

#alertblock("Valeurs par défaut", text[
  - Génération de toutes les combinaisons de constructeurs sans valeur par défaut correspondantes au constructeur de base avec des valeurs par défaut
  // Ainsi Foo(int, int = 2) va injecter Bar(int) et Bar(int, int)
])

#alertblock("Héritage multiple", text[
  - Héritage impossible de deux constructeurs avec la même signature
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astruct+Foo%0A%7B%0A++Foo()%0A++%7B%7D%0A%0A++Foo(int+a)%0A++++:+m_a(a)%0A++%7B%7D%0A%0A++int+m_a%7B2%7D%3B%0A%7D%3B%0A%0Astruct+Bar+:+Foo%0A%7B%0A++using+Foo::Foo%3B%0A++Bar()%0A++++:+Foo(5)+%0A++%7B%7D%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++Bar+foo%3B%0A++Bar+bar(4)%3B%0A%0A++std::cout+%3C%3C+foo.m_a+%3C%3C+!'+!'+%3C%3C+bar.m_a+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("N2540")

== ``` override```

- Indique la redéfinition d'une fonction d'une classe de base

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

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%0Astruct+Foo%0A%7B%0A++Foo()%0A++%7B%7D%0A%0A++virtual+void+f(int)%0A++%7B%7D%0A%7D%3B%0A%0Astruct+Bar+:+Foo%0A%7B%0A++Bar()%0A++%7B%7D%0A%0A++void+f(int)+override%0A++%7B%7D%0A%7D%3B%0A%0Aint+main()%0A%7B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("N2928")
#addproposal("N3206")
#addproposal("N3272")

== ``` override```

- Provoque une erreur de compilation si
  - La fonction n'existe pas dans la classe de base
  - La fonction de la classe de base n'est pas virtuelle

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

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astruct+Foo%0A%7B%0A++Foo()+%0A++%7B%7D%0A%0A++virtual+void+f(int)%0A++%7B%7D%0A%0A++virtual+void+g(int)+const%0A++%7B%7D%0A%0A++void+h(int)%0A++%7B%7D%0A%7D%3B%0A%0Astruct+Bar+:+Foo%0A%7B%0A++Bar()%0A++%7B%7D%0A%0A++void+f(float)+override%0A++%7B%7D%0A%0A++void+g(int)+override%0A++%7B%7D%0A%0A++void+h(int)+override%0A++%7B%7D%0A%0A++void+i(int)+override%0A++%7B%7D%0A%7D%3B%0A%0Aint+main()%0A%7B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== ``` override```

#noteblock("Objectifs", text[
  - Documentaire
  - Détection des non-reports de modifications lors d'un refactoring
  - Détection des redéfinitions involontaires
])

#adviceblock("Do", text[
  - Marquez ```cpp override``` les fonctions que vous redéfinissez
])

#adviceblock("Do", text[
  - Utilisez ```cpp virtual``` à la base de l'arbre d'héritage
  - Utilisez ```cpp override``` sur les redéfinitions
  // Si une fonction est virtuelle, toutes ces redéfinitions le sont qu'elles soient ou non marquées comme tel}
])

== ``` final```

- Indique qu'une classe ne peut pas être dérivée

```cpp
struct Foo final {
  virtual void f(int);
};

struct Bar : Foo {   // Erreur
  void f(int);
};
```

- Aussi bien via l'héritage public que privé

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astruct+Foo+final%0A%7B%0A++Foo()%0A++%7B%7D%0A%7D%3B%0A%0Astruct+Bar+:+Foo%0A%7B%0A++Bar()%0A++%7B%7D%0A%7D%3B%0A%0Aint+main()%0A%7B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("N3206")
#addproposal("N3272")

== ``` final```

- Ou qu'une fonction ne peut plus être redéfinie

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

#adviceblock("Do", text[
  - Utilisez ```cpp final``` avec parcimonie
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astruct+Foo%0A%7B%0A++Foo()%0A++%7B%7D%0A%0A++virtual+void+f(int)%0A++%7B%7D%0A%7D%3B%0A%0Astruct+Bar+:+Foo%0A%7B%0A++Bar()%0A++%7B%7D%0A%0A++virtual+void+f(int)+final%0A++%7B%7D%0A%7D%3B%0A%0Astruct+Baz+:+Bar%0A%7B%0A++Baz()%0A++%7B%7D%0A%0A++virtual+void+f(int)%0A++%7B%7D%0A%7D%3B%0A%0Aint+main()%0A%7B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Opérateurs de conversion explicite

- Extension de ```cpp explicit``` aux opérateurs de conversion
- ... qui ne définissent alors plus de conversion implicite

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

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astruct+Foo%0A%7B%0A++operator+int()%0A++%7B%0A++++return+5%3B%0A++%7D%0A%7D%3B%0A%0Astruct+Bar%0A%7B%0A++explicit+operator+int()%0A++%7B%0A++++return+5%3B%0A++%7D%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++%7B%0A++++Foo+f%3B%0A++++int+a+%3D+f%3B%0A++++int+b+%3D+static_cast%3Cint%3E(f)%3B%0A++++std::cout+%3C%3C+a+%3C%3C+!'+!'+%3C%3C+b+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0A++%7B%0A++++Bar+f%3B%0A%23if+1%0A++++int+a+%3D+f%3B%0A%23endif%0A++++int+b+%3D+static_cast%3Cint%3E(f)%3B%0A++++std::cout+%3C%3C+b+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("N2437")

== ``` noexcept```

- Indique qu'une fonction ne jette pas d'exception
// Rôle documentaire et permet au compilateur d'effectuer certaines optimisations (p. ex. sur le choix entre déplacement et copie)
// Appelle std::terminate() lorsque la fonction ne respecte pas son contrat et lance une exception
// std::terminate() appelle le \textit{handler} correspondant qui par défaut est std::abort() qui arrête violemment le programme}

```cpp
void foo() noexcept {}
```

- Pilotable par une expression booléenne

```cpp
void foo() noexcept(true) {}
```

#noteblock("Dépréciation", text[
  - Les spécifications d'exception sont dépréciées
  - Voir #link("http://www.gotw.ca/publications/mill22.htm")[A Pragmatic Look at Exception Specifications #linklogo()] (Herb Sutter)
  // En pratique, seule throw() était utilisée et utilisable et a été remplacée par noexcept
])

#addproposal("N3050")

== ``` noexcept```

- Opérateur ```cpp noexcept()``` teste, au \textit{compile-time}, si une expression peut ou non lever une exception
- Pour l'appel de fonction, teste si la fonction est ```cpp noexcept```

```cpp
noexcept(foo()); // true
```

#adviceblock("Do", text[
  - Marquez ```cpp noexcept``` les fonctions qui sémantiquement ne jette pas d'exception
])

== Conversion exception - pointeur

- Quasi-pointeur ```cpp std::exception_ptr``` à responsabilité partagée sur une exception
- ```cpp std::current_exception()``` récupère un pointeur sur l'exception courante
- ```cpp std::rethrow_exception()``` relance l'exception contenue dans ```cpp std::exception_ptr```
- ```cpp std::make_exception_ptr()``` construit ```cpp std::exception_ptr``` depuis une exception

#addproposal("n2179")

== Conversion exception - pointeur

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

#noteblock("Motivation", text[
  - Faire passer la barrière des threads aux exceptions
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cexception%3E%0A%0Avoid+foo()%0A%7B%0A++throw+42%3B%0A%7D%0A%0Avoid+bar(std::exception_ptr+e)%0A%7B%0A++std::rethrow_exception(e)%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++try%0A++%7B%0A++++foo()%3B%0A++%7D%0A++catch(...)%0A++%7B%0A++++std::exception_ptr+e+%3D+std::current_exception()%3B%0A++++bar(e)%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:54.83028720626631,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:45.16971279373369,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("n2179")

== Nested exception

- ```cpp std::nested_exception``` contient une exception imbriquée
- ```cpp nested_ptr()``` récupère un pointeur sur l'exception imbriquée
- ```cpp rethrow_nested()``` relance l'exception imbriquée
- ```cpp std::rethrow_if_nested()``` relance l'exception imbriquée si elle existe
- ```cpp std::throw_with_nested()``` lance une exception embarquant l'exception courante

```cpp
void foo() {
  try { throw 42; }
  catch(...) { throw_with_nested(logic_error("bar")); }
}

try { foo(); }
catch(logic_error &e) { std::rethrow_if_nested(e); }
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cexception%3E%0A%0Avoid+foo()+%0A%7B%0A++try+%0A++%7B+%0A++++throw+42%3B%0A++%7D%0A++catch(...)%0A++%7B+%0A++++std::throw_with_nested(std::logic_error(%22bar%22))%3B%0A++%7D%0A%7D%0A%0Aint+main()%0A%7B%0A++try%0A++%7B%0A++++foo()%3B%0A++%7D%0A++catch(std::logic_error+%26e)%0A++%7B%0A%23if+0%0A++++std::rethrow_if_nested(e)%3B%0A%23else%0A++++throw%3B%0A%23endif%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== ``` enum class```

- Énumérations mieux typées
- Sans conversions implicites
- Énumérés locaux à l'énumération

```cpp
enum class Foo { BAR1, BAR2 };

Foo foo = Foo::BAR1;
```

- Possibilité de fournir le type sous-jacent
// Sur les énumérations classiques aussi

```cpp
enum class Foo : unsigned char { BAR1, BAR2 };
```

- ```cpp std::underlying_type``` permet de récupérer ce type sous-jacent

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ctype_traits%3E%0A%0Aenum+class+Foo+:+unsigned+int%0A%7B+%0A++BAR1,%0A++BAR2,%0A%7D%3B%0A%0Aint+main()%0A%7B%0A%23if+0%0A++Foo+foo+%3D+BAR2%3B%0A%23else%0A++Foo+foo+%3D+Foo::BAR2%3B%0A%23endif%0A%0A%23if+0%0A++std::cout+%3C%3C+foo+%3C%3C+%22%5Cn%22%3B%0A%23else%0A++std::cout+%3C%3C+static_cast%3Cstd::underlying_type%3CFoo%3E::type%3E(foo)+%3C%3C+%22%5Cn%22%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("N2347")

== ``` enum class```

#adviceblock("Do", text[
  - Préférez les énumérations fortement typées
])

#noteblock("Bémol", text[
  - Pas de méthode simple et robuste pour récupérer la valeur ou l'intitulé de l'énuméré
])

== ``` std::function```

// Fonction de première classe (first-class citizens) : utilisables comme paramètre ou retour de fonction
// Fonction d'ordre supérieur : prend en paramètre ou retourne une autre fonction

- Encapsule un appelable de n'importe quel type

```cpp
int foo(int, int);

function<int(int, int)> bar = foo;
```

- Copiable
- Peut être passer en paramètre ou retourner par une fonction

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cfunctional%3E%0A%0Aint+foo(int+a,+int+b)%0A%7B%0A++return+a+%2B+b%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::function%3Cint(int,+int)%3E+bar+%3D+foo%3B%0A%0A++std::cout+%3C%3C+bar(1,2)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("n1836")

== ``` std::mem_fn```

- Convertit une fonction membre en _function object_ prenant une instance en paramètre

```cpp
struct Foo { int f(int a) { return 2 * a; } };

Foo foo;
function<int(Foo, int)> bar = mem_fn(&Foo::f);
bar(foo, 5);   // 10
```

#noteblock("Note", text[
  - Type de retour non spécifié mais stockable dans ```cpp std::function```
])

#noteblock("Dépréciation", text[
  - Dépréciation de ```cpp std::mem_fun```, ```cpp std::ptr_fun``` et consorts
  // Série de fonctions templates convertissant des fonctions membres, des pointeurs de fonction, etc. en foncteur utilisable dans les algorithmes
  // Leur grosse limitation venait du nombre de paramètres limités (0 ou 1)
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cfunctional%3E%0A%0Astruct+Foo%0A%7B%0A++int+f(int+a)%0A++%7B%0A++++return+2+*+a%3B%0A++%7D%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++Foo+foo%3B%0A++std::function%3Cint(Foo,+int)%3E+bar+%3D+std::mem_fn(%26Foo::f)%3B%0A%0A++std::cout+%3C%3C+bar(foo,+5)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("n1836")

== ``` std::bind```

- Construction de _function object_ en liant des paramètres à un appelable
- _Placeholders_ ```cpp std::placholders::_1```, ```cpp std::placholders::_2```, ... pour lier les paramètres du _function object_ à l'appelable

```cpp
int foo(int a, int b) { return (a - 1) * b; }

function<int(int)> bar = bind(&foo, _1, 2);
bar(3);               // 4

auto baz = bind(&foo, _2, _1);
baz(3, 2, 1, 2, 3);   // 3
```

// Avec auto, il est possible de passer autant de paramètres surnuméraires que souhaiter

#noteblock("Dépréciation", text[
  - Dépréciation de ```cpp std::bind1st``` et ```cpp std::bind2nd```
  // Version C++98 mais limités car ne pouvait que convertir une fonction binaire en fonction unaire en liant le premier ou le second paramètre
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cfunctional%3E%0A%0Astatic+int+foo(int+a,+int+b)%0A%7B%0A++return+(a+-+1)+*+b%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::function%3Cint(int)%3E+bar+%3D+std::bind(%26foo,+std::placeholders::_1,+2)%3B%0A++std::cout+%3C%3C+bar(3)+%3C%3C+!'%5Cn!'%3B%0A%0A++auto+baz+%3D+std::bind(%26foo,+std::placeholders::_2,+std::placeholders::_1)%3B%0A++std::cout+%3C%3C+baz(3,+2,+1,+2,+3)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("n1836")

== lambda et fermeture

#noteblock("Vocabulaire", text[
  - Lambda : fonction anonyme
  - Fermeture : capture des variables libres de l'environnement lexical
])

- ```cpp [capture](paramètres) spécificateurs -> type_retour {instructions}```

```cpp
int bar = 4;
auto foo = [&bar] (int a) -> int { bar *= a; return a; };

int baz = foo(5);  // bar : 20, baz : 5
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++int+bar+%3D+4%3B%0A++auto+foo+%3D+%5B%26bar%5D+(int+a)+-%3E+int+%7B+bar+*%3D+a%3B+return+a%3B%7D%3B%0A%0A++std::cout+%3C%3C+foo(5)+%3C%3C+!'+!'+%3C%3C+bar+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
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

== lambda et fermeture

- La capture de variables membres se fait par la capture de  ```cpp this```
  - Soit explicitement via ```cpp [this]```

#alertblock(text[Capture de ``` this```], text[
  - Capture du pointeur, non de l'objet
])


#list(marker: [ ], text[
  - Soit via ```cpp [=]``` ou ```cpp [&]```
])

== lambda et fermeture

- Préservation de la constante des variables capturées
// Même avec mutable
- Pas de capture des variables globales et statiques

#alertblock("Attention", text[
  - Par défaut, les variables capturées par copie ne sont pas modifiables

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
  - Omission impossible si la lambda est ```cpp mutable```
])

== lambda, ``` std::function```, ... - Conclusion

#adviceblock("Do", text[
  - Préférez les lambdas aux ```cpp std::function```
  - Préférez les lambdas à ```cpp std::bind()```
])

// Les lambdas sont généralement plus efficaces

#noteblock("Motivations", text[
  - Lisibilité, expressivité et performances
  - Voir #link("https://github.com/boostcon/cppnow_presentations_2016/blob/master/00_tuesday/practical_performance_practices.pdf")[Practical Performance Practices #linklogo()]

  // Entre autres, il y a aussi des remarques intéressantes sur le choix des conteneurs, des pointeurs intelligents, sur std::endl, etc.
])

#alertblock("Attention", text[
  - Prenez garde à la durée de vie des variables capturées par référence
])

== ``` std::reference_wrapper```

- Encapsule un objet en émulant une référence
- Construction par ```cpp std::ref()``` et ```cpp std::cref()```
- Copiable

```cpp
int a{10};
reference_wrapper<int> aref = ref(a);

aref++; // a : 11
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cfunctional%3E%0A%0Aint+main()%0A%7B%0A++int+a%7B10%7D%3B%0A%0A++std::reference_wrapper%3Cint%3E+aref+%3D+std::ref(a)%3B%0A++aref%2B%2B%3B%0A++std::cout+%3C%3C+a+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("n1836")

== Double chevron

- C++98/03 : ```cpp >>``` est toujours l'opérateur de décalage
- C++11 : peut être une double fermeture de template

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

```cpp
template <typename T, typename U, int V>
class Foo;

typedef Foo<int, int, 5> Baz;  // OK

template <typename U>
typedef Foo<int, U, 5> Bar;    // Incorrect
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Atemplate+%3Ctypename+T,+typename+U,+int+V%3E%0Aclass+Foo%0A%7B%0A%7D%3B%0A%0Atypedef+Foo%3Cint,+int,+5%3E+Baz%3B%0A%0A%23if+0%0Atemplate+%3Ctypename+U%3E%0Atypedef+Foo%3Cint,+U,+5%3E+Bar%3B%0A%23endif%0A%0Aint+main()%0A%7B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("N2258")

== Alias de template

- ```cpp using``` permet la création d'alias ne définissant que certains paramètres

```cpp
template <typename U>
using Bar = Foo<int, U, 5>;
```

#noteblock(text[``` using``` de types], text[
  - ```cpp using``` n'est pas réservé aux templates

  ```cpp
  using Error = int;
  ```
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Atemplate+%3Ctypename+T,+typename+U,+int+V%3E%0Aclass+Foo%0A%7B%0A%7D%3B%0A%0Ausing+Baz+%3D+Foo%3Cint,+int,+5%3E%3B%0A%0Atemplate+%3Ctypename+U%3E%0Ausing+Bar+%3D+Foo%3Cint,+U,+5%3E%3B%0A%0Aint+main()%0A%7B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("N2258")

== Extern template

- Indique que le template est instancié dans une autre unité de compilation
- Inutile de l'instancier ici

```cpp
extern template class std::vector<int>;
```

#noteblock("Objectif", text[
  - Réduction du temps de compilation
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

```cpp
template<typename... Args>
class Foo {
public:
  static const unsigned int size = sizeof...(Args);
};
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%0Atemplate%3Ctypename...+Args%3E%0Aclass+Foo%0A%7B%0Apublic:%0A++static+const+unsigned+int+size+%3D+sizeof...(Args)%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+Foo%3Cint,+int,+long%3E::size+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Variadic template

- Utilisation récursive par spécialisation

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

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%0A//+Condition+d!'arret%0Atemplate%3Ctypename+T%3E%0AT+sum(T+val)%0A%7B%0A++return+val%3B%0A%7D%0A%0Atemplate%3Ctypename+T,+typename...+Args%3E%0AT+sum(T+val,+Args...+values)%0A%7B%0A++return+val+%2B+sum(values...)%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+sum(1,+5,+56,+9)+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+sum(std::string(%22Un%22),+std::string(%22Deux%22))+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Variadic template

- Ou expansion sur une expression et une fonction d'expansion

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

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%0Atemplate%3Ctypename...+T%3E+%0Avoid+pass(T%26%26...)%0A%7B%0A%7D%0A%0Aint+total+%3D+0%3B%0Aint+foo(int+i)%0A%7B%0A++total+%2B%3D+i%3B%0A++return+i%3B%0A%7D%0A%0Atemplate%3Ctypename...+T%3E%0Aint+sum(T...+t)%0A%7B%0A++pass((foo(t))...)%3B+%0A++return+total%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+sum(1,+2,+3,+5)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Variadic template

#alertblock("Contraintes de l'expansion", text[
  - Paramètre unique
  - Ne retournant pas ```cpp void```
  - Pas d'ordre garanti
])

- Candidat naturel ```cpp std::initializer_list```
- ... constructible depuis un \textit{variadic template}

```cpp
template<typename... T>
int foo(T... t) {
  initializer_list<int>{ t... };
}

foo(1, 2, 3, 5);
```

== Variadic template

- ... qui règle le problème de l'ordre

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

// ,0 permet de régler le souci du retour void

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aint+total+%3D+0%3B%0Aint+foo(int+i)%0A%7B%0A++total+%2B%3D+i%3B%0A++return+i%3B%0A%7D%0A%0Atemplate%3Ctypename...+T%3E%0Aint+sum(T...+t)%0A%7B%0A++std::initializer_list%3Cint%3E%7B+(foo(t),+0)...+%7D%3B%0A++return+total%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+sum(1,+2,+3,+5)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Variadic template

- .. sur n'importe quelle expression prenant un paramètre

//Donc appelle de fonction ou lambda mais aussi simple expression

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

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%0Atemplate%3Ctypename+...+T%3E%0Atypename+std::common_type%3CT...%3E::type+sum(T+...+t)%0A%7B%0A++typename+std::common_type%3CT...%3E::type+result%7B%7D%3B%0A++std::initializer_list%3Cint%3E%7B+(result+%2B%3D+t,+0)...+%7D%3B%0A++return+result%3B%0A%7D%0A%0Atemplate%3Ctypename+...+T%3E%0Avoid+print(T+...+t)%0A%7B%0A++std::initializer_list%3Cint%3E%7B+(std::cout+%3C%3C+t+%3C%3C+%22+%22,+0)...+%7D%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+sum(1,+2,+3,+5)+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+sum(std::string(%22Un%22),+std::string(%22Deux%22))+%3C%3C+!'%5Cn!'%3B%0A%0A++print(1,+2,+3,+5)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== ``` std::enable_if```

- Classe template sur une expression booléenne et un type
- Définition du type seulement si l'expression booléenne est vraie
- Templates disponibles uniquement pour certains types

```cpp
template<class T,
typename enable_if<is_integral<T>::value, T>::type* = nullptr>
void foo(T data) { }

foo(42);
foo("azert");    // Erreur
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ctype_traits%3E%0A%0Atemplate%3Cclass+T,+typename+std::enable_if%3Cstd::is_integral%3CT%3E::value,+T%3E::type*+%3D+nullptr%3E%0Avoid+foo(T+data)%0A%7B%0A++std::cout+%3C%3C+data+%3C%3C+%22%5Cn%22%3B%0A%7D%0A%0Atemplate%3Cclass+T,+typename+std::enable_if%3C!!std::is_integral%3CT%3E::value,+T%3E::type*+%3D+nullptr%3E%0Avoid+bar(T)%0A%7B%0A++std::cout+%3C%3C+%22Generique%5Cn%22%3B%0A%7D%0A%0Atemplate%3Cclass+T,typename+std::enable_if%3Cstd::is_integral%3CT%3E::value,+T%3E::type*+%3D+nullptr%3E%0Avoid+bar(T)%0A%7B%0A++std::cout+%3C%3C+%22Entier%5Cn%22%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++foo(42)%3B%0A%23if+0%0A++foo(%22azert%22)%3B%0A%23endif%0A%0A++bar(42)%3B%0A++bar(%22azert%22)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Types locaux en arguments templates

- Utilisation des types locaux non-nommés comme arguments templates

```cpp
vector<int> foo)
struct Less {
  bool operator()(int a, int b) { return a < b; }
};

sort(foo.begin(), foo.end(), Less());
```

- Y compris des lambdas

```cpp
sort(foo.begin(), foo.end(),
     [] (int a, int b) { return a < b; });
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B5,+2,+8,+12,+3%7D%3B%0A++std::sort(foo.begin(),+foo.end(),+%5B%5D+(int+a,+int+b)+%7B+return+a+%3C+b%3B+%7D)%3B%0A%0A++for(size_t+i+%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+%22+%22%3B%0A++%7D%0A++std::cout+%3C%3C+%22%5Cn%22%3B%0A%7D%0A%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Astruct+Less%0A%7B%0A++bool+operator()(int+a,+int+b)%0A++%7B%0A++++return+a+%3C+b%3B%0A++%7D%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B5,+2,+8,+12,+3%7D%3B%0A++std::sort(foo.begin(),+foo.end(),+Less())%3B%0A%0A++for(size_t+i+%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+%22+%22%3B%0A++%7D%0A++std::cout+%3C%3C+%22%5Cn%22%3B%0A%7D%0A%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("N2657")

== Type traits -- Helper

- Constante _compile-time_ ```cpp std::integral_constant```
- ```cpp std::integral_constant``` booléen vrai ```cpp true_type```
- ```cpp std::integral_constant``` booléen faux ```cpp false_type```

```cpp
template <unsigned n>
struct factorial
  : integral_constant<int, n*factorial<n-1>::value> {};

template <>
struct factorial<0>
  : integral_constant<int, 1> {};
	factorial<5>::value;  // 120 en compile-time
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ctype_traits%3E%0A%0Atemplate+%3Cunsigned+n%3E%0Astruct+factorial+:+std::integral_constant%3Cint,+n*factorial%3Cn-1%3E::value%3E+%0A%7B%7D%3B%0A%0Atemplate+%3C%3E%0Astruct+factorial%3C0%3E+:+std::integral_constant%3Cint,+1%3E%0A%7B%7D%3B%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+factorial%3C5%3E::value+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("n1836")

== Type traits -- Trait

- Détermine, à la compilation, les caractéristiques des types
- ```cpp std::is_array``` : tableau C

```cpp
is_array<int>::value;        // false
is_array<int[3]>::value;     // true
```

- ```cpp std::is_integral``` : type entier

```cpp
is_integral<short>::value;   // true
is_integral<string>::value;  // false
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%23include+%3Ctype_traits%3E%0A%0Aint+main()%0A%7B%0A%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_array%3Cint%3E::value+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_array%3Cint%5B3%5D%3E::value+%3C%3C+!'%5Cn!'%3B%0A%0A++std::cout+%3C%3C+std::is_integral%3Cshort%3E::value+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::is_integral%3Cstd::string%3E::value+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("n1836")

== Type traits -- Trait}

- ```cpp std::is_fundamental``` : type fondamental (entier, réel, ```cpp void``` ou ```cpp nullptr_t```)

```cpp
is_fundamental<short>::value;   // true
is_fundamental<string>::value;  // false
is_fundamental<void*>::value;   // false
```

- ```cpp std::is_const``` : type constant

```cpp
is_const<const short>::value;  // true
is_const<string>::value;       // false
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%23include+%3Ctype_traits%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_fundamental%3Cshort%3E::value+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_fundamental%3Cstd::string%3E::value+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_fundamental%3Cvoid*%3E::value+%3C%3C+!'%5Cn!'%3B%0A%0A++std::cout+%3C%3C+std::is_const%3Cconst+short%3E::value+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::is_const%3Cstd::string%3E::value+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Type traits -- Trait

- ```cpp std::is_base_of``` : base d'un autre type

```cpp
struct Foo {};
struct Bar : Foo {};

is_base_of<int, int>::value;        // false
is_base_of<string, string>::value;  // true
is_base_of<Foo, Bar>::value;        // true
is_base_of<Bar, Foo>::value;        // false
```

- Et bien d'autres ...

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%23include+%3Ctype_traits%3E%0A%0Astruct+Foo%0A%7B%7D%3B%0A%0Astruct+Bar+:+Foo%0A%7B%7D%3B%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_base_of%3Cint,+int%3E::value+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_base_of%3Cstd::string,+std::string%3E::value+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_base_of%3CFoo,+Bar%3E::value+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_base_of%3CBar,+Foo%3E::value+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Type traits -- Transformations

- Construction d'un type par transformation d'un type existant
- ```cpp std::add_const``` : type ```cpp const```

```cpp
typedef add_const<int>::type A;         // const int
typedef add_const<const int>::type B;   // const int
typedef add_const<const int*>::type C;  // const int* const
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ctype_traits%3E%0A%0Atypedef+std::add_const%3Cint%3E::type+A%3B%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_const%3CA%3E::value+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("n1836")

== Type traits -- Transformations

- ```cpp std::make_unsigned``` : type non signé correspondant

```cpp
enum Foo {bar};

typedef make_unsigned<int>::type A;             // unsigned int
typedef make_unsigned<unsigned>::type B;        // unsigned int
typedef make_unsigned<const unsigned>::type C;  // const unsigned int
typedef make_unsigned<Foo>::type D;             // unsigned int
```

- Et bien d'autres ...

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ctype_traits%3E%0A%0Aenum+Foo%0A%7B%0A++bar%0A%7D%3B%0A%0Atypedef+std::make_unsigned%3Cint%3E::type+A%3B%0Atypedef+std::make_unsigned%3CFoo%3E::type+B%3B%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_unsigned%3Cint%3E::value+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_unsigned%3CFoo%3E::value+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_unsigned%3CA%3E::value+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::is_unsigned%3CB%3E::value+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

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
  - Ne pas utilisez le pointeur retourné par ```cpp get()``` pour libérer la ressource
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
  - Dépréciation de ```cpp std::auto_ptr```
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
  - Pas de ```cpp new``` explicite, plus robuste

  ```cpp
  // Fuite possible en cas d'exception depuis bar()
  foo(shared_ptr<int>(new int(42)), bar());
  ```

  - Allocation unique pour la ressource et le compteur de référence
])

#adviceblock("Do", text[
  - Utilisez ```cpp std::make_shared()``` pour construire vos ```cpp std::shared_ptr```
])

== Pointeurs intelligents -- ``` std::weak_ptr```

- Aucune responsabilité sur la ressource
- Collabore avec ```cpp std::shared_ptr```
- ... sans impact sur le comptage de références
- Pas de création depuis un pointeur nu

#noteblock("Objectif", text[
  \item Rompre les cycles
])

```cpp
shared_ptr<int> sp(new int(20));
weak_ptr<int> wp(sp);
```

#addproposal("n1836")

== Pointeurs intelligents -- ``` std::weak_ptr```

- Pas d'accès à la ressource
- Convertible en ```cpp std::shared_ptr``` via ```cpp lock()```
// Retourne un ```cpp std::shared_ptr``` vide si la ressource n'existe plus

```cpp
shared_ptr<int> sp = wp.lock();
```

- ```cpp reset()``` vide le pointeur
- ```cpp use_count()``` retourne le nombre de possesseurs de la ressource
// Possesseurs aux nombres desquels notre ```cpp std::weak_ptr``` n'appartient pas
- ```cpp expired()``` indique si le ```cpp std::weak_ptr``` ne référence plus une ressource valide
// Soit il pointe sur rien, soit la ressource a été libérée car n'avait plus de ```cpp std::shared_ptr``` sur elle

== Pointeurs intelligents -- Conclusion

#alertblock("Don't", text[
  - N'utilisez pas de pointeurs bruts possédants
])

#adviceblock("Do", text[
  - Réfléchissez à la responsabilité de vos ressources
])

#adviceblock("Do", text[
  - Préférez ```cpp std::unique_ptr``` à ```cpp std::shared_ptr```
  - Préférez une responsabilité unique à une responsabilité partagée
])

== Pointeurs intelligents -- Conclusion

#adviceblock("Do", text[
  - Brisez les cycles à l'aide de ```cpp std::weak_ptr```
])

#alertblock("Attention", text[
  - Passez par un ```cpp std::unique_ptr``` temporaire intermédiaire pour insérer des éléments dans un conteneur de ```cpp std::unique_ptr```
  - Voir #link("https://accu.org/index.php/journals/2271")[Overload 134 - C++ Antipatterns linklogo()]
  // push_back d'un pointeur brute n'est pas possible et emplace_back peut échouer en laissant fuir le pointeur
])

#adviceblock("Do", text[
  - Transférez au plus tôt la responsabilité à un pointeur intelligent
])

== Pointeurs intelligents -- Conclusion

#noteblock("Pour aller plus loin", text[
  - Voir #link("http://loic-joly.developpez.com/tutoriels/cpp/smart-pointers/")[Pointeurs intelligents #linklogo() (Loïc Joly)]
])

#noteblock("Sous silence", text[
  - Allocateurs, mémoire non-initialisée, alignement, ...
])

#noteblock("Mais aussi", text[
  - Support minimal des _Garbage Collector_
  // Support enlevé en C++23 : trop restrictif, inutilisé, conceptions très différentes et variés dans les langages à GC
  - Mais pas de GC standard
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
  - les attributs ```cpp gsl``` des "C++ Core Guidelines Checker" de Microsoft

  ```cpp
  [[ gsl::suppress(26400) ]]
  ```
])

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
  - Aussi une information à destination des développeurs
])


== Attribut ``` [[ noreturn ]]```

- Indique qu'une fonction ne retourne pas

```cpp
[[ noreturn ]] void foo() { throw "error"; }
```

#alertblock("Attention", text[
  - Qui ne retourne pas
  - Pas qui ne retourne rien
])

#noteblock("Usage", text[
  - Boucle infinie, sortie de l'application, exception systématique
])

#noteblock("Sous silence", text[
  - ```cpp [[ carries_dependency ]]```
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cexception%3E%0A%0A%5B%5B+noreturn+%5D%5D+void+foo()%0A%7B%0A%23if+0%0A++throw+std::runtime_error(%22foo%22)%3B%0A%23endif%0A%7D%0A%0Aint+main()%0A%7B%0A++foo()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Rapport

// La rapport est dans le type, pas dans les valeurs ou les instances

- ```cpp std::ratio``` représente un rapport entre deux nombres
- Numérateur et dénominateur sont des paramètres templates
- ```cpp num``` accède au numérateur
- ```cpp den``` accède au dénominateur

```cpp
ratio<6, 2> r;
cout << r.num << "/" << r.den;   // 3/1
```

- Instanciations standards des préfixes du système international d'unités
  - yocto, zepto, atto, femto, pico, nano, micro, milli, centi, déci
  - déca, hecto, kilo, méga, giga, téra, péta, exa, zetta, yotta

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cratio%3E%0A%0Aint+main()%0A%7B%0A++std::ratio%3C6,+2%3E+r%3B%0A++std::cout+%3C%3C+r.num+%3C%3C+!'/!'+%3C%3C+r.den+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Rapport

- Méta-fonctions arithmétiques
  - ```cpp std::ratio_add()```, ```cpp std::ratio_subtract()```
  - ```cpp std::ratio_multiply()```, ```cpp std::ratio_divide()```
// Méta car elles agissent sur les types et non sur les valeurs

```cpp
ratio_add<ratio<6, 2>, ratio<2, 3>> r;
cout << r.num << "/" << r.den;   // 11/3
```

- Méta-fonctions de comparaison
  - ```cpp std::ratio_equal()```, ```cpp std::ratio_not_equal()```
  - ```cpp std::ratio_less()```, ```cpp std::ratio_less_equal()```
  - ```cpp std::ratio_greater()``` et ```cpp std::ratio_greater_equal()```

```cpp
ratio_less_equal<ratio<6, 2>, ratio<2, 3>>::value;  // false
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cratio%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::boolalpha+%0A++++++++++++%3C%3C+std::ratio_less_equal%3Cstd::ratio%3C6,+2%3E,+std::ratio%3C2,+3%3E%3E::value+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cratio%3E%0A%0Aint+main()%0A%7B%0A++std::ratio_add%3Cstd::ratio%3C6,+2%3E,+std::ratio%3C2,+3%3E%3E+r%3B%0A%0A++std::cout+%3C%3C+r.num+%3C%3C+!'/!'+%3C%3C+r.den+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Durées

- Classe template ```cpp std::chrono::duration```
- Unité dépendante d'un ratio avec la seconde
- Instanciations standards _hours_, _minutes_, _seconds_, _milliseconds_, _microseconds_ et _nanosecond_

```cpp
milliseconds foo(12000);  // 12000 ms
foo.count();              // 12000
```

- ```cpp count()``` retourne la valeur
- ```cpp period``` est le type représentant le ratio

```cpp
milliseconds foo(12000);
foo.count() * milliseconds::period::num /
              milliseconds::period::den;  // 12
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cchrono%3E%0A%0Aint+main()%0A%7B%0A++std::chrono::milliseconds+foo(12000)%3B%0A%0A++std::cout+%3C%3C+foo.count()+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+foo.count()+*+std::chrono::milliseconds::period::num+/+std::chrono::milliseconds::period::den+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Durées

- Opérateurs de manipulation des durées (ajout, suppression, ...)

```cpp
milliseconds foo(500);
milliseconds bar(10);
foo += bar;   // 510
foo /= 2;     // 255
```

- Opérateurs de comparaison entre durées
- ```cpp zero()``` crée une durée nulle
- ```cpp min()``` crée la plus petite valeur possible
- ```cpp max()``` crée la plus grande valeur possible

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cchrono%3E%0A%0Aint+main()%0A%7B%0A++std::chrono::milliseconds+foo(500)%3B%0A++std::chrono::milliseconds+bar(10)%3B%0A%0A++foo+%2B%3D+bar%3B%0A++std::cout+%3C%3C+foo.count()+%3C%3C+!'%5Cn!'%3B%0A%0A++foo+/%3D+2%3B%0A++std::cout+%3C%3C+foo.count()+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Temps relatif

- ```cpp std::chrono::time_point``` temps relatif depuis l'epoch

#noteblock("Epoch", text[
  - Origine des temps de l'OS (1 janvier 1970 00h00 sur Unix)
])

- ```cpp time_since_epoch()``` retourne la durée depuis l'epoch
- Opérateurs d'ajout et de suppression d'une durée
- Opérateurs de comparaison entre ```cpp time_point```
- ```cpp min()``` retourne le plus petit temps relatif
- ```cpp max()``` retourne le plus grand temps relatif

== Horloges

- Horloge temps-réel du système ```cpp std::chrono::system_clock```
- ```cpp now()``` récupère temps courant

```cpp
system_clock::time_point today = system_clock::now();
today.time_since_epoch().count();
```

- ```cpp to_time_t()``` converti en ```cpp time_t```
- ```cpp fromtime_t()``` construit depuis ```cpp time_t```

```cpp
system_clock::time_point today = system_clock::now();
time_t tt = system_clock::to_time_t(today);
ctime(&tt);
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cchrono%3E%0A%0Aint+main()%0A%7B%0A++std::chrono::system_clock::time_point+today+%3D+std::chrono::system_clock::now()%3B%0A%0A++time_t+tt+%3D+std::chrono::system_clock::to_time_t(today)%3B%0A++std::cout+%3C%3C+ctime(%26tt)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cchrono%3E%0A%0Aint+main()%0A%7B%0A++std::chrono::system_clock::time_point+today+%3D+std::chrono::system_clock::now()%3B%0A++std::cout+%3C%3C+today.time_since_epoch().count()+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
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
  - Préférez ```cpp std::clock::duration``` aux entiers pour manipuler les durées
])

#alertblock("Attention", text[
  - N'espérez pas une précision arbitrairement grande des horloges
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

```cpp
atomic<int> foo{5};
int bar{5};

foo.compare_exchange_strong(bar, 10);  // foo : 10, bar : 5
foo.compare_exchange_strong(bar, 8);   // foo : 10, bar : 10
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Catomic%3E%0A%0Aint+main()%0A%7B%0A++std::atomic%3Cint%3E+foo%7B5%7D%3B%0A++int+bar%7B5%7D%3B%0A%0A++foo.compare_exchange_strong(bar,+10)%3B%0A++std::cout+%3C%3C+foo+%3C%3C+%22+%22+%3C%3C+bar+%3C%3C+%22%5Cn%22%3B%0A++foo.compare_exchange_strong(bar,+8)%3B%0A++std::cout+%3C%3C+foo+%3C%3C+%22+%22+%3C%3C+bar+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Variables atomiques -- ``` std::atomic```

- ```cpp fetch_add()``` addition et retour de la valeur avant modification

```cpp
	atomic<int> foo{5};

	cout << foo.fetch_add(10) << " ";
	cout << foo;        // Affiche 5 15
```

- ```cpp fetch_sub()``` soustraction et retour de la valeur avant modification
- ```cpp fetch_and()``` et binaire et retour de la valeur avant modification
- ```cpp fetch_or()``` ou binaire et retour de la valeur avant modification
- ```cpp fetch_xor()``` ou exclusif et retour de la valeur avant modification

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Catomic%3E%0A%0Aint+main()%0A%7B%0A++std::atomic%3Cint%3E+foo%7B5%7D%3B%0A%0A++std::cout+%3C%3C+foo.fetch_add(10)+%3C%3C+%22+%22%3B%0A++std::cout+%3C%3C+foo%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Variables atomiques -- ``` std::atomic```

- Plusieurs instanciations standards (```cpp std::atomic_bool```, ```cpp std::atomic_int```, ...)

#noteblock("Mais aussi", text[
  - Plusieurs fonctions "C-style", similaires aux fonctions membres de ```cpp std::atomic```, manipulant atomiquement des données
])

== Variables atomiques -- ``` std::atomic_flag```

- Gestion atomique de _flags_
- Non copiable, non déplaçable, _lock free_
- ```cpp clear()``` remet à 0 le _flag_
- ```cpp test_and_set()``` lève le _flag_ et retourne sa valeur avant modification

```cpp
atomic_flag foo = ATOMIC_FLAG_INIT;

foo.test_and_set();  // false
foo.test_and_set();  // true
foo.clear();
foo.test_and_set();  // false
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Catomic%3E%0A%0Aint+main()%0A%7B%0A++std::atomic_flag+foo+%3D+ATOMIC_FLAG_INIT%3B%0A%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+foo.test_and_set()+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+foo.test_and_set()+%3C%3C+%22%5Cn%22%3B%0A++foo.clear()%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+foo.test_and_set()+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

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

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cthread%3E%0A%23include+%3Cchrono%3E%0A%0Avoid+foo(size_t+imax)%0A%7B%0A++for(size_t+i+%3D+0%3B+i+%3C+imax%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+%22thread+%22+%3C%3C+i+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%7D%0A%0Aint+main()%0A%7B%0A++size_t+imax+%3D+40%3B%0A++std::thread+t(foo,+imax)%3B%0A%0A++for(size_t+i+%3D+0%3B+i+%3C+imax%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+%22main+%22+%3C%3C+i+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A++t.join()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Threads -- ``` std::this_thread```

- Représente le thread courant
- ```cpp yield()``` permet de "passer son tour"
// C'est à dire d'indiquer à l'ordonnanceur qu'il peut replanifier
- ```cpp sleep_for()``` suspend l'exécution sur la durée spécifiée

```cpp
this_thread::sleep_for(chrono::seconds(5));
```

- ```cpp sleep_until()``` suspend le thread jusqu'au temps demandé

#alertblock("Attention", text[
  - Ne vous attendez pas à des attentes arbitrairement précises
  // À l'échéance, le thread n'interrompt pas les autres pour reprendre la main
])

#noteblock("Attentes passives", text[
  - Les autres threads continuent de s'exécuter
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cthread%3E%0A%23include+%3Cchrono%3E%0A%0Aint+main()%0A%7B%0A++std::this_thread::sleep_for(std::chrono::seconds(5))%3B%0A++std::cout+%3C%3C+%22Main%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Mutex -- ``` std::mutex```

- Verrou pour l'accès exclusif à une section de code
- ```cpp lock()``` verrouille le mutex
- ... en attendant sa libération s'il est déjà verrouillé
- ```cpp try_lock()``` verrouille le mutex s'il est libre, retourne ```cpp false``` sinon
- ```cpp unlock()``` relâche le mutex

#alertblock("Attention", text[
  - ```cpp lock()``` sur un mutex verrouillé par le même thread provoque un _deadlock_
])

- ```cpp std::recursive_mutex``` variante verrouillable plusieurs fois par un même thread
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

```cpp
mutex mtx;
{
  lock_guard<mutex> lock(mtx);  // Prise du mutex
  ...
}  // Liberation du mutex
```

#noteblock("Note", text[
  - Gestion du mutex entièrement confiée au _lock_
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cthread%3E%0A%23include+%3Cchrono%3E%0A%23include+%3Cmutex%3E%0A%0Astd::mutex+mtx%3B%0A%0Avoid+foo(size_t+imax)%0A%7B%0A++for(size_t+i+%3D+0%3B+i+%3C+imax%3B+%2B%2Bi)%0A++%7B%0A++++%7B%0A++++++std::lock_guard%3Cstd::mutex%3E+lock(mtx)%3B%0A++++++std::cout+%3C%3C+%22thread+%22+%3C%3C+i+%3C%3C+!'%5Cn!'%3B%0A++++%7D%0A++++std::this_thread::sleep_for(std::chrono::milliseconds(10))%3B%0A++%7D%0A%7D%0A%0Aint+main()%0A%7B%0A++size_t+imax+%3D+40%3B%0A++std::thread+t(foo,+imax)%3B%0A%0A++for(size_t+i+%3D+0%3B+i+%3C+imax%3B+%2B%2Bi)%0A++%7B%0A++++%7B%0A++++++std::lock_guard%3Cstd::mutex%3E+lock(mtx)%3B%0A++++++std::cout+%3C%3C+%22main+%22+%3C%3C+i+%3C%3C+!'%5Cn!'%3B%0A++++%7D%0A++++std::this_thread::sleep_for(std::chrono::milliseconds(10))%3B%0A++%7D%0A++t.join()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Mutex -- ``` std::unique_lock```

- Capsule RAII des mutex
- Supporte les mutex verrouillés ou non
- Relâche le mutex à la destruction
- Expose les méthodes de verrouillage et libération des mutex

```cpp
mutex mtx;
{
  unique_lock<mutex> lock(mtx, defer_lock);
  ...
  lock.lock();  // Prise du mutex
  ...
}  // Liberation du mutex
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cthread%3E%0A%23include+%3Cchrono%3E%0A%23include+%3Cmutex%3E%0A%0Astd::mutex+mtx%3B%0A%0Avoid+foo(size_t+imax)%0A%7B%0A++for(size_t+i+%3D+0%3B+i+%3C+imax%3B+%2B%2Bi)%0A++%7B%0A++++%7B%0A++++++std::unique_lock%3Cstd::mutex%3E+lock(mtx,+std::defer_lock)%3B%0A++++++lock.lock()%3B%0A++++++std::cout+%3C%3C+%22thread+%22+%3C%3C+i+%3C%3C+!'%5Cn!'%3B%0A++++%7D%0A++++std::this_thread::sleep_for(std::chrono::milliseconds(10))%3B%0A++%7D%0A%7D%0A%0Aint+main()%0A%7B%0A++size_t+imax+%3D+40%3B%0A++std::thread+t(foo,+imax)%3B%0A%0A++for(size_t+i+%3D+0%3B+i+%3C+imax%3B+%2B%2Bi)%0A++%7B%0A++++%7B%0A++++++std::lock_guard%3Cstd::mutex%3E+lock(mtx)%3B%0A++++++std::cout+%3C%3C+%22main+%22+%3C%3C+i+%3C%3C+!'%5Cn!'%3B%0A++++%7D%0A++++std::this_thread::sleep_for(std::chrono::milliseconds(10))%3B%0A++%7D%0A++t.join()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Mutex -- ``` std::unique_lock```

- Comportements multiples à de la création
  - Verrouillage immédiat
  - Tentative de verrouillage
  - Acquisition sans verrouillage
  - Acquisition d'un mutex déjà verrouillé
- ```cpp mutex()``` retourne le mutex associé
- ```cpp owns_lock()``` teste si le \textit{lock} a un mutex associé et l'a verrouillé
- ```cpp operator bool()``` encapsule ```cpp owns_lock()```

#noteblock("Note", text[
  - Gestion du mutex conservée, garantie de libération
])

== Mutex -- Gestion multiple

- ```cpp std::lock()``` verrouille tous les mutex passés en paramètre
- ... sans produire de _deadlock_

```cpp
mutex mtx1, mtx2;
lock(mtx1, mtx2);
```

- ```cpp std::try_lock``` tente de verrouiller dans l'ordre tous les mutex passés en paramètre
- ... et relâche les mutex déjà pris en cas d'échec sur l'un d'eux

#codesample(
  "https://godbolt.org/#z:OYLghAFBqd5QCxAYwPYBMCmBRdBLAF1QCcAaPECAMzwBtMA7AQwFtMQByARg9KtQYEAysib0QXACx8BBAKoBnTAAUAHpwAMvAFYTStJg1DIApACYAQuYukl9ZATwDKjdAGFUtAK4sGe1wAyeAyYAHI%2BAEaYxHoADqgKhE4MHt6%2BcQlJAkEh4SxRMVy2mPaOAkIETMQEqT5%2BRXaYDskVVQQ5YZHRegqV1bXpDX3twZ353VwAlLaoXsTI7BzmAMzByN5YANQmy25OvcSYrDvYJhoAgitrG5jbuwQIh0zoJ2eXZqsM615bO27IjwEqFeFyuXxudzcLC8BEwqhBlwuvXQIBA0Nhqk2LAIqiKWJxZh2VlBFwAbqg8OhNvxUBBEgAvTAAfQImzwLCYqkmbxMAHZiedNtSSHS8IyWWy7gARTYaImSv5sjnw5YWbaWax4bkXIV8gVC3X8t4Gg3I1G0VDIADWTOAXiqL12ZrRMLhJ02FutXAg2Nx3NVxpNm2daBhkMV5jMDye6C46rM4d2Ct2irASwArG4GGmiYHDVK88GCCiQA88AoWY8jiWFPRMLEmfxiHTi6iAcQgaiWHRaOWmgJ0AoIFwNJN/frtryC6CpzyyRSqREqqLxaz2ZztZcjTrhc2Gcy19LZfK8JClZz5dZNZvDRPb4Whc7PTa7Q6/s70W7ltgPZarWYfQJccHyLEtQ1ZP4IzMKMq2eBNI0TNxkzcVMMyzHMAx3fNC2dMsK2jatUVrTB60bEUQ0BBhUC7Hs%2BzQBhB2HdMx1zHc%2BWnLcOLeYJWQ5YIIE3PVA33CV10xHYZUkOVMMFUDUQI55NgIb0aVIc8uVY2TcNgqkCAApcyHU4CSVkpsVwPZMZWktVT0VMTLw1SwtUDISsMnO9TVbEBn0A3E1N9MxjNkk0nz/W17WIR03A/V0VR/Z9vV9PFnWeVBYgIJlnyCoM5O8sLX0i98vM/OLf2tACArUlL0DSjKss0nKQ1mCCUyTSM%2BIYeNEOQ1CTEzbMlhkk12Jwry8MrGMiLrBszIojsqJo2heyUejGJHFihsnDihWUgA6bQKQYASGqUsx9sO46ZJGi4OGmWhOHTXg/A4LRSGojgUMctUFFmeZbhWHhSAITRbumK0QHTDR9E4SQnpBt7OF4BQQCh4GXtu0g4FgJA4SaGESHISgqmABRlEMEohAQVAAHdnsBtAWFiOgmDKBgyZCWhKZp57XoZpn6BiEnmFiBQqYIUg%2BboaJQlYRZeElgWAHkYS52n4dx5BzmIEnEdIDWKnwZ7eH4QQRDEdgpBkQRFBUdR0dIXQigMIwUCvSx9DwCJkcgaZauSZGOAAWmRCTTC%2Brg40DgB1MRaE2aO4QIYgmF4VBSWiYhKUwb2BNIYgvEEdlMAAFVQTwc%2BmH65gWHpi2CdmKaptXuF4JOSM4QHqeT2IQbuh64ft97sFUPGiGITZVAADgANkD6fJE2YBkGQTYICTgurUmVfPqsd3NlwQgSHVZYplb3vpgQatulz8HIehjhYdIHnU915HUfP%2B%2BzAH173rP9Gx1IOnYgiRnCSCAA%3D%3D",
)

== Mutex -- ``` std::call_once()```

- Garantit l'appel unique (pour un _flag_ donnée) de la fonction en paramètre
- Si la fonction a déjà été exécutée, ```cpp std::call_once()``` retourne sans exécuter la fonction
- Si la fonction est en cours d'exécution, ```cpp std::call_once()``` attend la fin de cette exécution avant de retourner

```cpp
void foo(int, char);

once_flag flag;
call_once(flag, foo, 42, 'r');
```

#noteblock("Cas d'utilisation", text[
  - Appelle par un unique thread d'une fonction d'initialisation
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cmutex%3E%0A%0Avoid+foo(int+a,+char+b)%0A%7B%0A++std::cout+%3C%3C+a+%3C%3C+%22-%22+%3C%3C+b+%3C%3C+%22%5Cn%22%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::once_flag+flag%3B%0A++std::once_flag+other%3B%0A%0A++std::call_once(flag,+foo,+42,+!'r!')%3B%0A++std::call_once(flag,+foo,+43,+!'s!')%3B%0A++std::call_once(other,+foo,+44,+!'t!')%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

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
  - Possibilité de fournir un prédicat
    - Blocage seulement s'il retourne ```cpp false```
    - Déblocage seulement s'il retourne ```cpp true```
])

== Variables conditionnelles -- ``` condition_variable```

- ```cpp wait_for()``` met en attente le thread, au maximum la durée donnée
- ```cpp wait_until()``` met en attente le thread, au maximum jusqu'au temps donné

#noteblock("Note", text[
  - ```cpp wait_for()``` et ```cpp wait_until()``` indique si l'exécution a repris suite à un timeout
])

== Variables conditionnelles -- ``` condition_variable```

- ```cpp notify_one()``` notifie un des threads en attente sur la variable conditionnelle

#alertblock("Attention", text[
  - Impossible de choisir quel thread notifié avec ```cpp notify_one()```
])

- ```cpp notify_all()``` notifie tous les threads en attente
- ```cpp std::condition_variable_any``` similaire à ```cpp std::condition_variable```
- ... sans être limité à ```cpp std::unique_lock```
- ```cpp std::notify_all_at_thread_exit()```
  - Indique de notifier tous les threads à la fin du thread courant
  - Prend un verrou qui sera libéré à la fin du thread

== Variables conditionnelles -- ``` condition_variable```

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

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cthread%3E%0A%23include+%3Cchrono%3E%0A%23include+%3Cmutex%3E%0A%23include+%3Ccondition_variable%3E%0A%0Astd::mutex+mtx%3B%0Astd::condition_variable+cv%3B%0A%0Avoid+print_id(int+id)%0A%7B%0A++std::unique_lock%3Cstd::mutex%3E+lck(mtx)%3B%0A++cv.wait(lck)%3B%0A++std::cout+%3C%3C+%22thread+%22+%3C%3C+id+%3C%3C+!'%5Cn!'%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::thread+threads%5B10%5D%3B%0A%0A++for(int+i+%3D+0%3B+i%3C10%3B+%2B%2Bi)%0A++%7B%0A++++threads%5Bi%5D+%3D+std::thread(print_id,+i)%3B%0A++%7D%0A++std::this_thread::sleep_for(std::chrono::seconds(5))%3B%0A++cv.notify_all()%3B%0A%0A++for(auto%26+th+:+threads)%0A++%7B%0A++++th.join()%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
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
  - ```cpp std::promise``` et ```cpp std::future``` peuvent également manipuler des exceptions
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
  - Après un appel à ```cpp share()```, le ```cpp std::future``` n'est plus valide
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
  - Deux politiques d'exécution de la fonction appelée
    - Exécution asynchrone
    - Exécution différée à l'appel de ```cpp wait()``` ou ```cpp get()```
  - Par défaut le choix est laissé à l'implémentation
])

== Futures et promise -- ``` std::async()```

```cpp
int foo() {
  this_thread::sleep_for(chrono::seconds(5));
  return 10;
}

future<int> bar = async(launch::async, foo);
...
cout << bar.get() << "\n";
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cthread%3E%0A%23include+%3Cchrono%3E%0A%23include+%3Cfuture%3E%0A%0Aint+foo()%0A%7B%0A++std::cout+%3C%3C+%22Begin+foo%5Cn%22%3B%0A++std::this_thread::sleep_for(std::chrono::seconds(5))%3B%0A++std::cout+%3C%3C+%22End+foo%5Cn%22%3B%0A++return+10%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::future%3Cint%3E+bar+%3D+async(std::launch::async,+foo)%3B%0A++std::cout+%3C%3C+%22Attente%5Cn%22%3B%0A++std::this_thread::sleep_for(std::chrono::seconds(1))%3B%0A++std::cout+%3C%3C+%22Attente%5Cn%22%3B%0A++std::cout+%3C%3C+bar.get()+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:49.99999999999999,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:49.99999999999999,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Futures et promise -- ``` std::promise```

- Objet que l'on promet de valoriser ultérieurement
- Déplaçable mais non copiable
- Partage un état avec le ```cpp std::future``` associé
- ```cpp get_future()``` retourne le ```cpp std::future``` associé

#alertblock("Attention", text[
  - Un seul ```cpp std::future``` par ```cpp std::promise``` peut être récupéré
])

== Futures et promise -- ``` std::promise```

- ```cpp set_value()``` affecte une valeur et passe l'état partagé à prêt
- ```cpp set_exception()``` affecte une exception et passe l'état partagé à prêt
- ```cpp set_value_at_thread_exit()``` affecte une valeur, l'état partagé passera à prêt à la fin du thread
- ```cpp set_exception_at_thread_exit()``` affecte une exception, l'état partagé passera à prêt à la fin du thread

== Futures et promise -- ``` std::promise```

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

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cthread%3E%0A%23include+%3Cchrono%3E%0A%23include+%3Cfuture%3E%0A%0Avoid+foo(std::future%3Cint%3E%26+fut)%0A%7B%0A++int+x+%3D+fut.get()%3B%0A++std::cout+%3C%3C+x+%3C%3C+!'%5Cn!'%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::promise%3Cint%3E+prom%3B%0A++std::future%3Cint%3E+fut+%3D+prom.get_future()%3B%0A++std::thread+th1(foo,+ref(fut))%3B%0A%0A++std::this_thread::sleep_for(std::chrono::seconds(2))%3B%0A%0A++prom.set_value(10)%3B%0A++th1.join()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:49.99999999999999,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:49.99999999999999,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Futures et promise -- ``` std::packaged_task```

- Encapsulation d'un appelable similaire à ```cpp std::function```
- ... dont la valeur de retour est récupérable par un ```cpp std::future```
- Partage un état avec le ```cpp std::future``` associé
- ```cpp valid()``` teste s'il est associé à un état partagé (contient un appelable)
- ```cpp get_future()``` retourne le ```cpp std::future``` associé

#alertblock("Attention", text[
  - Un seul ```cpp std::future``` par ```cpp std::packaged_task``` peut être récupéré
])

== Futures et promise -- ``` std::packaged_task```

- ```cpp operator()``` appelle l'appelable, affecte sa valeur de retour (ou l'exception levée) au ```cpp std::future``` et passe l'état partagé à prêt
- ```cpp reset()``` réinitialise l'état partagé en conservant l'appelable

#noteblock("note", text[
  - ```cpp reset()``` permet d'appeler une nouvelle fois l'appelable
])

- ```cpp make_ready_at_thread_exit()``` appelle l'appelable et affecte sa valeur de retour (ou l'exception levée), l'état partagé passera à prêt à la fin

== Futures et promise -- ``` std::packaged_task```

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

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:8,endLineNumber:21,positionColumn:8,positionLineNumber:21,selectionStartColumn:8,selectionStartLineNumber:21,startColumn:8,startLineNumber:21),source:'%23include+%3Ciostream%3E%0A%23include+%3Cthread%3E%0A%23include+%3Cchrono%3E%0A%23include+%3Cfuture%3E%0A%0Avoid+foo(std::future%3Cint%3E%26+fut)%0A%7B%0A++int+x+%3D+fut.get()%3B%0A++std::cout+%3C%3C+x+%3C%3C+!'%5Cn!'%3B%0A%7D%0A%0Aint+bar()%0A%7B%0A++return+10%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::packaged_task%3Cint()%3E+tsk(bar)%3B%0A++std::future%3Cint%3E+fut+%3D+tsk.get_future()%3B%0A++std::thread+th1(foo,+std::ref(fut))%3B%0A%0A++std::this_thread::sleep_for(std::chrono::seconds(2))%3B%0A%0A++tsk()%3B%0A++th1.join()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:49.99999999999999,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:49.99999999999999,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Conclusion

#adviceblock("Do, dans cet ordre", text[
  - Évitez de partager variables et ressources
  - Préférez les partages en lecture seule
  - Préférez les structures de données gérant les accès concurrents
  // std::atomic`, conteneur lock-free, conteneur thread-safe, etc.
  - Protégez l'accès par mutex ou autres barrières
])

#adviceblock("Do", text[
  - Encapsulez les mutex dans des ```cpp std::lock_guard``` ou ```cpp std::unique_lock```
])

== Conclusion

#adviceblock("Do", text[
  - Analysez vos cas d'utilisation pour choisir le bon outil
])

#alertblock("Attention", text[
  - Très faibles garanties de _thread-safety_ de la part des conteneurs standards
  // En gros plusieurs threads peuvent lire un même conteneur et plusieurs threads peuvent lire ou écrire simultanément des conteneurs différents sans problème et c'est à peu prés tout
])

#adviceblock("Do", text[
  - ```cpp Boost.Lockfree``` pour des structures de données _thread-safe_ et _lock-free_
])

#noteblock("Pour aller plus loin", text[
  - Voir _C++ Concurrency in action_ d'Anthony Williams
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

```cpp
regex r("[0-9]+");
regex_search(string("123"), r);         // true
regex_search(string("abcd123efg"), r);  // true
regex_search(string("abcdefg"), r);     // false
```

```cpp std::regex_match()``` vérifie la correspondance

```cpp
regex r("[0-9]+");
regex_match(string("123"), r);          // true
regex_match(string("abcd123efg"), r);   // false
regex_match(string("abcdefg"), r);      // false
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cregex%3E%0A%0Aint+main()%0A%7B%0A++std::regex+r(%22%5B0-9%5D%2B%22)%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::regex_match(std::string(%22123%22),+r)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::regex_match(std::string(%22abcd123efg%22),+r)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::regex_match(std::string(%22abcdefg%22),+r)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:49.99999999999999,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:49.99999999999999,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cregex%3E%0A%0Aint+main()%0A%7B%0A++std::regex+r(%22%5B0-9%5D%2B%22)%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::regex_search(std::string(%22123%22),+r)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::regex_search(std::string(%22abcd123efg%22),+r)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::regex_search(std::string(%22abcdefg%22),+r)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:49.99999999999999,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:49.99999999999999,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

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

== Expressions rationnelles (regex)

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

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cregex%3E%0A%0Aint+main()%0A%7B%0A++std::string+s(%22abcd123efg%22)%3B%0A++std::regex+r(%22%5B0-9%5D%2B%22)%3B%0A++std::smatch+m%3B%0A%0A++std::regex_search(s,+m,+r)%3B%0A++std::cout+%3C%3C+m.size()+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+m.str(0)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+m.position(0)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+m.prefix()+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+m.suffix()+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:49.99999999999999,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:49.99999999999999,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Expressions rationnelles (regex)

- Fonction de remplacement : ```cpp std::regex_replace()```

```cpp
string s("abcd123efg");
regex r("[0-9]+");
regex_replace(s, r, "-"); // abcd-efg
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cregex%3E%0A%0Aint+main()%0A%7B%0A++std::string+s(%22abcd123efg%22)%3B%0A++std::regex+r(%22%5B0-9%5D%2B%22)%3B%0A++std::cout+%3C%3C+std::regex_replace(s,+r,+%22-%22)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:49.99999999999999,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:49.99999999999999,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== Expressions rationnelles (regex)

#adviceblock("Do", text[
  - Préférez les expressions rationnelles aux analyseurs "à la main"
])

#alertblock("Don't", text[
  - N'utilisez pas les expressions rationnelles pour les traitements triviaux
  - Préférez les algorithmes
])

#noteblock("Conseil", text[
  - Encapsulez les expressions rationnelles ayant une sémantique claire et utilisées plusieurs fois dans une fonction dédiée au nom évocateur
])

#noteblock("Performance", text[
  - Construction très coûteuse de l'expression rationnelle
])

== Nombres aléatoires

- Générateurs pseudo-aléatoires initialisés par une graine (congruence linéaire, Mersenne, ...)
- Générateur aléatoire

#alertblock("Attention", text[
  - Peut ne pas être présent sur certaines implémentations
  - Peut être un générateur pseudo-aléatoire (entropie nulle) sur d'autres
])

- Distributions adaptant la séquence d'un générateur pour respecter une distribution particulière (uniforme, normale, binomiale, de Poisson, ...)
- Fonction de normalisation ramenant la séquence générée dans [0,1)

#addproposal("n1836")

== Nombres aléatoires
```cpp
	default_random_engine gen;
	uniform_int_distribution<int> distribution(0,9);
	gen.seed(system_clock::now().time_since_epoch().count());

	// Nombre aleatoire entre 0 et 9
	distribution(gen);
```

#adviceblock("Do", text[
  - Préférez ces générateurs et distributions à ```cpp rand()```
])

#noteblock("Quiz", text[
  Comment générer un tirage équiprobable entre 6 et 42 avec ```cpp rand()```
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Crandom%3E%0A%23include+%3Cchrono%3E%0A%0Aint+main()%0A%7B%0A++std::default_random_engine+generator%3B%0A++std::uniform_int_distribution%3Cint%3E+distribution(0,9)%3B%0A%0A++generator.seed(std::chrono::system_clock::now().time_since_epoch().count())%3B%0A++std::cout+%3C%3C+distribution(generator)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

= C++14

== Présentation

- Approuvé le 16 août 2014
- Dernier \textit{Working Draft} : #link("https://wg21.link/std14")[N4140 #linklogo()]
- Dans la continuité de C++11
- Changements moins importants
- Mais loin d'une simple version correctrice

== ``` constexpr```

- Fonctions membres ```cpp constexpr``` plus implicitement ```cpp const```
- Relâchement des contraintes sur les fonctions ```cpp constexpr```
  - Variables locales (ni ```cpp static```, ni ```cpp thread_local```, obligatoirement initialisées)
  - Objets mutables créés lors l'évaluation de l'expression constante
  - ```cpp if```, ```cpp switch```, ```cpp while```, ```cpp for```, ```cpp do while```
- Application de ```cpp constexpr``` à plusieurs éléments de la bibliothèque standard

#addproposal("N3652")

== Généralisation de la déduction du type retour

- Utilisable sur les lambdas complexes

```cpp
[](int x) {
  if(x >= 0) return 2 * x;
  else return -2 * x;
};
```

- Mais aussi sur les fonctions

```cpp
auto foo(int x) {
  if(x >= 0) return 2 * x;
  else return -2 * x;
}
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astatic+auto+bar(int+x)%0A%7B%0A++if(x+%3E%3D+0)+return+2+*+x%3B%0A++else+return+-2+*+x%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+bar(5)+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+bar(-2)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++auto+foo+%3D+%5B%5D(int+x)%0A++%7B%0A++++if(x+%3E%3D+0)+return+2+*+x%3B%0A%09else+return+-2+*+x%3B%0A++%7D%3B%0A%0A++std::cout+%3C%3C+foo(5)+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+foo(-2)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("N3638")

== Généralisation de la déduction du type retour

- Y compris récursive

```cpp
auto fact(unsigned int x) {
  if(x == 0) return 1U;
  else return x * fact(x - 1);
}
```

#alertblock("Contraintes", text[
  - Un ```cpp return``` doit précéder l'appel récursive
  - Tous les chemins doivent avoir le même type de retour
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astatic+auto+fact(unsigned+int+x)%0A%7B%0A++if(x+%3D%3D+0)+return+1U%3B%0A++else+return+x+*+fact(x-1)%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+fact(4)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

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

```cpp
struct Foo {int i, int j = 5};

Foo foo{42};   // i = 42, j = 5
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astruct+Foo%0A%7B%0A++int+a%3B%0A++int+b+%3D+42%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++Foo+foo%7B6%7D%3B%0A++std::cout+%3C%3C+foo.a+%3C%3C+!'+!'+%3C%3C+foo.b+%3C%3C+!'%5Cn!'%3B%0A%0A++Foo+bar%7B6,+5%7D%3B%0A++std::cout+%3C%3C+bar.a+%3C%3C+!'+!'+%3C%3C+bar.b+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("N3653")

== Itérateurs

- Fonctions libres ```cpp std::cbegin()``` et ```cpp std::cend()```
- Fonctions libres ```cpp std::rbegin()``` et ```cpp std::rend()```
- Fonctions libres ```cpp std::crbegin()``` et ```cpp std::crend()```
- _Null forward iterator_ ne référençant aucun conteneur valide

```cpp
auto ni = vector<int>::iterator();
auto nd = vector<double>::iterator();

ni == ni;    // true
nd != nd;    // false
ni == nd;    // Erreur de compilation
```

#alertblock("Attention", text[
  - _Null forward iterator_ non comparables avec des itérateurs classiques
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Aint+main()%0A%7B%0A++auto+ni+%3D+std::vector%3Cint%3E::iterator()%3B%0A++auto+nd+%3D+std::vector%3Cdouble%3E::iterator()%3B%0A%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+(ni+%3D%3D+ni)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+(nd+!!%3D+nd)+%3C%3C+%22%5Cn%22%3B%0A%23if+0%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+(ni+%3D%3D+nd)+%3C%3C+%22%5Cn%22%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

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

```cpp
vector<int> foo{1, 2, 3};
vector<int> bar{10, 11};

equal(begin(foo), end(foo), begin(bar), end(bar));
```

- ```cpp std::exchange()``` change la valeur d'un objet et retourne l'ancienne

```cpp
vector<int> foo{1, 2, 3};
vector<int> bar = exchange(foo, {10, 11});
// foo : 10 11, bar : 1, 2, 3
```

#noteblock("Dépréciation", text[
  - Dépréciation de ```cpp std::random_shuffle()```
  // Remplacé par std::shuffle() qui permet un meilleur aléa
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cutility%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B1,+2,+3%7D%3B%0A++std::vector%3Cint%3E+bar+%3D+std::exchange(foo,+%7B10,+11%7D)%3B%0A%0A++for(const+auto+e:+foo)%0A++%7B%0A++++std::cout+%3C%3C+e+%3C%3C+%22+%22%3B%0A++%7D%0A++std::cout+%3C%3C+%22%5Cn%22%3B%0A++for(const+auto+e:+bar)%0A++%7B%0A++++std::cout+%3C%3C+e+%3C%3C+%22+%22%3B%0A++%7D%0A++std::cout+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B1,+2,+3%7D%3B%0A++std::vector%3Cint%3E+bar%7B10,+11,+12%7D%3B%0A++std::vector%3Cint%3E+baz%7B1,+2%7D%3B%0A%0A++std::cout+%3C%3C+std::boolalpha%3B%0A++std::cout+%3C%3C+std::equal(std::begin(foo),+std::end(foo),+std::begin(foo),+std::end(foo))+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::equal(std::begin(foo),+std::end(foo),+std::begin(bar),+std::end(bar))+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::equal(std::begin(foo),+std::end(foo),+std::begin(bar),+std::end(bar))+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("N3668")
#addproposal("N3671")

== Quoted string

- Insertion et extraction de chaînes avec guillemets

```cpp
string foo = "Chaine avec \"guillemets\"";
cout << foo << "\n";      // Chaine avec "guillemets"

stringstream ss;
ss << quoted(foo);
cout << ss.str() << "\n"; // "Chaine avec \"guillemets\""

string bar;
ss >> quoted(bar);
cout << bar << "\n";      // Chaine avec "guillemets"
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%23include+%3Csstream%3E%0A%23include+%3Ciomanip%3E%0A%0Aint+main()%0A%7B%0A++std::string+foo+%3D+%22Chaine+avec+%5C%22guillemets%5C%22%22%3B%0A++std::cout+%3C%3C+foo+%3C%3C+%22%5Cn%22%3B%0A%0A++std::stringstream+ss%3B%0A++ss+%3C%3C+std::quoted(foo)%3B%0A++std::cout+%3C%3C+ss.str()+%3C%3C+%22%5Cn%22%3B%0A%0A++std::string+bar%3B%0A++ss+%3E%3E+std::quoted(bar)%3B%0A++std::cout+%3C%3C+bar+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("N3654")

== Littéraux binaires

- Support des littéraux binaires préfixés par ```cpp 0b```

```cpp
int foo = 0b101010; // 42
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++int+foo+%3D+0b101010%3B%0A%0A++std::cout+%3C%3C+foo+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("N3472")

== Séparateurs

- Utilisation possible de ' dans les nombres littéraux

```cpp
int foo = 0b0010'1010;  // 42
int bar = 1'000;        // 1000
int baz = 010'00;       // 512
```

#noteblock("Note", text[
  - Purement esthétique, aucune sémantique ni place réservée
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+0b0010!'1010+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+1!'000+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+010!'00+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("N3781")

== User-defined literals standards

- Suffixe ```cpp s``` sur les chaînes : ```cpp std::string```

```cpp
auto foo = "abcd"s;   // string
```

#noteblock("Note", text[
  - Remplace ```cpp std::string{"abcd"}```
])

#alertblock("Attention", text[
  - Nécessite l'utilisation de ```cpp using namespace std::literals```
])


#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%0Ausing+namespace+std::literals%3B%0A%0Aint+main()%0A%7B%0A++auto+s1+%3D+%22Abcd%22%3B%0A++auto+s2+%3D+%22Abcd%22s%3B%0A%0A++std::cout+%3C%3C+std::boolalpha%3B%0A++std::cout+%3C%3C+(typeid(s1)+%3D%3D+typeid(std::string))+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+(typeid(s1)+%3D%3D+typeid(const+char*))+%3C%3C+%22%5Cn%22%3B%0A%0A++std::cout+%3C%3C+(typeid(s2)+%3D%3D+typeid(std::string))+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("N3642")

== User-defined literals standards

- Suffixe ```cpp h```, ```cpp min```, ```cpp s```, ```cpp ms```, ```cpp us``` et ```cpp ns``` : ```cpp std::chrono::duration```

```cpp
auto foo = 60s;   // chrono::seconds
auto bar = 5min;  // chrono::minutes
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cchrono%3E%0A%0Ausing+namespace+std::literals%3B%0A%0Aint+main()%0A%7B%0A++auto+foo+%3D+60s%3B+++//+chrono::seconds%0A++auto+bar+%3D+5min%3B++//+chrono::minutes%0A%0A++std::cout+%3C%3C+(foo+%2B+bar).count()+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("N3642")

== User-defined literals standards

- Suffixe ``` if``` : nombre imaginaire de type ```cpp std::complex<float>```
- Suffixe ``` i``` : nombre imaginaire de type ```cpp std::complex<double>```
- Suffixe ``` il``` : nombre imaginaire de type ```cpp std::complex<long double>```

```cpp
auto foo = 5i;  // complex<double>
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ccomplex%3E%0A%0Ausing+namespace+std::literals%3B%0A%0Aint+main()%0A%7B%0A++auto+foo+%3D+5i%3B%0A%0A++std::cout+%3C%3C+foo.real()+%3C%3C+%22+-+%22+%3C%3C+foo.imag()+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("N3642")

== Adressage des ``` std::tuple``` par le type

- Utilisation du type plutôt que de l'indice

```cpp
tuple<int, long, long> foo{42, 58L, 9L};

get<int>(foo);  // 42
```

#alertblock("Attention", text[
  - Uniquement s'il n'y a qu'une occurrence du type dans le ```cpp std::tuple```
])

```cpp
get<long>(foo);  // Erreur
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ctuple%3E%0A%0Aint+main()%0A%7B%0A++std::tuple%3Cint,+long,+long%3E+foo%7B42,+58L,+9L%7D%3B%0A%0A++std::cout+%3C%3C+std::get%3Cint%3E(foo)+%3C%3C+!'%5Cn!'%3B%0A%23if+0%0A++std::cout+%3C%3C+std::get%3Clong%3E(foo)+%3C%3C+!'%5Cn!'%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("N3670")

== Variable template

- Généralisation des templates aux variables
- Y compris les spécialisations

```cpp
template<typename T>
constexpr T PI = T(3.1415926535897932385);

template<>
constexpr const char* PI<const char*> = "pi";

PI<int>;          // 3
PI<double>;       // 3.14159
PI<const char*>;  // pi
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Atemplate%3Ctypename+T%3E%0Aconstexpr+T+PI+%3D+T(3.1415926535897932385)%3B%0A%0Atemplate%3C%3E%0Aconstexpr+const+char*+PI%3Cconst+char*%3E+%3D+%22pi%22%3B%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+PI%3Cint%3E+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+PI%3Cdouble%3E+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+PI%3Cconst+char*%3E+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("N3651")

== Generic lambdas

- Lambdas utilisables sur différents types de paramètres
- Déduction du type des paramètres déclarés ```cpp auto```

```cpp
auto foo = [] (auto in) { cout << in << '\n'; };

foo(2);
foo("azerty"s);
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%0Ausing+namespace+std::literals%3B%0A%0Aint+main()%0A%7B%0A++auto+foo+%3D+%5B%5D+(auto+in)+%7B+std::cout+%3C%3C+in+%3C%3C+!'%5Cn!'%3B+%7D%3B%0A%0A++foo(2)%3B%0A++foo(%22azerty%22s)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("N3649")

== Variadic lambdas

- Lambda à nombre de paramètres variable
- Suffixe ```cpp ...``` à ```cpp auto```

```cpp
auto foo = [] (auto... args) {
  std::cout << sizeof...(args) << '\n';
};

foo(2);           // 1
foo(2, 3, 4);     // 3
foo("azerty"s);   // 1
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%0Ausing+namespace+std::literals%3B%0A%0Aint+main()%0A%7B%0A++auto+foo+%3D+%5B%5D+(auto...+args)+%7B+std::cout+%3C%3C+sizeof...(args)+%3C%3C+!'%5Cn!'%3B+%7D%3B%0A%0A++foo(2)%3B%0A++foo(2,+3,+4)%3B%0A++foo(%22azerty%22s)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("N3649")

== Capture généralisée

- Création de variables capturées depuis des variables locales ou des constantes

```cpp
int foo = 42;

auto bar = [ &x = foo ]() { --x; };
bar();  // foo : 41

auto baz = [ y = 10 ]() { return y; };
baz();  // 10

auto qux = [ z = 2 * foo ]() { return z; };
qux();  // 82
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++int+foo+%3D+42%3B%0A%0A++auto+bar+%3D+%5B+%26x+%3D+foo+%5D()+%7B+--x%3B+%7D%3B%0A++bar()%3B%0A++std::cout+%3C%3C+foo+%3C%3C+%22%5Cn%22%3B%0A%0A++auto+baz+%3D+%5B+y+%3D+10+%5D()+%7B+return+y%3B+%7D%3B%0A++std::cout+%3C%3C+baz()+%3C%3C+%22%5Cn%22%3B%0A%0A++auto+qux+%3D+%5B+z+%3D+2+*+foo+%5D()+%7B+return+z%3B+%7D%3B%0A++std::cout+%3C%3C+qux()+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("N3648")

== Capture généralisée

- Capture par déplacement

```cpp
auto foo = make_unique<int>(42);
auto bar = [ foo = move(foo) ](int i) {
  cout << *foo * i << '\n';
};

bar(5);  // Affiche 210
```

- Capture des variables membres

```cpp
struct Bar {
  auto foo() { return [s=s] { cout << s << '\n'; }; }

  string s;
};
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%0Astruct+Bar%0A%7B%0A++auto+foo()+%7B+return+%5Bs%3Ds%5D+%7B+std::cout+%3C%3C+s+%3C%3C+!'%5Cn!'%3B+%7D%3B+%7D%0A%0A++std::string+s%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++Bar+bar%3B%0A++bar.s+%3D+%22Test%22%3B%0A%0A++bar.foo()()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cmemory%3E%0A%0Aint+main()%0A%7B%0A++auto+foo+%3D+std::make_unique%3Cint%3E(42)%3B%0A++auto+bar+%3D+%5B+foo+%3D+std::move(foo)+%5D(int+i)+%7B+std::cout+%3C%3C+*foo+*+i+%3C%3C+!'%5Cn!'%3B+%7D%3B%0A%0A++bar(5)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("N3648")

== Améliorations des lambdas

- Type de retour complètement facultatif
// Il n'y a plus les restrictions de C++11 (une seule instruction, de type return)
- Conversion possible de lambda sans capture en pointeur de fonction
// Donc passable à des fonctions C attendant un pointeur de fonction en paramètre

```cpp
void foo(void(* bar)(int))

foo([](int x) { cout << x << "\n"; });
```

- Peuvent être ```cpp noexcept```
- Ajout des paramètres par défaut aux lambdas

```cpp
auto foo = [] (int bar = 12) { cout << bar << "\n"; };
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++auto+foo+%3D+%5B%5D+(int+bar+%3D+12)+%7B+std::cout+%3C%3C+bar+%3C%3C+%22%5Cn%22%3B+%7D%3B%0A%0A++foo()%3B%0A++foo(5)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Avoid+foo(void(*+bar)(int))%0A%7B%0A++bar(5)%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++foo(%5B%5D(int+x)+%7B+std::cout+%3C%3C+x+%3C%3C+%22%5Cn%22%3B+%7D)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

== ``` std::is_final```

- Indique si la classe est finale ou non

```cpp
class Foo {};
class Bar final {};

is_final<Foo>::value;   // false
is_final<Bar>::value;   // true
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ctype_traits%3E%0A%0Aclass+Foo%0A%7B%7D%3B%0A%0Aclass+Bar+final%0A%7B%7D%3B%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::boolalpha%3B%0A++std::cout+%3C%3C+std::is_final%3CFoo%3E::value+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::is_final%3CBar%3E::value+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
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
  - Plus de ```cpp new``` dans le code applicatif
])


#noteblock("Note", text[
  - Utilisable pour construire dans un conteneur
])

#addproposal("N3656")

== Attribut ``` [[ deprecated ]]```

- Indique qu'une entité (variable, fonction, classe, ...) est dépréciée
- Émission possible d'avertissement sur l'utilisation d'une entité ```cpp deprecated```
// Possible car il n'y a pas d'obligation dans la norme

```cpp
[[ deprecated ]]
void bar() {}

class [[ deprecated ]] Baz {};

[[ deprecated ]]
int foo{42};
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0A%5B%5B+deprecated+%5D%5D%0Astatic+void+bar()%0A%7B%0A%7D%0A%0Aclass+%5B%5B+deprecated+%5D%5D+Baz%0A%7B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++bar()%3B%0A%0A++Baz+baz%3B%0A%0A++%5B%5B+deprecated+%5D%5D%0A++int+foo%7B42%7D%3B%0A++std::cout+%3C%3C+foo+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("N3760")

== Attribut ``` [[ deprecated ]]```

- Possibilité de fournir un message explicatif

```cpp
[[ deprecated("Utilisez Foo") ]]
void bar() {}
```

```shell
warning: 'void bar()' is deprecated: Utilisez Foo
```

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0A%5B%5B+deprecated(%22Utilisez+Foo%22)+%5D%5D%0Astatic+void+bar()%0A%7B%0A%7D%0A%0Aint+main()%0A%7B%0A++bar()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B14+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("N3760")

== ``` std::shared_timed_mutex```

- Similaire à ```cpp std::timed_mutex``` avec deux niveaux d'accès
  - Exclusif : possible si le verrou n'est pas pris
  - Partagé : possible si le verrou n'est pas pris en exclusif
- Même API que ```cpp std::timed_mutex``` pour l'accès exclusif
- API similaire pour l'accès partagé

#alertblock("Attention", text[
  - Un thread ne doit pas prendre un mutex qu'il possède déjà
  - Même en accès partagé
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

= C++17

== Présentation

- Approuvé en décembre 2017
- Dernier Working Draft : #link("https://wg21.link/std17")[N4659 #linklogo()]

#noteblock("Note", text[
  - Voir #link("https://www.youtube.com/user/lefticus1/videos")[Vidéos C++ Weekly #linklogo()] (Jason Turner)
])

== Fonctionnalités supprimées

- Suppression des trigraphes (non dépréciés)

#noteblock("Note", text[
  - Les digraphes ne sont pas concernés
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
  - Ne justifie pas l'usage de variables globales
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
  - Conditions d'arrêt plus simple avec les _variadic template_}
  - Moins de spécialisations explicites
])

#noteblock("Note", text[
  - Conditions intégralement évaluables au _compile-time_, pas de court-circuit

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
  - Les branches doivent être syntaxiquement correctes
  - ... mais pas nécessairement sémantiquement valides
])

#noteblock("Note", text[
  - Les branches peuvent avoir des types retour différents sans remettre en cause la déduction de type retour
])

#adviceblock("Do", text[
  - Préférez ```cpp if constexpr``` aux suites de spécialisations de template et SFINAE, aux imbrications de ternaires ou à ```cpp #if```
])

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
  - La portée de l'objet référencé doit être supérieure à celle des références
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
  - Meilleure lisibilité
  - Remplacement de ```cpp std::tie()```
])

#noteblock("Nom", text[
  - Déstructuration (\textit{destructuring}) dans d'autres langages
])

#noteblock("Et ensuite ?", text[
  - Premier pas vers les types algébriques de données et le _pattern matching_
])

// Type algébrique : type somme de types produit
// Type produit : analogue sur les types du produit cartésien sur les ensembles
// Type somme : analogue sur les types de l'union disjointe

#alertblock("Limite", text[
  - Pas de capture de _structured binding_ par les lambdas
])

// Possible de passer par la capture généralisée

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
  - Ordre d'évaluation des paramètres toujours non fixé
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
  - Élision de copies possibles avant C++17, garanties maintenant
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
  - Uniquement sur de l'héritage public non virtuel
  - Pas de constructeur fourni par l'utilisateur (y compris hérité)
  - Pas de donnée membre non statique privée ou protégée
  - Pas de fonction virtuelle
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
- ... et les conversions vers des entiers (```cpp std::to_integer```)
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

== ``` emplace_back()```, ``` emplace_front()```}

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
  - ```cpp emplace()``` renvoie toujours un itérateur
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cstd::vector%3Cint%3E%3E+foo%3B%0A++foo.emplace_back(3,+1).push_back(42)%3B%0A%0A++for(const+auto%26+vec:+foo)%0A++%7B%0A++++for(const+auto+it:+vec)%0A++++%7B%0A++++++std::cout+%3C%3C+it+%3C%3C+%22+%22%3B%0A++++%7D%0A++++std::cout+%3C%3C+%22%5Cn%22%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0084")

== Fonctions libres de manipulation

- ```cpp std::size()```
  - Conteneurs et ```cpp initializer_list``` : résultat de la fonction membre ```cpp size()```
  - Tableau C : taille du tableau
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
  - Utilisation avec des API C
  - Utilisation  de ```cpp memcpy``` et ```cpp memset```
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
  - Pas d'exception, pas de gestion mémoire, pas de locale
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ccharconv%3E%0A%0Aint+main()%0A%7B%0A++char+str%5B25%5D+%3D+%22%22%3B%0A++std::to_chars(std::begin(str),+std::end(str),+12.5)%3B%0A++std::cout+%3C%3C+str+%3C%3C+%22%5Cn%22%3B%0A%0A++double+val+%3D+0%3B%0A++std::from_chars(std::begin(str),+std::end(str),+val)%3B%0A++std::cout+%3C%3C+val+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0067")

== ``` std::variant```

- Union _type-safe_ contenant une valeur d'un type choisi parmi $n$
- Type contenu dépend de la valeur assignée

#alertblock("Restrictions", text[
  - Ne peut pas contenir de références, de tableaux C, ```cpp void``` ni être vide
  // Mais peut contenir plusieurs fois le même type (avec des qualifiers cv identiques ou non)
  // Contenir plusieurs fois le même type peut être utile dans le cadre de code template
  // Mais peut contenir des std::array<> (alternative aux tableaux C) et des std::reference_wrapper<> (alternative aux références)
  - ```cpp std::variant``` _default-constructible_ seulement si le premier type l'est
  // Le std::variant contient alors le premier type initialisé par défaut
])

#noteblock(text[``` std::monostate```], text[
  - Permet d'émuler des ```cpp std::variant``` vides
  // Les ```cpp std::variant``` vides peuvent être utile dans le cas de code template
  - Rend un ```cpp std::variant``` _default constructible_
  // Si std::monostate est le premier élément du std::variant, celui-ci devient default-constructible
])

#adviceblock("Do", text[
  - Préférez ```cpp std::variant``` aux unions brutes
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

== ``` std::variant```

- ```cpp std::visit()``` permet l'appel sur le type réellement contenu

```cpp
vector<variant<int, string>> v{5, 10, "hello"};

for(auto item : v)
  visit([](auto&& arg){cout << arg;}, item);
```

#alertblock("Attention", text[
  - Appelable valide pour tous les types du ```cpp std::variant```
  // Et ce peut être une structure/classe présentant une surcharge de operator() pour chacun des types}
])

#noteblock("Alternative à C++17", text[
  - Utilisez ```cpp Boost.Variant```
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cvariant%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cstd::variant%3Cint,+std::string%3E%3E+v%7B5,+10,+%22hello%22%7D%3B%0A%0A++for(auto+item+:+v)%0A++%7B%0A++++std::visit(%5B%5D(auto%26%26+arg)%7Bstd::cout+%3C%3C+arg+%3C%3C+!'+!'%3B%7D,+item)%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

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

TODO

/*
\begin{center}
\begin{tikzpicture}[framed,background rectangle/.style={draw=black,fill=white,rounded corners,general shadow={fill=lightgray,shadow xshift= 4pt,shadow yshift=-4pt}}]
\coordinate (i) at (0,0);
\coordinate (o) at (4.5cm,0);
\coordinate (l) at (2.5cm,0);

\begin{scope}[sibling distance=12mm,level distance=6mm]
\node at (i) {:}
child {node {1}}
child {node {:}
child {node {2}}
child {node {:}
child {node {3}}
child {node {:}
child {node {4}}
child {node {[ ]}}
}
}
};

\node at (o)  {$f$}
child {node {1}}
child {node {$f$}
child {node {2}}
child {node {$f$}
child {node {3}}
child {node {$f$}
child {node {4}}
child {node {$z$}}
}
}
};
\end{scope}

\node at (l) {\textit{Right fold}};
\end{tikzpicture}
\\
\phantom{text}\\
\begin{tikzpicture}[framed,background rectangle/.style={draw=black,fill=white,rounded corners,general shadow={fill=lightgray,shadow xshift= 4pt,shadow yshift=-4pt}}]
\coordinate (i) at (0,0);
\coordinate (o) at (6.35cm,0);
\coordinate (l) at (2.5cm,0);

\begin{scope}[sibling distance=12mm,level distance=6mm]
\node at (i) {:}
child {node {1}}
child {node {:}
child {node {2}}
child {node {:}
child {node {3}}
child {node {:}
child {node {4}}
child {node {[ ]}}
}
}
};

\node at (o) {$f$}
child {node {$f$}
child {node {$f$}
child {node {$f$}
child {node {$z$}}
child {node {1}}
}
child {node {2}}
}
child {node {3}}
}
child {node {4}};
\end{scope}

\node at (l) {\textit{Left fold}};
\end{tikzpicture}
\end{center}
*/

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

== Fold expression

#alertblock(text[_left fold_ ou _right fold_ ?}], text[
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
  - ```cpp false``` pour l'opérateur ```cpp ```
  - ```cpp void()``` pour l'opérateur ```cpp ,```

#alertblock("Attention", text[
  - Un _parameter pack_ vide est une erreur pour les autres opérateurs
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
  - Casse du code C++11 valide
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
  \item Comportement différent d'un destructeur en présence d'exception
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
  - Ne permet pas la déduction partielle

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

- Construction de \textit{function object} en niant un appelable

```cpp
bool LessThan10(int a) { return a < 10; }

vector<int> foo = { 1, 6, 3, 8, 14, 42, 2 };
count_if(begin(foo), end(foo), not_fn(LessThan10)); // 2
```

#noteblock("Dépréciation", text[
  - Dépréciation de ```cpp std::not1``` et ```cpp std::not2```
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
  - Conversion implicite en ```cpp void``` pour supprimer l'avertissement

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
  - Ne pas nommer les paramètres non utilisés
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0A%23if+0%0A%5B%5B+maybe_unused+%5D%5D+static+int+foo(%5B%5B+maybe_unused+%5D%5Dint+a,%0A++++++++++++++++++++++++++++++++++%5B%5B+maybe_unused+%5D%5D+int+b)%0A%23else%0Astatic+int+foo(int+a,%0A+++++++++++++++int+b)%0A%23endif%0A%7B%0A++return+0%3B%0A%7D%0A%0Aint+main()%0A%7B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("P0212")

== Attributs C++17 - Conclusion

#adviceblock("Do", text[
  - Utilisez les attributs pour indiquer vos intentions
  // Au delà de l'information pour le compilateur et d'autres outils, c'est aussi une documentation à l'intention des lecteurs et correcteurs
])

#noteblock("Au delà du compilateur", text[
  - Prise en compte par d'autres outils souhaitable
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
  - Équivalent _non-timed_ de ```cpp std::shared_timed_mutex```
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

- ```cpp std::make_from_tuple()``` permet de construire un objet depuis un _tuple-like_

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
  - Ne peut pas contenir des références, des tableaux C, ```cpp void``` ni être vide
])

- Interface similaire à un pointeur
  - Testable via ```cpp operator bool()```
  - Accès à l'objet via ```cpp operator*```
  - Accès à un membre via ```cpp operator->```

#alertblock("Attention", text[
  - ```cpp operator*``` ou ```cpp operator->``` indéfini sur un ```cpp std::optional``` vide
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



== ``` std::optional```}

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
  - Utilisez des booléens "trois états" (```cpp Boost.tribool```)
  - Utilisez des pointeurs bruts
])

#adviceblock("Do", text[
  - Préférez ```cpp std::optional``` aux pointeurs bruts pour les données optionnelles
])

#noteblock("Alternative à C++17", text[
  - Utilisez ```cpp Boost.Optional```
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
  - Utilisez ```cpp Boost.Any```
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
  - Pas de ```cpp \0``` terminal systématique
  - La chaîne référencée doit vivre au moins aussi longtemps que la vue
])

#addproposal("N3921")
#addproposal("P0220")

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

#addproposal("N3921")
#addproposal("P0220")

== ``` std::string_view```

```cpp
string foo = "Lorem ipsum dolor sit amet";

string_view bar(&foo[0], 11);
cout << bar.size() << " - " << bar << '\n';  // 11 - Lorem ipsum

bar.remove_suffix(6);
cout << bar.size() << " - " << bar << '\n';  // 5 - Lorem
```

#adviceblock("Performances", text[
  - Souvent meilleures que les fonctionnalités équivalentes de ```cpp string```
  - Mais pas toujours, donc mesurez
])

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cstring%3E%0A%23include+%3Cstring_view%3E%0A%0Aint+main()%0A%7B%0A++%7B%0A++++std::string+foo+%3D+%22Lorem+ipsum+dolor+sit+amet,+consectetur+adipiscing+elit.+Sed+non+risus.%22%3B%0A%0A++++std::string_view+bar(%26foo%5B0%5D,+11)%3B%0A++++std::cout+%3C%3C+bar.size()+%3C%3C+%22+-+%22+%3C%3C+bar+%3C%3C+!'%5Cn!'%3B%0A%0A++++foo%5B0%5D+%3D+!'l!'%3B%0A++++std::cout+%3C%3C+bar.size()+%3C%3C+%22+-+%22+%3C%3C+bar+%3C%3C+!'%5Cn!'%3B%0A++++std::cout+%3C%3C+bar%5B0%5D+%3C%3C+!'%5Cn!'%3B%0A%0A++++bar.remove_suffix(6)%3B%0A++++std::cout+%3C%3C+bar.size()+%3C%3C+%22+-+%22+%3C%3C+bar+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0A++%7B%0A++++char+foo%5B3%5D+%3D+%7B!'B!',+!'a!',+!'r!'%7D%3B%0A++++std::string_view+bar(foo,+sizeof+foo)%3B%0A++++std::cout+%3C%3C+bar.size()+%3C%3C+%22+-+%22+%3C%3C+bar+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B17+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)

#addproposal("N3921")
#addproposal("P0220")

== Mémoire

- ```cpp std::shared_ptr``` et ```cpp std::weak_ptr``` sur des tableaux

```cpp
std::shared_ptr<int[]> foo(new int[10]);
```

#alertblock(text[Pas de ``` std::make_shared()```], text[
  - ```cpp std::make_shared()``` ne supporte pas les tableaux en C++17
])

- Évolutions des allocateurs
// Type-erased allocator, polymorphic allocator, {memory ressources
// Gestion de l'alignement des Over-Aligned Data
- Classe de gestion de pools de ressources (synchronisés ou non)

#noteblock("Note", text[
  - Pointeur intelligent sans responsabilité dans le TS ```cpp observer_ptr```
  - Mais pas dans le périmètre accepté pour C++17
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
  - Utilisez \textit{Filesystem} plutôt que les API C ou systèmes
])

#noteblock("Alternative à C++17", text[
  - Utilisez ```cpp Boost.Filesystem```
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
  \item Pas de gestion intrinsèque des accès concurrents
])

#addproposal("P0024")

== Parallelism TS

- ```cpp std::for_each_n()``` parcours un ensemble défini par l'itérateur de début et sa taille
// En soi, ce n'est pas lié au parallélisme mais cet algorithme apparait avec ce TS
- ```cpp std::reduce()``` "ajoute" tous les éléments de l'ensemble

#noteblock(text[``` std::reduce()``` ou ``` std::accumulate()``` ?], text[
  - Ordre des "additions" non spécifié dans le cas de ```cpp std::reduce()```
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
  - Transformation non appliquée à la graine
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
- Suppression des membres dépréciés de ```cpp std::reference_wrapper``` : ```cpp result_type```, ```cpp argument_type```, ```cpp first_argument_type``` et ```cpp second_argument_type```

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
  - Pilotage de ```cpp explicit``` via un paramètre booléen \textit{compile-time}
  - Possibilité de rendre des constructeurs templates explicites ou non en fonction de l'instanciation
  - Alternative à des constructions à base de macros de compilation ou de SFINAE

#addproposal("P0892")

== Types entiers

- Types entiers signés obligatoirement en compléments à 2

#noteblock("Situation pré-C++20", text[
  - Pas de contrainte en C++
  - 3 choix en C : signe + mantisse, complément à 1 et complément à 2
])

// Le même changement a eu lieu en C2x
// Complément à 1 : négation de tous les bits
// Complément à 2 : négation de tous les bits, puis ajout de 1

#alertblock("Compatibilité", text[
  - En pratique, toutes les implémentations actuelles sont en complément à 2
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
// Et les \textit{Universal character name} doivent correspondre à des code points ISO/IEC 10646
- ```cpp char8_t``` pour les caractères UTF-8
  - Pendant UTF-8 de ```cpp char16_t``` et ```cpp char32_t```
  - Similaire en taille, alignement et conversions à ```cpp unsigned char```
  - Pas un alias sur un autre type
  - Prise en compte dans la bibliothèque standard
- Type ```cpp u8string``` pour les chaînes UTF-8

#noteblock("Motivation", text[
  - Suppression de l'ambiguïté caractère UTF-8 / littéral
  - Suppression d'ambiguïté sur les surcharges et spécialisation de template
])

#addproposal("P0482")
#addproposal("P1041")

== Définition d'agrégat

- Modification de la définition d'agrégat :
  - C++17 : pas de constructeur \textit{user-provided}
  - C++20 : pas de constructeur \textit{user-declared}
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
  - Uniquement sur les agrégats et les unions
  - Initialisation des champs dans leur ordre de déclaration
  - Initialisation d'un unique membre d'une union

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
  - ```cpp {}``` permet l'utilisation d'_initializer list_
  - ```cpp ()``` permet les conversions avec perte de précision
])

#noteblock("Motivations", text[
  - Fonctions transférant les arguments à un constructeur sur des agrégats
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

#codesample("https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astruct+Foo%0A%7B%0A++unsigned+int+a+:+1+%7B0%7D%3B%0A++unsigned+int+b+:+1+%3D+1%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++Foo+foo%3B%0A++std::cout+%3C%3C+foo.a+%3C%3C+%22+%22+%3C%3C+foo.b+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4")

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

#codesample("https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Cbit%3E%0A%23include+%3Ciostream%3E%0A+%0Aint+main()%0A%7B%0A++if(std::endian::native+%3D%3D+std::endian::big)%0A++++std::cout+%3C%3C+%22big-endian%5Cn%22%3B%0A++else+if(std::endian::native+%3D%3D+std::endian::little)%0A++++std::cout+%3C%3C+%22little-endian%5Cn%22%3B%0A++else%0A++++std::cout+%3C%3C+%22mixed-endian%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4")

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

#codesample("https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Cbit%3E%0A%23include+%3Ciostream%3E%0A+%0Aenum+class+Foo%0A%7B%0A++val1,%0A++val2,%0A++val3,%0A%7D%3B%0A%0Ausing+Foo::val2%3B%0A%0Aint+main()%0A%7B%0A++Foo+foo+%3D+Foo::val2%3B%0A%0A++if(foo+%3D%3D+val2)%0A++%7B%0A++++std::cout+%3C%3C+%22val2%5Cn%22%3B%0A++%7D%0A%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4")

#codesample("https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Cbit%3E%0A%23include+%3Ciostream%3E%0A+%0Aenum+class+Foo%0A%7B%0A++val1,%0A++val2,%0A++val3,%0A%7D%3B%0A%0Ausing+enum+Foo%3B%0A%0Aint+main()%0A%7B%0A++Foo+foo+%3D+Foo::val2%3B%0A%0A++if(foo+%3D%3D+val2)%0A++%7B%0A++++std::cout+%3C%3C+%22val2%5Cn%22%3B%0A++%7D%0A%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4")

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

#codesample("https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Cbit%3E%0A%23include+%3Ciostream%3E%0A%0Astruct+Foo%0A%7B%0A++int+i%3B%0A++bool+b%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++void*+p+%3D+nullptr%3B%0A%0A%23if+0%0A++Foo+foo%7B1,+p%7D%3B%0A%23endif%0A%23if+0%0A++bool+b1%7Bp%7D%3B%0A%23endif%0A++bool+b2+%3D+p%3B%0A++bool+b3%7Bnullptr%7D%3B%0A%23if+0%0A++bool+b4+%3D+nullptr%3B%0A%23endif%0A%23if+0%0A++bool+b5+%3D+%7Bnullptr%7D%3B%0A%23endif%0A++if(p)+%7B+%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic+-Wno-unused-variable',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4")

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
  - Une unique version à écrire (```cpp A<=>B``` ou ```cpp B<=>A```)
])

#addproposal("P1185")
#addproposal("P1186")
#addproposal("P0768")

== spaceship operator -- ``` operator<=>```

- Peut être déclaré ```cpp =default``` et généré par
  - ```cpp operator<=>``` des bases et membres
  - ```cpp operator==``` et ```cpp operator<```

#alertblock("Attention", text[
  - Uniquement pour des comparaisons homogènes
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
  - Pas de génération depuis ```cpp operator<=>```
  // Initialement, operator== et operator!= aussi résolu via operator<=>. Modifié pour ne pas avoir des tests d'égalité non optimaux "par erreur" via le fallback sur operator<=> (p.ex. court-circuit sur la taille de conteneurs)
])

#adviceblock(text[``` =default``` implicite], text[
  - Implicitement ```cpp =default``` lorsque ```cpp operator<=>``` est ```cpp =default```
])

#codesample("https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ccompare%3E%0A%23include+%3Ciostream%3E%0A%0Astruct+Foo%0A%7B%0A++int+value%3B%0A%0A%23if+1%0A++auto+operator%3C%3D%3E(const+Foo%26+rhs)+const%0A++%7B%0A++++return+value+%3C%3D%3E+rhs.value%3B%0A++%7D%0A%23else%0A++auto+operator%3C%3D%3E(const+Foo%26+rhs)+const+%3D+default%3B%0A%23endif%0A%0A%23if+0%0A++bool+operator%3D%3D(const+Foo%26+rhs)+const+%3D+default%3B%0A%23endif%0A%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++Foo+foo1%7B2011%7D%3B%0A++Foo+foo2%7B2014%7D%3B%0A%0A++std::cout+%3C%3C+std::boolalpha%3B%0A++std::cout+%3C%3C+(foo1+%3C+foo2)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+(foo1+%3E+foo2)+%3C%3C+%22%5Cn%22%3B%0A%23if+0%0A++std::cout+%3C%3C+(foo1+%3D%3D+foo2)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+(foo1+!!%3D+foo2)+%3C%3C+%22%5Cn%22%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4")

#addproposal("P1185")
#addproposal("P1186")
#addproposal("P0768")

== spaceship operator -- Conclusion

#adviceblock("Do", text[
  - Privilégiez ```cpp operator<=>``` aux opérateurs ```cpp <```, ```cpp <=```, ```cpp >``` et ```cpp >=```
  - Déclarez ```cpp operator<=>``` et ```cpp operator==``` ```cpp =default``` si possible
])

#alertblock("Don't", text[
  - Ne mélangez pas ```cpp operator<=>``` et opérateurs d'ordre dans une même classe
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

#codesample("https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Anamespace+A::inline+B::C%0A%7B%0A++int+i+%3D+5%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+A::B::C::i+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+A::C::i+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4")

#addproposal("P1094")

// !!!!!!!!!!!!!!!!!!!!!!!!!!
== Modules -- Présentation}
\begin{itemize}
// Fusion du TS de mai 2018 et de la proposition concurrente de Clang (ATOM)}

\item Alternative au mécanisme d'inclusion
\end{itemize}

#alertblock{Modules et ``` namespace```}
\begin{itemize}
\item Ne replace pas les ```cpp namespace```
\end{itemize}
\end{alertblock}

\begin{itemize}
\item [] \begin{itemize}
\item Réduction des temps de compilation
\item Nouveau niveau d'encapsulation
\item Plus grande robustesse (isolation des effets des macros)
\item Meilleurs prises en charge des bibliothèques par l'analyse statique, les optimiseurs, ...
\item Gestion des inclusions multiples sans garde
\item Compatible avec le système actuel d'inclusion
\end{itemize}
\end{itemize}

#alertblock{Bibliothèque standard}
\begin{itemize}
\item En C++20, la bibliothèque standard n'utilise pas les modules
\end{itemize}
\end{alertblock}

#addproposal{P1103}{https://wg21.link/P1103}



== Modules -- Interface Unit}
\begin{itemize}
\item L'\textit{Interface Unit} commence par un préambule
\begin{itemize}
\item Nom du module à exporter
\item Suivi de l'import d'autres modules
\item Éventuellement ré-exportés par le module
\end{itemize}
\end{itemize}

```cpp
		export module foo;
		import a;
		export import b;
```

\begin{itemize}
\item Suivi du corps exportant des symboles via le mot-clé ```cpp export```
\end{itemize}

// Les symboles "internal linkage" ne sont bien entendu pas exportables}

```cpp
		export int i;
		export void bar(int j);
		export {
		  void baz();
		  long l;
		}
```

#addproposal{P1103}{https://wg21.link/P1103}



== Modules -- Implementation Unit}
\begin{itemize}
\item L'\textit{Implementation Unit} commence par un préambule
\begin{itemize}
\item Nom du module implémenté
\item Suivi de l'import d'autres modules
\end{itemize}
\item Suivi du corps contenant les détails d'implémentation
\end{itemize}

```cpp
		module foo;
		void bar(int j) { return 3 * j; }
```

#noteblock{Note}
\begin{itemize}
\item \textit{Implementation Unit} a accès aux déclarations non exportées du module
\end{itemize}

// Les déclarations non exportées sont visibles de l'ensemble du module}
\end{block}

#alertblock{Mais ...}
\begin{itemize}
\item Mais pas les autres unités de compilation même si elles importent le module
\end{itemize}
\end{alertblock}

#addproposal{P1103}{https://wg21.link/P1103}



== Modules -- Partitions}
\begin{itemize}
\item Les modules peuvent être partitionnés sur plusieurs unités
\item Les partitions fournissent alors un nom de partition
\end{itemize}

```cpp
		// Interface Unit
		export module foo:part;
```

```cpp
		// Implementation Unit
		module foo:part;
```

#alertblock{\textit{Primary Module Interface Unit}}
\begin{itemize}
\item Une et une seule \textit{Interface Unit} sans nom de partition par module
\end{itemize}
\end{alertblock}

\begin{itemize}
\item Un élément peut être déclaré dans une partition et défini dans une autre
\end{itemize}

#addproposal{P1103}{https://wg21.link/P1103}



== Modules -- Partitions}
\begin{itemize}
\item Les partitions sont un détail d'implémentation non visibles hors du module

// Concrètement, hors du module on importe le module dans son ensemble}

\item Une partition peut être importée dans une \textit{Implementation Unit}
\item ... en important uniquement le nom de la partition
\end{itemize}

```cpp
		module foo;
		import :part;     // Importe foo:part
		import foo:part;  // Erreur
```

\begin{itemize}
\item Le \textit{Primary Module Interface Unit} peut exporter les partitions
\end{itemize}

```cpp
		export module foo;
		export :part1;
		export :part2;
```

#addproposal{P1103}{https://wg21.link/P1103}



== Modules -- Export de namespace}
\begin{itemize}
\item Un namespace est exporté s'il est déclaré ```cpp export```
\item ... ou implicitement si un de ses éléments est exporté
\end{itemize}

```cpp
		export namespace A {  // A est exporte
		  int n;              // A::n est exporte
		}

		namespace B {
		  export int n;       // B::n et B sont exportes
		  int m;              // B::m n'est pas exporte
		}
```

#addproposal{P1103}{https://wg21.link/P1103}



== Modules -- Export de namespace}
\begin{itemize}
\item Les éléments d'une partie exportée d'un namespace sont exportés
\end{itemize}

```cpp
		namespace C { int n; }         // C::m est exporte

		export namespace C { int m; }  // mais pas C::n
```

#addproposal{P1103}{https://wg21.link/P1103}



== Modules -- Implémentation inline}
\begin{itemize}
\item Interface et implémentation dans un unique fichier
\item Implémentation dans un fragment ```cpp private```
\end{itemize}

```cpp
		export module m;
		struct s;
		export using s_ptr = s*;

		module :private;
		struct s {};
```

#alertblock{Restriction}
\begin{itemize}
\item Uniquement dans une \textit{Primary Module Interface Unit}
\item Qui doit être la seule unité du module
\end{itemize}
\end{alertblock}

#addproposal{P1103}{https://wg21.link/P1103}



== Modules -- Utilisation}
\begin{itemize}
\item Import des modules via la directive ```cpp import```
\end{itemize}

```cpp
		import foo;

		// Utilisation des symboles exportes de foo
```

\begin{itemize}
\item Cohabitation possible avec des inclusions
\end{itemize}

```cpp
		#include <vector>
		import foo;
		#include "bar.h"
```

#addproposal{P1103}{https://wg21.link/P1103}



== Modules -- Code non-modulaire}
\begin{itemize}
\item Inclusion d'en-têtes avant le préambule du module
\end{itemize}

// Seules des directives ```cpp include``` peuvent apparaître}

```cpp
		module;
		#include "bar.h"
		export module foo;
```

\begin{itemize}
\item Ou import des en-têtes
\end{itemize}

```cpp
		export module foo;
		import "bar.h";
		import <version>;
```

#addproposal{P1103}{https://wg21.link/P1103}



== Modules -- Code non-modulaire}
\begin{itemize}
\item Export possible des symboles inclus
\end{itemize}

```cpp
		module;
		#include "bar.h" // Definit X
		export module foo;
		export using X = ::X;
```

\begin{itemize}
\item Ou de l'en-tête dans son ensemble
\end{itemize}

```cpp
		export module foo;
		export import "bar.h";
```

#addproposal{P1103}{https://wg21.link/P1103}

== Chaînes de caractères}
\begin{itemize}
\item ```cpp std::basic_string::reserve()``` ne peut plus réduire la capacité
\begin{itemize}
\item Appel avec une capacité inférieure sans effet

// Auparavant, la norme permettait de réduire effectivement la capacité mais ne l'imposait pas (idem ```cpp shrink_to_fit()```)}
// Si la capacité demandée était inférieur à la taille effective, cet appel était équivalent à un appel à ```cpp shrink_to_fit()```}

\item Comportement similaire à ```cpp std::vector::reserve()```
\end{itemize}
\end{itemize}

#noteblock{Rappel}
\begin{itemize}
\item Après ```cpp reserve()```, la capacité est supérieure ou égale à la capacité demandée
\end{itemize}
\end{block}

\begin{itemize}
\item Dépréciation de ```cpp reserve()``` sans paramètre
\end{itemize}

#adviceblock{Réduction à la capacité utile}
\begin{itemize}
\item Utilisez ```cpp shrink_to_fit()``` et non ```cpp reserve()```
\end{itemize}
\end{exampleblock}

#addproposal{P0966}{https://wg21.link/P0966}



== Chaînes de caractères}
\begin{itemize}
\item Ajout à ```cpp std::basic_string``` et ```cpp std::string_view```
\begin{itemize}
\item ```cpp starts_with()``` teste si la chaîne commence par une sous-chaîne
\item ```cpp ends_with()``` teste si la chaîne termine par une sous-chaîne
\end{itemize}
\end{itemize}

```cpp
		string foo = "Hello world";

		foo.starts_with("Hello");   // true
		foo.ends_with("monde");     // false
```

\begin{itemize}
\item ```cpp std::string_view``` constructible depuis une paire d'itérateurs
\end{itemize}


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Cstring%3E%0A%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++std::string+foo+%3D+%22Hello+world%22%3B%0A%0A++std::cout+%3C%3C+std::boolalpha%3B%0A++std::cout+%3C%3C+foo.starts_with(%22Hello%22)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+foo.ends_with(%22monde%22)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0457}{https://wg21.link/P0457}



== Conteneurs associatifs}
\begin{itemize}
\item ```cpp contains()``` teste la présence d'une clé
\end{itemize}

```cpp
		map<int, string> foo{{1, "foo"}, {42, "bar"}};

		foo.contains(42);  // true
		foo.contains(38);  // false
```


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Cmap%3E%0A%23include+%3Cstring%3E%0A%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++std::map%3Cint,+std::string%3E+foo%7B%7B1,+%22foo%22%7D,+%7B42,+%22bar%22%7D%7D%3B%0A%0A++std::cout+%3C%3C+std::boolalpha%3B%0A++std::cout+%3C%3C+foo.contains(42)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+foo.contains(38)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0458}{https://wg21.link/P0458}



== Conteneurs associatifs}
\begin{itemize}
\item Optimisation de la recherche hétérogène dans des conteneurs non-ordonnés
\begin{itemize}
\item Fourniture d'une classe exposant
\begin{itemize}
\item Différents foncteurs de calcul du hash
\item Tag ```cpp transparent_key_equal``` sur une comparaison transparente
\end{itemize}
\item Suppression de conversions inutiles
\end{itemize}
\end{itemize}

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

#addproposal{P0919}{https://wg21.link/P0919}
#addproposal{P1690}{https://wg21.link/P1690}



== ``` std::list``` et ``` forward_list```}
\begin{itemize}
\item ```cpp remove()```, ```cpp remove_if()``` et ```cpp unique()``` retournent le nombre d'éléments supprimés
\end{itemize}


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Calgorithm%3E%0A%23include+%3Clist%3E%0A%0Aint+main()%0A%7B%0A++std::list%3Cint%3E+foo%7B1,+5,+12,+8,+13%7D%3B%0A%0A++std::cout+%3C%3C+foo.remove_if(%5B%5D+(int+i)+%7B+return+i+%3E+10%3B+%7D)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0646}{https://wg21.link/P0646}



== ``` std::array```}
\begin{itemize}
\item ```cpp std::to_array()``` construit un ```cpp std::array``` depuis un tableau C
\end{itemize}

```cpp
		auto foo = to_array({1, 2, 5, 42});

		long foo[] = {1, 2, 5, 42};
		auto bar = to_array(foo);

		auto foo = to_array<long>({1, 2, 5, 42});
```

\begin{itemize}
\item Y compris une chaîne C
\end{itemize}

```cpp
		auto foo = to_array("foo");
```

#alertblock{``` 0``` terminal}
\begin{itemize}
\item Le ``` \0``` terminal est un élément du tableau
\end{itemize}
\end{alertblock}


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Carray%3E%0A%0Aint+main()%0A%7B%0A++auto+foo+%3D+std::to_array(%22foo%22)%3B%0A++std::cout+%3C%3C+foo.size()+%3C%3C+%22%5Cn%22%3B%0A++for(const+auto+c+:+foo)%0A++%7B%0A++++std::cout+%3C%3C+c+%3C%3C+%22+%22%3B%0A++%7D%0A++std::cout+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Carray%3E%0A%0Aint+main()%0A%7B%0A++%7B%0A++++auto+foo+%3D+std::to_array(%7B1,+2,+5,+42,+58%7D)%3B%0A++++std::cout+%3C%3C+foo.size()+%3C%3C+%22%5Cn%22%3B%0A++++for(const+auto+c+:+foo)%0A++++%7B%0A++++++std::cout+%3C%3C+c+%3C%3C+%22+%22%3B%0A++++%7D%0A++++std::cout+%3C%3C+%22%5Cn%22%3B%0A++%7D%0A%0A++%7B%0A++++long+foo%5B%5D+%3D+%7B1,+2,+5,+42,+33,+12%7D%3B%0A++++auto+bar+%3D+std::to_array(foo)%3B%0A++++std::cout+%3C%3C+bar.size()+%3C%3C+%22%5Cn%22%3B%0A++++for(const+auto+c+:+bar)%0A++++%7B%0A++++++std::cout+%3C%3C+c+%3C%3C+%22+%22%3B%0A++++%7D%0A++++std::cout+%3C%3C+%22%5Cn%22%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'0',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0325}{https://wg21.link/P0325}



== Suppression d'éléments}
\begin{itemize}
\item ```cpp std::erase()``` supprime les éléments égaux à la valeur fournie
\item ```cpp std::erase_if()``` supprime les éléments satisfaisant le prédicat fourni
\end{itemize}

```cpp
		vector<int> foo {5, 12, 2, 56, 18, 33};

		erase_if(foo, [](int i) { return i > 20; }); // 5 12 2 18
```

\begin{itemize}
\item Remplacement de l'idiome "\textit{Erase-remove}"
\item Remplacement de la fonction membre ```cpp erase()```
\end{itemize}


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:26,positionColumn:1,positionLineNumber:26,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Cvector%3E%0A%23include+%3Cmap%3E%0A%23include+%3Cstring%3E%0A%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo+%7B5,+12,+2,+56,+18,+33%7D%3B%0A++std::erase_if(foo,+%5B%5D(int+i)+%7Breturn+i+%3E+20%3B%7D)%3B%0A%0A++for(int+i+:+foo)%0A++%7B%0A++++std::cout+%3C%3C+i+%3C%3C+%22+%22%3B%0A++%7D%0A++std::cout+%3C%3C+%22%5Cn%22%3B%0A%0A++std::map%3Cint,+std::string%3E+bar%7B%7B5,+%22a%22%7D,+%7B12,+%22b%22%7D,+%7B2,+%22c%22%7D,+%7B42,+%22d%22%7D%7D%3B%0A++std::erase_if(bar,+%5B%5D(std::pair%3Cint,+std::string%3E+i)+%7Breturn+i.first+%3E+20%3B%7D)%3B%0A%0A++for(auto+i+:+bar)%0A++%7B%0A++++std::cout+%3C%3C+i.first+%3C%3C+%22+:+%22+%3C%3C+i.second+%3C%3C+%22+%22%3B%0A++%7D%0A++std::cout+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P1209}{https://wg21.link/P1209}
#addproposal{P1115}{https://wg21.link/P1115}



== ``` std::span```}
\begin{itemize}
\item Vue sur un conteneur contigu
\item Similaire à ```cpp std::string_view```
\item Constructible depuis
\begin{itemize}
\item Conteneur
\item Couple début / taille
\item Couple début / fin
\item Range
\item Autre ```cpp std::span```
\end{itemize}
\end{itemize}

```cpp
		array<int, 5> foo = {0, 1, 2, 3, 4};
		span<int> s1{foo};
		span<int> s2(foo.data(), 3);
```

#addproposal{P0122}{https://wg21.link/P0122}
#addproposal{P1024}{https://wg21.link/P1024}
#addproposal{P1227}{https://wg21.link/P1227}



== ``` std::span```}
\begin{itemize}
\item ```cpp begin()```, ```cpp end()```, ... : itérateurs sur le ```cpp std::span```
\item ```cpp size()```, ```cpp empty()``` : taille et vacuité
\item ```cpp operator[]```, ```cpp front()```, ```cpp back()``` : accès à un élément
\end{itemize}

```cpp
		array<int, 5> foo = {0, 1, 2, 3, 4};
		span<int> bar{ foo.data(), 4 };

		bar.front();  // 0
```

\begin{itemize}
\item ```cpp first()```, ```cpp last()``` : construction de \textit{sous-span}
\end{itemize}

```cpp
		span<int> baz = bar.first(2);  // 0, 1
```

\begin{itemize}
\item \textit{structured binding} sur des ```cpp std::span``` de taille fixe
\end{itemize}


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Carray%3E%0A%23include+%3Cspan%3E%0A%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++std::array%3Cint,+5%3E+foo+%3D+%7B7,+12,+28,+3,+9%7D%3B%0A++std::span%3Cint%3E+bar(foo.data(),+3)%3B%0A%0A++std::cout+%3C%3C+bar.size()+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+bar.front()+%3C%3C+%22%5Cn%22%3B+%0A++std::cout+%3C%3C+bar%5B2%5D+%3C%3C+%22%5Cn%22%3B+%0A%0A++std::span%3Cint%3E+baz+%3D+bar.first(2)%3B%0A++for(const+auto+i+:+baz)%0A++%7B%0A++++std::cout+%3C%3C+i+%3C%3C+%22+%22%3B%0A++%7D%0A++std::cout+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0122}{https://wg21.link/P0122}
#addproposal{P1024}{https://wg21.link/P1024}
#addproposal{P1227}{https://wg21.link/P1227}

== Décalages d'éléments}
\begin{itemize}
\item ```cpp std::shift_left()``` décale les éléments vers le début de l'ensemble
\item ```cpp std::shift_right()``` décale les éléments vers la fin de l'ensemble
\item ... retournent un itérateur vers la fin (resp. début) du nouvel ensemble
\end{itemize}

#noteblock{Taille et décalage}
\begin{itemize}
\item Opération sans effet si le décalage est supérieur la taille de l'ensemble
\end{itemize}
\end{block}

```cpp
		vector<int> foo{5, 10, 15, 20};
		shift_left(foo.begin(), foo.end(), 2);   // 15, 20

		vector<int> bar{5, 10, 15, 20};
		shift_right(bar.begin(), bar.end(), 1);  // 5, 10, 15
```


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B5,+10,+15,+20%7D%3B%0A++std::shift_left(foo.begin(),+foo.end(),+2)%3B%0A++//+%7B15,+20,+%3F,+%3F%7D%0A++for(int+i+:+foo)%0A++%7B%0A++++std::cout+%3C%3C+i+%3C%3C+%22+%22%3B%0A++%7D%0A++std::cout+%3C%3C+%22%5Cn%22%3B%0A%0A++std::vector%3Cint%3E+bar%7B5,+10,+15,+20%7D%3B%0A++std::shift_right(bar.begin(),+bar.end(),+1)%3B%0A++//+%7B%3F,+5,+10,+15%7D%0A++for(int+i+:+bar)%0A++%7B%0A++++std::cout+%3C%3C+i+%3C%3C+%22+%22%3B%0A++%7D%0A++std::cout+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0769}{https://wg21.link/P0769}



== Manipulation de puissances de deux}
\begin{itemize}
\item ```cpp std::has_single_bit()``` teste si un entier est une puissance de deux
\item ```cpp std::bit_ceil()``` plus petite puissance de deux non strictement inférieure
\item ```cpp std::bit_floor()``` plus grande puissance de deux non strictement supérieure
\item ```cpp std::bit_width()``` plus petit nombre de bits pour représenter un entier
\end{itemize}

```cpp
		has_single_bit(4u);  // true
		has_single_bit(7u);  // false
		bit_ceil(7u);        // 8
		bit_ceil(8u);        // 8
		bit_floor(7u);       // 4
		bit_width(7u);       // 3
```

#alertblock{Restriction}
\begin{itemize}
\item Uniquement sur des entiers non signés
\end{itemize}
\end{alertblock}


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cbit%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::has_single_bit(4u)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::has_single_bit(7u)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::bit_ceil(7u)++%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::bit_ceil(8u)++%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::bit_floor(7u)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::bit_width(7u)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0556}{https://wg21.link/P0556}
#addproposal{P1956}{https://wg21.link/P1956}



== Manipulation binaire}
\begin{itemize}
\item ```cpp std::rotl()``` et ```cpp std::rotr()``` rotations binaires
\item ```cpp std::countl_zero``` nombre consécutif de bits à zéro depuis le plus significatif
\item ```cpp std::countl_one``` nombre consécutif de bits à un depuis le plus significatif
\item ```cpp std::countr_zero``` nombre consécutif de bits à zéro depuis le moins significatif
\item ```cpp std::countr_one``` nombre consécutif de bits à un depuis le moins significatif
\item ```cpp std::popcount``` nombre de bit à un
\end{itemize}

```cpp
		rotl(6u, 2);   // 24
		rotr(6u, 1);   // 3
		popcount(6u);  // 2
```

#alertblock{Restriction}
\begin{itemize}
\item Uniquement sur des entiers non signés
\end{itemize}
\end{alertblock}


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cbit%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::rotl(6u,+2)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::rotr(6u,+1)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::popcount(6u)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0553}{https://wg21.link/P0553}



== Conversion binaire}
\begin{itemize}
\item ```cpp std::bit_cast``` ré-interprète une représentation binaire en un autre type
\begin{itemize}
\item Conversion bit-à-bit
\item Alternative plus sûre à ```cpp reinterpret_cast``` ou ```cpp memcpy()```
\item Conversion ```cpp constexpr``` si possible
\end{itemize}
\end{itemize}

#alertblock{Restriction}
\begin{itemize}
\item Uniquement sur des types \textit{trivially copyable}
\end{itemize}
\end{alertblock}

#addproposal{P0476}{https://wg21.link/P0476}



== Comparaison d'entiers}
\begin{itemize}
\item Ajout de fonctions de comparaison d'entier : ```cpp std::cmp_equal()```, ```cpp std::cmp_not_equal()```, ```cpp std::cmp_less()```, ```cpp std::cmp_greated()```, ```cpp std::cmp_less_equal()``` et ```cpp std::cmp_greater_equal()```
\item Permettent la comparaison signé / non signé sans promotion
\end{itemize}


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cutility%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::boolalpha%3B%0A++std::cout+%3C%3C+(-1+%3E+1U)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::cmp_greater(-1,+1U)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0586}{https://wg21.link/P0586}



== Mathématiques}
\begin{itemize}
//	\item Définition des constantes mathématiques $e$, $\log_2 e$, $\log_{10} e$, $\pi$, $\dfrac{1}{\pi}$, $\dfrac{1}{\sqrt{\pi}}$, $\ln{2}$, $\ln{10}$, $\sqrt{2}$, $\sqrt{3}$, $\dfrac{1}{\sqrt{3}}$, $\gamma$, $\varphi$

// $\gamma$ est la constante de Euler-Mascheroni et $\varphi$ le nombre d'or}

\item ```cpp std::midpoint()``` : demi-somme de deux valeurs (entières ou flottantes)
\end{itemize}

#noteblock{Règle d'arrondi}
\begin{itemize}
\item La demi-somme d'entiers est entière et arrondie vers le premier paramètre
\end{itemize}

```cpp
		midpoint(2, 4);  // 3
		midpoint(2, 5);  // 3
		midpoint(5, 2);  // 4
```
\end{block}


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cnumeric%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::midpoint(2,+4)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::midpoint(2,+5)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::midpoint(5,+2)+%3C%3C+%22%5Cn%22%3B+%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0631}{https://wg21.link/P0631}
#addproposal{P0811}{https://wg21.link/P0811}



\frametitle{Mathématiques}
\begin{itemize}
\item ```cpp std::lerp()``` : interpolation linéaire entre deux valeurs flottantes
\end{itemize}

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


#codesample{https://godbolt.org/#z:OYLghAFBqd5QCxAYwPYBMCmBRdBLAF1QCcAaPECAMzwBtMA7AQwFtMQByARg9KtQYEAysib0QXACx8BBAKoBnTAAUAHpwAMvAFYTStJg1DIApACYAQuYukl9ZATwDKjdAGFUtAK4sGe1wAyeAyYAHI%2BAEaYxHoADqgKhE4MHt6%2BcQlJAkEh4SxRMVy2mPaOAkIETMQEqT5%2BRXaYDskVVQQ5YZHRegqV1bXpDX3twZ353VwAlLaoXsTI7BzmAMzByN5YANQmy25OvcSYrDvYJhoAgitrG5jbu8gsTAQIJ2eXF8EEm4/BEJNvJgA7FYLptNr10CAULMvjs3HDwQRISB6MRYhAuBpSJszFjNhpJnd4bttmYzCYAKxuBjmcnLEHnMEQqFoLyw3YI5ko6LozHY3HYjQAOimRIRtMp1Il9LeTKRLJhYpJXNRvLxAvxQrMhLh4rJkpp%2BploMRyNZ7OJblNUNVGPVeOFyx1HJJEqphrpDLlZsVuuV8u5aLt/IdQskzstpPJ7ulXut0LZSqtKp5wZxoYpEb10alRrjXPNSfjtr56cFQoAbFnXfqY3nZfHC37kwGS/by4Dq1a3bnPQ2C76XS3kW2Q%2BWABxdqMG2P9gNNofF1OljXCgCcU57Hp2%2Bfng8jKaDK7xoub07rfYuQIAIm8ONNaJwKbw/BwtKRUJx4ZZrODZvNbhWHhSAITR72mABrEAKSxR8OEkF8wI/TheAUEAsVAt971IOBYCQTBVCaNkSHISgqmABRlEMEohAQVAAHdX2AtAWFiOgnmSKiQloWiGNfd8WLY1EQAo5hYgUOiCFIQS6GiUJWEWXgZNRAB5NleMYpCCKac5iAolDSG05AKnwV9eH4QQRDEdgpBkQRFBUdQsNIXQigMIwUGsax9DwCI0MgaZUFiMoGDQjgAFoIR2a9TB/SxcU2cKAHUxFoRKkoIghiCYRLYkwdBDEcZBeFQAA3aJiDwLB/L%2BUhiC8QQ8DYAAVVBPBq6YFH/BYeiRYIuJoujNO4XgsswRZgPo7LYjAh8n0Q5zPw4bBCOQYjiE2VRxwrcKK0kTZgGQZBNggLKGogwkIG/KxLGxXBCBIUllimUbZumBAjiwGJaqgmD9E4BDSH4kqDLQjC3v%2BjgzAW98lterDJmmcriESZxJCAA%3D}


#addproposal{P0811}{https://wg21.link/P0811}



== Évolutions de la bibliothèque standard}
\begin{itemize}
\item Utilisation de l'attribut ```cpp [[ nodiscard ]]```
\item Davantage de ```cpp noexcept```
\item Optimisation d'algorithmes numériques via ```cpp std::move()```
\end{itemize}


== Ranges -- Présentation}
\begin{itemize}
\item Abstraction de plus haut niveau que les itérateurs
\item Manipulation d'ensemble au travers d'algorithmes et de \textit{range adaptators}
\item Vivent dans le ```cpp namespace std::ranges```

// Pour être précis, les \textit{range adaptors} manipulent seulement les \textit{viewable ranges}}
\end{itemize}

#noteblock{Pour aller plus loin}
\begin{itemize}
\item #link{https://accu.org/content/conf2009/AndreiAlexandrescu_iterators-must-go.pdf}{Iterators Must Go#linklogo() (Andrei Alexandrescu)}
\item #link{http://ericniebler.com/}{Blog d'Eric Niebler#linklogo()}
\end{itemize}
\end{block}

#addproposal{P0896}{https://wg21.link/P0896}
#addproposal{P1035}{https://wg21.link/P1035}



== Ranges -- Concepts}
\begin{itemize}
\item ```cpp Range``` : séquence d'éléments définie par
\begin{itemize}
\item Itérateur de début
\item Sentinelle de fin
\begin{itemize}
\item Itérateur
\item Valeur particulière
\item ```cpp std::default_sentinel_t``` : itérateurs gérant la limite du range

// ```cpp std::default_sentinel_t``` utilisable avec ```cpp std::counted_iterator```}
// Appelé \textit{counted range}, range représenté par un itérateur de début et un nombre d'éléments}
\end{itemize}
\end{itemize}

\item Conteneur : range possédant ses éléments
\item ```cpp View```
\begin{itemize}
\item range ne possédant pas les éléments
\item Copie, déplacement et affectation en temps constant
\end{itemize}
\item ```cpp SizedRange``` : taille en temps constant
\item ```cpp ViewableRange``` : range convertible en une vue
\item ```cpp CommonRange``` : itérateur et sentinelle de même type
\end{itemize}

#addproposal{P0896}{https://wg21.link/P0896}
#addproposal{P1035}{https://wg21.link/P1035}



== Ranges -- Concepts}
\begin{itemize}
\item ```cpp InputRange``` : fournit des ```cpp input_iterator```
\item ```cpp OutputRange``` : fournit des ```cpp output_iterator```
\item ```cpp ForwardRange``` : fournit ```cpp forward_iterator```
\item ```cpp BidirectionalRange``` : fournit ```cpp bidirectional_iterator```
\item ```cpp RandomAccessRange``` : fournit ```cpp random_access_iterator```
\item ```cpp ContiguousRange``` : fournit ```cpp contiguous_iterator```
\end{itemize}

#noteblock{En résumé}
\begin{itemize}
\item Conteneurs : possession, copie profonde
\item Vues : référence, copie superficielle
\end{itemize}
\end{block}

#addproposal{P0896}{https://wg21.link/P0896}
#addproposal{P1035}{https://wg21.link/P1035}



== Ranges -- Itérateurs}
\begin{itemize}
\item ```cpp std::common_iterator``` : adaptateur d'itérateurs/sentinelles permettant de représenter un \textit{non-common} ```cpp range``` comme un ```cpp CommonRange```

// Passe de itérateur/sentinelle de types différents à itérateur/sentinelle de même type}
// Grâce à l'opérateur de comparaison adéquate}

\item ```cpp std::counted_iterator``` : adaptateur d'itérateurs reprenant le fonctionnement de l'itérateur sous-jacent mais conservant la distance à la fin du ```cpp range```
\end{itemize}

#addproposal{P0896}{https://wg21.link/P0896}
#addproposal{P1035}{https://wg21.link/P1035}



== Ranges -- Opérations}
\begin{itemize}
\item ```cpp begin()```, ```cpp end()```, ```cpp cbegin()```, ```cpp cend()```, ... retournent itérateurs et sentinelles
\item ```cpp size()``` retourne la taille du ```cpp range```
\item ```cpp empty()``` teste la vacuité
\item ```cpp data()``` et ```cpp cdata()``` retournent l'adresse de début du ```cpp range```
\end{itemize}

#alertblock{Restrictions}
\begin{itemize}
\item ```cpp data()``` et ```cpp cdata()``` uniquement sur des ```cpp ContiguousRange```
\end{itemize}
\end{alertblock}

\begin{itemize}
\item Surcharges de différents algorithmes prenant un ```cpp range``` en paramètre
\end{itemize}

#addproposal{P0896}{https://wg21.link/P0896}
#addproposal{P1035}{https://wg21.link/P1035}



== Ranges -- Factory}
\begin{itemize}
\item ```cpp std::views::empty``` crée une vue vide
\item ```cpp std::views::single``` crée une vue sur un unique élément
\item ```cpp std::views::iota``` crée une vue en incrémentant une valeur initiale
\end{itemize}

```cpp
for(int i : iota(1, 10))
  cout << i << ' ';   // 1 2 3 4 5 6 7 8 9
```

\begin{itemize}
\item ```cpp std::views::counted``` crée un vue depuis un itérateur et un nombre d'éléments
\end{itemize}

```cpp
int a[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
counted(a, 3);   // 1 2 3
```


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Cranges%3E%0A%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++int+a%5B%5D+%3D+%7B1,+2,+3,+4,+5,+6,+7,+8,+9,+10%7D%3B%0A++for(int+i+:+std::views::counted(a,+3))%0A++%7B%0A++++std::cout+%3C%3C+i+%3C%3C+!'+!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Cranges%3E%0A%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++for(int+i+:+std::views::iota(1,+10))%0A++%7B%0A++++std::cout+%3C%3C+i+%3C%3C+!'+!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0896}{https://wg21.link/P0896}
#addproposal{P1035}{https://wg21.link/P1035}



== Ranges -- Factory}
\begin{itemize}
\item ```cpp std::ranges::istream_view``` créé une vue sur un un flux d'entrée
\item ```cpp std::ranges::subrange()``` construit un sous-range depuis
\begin{itemize}
\item Une paire d'itérateur
\item Un itérateur de début et une sentinelle de fin
\end{itemize}
\end{itemize}

```cpp
		vector<int> vec{1, 2, 3, 4, 5, 6, 7, 8, 9};
		subrange(begin(vec), begin(vec) + 3);   // 1 2 3
```


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:73,endLineNumber:8,positionColumn:73,positionLineNumber:8,selectionStartColumn:3,selectionStartLineNumber:7,startColumn:3,startLineNumber:7),source:'%23include+%3Cranges%3E%0A%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+vec%7B1,+2,+3,+4,+5,+6,+7,+8,+9%7D%3B%0A++auto+rg+%3D+std::ranges::subrange(std::begin(vec),+std::begin(vec)+%2B+3)%3B%0A++for(int+i+:+rg)%0A++%7B%0A++++std::cout+%3C%3C+i+%3C%3C+!'+!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0896}{https://wg21.link/P0896}
#addproposal{P1035}{https://wg21.link/P1035}



== Ranges -- Range adaptators}
\begin{itemize}
\item Appliquent filtres et transformations aux ranges
\item Évaluation paresseuse des ```cpp view```
\item Peuvent être chaînés avec une syntaxe "appel de fonction"
\end{itemize}

```cpp
		D(C(R));
```

\begin{itemize}
\item Ou une syntaxe "pipeline"
\end{itemize}

```cpp
R ``` C ``` D;
```

#addproposal{P0896}{https://wg21.link/P0896}
#addproposal{P1035}{https://wg21.link/P1035}



== Ranges -- Range adaptators}
\begin{itemize}
\item ```cpp std::views::all``` : tous les éléments du ```cpp range```
\item ```cpp std::views::ref``` : références sur les éléments du ```cpp range```
\item ```cpp std::views::filter``` : tous les éléments satisfaisants un prédicat
\end{itemize}

```cpp
		vector<int> ints{0, 1, 2, 3, 4, 5};
		auto even = [](int i){ return (i % 2) == 0; };

		ints | filter(even);       // 0, 2, 4
```

\begin{itemize}
\item ```cpp std::views::transform``` applique d'une fonction aux éléments
\end{itemize}

```cpp
		vector<int> ints{0, 1, 2, 3, 4, 5};
		auto foo = [](int i){ return 2 * i; };

		ints | transform(foo);  // 0, 2, 4, 6, 8, 10
```


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cranges%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+ints%7B0,+1,+2,+3,+4,+5%7D%3B%0A++auto+foo+%3D+%5B%5D(int+i)%7B+return+2+*+i%3B+%7D%3B%0A%0A++for(int+i+:+ints+%7C+std::views::transform(foo))%0A++%7B%0A++++std::cout+%3C%3C+i+%3C%3C+!'+!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cranges%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+ints%7B0,+1,+2,+3,+4,+5%7D%3B%0A++auto+even+%3D+%5B%5D(int+i)%7B+return+(i+%25+2)+%3D%3D+0%3B+%7D%3B%0A%0A++for(int+i+:+ints+%7C+std::views::filter(even))%0A++%7B%0A++++std::cout+%3C%3C+i+%3C%3C+!'+!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0896}{https://wg21.link/P0896}
#addproposal{P1035}{https://wg21.link/P1035}



== Ranges -- Range adaptators}
\begin{itemize}
\item ```cpp std::views::take``` : les $N$ premiers éléments
\end{itemize}

```cpp
iota(1, 10) ``` take(foo);  // 1, 2, 3
```

\begin{itemize}
	\item ```cpp std::views::take_while``` : les éléments jusqu'au premier ne satisfaisant pas un prédicat
	\end{itemize}

```cpp
iota(1, 10) ``` take_while([] (int i) { return i != 5; })) // 1, 2, 3, 4
```

\begin{itemize}
\item ```cpp std::views::drop``` : tous les éléments sauf les $N$ premiers
\end{itemize}

```cpp
iota(1, 10) ``` drop(3)) // 4, 5, 6, 7, 8, 9
```

\begin{itemize}
	\item ```cpp std::views::drop_while``` : tous les éléments depuis le premier ne satisfaisant pas un prédicat
	\end{itemize}

```cpp
iota(1, 10) ``` drop_while([] (int i) { return i != 5; })) // 5, 6, 7, 8, 9
```


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:93,endLineNumber:6,positionColumn:93,positionLineNumber:6,selectionStartColumn:64,selectionStartLineNumber:6,startColumn:64,startLineNumber:6),source:'%23include+%3Cranges%3E%0A%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++for(int+i+:+std::views::iota(1,+10)+%7C+std::views::drop_while(%5B%5D+(int+i)+%7B+return+i+!!%3D+5%3B+%7D))%0A++%7B%0A++++std::cout+%3C%3C+i+%3C%3C+!'+!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:57,endLineNumber:6,positionColumn:57,positionLineNumber:6,selectionStartColumn:57,selectionStartLineNumber:6,startColumn:57,startLineNumber:6),source:'%23include+%3Cranges%3E%0A%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++for(int+i+:+std::views::iota(1,+10)+%7C+std::views::drop(3))%0A++%7B%0A++++std::cout+%3C%3C+i+%3C%3C+!'+!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:95,endLineNumber:6,positionColumn:95,positionLineNumber:6,selectionStartColumn:41,selectionStartLineNumber:6,startColumn:41,startLineNumber:6),source:'%23include+%3Cranges%3E%0A%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++for(int+i+:+std::views::iota(1,+10)+%7C+std::views::take_while(%5B%5D+(int+i)+%7B+return+i+!!%3D+5%3B+%7D))%0A++%7B%0A++++std::cout+%3C%3C+i+%3C%3C+!'+!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:38,endLineNumber:6,positionColumn:20,positionLineNumber:6,selectionStartColumn:38,selectionStartLineNumber:6,startColumn:20,startLineNumber:6),source:'%23include+%3Cranges%3E%0A%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++for(int+i+:+std::views::iota(1,+10)+%7C+std::views::take(3))%0A++%7B%0A++++std::cout+%3C%3C+i+%3C%3C+!'+!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0896}{https://wg21.link/P0896}
#addproposal{P1035}{https://wg21.link/P1035}



== Ranges -- Range adaptators}
\begin{itemize}
\item ```cpp std::views::common``` convertit une vue en ```cpp common_range```
\item ```cpp std::views::reverse``` : éléments en sens inverse
\end{itemize}

```cpp
		iota(1, 10) | reverse) // 9, 8, 7, 6, 5, 4, 3, 2, 1
```

\begin{itemize}
\item ```cpp std::views::join``` joint les éléments d'un range
\end{itemize}

```cpp
vector<string> foo{"hello", " ", "world", "!"};
foo | join);  // hello world!
```

\begin{itemize}
\item ```cpp std::views::split``` et ```cpp std::views::lazy_split``` découpent un range
\end{itemize}

```cpp
string foo{"the quick brown fox"};
foo | splitbar(' '); // the, quick, brown, fox
```


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:9,positionColumn:1,positionLineNumber:9,selectionStartColumn:1,selectionStartLineNumber:9,startColumn:1,startLineNumber:9),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cstring%3E%0A%23include+%3Cranges%3E%0A%0Aint+main()%0A%7B%0A++std::string+foo%7B%22the+quick+brown+fox%22%7D%3B%0A++for(auto+baz+:+foo+%7C+std::views::split(!'+!'))%0A++%7B%0A++++for(char+c+:+baz)%0A++++%7B%0A++++++std::cout+%3C%3C+c%3B%0A++++%7D%0A++++std::cout+%3C%3C+%22%5Cn%22%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:10,positionColumn:1,positionLineNumber:10,selectionStartColumn:1,selectionStartLineNumber:8,startColumn:1,startLineNumber:8),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cstring%3E%0A%23include+%3Cranges%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cstd::string%3E+foo%7B%22hello%22,+%22+%22,+%22world%22,+%22!!%22%7D%3B%0A++for(char+c+:+foo+%7C+std::views::join)%0A++%7B%0A++++std::cout+%3C%3C+c%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:61,endLineNumber:6,positionColumn:61,positionLineNumber:6,selectionStartColumn:61,selectionStartLineNumber:6,startColumn:61,startLineNumber:6),source:'%23include+%3Cranges%3E%0A%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++for(int+i+:+std::views::iota(1,+10)+%7C+std::views::reverse)%0A++%7B%0A++++std::cout+%3C%3C+i+%3C%3C+!'+!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0896}{https://wg21.link/P0896}
#addproposal{P1035}{https://wg21.link/P1035}



== Ranges -- Range adaptators}
\begin{itemize}
\item ```cpp std::views::elements``` : /* $N\textsuperscript{e}$*/ éléments d'un range de \textit{tuple-likes}
\end{itemize}

```cpp
map<std::string, int> foo {
  {"Lovelace"s, 1815}, {"Turing"s,   1912},
  {"Babbage"s,  1791}, {"Hamilton"s, 1936}};

foo ``` elements<1>;  // 1791 1936 1815 1912
```

\begin{itemize}
	\item ```cpp std::views::keys``` : clés d'un range de ```cpp std::pair```
	\end{itemize}

```cpp
foo ``` keys; // Babbage Hamilton Lovelace Turing
```

\begin{itemize}
\item ```cpp std::views::values``` : valeurs d'un range de ```cpp std::pair```
\end{itemize}

```cpp
		foo | values; // 1791 1936 1815 1912
```

\begin{itemize}
\item Surcharges des algorithmes opérants sur les ranges
\end{itemize}


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:5,endLineNumber:16,positionColumn:5,positionLineNumber:16,selectionStartColumn:5,selectionStartLineNumber:16,startColumn:5,startLineNumber:16),source:'%23include+%3Ciostream%3E%0A%23include+%3Cmap%3E%0A%23include+%3Cstring%3E%0A%23include+%3Cranges%3E%0A%0Ausing+namespace+std::literals%3B%0A%0Aint+main()%0A%7B%0A++std::map%3Cstd::string,+int%3E+foo+%3D+%0A++%7B%0A++++%7B%22Lovelace%22s,+1815%7D,%0A++++%7B%22Turing%22s,+++1912%7D,%0A++++%7B%22Babbage%22s,++1791%7D,%0A++++%7B%22Hamilton%22s,+1936%7D,%0A++%7D%3B%0A%0A++for(auto+i+:+foo+%7C+std::views::values)%0A++%7B%0A++++std::cout+%3C%3C+i+%3C%3C+%22+%22%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:38,endLineNumber:18,positionColumn:38,positionLineNumber:18,selectionStartColumn:38,selectionStartLineNumber:18,startColumn:38,startLineNumber:18),source:'%23include+%3Ciostream%3E%0A%23include+%3Cmap%3E%0A%23include+%3Cstring%3E%0A%23include+%3Cranges%3E%0A%0Ausing+namespace+std::literals%3B%0A%0Aint+main()%0A%7B%0A++std::map%3Cstd::string,+int%3E+foo+%3D+%0A++%7B%0A++++%7B%22Lovelace%22s,+1815%7D,%0A++++%7B%22Turing%22s,+++1912%7D,%0A++++%7B%22Babbage%22s,++1791%7D,%0A++++%7B%22Hamilton%22s,+1936%7D,%0A++%7D%3B%0A%0A++for(auto+i+:+foo+%7C+std::views::keys)%0A++%7B%0A++++std::cout+%3C%3C+i+%3C%3C+%22+%22%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cmap%3E%0A%23include+%3Cstring%3E%0A%23include+%3Cranges%3E%0A%0Ausing+namespace+std::literals%3B%0A%0Aint+main()%0A%7B%0A++std::map%3Cstd::string,+int%3E+foo+%3D+%0A++%7B%0A++++%7B%22Lovelace%22s,+1815%7D,%0A++++%7B%22Turing%22s,+++1912%7D,%0A++++%7B%22Babbage%22s,++1791%7D,%0A++++%7B%22Hamilton%22s,+1936%7D,%0A++%7D%3B%0A%0A++for(auto+i+:+foo+%7C+std::views::elements%3C1%3E)%0A++%7B%0A++++std::cout+%3C%3C+i+%3C%3C+%22+%22%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0896}{https://wg21.link/P0896}
#addproposal{P1035}{https://wg21.link/P1035}


== Gestion des flux}
\begin{itemize}
\item Flux synchrones
\begin{itemize}
\item Classe tampon synchrone : ```cpp std::basic_syncbuf```
\item Classe flux bufferisé synchrone : ```cpp std::basic_osyncstream```
\item ```cpp emit()``` transfère le tampon vers le flux de sortie
\end{itemize}
\end{itemize}

```cpp
		{ osyncstream s(cout);
		  s << "Hello," << '\n'; // no flush
		  s.emit(); // characters transferred, cout not flushed
		  s << "World!" << endl; // flush noted, cout not flushed
		  s.emit(); // characters transferred, cout flushed
		  s << "Greetings." << '\n'; // no flush
		} // characters transferred, cout not flushed
```

\begin{itemize}
\item Limitation de la taille lue dans les flux avec ```cpp std::setw()```
\end{itemize}

```cpp
		// Seuls 24 caracteres sont lus
		cin >> setw(24) >> a;
```

#addproposal{P0053}{https://wg21.link/P0053}



== ``` std::format``` -- Présentation}
\begin{itemize}
\item API de formatage inspiré de la bibliothèque #link("https://github.com/fmtlib/fmt")[``` {fmt}```]
\end{itemize}

#noteblock{Motivations}
\begin{itemize}
\item Formatage "à la C" non extensible et peu sûr
\item Flux complexes, peu performants, peu propices à l'internationalisation et la localisation, formateurs globaux

// Peu propices à la localisation car le format et l'ordre des éléments est dans le code lui-même et ne peut pas être sortie facilement}
// Les formateurs sont globaux, ainsi l'injection de ```cpp std::hex``` dans un flux va passer tous les affichages des entiers en hexadécimal jusqu'à un changement explicite et pas uniquement celui concerné}
\end{itemize}
\end{block}

\begin{itemize}
\item Formatage \textit{locale-specific} ou \textit{locale-independent}

// Par défaut, la locale n'est pas prise en compte, mais peut l'être si souhaité}

\item Format sous forme de chaînes utilisant ```cpp {}``` comme \textit{placeholder}
\end{itemize}

#noteblock{En attendant C++20}
\begin{itemize}
\item Utilisez ```cpp {fmt}``` ou ```cpp Boost.Format```
\end{itemize}
\end{block}

#noteblock{Voir aussi}
\begin{itemize}
\item Overload 166
\end{itemize}
\end{block}

#addproposal{P0645}{https://wg21.link/P0645}



== ``` std::format``` -- API}
\begin{itemize}
\item ```cpp format()``` retourne une chaîne
\end{itemize}

```cpp
		format("{}", "a");  // "a"
```

\begin{itemize}
\item ```cpp format_to()``` formate dans un ```cpp output_iterator```
\end{itemize}

```cpp
		vector<char> foo;

		format_to(back_inserter(foo), "{}", "a");
```

// ```cpp output_iterator``` est retourné par ```cpp format_to()```}

\begin{itemize}
\item ```cpp format_to_n()``` formate dans un ```cpp output_iterator``` avec une taille limite
\end{itemize}

```cpp
		array<char, 4> foo;

		format_to_n(foo.data(), foo.size(), "{}", "a");
```

// Troncature à la taille indiquée si nécessaire}


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Carray%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::array%3Cchar,+4%3E+foo%3B%0A%0A++std::format_to_n(foo.data(),+foo.size(),+%22%7B%7D%22,+%22a%22)%3B%0A++for(auto+c:+foo)%0A++%7B%0A++++std::cout+%3C%3C+c+%3C%3C+%22+%22%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cchar%3E+foo%3B%0A%0A++std::format_to(std::back_inserter(foo),+%22%7B%7D%22,+%22a%22)%3B%0A++for(auto+c:+foo)%0A++%7B%0A++++std::cout+%3C%3C+c+%3C%3C+%22+%22%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7B%7D%22,+%22a%22)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0645}{https://wg21.link/P0645}



== ``` std::format``` -- API}
\begin{itemize}
\item ```cpp formatted_size()``` retourne la taille nécessaire au formatage
\end{itemize}

```cpp
		formatted_size("{}", "a");  // 1
```

\begin{itemize}
\item ```cpp vformat()``` et ```cpp vformat_to()``` arguments regroupés dans un \textit{tuple-like}
\end{itemize}

```cpp
		vformat("{}", make_format_args("a"));
```

\begin{itemize}
\item Variantes ```cpp wchar``` et ```cpp locale```
\end{itemize}


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::vformat(%22%7B%7D%22,+std::make_format_args(%22a%22))+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::formatted_size(%22%7B%7D%22,+%22a%22)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0645}{https://wg21.link/P0645}



== ``` std::format``` -- Placeholder}
\begin{itemize}
\item Format général : ```cpp {[arg-id][:format-spec]}```
\begin{itemize}
\item ```cpp arg-id``` : index, optionnel, de l'argument de la liste de paramètres
\item ```cpp format-spec``` : spécifications, optionnelles, du format
\end{itemize}
\end{itemize}

#noteblock{Séquences d'échappement}
\begin{itemize}
\item ```cpp {{``` affiche ```cpp {```
\item ```cpp }}``` affiche ```cpp }```
\end{itemize}
\end{block}

#addproposal{P0645}{https://wg21.link/P0645}



== ``` std::format``` -- Identifiant d'arguments}
\begin{itemize}
\item Valeur optionnelle indiquant l'index du paramètre à afficher
\item Débute à 0
\end{itemize}

```cpp
		format("{1} et {0}", "a", "b"); // "b et a"
		format("{0} et {0}", "a");      // "a et a"
```

\begin{itemize}
\item En cas d'absence, les paramètres sont pris dans l'ordre d'apparition
\end{itemize}

```cpp
		format("{} et {}", "a", "b");   // "a et b"
```

#alertblock{Limite}
\begin{itemize}
\item Impossible d'en n'omettre que certains
\end{itemize}
\end{alertblock}


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7B%7D+et+%7B%7D%22,+%22a%22,+%22b%22)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7B1%7D+et+%7B0%7D%5Cn%22,+%22a%22,+%22b%22)%3B%0A++std::cout+%3C%3C+std::format(%22%7B0%7D+et+%7B0%7D%5Cn%22,+%22a%22)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0645}{https://wg21.link/P0645}



== ``` std::format``` -- Spécification de format}
\begin{itemize}
\item Format général : ``` [[fill]align][sign][#][0][width][prec][L][type]```
\begin{itemize}
\item ```cpp fill``` et ```cpp align``` : gestion de l'alignement
\item ```cpp sign``` : gestion du signe
\item ```cpp \#``` : forme alternative
\item ```cpp 0``` : gestion des zéros non significatifs
\item ```cpp width``` : taille minimal du champ
\item ```cpp prec``` : précision du champ
\item ```cpp L``` : prise en compte de la locale
\item ```cpp type``` : type à afficher
\end{itemize}
\end{itemize}

#addproposal{P0645}{https://wg21.link/P0645}



== ``` std::format``` -- Alignement}
\begin{itemize}
\item Alignement par défaut dépendant du type
\end{itemize}

```cpp
		format("{:6}", 42);     // "    42"
		format("{:6}", 'x');    // "x     "
```

\begin{itemize}
\item Fourniture du caractère de \textit{padding}
\end{itemize}

```cpp
		format("{:06}", 42);    // "000042"
```

\begin{itemize}
\item Choix de l'alignement
\end{itemize}

```cpp
		format("{:*<6}", 'x');  // "x*****"
		format("{:*>6}", 'x');  // "*****x"
		format("{:*^6}", 'x');  // "**x***"
```


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7B:*%3C6%7D%22,+!'x!')+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B:*%3E6%7D%22,+!'x!')+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B:*%5E6%7D%22,+!'x!')+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7B:06%7D%22,+42)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7B:6%7D%22,+42)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B:6%7D%22,+!'x!')+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0645}{https://wg21.link/P0645}



== ``` std::format``` -- Taille minimale}
\begin{itemize}
\item Fournit la taille minimal du champ
\item Si le champ est plus long, il n'est pas tronqué
\end{itemize}

```cpp
// "```  10``` ```          10```"
format("```{0:4}``` ```{0:12}```", 10);
// "```10000000``` ```    10000000```"
format("```{0:4}``` ```{0:12}```", 1000000);
```

\begin{itemize}
\item Possible de fournir la taille en paramètre via un \textit{placeholder}
\end{itemize}

```cpp
// "```  10``` ```          10```"
format("```{0:{1}}``` ```{0:{2}}```", 10, 4, 12);
```


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7C%7B0:%7B1%7D%7D%7C+%7C%7B0:%7B2%7D%7D%7C%22,+10,+4,+12)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7C%7B0:4%7D%7C+%7C%7B0:12%7D%7C%22,+10)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7C%7B0:4%7D%7C+%7C%7B0:12%7D%7C%22,+1000000)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0645}{https://wg21.link/P0645}



== ``` std::format``` -- Précision}
\begin{itemize}
\item Introduit par un ```cpp .```
\item Uniquement sur
\begin{itemize}
\item Les nombres flottants
\end{itemize}
\end{itemize}

```cpp
		format("{:.6f}", 392.65);       // "392.650000"
```

\begin{itemize}
\item [] \begin{itemize}
\item Les chaînes de caractères : troncature
\end{itemize}
\end{itemize}

```cpp
		format("{:.6}", "azertyuiop");  // "azerty"
```

\begin{itemize}
\item Possible de fournir la taille en paramètre via un \textit{placeholder}
\end{itemize}


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7B:.6%7D%22,+%22azertyuiop%22)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7B:.6f%7D%22,+392.65)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0645}{https://wg21.link/P0645}



== ``` std::format``` -- Signe}
\begin{itemize}
\item Uniquement sur les négatifs : '```cpp -```'
\item Sur toutes les valeurs : '```cpp +```'
\item Uniquement sur les négatifs en réservant l'espace : '``` ```'
\end{itemize}

```cpp
		format("{0:},{0:+},{0:-},{0: }", 1);   // "1,+1,1, 1"
		format("{0:},{0:+},{0:-},{0: }", -1);  // "-1,-1,-1,-1"
```


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7B0:%7D,%7B0:%2B%7D,%7B0:-%7D,%7B0:+%7D%22,+1)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B0:%7D,%7B0:%2B%7D,%7B0:-%7D,%7B0:+%7D%22,+-1)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0645}{https://wg21.link/P0645}



== ``` std::format``` -- Zéros non significatifs}
\begin{itemize}
\item Affichage des zéros non significatifs
\end{itemize}

```cpp
		format("{:+06d}", 120);  // "+00120"
```


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7B:%2B06d%7D%22,+120)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0645}{https://wg21.link/P0645}



== ``` std::format``` -- Format}
\begin{itemize}
\item Entiers : décimal, octal, binaire ou hexadécimal
\end{itemize}

```cpp
		format("{:d}", 42);           // "42"
		format("{:x} {:X}", 42, 42);  // "2a 2A"
		format("{:b}", 42);           // "101010"
		format("{:o}", 42);           // "52"
```

\begin{itemize}
\item Caractères : valeur numérique ou caractère
\end{itemize}

```cpp
		format("{:X}", 'A');          // "41"
		format("{:c}", 'A');          // "A"
```

\begin{itemize}
\item Booléens : chaîne ou nombre
\end{itemize}

```cpp
		format("{:d}", true);         // "1"
		format("{:s}", true);         // "true"
```


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7B:d%7D%22,+true)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B:s%7D%22,+true)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7B:X%7D%22,+!'A!')+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B:c%7D%22,+!'A!')+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7B:d%7D%22,+42)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B:x%7D+%7B:X%7D%22,+42,+42)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B:b%7D%22,+42)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B:o%7D%22,+42)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0645}{https://wg21.link/P0645}



== ``` std::format``` -- Format}
\begin{itemize}
\item Flottants : fixe, court, scientifique ou hexadécimal
\end{itemize}

```cpp
		format("{:.6f}", 392.65);   // "392.650000"
		format("{:.6g}", 392.65);   // "392.65"
		format("{:.6e}", 392.65);   // "3.9265e+02"
		format("{:.6E}", 392.65);   // "3.9265E+02"
		format("{:.6a}", 42.);      // "1.500000p+5"
```

// Format court : fixe sur les petites nombres, scientifique sur les grands}
// Par défaut court : .6g}

\begin{itemize}
\item Chaîne de caractère
\end{itemize}

```cpp
		format("{:s}", "azerty");   // "azerty"
```


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7B:s%7D%22,+%22azerty%22)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7B:.6f%7D%22,+392.65)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B:.6g%7D%22,+392.65)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B:.6e%7D%22,+392.65)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B:.6E%7D%22,+392.65)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B:.6a%7D%22,+42.)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0645}{https://wg21.link/P0645}



== ``` std::format``` -- Forme alternative}
\begin{itemize}
\item Affichage de la base des entiers
\end{itemize}

```cpp
		format("{:#x}", 42);        // "0x2a"
		format("{:#X}", 42);        // "0X2A"
```

\begin{itemize}
\item Affichage du point décimal et de l'ensemble de la précision des flottants
\end{itemize}

```cpp
		format("{:.6g}", 392.65);   // "392.65"
		format("{:#.6g}", 392.65);  // "392.650"
```


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7B:.6g%7D%22,+392.65)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B:%23.6g%7D%22,+392.65)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7B:%23x%7D%22,+42)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B:%23X%7D%22,+42)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0645}{https://wg21.link/P0645}



== ``` std::format``` -- Dates et heures}
\begin{itemize}
\item Format basé sur ```cpp strftime```
\begin{itemize}
\item ```cpp %y``` : année sur deux digits
\item ```cpp %m``` : mois
\item ```cpp %d``` : jour dans le mois
\item ```cpp %u```, ```cpp %w``` : jour dans la semaine

// 1 à 7 avec 1 lundi pour u, 0 à 6 avec 0 pour dimanche pour w}

\item ```cpp %H```, ```cpp %I``` : heure (format 24h ou 12h)
\item ```cpp %M``` : minutes
\item ```cpp %S``` : secondes
\item ```cpp %Z``` : timezone
\item ...
\end{itemize}
\end{itemize}

```cpp
		format("{:%F %T}", chrono::system_clock::now());
		// AAAA-MM-JJ HH:mm:ss
```


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cchrono%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7B:%25F+%25T%7D%22,+std::chrono::system_clock::now())%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0645}{https://wg21.link/P0645}



== ``` std::format``` -- Gestion des erreurs}
\begin{itemize}
\item Exception ```cpp std::format_error```
\begin{itemize}
\item Chaîne de format invalide
\item Spécificateurs non cohérents avec le type fournit
\item Absence de valeur
\item Exception levée par un formateur
\end{itemize}
\end{itemize}

#noteblock{Valeur surnuméraire}
\begin{itemize}
\item Les valeurs surnuméraires ne sont pas des erreurs et sont ignorées
\end{itemize}
\end{block}

#addproposal{P0645}{https://wg21.link/P0645}



== ``` std::format``` -- Types utilisateur}
\begin{itemize}
\item Par spécialisation de ```cpp std::formatter<>```
\end{itemize}

```cpp
		template<>
		struct formatter<T> {
		  template <class ParseContext>
		  auto parse(ParseContext& parse_ctx);

		  template <class FormatContext>
		  auto format(const T& value, FormatContext& fmt_ctx);
		};
```

#addproposal{P0645}{https://wg21.link/P0645}



== ``` std::format``` -- Types utilisateur}
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

#noteblock{Aller plus loin}
\begin{itemize}
\item Voir #link{https://www.sandordargo.com/blog/2025/07/23/format-your-own-type-part-1}{Format your own type (Part 1)#linklogo()} et #link{ https://www.sandordargo.com/blog/2025/07/30/format-your-own-type-part-2}{Format your own type (Part 2)#linklogo()}
\end{itemize}
\end{block}


#codesample{https://godbolt.org/#z:OYLghAFBqd5QCxAYwPYBMCmBRdBLAF1QCcAaPECAMzwBtMA7AQwFtMQByARg9KtQYEAysib0QXACx8BBAKoBnTAAUAHpwAMvAFYTStJg1DIApACYAQuYukl9ZATwDKjdAGFUtAK4sGIAMxmpK4AMngMmAByPgBGmMQgABwAnKQADqgKhE4MHt6%2BAUEZWY4CYRHRLHEJKbaY9qUMQgRMxAR5Pn6BdQ05za0E5VGx8UmpCi1tHQXdEwNDldVjAJS2qF7EyOwcAPQ7ANQIBARpCiB7AO5XAHQKhugk6K3AqNdoLDsxtKjAO2YaZgArDsNAB2Hb%2BDQ7fjEFhMAgAWgAnutiAjUBcGAiCEi0pgEWkBgizCYNABBUkUsz%2BcLIbxYfYmfxuUQKJRtJnYSnmGkMOleBlMtwwuEETnc6m0%2BmYRnMpwTYiYVji8k8qUCmVC1BpRpiFVU3n8wXMhXhYD6ykKrwOfbKYg/YisFhmkKGYBeJjATWgqzk/b%2B/YTdAgECmoz7ZhsJm%2BskB/bhAj7OHaEgAfQAbvEsgITD6NLmACLRylxoMh7W62hChOcpPhNOZ4jZhi5ixlkAMLy0b46wvFv0B9sVnJ6uWCWuEgjIBAZrM5Vvtzvdit9/wx1fr8kETAsNIGbeytz6q029si%2BHb4hCu0Op0ut0er211slwcEYOhgjEM37VMX78xF424KP2sYBmgDATJgqhpMQ%2BxMEBqD7ISTaYBAZ4kKKqYoUoqYQduqhimYABsyGtLh%2BHQQQyyMj6r5xv6CFEPGiZMgWgbviGjpGJgZwgDQDDoBAOGYHhshUaQ%2BxgBwhbScsoEMQGf7HABQG8bK7HtmGwDCeRomUYR1xxMA4QQKsLHyWu9EMYqBAbAwLEKQGfaqgOjGIfs54EBAEETLa9rAI6LDOkYrpGI%2BmDmKRsG3sFZqpgY4WepgpDWYpikYbC8JiYIVFRZ5mHZQZ1H7L5rF0W5DFMUh6ysf47FeTlBEENctVmU5il4FQ%2BwQMpX54IBwHXDuOpImZNEvpV6X7LVGkcR%2BjVEBAtWSeYJJ0aCRYbUWZhBMhAVBSFwAJQ%2ByXXJGKVpdN103ftsVHSdSVetcyYNnOAiWTGt37LZ9kzUBHUMS5YGKTCPXVRGc0aF40aQ0Kv7/gNakKLceAAF5oZ9jKWNYDATRVIPXV1PV9apwEmICFgtoC7FsWxUkyUCcm0V932DhchDTiTiODbxFNWDjljUwW%2BOs2zDGsjK0m0NJIBXeLcazfTmVYUtK3Y%2BtVibWtqVTQr%2BvXTFgV3kYj3umdF2ffLBsxIqTAANaA/rksM%2BmsvW/rSv1fNIaLagEAewb/rq2tL7a7tklG4d8WJebz2vcQs5NjkVt60HxPCQdJvHbHEUvfWieNs2ouB0HXuaZx/GFQQqZLaXQcBiHu3XGHO1BPXDf7AAVFH2dm3nIVvcnH1Ow3wOd3GGe93Fpu52dk7Tknxcsx3Cvlz7VdZTXddpxPitAatzetzrq9Bz3Wczznp3PQvM5Fyno9B%2BPe/7LbSqO1Zu/fS70ksO7X9ryAnNFW2Ud6Exfv9Agh9NZ9gjndY2l9%2B5nQTkvB%2Bn9wENzfg7R%2BbMf4cAYP/DBZcgHK0rn7AOADiFQI1sfOB597ox2vpgfODAh7FxwfrLBH9NxENwUwJQDM0iEIgevEB29/anzZk3GB4c9r0IQQ9OeN94SL3viPdBECuEcNung8wgJhEv1EWQ6utd/bSL0WtVOvDOF224ZI5%2BN1Cz7HqAIya1j0pGIWiYtWB8aHbR1gjFSSNyaU2FlY76Digba13r9YgDlaqA2Bhubk5IExJiYKZEulUvBZHDBdBQhItgb20glQg8QxAgQ0QGG8Cj7xPRlMgNIaQXy7SPILAWe1/jJMqjU6OoUmHISRAQBAOY6K7WUEMkZLY4H%2BEklwdaRYqn%2Bl6dnMKccZRpEmQIZQKiEAtLMBM4ZOYZlzL2lwfM2t0HWXbGgEhzJ4ZiIDrtWhe1GlpAmvc5kDMKZuAITJJZG9bl1SPF8x5ocfRyyBFWIELBYGvKaR8kFbhvmAl%2BdJQGNyvZIo3l5J5mtIWAmhYCWFsjJJvMRfDdFqK/kYsrkCw8DzjFbzxa2AlRL0xwrJQihlXyqVov%2BWLQFWLGVeOZeCrWbdI5bIYDsqcCAKW8pktS9FALMV3OxWC55EK9G0GxoCDlpLBlHJlbshVyK%2BU0tVXS4VoKmWihZdqqFeqWAtyBAwV1gJmmGs2ca2V04zUov5aBYGHBVi0E4ICXgfgOBaFIKgTgbSBYWEDKiIpPIeCkAIJoUNqx7YgEBBofQnBJBRuzXGzgvAziFqzTG0NpA4CwCQNBTAyBEJkAoBAZ4CgdkRFoEIEZmJOAZveGkOg8Icg9vqP2jE0bY0jroKMYAChmCnBGVA%2Bd9BiCRFYNsXgG74gAHkgLTsHbW4IqgW1kmIEuit56W3NHwNG3g/BBAiDEOwKQMhBCKBUOoM9uguD6DdCgaw1h9ADTOJAVYw4BBnA4AiIMbFTDtP%2BPsBEAB1MQuqMNUUdGhvETxBB4GQLwVAjZvxYEg2ZUgxAvBEbYAAFVQJ4KjqwFCpo/bYd84RJ19oHdGjNX5MDbAzRcR0aRs1hojaWs98aODYAva2ogcFVCJGIgiYikh9jAGQMgHqX46P2xohARNYH9i4EICQbG/guDLF4DWrQyxVgICVFgBI1G80FqLRwEtpBZ2kdvVWzNkmpMcDMDJ2Ncn7MhdIGovwkggA%3D%3D%3D}

#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cformat%3E%0A%0Astruct+MyComplex%0A%7B%0A++double+real%3B%0A++double+imag%3B%0A%7D%3B%0A%0Atemplate%3C%3E%0Astruct+std::formatter%3CMyComplex%3E%0A%7B%0A++++constexpr+auto+parse(std::format_parse_context%26+ctx)%0A++++%7B%0A++++++++return+ctx.begin()%3B%0A++++%7D%0A+%0A++++auto+format(const+MyComplex%26+value,+std::format_context%26+ctx)+const%0A++++%7B%0A++++++++return+std::format_to(ctx.out(),+%22%7B%7D%2B%7B%7Di%22,+value.real,+value.imag)%3B%0A++++%7D%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++++std::cout+%3C%3C+std::format(%22%7B%7D%22,+MyComplex%7B1,+2%7D)+%3C%3C+%22%5Cn%22%3B%0A%7D'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0645}{https://wg21.link/P0645}


== Tableaux}
\begin{itemize}
\item Support des tableaux par ```cpp std::make_shared()```
\end{itemize}

```cpp
		shared_ptr<double[]> foo = make_shared<double[]>(1024);
```

\begin{itemize}
\item Déduction de la taille des tableaux par ```cpp new()```
\end{itemize}

```cpp
		double* a = new double[]{1, 2, 3};
```


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aint+main()%0A%7B%0A++double*+foo+%3D+new+double%5B%5D%7B1,+2,+3%7D%3B%0A++delete%5B%5D+foo%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cmemory%3E%0A%0Aint+main()%0A%7B%0A++std::shared_ptr%3Cdouble%5B%5D%3E+foo+%3D+std::make_shared%3Cdouble%5B%5D%3E(1024)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0674}{https://wg21.link/P0674}
#addproposal{P1009}{https://wg21.link/P1009}



== Destruction}
\begin{itemize}
\item ```cpp std::destroying_delete_t``` : pas de destruction avant l'appel à ```cpp delete()```
\end{itemize}

#noteblock{Intérêt}
\begin{itemize}
\item Conserver des informations nécessaire à la libération
\end{itemize}
\end{block}

```cpp
		struct Foo {
		  void operator delete(Foo* ptr, destroying_delete_t) {
		    const size_t realSize = ...;
		    ptr->~Foo();
		    ::operator delete(ptr, realSize);
		  }
		};
```

#alertblock{Ne pas oublier}
\begin{itemize}
\item La destruction doit être appelée explicitement
\end{itemize}
\end{alertblock}

#addproposal{P0722}{https://wg21.link/P0722}


== Horloges}
\begin{itemize}
\item Nouvelles horloges
\begin{itemize}
\shorthandoff{:}
\item ```cpp std::chrono::utc_clock```
\begin{itemize}
\item Temps universel coordonné
\item Epoch : 1 janvier 1970 00:00:00
\item Support des secondes intercalaires
\end{itemize}
\item ```cpp std::chrono::gps_clock```
\begin{itemize}
\item Epoch : 6 janvier 1980 00:00:00 UTC
\item Pas de seconde intercalaire
\end{itemize}
\item ```cpp std::chrono::tai_clock```
\begin{itemize}
\item Temps atomique universel
\item Epoch : 31 décembre 1957 23:59:50 UTC
\item Pas de seconde intercalaire
\end{itemize}
\item ```cpp std::chrono::file_clock``` : alias vers le temps du système de fichier
\shorthandon{:}
\end{itemize}
\end{itemize}


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cchrono%3E%0A%23include+%3Cformat%3E%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+std::format(%22%7B:%25F+%25T%7D%22,+std::chrono::utc_clock::now())+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B:%25F+%25T%7D%22,+std::chrono::gps_clock::now())+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B:%25F+%25T%7D%22,+std::chrono::tai_clock::now())+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B:%25F+%25T%7D%22,+std::chrono::file_clock::now())+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0355}{https://wg21.link/P0355}



== Horloges}
\begin{itemize}
\item Conversion des horloges vers et depuis UTC
\item Conversion de ```cpp std::chrono::utc_clock``` vers et depuis le temps système
\item Conversion des horloges entre-elles
\end{itemize}

#alertblock{Conversion de ```cpp std::chrono::file_clock```}
\begin{itemize}
\item Support optionnel des conversions entre ```cpp std::chrono::file_clock``` et ```cpp std::chrono::utc_clock``` ou ```cpp std::chrono::system_clock```
\end{itemize}
\end{alertblock}

\begin{itemize}
\item Pseudo-horloge ```cpp std::chrono::local_t``` temps dans la \textit{timezone} locale
\end{itemize}

#addproposal{P0355}{https://wg21.link/P0355}



== Évolution de ``` std::chrono::duration```}
\begin{itemize}
\item \textit{Helper} pour le jour, la semaine, le mois ou l'année
\item ```cpp from_stream()``` lit une ```cpp std::chrono::duration```
\item Utilisation de chaîne de format utilisant des séquences préfixées par ```cpp %```
\begin{itemize}
\item ```cpp %H```,```cpp %I``` : heure (format 24h ou 12h)
\item ```cpp %M``` : minutes
\item ```cpp %S``` : secondes
\item ```cpp %Y```, ```cpp %y``` : année (4 ou 2 chiffres)
\item ```cpp %m``` : numéro du mois
\item ```cpp %b```, ```cpp %B``` : nom du mois dans la locale (abrégé ou complet)
\item ```cpp %d``` : numéro du jour dans le mois
\item ```cpp %U``` : numéro de la semaine
\item ```cpp %Z``` : abréviation de la \textit{timezone}
\item ...

// Similaire à ```cpp strftime()```}
// Et identique à ceux utilisés dans ```cpp std::format```}
\end{itemize}
\end{itemize}

#addproposal{P0355}{https://wg21.link/P0355}



== Calendrier}
\begin{itemize}
\item Gestion du calendrier grégorien
\begin{itemize}
\item Différentes représentations
\begin{itemize}
\item Année, mois
\item Jour dans l'année, dans le mois
\item Dernier jour du mois
\item Jour dans la semaine, /*$n\textsuperscript{e}$*/ jour de la semaine dans le mois
\end{itemize}
\end{itemize}
\end{itemize}

#alertblock{Convention anglo-saxonne}
\begin{itemize}
\item Le premier jour de la semaine est le dimanche
\end{itemize}
\end{alertblock}

\begin{itemize}
\item [] \begin{itemize}
\item [] \begin{itemize}
\item Et différentes combinaisons permettant de construire une date complète
\end{itemize}
\end{itemize}
\end{itemize}

#addproposal{P0355}{https://wg21.link/P0355}



== Calendrier}
\begin{itemize}
\item [] \begin{itemize}
\item Constantes représentant les jours de la semaine et les mois
\item Suffixes littéraux ```cpp y``` et ```cpp d``` pour les années et les jours
\item ```cpp operator/``` pour construire une date depuis un format humain
\end{itemize}
\end{itemize}

```cpp
auto date1 = 2016y/May/29d;
auto date2 = Sunday[3]/May/2016y;
```


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cchrono%3E%0A%23include+%3Cformat%3E%0A%0Ausing+namespace+std::literals::chrono_literals%3B%0A%0Aint+main()%0A%7B%0A++auto+date1+%3D+2016y/std::chrono::May/29d%3B%0A++auto+date2+%3D+std::chrono::Sunday%5B3%5D/std::chrono::May/2016y%3B%0A%0A++std::cout+%3C%3C+std::format(%22%7B:%25F%7D%22,+date1)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B:%25F%7D%22,+date2)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0355}{https://wg21.link/P0355}



== Timezone}
\begin{itemize}
\item Gestion des \textit{timezones}
\begin{itemize}
\item Gestion de la base de \textit{timezones} de l'IANA

// IANA : \textit{Internet Assigned Numbers Authority}}

\item Récupération de la \textit{timezone} courante
\item Recherche d'une \textit{timezone} depuis son nom
\item Caractéristiques d'une \textit{timezone}
\item Informations sur les secondes intercalaires
\item Récupération du nom d'une \textit{timezone}
\item Conversion entre \textit{timezone}
\item Gestion des ambiguïté de conversion
\end{itemize}
\end{itemize}

```cpp
		// 2016-05-29 07:30:06.153 UTC
		auto tp = sys_days{2016y/may/29d} + 7h + 30min + 6s + 153ms;
		// 2016-05-29 16:30:06.153 JST
		zoned_time zt = {"Asia/Tokyo", tp};
```


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cchrono%3E%0A%23include+%3Cformat%3E%0A%0Ausing+namespace+std::literals::chrono_literals%3B%0A%0Aint+main()%0A%7B%0A++auto+tp+%3D+std::chrono::sys_days%7B2016y/std::chrono::May/29d%7D+%2B+7h+%2B+30min+%2B+6s+%2B+153ms%3B+%0A++std::chrono::zoned_time+zt+%3D+%7B%22Asia/Tokyo%22,+tp%7D%3B%0A%0A++std::cout+%3C%3C+std::format(%22%7B:%25F+%25T+%25Z%7D%22,+tp)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+std::format(%22%7B:%25F+%25T+%25Z%7D%22,+zt)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0355}{https://wg21.link/P0355}



== Date et heure}
#noteblock{En attendant C++20}
\begin{itemize}
\item Utilisez ```cpp Boost.DateTime```
\end{itemize}
\end{block}

#noteblock{Pour aller plus loin}
\begin{itemize}
\item #link{http://site.icu-project.org/home}{```cpp ICU```#linklogo()} supporte de nombreux calendriers et mécanismes de localisation
\end{itemize}

// ICU : \textit{International Components for Unicode}}
\end{block}


== Range-based for loop}
\begin{itemize}
\item Initialisation dans les range-based for loop
\end{itemize}

```cpp
		vector<int> foo{1, 8, 5, 56, 42};
		for(size_t i = 0; const auto& bar : foo) {
		  cout << bar << " " << i << "\n";
		  ++i;
		}
```

\begin{itemize}
\item Seuls des couples ```cpp begin()```, ```cpp end()``` cohérents sont utilisés
\begin{itemize}
\item "Début" et "début + taille"
\item fonctions membres ```cpp begin()``` et ```cpp end()```
\item fonctions libres ```cpp std::begin()``` et ```cpp std::end()```
\end{itemize}
\end{itemize}

#noteblock{Intérêt}
\begin{itemize}
\item Itération (via des fonctions libres) d'éléments ayant une fonction membre ```cpp begin()``` ou ```cpp end()``` mais pas les deux
\end{itemize}
\end{block}

// Fonction membre qui n'est probablement pas une fonction d'itération}
// Auparavant la fonction membre était utilisé bien qu'incohérente}


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B1,+8,+5,+56,+42%7D%3B%0A++for(size_t+i+%3D+0%3B+const+auto%26+bar+:+foo)+%0A++%7B%0A++++std::cout+%3C%3C+bar+%3C%3C+%22+%22+%3C%3C+i+%3C%3C+%22%5Cn%22%3B%0A++++%2B%2Bi%3B+%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0614}{https://wg21.link/P0614}
#addproposal{P0962}{https://wg21.link/P0962}

== ``` consteval```}
\begin{itemize}
\item ```cpp consteval``` impose une évaluation \textit{compile-time}

// ```cpp constexpr``` permet une évaluation \textit{compile-time} mais ne l'impose pas}

\begin{itemize}
\item ```cpp consteval``` implique ```cpp inline```
\end{itemize}
\end{itemize}

```cpp
		consteval int sqr(int n) { return n * n; }
		sqr(100);    // OK
		int x = 100;
		sqr(x);      // Erreur
```

#alertblock{Restriction}
\begin{itemize}
\item Pas de pointeur dans des contextes ```cpp consteval```
\end{itemize}
\end{alertblock}


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aconsteval+int+sqr(int+n)%0A%7B%0A++return+n+*+n%3B%0A%7D%0A%0Aconstexpr+int+sqr2(int+n)%0A%7B%0A++return+n+*+n%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+sqr(100)+%3C%3C+%22%5Cn%22%3B%0A%0A++constexpr+int+x+%3D+10%3B%0A++std::cout+%3C%3C+sqr(x)+%3C%3C+%22%5Cn%22%3B%0A%0A++int+y+%3D+100%3B%0A%23if+0%0A++std::cout+%3C%3C+sqr(y)%3B+%3C%3C+%22%5Cn%22%3B%0A%23endif%0A%0A%23if+0%0A++std::cout+%3C%3C+sqr2(y)+%3C%3C+%22%5Cn%22%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic+-Wno-unused-variable',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P1073}{https://wg21.link/P1073}



== ``` constinit```}
\begin{itemize}
\item ```cpp constinit``` impose une initialisation durant la phase \textit{static initialization}
\begin{itemize}
\item Uniquement sur des objets dont la \textit{storage duration} est \textit{static} ou \textit{thread}
\item Mal-formé en cas d'initialisation dynamique
\item Adresse le \textit{static initialization order fiasco}
\end{itemize}
\end{itemize}

#addproposal{P1143}{https://wg21.link/P1143}



== ``` constexpr```}
\begin{itemize}
\item Initialisation triviale dans des contextes ```cpp constexpr```
\item ```cpp std::is_constant_evaluated()``` pour savoir si l'évaluation est \textit{compile-time}
\item Prise en compte accrue dans la bibliothèque standard
\item Assouplissement des restrictions
\begin{itemize}
\item Fonctions virtuelles ```cpp constexpr```
\item Utilisation d'```cpp union```
\item Utilisation de ```cpp try {} catch()```
\begin{itemize}
\item Se comporte comme \textit{no-ops} en \textit{compile-time}
\item Ne peut pas lancer d'exception \textit{compile-time}
\end{itemize}
\item Utilisation de ```cpp dynamic_cast``` et ```cpp typeid```
\item Utilisation de ```cpp asm```
\begin{itemize}
\item Si le code ```cpp asm``` n'est pas évalué en \textit{compile-time}
\end{itemize}
\end{itemize}
\end{itemize}

#addproposal{P1064}{https://wg21.link/P1064}
#addproposal{P1002}{https://wg21.link/P1002}
#addproposal{P1330}{https://wg21.link/P1330}
#addproposal{P1331}{https://wg21.link/P1331}

== Structured binding}
\begin{itemize}
\item Extension à tous les membres visibles

// \textit{structured binding} sur les membres privés depuis une fonction membre ou amis}

\item Plus proche de variables classiques
\begin{itemize}
\item Capture par les lambdas (copie et référence)
\end{itemize}
\end{itemize}

// En C++17, les lambdas ne peuvent pas capturer de \textit{structured binding}}

```cpp
		tuple foo{5, 42};

		auto[a, b] = foo;
		auto f1 = [a] { return a; };
		auto f2 = [=] { return b; };
```

\begin{itemize}
\item [] \begin{itemize}
\item Déclaration ```cpp inline```, ```cpp extern```, ```cpp static```, ```cpp thread_local``` ou ```cpp constexpr``` possible
\item Possibilité de marquer ```cpp [[ maybe_unused ]]```
\end{itemize}
\end{itemize}


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ctuple%3E%0A%0Aint+main()%0A%7B%0A++std::tuple+foo%7B5,+42%7D%3B%0A%0A++auto%5Ba,+b%5D+%3D+foo%3B%0A++auto+f1+%3D+%5Ba%5D+%7B+return+a%3B+%7D%3B%0A++auto+f2+%3D+%5B%3D%5D+%7B+return+b%3B+%7D%3B%0A%0A++std::cout+%3C%3C+f1()+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+f2()+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0961}{https://wg21.link/P0961}
#addproposal{P1091}{https://wg21.link/P1091}
#addproposal{P1381}{https://wg21.link/P1381}



== Structured binding}
\begin{itemize}
\item Recherche de ```cpp get()``` : seules les fonctions membres templates dont le premier paramètre template n'est pas un type sont retenues
\end{itemize}

#noteblock{Motivation}
\begin{itemize}
\item Utiliser des classes possédant un ```cpp get()``` indépendant de l'interface \textit{tuple-like}
\end{itemize}
\end{block}

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

// Exemple invalide en C++17 à cause du ```cpp get()``` de ```cpp shared_ptr``` qui n'était pas utilisable mais empêchait de rechercher dans le ```cpp namespace``` englobant. En C++20 cette fonction n'est pas retenue et on recherche dans le ```cpp namespace```}

#addproposal{P0969}{https://wg21.link/P0969}

== Non-Type Template Parameters}
\begin{itemize}
\item Utilisation possible de classes
\begin{itemize}
\item \textit{strong structural equality}
\begin{itemize}
\item Classes de base et membres non statiques avec une \textit{defaulted} ```cpp operator==```
\item Pas de référence
\item Pas de type flottant
\end{itemize}
\item Pas d'union
\end{itemize}
\end{itemize}

```cpp
		template<chrono::seconds seconds>
		class fixed_timer { ... };
```

// En C++17, il fallait utiliser un type entier, p.ex. ```cpp size_t```}

```cpp
		template<fixed_string Id>
		class entity { ... };

		entity<"hello"> e;
```

// En C++17, il faut utiliser un ensemble de ```cpp char``` : ```cpp template<char... Id>```}

#addproposal{P0732}{https://wg21.link/P0732}



== Templates}
\begin{itemize}
\item ```cpp typename``` optionnel lorsque seul un nom de type est possible

// Il ne sert qu'à lever des ambigüités}

\item Spécialisation possible sur des classes internes privées ou protégées
\item ```cpp std::type_identity<>``` désactive la déduction de type
\end{itemize}

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


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Ctype_traits%3E%0A%0Atemplate%3Cclass+T%3E%0A%23if+1%0AT+foo(T+a,+std::type_identity_t%3CT%3E+b)%0A%23else%0AT+foo(T+a,+T+b)%0A%23endif%0A%7B%0A++return+a+%2B+b%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+foo(4.2,+3)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0846}{https://wg21.link/P0846}
#addproposal{P0887}{https://wg21.link/P0887}



== Templates}
\begin{itemize}
\item Déduction de type sur les alias de template
\end{itemize}

```cpp
		template<typename T>
		using IntPair = std::pair<int, T>;

		// C++ 17
		IntPair<double> p0{1, 2.0};

		// C++ 20
		IntPair p1{1, 2.0};   // std::pair<int, double>
```


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cutility%3E%0A%0Atemplate%3Ctypename+T%3E%0Ausing+IntPair+%3D+std::pair%3Cint,+T%3E%3B%0A%0Aint+main()%0A%7B%0A++IntPair%3Cdouble%3E+p0%7B1,+2.0%7D%3B+%0A++IntPair+p1%7B1,+2.0%7D%3B+%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P1814}{https://wg21.link/P1814}



== Paramètres ``` auto```}
\begin{itemize}
\item Création de fonctions templates via ```cpp auto```
\end{itemize}

```cpp
		void foo(auto a, auto b) { ... };
```

\begin{itemize}
\item Similaire	à la création de lambdas polymorphiques
\end{itemize}


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Aauto+foo(auto+a,+auto+b)%0A%7B%0A++return+a+%2B+b%3B%0A%7D%3B%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+foo(4,+3)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


== Concepts -- Présentation}
\begin{itemize}
\item Histoire ancienne et mouvementée
\begin{itemize}
\item Prévu initialement pour C++0x
\item ... et cause des décalages successifs
\item Retrait à grand bruit de C++11
\item Finalement Concept lite TS publié en 2015
\item Intégration du TS acceptée en juillet 2017

// Mais pas en C++17, il fallait le support par les compilateurs avant pour valider le concept}

\end{itemize}
\item Définition de contraintes sur les paramètres templates et l'inférence de type
\begin{itemize}
\item Meilleurs diagnostics
\item Meilleure documentation du code
\item Aide à la déduction de type
\item Aide à la résolution de spécialisation

// Basé du coup sur un "nom" et non sur la structure (typage nominal/structurel)}

\end{itemize}
\item Propositions abandonnées / mises de côté
\begin{itemize}
\item \textit{Axiom} : spécification de propriétés sémantiques d'un concept

// Les concepts actuels se basent sur la structure et des propriétés syntaxiques (p.ex. l'opération d'addition est présent)}
// Exemple d'\textit{axiom} : associativité ou commutativité}
// Intérêt des \textit{axiom} : meilleure documentation, informations au compilateur (meilleurs avertissement et diagnostics, meilleures optimisations)}

\item \textit{Concept map} : transformation d'un type non-compatible vers un concept

// Exemple de \textit{concept map} : Utilisation de type définissant l'inégalité stricte et la comparaison vers un concept attendant l'inégalité large, implémentation du concept de pile (\textit{stack}) par ```cpp std::vector```}
\end{itemize}
\end{itemize}

#addproposal{P0734}{https://wg21.link/P0734}
#addproposal{P0898}{https://wg21.link/P0898}



== Concepts -- Utilisation template}
\begin{itemize}
\item Utilisable via une \textit{Requires clause}
\end{itemize}

```cpp
		template<typename T> requires incrementable<T>
		void foo(T);
```

\begin{itemize}
\item ... via une \textit{Trailing requires clause}
\end{itemize}

```cpp
		template<typename T>
		void foo(T) requires incrementable<T>;
```

\begin{itemize}
\item ... via des paramètres templates contraints
\end{itemize}

```cpp
		template<incrementable T>
		void foo(T);
```

\begin{itemize}
\item ... ou via des combinaisons de ces syntaxes
\end{itemize}


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Atemplate%3Cstd::incrementable+T%3E%0Avoid+foo(T)%0A%7B%7D%0A%0Aint+main()%0A%7B%0A++foo(5)%3B%0A%23if+0%0A++foo(std::vector%3Cint%3E%7B1,+2,+3%7D)%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Atemplate%3Ctypename+T%3E%0Avoid+foo(T)+requires+std::incrementable%3CT%3E%0A%7B%7D%0A%0Aint+main()%0A%7B%0A++foo(5)%3B%0A%23if+0%0A++foo(std::vector%3Cint%3E%7B1,+2,+3%7D)%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Atemplate%3Ctypename+T%3E+requires+std::incrementable%3CT%3E%0Avoid+foo(T)%0A%7B%7D%0A%0Aint+main()%0A%7B%0A++foo(5)%3B%0A%23if+0%0A++foo(std::vector%3Cint%3E%7B1,+2,+3%7D)%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0734}{https://wg21.link/P0734}
#addproposal{P0898}{https://wg21.link/P0898}



== Concepts -- Utilisation template}
\begin{itemize}
\item Utilisable depuis un concept nommé
\end{itemize}

```cpp
		template<typename T> requires incrementable<T>
		void foo(T);
```

\begin{itemize}
\item ... ou depuis des expressions
\end{itemize}

```cpp
		template<typename T> requires requires (T x) { ++x; }
		void foo(T);
```

```cpp
		template<typename T> requires (sizeof(T) > 1)
		void foo(T);
```

// Oui, ```cpp requires``` est bien en double}


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Atemplate%3Ctypename+T%3E+requires+(sizeof(T)+%3E+1)%0Avoid+foo(T)%0A%7B%7D%0A%0Aint+main()%0A%7B%0A++foo(5)%3B%0A%23if+0%0A++foo(!'a!')%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Atemplate%3Ctypename+T%3E+requires+requires+(T+x)+%7B+x%2B%2B%3B+%7D%0Avoid+foo(T)%0A%7B%7D%0A%0Aint+main()%0A%7B%0A++foo(5)%3B%0A%23if+0%0A++foo(std::vector%3Cint%3E%7B0,+1%7D)%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Atemplate%3Ctypename+T%3E+requires+std::incrementable%3CT%3E%0Avoid+foo(T)%0A%7B%7D%0A%0Aint+main()%0A%7B%0A++foo(5)%3B%0A%23if+0%0A++foo(std::vector%3Cint%3E%7B0,+1%7D)%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0734}{https://wg21.link/P0734}
#addproposal{P0898}{https://wg21.link/P0898}



== Concepts -- Utilisation template}
\begin{itemize}
\item Peuvent être composés
\end{itemize}

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


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Atemplate%3Ctypename+T%3E%0Arequires+(sizeof(T)+%3D%3D+2+%7C%7C+sizeof(T)+%3D%3D+4)%0Avoid+foo(T)%0A%7B%7D%0A%0Aint+main()%0A%7B%0A++foo(5)%3B%0A%23if+0%0A++foo(!'a!')%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Atemplate%3Ctypename+T%3E%0Arequires+(sizeof(T)+%3E+1+%26%26+sizeof(T)+%3C%3D+4)%0Avoid+foo(T)%0A%7B%7D%0A%0Aint+main()%0A%7B%0A++foo(5)%3B%0A%23if+0%0A++foo(!'a!')%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0734}{https://wg21.link/P0734}
#addproposal{P0898}{https://wg21.link/P0898}



== Concepts -- Utilisation template}
\begin{itemize}
\item Support des \textit{parameters pack}
\end{itemize}

```cpp
		template<Constraint... T>
		void foo(T...);
```

```cpp
		template<typename... T>
		requires (Constraint<T> && ... && true)
		void foo(T...);
```


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Atemplate%3Ctypename...+T%3E%0Arequires+(std::incrementable%3CT%3E+%26%26...+%26%26+true)%0Avoid+foo(T...)%0A%7B%7D%0A%0Aint+main()%0A%7B%0A++foo(5)%3B%0A++foo(5,+6,+7)%3B%0A%23if+0%0A++foo(std::vector%3Cint%3E%7B1,+2%7D)%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:6,endLineNumber:12,positionColumn:6,positionLineNumber:12,selectionStartColumn:6,selectionStartLineNumber:12,startColumn:6,startLineNumber:12),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Atemplate%3Cstd::incrementable...+T%3E%0Avoid+foo(T...)%0A%7B%7D%0A%0Aint+main()%0A%7B%0A++foo(5)%3B%0A++foo(5,+6,+7)%3B%0A%23if+0%0A++foo(std::vector%3Cint%3E%7B1,+2%7D)%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0734}{https://wg21.link/P0734}
#addproposal{P0898}{https://wg21.link/P0898}



== Concepts -- Utilisation inférence de type}
\begin{itemize}
\item Contraintes sur les paramètres (lambdas et fonctions templates)
\end{itemize}

```cpp
		[](Constraint auto a) {}
		void foo(Constraint auto a);
```

\begin{itemize}
\item Contraintes sur les types de retour
\end{itemize}

```cpp
		Constraint auto foo();
		auto bar() -> Constraint decltype(auto);
```


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Astd::incrementable+auto+foo()+%0A%7B%0A%23if+1%0A++return+5%3B%0A%23else%0A++return+std::vector%3Cint%3E%7B%7D%3B%0A%23endif%0A%7D%0A%0Aauto+bar()+-%3E+std::incrementable++decltype(auto)%0A%7B%0A%23if+1%0A++return+5%3B%0A%23else%0A++return+std::vector%3Cint%3E%7B%7D%3B%0A%23endif%0A%7D%0A%0Aint+main()%0A%7B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Avoid+foo(std::incrementable+auto)%0A%7B%7D%0A%0Aint+main()%0A%7B%0A++foo(5)%3B%0A%23if+0%0A++foo(std::vector%3Cint%3E%7B%7D)%3B%0A%23endif%0A%0A++auto+bar+%3D+%5B%5D(std::incrementable+auto)+%7B%7D%3B%0A++bar(5)%3B%0A%23if+0%0A++bar(std::vector%3Cint%3E%7B%7D)%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0734}{https://wg21.link/P0734}
#addproposal{P0898}{https://wg21.link/P0898}



== Concepts -- Utilisation inférence de type}
\begin{itemize}
\item Contraintes sur les variables
\end{itemize}

```cpp
		Constraint auto bar = ...;
```

\begin{itemize}
\item Contraintes sur les \textit{non-type template parameters}
\end{itemize}

```cpp
		template<Constraint auto S>
		void foo();
```

\begin{itemize}
\item Support des \textit{parameters pack}
\end{itemize}

```cpp
		void foo(Constraint auto... T);
```


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Avoid+foo(std::incrementable+auto...)%0A%7B%7D%0A%0Aint+main()%0A%7B%0A++foo(5)%3B%0A++foo(1,+2,+3)%3B%0A%23if+0%0A++foo(std::vector%3Cint%3E%7B%7D)%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Atemplate%3Cstd::incrementable+auto+S%3E%0Avoid+foo()%0A%7B%7D%0A%0Aint+main()%0A%7B%0A++foo%3C5%3E()%3B%0A%23if+0%0A++foo%3Cstd::vector%3Cint%3E%7B%7D%3E()%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Aint+main()%0A%7B%0A++std::incrementable+auto+foo+%3D+5%3B%0A%23if+0%0A++std::incrementable+auto+bar+%3D+std::vector%3Cint%3E%7B%7D%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic+-Wno-unused-variable',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0734}{https://wg21.link/P0734}
#addproposal{P0898}{https://wg21.link/P0898}



== Concepts -- Standard}
\begin{itemize}
\item Nombreux concepts standards
\begin{itemize}
\item Relations entre types : ```cpp same_as```, ```cpp derived_from```, ```cpp convertible_to```, ```cpp common_with```, ...
\item Types numériques : ```cpp integral```, ```cpp signed_integral```, ```cpp unsigned_integral```, ```cpp floating_point```, ...
\item Opérations supportées : ```cpp swappable```, ```cpp destructible```, ```cpp default_constructible```, ```cpp move_constructible```, ```cpp copy_constructible```, ...
\item Catégories de types : ```cpp movable```, ```cpp copyable```, ```cpp semiregular```, ```cpp regular```, ...

// ```cpp semiregular``` : ```cpp copyable``` et ```cpp default_constructible```}
// ```cpp regular``` : ```cpp semiregular``` et ```cpp equality_comparable```}

\item Comparaisons : ```cpp boolean```, ```cpp equality_comparable```, ```cpp totally_ordered```, ...
\item \textit{Callable concepts} : ```cpp invocable```, ```cpp predicate```, ```cpp strict_weak_order```, ...
\item ...
\end{itemize}
\end{itemize}

#addproposal{P0734}{https://wg21.link/P0734}
#addproposal{P0898}{https://wg21.link/P0898}



== Concepts -- Définition}
\begin{itemize}
\item Peuvent être définis depuis des expressions
\end{itemize}

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

#addproposal{P0734}{https://wg21.link/P0734}
#addproposal{P0898}{https://wg21.link/P0898}



== Concepts -- Définition}
\begin{itemize}
\item Y compris en retirant des qualifieurs
\end{itemize}

```cpp
template<class T>
concept Addable = requires(
  const remove_reference_t<T>& a,
  const remove_reference_t<T>& b) { a + b; };
```

\begin{itemize}
\item Ou en imposant les types de retour
\end{itemize}

```cpp
		template<class T>
		concept Comparable = requires(T a, T b) {
		  { a == b } -> boolean;
		  { a != b } -> boolean; };
```

#addproposal{P0734}{https://wg21.link/P0734}
#addproposal{P0898}{https://wg21.link/P0898}



== Concepts -- Définition}
\begin{itemize}
\item Depuis des \textit{traits}
\end{itemize}

```cpp
		template<class T>
		concept integral = is_integral_v<T>;
```

```cpp
template<class T, class... Args>
concept constructible_from =
  destructible<T> && is_constructible_v<T, Args...>;
```

#addproposal{P0734}{https://wg21.link/P0734}
#addproposal{P0898}{https://wg21.link/P0898}



== Concepts -- Définition}
\begin{itemize}
\item Depuis d'autres concepts
\end{itemize}

```cpp
template<class T> concept semiregular =
  copyable<T> && default_constructible<T>;
```

\begin{itemize}
\item En combinant différentes méthodes
\end{itemize}

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

#addproposal{P0734}{https://wg21.link/P0734}
#addproposal{P0898}{https://wg21.link/P0898}


== Attributs}
\begin{itemize}
\item Ajout d'attributs
\begin{itemize}
\item ```cpp [[ likely ]]``` et ```cpp [[ unlikely ]]``` probabilité de branches conditionnelles

// Fourni au compilateur des informations lui permettant des optimisations plus pertinentes}

\item ```cpp [[ no_unique_address ]]``` membre statique ne nécessitant pas une adresse unique

// Et permettre l'EMO (\textit{Empty Member Optimisation})}
\end{itemize}

\item Extension de ```cpp [[ nodiscard ]]``` aux constructeurs
\begin{itemize}
\item Marquage ```cpp [[ nodiscard ]]``` des constructeurs autorisé
\item Vérification également lors des conversions via les constructeurs
\end{itemize}
\item Possibilité d'associer un message à ```cpp [[ nodiscard ]]```
\end{itemize}


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0A%5B%5B+nodiscard(%22Must+be+checked%22)+%5D%5D+static+int+foo()%0A%7B%0A++return+5%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++foo()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%0Astruct+Bar+%7B%0A++%5B%5B+nodiscard+%5D%5DBar()+%7B%7D%0A%7D%3B%0A%0Aint+main()%0A%7B%0A%23if+0%0A++Bar+b%7B%7D%3B%0A%23else%0A++Bar%7B%7D%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0479}{https://wg21.link/P0479}
#addproposal{P0840}{https://wg21.link/P0840}
#addproposal{P1771}{https://wg21.link/P1771}
#addproposal{P1301}{https://wg21.link/P1301}


== Lambda}
\begin{itemize}
\item Utilisables dans des contextes non évalués

// Contextes non évalués : ```cpp sizeof()```, ```cpp typeid()``` ou ```cpp decltype()```}

\item Utilisation de paramètres templates pour les lambdas génériques
\begin{itemize}
\item En complément de la syntaxe avec ```cpp auto```
\item Permet de récupérer le type
\end{itemize}
\end{itemize}

#noteblock{Usage}
\begin{itemize}
\item Spécification de contraintes sur paramètres : types identiques, itérateur, ...
\end{itemize}
\end{block}

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


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Aint+main()%0A%7B%0A++auto+foo+%3D+%5B%5D%3Ctypename+T%3E(std::vector%3CT%3E+vec)+%7B+return+std::size(vec)%3B+%7D%3B%0A%0A++std::cout+%3C%3C+foo(std::vector%3Cint%3E%7B1,+2,+3%7D)+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+foo(std::vector%3Cdouble%3E%7B1.,+2.%7D)+%3C%3C+%22%5Cn%22%3B%0A%23if+0%0A++std::cout+%3C%3C+foo(5)+%3C%3C+%22%5Cn%22%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%0Aint+main()%0A%7B%0A++auto+foo+%3D+%5B%5D%3Ctypename+T%3E(T+first,+T+second)+%7B+return+first+%2B+second%3B+%7D%3B%0A%0A++std::cout+%3C%3C+foo(1,+5)+%3C%3C+%22%5Cn%22%3B%0A%23if+0%0A++std::cout+%3C%3C+foo(1.,+5)+%3C%3C+%22%5Cn%22%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0315}{https://wg21.link/P0315}
#addproposal{P0428}{https://wg21.link/P0428}



== Lambda}
\begin{itemize}
\item Lambda \textit{stateless} assignables et constructibles par défaut

// \textit{stateless}, c'est à dire qui ne capture rien}
\end{itemize}

```cpp
		auto greater = [](auto x,auto y) { return x > y; };

		map<string, int, decltype(greater)> foo;
```

\begin{itemize}
\item Dépréciation de la capture implicite de ```cpp this``` par ```cpp [=]```
\begin{itemize}
\item Capture explicite par ```cpp [=, this]```

// ```cpp this``` est capturé par référence}

\item Capture implicite par ```cpp [&]``` toujours présente
\end{itemize}
\item Capture de \textit{structured binding}
\end{itemize}

#addproposal{P0624}{https://wg21.link/P0624}
#addproposal{P0409}{https://wg21.link/P0409}



== Lambda}
\begin{itemize}
\item Expansion des \textit{parameter packs} lors de la capture
\end{itemize}

```cpp
		template<class F, class... Args>
		auto delay_invoke(F f, Args... args) {
		  return [f=move(f),...args=move(args)]()->decltype(auto) {
		    return invoke(f, args...);
		  }
		}
```

\begin{itemize}
\item Peuvent être ```cpp consteval```
\end{itemize}

#addproposal{P0780}{https://wg21.link/P0780}



== Binding}
\begin{itemize}
\item ```cpp std::bind_front()``` assigne les arguments fournis aux premiers paramètres de l'appelable
\end{itemize}

```cpp
		int foo(int a, int b, int c, int d) { return a * b * c + d; }

		auto baz = bind_front(&foo, 2, 3, 4);
		baz(7);  // 31

		// Equivalent a

		auto bar = bind(&foo, 2, 3, 4, _1);
		bar(6);  // 30
```

\begin{itemize}
\item ```cpp std::reference_wrapper``` accepte les types incomplets

// Exemple de types incomplets : \textit{forward declaration} ou types abstraits}
\end{itemize}


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Cfunctional%3E%0A%23include+%3Ciostream%3E%0A%0Aint+foo(int+a,+int+b,+int+c,+int+d)%0A%7B%0A++return+a+*+b+*+c+%2B+d%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::cout+%3C%3C+foo(2,+3,+4,+5)+%3C%3C+%22%5Cn%22%3B%0A%0A++auto+bar+%3D+std::bind(%26foo,+2,+3,+4,+std::placeholders::_1)%3B%0A++std::cout+%3C%3C+bar(6)+%3C%3C+%22%5Cn%22%3B%0A%0A++auto+baz+%3D+std::bind_front(%26foo,+2,+3,+4)%3B%0A++std::cout+%3C%3C+baz(7)+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0356}{https://wg21.link/P0356}
#addproposal{P0357}{https://wg21.link/P0357}


== ``` std::atomic```}
\begin{itemize}
\item ```cpp std::atomic<std::shared_ptr<T>>```
\item ```cpp std::atomic<>``` sur les types flottant
\item Initialisation par défaut de ```cpp std::atomic<>```
\item ```cpp std::atomic_ref``` applique des modifications atomiques sur des données non-atomiques qu'il référence
\item ```cpp wait()```, ```cpp notify_one()``` et ```cpp notify_all()``` pour attendre le changement d'état d'un ```cpp std::atomic```
\end{itemize}

#addproposal{P0718}{https://wg21.link/P0718}
#addproposal{P0020}{https://wg21.link/P0020}
#addproposal{P0883}{https://wg21.link/P0883}
#addproposal{P0019}{https://wg21.link/P0019}



== Thread}
\begin{itemize}
\item Nouvelle variante ```cpp std::jthread```
\begin{itemize}
\item Automatiquement arrêté et joint lors de la destruction
\end{itemize}
\end{itemize}

```cpp
		int main() { thread t(foo); }  // Erreur (terminate)
```

// Il faut rajouter un appel à ```cpp join()``` pour corriger ce problème}

```cpp
		int main() { jthread t(foo); } // OK
```

\begin{itemize}
\item [] \begin{itemize}
\item Peut être arrêté par l'appel à ```cpp request_stop()```
\end{itemize}
\end{itemize}

```cpp
		void foo(stop_token st) {
		  while(!st.stop_requested()) { ... }
		}

		jthread t(foo);
		...
		t.request_stop();
```


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cthread%3E%0A%23include+%3Cchrono%3E%0A%0Ausing+namespace+std::chrono_literals%3B%0A%0Avoid+foo(std::stop_token+st)%0A%7B%0A++while(!!st.stop_requested())%0A++%7B+%0A++++std::cout+%3C%3C+%22Foo%5Cn%22%3B%0A++++std::this_thread::sleep_for(500ms)%3B%0A++%7D%0A%7D%0A%0Aint+main()%0A%7B%0A++std::jthread+t(foo)%3B%0A++std::this_thread::sleep_for(2s)%3B%0A%0A++t.request_stop()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic+-pthread',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}

#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cthread%3E%0A%0Avoid+foo()%0A%7B%0A++std::cout+%3C%3C+%22Foo%5Cn%22%3B%0A%7D%0A%0Aint+main()%0A%7B%0A%23if+1%0A++std::jthread+t(foo)%3B%0A%23else%0A++std::thread+t(foo)%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic+-pthread',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P0660}{https://wg21.link/P0660}



== synchronisation -- sémaphores}
\begin{itemize}
\item ```cpp std::counting_semaphore```
\begin{itemize}
\item Création avec la valeur maximale de possesseurs
\item ```cpp max()``` retourne le nombre maximal de possesseurs
\item ```cpp release()``` relâche, une ou plusieurs fois, le sémaphore

// Incrémente le compteur de la valeur en paramètre, 1 par défaut}

\item ```cpp acquire()``` prend le sémaphore en attendant si besoin

// Décrémente le compteur de 1 en attendant tant qu'il est nul}

\item ```cpp try_acquire()``` tente de prendre le sémaphore et retourne le résultat de l'opération

// Décrémente le compteur de 1 s'il n'est pas nul et retourne ```cpp true``` dans ce cas, et ```cpp false``` si le compteur est nul}

\item ```cpp try_acquire_for()``` tente de prendre le sémaphore en attendant la durée donnée si besoin
\item ```cpp try_acquire_until()``` tente de prendre le sémaphore en attendant jusqu'à un temps donné si besoin
\end{itemize}
\item ```cpp std::binary_semaphore```	instanciation de ```cpp std::counting_semaphore``` pour un unique possesseur
\end{itemize}


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cthread%3E%0A%23include+%3Cchrono%3E%0A%23include+%3Csemaphore%3E%0A+%0Astd::binary_semaphore+signalMainToThread%7B0%7D%3B%0Astd::binary_semaphore+signalThreadToMain%7B0%7D%3B%0A%0Ausing+namespace+std::literals%3B%0A%0Avoid+foo()%0A%7B%0A++signalMainToThread.acquire()%3B%0A++std::cout+%3C%3C+%22%5Bthread%5D+Reception+du+signal%5Cn%22%3B%0A+%0A++std::this_thread::sleep_for(2s)%3B%0A+%0A++std::cout+%3C%3C+%22%5Bthread%5D+Envoi+a+main%5Cn%22%3B%0A++signalThreadToMain.release()%3B%0A%7D%0A+%0Aint+main()%0A%7B%0A++std::thread+worker(foo)%3B%0A++std::this_thread::sleep_for(2s)%3B%0A%0A++std::cout+%3C%3C+%22%5Bmain%5D+Envoi+au+thread%5Cn%22%3B%0A++signalMainToThread.release()%3B%0A++signalThreadToMain.acquire()%3B%0A+%0A++std::cout+%3C%3C+%22%5Bmain%5D+Got+the+signal%5Cn%22%3B+//+response+message%0A++worker.join()%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic+-pthread',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P1135}{https://wg21.link/P1135}



== synchronisation -- latch}
\begin{itemize}
\item ```cpp std::latch``` compteur descendant permettant de bloquer des threads tant qu'il n'a pas atteint zéro
\begin{itemize}
\item Création avec la valeur initiale du compteur
\item ```cpp count_down()``` décrémente le compteur
\item ```cpp try_wait()``` indique si le compteur a atteint zéro
\item ```cpp wait()``` attend jusqu'à ce que le compteur atteigne zéro
\item ```cpp arrive_and_wait()``` décrémente le compteur et attend qu'il atteigne zéro
\end{itemize}
\end{itemize}

#alertblock{Pas d'incrément}
\begin{itemize}
\item Impossible d'incrémenter un ```cpp std::latch``` et de revenir à sa valeur initiale
\end{itemize}
\end{alertblock}


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Clatch%3E%0A%23include+%3Cthread%3E%0A%0Aint+main()%0A%7B%0A++const+size_t+nbLatch+%3D+5%3B%0A++std::latch+l1(nbLatch)%3B%0A++std::latch+l2(1)%3B%0A%0A++auto+work+%3D+%5B%26%5D+(int+i)%0A++++++++++++++%7B%0A++++++++++++++++std::cout+%3C%3C+%22Entree+foo%22+%3C%3C+i+%3C%3C+%22%5Cn%22%3B%0A++++++++++++++++l1.count_down()%3B%0A++++++++++++++++l2.wait()%3B%0A++++++++++++++++std::cout+%3C%3C+%22Sortie+foo%22+%3C%3C+i+%3C%3C+%22%5Cn%22%3B%0A++++++++++++++%7D%3B%0A%0A++std::cout+%3C%3C+%22Demarrage%5Cn%22%3B%0A++std::jthread+t%5BnbLatch%5D%3B%0A++for(size_t+i+%3D+0%3B+i+%3C+nbLatch%3B+%2B%2Bi)%0A++%7B%0A++++t%5Bi%5D+%3D+std::jthread(work,+i)%3B%0A++%7D%0A%0A++l1.wait()%3B%0A++std::cout+%3C%3C+%22Thread+OK%5Cn%22%3B%0A++l2.count_down()%3B%0A%7D'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic+-pthread',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P1135}{https://wg21.link/P1135}



== synchronisation -- barrière}
\begin{itemize}
\item ```cpp std::barrier``` attend qu'un certain nombre de threads n'atteigne la barrière
\begin{itemize}
\item Création avec le nombre de threads attendus
\item ```cpp arrive()``` décrémente le compteur
\item ```cpp wait()``` attend que le compteur atteigne zéro
\item ```cpp arrive_and_wait()``` décrémente le compteur et attend qu'il atteigne zéro
\item ```cpp arrive_and_drop()``` décrémente le compteur ainsi que la valeur initiale
\item Une fois zéro atteint, les threads en attente sont débloqués et le compteur reprend la valeur initiale décrémentée du nombre de threads "\textit{droppés}"
\end{itemize}
\end{itemize}


#codesample{https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:'%23include+%3Ciostream%3E%0A%23include+%3Cbarrier%3E%0A%23include+%3Cthread%3E%0A%0Aint+main()%0A%7B%0A++const+size_t+nb+%3D+5%3B%0A++std::barrier+b(nb)%3B%0A%0A++auto+work+%3D+%5B%26%5D+(int+i)%0A++++++++++++++%7B%0A++++++++++++++++std::cout+%3C%3C+%22Entree+foo%22+%3C%3C+i+%3C%3C+%22%5Cn%22%3B%0A++++++++++++++++b.arrive_and_wait()%3B%0A++++++++++++++++std::cout+%3C%3C+%22Milieu+foo%22+%3C%3C+i+%3C%3C+%22%5Cn%22%3B%0A++++++++++++++++b.arrive_and_wait()%3B%0A++++++++++++++++std::cout+%3C%3C+%22Sortie+foo%22+%3C%3C+i+%3C%3C+%22%5Cn%22%3B%0A++++++++++++++%7D%3B%0A%0A++std::cout+%3C%3C+%22Demarrage%5Cn%22%3B%0A++std::jthread+t%5Bnb%5D%3B%0A++for(size_t+i+%3D+0%3B+i+%3C+nb%3B+%2B%2Bi)%0A++%7B%0A++++t%5Bi%5D+%3D+std::jthread(work,+i)%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B20+-Wall+-Wextra+-pedantic+-pthread',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4}


#addproposal{P1135}{https://wg21.link/P1135}



== Politique d'exécution}
\begin{itemize}
\item Nouvelle politique d'exécution vectorisé ```cpp std::unsequenced_policy```
\end{itemize}

#addproposal{P1001}{https://wg21.link/P1001}


== ``` std::coroutine``` -- Présentation}
\begin{itemize}
\item Fonction dont l'exécution peut être suspendue et reprise
\item Simplification du développement de code asynchrone
\item TS publié en juillet 2017
\end{itemize}

#addproposal{P0912}{https://wg21.link/P0912}



== ``` std::coroutine``` -- Définition}
\begin{itemize}
\item Fonctions contenant
\begin{itemize}
\item ```cpp co_await``` suspend l'exécution
\item ```cpp co_yield``` suspend l'exécution en retournant une valeur
\item ```cpp co_return``` termine la fonction
\end{itemize}

\item Restrictions
\begin{itemize}
\item Pas de ```cpp return```
\item Pas d'argument \textit{variadic}
\item Pas de déduction de type sur le retour
\item Pas sur les constructeurs, destructeurs, fonctions ```cpp constexpr```
\end{itemize}
\end{itemize}

#addproposal{P0912}{https://wg21.link/P0912}



== ``` std::coroutine``` -- Mécanismes}
\begin{itemize}
\item \textit{Promise} utilisée pour renvoyer valeurs et exceptions
\item \textit{Coroutine state} interne contenant promesse, paramètres, variables locales et état du point de suspension
\item \textit{Coroutine handle} non possédant pour poursuivre ou détruire la coroutine
\begin{itemize}
\item ```cpp operator bool()``` indique si le \textit{handle} gère effectivement une coroutine
\item ```cpp done()``` indique si la coroutine est suspendue dans son état final
\item ```cpp operator()``` et ```cpp resume()``` poursuit la coroutine
\item ```cpp destroy()``` détruit la coroutine
\end{itemize}
\item Spécialisation de \textit{coroutine handle} sur une \textit{promise}
\begin{itemize}
\item ```cpp promise()``` accès à la promesse
\end{itemize}
\end{itemize}

#addproposal{P0912}{https://wg21.link/P0912}

== ``` std::create_directory()```}
\begin{itemize}
\item Échec de ```cpp std::create_directory()``` si l'élément terminal existe et n'est pas un répertoire
\end{itemize}

```cpp
		create_directory("a/b/c");
		// C++17
		// Erreur si a ou b existe mais ne sont pas des repertoires
		// Pas d'erreur si c existe mais n'est pas un repertoire

		// C++20
		// Erreur dans les deux cas
```

#addproposal{P1164}{https://wg21.link/P1164}

== Constructeur de ``` std::variant```}
\begin{itemize}
\item Contraintes sur le constructeur et l'opérateur d'affectation de ```cpp std::variant```
\begin{itemize}
\item Pas de conversion en ```cpp bool```
\item Pas de \textit{narrowing conversion}
\end{itemize}
\end{itemize}

#addproposal{P0608}{https://wg21.link/P0608}



== ``` std::visit()```}
\begin{itemize}
\item Possibilité d'expliciter le type de retour de ```cpp std::visit()```
\begin{itemize}
\item Via un paramètre template
\item Sinon déduit de l'application du visiteur au premier paramètre
\end{itemize}
\end{itemize}

#addproposal{p0655}{https://wg21.link/p0655}
