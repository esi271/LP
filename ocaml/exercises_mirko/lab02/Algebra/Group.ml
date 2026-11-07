module type GroupSupport =
    sig

        type t

        val id : t
        val op : t -> t -> t
        val eq : t -> t -> bool
        val inv : t -> t option

    end

module BoolSupport : GroupSupport with type t = bool =
    struct
        type t = bool

        let op a b = a || b
        let id = false
        let eq a b = a = b
        let inv a = Some (not a)

    end

module IntZ : GroupSupport with type t = int =
    struct

        type t = int

        let op a b = a+b
        let id = 0
        let eq a b = a = b
        let inv a = Some (-a)

    end

module IntZnMult (N : sig val n : int end) : GroupSupport with type t = int =
    struct

        type t = int

        let op a b = (a*b) mod N.n
        let id = 1
        let eq a b = a = b

        let rec egcd a b = 
            if b = 0 then (a, 1, 0)
            else
                let (g,x,y) = egcd b (a mod b) in
                (g, y, x-(a/b)*y)

        let inv a = 
            let (g, x, _) = egcd a N.n in
            if g <> 1 then None
            else Some (((x mod N.n) + N.n) mod N.n)

    end

module StringSupport : GroupSupport with type t = string =
    struct

        type t = string

        let op a b = if String.length a > String.length b then a else b
        let id = String.empty
        let eq a b = String.equal a b
        let inv a = None

    end

module Group (T : GroupSupport) =
    struct
    include Monoid.Monoid (T)

        let has_inverse a =
            match T.inv a with
            | None -> false
            | Some _ -> true

        let is_group set =
            is_monoid set &&
            List.for_all (has_inverse) set

    end
