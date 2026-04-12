#import "./model.typ": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

= Retour sur C++98 / C++03

== Rappels

=== Rappels historiques

- Années 80 -- "_C with classes_" par Bjarne Stroustrup aux Bell Labs
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

=== Philosophie du C++

- Multi-paradigme

// Procédural, objet, générique et Template meta-programming

- Typage statique déclaratif
- Généraliste
- Initialement, ajout des classes au C
- Vaste sous-ensemble commun (proche du C) entre C et C++
- _Zero-overhead abstraction_
- Compatibilité ascendante forte mais pas absolue
- Évolutions par les bibliothèques plutôt que par le langage
- Pas de "magie" dans la bibliothèque standard

=== Normalisation

- Normalisé par #link("http://www.open-std.org/JTC1/SC22/WG21/")[l'ISO (JTC1/SC22/WG21 #linklogo())]
- Comité distinct de celui du C

// C : Working group 14

- ... mais plusieurs membres en commun
- Pas de propriétaire du C++

// Donc libre de droit, mais la norme ISO définitive est payante

=== Normalisation

- Actualité de normalisation, et du C++ en général : #link("https://isocpp.org/")[isocpp.org #linklogo()]

#alertblock("isocpp.org n'est pas le site du comité", text[
  Site de la _Standard C++ Foundation_ dont le but est la promotion du C++

  Les deux sont cependant très proches et partagent de nombreux membres
])

- #link("https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines")[C++ Core Guidelines #linklogo()]
- #link("https://github.com/cplusplus")[Dépôt GIT #linklogo()] (brouillons et propositions)
- Conférence annuelle #link("http://cppcon.org/")[cppcon #linklogo()]

=== Norme et support

- Compilateurs
  - GCC -- #link("https://gcc.gnu.org/projects/cxx-status.html")[C++ Standards Support in GCC #linklogo()]
  - Clang -- #link("http://clang.llvm.org/cxx_status.html")[C++ Support in Clang #linklogo()]
  - Visual studio -- #link("https://docs.microsoft.com/fr-fr/cpp/overview/visual-cpp-language-conformance?view=msvc-160")[Conformité du langage Microsoft C++ #linklogo()]
- Bibliothèques standards
  - GCC -- #link("https://gcc.gnu.org/onlinedocs/libstdc++/manual/status.html")[status.html #linklogo()]
  - Clang -- #link("https://libcxx.llvm.org/")[C++ Standard Library #linklogo()]
- Vision globale -- #link("http://en.cppreference.com/w/cpp/compiler_support")[C++ compiler support #linklogo()]

#noteblock("Sites de référence C++", text[
  #link("https://en.cppreference.com/w/")[cppreference.com #linklogo()]

  #link("https://hackingcpp.com/")[hacking C++ #linklogo()]
])

== Gestion des erreurs

=== Erreurs -- Code retour

- Plusieurs variantes
  - Type de retour dédié
  - Valeur particulière notant un échec (```cpp NULL```, ```cpp -1```)
  - Récupération de la dernière erreur (```cpp errno```, ```cpp GetLastError()```)
- Nécessite "un test toutes les deux lignes"
- Gestion manuelle de la remontée de la pile d'appel
- Adapté au traitement local des erreurs, pas au traitement "plus haut"

#alertblock("Problèmes et limites", text[
  Impact négatif sur la lisibilité

  Souvent délaissée dans un contexte d'enseignement ou de formation

  Beaucoup de code avec une gestion d'erreurs déficiente
])

=== Erreurs -- Exceptions

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

=== Erreurs -- Exceptions

- Type quelconque
- Idéalement héritant de ```cpp std::exception``` (via ```cpp std::logic_error```, ```cpp std::runtime_error``` ou autres)
- ```cpp catch(...)``` pour attraper les exceptions de tout type
- Compatibles avec le _stack unwinding_
- Pas de ```cpp finally```
- Appel de ```cpp std::terminate()``` si une exception n'est pas attrapée
- Utilisées par la bibliothèque standard (p.ex. ```cpp std::bad_alloc```)

=== Erreurs -- Critiques des exceptions

- Critiquées, parfois interdites (p.ex. : #link("https://google.github.io/styleguide/cppguide.html")[Google C++ Style Guide #linklogo()])
  - Impact négatif sur les performances

#noteblock("Plus vraiment", text[
  Actuellement, une exception non levée ne coûte quasiment rien
])

#list(marker: [], list(indent: 7pt, "Mauvais support par les différents outils"))

#noteblock("À nuancer", text[
  Correctement supportées par les compilateurs actuels

  Inégalement gérées par les outils d'analyse, de documentation, ...
])

#list(
  marker: [],
  list(indent: 7pt, "Code plus complexe à analyser"),
  //Complexité discutable : il faut une vision plus globale, donc plus complexe, pour suivre un programme. Mais le code local est plus simple vu qu'il n'est pas noyé de code dédié à la gestion d'erreurs
  list(indent: 7pt, "Difficiles à introduire dans une large base de code sans exception"),
  // Argument de la difficulté d'introduction à nuancer toutefois avec la levée d'exception par la bibliothèque standard qui a lieu dans tous les cas (hors options particulières du compilateur)
  list(indent: 7pt, "Absence d'ABI normalisée"),
  //Le problème d'ABI est plus large que les seules exceptions
)

=== Erreurs -- Exception safety

- _No-throw guarantee_ : l'opération ne peut pas échouer

#adviceblock("Do", text[
  Destructeurs et ```cpp swap()``` ne doivent pas lever d'exception
])

- _Strong exception safety_ : pas d'effet de bord, pas de fuite, état conservé
- _Basic exception safety_ : pas de fuite, invariants conservés
- _No exception safety_ : aucune garantie

=== Erreurs -- Exception safety

#adviceblock("Do", text[
  Privilégiez les garanties les plus fortes possibles
])

#alertblock("Don't", text[
  Évitez la _Basic exception safety_
])

#alertblock("Don't", text[
  Évitez absolument le _No exception safety_
])

=== Erreurs -- Exception safety

#adviceblock("Do", text[
  Utilisez l'idiome _copy-and-swap_ pour implémenter la _Strong exception safety_
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
=== Erreurs -- Exceptions et bonnes pratiques

#adviceblock("Do", text[
  _Throw by value, catch by const reference_ (voir _C++ Coding Standards_)
])

#adviceblock(text[Do, _throw_], text[
  Lancez des exceptions standards lorsqu'elles sont pertinentes

  Définissez vos propres exceptions sinon
])

#adviceblock("Do, définition", text[
  Héritez de ```cpp std::runtime_error ```

  Définissez des hiérarchies peu profondes et compactes
])

#adviceblock("Do", text[
  Capturez uniquement là où vous savez traiter l'erreur
])

#alertblock("Don't", text[
  N'utilisez jamais les exceptions pour contrôler le flux d'exécution
])

=== Erreurs -- ```cpp assert```

- Arrête le programme si l'expression est évalué à 0
- Affiche au moins l'expression, le fichier et la ligne

```cpp
assert(expression);
```

- Sans effet lorsque ```cpp NDEBUG``` est défini
  - Coût nul en _Release_
  - Inutilisable pour les erreurs d'exécution et le contrôle des entrées

#noteblock("Objectifs", text[
  Traquer les erreurs de programmation et les violations de contrat interne
])

#alertblock("Don't", text[
  Jamais d'```cpp assert``` pour les erreurs d'exécution et le contrôle des entrées
])

=== Erreurs -- Conclusion

#adviceblock(text[Do, exception/code retour vs. ``` assert```], text[
  Utilisez exceptions et codes retour pour les erreurs d'exécution

  Réservez ```cpp assert``` aux erreurs de programmation et aux violations de contrats
])

#adviceblock("Do, exception vs. code retour", text[
  Codes retour pour les erreurs traitées localement (par l'appelant)

  Exceptions pour les erreurs non-récupérables ou au traitement lointain
])

== Gestion des ressources

=== Ressources -- Gestion manuelle

#questionblock(" Comment gérer les erreurs ?", none)

- Solution C : _Single Entry Single Exit_, bloc unique de libération

```cpp
char* memory = malloc(50);
if(!memory) goto err;
...
err:
free(memory);
```

#list(marker: [], list(indent: 5pt, "Laborieux"), list(
  indent: 5pt,
  "Difficile à mettre en place en présence d'exceptions",
))

=== Ressources -- Gestion manuelle

#questionblock("Quiz : Comment éviter les fuites mémoires ?", ```cpp
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

=== Ressources -- Gestion manuelle

#questionblock("Comment copier les classes possédant des ressources ?", none)

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

=== Ressources -- Bonnes pratiques

#adviceblock("Do", text[
  Si une classe manipule une ressource brute, elle doit
  - Soit définir constructeur de copie et opérateur d'affectation
  - Soit les déclarer privés sans les définir (classe non copiable)
])

#adviceblock(text[_Big Rule of three_], text[
  Si vous devez définir le constructeur de copie, l'opérateur d'affectation ou le destructeur, alors vous devriez définir les trois
])

// Forme canonique orthodoxe de Coplien
// Thèse de Coplien : Multi-paradigm Design

=== Ressources -- RAII

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
  Utilisez RAII pour vos objets
])

=== Ressources -- RAII

#adviceblock("Do", text[
  Faites des constructeurs qui construisent des objets
  - Cohérents
  - Utilisables
  - Complètement initialisés
])

#alertblock("Don't", text[
  Évitez les couples constructeur vide et fonction d'initialisation
])

#alertblock("Don't", text[
  Évitez les couples constructeur vide et ensemble de mutateurs
])

=== Ressources -- Limites du RAII

