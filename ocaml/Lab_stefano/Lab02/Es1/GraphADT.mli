module type GraphADT =
    sig

        (*dichiara un tipo astratto con due parametri*)
        type ('a, 'b) graph

        val empty : unit -> ('a, 'b)  graph
        val add_node : 'a -> ('a, 'b)  graph -> ('a, 'b)  graph
        val node_is_in_graph : 'a -> ('a, 'b)  graph -> bool
        val nodes : ('a, 'b)  graph -> 'a list
        val add_link : 'b -> 'a -> 'a -> ('a, 'b)  graph -> ('a, 'b)  graph
        val adjacents : 'a -> ('a, 'b) graph -> ('b * 'a) list

    end;;