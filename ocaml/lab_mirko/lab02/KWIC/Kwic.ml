module type Kwic = sig

    val print_index : string -> unit

end

module Kwic : Kwic = struct

    let num_wide = 5
    let keyword_start = 39
    let max_line_size = 79
    let max_left = 33
    let max_right = 40
    let max_title_size = max_left + max_right


    (* 
       title position * title * n times the word is in the title
    *)
    type v = (int * string * int) list

    module SMap = Map.Make(struct 
        type t = string 
        let compare s1 s2 = String.compare (String.lowercase_ascii s1) (String.lowercase_ascii s2) 
    end)

    let read_file file = 
        let chan = open_in file in
        let rec aux acc =
            match input_line chan with
            | line -> aux (line::acc) 
            | exception End_of_file -> close_in chan; List.rev acc in
        aux [] 
        
    let index_from_word line word from =
        let rec index_from_word pos from = function
            | [] -> pos
            | h::_ when h = word && from = 0 -> pos
            | h::t when h = word && not (from = 0) -> index_from_word (pos+(String.length h)+1) (from - 1) t
            | h::t -> index_from_word (pos+(String.length h)+1) from t
        in index_from_word 0 from (String.split_on_char ' ' line) 

    let clean_titles titles = 
        List.map (fun s -> String.trim s) titles

    let clean_title title keyword_pos =
        if keyword_pos > max_left then String.sub title (keyword_pos - max_left) (String.length title - (keyword_pos - max_left)) else title 

    let add_padding_right line =
        if String.length line < max_line_size then
            line ^ String.make (max_line_size - 1 - (String.length line)) ' ' ^ "."
        else
            line
        
    let format_title pos title keypos =
        let number = string_of_int pos in
        let format_number = String.make (num_wide - (String.length number)) ' ' ^ number in
        let keycol = min keypos max_left in
        let clean_t = clean_title title keypos in
        let body = String.make (max_left - keycol) ' ' ^ clean_t in
        let body =
            if String.length body > max_left + max_right
            then String.sub body 0 (max_left + max_right)
            else body
        in
        Printf.printf "%s\n" (add_padding_right (format_number ^ " " ^ body))

    let count_in_s s x = 
        List.fold_left 
        (fun acc w -> if w = x then acc + 1 else acc)
        0
        (String.split_on_char ' ' s)

    let is_minor_word word = 
        match String.lowercase_ascii word with
        | "the" | "and" -> true
        | _ -> false

    let word_offsets title =
        let rec go acc start = function
            | [] -> List.rev acc
            | w :: rest -> go ((w, start) :: acc) (start + String.length w + 1) rest
        in
        go [] 0 (String.split_on_char ' ' title)

    let index_titles titles = 
        List.fold_left
        (fun m (i, title) -> 
            List.fold_left
            (fun m (w, off) ->
                if is_minor_word w then m
                else
                    SMap.update w
                    (function
                        | None -> Some [(i, title, off)]
                        | Some l -> Some ((i, title, off) :: l))
                    m)
            m (word_offsets title))
        SMap.empty
        (List.mapi (fun i t -> (i + 1, t)) titles)

    let print_index file =
        let c_titles = clean_titles (read_file file) in
        SMap.iter (fun word titles ->
            List.iter (fun (pos, title, kp) -> format_title pos title kp) 
            (List.rev titles))
        (index_titles c_titles)

end