#alertblock("Gestion des erreurs", text[
  Pas d'erreur ni d'exception dans les destructeurs

  La libération peut échouer (p.ex. ```cpp flush()``` lors de la fermeture de fichier)

  ```cpp
  {
    ifstream src("input.txt");
    ofstream dst("output.txt");
    copy_files(src, dst);
  }

  remove_file(src);  // Potentielle perte de donnees
  ```

  //Problème résolu en forçant l'écriture (flush) en fin de la fonction copy_files() et en remontant une exception en cas d'erreur
])

=== Ressources -- Limites du RAII

#alertblock(```cpp std::auto_ptr```, text[
  Copiable, la copie transfère la responsabilité de la ressource

  ```cpp
  void foo(auto_ptr<int> bar) {}

  auto_ptr<int> bar(new int(5));
  foo(bar);
  cout << *bar << "\n";  // Erreur : bar n'est plus utilisable
  ```
])

=== Ressources -- Loi de Déméter

// À strictement parler, gestion de l'accès aux ressources pas de la libération

- Principe de connaissance minimale
- Un objet ```cpp A``` peut utiliser les services d'un deuxième objet ```cpp B```
- ... mais ne doit pas utiliser ```cpp B``` pour accéder à un troisième objet
- En particulier, une classe n'expose pas ses données

#noteblock("Exceptions", text[
  Agrégats et conteneurs dont le rôle est de contenir des données

  // Agrégat désigne ici des classes, ou structures, qui agrègent un ensemble de données ensembles sans comportement ni invariant. Ce n'est pas exactement la même chose que l'aggregate du standard
  // Certains utilisent aussi le terme d'agglomérat, ce qui évite la confusion
])

#noteblock("Objectifs", text[
  Mise en place du RAII

  Meilleure encapsulation

  Respect des _patterns_ SOLID et GRASP

  Meilleure lisibilité, maintenabilité et ré-utilisabilité
  // Notamment le principe ouvert-fermé, l'inversion de dépendance et le couplage faible
  // GRASP : General Responsibility Assignment Software Patterns (ou Principles)
  // SOLID : SRP, OCP, LSP, ISP, DIP
  // SRP : principe de responsabilité unique
  // OCP : principe ouvert/fermé
  // LSP : Principe de substitution de Liskov
  // ISP : Principe de ségrégation des interfaces
  // DIP : Principe d'inversion des dépendances
])

=== Ressources -- Loi de Déméter

#adviceblock("Do, agrégats", text[
  Préférez les structures aux classes

  Laissez les membres publics

  Fournissez, éventuellement, des constructeurs initialisant les données
])

#adviceblock("Do, conteneurs", text[
  Respectez l'interface et la logique des conteneurs standards
])

#adviceblock("Do, classes de service", text[
  Exposez des services, pas des données

  Pas de données publiques

  Limitez les accesseurs et les mutateurs
])

=== Ressources -- Loi de Déméter

#noteblock("Conseils", text[
  N'hésitez pas à étendre l'interface de classe avec des fonctions libres

  Pensez à l'amitié pour cette interface étendue

  Implémentez-la en terme de fonctions membres (p.ex. ```cpp +``` à partir de ```cpp+=```)

  ```cpp
  class Foo {
  public:
    Foo& operator+=(const Foo& other);
  };

  Foo operator+(Foo lhs, const Foo& rhs) {
    return lhs += rhs;
  }
  ```
])

=== Ressources -- Et le Garbage Collector ?

- Pas de GC dans le langage ni dans la bibliothèque standard
- Au moins un GC en bibliothèque tierce (#link("http://www.hboehm.info/gc/")[Hans Boehm #linklogo()])
- ... mais limité par manque de support par le langage
- Non déterministe : adapté à la mémoire pas aux autres ressources
- Particulièrement adapté à la gestion des structures cycliques
- D'autres avantages pour la mémoire (compactage, recyclage, ...)

// Mais ces fonctionnalités évoluées des GC ne sont probablement pas compatibles avec le fonctionnement du C++

#noteblock("Wait and see", text[
  Un complément à RAII, pas un concurrent ni un remplaçant

  Indisponible à ce jour
])

=== Ressources -- Conclusion

#adviceblock("Do, RAII", text[
  Préférez les classes RAII de la bibliothèque standard aux ressources brutes

  Encapsulez les ressources dans des capsules RAII standards

  Concevez vos classes en respectant le RAII
])

#adviceblock("Do, Déméter", text[
  Respectez Déméter
])

=== Ressources -- Conclusion

#alertblock("Don't", text[
  Pas de ```cpp delete``` dans le code applicatif
])

#alertblock("Attention", text[
  Sous Linux, méfiez-vous de l'_Optimistic Memory Allocator_

  // Retourne une adresse lors d'un new ou d'un malloc() sans allocation et avec peu de contrôle
  // Allocation uniquement lors de l'usage de la mémoire
  // Si manque de mémoire à ce moment : une application est tuée (probablement le demandeur ou la plus gourmande, influence du uptime, de la priorité ou du propriétaire ?) mais jamais init
  // Pourquoi OMA : les logiciels demandent plus de mémoire que ce qu'ils utilisent réellement

  Pensez à paramétrer correctement l'OS
])

== STL

=== STL -- Standard Template Library

- Partie de la bibliothèque standard comprenant
  - Conteneurs et ```cpp std::basic_string```
  - Itérateurs
  - Algorithmes manipulation les données des conteneurs via les itérateurs

#noteblock("Note", text[
  Quelques algorithmes manipulant directement des données (```cpp std::min()```)
])

- Conçue initialement par Alexander Stepanov
  - Promoteur de la programmation générique

  // Programmation générique : template en C++, generic en Java
  // Programmation générique = polymorphisme paramétrique

  - Sceptique vis à vis de la POO

// Pour Stepanov : POO = hoax (canular)
// Stepanov ne s'oppose pas à l'abstraction et à encapsulation mais à la façon dont la POO prétend y répondre

- Basée sur les templates, pas sur la POO

=== STL -- Standard Template Library

#noteblock("Intérêts", text[
  $n$ conteneurs et $m$ algorithmes, seulement $m$ implémentations

  Tout nouvel algorithme est disponible sur tous les conteneurs compatibles

  Tout nouveau conteneur bénéficie de tous les algorithmes compatibles

  Changement de conteneur à effort réduit
])

#noteblock("Pour aller plus loin", text[
  Voir _Effective STL_ de Scott Meyers
])

=== STL -- Standard Template Library

#noteblock("À nuancer", text[
  Algorithmes membres sur certains conteneurs
  - Accès par itérateurs insuffisant (p.ex. ```cpp std::list```)
  - Habitudes et historiques (p.ex. ```cpp std::string```)
  - Performances (p.ex. ```cpp std::map.find()```)
])

== STL -- Conteneurs

=== STL Conteneurs -- Généralités

- Contiennent des objets copiables et non constants
- ... qui peuvent être les adresses d'autres objets

#alertblock("Conteneurs de pointeurs", text[
  Pas de libération automatique des objets pointés
])

- ... accessibles via un itérateur
- Fourniture possible d'une politique d'allocation
- Vu des algorithmes, ce qui fournit une paire d'itérateurs, est un conteneur

=== STL Conteneurs -- Conteneurs séquentiels

- ```cpp std::vector```
  - Tableau de taille variable d'éléments contigus
  - Accès indexé
  - Croissance en temps amorti
  - Modifications en fin de vecteur (coûteux ailleurs)
  - Compatible avec l'organisation mémoire des tableaux C

#alertblock(text[``` std::vector<bool>``` n'est pas un vecteur de booléen], text[
  Ne remplit pas tous les pré-requis des conteneurs

  ```cpp operator[]``` ne retourne pas le booléen mais un _proxy_ vers celui-ci

  Voir _Effective STL_ item 18
])

=== STL Conteneurs -- Conteneurs séquentiels

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

=== STL Conteneurs -- Conteneurs séquentiels

- ```cpp std::string```
  - Alias de ```cpp std::basic_string<char>```
  - Stockage de chaînes de caractères
  - Manipulation de _bytes_ et non de caractères encodés

#alertblock(text[```cpp std::string``` et UTF-8], text[
  ```cpp length()``` et ```cpp size()``` retournent le nombre de _bytes_, pas de caractères
])

#list(marker: [], list(indent: 5pt, "Contiguïté non garantie, mais respectée en pratique"), list(
  indent: 5pt,
  text[Variante ```cpp std::wstring``` pour les caractères larges],
))

#alertblock("API trop riche", text[
  Voir #link("http://www.gotw.ca/gotw/084.htm")[GotW \#84 : Monoliths "Unstrung" #linklogo()]
])

=== STL Conteneurs -- Conteneurs associatifs

- Quatre saveurs
  - ```cpp std::map``` -- clés-valeurs, ordonné par la clé, unicité des clés
  - ```cpp std::multimap``` -- clés-valeurs, ordonné par la clé, multiplicité des clés
  - ```cpp std::set``` -- valeurs ordonnées et uniques
  - ```cpp std::multiset``` -- valeurs ordonnées et non-uniques

#noteblock("Implémentation", text[
  Pas des tables de hachage

  Généralement des arbres binaires de recherche balancés
  // red-black tree le plus souvent
])

- Critère d'ordre - #highlight[strict] - configurable (strictement inférieur par défaut)

- Algorithmes membres (recherche) pour les performances

=== STL Conteneurs -- Adaptateurs

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

