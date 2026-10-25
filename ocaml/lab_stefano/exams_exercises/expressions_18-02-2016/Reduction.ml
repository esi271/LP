module ArithExpr =
    struct
    
        type exp =
        | Sum of exp * exp
        | Min of exp * exp
        | Mul of exp * exp
        | Div of exp * exp
        | Number of float

        let rec tostring = function
        | Number f -> Printf.sprintf "%s" (string_of_float f)
        | Sum (e1, e2) -> Printf.sprintf "(%s + %s)" (tostring e1) (tostring e2)
        | Min (e1, e2) -> Printf.sprintf "(%s - %s)" (tostring e1) (tostring e2)
        | Mul (e1, e2) -> Printf.sprintf "(%s * %s)" (tostring e1) (tostring e2)
        | Div (e1, e2) -> Printf.sprintf "(%s / %s)" (tostring e1) (tostring e2)

        let rec eval = function
        | Number f -> Number f
        | Sum (Number (a), Number (b)) -> Number (a +. b)
        | Sum (e1, e2) ->  Sum((eval e1),(eval e2))
        | Min (Number (a), Number (b)) -> Number (a -. b)
        | Min (e1, e2) ->  Min((eval e1),(eval e2))
        | Mul (Number (a), Number (b)) -> Number (a *. b)
        | Mul (e1, e2) ->  Mul((eval e1),(eval e2))
        | Div (Number (a), Number (b)) -> Number (a /. b)
        | Div (e1, e2) ->  Div((eval e1),(eval e2))

        (* string in polish notation  and numbers in the initial expression are only 1-figure integers.*)
        let parse str = 
            let rec parse str index =
                match str.[index] with
                |'1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9' -> 
                    let s = (String.make 1 (str.[index]))^"." in
                    (Number (float_of_string s), (index + 1))
                | '+' -> 
                    let e1, index1 = parse str (index + 1) in 
                    let e2, index2 = parse str (index1) in 
                    (Sum (e1, e2), (index2))
                | '-' ->
                    let e1, index1 = parse str (index + 1) in 
                    let e2, index2 = parse str (index1) in 
                    (Min (e1, e2),(index2))
                | '*' ->
                    let e1, index1 = parse str (index + 1) in 
                    let e2, index2 = parse str (index1) in 
                    (Mul (e1, e2), (index2))
                | '/' ->
                    let e1, index1 = parse str (index + 1) in 
                    let e2, index2 = parse str (index1) in 
                    (Div (e1, e2), (index2))
            in 
            let (r, _) = parse str 0 in
            r
        
        let print_evaluation str = 

            let rec print_evaluation_exp exp =
                print_endline (tostring exp);
                match exp with
                | Number (n) -> ()
                | _ -> print_evaluation_exp (eval exp)
            in
            print_evaluation_exp (parse str)
            
    end;;