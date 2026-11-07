open PolyMergeADT ;;

module PolyMerge (T : PolyMergeADT) = struct

    let split a =
        let len = T.length a in
        let rec split acc cnt l =
            if cnt = 0 then (T.rev acc, l)
            else split (T.cons (T.hd l) acc) (cnt-1) (T.tl l) in
        split (T.empty ()) (len/2) a

    let merge (>:) a b =
        let rec merge acc a b =
            if T.is_empty a then T.append b acc
            else if T.is_empty b then T.append a acc
            else if T.hd a >: T.hd b
            then merge (T.cons (T.hd a) acc) (T.tl a) b
            else merge (T.cons (T.hd b) acc) a (T.tl b) in
        T.rev (merge (T.empty ()) a b)

    let rec sort (>:) t =
        if T.length t <= 1 then t
        else
            let (l, r) = split t in
            merge (>:) (sort (>:) l) (sort (>:) r)

end