=== STL Conteneurs -- Adaptateurs

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:4,endLineNumber:9,positionColumn:4,positionLineNumber:9,selectionStartColumn:4,selectionStartLineNumber:9,startColumn:4,startLineNumber:9),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cstack%3E%0A%0Aint+main()%0A%7B%0A++std::stack%3Cint,+std::vector%3Cint%3E+%3E+foo%3B%0A++for(int+i%3D0%3B+i%3C5%3B+%2B%2Bi)%0A++%7B%0A++++foo.push(i)%3B%0A++%7D%0A%0A++while(!!foo.empty())%0A++%7B%0A++++std::cout+%3C%3C+!'+!'+%3C%3C+foo.top()%3B%0A++++foo.pop()%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B98+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    stack<int, vector<int> > foo;
    for(int i=0; i<5; ++i) foo.push(i);

    // Affiche 4 3 2 1 0
    while(!foo.empty()) {
      cout << ' ' << foo.top();
      foo.pop();
    }
    ```
  ],
)

=== STL Conteneurs -- conteneurs non-STL

- ```cpp std::bitset```
  - Tableau de bits de taille fixe
  - Conçu pour réduite l'empreinte mémoire
  - Pas d'itérateur ni d'interface STL

#noteblock(text[``` std::bitset``` vs. ``` std::vector<bool>```], text[
  Objectif de gain mémoire adressé par ```cpp std::bitset```, pourquoi ```cpp std::vector<bool>``` n'est-il pas un vrai conteneur de booléen ?
])

=== STL Conteneurs -- conteneurs non-STL

- Conteneurs non-standards
  - Listes simplement chaînées
  - Tables de hachage
  - Tableaux de taille fixe
  - Tampons circulaires
  - Arbres et graphes
  - Variantes de conteneurs STL

// Variantes ciblant un autre compromis : listes en tableau, ropes, map à plat, ...

=== STL Conteneurs -- ```cpp std::pair```

- Couple de deux valeurs
- Pas un conteneur
  - Type de retour de la recherche sur les ```cpp std::map``` (couple clé-valeur)
  - Candidat pour construire des vecteurs indexés par un non-numérique
- ```cpp std::make_pair``` construit une paire

=== STL Conteneurs -- Choix du conteneur

#adviceblock("Do, par défaut", text[
  ```cpp std::string``` pour les chaînes de caractères

  ```cpp std::vector```
])

#adviceblock("Do, performances", text[
  Mesurez avec des données réelles sur la configuration cible
])

#alertblock("Flux d'octets", text[
  Utilisez ```cpp std::vector<unsigned char>```

  Pas ```cpp std::vector<char>``` encore moins ```cpp std::string```
])

=== STL Conteneurs -- Choix du conteneur

#noteblock("Conseils", text[
  Voir _Effective STL_ item 1

  Voir #link("https://hackingcpp.com/cpp/design/which_std_sequence_container.png")[Which C++ Standard Sequence Container should I use? #linklogo()]
])

#noteblock("Conseil", text[
  Pensez à ```cpp reserve()```
])

#noteblock("Conseil", text[
  Une insertion en vrac suivie d'un tri peut être plus efficace qu'une insertion en place
])

#noteblock("Conseil", text[
  Un vecteur de paires peut être un bon choix pour un ensemble de clés-valeurs
])

== STL -- Itérateurs

=== STL Itérateurs -- Généralités

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
  Pointent un élément après le dernier

  Ne doivent pas être déréférencés ni incrémentés
])

// Un élément après la fin permet de représenter des ensemble vide (si begin et end référence le même élément)

=== STL Itérateurs -- Catégories et opérations

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

=== STL Itérateurs -- Catégories et conteneurs

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

=== STL Itérateurs -- Itérateurs d'insertion

- Adaptateur d'itérateurs
- De type _Output_
- Insertion de nouveaux éléments
  - En queue : ```cpp back_inserter```
  - En tête : ```cpp front_inserter```
  - À la position courante : ```cpp inserter```

== STL -- Algorithmes

=== STL Algorithmes -- Foncteurs

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

=== STL Algorithmes -- Foncteurs

- Possèdent des données membres
- Foncteurs standards : ```cpp std::plus```, ```cpp std::minus```, ```cpp std::equal```, ```cpp std::less```, ...
- Constructibles
  - Depuis des pointeurs de fonctions : ```cpp std::prt_fun```
  - Depuis des fonctions membres : ```cpp std::mem_fun```, ```cpp std::mem_fun1```, ...
  - En niant d'autres foncteurs : ```cpp std::not1```, ```cpp std::not2```
  - En fixant des paramètres : ```cpp std::bind1st```, ```cpp std::bind2nd```

=== STL Algorithmes -- Prédicats

- Appelables retournant un booléen (ou un type convertible en booléen)
- Utilisés par de nombreux algorithmes
- De nombreux algorithmes utilisent un prédicat par défaut (p.ex. ```cpp <``` ou ```cpp ==```)

=== STL Algorithmes -- Parcours

- ```cpp std::for_each()``` parcourt un ensemble d'éléments
- ... et applique un traitement à chaque élément

```cpp
void print(int i) { cout << i << ' '; }

vector<int> foo{4, 5, 9 ,12};
for_each(foo.begin(), foo.end(), print);
```

- Version du _map_/_apply_ fonctionnel

=== STL Algorithmes -- Parcours

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

=== STL Algorithmes -- Recherche linéaire

- ```cpp std::find()``` recherche une valeur
- ... et retourne un itérateur sur celle-ci
- ... ou l'itérateur de fin si la valeur n'est pas présente

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:39,endLineNumber:12,positionColumn:39,positionLineNumber:12,selectionStartColumn:39,selectionStartLineNumber:12,startColumn:39,startLineNumber:12),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B4,+5,+9+,12%7D%3B%0A%0A++std::vector%3Cint%3E::iterator+it+%3D+find(foo.begin(),+foo.end(),+5)%3B%0A++std::cout+%3C%3C+*(it-1)+%3C%3C+!'+!'+%3C%3C+*it+%3C%3C+!'+!'+%3C%3C+*(it%2B1)+%3C%3C+!'%5Cn!'%3B%0A%0A++it+%3D+find(foo.begin(),+foo.end(),+19)%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+(it+%3D%3D+foo.end())+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo{4, 5, 9 ,12};

    find(foo.begin(), foo.end(), 5);   // itérateur sur foo[1]
    find(foo.begin(), foo.end(), 19);  // itérateur sur foo.end()
    ```
  ],
)

=== STL Algorithmes -- Recherche linéaire

- ```cpp std::find_if()``` recherche depuis un prédicat

#noteblock(text[Variantes ```cpp _if```], text[
  Les algorithmes suffixés par ```cpp _if``` utilisent un prédicat
])

- ```cpp std::find_first_of()``` recherche la première occurrence d'un élément
- ```cpp std::search()``` recherche la première occurrence d'un sous-ensemble
- ```cpp std::find_end()``` recherche la dernière occurrence d'un sous-ensemble
- ```cpp std::adjacent_find()``` recherche deux éléments consécutifs égaux
- ```cpp std::search_n()``` recherche la première suite de $n$ éléments consécutifs égaux à une valeur

=== STL Algorithmes -- Recherche dichotomique

#alertblock("Pré-requis", "L'ensemble doit être trié")

- ```cpp std::lower_bound()``` retourne un itérateur sur le premier élément non strictement inférieur à la valeur recherchée

// Formulation "n'est pas strictement inférieur" semble être une tournure compliquée pour supérieur ou égal, mais c'est précisément ce que fait la fonction et c'est important si on fourni un prédicat de comparaison

- ... et l'itérateur de fin si un tel élément n'existe pas

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:15,positionColumn:1,positionLineNumber:15,selectionStartColumn:1,selectionStartLineNumber:15,startColumn:1,startLineNumber:15),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B4,+5,+7,+9,+12%7D%3B%0A%0A++std::vector%3Cint%3E::iterator+it+%3D+std::lower_bound(foo.begin(),+foo.end(),+6)%3B%0A++std::cout+%3C%3C+*it+%3C%3C+!'%5Cn!'%3B%0A%0A++it+%3D+std::lower_bound(foo.begin(),+foo.end(),+9)%3B%0A++std::cout+%3C%3C+*it+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo{4, 5, 7, 9, 12};

    *lower_bound(foo.begin(), foo.end(), 6);  // 7
    *lower_bound(foo.begin(), foo.end(), 9);  // 9
    ```
  ],
)

=== STL Algorithmes -- Recherche dichotomique

- ```cpp std::upper_bound()``` retourne un itérateur sur le premier élément strictement supérieur à la valeur recherchée
- ```cpp std::equal_range()``` retourne la paire (```cpp std::lower_bound()```, ```cpp std::upper_bound()```)

#alertblock("Attention", text[
  Le résultat retourné peut ne pas être la valeur recherchée
])

- ```cpp std::binary_search()``` indique si l'élément cherché est présent

=== STL Algorithmes -- Recherche dichotomique

#alertblock("Attention", text[
  Pas de fonction de recherche dichotomique retournant l'élément cherché
])

```cpp
vector<int>::iterator foo(vector<int> vec, int val) {
  vector<int>::iterator it = lower_bound(vec.begin(),
                                         vec.end(), val);
  if(it != vec.end() && *it == val) return it;
  else return vec.end();
}

vector<int> bar{1, 5, 8, 13, 25, 42};
foo(bar, 12);  // vec.end
foo(bar, 13);  // itérateur sur 13
```

=== STL Algorithmes -- Comptage

- ```cpp std::count()``` compte le nombre d'éléments égaux à la valeur fournie

- ```cpp std::count_if()``` compte le nombre d'éléments satisfaisant le prédicat

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:19,positionColumn:1,positionLineNumber:19,selectionStartColumn:1,selectionStartLineNumber:19,startColumn:1,startLineNumber:19),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Abool+compare(int+nb)%0A%7B%0A++return+nb+%3E%3D+5%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B2,+5,+2,+1,+8,+8,+6,+2,+8,+8,+8,+2%7D%3B%0A%0A++std::cout+%3C%3C+std::count(foo.begin(),+foo.end(),+8)+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::count(foo.begin(),+foo.end(),+7)+%3C%3C+!'%5Cn!'%3B%0A%0A++std::cout+%3C%3C+std::count_if(foo.begin(),+foo.end(),+compare)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo{4, 5, 3, 9, 5, 5 ,12};

    count(foo.begin(), foo.end(), 5);  // 3
    count(foo.begin(), foo.end(), 2);  // 0
    ```
  ],
)

