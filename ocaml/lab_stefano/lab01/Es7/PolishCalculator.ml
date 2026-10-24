module PolishCalculator (S : StackADT) =
    struct

        type exp =
            | Int of int
            | Neg of exp
            | Sum of exp * exp
            | Dif of exp * exp
            | Mul of exp * exp
            | Div of exp * exp
            | Pow of exp * exp


        let expr_of_string str =

            let build stack str =

                let binary_operation stack f =
                    let (b, s1) = S.pop stack in
                    let (a, s2) = S.pop s1 in
                    S.push s2 (f a b)
                in
                
                match int_of_string_opt str with
                | Some(n) -> S.push stack (Int n)
                | _ ->
                    match str with
                    | "+" -> binary_operation stack (fun a b -> Sum (a, b))
                    | "*" -> binary_operation stack (fun a b -> Mul (a, b))
                    | "/" -> binary_operation stack (fun a b -> Div (a, b))
                    | "**" -> binary_operation stack (fun a b -> Pow (a, b))
                    | "-" ->
                        if S.size stack = 1 then 
                            let (b, s1) = S.pop stack in
                            S.push s1 (Neg b)
                        else binary_operation stack (fun a b -> Dif (a, b))
                    | _ -> failwith "Operation not valid"
            in

            let c_list =  List.filter (fun s -> s <> "") (String.split_on_char ' ' str) in
            let conversion = List.fold_left (build) (S.empty ()) c_list in
            let (res, _) = S.pop conversion in
            res


        let eval expr = 
            let rec eval expr =

                let rec pow ?(acc = 1) b e =
                    if e = 0 then acc
                    else pow ~acc:(acc * b) b (e - 1)
                in

                match expr with
                | Int n -> n
                | Neg ex -> eval ex
                | Sum (ex1, ex2) -> (eval ex1) + (eval ex2) 
                | Dif (ex1, ex2) -> (eval ex1) - (eval ex2) 
                | Mul (ex1, ex2) -> (eval ex1) * (eval ex2) 
                | Div (ex1, ex2) -> (eval ex1) / (eval ex2) 
                | Pow (ex1, ex2) -> pow (eval ex1) (eval ex2) 
                
            in eval expr;

    end