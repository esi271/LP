open Comparable;;
open IntervalI;;

module Interval (T : Comparable) : (IntervalI with type endpoint = T.t) = struct

    type endpoint = T.t
    type interval = Interval of endpoint * endpoint | Empty

    exception WrongInterval

    let create b e = 
        if (T.compare b e) > 0 then raise WrongInterval
        else if (T.compare b e) = 0 then Empty 
        else Interval (b, e)

    let is_empty = function
        | Empty -> true
        | _ -> false

    let contains i e = 
        match i with
        | Empty -> false
        | Interval (start, fin) -> 
                if T.compare start e <= 0 && T.compare fin e >= 0 then true
                else false

    let intersect i1 i2 =
        match i1, i2 with
        | Empty, Empty -> Empty
        | _, Empty | Empty, _ -> Empty
        | Interval (a, b), Interval (c, d) -> Interval (max a b, min b d)

    let tostring = function
        | Empty -> "[]"
        | Interval (a, b) -> Printf.sprintf "[%s, %s]" (T.tostring a) (T.tostring b)

end

module IntInterval = Interval(
    struct
        type t = int
        let compare a b = Int.compare a b
        let tostring a = Int.to_string a
    end)

module StringInterval = Interval(
    struct
        type t = string
        let compare a b = String.compare a b
        let tostring a = a
    end)
