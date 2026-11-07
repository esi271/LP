module type GraphADT = 
    sig

        type 'a graph

        val empty : unit -> 'a graph

        val is_in_graph : 'a -> 'a graph -> bool
        val add_node : 'a -> 'a graph -> 'a graph
        val add_edge : 'a -> 'a -> 'a graph -> 'a graph

        val adjacents : 'a -> 'a graph -> 'a list
        val is_adjacent : 'a -> 'a -> 'a graph -> bool 

    end

(* Implementation of a bidirectional graph *)
module Graph : GraphADT = 
    struct
        
        type 'a graph = Empty | Graph of ('a * 'a list) list

        let empty () = Empty

        (* Checks if node is in the graph *)
        let is_in_graph n = function
            | Empty -> false
            | Graph g -> 
                    let rec aux acc = function
                        | [] -> acc
                        | (node, _)::t -> aux (acc|| node = n) t
                    in
                    aux false g

        (* Adds node if not present in the graph *)
        let add_node n = function
            | Empty -> Graph ((n, [])::[])
            | Graph g -> 
                    let rec add_node acc = function
                        | [] -> Graph ((n, [])::acc)
                        | h :: t when (fst h) = n -> Graph (List.rev_append (h::acc) t)
                        | h :: t -> add_node (h::acc) t 
                    in add_node [] g

        (* Adds an edge from 2 nodes, non existent nodes get created *)
        let add_edge n1 n2 g = 
            let rec add_edge a b acc = function
                | [] -> acc
                | (n, nb)::t when n1 = a -> List.rev_append ((n, b::nb)::acc) t
                | h :: t -> add_edge a b (h :: acc) t
            in
            let g' = 
                match add_node n1 (add_node n2 g) with
                | Empty -> []
                | Graph gr -> gr
            in Graph (add_edge n2 n1 [] (add_edge n1 n2 [] g'))

        let adjacents n g =
            match g with 
            | Empty -> []
            | Graph gl -> 
                    if is_in_graph n g then
                        snd (List.find (fun x -> fst x = n) gl)
                    else 
                        []

        let is_adjacent n1 n2 g =
            List.exists (fun x -> x = n2) (adjacents n1 g)

    end
