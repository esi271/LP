module SocialNetwork (G : GraphADT) =
    struct

        type network = { g : string G.graph }

        exception EmptyGraph
        exception NotInGraph

        let rec edges_to_graph edges =
            let rec aux g = function
                | [] -> { g = g }
                | (a,b)::t -> aux (G.add_edge a b g) t in
            aux (G.empty ()) edges

        let dfs g n =
            let rec dfs g n g' = function
                | [] -> g'
                | h :: t when (G.is_in_graph h g') -> dfs g n g' t
                | h :: t -> dfs g n (G.add_edge h n (dfs g h (G.add_node h g') (G.adjacents h g))) t
            in
            if (g = G.empty ()) then raise EmptyGraph
            else if not (G.is_in_graph n g) then raise NotInGraph
            else dfs g n (G.empty ()) (G.adjacents n g)

    end