=== STL Algorithmes -- Comparaison

- ```cpp std::equal()``` teste l'égalité de deux ensembles (valeur et position)

#codesample(
  "https://godbolt.org/#z:OYLghAFBqd5QCxAYwPYBMCmBRdBLAF1QCcAaPECAMzwBtMA7AQwFtMQByARg9KtQYEAysib0QXACx8BBAKoBnTAAUAHpwAMvAFYTStJg1DIApACYAQuYukl9ZATwDKjdAGFUtAK4sGe1wAyeAyYAHI%2BAEaYxCBmAGykAA6oCoRODB7evnrJqY4CQSHhLFEx8baY9vkMQgRMxASZPn5cFVXptfUEhWGR0bEJCnUNTdmtQ109xaUDAJS2qF7EyOwc5gDMwcjeWADUJutuTkPEmKwH2CYaAIIbWzuY%2B4cAbpgOJBdXt2abDNteewObjEwBIhAQLE%2BNy%2BwQIuxYTGCEFmXxMAHYrDddrshugQCBXu9iEDYRddvxUOiLK1dgBWUi7AAcDLM6IAIgdMbcsfsMV9sdjcfjCURiYdSetsLsIvUqTT6UyWezOfyBUKUIs4UCgTiCHiQBFUJ4xIkEEwnm4derMABHLxiahGgB0UWASPm5OdrmRDJlxBdmDdDGRswtOrAa1pbgYEZVPMFevxaC8WsOVsTBqNBlopvN2sOu0dqCeHPWbOl9VD%2Bbcu1jUZja3WXOxyuhPKpqoT%2BpFH3FgjJfrlDPWLIZaOVTc7uv1ydTloL6sNxpzZrDC4ztvttCLAaDPs9qCd3o9ft37qraYLdejscn8enSc1a5ri6zJtX1cLFJLB3Lfov841teDZxtcLZohybZgbyzZqhmPZikc/aShWxIYvKDLMrsZgMpIE6wV2j4ps%2BD6ZsuuYkdadoOhSZ7Bh6tHHr69R0SGJHAbeBGkbOlEZku2YUZ%2BRY/mWqEAeGkY3o2sGtrcEFfBw8y0JwtK8H4HBaKQqCcJaljWDiizLI8Gw8KQBCaIp8wANYgLSGj6JwkhqRZWmcLwCggPZ5kaYppBwLASCYKobwpiQ5CUPUwAKMohiVEICCoAA7upploCwiR0Ew1QxSEtDxUl6maWlGX0DEUXMIkCgJQQpDFXQ0ShKwqy8HVpUAPIpvlyUuUFbzXMQUVuaQvXILU%2BDqbw/CCCIYjsFIMiCIoKjqD5pC6K0BhGCg1jWPoeARB5kDzKgiTVB5HAALS4r%2Bph6ZYXBcLsF0AOpiLQT3PUFBDEEwvCoK8xDEHgWCHT6xBeIIeBsAAKlmoPzAohkrHouLBDlcUJd13C8N9mCrKZiU/YkFlKSpzmrdpHDYMFyChcQuyqIycQXXEki7MAyDIIW30Q1ZoYQLpViWAyuCECQ%2Bw/Fwsw4yT8wIGcWAxD6Nl2Q5HBOaQhV/UNHlebLatmOTmmUzLPmzPMAOpM4khAA%3D%3D%3D",
  code: [
    ```cpp
    vector<int> foo{4, 5, 9, 12};
    vector<int> bar{4, 5, 12, 9};

    equal(foo.begin(), foo.end(), foo.begin());  // true
    equal(foo.begin(), foo.end(), var.begin());  // false
    ```
  ],
)

=== STL Algorithmes -- Comparaison

#alertblock("Attention", text[
  ```cpp std::equal()``` ne vérifie pas les tailles des deux ensembles
])

#noteblock(text[Et ```operator==``` ?], text[
  ```cpp operator==``` sur des conteneurs teste la taille et le contenu
])

#adviceblock("Do", text[
  Préférez ```cpp operator==``` à ```cpp std::equal()``` pour comparer un conteneur complet
])

=== STL Algorithmes -- Comparaison

- ```cpp std::mistmatch()``` retourne une paire d'itérateurs sur les premiers éléments différents

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:35,endLineNumber:8,positionColumn:35,positionLineNumber:8,selectionStartColumn:35,selectionStartLineNumber:8,startColumn:35,startLineNumber:8),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B4,+5,+9,+13%7D%3B%0A++std::vector%3Cint%3E+bar%7B4,+5,+12,+8%7D%3B%0A%0A++std::pair%3Cstd::vector%3Cint%3E::iterator,+std::vector%3Cint%3E::iterator%3E+res+%3D+std::mismatch(foo.begin(),+foo.end(),+bar.begin())%3B%0A++std::cout+%3C%3C+*(res.first)+%3C%3C+!'+!'+%3C%3C+*(res.second)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo{4, 5, 9, 13};
    vector<int> var{4, 5, 12, 8};

    mismatch(foo.begin(), foo.end(), bar.begin());  // 9 12
    ```
  ],
)

- ... ou l'itérateur de fin en cas d'égalité

=== STL Algorithmes -- Remplissage

- ```cpp std::fill()``` remplit l'ensemble avec la valeur fournie
- ```cpp std::fill_n()``` idem avec un ensemble défini par sa taille

#codesample(
  "https://godbolt.org/#z:OYLghAFBqd5QCxAYwPYBMCmBRdBLAF1QCcAaPECAMzwBtMA7AQwFtMQByARg9KtQYEAysib0QXACx8BBAKoBnTAAUAHpwAMvAFYTStJg1DIApACYAQuYukl9ZATwDKjdAGFUtAK4sGe1wAyeAyYAHI%2BAEaYxCDSAA6oCoRODB7evnoJSY4CQSHhLFEx0naYDilCBEzEBGk%2Bfly2mPY5DJXVBHlhkdGxtlU1dRmNCgOdwd2FvZIAlLaoXsTI7BzmAMzByN5YANQma25Oo8SYrPvYJhoAguub25h7BwBuZUTE55c3ZhsMW167%2BzcYmAJEICBYH2un2CBB2LCYwQgM0%2BJgA7FZrjs9ujPlisaN0CAQC8HCRATDzjt%2BKgILN9hirnidgSiTRaLRqKhUAA6KLARFzKlc7muJGkHaSMzItYMpkslALWGAwFC1AmACsFg0GoAIo83CqwBwdkb9SrqRqLFxdWaDibjablXaLZqzDanW57V6ParLWt3QdDat1W4GEb6bjsTqUZjsbK8fKSW9yYJKRaZZH8QRCSA2bQAPoMCDyiJMZAAa3zwSUNWinNQgukErW0vjWZzaC8SsDzq5lu16r1PtNjp7npdVoDBrtI%2BNPonbsHts9s%2BXvs1/qXw%2BDofDGdjaOjUIPONj7aJSbJBwpa2wqtp4skdP3jIT2aJne70/Hfc1A6HY5eqO37rpOW6Aau86/hYi4ASBkGAROm5wUGGq7qsL5YoeKKokeVwcHMtCcOqvB%2BBwWikKgnAGpY1jMgsSwPOsPCkAQmgEXM5YgOqGj6JwkikexlGcLwCggLxbHkQRpBwLASCYKoZRdiQ5CUNUwAKMohjNEICCoAA7mRLFoCwcR0EwrRaSEtC6QZZEUSZZn0DEGnMHECh6QQpCOXQ0ShKwKy8D5zkAPJdrZhlCQpZRXMQGkiaQ0XIJU%2BBkbw/CCCIYjsFIMiCIoKjqFJpC6I0BhGCg1jWPoeARGJkBzKgcStGJHAALQEvsOqmLRlgAJwABw7G1ADqYi0MNI0KQQxBMLwqAvMQxB4Fg9VisQXiCHgbAACpcrQa1zAoDHLHoBLBFZOl6ZF3C8DNmArCx%2BmzXE7GEcRgnFVRHDYIpyDKcQOyqANABsbUg5IOzAMgyA7BAM2beWMxwzRViWOKuCECQezfFwMx3W9cwIKcWAxGKXE8XxHACaQ9nzQlYkSYTVNmJ9FHfQTUkzHMi1JM4khAA%3D",
  code: [
    ```cpp
    vector<int> foo(4);

    fill(foo.begin(), foo.end(), 42);   // 42 42 42 42
    fill_n(back_inserter(foo), 4, 43);  // 43 43 43 43
    ```],
)

#noteblock("Constructeur", text[
  Remplissage des conteneurs séquentiels à la construction

  ```cpp
  vector<int> foo(4, 12);
  ```
])

=== STL Algorithmes -- Remplissage

- ```cpp std::generate()``` valorise les éléments à partir d'un générateur

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:2,endLineNumber:6,positionColumn:2,positionLineNumber:6,selectionStartColumn:2,selectionStartLineNumber:6,startColumn:2,startLineNumber:6),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Astatic+int+gen()%0A%7B%0A++static+int+i+%3D+0%3B%0A++i+%2B%3D+5%3B%0A++return+i%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo(4)%3B%0A++std::generate(foo.begin(),+foo.end(),+gen)%3B++//+5+10+15+20%0A++std::cout+%3C%3C+foo%5B0%5D+%3C%3C+!'+!'+%3C%3C+foo%5B1%5D+%3C%3C+!'+!'+%3C%3C+foo%5B2%5D+%3C%3C+!'+!'+%3C%3C+foo%5B3%5D+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B98+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    int gen() {
      static int i = 0;
      i += 5;
      return i;
    }

    vector<int> foo(4);
    generate(foo.begin(), foo.end(), gen);  // 5 10 15 20
    ```
  ],
)

