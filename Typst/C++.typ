#import "./model.typ": *

#show: slides.with(
  title: "C++",
  date: datetime.today().display("[day]/[month]/[year]"),
  authors: "Grégory Lerbret",
  footer: true,
  toc: true,
)

= Retour sur C++98 / C++03

== First Slide

- Aaaa
  - cccc
    - dddd
- bbb

#noteblock("a", "bb")
#alertblock("a", "bb")

== AAAA

/*#codesample(
  "https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,selection:(endColumn:1,endLineNumber:18,positionColumn:1,positionLineNumber:18,selectionStartColumn:1,selectionStartLineNumber:18,startColumn:1,startLineNumber:18),source:'%23include+%3Ciostream%3E%0A%23include+%3Cvector%3E%0A%23include+%3Calgorithm%3E%0A%0Aint+main()%0A%7B%0A++std::vector%3Cint%3E+foo%7B2,+5,+2,+1,+8,+8,+6,+2,+8,+8,+8,+2%7D%3B%0A%0A++std::vector%3Cint%3E::iterator+it+%3D+find(foo.begin(),+foo.end(),+6)%3B%0A++std::cout+%3C%3C+*it+%3C%3C+!'+!'+%3C%3C+*(it%2B1)+%3C%3C+!'%5Cn!'%3B%0A%0A++std::vector%3Cint%3E::iterator+it2+%3D+std::adjacent_find(foo.begin(),+foo.end())%3B%0A++std::cout+%3C%3C+*it2+%3C%3C+!'+!'+%3C%3C+*(it2+-+1)+%3C%3C+!'+!'+%3C%3C+*(it2+%2B+2)+%3C%3C+!'%5Cn!'%3B%0A%0A++std::vector%3Cint%3E::iterator+it3+%3D+std::search_n(foo.begin(),+foo.end(),+3,+8)%3B%0A++std::cout+%3C%3C+*it3+%3C%3C+!'+!'+%3C%3C+*(it3+-+1)+%3C%3C+!'+!'+%3C%3C+*(it3+%2B+3)+%3C%3C+!'%5Cn!'%3B%0A%7D%0A'),l:'5',n:'0',o:'C%2B%2B+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:executor,i:(argsPanelShown:'1',compilationPanelShown:'0',compiler:gsnapshot,compilerName:'',compilerOutShown:'0',execArgs:'',execStdin:'',fontScale:14,fontUsePx:'0',j:1,lang:c%2B%2B,libs:!(),options:'-std%3Dc%2B%2B11+-Wall+-Wextra',overrides:!(),runtimeTools:!(),source:1,stdinPanelShown:'1',tree:'1',wrap:'0'),l:'5',n:'0',o:'Executor+x86-64+gcc+(trunk)+(C%2B%2B,+Editor+%231)',t:'0')),header:(),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4",
)*/
#codesample("1")
#codesample("2")
#codesample("3")

```cpp
print("Hello World")
```

== Second slide

aaa
#codesample("2.1")



== Thirs

#lorem(20)

= C++11

= C++14

= C++7

= C++20

= C++23 "_Pandemic edition_"<label2>

== First Slide

This is very interesting cnum(1)

#lorem(20)

= C++26

= En ensuite ?
