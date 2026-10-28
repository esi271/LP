let cqsort (>:) l =

    let rec cqsort l f =
        match l with
        | [] | [_] -> f l
        | hd :: tl ->
            cqsort (List.filter (fun x -> x >: hd) tl)
            (fun ls ->
                cqsort (List.filter (fun x -> hd >: x) tl)
                (fun ld -> f (ls @ [hd] @ ld))
            )
    in cqsort l (fun x -> x);;  