- ```cpp std::generate_n()``` idem avec un ensemble défini par sa taille

=== STL Algorithmes -- Copie

- ```cpp std::copy()``` copie les éléments du début vers la fin

#codesample(
  "https://godbolt.org/#z:OYLghAFBqd5QCxAYwPYBMCmBRdBLAF1QCcAaPECAMzwBtMA7AQwFtMQByARg9KtQYEAysib0QXACx8BBAKoBnTAAUAHpwAMvAFYTStJg1DIApACYAQuYukl9ZATwDKjdAGFUtAK4sGe1wAyeAyYAHI%2BAEaYxCBmZqQADqgKhE4MHt6%2BekkpjgJBIeEsUTFxtpj2eQxCBEzEBBk%2BflzllWk1dQQFYZHRsfEKtfWNWS2Dnd1FJf0AlLaoXsTI7BzmAMzByN5YANQma25Og8SYrPvYJhoAguub25h7BwBumA4k55c3ZhsMW167%2BzcYmAJEICBYH2un2CBB2LCYwQgM0%2BJgA7FZrjsdoN0CAQC83sRATDzjt%2BKg0RYAKykHZmABstNRtK4ZjRABF9hibpi9ujPlisTi8QSiESDiS1tgdhE6lyBYLhShUAkAJ7UVCoAB0UWAiLmZM1WtcSNpStlyAA1gB9YJKerRCCy4gzZFrbmC7EEXHKrywwGAmVyqkWDQmKnsx5uQNgDg7WNRwPO8MWLjhyMBg7xuMJzNuINEkNsiOJrMJ3MHJPBixrdOl/Ox8NuBiN90Kjko3mUhVC70i15i4mCUnOiAADjdHsVfeVautFstAHc6ugNdrdfraeTjQxVwbnTu95Oe16fWg/fWCymwyW89n73fkyG07fK2Wc3HH9Xixm3w2P5eT41nWd6NlSzatlOvZngs/p/leIaSCB8Hlp%2B8FAVSyHRu%2BD7odW9JYTGAFfoWFiooR75Ni2qxtl2qKclC9GfBwcy0JwVK8H4HBaKQqCcNGljWNiCxLA86w8KQBCaCxcyWiAVIaPonCSJx0m8ZwvAKCAilSdxLGkHAsBIJgqivH6JDkJQdTAAoyiGBUQgIKgi5cRJaAsAkdBMFUdkhLQjnOVxPHuZ59AxDZzAJAoTkEKQIV0NEoSsCsvDxWFADyfoBS5akma8VzEDZGmkHlyA1PgXG8PwggiGI7BSDIgiKCo6h6aQugtAYRgoNY1j6HgERaZAcwqlUWkcAAtDi%2BzsqYgmWFwXA7BNADqYi0MtK0mQQxBMLwqAvMQxB4FgQ2msQXiCHgbAACqarQZ1zAoInLHoOLBL5DlOTl3C8DtmArBJi67Qk0msexqltXxHDYKZyDmcQOyqGO9ITfSkg7MAyDIDsEA7ZdlozLjAlWJYtK4IQJB7N8XAzH9YNzAgpxYDEppyQpSkcCppBBftxVaTpDOc2YkM8dD9N6a6pCHSkziSEAA%3D%3D%3D",
  code: [
    ```cpp
    vector<int> foo{4, 5, 9, 12};
    vector<int> bar;

    copy(foo.begin(), foo.end(), back_inserter(bar));
    ```
  ],
)

- ```cpp std::copy_backward()``` copie les éléments de la fin vers le début

=== STL Algorithmes -- Échange

- ```cpp std::swap()``` échange deux objets

```cpp
int x=10, y=20;   // x:10 y:20
swap(x,y);        // x:20 y:10
```

- ```cpp std::swap_ranges()``` échange des éléments de deux ensembles

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:14,positionColumn:1,positionLineNumber:14,selectionStartColumn:1,selectionStartLineNumber:14,startColumn:1,startLineNumber:14),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo+(5,10)%3B%0A++std::vector%3Cint%3E+bar+(5,33)%3B%0A%0A++std::cout+%3C%3C+bar%5B0%5D+%3C%3C+%22+%22+%3C%3C+bar%5B1%5D+%3C%3C+%22+%22+%3C%3C+bar%5B2%5D+%3C%3C+%22+%22+%3C%3C+bar%5B3%5D+%3C%3C+%22+%22+%3C%3C+bar%5B4%5D+%3C%3C+%22%5Cn%22%3B%0A++std::swap_ranges(foo.begin()+%2B+1,+foo.end()+-+1,+bar.begin())%3B%0A++std::cout+%3C%3C+bar%5B0%5D+%3C%3C+%22+%22+%3C%3C+bar%5B1%5D+%3C%3C+%22+%22+%3C%3C+bar%5B2%5D+%3C%3C+%22+%22+%3C%3C+bar%5B3%5D+%3C%3C+%22+%22+%3C%3C+bar%5B4%5D+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B98+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo (5,10); // foo: 10 10 10 10 10
    vector<int> bar (5,33); // bar: 33 33 33 33 33

    swap_ranges(foo.begin()+1, foo.end()-1, bar.begin());
    // foo : 10 33 33 33 10
    // bar : 10 10 10 33 33
    ```
  ],
)

- ```cpp std::iter_swap()``` échange deux objets pointés par des itérateurs

=== STL Algorithmes -- Remplacement

- ```cpp std::replace()``` remplace toutes les occurrences d'une valeur

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:32,positionColumn:1,positionLineNumber:32,selectionStartColumn:1,selectionStartLineNumber:32,startColumn:1,startLineNumber:32),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Astatic+bool+check(int+a)%0A%7B%0A++return+a+%3E%3D+7%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B4,+5,+7,+9+,12,+5%7D%3B%0A++++std::replace(foo.begin(),+foo.end(),+5,+8)%3B%0A++++for(size_t++i+%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++++%7B%0A++++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+!'+!'%3B%0A++++%7D%0A++++std::cout+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B4,+5,+7,+9+,12,+5%7D%3B%0A++++std::replace_if(foo.begin(),+foo.end(),+check,+8)%3B%0A++++for(size_t++i+%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++++%7B%0A++++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+!'+!'%3B%0A++++%7D%0A++++std::cout+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo{4, 5, 7, 9 ,12, 5};

    replace(foo.begin(), foo.end(), 5, 8);  // 4 8 7 9 12 8
    ```
  ],
)

- ```cpp std::replace_if()``` remplace toutes les éléments vérifiant le prédicat

=== STL Algorithmes -- Remplacement

- ```cpp std::replace_copy()``` copie les éléments d'un ensemble en remplaçant toutes les occurrences d'une valeur

#noteblock(```cpp _copy```, text[
  Les algorithmes suffixés par ```cpp _copy``` fonctionnent comme l'algorithme de base en troquant la modification en place contre une copie du résultat
])

- ```cpp std::replace_copy_if()``` copie les éléments d'un ensemble en remplaçant toutes les éléments vérifiant le prédicat

=== STL Algorithmes -- Suppression

- ```cpp std::remove()``` élimine les éléments égaux à une valeur donnée

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:26,positionColumn:1,positionLineNumber:26,selectionStartColumn:1,selectionStartLineNumber:26,startColumn:1,startLineNumber:26),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Astatic+void+print(int+a)%0A%7B%0A++std::cout+%3C%3C+a+%3C%3C+!'+!'%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B4,+5,+5,+5,+7,+9,+9,+5%7D%3B%0A%0A++std::vector%3Cint%3E::iterator+it+%3D+std::remove(foo.begin(),+foo.end(),+5)%3B%0A++std::for_each(foo.begin(),+it,+print)%3B%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%0A%23if+0%0A++for(size_t+i++%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo{4, 5, 5, 5, 7, 9, 9, 5};

    remove(foo.begin(), foo.end(), 5);    // 4 7 9 9 ...
    ```
  ],
)

#alertblock("Pas de suppression", text[
  Ramène les éléments à conserver vers le début de l'ensemble

  Retourne l'itérateur correspond à la nouvelle fin
])

// std::remove() ne supprime pas car les algorithmes ne peuvent pas modifier le conteneur, en particulier sa taille, mais seulement son contenu

#noteblock(text[Idiome _Erase-Remove_], text[
  Suppression via un appel à ```cpp erase()``` après le nouvel itérateur de fin

  #codesample(
    "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:16,positionColumn:1,positionLineNumber:16,selectionStartColumn:1,selectionStartLineNumber:16,startColumn:1,startLineNumber:16),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B4,+5,+5,+5,+7,+9,+9,+5%7D%3B%0A%0A++foo.erase(std::remove(foo.begin(),+foo.end(),+5),+foo.end())%3B%0A++for(size_t+i++%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
    code: [
      ```cpp
      foo.erase(remove(foo.begin(), foo.end(), 5), foo.end());
      ```
    ],
  )
])

=== STL Algorithmes -- Suppression

- ```cpp std::remove_if()``` élimine les éléments vérifiant le prédicat
- ```cpp std::remove_copy()``` copie les éléments différents d'une valeur donnée
- ```cpp std::remove_copy_if()``` copie les éléments ne vérifiant pas le prédicat

=== STL Algorithmes -- Suppression des doublons

- ```cpp std::unique()``` élimine les éléments consécutifs égaux sauf le premier

// Tout comme remove, les éléments ne sont pas supprimés du conteneur mais déplacé à la fin et l'itérateur correspondant est renvoyé
// L'ordre relatif est préservé, important si la comparaison ne se fait que sur une partie d'un élément composite

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:26,positionColumn:1,positionLineNumber:26,selectionStartColumn:1,selectionStartLineNumber:26,startColumn:1,startLineNumber:26),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Astatic+void+print(int+a)%0A%7B%0A++std::cout+%3C%3C+a+%3C%3C+!'+!'%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B4,+5,+5,+5,+7,+9,+9,+5%7D%3B%0A%0A++std::vector%3Cint%3E::iterator+it+%3D+std::unique(foo.begin(),+foo.end())%3B%0A++std::for_each(foo.begin(),+it,+print)%3B%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%0A%23if+0%0A++for(size_t+i++%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo{4, 5, 5, 5, 7, 9, 9, 5};

    unique(foo.begin(), foo.end());  // 4 5 7 9 5 ...
    ```
  ],
)

