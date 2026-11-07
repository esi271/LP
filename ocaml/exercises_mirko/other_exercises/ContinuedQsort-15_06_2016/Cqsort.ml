module Cqsort = struct

    let cqsort (>:) l = 
        let rec cqsort l c =
            match l with
        | [] -> c l
        | h :: t -> cqsort
        (List.filter (fun x -> x >: h) t)
        (fun ll -> c (cqsort
            (List.filter (fun y -> h >: y) t)
            (fun gl -> ((ll @ [h]) @ gl)))) in
        cqsort l (fun x -> x)

end
