module Graph : GraphADT =
    struct

        type ('a, 'b) graph = 'a list * ('b * ('a * 'a)) list

        let empty () = ([], [])

        let rec insert_node ?(acc = []) n = function
        | [] -> List.rev (n :: acc)
        | hd :: tl when hd = n -> List.rev_append acc (hd :: tl)
        | hd :: tl -> insert_node ~acc:(hd :: acc) n tl

        let add_node n = function
        |([], arcs) -> ([n], arcs)
        |(nodes, arcs) -> ((insert_node n nodes), arcs)

        let rec contains_node n = function
        | [] -> false
        | hd :: tl when hd = n -> true
        | hd :: tl -> contains_node n tl

        let node_is_in_graph n = function
        | (nodes, _) -> contains_node n nodes

        let nodes = function
        | (nodes, _) -> nodes

        let rec insert_link ?(acc = []) label e1 e2 = function
        | [] -> 
            let link = (label, (e1, e2)) in
            List.rev (link :: acc)
        |(l, (n1, n2)) :: tl ->
            if ((l = label) && (((e1 = n1 && e2 = n2) || (e1 = n2 && e2 = n1)))) then
                List.rev_append acc ((l, (n1, n2)) :: tl)
            else insert_link ~acc:((l, (n1, n2)) :: acc) label e1 e2 tl

        let add_link label n1 n2 = function
        |(nodes, arcs) when (contains_node n1 nodes) && (contains_node n2 nodes) -> 
            (nodes, insert_link label n1 n2 arcs)
        | (nodes, arcs) -> (nodes, arcs) 

        let rec find_adjacents ?(acc = []) node = function
        | [] -> acc
        | (l, (n1, n2)) :: tl -> 
            if n1 = node then find_adjacents ~acc:((l, n2) :: acc) node tl
            else if n2 = node then find_adjacents ~acc:((l, n1) :: acc) node tl
            else find_adjacents ~acc:(acc) node tl

        let adjacents node = function
        | (nodes, arcs) ->
            if contains_node node nodes then find_adjacents node arcs
            else []

    end;;