- ```cpp std::unique_copy()``` copie l'ensemble en ne conservant que le premier des éléments consécutifs égaux

=== STL Algorithmes -- Transformation

- ```cpp std::transform()``` transforme les éléments d'un ensemble

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:22,positionColumn:1,positionLineNumber:22,selectionStartColumn:1,selectionStartLineNumber:22,startColumn:1,startLineNumber:22),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Astatic+int+double_val(int+i)%0A%7B%0A++return+2+*+i%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B4,+5,+7,+9%7D%3B%0A++std::vector%3Cint%3E+bar%3B%0A%0A++std::transform(foo.begin(),+foo.end(),+std::back_inserter(bar),+double_val)%3B%0A++for(size_t+i+%3D+0%3B+i+%3C+bar.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+bar%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    int double_val(int i) { return 2 * i;}

    vector<int> foo{4, 5, 7, 9};
    vector<int> bar;
    transform(foo.begin(), foo.end(), back_inserter(bar), double_val);
    // 8 10 14 18
    ```
  ],
)

=== STL Algorithmes -- Transformation

- Ou de deux ensembles en stockant le résultat dans un troisième

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:4,positionColumn:1,positionLineNumber:4,selectionStartColumn:1,selectionStartLineNumber:4,startColumn:1,startLineNumber:4),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B4,+5,+7,+9%7D%3B%0A++std::vector%3Cint%3E+bar%7B2,+3,+6,+1%7D%3B%0A++std::vector%3Cint%3E+baz%3B%0A%0A++std::transform(foo.begin(),+foo.end(),+bar.begin(),+std::back_inserter(baz),+std::plus%3Cint%3E())%3B%0A++for(size_t+i+%3D+0%3B+i+%3C+baz.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+baz%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo{4, 5, 7, 9};
    vector<int> bar{2, 3, 6, 1};
    vector<int> baz;

    transform(foo.begin(), foo.end(), bar.begin(),
              back_inserter(baz), plus<int>());
    // 6 8 13 10
    ```],
)

=== STL Algorithmes -- Rotation

- ```cpp std::rotate()``` effectue une rotation de l'ensemble, le nouveau début étant fourni par un itérateur

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:16,positionColumn:1,positionLineNumber:16,selectionStartColumn:1,selectionStartLineNumber:16,startColumn:1,startLineNumber:16),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B4,+5,+7,+9,+12%7D%3B%0A%0A++std::rotate(foo.begin(),+foo.begin()+%2B+2,+foo.end())%3B%0A++for(size_t+i+%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo{4, 5, 7, 9, 12};

    rotate(foo.begin(), foo.begin() + 2, foo.end());  // 7 9 12 4 5
    ```
  ],
)

- ```cpp std::rotate_copy()``` effectue une rotation et copie le résultat

=== STL Algorithmes -- Partitionnement

- ```cpp std::partition()``` réordonne l'ensemble pour que les éléments vérifiant le prédicat soit avant ceux ne le vérifiant pas ...

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:21,positionColumn:1,positionLineNumber:21,selectionStartColumn:1,selectionStartLineNumber:21,startColumn:1,startLineNumber:21),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Astatic+bool+is_odd(int+i)%0A%7B%0A++return+(i%252)%3D%3D1%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B4,+13,+28,+9+,+54%7D%3B%0A%0A++std::partition(foo.begin(),+foo.end(),+is_odd)%3B%0A++for(size_t+i+%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    bool is_odd(int i) { return (i % 2) == 1; }
    vector<int> foo{4, 13, 28, 9 , 54};

    partition(foo.begin(), foo.end(), is_odd);
    // 9 13 28 4 54 ou 9 13 4 28 54 ou ...)
    ```
  ],
)

- ... et retourne un itérateur sur le début de la seconde partie

#alertblock("Attention", text[
  Ordre relatif non conservé
])

=== STL Algorithmes -- Partitionnement

- ```cpp std::stable_partition()``` partitionne en conservant l'ordre relatif

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:21,positionColumn:1,positionLineNumber:21,selectionStartColumn:1,selectionStartLineNumber:21,startColumn:1,startLineNumber:21),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Astatic+bool+is_odd(int+i)%0A%7B%0A++return+(i%252)%3D%3D1%3B%0A%7D%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B4,+13,+28,+9+,+54%7D%3B%0A%0A++std::stable_partition(foo.begin(),+foo.end(),+is_odd)%3B%0A++for(size_t+i+%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo{4, 13, 28, 9 , 54};

    stable_partition(foo.begin(), foo.end(), is_odd);  // 13 9 4 28 54
    ```
  ],
)

#noteblock("Deux fonctions ?", text[
  Stabilité coûteuse en temps et pas toujours nécessaire
])

=== STL Algorithmes -- Partitionnement

- ```cpp std::nth_element()``` réordonne les éléments
  - Élément sur l'itérateur pivot est celui qui serait à cette place si l'ensemble était trié
  - Éléments avant ne sont pas supérieurs
  - Éléments après ne sont pas inférieurs
  - Pas d'ordre particulier au sein des deux sous-ensembles

// Formulation "pas supérieur" étrange mais gère le cas des égalités avec le pivot et la sémantique de l'opérateur fourni

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:4,positionColumn:1,positionLineNumber:4,selectionStartColumn:1,selectionStartLineNumber:4,startColumn:1,startLineNumber:4),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B9,+8,+7,+6,+5,+4,+3,+2,+1%7D%3B%0A%0A++std::nth_element(foo.begin(),+foo.begin()+%2B+3,+foo.end())%3B%0A++for(size_t+i+%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo{9, 8, 7, 6, 5, 4, 3, 2, 1};

    nth_element(foo.begin(), foo.begin() + 3, foo.end());
    // 2 1 3 4 5 9 6 7 8
    ```
  ],
)

=== STL Algorithmes -- Tri

- ```cpp std::sort()``` trie un ensemble

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:16,positionColumn:1,positionLineNumber:16,selectionStartColumn:1,selectionStartLineNumber:16,startColumn:1,startLineNumber:16),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B4,+13,+28,+9+,+54%7D%3B%0A%0A++std::sort(foo.begin(),+foo.end())%3B%0A++for(size_t+i+%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo{4, 13, 28, 9 , 54};

    sort(foo.begin(), foo.end());  // 4 9 13 28 54
    ```
  ],
)

#alertblock("Attention", text[
  Ordre relatif non conservé
])

- ```cpp std::stable_sort()``` trie l'ensemble en conservant l'ordre relatif

=== STL Algorithmes -- Tri

- ```cpp std::partial_sort()``` réordonne l'ensemble de manière à ce que les éléments situés avant un itérateur pivot soient les plus petits éléments de l'ensemble ordonnés par ordre croissant ...

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:16,positionColumn:1,positionLineNumber:16,selectionStartColumn:1,selectionStartLineNumber:16,startColumn:1,startLineNumber:16),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B9,+8,+7,+6,+5,+4,+3,+2,+1%7D%3B%0A%0A++std::partial_sort(foo.begin(),+foo.begin()+%2B+3,+foo.end())%3B%0A++for(size_t+i+%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo{9, 8, 7, 6, 5, 4, 3, 2, 1};

    partial_sort(foo.begin(), foo.begin() + 3, foo.end());
    // 1 2 3 9 8 7 6 5 4
    ```
  ],
)

- ... les autres éléments n'ont pas d'ordre particulier
- ```cpp std::partial_sort_copy()``` copie l'ensemble ordonné à l'image de ```cpp std::partial_sort()```

=== STL Algorithmes -- Mélange

