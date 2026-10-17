(* A ring is an algebraic structure consisting of a set together with two binary operations (usually called addition and multiplication),
   where each operation combines two elements to form a third element.
   To qualify as a ring, the set together with its two operations must satisfy certain conditions, namely, the set must be an abelian
   (i.e., commutative) group under addition and a monoid under multiplication such that multiplication distributes over addition. *)
module type RingADT = sig

    type t
    val is_ring : t list -> bool

end

module Ring (T : RingSupport.RingSupport) : RingADT with type t = T.t = struct

    type t = T.t
    let (+) = T.(+)
    let ( * ) = T.( * )

    let assoc ($) a b c = 
        T.eq ((a$b)$c) (a$(b$c))

    let commu ($) a b = 
        T.eq (a$b) (b$a)

    let distr a b c =
        T.eq (a*(b+c)) ((a*b)+(a*c)) &&
        T.eq ((b+c)*a) ((b*a)+(c*a))

    let inv a = 
        match T.inv a with
        | None -> false
        | Some n -> true

    let for_all_triples p set =
        List.for_all ( fun x ->
            List.for_all (fun y ->
                List.for_all (fun z -> p x y z) set) set) set

    let for_all_pairs p set =
        List.for_all ( fun x ->
            List.for_all (fun y -> p x y) set) set

    let has_id ($) set id = 
        List.for_all (fun x -> T.eq (x$id) x) set
        
    let is_group set =
        for_all_triples (assoc (+)) set && for_all_pairs (commu (+)) set &&
        has_id (+) set T.add_id &&
        List.for_all (fun x -> inv x) set

    let is_monoid set =
        for_all_triples (assoc ( * )) set && has_id ( * ) set T.mult_id

    let is_ring set = 
        is_group set && is_monoid set && for_all_triples distr set

end
