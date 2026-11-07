module Qsort = struct

    let qsort (>:) l =
        let rec qsort = function
            | [] -> []
            | h :: t -> qsort (List.filter (fun x -> x >: h) t)
            @ [h] @
                        qsort (List.filter (fun x -> h >: x) t)
        in
        qsort l

end
