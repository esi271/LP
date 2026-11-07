open ComparableADT;;
open IntervalADT;;


module Interval (T : Comparable) : (IntervalI with type endpoint = T.t) =
    struct

        type endpoint = T.t
        type interval = 
        | Interval of endpoint * endpoint
        | Empty
        exception WrongInterval

        let create e1 e2 =
            if (T.compare e1 e2) > 0 then raise WrongInterval
            else if (T.compare e1 e2) = 0 then Empty
            else Interval (e1, e2)

        let is_empty = function
        | Interval (_, _) -> false
        | Empty -> true

        let contains interval e = 
            match interval with
            | Interval (min, max) ->
                if (T.compare e min) < 0 then false
                else if (T.compare e max) > 0 then false
                else true
            | Empty -> false

        let intersect interval1 interval2 =
            let max a b = if (T.compare a b) >= 0 then a else b in
            let min a b = if (T.compare a b) <= 0 then a else b in
            match interval1, interval2 with
            | Interval (min1, max1), Interval (min2, max2) ->
                Interval ((max min1 min2), (min max1 max2))
            | Empty,_ | _, Empty -> Empty

        let tostring = function
        | Interval (min, max) -> Printf.sprintf "[%s, %s]" (T.tostring min) (T.tostring max)
        | Empty -> "[]"
      
    end;;

module IntInterval = Interval (
    struct

        type t = int
        let compare a b = compare a b
        let tostring a = string_of_int a

    end
);;

module StringInterval = Interval (
    struct

        type t = string
        let compare a b = compare a b
        let tostring a = a

    end
);;

