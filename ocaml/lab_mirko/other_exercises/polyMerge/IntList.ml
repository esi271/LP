open PolyMergeADT

module IntList : PolyMergeADT with type elt = int and type t = int list = struct

    type elt = int
    type t = int list

    let empty () = []
    let length l = List.length l
    let append a b = List.append a b
    let cons a l = List.cons a l
    let is_empty l = List.is_empty l
    let rev l = List.rev l

    let hd l = List.hd l
    let tl l = List.tl l

end
