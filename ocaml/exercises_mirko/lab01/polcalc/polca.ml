module type StackADT = sig 

    type 'a stack
    exception EmptyStackException

        val empty : unit -> 'a stack

        val push : 'a stack -> 'a -> unit
        val pop : 'a stack -> 'a
        val is_empty : 'a stack -> bool

        val length : 'a stack -> int

end

module Stack = struct

    type 'a stack = { mutable s : 'a list }
    exception EmptyStackException

    let empty () = { s = [] }

    let push stack x =
        stack.s <- x :: stack.s

    let pop stack =
        match stack.s with
        | h :: t -> 
                stack.s <- t;
                h
        | [] -> raise EmptyStackException

    let is_empty stack = (List.length stack.s) = 0

    let length stack = List.length stack.s


end

module PolishCalculator (Stack : StackADT) =
    struct 

        type expr = 
            | Value of int
            | Sum of expr * expr
            | Sub of expr * expr
            | Neg of expr
            | Mul of expr * expr
            | Div of expr * expr
            | Pow of expr * expr

        let pow a b =
            let rec aux acc b = 
                if b = 0 then acc else aux (acc*a) (b-1)
            in
            aux 1 b


        let is_op = function
            | "+" | "-" | "*" | "/" | "**" -> true
            | _ -> false

        let expr_of_string str = 
            let stack = Stack.empty ()in
            let split = String.split_on_char ' ' str in
            let pop () = Stack.pop stack in
            let push x = Stack.push stack x in

            let binary op =
                let a = pop () in
                let b = pop () in
                push (op a b) in

            let unary op =
                let a = pop () in
                push (op a) in

            List.iter (fun tok ->
                if is_op tok then
                    match tok with
                    | "+" -> binary (fun a b -> Sum (a, b))
                    | "-" -> if Stack.length stack = 1 then unary (fun a -> Neg a) else
                        binary (fun a b -> Sub (a, b))
                    | "*" -> binary (fun a b -> Mul (a, b))
                    | "/" -> binary (fun a b -> Div (a, b))
                    | "**" -> binary (fun a b -> Pow (a, b))
                    | _ -> ()
                    else
                        push (Value (int_of_string tok))
                        ) split;
        pop ()


            let rec eval = function
                | Value n -> n
            | Sum (a, b) -> (eval a) + (eval b)
            | Sub (a, b) -> (eval a) - (eval b)
            | Neg n -> - (eval n)
            | Mul (a, b) -> (eval a) * (eval b)
            | Div (a, b) -> (eval a) / (eval b)
            | Pow (a, b) -> pow (eval a) (eval b)


end

