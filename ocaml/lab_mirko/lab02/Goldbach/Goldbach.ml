module type Goldbach = sig 

    type g_partition = (int * (int * int))

    val goldbach : int -> g_partition option
    val goldbach_list : int -> int -> g_partition list

end

module Goldbach : Goldbach = struct

    type g_partition = (int * (int * int))

    let is_prime n =
        let rec is_prime = function
            | x when x*x > n -> true
            | x when n mod x = 0 -> false
            | x -> is_prime (x+1) in
        if n < 2 then false else
        is_prime (2)

    let goldbach n =
        if n mod 2 <> 0 then None
        else
            let rec search p =
                if is_prime p && is_prime (n-p) 
                then Some (n, (p, n-p)) 
                else search (p+1) in
            search 2

    let goldbach_list n m = 
        let rec aux acc curr =
            if curr > m then acc
            else 
                match goldbach curr with
                | None -> aux acc (curr+1)
                | Some g -> aux (g::acc) (curr+1) in
        List.rev (aux [] n)

end
