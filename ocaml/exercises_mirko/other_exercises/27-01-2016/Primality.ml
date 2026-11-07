module Primality = struct

        let trialdivision n = 
                let rec aux = function
                        | x when x <= 2 -> true
                        | x -> if n mod x = 0 then false else aux (x-1)
                in
                if n < 0 then false
                else if n mod 2 = 0 then false
                else aux (n/2)

        let lucaslehmer n =
                let rec aux s p =
                        if p = 0 then s = 0
                        else aux ((s*s-2) mod n) (p-1)
                in
                aux 4 ((int_of_float ((log ((float n) +. 1.)) /. log 2.))-2)

        let modexp b e m =
                let rec modexp' c b e' e m =
                        if e' <= e then modexp' ((c*b) mod m) b (e'+1) e m
                        else c
                in modexp' 1 b 1 e m

        let range a b = 
                let rec range acc i =
                        if i = b then acc else range (i::acc) (i+1)
                in
                range [] a

        let littlefermat n = 
                List.length (
                        List.filter (
                                fun x -> (modexp x (n-1) n) <> 1
                ) (range 2 (int_of_float (log (float n))+1))) == 0

        let is_prime n = 
                if n <= 10000 then trialdivision n
                else if (10001 <= n) && (n <= 524287) then lucaslehmer n
                else littlefermat n

end
