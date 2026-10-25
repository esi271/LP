module Hamming : (
    sig
        val hamming : string -> string -> int * (char * char) list
    end
) =
    struct

    exception Invalid_arg

    let rec length ?(acc = 0) s =
        try
            let _ = s.[acc] in
            length ~acc:(acc + 1) s
        
        with _ -> acc;;

    let fold2_right acc f s1 s2 =
        let l = length s1 in
        let rec fold index = 
            match index with
            | i when i = l -> acc
            | _ -> 
                f (s1.[index]) (s2.[index]) (fold (index + 1))
        in fold 0;; 
    
    let hamming s1 s2 =
        if (length s1) <> (length s2) then raise Invalid_arg
        else
            fold2_right (0, [])
            (fun a b acc ->
                let n = fst acc in
                let l = snd acc in
                if a = b then acc
                else (n+1, ((a, b) :: l))
                ) s1 s2;;
    end;;