module SocialNetwork (G : GraphADT) = 
    struct

        type user = string

        type label =
        | Friendship
        | Kinship
        | FinancialExchange
        | Dislike
        | SexualRelationship
        | Beliefs
        | Knowledge
        | Prestige

        type ('a, 'b) tree =
        | Tree of 'a * (('b * ('a, 'b) tree) list)
        | Leaf of 'a

        type socialNetwork = (user, label) G.graph

        let empty () = G.empty ()

        let add_user u sn = G.add_node u sn

        let add_relation u1 label u2 sn = G.add_link label u1 u2 sn

        let users sn = G.nodes sn

        let get_network_tree_from_root u sn =

            let contains n l = 
                List.fold_left (fun acc c -> acc || (c = n)) false l
            in
            let subtract l1 l2 =
                List.fold_right (fun (l,e) acc -> if (contains e l2) then acc else ((l,e) :: acc)) l1 []
            in

            let rec create_tree n visited = function
            | [] -> Leaf n, (n::visited)
            | adj -> 
                let f1, visited = create_forest adj (n :: visited) in
                Tree (n, f1), visited
            and create_forest ?(acc = []) l visited =
                match l with
                | [] -> acc, visited
                | (l, n) :: tl ->
                    if contains n visited then
                        create_forest ~acc:(acc) tl visited
                    else
                        let adj = subtract (G.adjacents n sn) visited in
                        let t1, visited  = create_tree n visited adj in
                        create_forest ~acc:((l, t1) :: acc) tl visited
            in create_tree u [] (G.adjacents u sn)

        let get_network_tree sn = 

            let contains n l = 
                List.fold_left (fun acc c -> acc || (c = n)) false l
            in
            let subtract l1 l2 =
                List.fold_right (fun e acc -> if (contains e l2) then acc else ((e :: acc))) l1 []
            in

            let rec build ?(acc = []) nodes visited =
                match nodes with
                | [] -> acc
                | n :: tl -> 
                    let t, visited = get_network_tree_from_root n sn in
                    build ~acc:(t :: acc) (subtract nodes visited) visited
            in build (users sn) []
                        
    end;;