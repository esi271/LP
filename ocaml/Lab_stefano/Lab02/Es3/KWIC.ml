module KWIC =
    struct

        let get_words filename =
            let ic = open_in filename in

            let rec read acc = 
                match input_line ic with
                | line ->
                    let detected = String.split_on_char ' ' line in
                    let words = List.fold_right (fun e acc -> if e = "" then acc else e :: acc) detected [] in 
                    read ((List.map (fun s -> String.trim s) words) :: acc)
                | exception End_of_file -> 
                    close_in ic;
                    List.rev acc
            in read []

        let rec get_keyword ?(acc = []) ?(p = 0) = function
        | hd :: tl ->
            let word = String.lowercase_ascii hd in
            if (String.length word > 2) && (word <> "the") && (word <> "and") then
                get_keyword ~acc:((hd,p) :: acc) ~p:(p+1) tl
            else 
                get_keyword ~acc:(acc) ~p:(p+1) tl
        | [] -> List.rev acc

        let rec drop_n ?(current = 0) ?(acc = []) i = function
        | hd :: tl when current <= i -> drop_n ~current:(current + 1) ~acc:(acc) i tl
        | hd :: tl -> drop_n ~current:(current + 1) ~acc:(hd :: acc) i tl
        | [] -> List.rev acc

        let rec take_n ?(current = 0) ?(acc = []) i = function
        | hd :: tl when current < i -> take_n ~current:(current + 1) ~acc:(hd :: acc) i tl
        | hd :: tl -> take_n ~current:(current + 1) ~acc:(acc) i tl
        | [] -> List.rev acc

        let get_index title i =

            let rec build ?(acc = []) = function
            | (hd, p) :: tl ->
                let sx = take_n p title in
                let dx = drop_n p title in
                let index = (i, sx, hd, dx) in
                build ~acc:(index :: acc) tl
            | [] -> acc
            in build (get_keyword title)

        let rec get_indexes ?(acc = []) ?(pos = 1) = function
        | hd :: tl -> 
            let index = get_index hd pos in
            get_indexes ~acc:(index :: acc) ~pos:(pos+1) tl
        | [] -> List.concat acc

        let format idx =

            let rec right_justified s i =
                if String.length s < i then right_justified (" " ^ s) i
                else s 
            in

            let rec left_justified s i =
                if String.length s < i then left_justified (s ^ " ") i
                else s
            in

            let format_l s =
                let s = (s ^ " ") in
                if String.length s > 33 then
                    String.sub s 0 33
                else right_justified s 33
            in

            let max_r = List.fold_left (
                fun acc (_,_,k,r) -> 
                    let count = (String.length k) + (List.fold_left(fun r e -> r + String.length e) 0 r) + (List.length r) in
                    if count > acc then count
                    else acc
                ) 0 idx 
            in

            let format_r s =
                if String.length s > 40 then
                    String.sub s 0 40
                else left_justified s max_r
            in

            let rec format ?(acc = []) = function
            | (i, l, k, r) :: tl->
                let b = Buffer.create 80 in
                Buffer.add_string b (right_justified (string_of_int i) 5);
                Buffer.add_string b (format_l (String.concat " " l));
                Buffer.add_string b (format_r (String.concat " " (k :: r)));
                format ~acc:((Buffer.contents b) :: acc) tl
            | [] -> List.rev acc
            in format idx

        
        let kwic_index filename = 
            let words = get_words filename in
            let idx = get_indexes words in
            let sorted = List.sort (
                fun (_, _, k1, _) (_, _, k2, _) ->
                    String.compare k1 k2
            ) idx
            in
            format sorted

    end;;