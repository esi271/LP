open NaturalI

module N : NaturalI = struct

    type natural = Zero | Succ of natural
    exception NegativeNumber
    exception DivisionByZero

    let rec (+) a b =
        match a, b with
        | Zero, Zero -> Zero
        | x, Zero | Zero, x -> x
        | x, Succ y -> Succ x + y

    let rec (-) a b =
        match a, b with
        | Zero, Zero -> Zero
        | Zero, Succ x -> raise NegativeNumber
        | x, Zero -> x
        | Succ x, Succ y -> x - y

    let ( * ) a b =
        if a > Zero 
        then
            let rec mul r = function
                | Zero -> r
                | Succ Zero -> r+a
                | Succ x -> mul (r+a) x
            in
            mul Zero b
        else     
            Zero

    let (/) a b =
        if a = Zero then Zero
        else if b = Zero then raise DivisionByZero
        else
            let rec aux r = 
                if r * b = a then r
                else if (Succ r) * b > a then r
                else aux (Succ r)
            in
            aux Zero


    let rec eval = function
        | Zero -> 0
        | Succ x -> succ (eval x)

    let convert n =
        let rec convert r n =
            if n > 0 then convert (Succ r) (pred n)
            else r in
        convert Zero n

end
