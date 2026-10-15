(*
is_palindrome: string → bool 
that checks if the string is palindrome, a string is palindrome when the represented sentence can be read the same way in either directions 
in spite of spaces, punctual and letter cases, e.g., detartrated, "Do geese see God?", "Rise to vote, sir.", ...
*)
let is_palindrome s =
    
    let valid = function
    | ' ' | '\t' | '\n' | '\r' -> false
    | '!'..'/' | ':'..'@' | '['..'`' | '{'..'~' -> false
    | _ -> true
    in 

    let rev_list = Bytes.fold_left(fun acc c -> if valid c then (Char.lowercase_ascii c) :: acc else acc) [] (Bytes.of_string s)
    in rev_list = List.rev rev_list;;

(*
operator (-): string → string → string 
that subtracts the letters in a string from the letters in another string, 
e.g., "Walter Cazzola"-"abcwxyz" will give "Wlter Col" note that the operator - is case sensitive
*)
let ( - ) a b =
    let check c s =
        Bytes.fold_left(fun found x -> found || x = c) false (Bytes.of_string s)
    in 
    let diff = Bytes.fold_left (fun acc c -> if (check c b) then acc else (c :: acc)) [] (Bytes.of_string a)
    in 
    String.of_seq (List.to_seq (List.rev diff));;

(*
anagram : string → string list → boolean 
that given a dictionary of strings, checks if the input string is an anagram of one or more of the strings in the dictionary
*)
let anagram word dict =

    let check w1 w2 =

        let rec remove_1_occurence c found res = function
        | hd :: tl when found -> remove_1_occurence c found (hd :: res) tl
        | hd :: tl when hd = c -> remove_1_occurence c true res tl
        | hd :: tl -> remove_1_occurence c found (hd :: res) tl
        | [] -> res
        in
        let rec remove_element c1l c2l =
            match c1l with
            | c :: tl -> remove_element tl (remove_1_occurence c false [] c2l) 
            | [] -> c2l
        in  
        if String.length w1 = String.length w2 then
            let c1l = Bytes.fold_left(fun acc c -> c :: acc) [] (Bytes.of_string w1) in
            let c2l = Bytes.fold_left(fun acc c -> c :: acc) [] (Bytes.of_string w2) in
            remove_element c1l c2l  = []
        else false
    in
    let rec anagram word result = function
    | _ when result = true -> result
    | [] -> result
    | w1 :: tl -> anagram word (check word w1) tl
    in anagram word false dict;;