module N : NaturalI.NaturalI =
    struct

        type natural =
        | Zero 
        | Succ of natural

        exception NegativeNumber
        exception DivisionByZero
      
        (* n1 + n2 *)
        let ( + ) n1 n2 =

            let rec add n1 = function
            | Zero -> n1
            | Succ n -> add (Succ n1) n
            in
            add n1 n2

        (* n1 - n2 *)
        let ( - ) n1 n2 =

            let rec sub n1 n2 =
                match n1, n2 with
                | _, Zero -> n1
                | Succ(n1'), Succ(n2') -> sub n1' n2'
                | Zero, Succ(_) -> raise NegativeNumber
            in 
            sub n1 n2

        (* n1 * n2 *)
        let ( * ) n1 n2 =

            let rec mul res n2 =
                match res, n2 with
                |Zero, _ | _, Zero -> Zero
                |_, Succ Zero -> res
                |Succ Zero, _ -> n2
                | _, Succ(n2') -> mul (res + n1) n2'
            in 
            mul n1 n2

        (* n1 / n2 *)
        let ( / ) n1 n2 =

            let rec aux (Succ res) =
                let mul = n2 * (Succ res) in
                if mul = n1 then (Succ res)
                else if mul > n1 then res
                else aux (Succ (Succ res))
            in
            match n1, n2 with
            | _, Zero -> raise DivisionByZero
            | Zero, _ -> Zero
            | e1, e2 when e1 = e2 -> Succ Zero
            | e1, e2 when e1 < e2 -> Zero
            | _, _ -> aux (Succ(Succ Zero))

        
        let convert i = 
            let rec convert ?(res = Zero) i =
                if i = 0 then res
                else convert ~res:(Succ res) (pred i)
            in convert i

        
        let eval n =
            let rec eval ?(res = 0) = function
            | Zero -> res 
            | Succ(n') -> eval ~res:(succ res) n'
            in eval n 



    end;;