---
layout: post
title: 'Mini-post: JUnit Without Gradle'
date: 2021-03-11 18:40 +0100
categories: blog
---

Most of the time I use JUnit I do it through Gradle or Maven, however, lately I've been looking into using it for testing smaller things like [solutions](/comprog) to competitive programming problems.
Turns out that for JUnit5 you can run your tests using the [ConsoleLauncher](https://junit.org/junit5/docs/current/user-guide/#running-tests-console-launcher), which in a nutshell is an executable jar
that also contains all the runtime and compile dependencies you need to write and run junit tests.

Here's an example of how to use it, say you have a `RandomizedSelection.java` file that contains some tests:

```java
import org.junit.jupiter.api.*;
import org.junit.jupiter.params.*;
import org.junit.jupiter.params.provider.*;
import static org.junit.jupiter.api.Assertions.*;

import java.util.*;
import java.util.stream.*;

class RandomizedSelection {
    static int select(List<Integer> ints, int k){
        if (k < 0 || k >= ints.size()) throw new IllegalArgumentException();
        Objects.requireNonNull(ints);
        return select(ints, 0, ints.size() - 1, k);
    }

    private static int select(List<Integer> ints, int l, int r, int k){
        int finalPivotPos = partition(ints, l, r, (r + l) >>> 1); 
        int largerElements = r - finalPivotPos;
        if (largerElements > k){
            return select(ints, finalPivotPos + 1, r, k);  
        } else if (largerElements < k){
            return select(ints, l, finalPivotPos - 1, k - largerElements - 1);
        }
        return ints.get(finalPivotPos);
    }

    private static int partition(List<Integer> ints, int from, int to, int pivotPosition){
        int pivot = ints.get(pivotPosition);
        Collections.swap(ints, to, pivotPosition);
        int bound = from;
        for(int i = from; i <= to; i++){
            if(ints.get(i) < pivot){
                Collections.swap(ints, bound, i);
                bound++;
            }   
        }
        Collections.swap(ints, bound, to);
        return bound;
    }
}

class RandomizedSelectionTests{
    @Test
    void shouldFailOnIllegalArgs(){
        Assertions.assertThrows(NullPointerException.class, () -> RandomizedSelection.select(null, 0));
        Assertions.assertThrows(IllegalArgumentException.class, () -> RandomizedSelection.select(Arrays.asList(1,2,3), 3));
    }

    @ParameterizedTest(name = "{index} {1}(th/st) largest element of {0} is {2}")
    @MethodSource("testData")
    void selectKthLargest(List<Integer> numbers, int k, int expected ){
        assertEquals(expected, RandomizedSelection.select(numbers, k));
    }

    @Test
    @DisplayName("Randomly generated test \uD83D\uDE80")
    void aBigTest(){
        Random random = new Random();
        List<Integer> ints = random.ints(0,1000).limit(100).boxed().collect(Collectors.toList());
        List<Integer> sortedInts = ints.stream().sorted(Comparator.reverseOrder()).collect(Collectors.toList());
        int k = random.nextInt(ints.size());
        assertEquals(sortedInts.get(k), RandomizedSelection.select(ints, k));
    }

    static Stream<Arguments> testData(){
        return Stream.of(
            Arguments.of(Arrays.asList(10,20,30), 1, 20),
            Arguments.of(Arrays.asList(40), 0, 40),
            Arguments.of(Arrays.asList(98,11,4,2,1,50), 1, 50),
            Arguments.of(Arrays.asList(50,13,11,90,45,21,55), 3, 45)
        );
    }
}
```
<small>RandomizedSelection.java</small>

To compile these classes and run the tests, the following should be enough (I've defined some functions to avoid having to remember all the flags)

```sh
function junit_test(){
	java -jar $libdir/junit-platform-console-standalone-1.7.1.jar -cp . --scan-classpath --disable-banner --fail-if-no-tests --include-classname ".*"
}

function java_compile(){
	javac -cp "$libdir/*" -g $1
}

function java_clean(){
	rm *.class
}

function java_test(){
	java_compile $1 && junit_test
}
```

```
java_test RandomizedSelection.java && java_clean
╷
├─ JUnit Jupiter ✔
│  └─ RandomizedSelectionTests ✔
│     ├─ Randomly generated test 🚀 ✔
│     ├─ selectKthLargest(List, int, int) ✔
│     │  ├─ 1 1(th/st) largest element of [10, 20, 30] is 20 ✔
│     │  ├─ 2 0(th/st) largest element of [40] is 40 ✔
│     │  ├─ 3 1(th/st) largest element of [98, 11, 4, 2, 1, 50] is 50 ✔
│     │  └─ 4 3(th/st) largest element of [50, 13, 11, 90, 45, 21, 55] is 45 ✔
│     └─ shouldFailOnIllegalArgs() ✔
└─ JUnit Vintage ✔

Test run finished after 98 ms
[         4 containers found      ]
[         0 containers skipped    ]
[         4 containers started    ]
[         0 containers aborted    ]
[         4 containers successful ]
[         0 containers failed     ]
[         6 tests found           ]
[         0 tests skipped         ]
[         6 tests started         ]
[         0 tests aborted         ]
[         6 tests successful      ]
[         0 tests failed          ]
```

Is this useful? well, is it? not sure. I just like knowing how to do it.
