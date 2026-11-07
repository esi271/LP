module Huffman (P : Printable) : HuffmanI = struct

    type elt = P.t
    type tree = Leaf of elt | Tree of (tree * tree)

    exception EmptyInput
    exception NotFound

    let frequencies list = 
    List.rev (
        List.fold_left 
        (fun acc c -> 
                match List.assoc_opt c acc with
                | Some x -> (c, x + 1) :: (List.remove_assoc x acc)
                | None -> (c, 1) :: acc
        ) [] list)

    let build freqs = ()
       

end
