open PolyMerge ;;

let module IM = PolyMerge(IntList);;

let main () =
    let a = IM.sort [5;1;2;51;2;51;521;51] in
    List.ite
