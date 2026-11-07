let is_prime n =
    let rec aux curr =
        if curr <= 2 then true
        else if (n mod curr) = 0 then false
        else aux (curr-1)
    in
    aux (n/2)

let gcd a b =
    let rec aux a b =
        let k = a mod b in
        if k = 0 then b
        else aux b k
    in if a > b then aux a b else aux b a

(* Better version of gcd *)
let rec gcd_better a b =
    if b = 0 then a else gcd_better b (a mod b)

let coprime a b = gcd_better a b = 1

let phi m =
    let rec phi n acc =
        if n < m then if coprime m n then phi (n+1) (acc+1) else phi (n+1) acc
        else acc in
    phi 1 0

let factors n =
    let rec factors n curr acc =
        if n <> 1 then
            if is_prime curr then
                if n mod curr = 0 then 
                    factors (n/curr) curr (curr :: acc)
                else
                    factors n (curr+1) acc
            else
            factors n (curr+1) acc
        else
            acc in
    List.rev (factors n 2 [])
