let get_words filename =
    let ic = open_in filename in

    (* -> char list list*)
    let rec read acc =
        match input_line ic with
        | line -> 
            let words = String.split_on_char ' ' line in
            let chars = List.map (fun s -> String.fold_right (fun c l -> c :: l) s []) words in
            read (chars :: acc)
        | exception End_of_file -> 
            close_in ic; 
            List.concat (List.rev acc)
    in

    (*char list -> string list*)
    let rec split_if_signature acc = function
    | c :: str ->
        (
        match c with
        | '\'' | '!' | '?' | ',' | ';' | '.' | ':' ->
            (
            if acc = [] then 
                let s = (String.make 1 c) in
                s :: (split_if_signature [] str)
            else 
                let s = (String.make 1 c) in
                let s_list = String.of_seq(List.to_seq(List.rev acc)) in
                s_list :: s :: (split_if_signature [] str)
            )
        | _ ->  split_if_signature (c :: acc) str
        )
    | [] -> 
        if acc = [] then [] 
        else [String.of_seq(List.to_seq(List.rev acc))]
    in 
    (*char list list*)
    let words = read [] in
    (*
    itera in words quindi char list list:
        - i suoi elementi sono char list -> split_if_signature -> string list
    Otteniamo una string list list -> concateno -> string list
    *)
    List.concat_map (split_if_signature []) (words);;


let count_words filename =
    let module StringMap = Map.Make(String) in
    let count map word = 
        let increment op =
            match op with
            |Some n -> Some (n+1)
            |None -> Some 1
        in
        StringMap.update (String.lowercase_ascii word) (increment) map
    in
    let all_words = get_words filename in
    let map = List.fold_left count (StringMap.empty) all_words in
    StringMap.bindings map;;