- ```cpp std::random_shuffle()``` réordonne aléatoirement l'ensemble

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:15,positionColumn:1,positionLineNumber:15,selectionStartColumn:1,selectionStartLineNumber:15,startColumn:1,startLineNumber:15),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B9,+8,+7,+6,+5,+4,+3,+2,+1%7D%3B%0A%0A++std::random_shuffle(foo.begin(),+foo.end())%3B%0A++for(size_t+i+%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo{9, 8, 7, 6, 5, 4, 3, 2, 1};

    random_shuffle(foo.begin(), foo.end());
    // 1 8 3 7 9 4 2 6 5 ou
    // 5 6 2 1 9 4 7 8 3 ou
    // ...
    ```
  ],
)

=== STL Algorithmes -- Fusion

- ```cpp std::merge()``` fusionne deux ensembles triés dans un troisième

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:31,positionColumn:1,positionLineNumber:31,selectionStartColumn:1,selectionStartLineNumber:31,startColumn:1,startLineNumber:31),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B1,+5,+6,+8%7D%3B%0A++++std::vector%3Cint%3E+bar%7B2,+5%7D%3B%0A++++std::vector%3Cint%3E+baz%3B%0A%0A++++std::merge(foo.begin(),+foo.end(),+bar.begin(),+bar.end(),+std::back_inserter(baz))%3B%0A++++for(size_t+i+%3D+0%3B+i+%3C+baz.size()%3B+%2B%2Bi)%0A++++%7B%0A++++++std::cout+%3C%3C+baz%5Bi%5D+%3C%3C+!'+!'%3B%0A++++%7D%0A++++std::cout+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B1,+5,+6,+8,+2,+5%7D%3B%0A%0A++++std::inplace_merge(foo.begin(),+foo.begin()+%2B+4,+foo.end())%3B%0A++++for(size_t+i+%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++++%7B%0A++++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+!'+!'%3B%0A++++%7D%0A++++std::cout+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo{1, 5, 6, 8};
    vector<int> bar{2, 5};
    vector<int> baz;

    merge(foo.begin(), foo.end(), bar.begin(), bar.end(),
          back_inserter(baz));      // 1 2 5 5 6 8
    ```
  ],
)

- ```cpp std::inplace_merge()``` fusionne deux sous-ensembles sur place

=== STL Algorithmes -- Opérations ensemblistes

#alertblock("Attention", text[
  Ensembles sans répétition de valeur

  Ensembles triés
])

- ```cpp std::includes()``` vérifie si tous les éléments sont présents dans un autre ensemble

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:14,positionColumn:1,positionLineNumber:14,selectionStartColumn:1,selectionStartLineNumber:14,startColumn:1,startLineNumber:14),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B1,+5,+6,+8%7D%3B%0A++std::vector%3Cint%3E+bar%7B2,+5%7D%3B%0A++std::vector%3Cint%3E+baz%7B1,+6%7D%3B%0A%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::includes(foo.begin(),+foo.end(),+bar.begin(),+bar.end())+%3C%3C+!'%5Cn!'%3B%0A++std::cout+%3C%3C+std::boolalpha+%3C%3C+std::includes(foo.begin(),+foo.end(),+baz.begin(),+baz.end())+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo{1, 5, 6, 8};
    vector<int> bar{2, 5};
    vector<int> baz{1, 6};

    includes(foo.begin(), foo.end(), bar.begin(), bar.end());  // faux
    includes(foo.begin(), foo.end(), baz.begin(), baz.end());  // vrai
    ```
  ],
)

=== STL Algorithmes -- Opérations ensemblistes

- ```cpp std::set_union()``` : union de deux ensembles

#codesample(
  "https://godbolt.org/#z:OYLghAFBqd5QCxAYwPYBMCmBRdBLAF1QCcAaPECAMzwBtMA7AQwFtMQByARg9KtQYEAysib0QXACx8BBAKoBnTAAUAHpwAMvAFYTStJg1DIApACYAQuYukl9ZATwDKjdAGFUtAK4sGe1wAyeAyYAHI%2BAEaYxCAA7KQADqgKhE4MHt6%2BekkpjgJBIeEsUTHxdpgOaUIETMQEGT5%2BXLaY9nkM1bUEBWGR0XG2NXUNWc0KQ93BvcX9sQCUtqhexMjsHOYAzMHI3lgA1CYbbk7jxJish9gmGgCCm9u7mAdHAG4VRMSX13dmWww7Xn2hzcYmAJEICBYX1u32CBD2LCYwQgc2%2BJliVluewOGO%2B2Ox43QIBAbwcJGBcMue34qHRFmaewArKQ9gA2FkADnRABFDpibvi9oTiaSPhTBFSIrU6WYWYyeXy8fjhST3uSjpSNtg9lKAF6KmFY5UEIkgJQEAD6XgYaWoqFQADoosBkQtqfaHa4USypcQnZgXQxvTrap6GOhg1LkABrC3BJR1aIQPVzVEbfmC/jECApXWYC3wvDPbl7DR8vZF4Eh3UO3OYFHl6zWPCoo3YulKwUqtBeeHAqt6kyMix4Icl/tHPZgDhT9bpzs43ltoUm4k9vtHKvToduBjb%2BdGhWGgU4jPG02i9XHCVa920jEM5lszkKg8ngmr1Vkz4am/a30ynKr5nh%2BF5qj%2B14EJKTD6m%2BC4quacaCNESiVAIdqOs6rosjSYYRm6vr%2BoGkahl6BFMDGSEJgQSYpmmIHutmdYFhWxaluWlaTnqtZ4HmDbpgcljNq276nguoFrksG5uAOMFDiOY7PDJk7TrOBqiUeondlJSlbusjK7vuZ6aUqHbLiql4QZq2o0nSj4suyexcrEvJvl2n6WeKUG3gBGKykywHwR54FedBsH8kFpqIfgVBUNEjCrBhRHYXeeEkX6WFBuRfpkT6FGxvG0Q0dmdHqZmJA5rx%2BaFmxZYCZxbjVjxfH0YJViWC2C5maJEkoDpE6NYOw6joy46bipM5GV1LmRZJva6RNO57nOxkzce7a4uZwXfqFt62Q%2BcoOS%2BM1ueeIohb%2B3n/tKflASdDEWRdkFheps1mpgloKAAniwbAEMQeDIBaMVxWc/z1rhmXBrhuUhhlAYpYRsNRgVDDUbRMGpmV%2BJZpVeYsZxJZ1RYrGyTWdb8STTYdSJgrdYKvXrgtg1ycNikDbOamnRtS5aZ%2BTMc9uBnLdjJlrTcHALLQnCMrwfgcFopCoJwMlCZYQpLCsTybDwpAEJoksLNGICMho%2BicJIcsG0rnC8AoIBm/rCuS6QcCwEgmCqBUvYkOQlC1MACjKIYrRCAgqAAO7y7raAsAkdBMO0wchLQYeR/Liux/H9AxIHzAJAo4cEKQWd0NEoSsGsvClznADyvZp1H1uexUNzEIHtukC3yDVPg8u8PwggiGI7BSDIgiKCo6jO6QujNAYRgoNTNi0HgET25ACyoAk7T2xwAC0hKHNyphq/SXB7PvADqYi0JfV%2Be/9TC8KgbzEADWAb96xDWo4bAACr2loF/BYChNarD0ISYIydQ7hybtwXg/1MBrF1hHYgTAEgGyljLK2M9lYcGwF7ZAPtiB7FUByVk%2B9WSSD2MAZAyA9gQH%2BtaaMcxGGq3ajYPYuBCAkEEhsLgcxEFYIWAgc4WAYjemNqbc2HBLakAzi/Tu9tHYiNkWYXBit8HCOdqmUgb8UjOEkEAA%3D%3D%3D",
  code: [
    ```cpp
    vector<int> foo{1, 5, 6, 8};
    vector<int> bar{2, 5};
    vector<int> baz;

    set_union(foo.begin(), foo.end(), bar.begin(),
              bar.end(), back_inserter(baz));   // 1 2 5 6 8
    ```
  ],
)

- ```cpp std::set_intersection()``` : intersection de deux ensembles
- ```cpp std::set_difference()``` : différence de deux ensembles
- ```cpp std::set_symmetric_difference()``` : différence symétrique de deux ensembles

// set_difference() conserve les éléments présents dans le premier ensemble mais pas dans le second alors que set_symmetric_difference() conserve les éléments présents dans un des ensembles mais pas dans l'autre}

=== STL Algorithmes -- Gestion de tas

#noteblock("Tas", text[
  Structure permettant la récupération de l'élément de plus grande valeur
])

- ```cpp std::make_heap()``` forme un tas depuis un ensemble
- ```cpp std::pop_heap()``` déplace l'élément de plus haute valeur en fin d'ensemble
- ```cpp std::push_heap()``` ajoute l'élément en fin d'ensemble au tas

#noteblock("Structure", text[
  ```cpp std::pop_heap()``` et ```cpp std::push_heap()``` maintiennent la structure de tas
])

- ```cpp std::sort_heap()``` tri le tas

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:27,positionColumn:1,positionLineNumber:27,selectionStartColumn:1,selectionStartLineNumber:27,startColumn:1,startLineNumber:27),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B10,20,30,5,15%7D%3B%0A%0A++std::make_heap(foo.begin(),+foo.end())%3B%0A++std::cout+%3C%3C+foo.front()+%3C%3C+!'%5Cn!'%3B%0A%0A++std::pop_heap(foo.begin(),+foo.end())%3B%0A++foo.pop_back()%3B%0A++std::cout+%3C%3C+foo.front()+%3C%3C+!'%5Cn!'%3B%0A%0A++foo.push_back(99)%3B%0A++std::push_heap(foo.begin(),+foo.end())%3B%0A++std::cout+%3C%3C+foo.front()+%3C%3C+!'%5Cn!'%3B%0A%0A++std::sort_heap(foo.begin(),+foo.end())%3B%0A++for(size_t+i+%3D+0%3B+i+%3C+foo.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+foo%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4", code: [
```cpp
vector<int> foo{10,20,30,5,15};

