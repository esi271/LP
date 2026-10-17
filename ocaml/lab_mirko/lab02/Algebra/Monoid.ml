module type MonoidSupport =
    sig

        type t

        val id : t
        val op : t -> t -> t
        val eq : t -> t -> bool

    end

module BoolSupport : MonoidSupport with type t = bool =
    struct
        type t = bool

        let op a b = a || b

        let id = false

        let eq a b = a = b
    end

module IntZn (N : sig val n : int end) : MonoidSupport with type t = int =
    struct

        type t = int

        let op a b = (a+b) mod N.n

        let id = 1

        let eq a b = a = b

    end

(* A monoid is an algebraic structure consisting of a set together with a single associative binary operation
and an identity element.
E.g., the set of booleans with the or operator is a monoid whose identity is false. *)
module Monoid (T : MonoidSupport) =
    struct

        let assoc a b c =
            T.eq (T.op (T.op a b) c) (T.op a (T.op b c))

        let is_monoid set =
            List.for_all ( fun x ->
                List.for_all (fun y ->
                    List.for_all (fun z -> assoc x y z) set) set) set
            && 
            List.for_all (fun a -> T.eq (T.op a T.id) a && T.eq (T.op T.id a) a) set

    end
