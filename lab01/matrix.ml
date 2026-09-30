type matrix = int list list;;

(* A function zeroes to construct a matrix of size n×m filled with zeros *)

let zeroes n m = 
    List.init n (fun x -> List.init m (fun x -> 0));;

(* A function identity to construct the identity matrix (the one with all 0s but the 1s on the diagonal) of given size. *)

let identity n = 
    List.init n (fun x -> List.init n (fun y -> if x = y then 1 else 0));;

(* A function init to construct a square matrix of a given size n filled with the first n×n integers. *)

let init n =
    List.init n (fun x -> List.init n (fun y -> y+n*x));;

(* A function transpose that transposes a generic matrix independently of its size and content. *)

let rows mat = (List.length mat);;
let cols mat = (List.length (List.hd mat));;

let cell_value mat i j = List.nth (List.nth mat i) j;;

let transpose mat =
    List.init (cols mat) (fun x -> List.init (rows mat) (fun y -> cell_value mat y x));;


let mat_sum mat1 mat2 =
    List.init (rows mat1) (
        fun x -> 
        List.init (cols mat1) (
            fun y -> (
                cell_value mat1 x y)+(cell_value mat2 x y)
                )
        );;

let dot_prod a b =
    let rec aux res a b = 
        match a, b with
        | ha :: ta, hb :: tb -> aux (res + (ha*hb)) ta tb
        | _, _ -> res in
    aux 0 a b;;

let mat_prod m1 m2 =
    let mt2 = transpose m2 in
    List.init (rows m1) (
        fun x -> List.init (rows mt2) (
            fun y -> dot_prod (List.nth m1 x) (List.nth mt2 y)
        )
    );;
