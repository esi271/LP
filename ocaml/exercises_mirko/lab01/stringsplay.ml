let is_palindrome word =
    let lword = List.of_seq (String.to_seq word) in
    lword = List.rev lword;;

let str_sub word1 word2 =
    let lword1 = List.of_seq (String.to_seq word1) in
    let rec aux acc = function
        | h :: t -> if (String.contains word2 h) then aux acc t else aux (h::acc) t
        | [] -> String.of_seq (List.to_seq (List.rev acc)) in
    aux [] lword1;;

let (--) = str_sub;;

let rec is_anagram word1 word2 = 
    let chars s = List.of_seq (String.to_seq s) in
    List.sort Char.compare (chars word1) = List.sort Char.compare (chars word2);;

let rec anagram word = function
    | h :: t -> if is_anagram word h then true else anagram word t
    | [] -> false;;
