# Exercise ML/OCaML: How Far Are You?

In computational linguistics and computer science, edit distance is a string metric, i.e., a way of quantifying how dissimilar two strings (e.g., words, sentences) are to one another, that is measured by counting the minimum number of operations required to transform one string into the other. Edit distances find applications, for example, in automatic spelling correction where it can determine a candidate corrections for a misspelled word by selecting words from a dictionary that have a low distance to the word in question.

Different definitions of an edit distance use different sets of like operations. Most commonly used operations are the removal, insertion, or substitution of a character in the string. One of the most used edit distance is the Hamming distance.

The Hamming distance between two strings or vectors of equal length is the number of positions at which the corresponding symbols are different. In other words, it measures the minimum number of substitutions required to change one string into the other, or equivalently, the minimum number of errors that could have transformed one string into the other. It is named after the American mathematician Richard Hamming.

Given that, the exercise consists in writing a module `hamming` that provides an implementation of the `hamming : string -> string -> int * (char * char) list` that given two strings returns a couple composed of the number of changes needed to transform the former string to the latter and a list of substitutions needed to perform the transformation. Each substitution is a couple of characters where the former is the one that is replaced by the latter. The two strings **must** have the same length. If the two arguments do not have the same length you have to raise an `invalid_arg` exception. The exercise must be in plain functional OCaML, i.e., no library functions can be used in its implementation, no object-oriented or imperative feature can be used.

The following is an example of the expected behavior (your code must compile against this example):

```ocaml
open Hamming;;

let test elem = hamming (fst elem) (snd elem) ;;
let print_result (edits, ops) =
  let print_operation (a, b) = Printf.sprintf "'%c' -> '%c'" a b
  in let ops_str = String.concat ", " (List.map print_operation ops) in
    Printf.printf "Number of edits: %d\nChanges: %s\n" edits ops_str

let main () =
  let test_cases =
    [("kittens", "sitting"); ("The cat jump down", "The Bats flies up");
     ("She walks in the park", "They walk in the park"); ("garden", "gordon");
     ("You play video-games at home", "We read books at the library"); ("paris", "party")
    ]
  in List.iter print_result (List.map test test_cases) ;;

let () = main () ;;
```

```text
Number of edits: 3
Changes: 'k' -> 's', 'e' -> 'i', 's' -> 'g'
Number of edits: 11
Changes: 'c' -> 'B', ' ' -> 's', 'j' -> ' ', 'u' -> 'f', 'm' -> 'l', 'p' -> 'i', ' ' -> 'e', 'd' -> 's', 'o' -> ' ', 'w' -> 'u', 'n' -> 'p'
Number of edits: 7
Changes: 'S' -> 'T', ' ' -> 'y', 'w' -> ' ', 'a' -> 'w', 'l' -> 'a', 'k' -> 'l', 's' -> 'k'
Number of edits: 2
Changes: 'a' -> 'o', 'e' -> 'o'
Number of edits: 27
Changes: 'Y' -> 'W', 'o' -> 'e', 'u' -> ' ', ' ' -> 'r', 'p' -> 'e', 'l' -> 'a', 'a' -> 'd', 'y' -> ' ', ' ' -> 'b', 'v' -> 'o', 'i' -> 'o', 'd' -> 'k', 'e' -> 's', 'o' -> ' ', '-' -> 'a', 'g' -> 't', 'a' -> ' ', 'm' -> 't', 'e' -> 'h', 's' -> 'e', 'a' -> 'l', 't' -> 'i', ' ' -> 'b', 'h' -> 'r', 'o' -> 'a', 'm' -> 'r', 'e' -> 'y'
Number of edits: 2
Changes: 'i' -> 't', 's' -> 'y'
```