make_heap(foo.begin(), foo.end()); // front : 30
pop_heap(foo.begin(), foo.end());
foo.pop_back();                    // front : 20
```
  ]
)

=== STL Algorithmes -- Min-max

- ```cpp std::min()``` détermine le minimum de deux éléments
- ```cpp std::max()``` détermine le maximum de deux éléments

```cpp
min(52, 6);  // 6
max(52, 6);  // 52
```

- ```cpp std::min_element()``` détermine le plus petit élément d'un ensemble
- ```cpp std::max_element()``` détermine le plus grand élément d'un ensemble

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:10,positionColumn:1,positionLineNumber:10,selectionStartColumn:1,selectionStartLineNumber:10,startColumn:1,startLineNumber:10),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B18,+5,+6,+8%7D%3B%0A%0A++std::cout+%3C%3C+*std::min_element(foo.begin(),+foo.end())+%3C%3C+%22%5Cn%22%3B%0A++std::cout+%3C%3C+*std::max_element(foo.begin(),+foo.end())+%3C%3C+%22%5Cn%22%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo{18, 5, 6, 8};

    min_element(foo.begin(), foo.end());  // 5
    max_element(foo.begin(), foo.end());  // 18
    ```
  ],
)

=== STL Algorithmes -- Numérique

- ```cpp std::accumulate()``` "ajoute" tous les éléments de l'ensemble

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:10,positionColumn:1,positionLineNumber:10,selectionStartColumn:1,selectionStartLineNumber:10,startColumn:1,startLineNumber:10),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cnumeric%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B18,+5,+6,+8%7D%3B%0A++std::cout+%3C%3C+std::accumulate(foo.begin(),+foo.end(),+1,+std::multiplies%3Cint%3E())+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo{18, 5, 6, 8};

    accumulate(foo.begin(), foo.end(), 1, multiplies<int>()); // 4320
    ```
  ],
)

- Opérateur et valeur initiale configurables
- _Reduce_/_fold_ fonctionnel

=== STL Algorithmes -- Numérique

- ```cpp std::adjacent_difference()``` "différence" entre un élément et son prédécesseur

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:15,positionColumn:1,positionLineNumber:15,selectionStartColumn:1,selectionStartLineNumber:15,startColumn:1,startLineNumber:15),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cnumeric%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B18,+5,+6,+8%7D%3B%0A++std::vector%3Cint%3E+bar%3B%0A%0A++std::adjacent_difference(foo.begin(),+foo.end(),+back_inserter(bar),+std::minus%3Cint%3E())%3B%0A++for(size_t+i+%3D+0%3B+i+%3C+bar.size()%3B+%2B%2Bi)%0A++%7B%0A++++std::cout+%3C%3C+bar%5Bi%5D+%3C%3C+!'+!'%3B%0A++%7D%0A++std::cout+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo{18, 5, 6, 8};
    vector<int> bar;

    adjacent_difference(foo.begin(), foo.end(),
                        back_inserter(bar), minus<int>());
    // 18 -13 1 2
    ```
  ],
)

- Opérateur configurable

=== STL Algorithmes -- Numérique

- ```cpp std::inner_product()``` : "produit scalaire" de deux ensembles

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:12,positionColumn:1,positionLineNumber:12,selectionStartColumn:1,selectionStartLineNumber:12,startColumn:1,startLineNumber:12),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cnumeric%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B1,+2,+3,+4%7D%3B%0A++std::vector%3Cint%3E+bar%7B2,+3,+4,+5%7D%3B%0A%0A++std::cout+%3C%3C+std::inner_product(foo.begin(),+foo.end(),+bar.begin(),+0)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo{1, 2, 3, 4};
    vector<int> bar{2, 3, 4, 5};

    inner_product(foo.begin(), foo.end(), bar.begin(), 0); // 40
    ```
  ],
)

- Opérateurs et valeur configurables

=== STL Algorithmes -- Numérique

- ```cpp std::partial_sum()``` : "somme" partielle d'un ensemble
- Chaque élément résultant est la somme des éléments d'indice inférieur ou égal de l'ensemble de départ

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:6,endLineNumber:19,positionColumn:6,positionLineNumber:19,selectionStartColumn:6,selectionStartLineNumber:19,startColumn:6,startLineNumber:19),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Cnumeric%3E%0A%0Aint+main()%0A%7B%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B1,+2,+3,+4%7D%3B%0A++++std::vector%3Cint%3E+bar%3B%0A%0A++++std::partial_sum(foo.begin(),+foo.end(),+back_inserter(bar))%3B%0A++++for(size_t+i+%3D+0%3B+i+%3C+bar.size()%3B+%2B%2Bi)%0A++++%7B%0A++++++std::cout+%3C%3C+bar%5Bi%5D+%3C%3C+!'+!'%3B%0A++++%7D%0A++++std::cout+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%0A%23if+0%0A++//+Factorielle%0A++%7B%0A++++std::vector%3Cint%3E+foo%7B1,+2,+3,+4%7D%3B%0A++++std::vector%3Cint%3E+bar%3B%0A%0A++++std::partial_sum(foo.begin(),+foo.end(),+back_inserter(bar),+std::multiplies%3Cint%3E())%3B%0A++++for(size_t+i+%3D+0%3B+i+%3C+bar.size()%3B+%2B%2Bi)%0A++++%7B%0A++++++std::cout+%3C%3C+bar%5Bi%5D+%3C%3C+!'+!'%3B%0A++++%7D%0A++++std::cout+%3C%3C+!'%5Cn!'%3B%0A++%7D%0A%23endif%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
    vector<int> foo{1, 2, 3, 4};
    vector<int> bar;

    partial_sum(foo.begin(), foo.end(), back_inserter(bar));
    // 1 3 6 10
    ```
  ],
)

- Opérateur configurable

=== STL Algorithmes -- Au delà des conteneurs

- Itérateurs définissables hors des conteneurs
  - Abstraction du parcours
  - Sémantique de pointeurs
- Algorithmes indépendants du conteneur
- Utilisables sur d'autres ensembles de données

=== STL Algorithmes -- Au delà des conteneurs

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

=== STL Algorithmes -- Au delà des conteneurs

- Flux
  - ```cpp istream_iterator``` : input itérateur
    - Début : depuis un flux entrant
    - Fin : constructeur par défaut
  - ```cpp ostream_iterator``` : output itérateur
    - Depuis un flux sortant, séparateur configurable

#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:13,positionColumn:1,positionLineNumber:13,selectionStartColumn:1,selectionStartLineNumber:13,startColumn:1,startLineNumber:13),source:'%23include+%3Ciostream%3E%0A%23include+%3Citerator%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B5,+6,+12,+89%7D%3B%0A++std::ostream_iterator%3Cint%3E+out_it+(std::cout,+%22,+%22)%3B%0A%0A++std::copy(foo.begin(),+foo.end(),+out_it)%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
  code: [
    ```cpp
   	vector<int> foo{5, 6, 12, 89};
   	ostream_iterator<int> out_it (cout, ", ");

   	copy(foo.begin(), foo.end(), out_it); // 5, 6, 12, 89,
    ```
  ],
)

#alertblock("Attention", text[
  Séparateur ajouté après chaque élément, y compris le dernier
])

- Buffers de flux : ```cpp istreambuf_iterator``` et ```cpp ostreambuf_iterator```

== STL -- Conclusion

=== STL Conclusion

#adviceblock("Do", text[
  Préférez les conteneurs aux tableaux C
])

#alertblock("Attention", text[
  ```cpp operator[]``` ne vérifie pas les bornes

  // Une implémentation peut mettre une assertion dessus et produire une erreur à l'exécution en debug, p.ex. sur les TU, et une implémentation de qualité devrait le faire
])

#alertblock("Don't", text[
  N'utilisez pas d'itérateur invalidé
])

#alertblock("Attention", text[
  Pas objets polymorphiques dans les conteneurs

  Ou via des pointeurs intelligents
])

=== STL Conclusion

#adviceblock("Do, performances", text[
  Mesurez !
])

#noteblock("Conseils, performances", text[
  Réfléchissez à votre utilisation des données

  // Utilisation des données : zone critique/non critique, découpage d'algorithmes, données particulières (triées, lourdes à copier), compromis temps/mémoire, stabilité (tri), mise en cache, ...

  Méfiez-vous des complexités brutes

  // La complexité n'est pas ou peu significative pour de petits volumes de données, p.ex. les tris par insertion ou sélection (O($n^{2}$)) plus efficaces que des tris en O($n\ln n$)}
  // Les complexités moyennes ne sont pas pertinentes pour des données particuliers, p.ex. tri par insertion efficace sur ensembles presque triés, peu de permutation du tri par sélection donc efficace pour des données lourdes à déplacer}
])

#adviceblock("Do", text[
  Préférez les algorithmes standards aux algorithmes tierces et maisons
])

#noteblock("Bémol, performances", text[
  Algorithmes standards généralement bons

  Mais pas optimaux dans toutes les situations
])

=== STL Conclusion

#adviceblock("Do", text[
  Faites vos propres algorithmes plutôt que des boucles

  Faites des algorithmes génériques et compatibles avec la STL
])

#adviceblock("Do, sémantique", text[
  Le bon algorithme pour la bonne opération

  Définissez la sémantique de vos algorithmes et choisissez un nom explicite
])

#adviceblock("Do", text[
  Préférez les prédicats purs
])

=== STL Conclusion

#adviceblock("Do", text[
  Vérifiez que les ensembles de destination aient une taille suffisante
])

#adviceblock("Do", text[
  Vérifiez les pré-conditions des algorithmes (p.ex. ensemble trié)
])

#adviceblock("Do", text[
  Vérifiez le type d'itérateur requis
])

#adviceblock("Do", text[
  Vérifiez les complexités garanties
])

#noteblock("Aller plus loin", text[
  Voir #link("https://github.com/CppCon/CppCon2016/blob/master/Presentations/STL%20Algorithms/STL%20Algorithms%20-%20Marshall%20Clow%20-%20CppCon%202016.pdf")[STL Algorithms #linklogo() (Marshall Clow)]
])
