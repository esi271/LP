type 'a matrix = 'a array array;;

(* A function zeroes to construct a matrix of size n×m filled with zeros *)

let zeroes n m = 
    Array.make_matrix n m 0;;

(* A function identity to construct the identity matrix (the one with all 0s but the 1s on the diagonal) of given size. *)

let identity n = 
    let f x y = if x = y then 1 else 0 in
    Array.init_matrix n n f;;

(* A function init to construct a square matrix of a given size n filled with the first n×n integers. *)

let init n =
    let f x y = n*x+y in
    Array.init_matrix n n f;;

(* A function transpose that transposes a generic matrix independently of its size and content. *)

let transpose mat =
    let f x y = mat.(y).(x) in
    Array.init_matrix (Array.length mat.(0)) (Array.length mat) f;;

let rows mat = (Array.length mat);;
let cols mat = (Array.length mat.(0));;

let sum_mat mat1 mat2 =
    if (rows mat1) <> (rows mat2) || (cols mat1) <> (cols mat2) then Array.make_matrix 1 1 (-1) else
        let f x y = mat1.(x).(y) + mat2.(x).(y) in
        Array.init_matrix (rows mat1) (cols mat1) f;;
