module Frequency =
    struct

        let occ = Hashtbl.create 100

        let count file =
            let f = In_channel.open_bin file in
            let rec count = function
                | l :: t -> 
                        let words = String.split_on_char ' ' l in
                        List.iter (
                            fun word -> 
                                let low_word = String.lowercase_ascii word in
                                if (Hashtbl.mem occ low_word) 
                                then Hashtbl.replace occ low_word ((Hashtbl.find occ low_word) + 1) 
                                else Hashtbl.add occ low_word 1
                                ) 
                        words;
                        count t
                | [] -> () in
            count (In_channel.input_lines f)

        let freq word = Hashtbl.find occ word;;

        let words () = Hashtbl.iter 
        ( fun word count -> Printf.printf "%s: %d\n" word count)
        occ;;

    end;;
