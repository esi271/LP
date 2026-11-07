type expr = 
      Expr of float
    | Add of expr * expr
    | Sub of expr * expr
    | Mul of expr * expr
    | Div of expr * expr

let print_expr expr = 
    let rec aux acc = function
    | Expr f -> Printf.sprintf " %s " (string_of_float f)
    | Add (l, r) -> Printf.sprintf "( %s + %s )" (aux "" l) (aux "" r)
    | Sub (l, r) -> Printf.sprintf "( %s - %s )" (aux "" l) (aux "" r)
    | Mul (l, r) -> Printf.sprintf "( %s * %s )" (aux "" l) (aux "" r)
    | Div (l, r) -> Printf.sprintf "( %s / %s )" (aux "" l) (aux "" r) in
    Printf.printf "%s" ((aux "" expr) ^ "\n")

let is_op = function
    | '+' | '-' | '*' | '/' -> true
    | _ -> false

let to_expr c e1 e2 =
  match c with
  | '+' -> Add (e1, e2)
  | '-' -> Sub (e1, e2)
  | '*' -> Mul (e1, e2)
  | '/' -> Div (e1, e2)
  | _ -> raise (Invalid_argument "to_expr: unknown operator")

let read str =
    let f_of_c c = float_of_int (Char.code c - Char.code '0') in
    let s = Stack.create () in
    let rec read = function
        | [] -> ()
        | h :: t when is_op h -> 
                let s1 = Stack.pop s in
                let s2 = Stack.pop s in
                Stack.push (to_expr h s1 s2) s;
                read t
        | h :: t -> 
                Stack.push (Expr (f_of_c h)) s;
                read t
    in
    read (List.rev (List.of_seq (String.to_seq str)));
    Stack.pop s

let rec merge = function
    | Expr(f) -> Expr(f) 
    | Add(Expr(n1), Expr(n2)) -> Expr(n1+.n2)
    | Add(n1, n2) -> Add((merge n1), (merge n2))
    | Sub(Expr(n1), Expr(n2)) -> Expr(n1-.n2)
    | Sub(n1, n2) -> Sub((merge n1), (merge n2))
    | Mul(Expr(n1), Expr(n2)) -> Expr(n1*.n2)
    | Mul(n1, n2) -> Mul((merge n1), (merge n2))
    | Div(Expr(n1), Expr(n2)) -> Expr(n1/.n2)
    | Div(n1, n2) -> Div((merge n1), (merge n2))

let print_evaluation str = 
    let rec print_evaluation expr = 
        print_expr expr;
        match expr with
        | Expr e -> ()
        | e -> print_evaluation (merge e) in
    print_evaluation (read str)

