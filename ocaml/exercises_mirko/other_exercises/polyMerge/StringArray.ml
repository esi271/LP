open PolyMergeADT ;;

module StringArray : PolyMergeADT with type elt = string and type t = string array = struct

    type elt = string 
    type t = string array

    let empty () = [||]
    let length a = Array.length a
    let append a b = Array.append a b
    let cons a arr = append [|a|] arr
    let is_empty a = Array.length a = 0
    let rev a = Array.init (length a) (fun i -> a.(length a-i-1))

    let hd a = a.(0)
    let tl a = Array.sub a 1 (length a-1)

end
