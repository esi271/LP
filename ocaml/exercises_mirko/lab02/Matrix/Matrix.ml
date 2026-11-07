module type MatrixADT = sig

    type t
    type matrix

    val eq : matrix -> matrix -> bool
    val copy : matrix -> matrix 
    val add : matrix -> matrix -> matrix
    val scalar : t -> matrix -> matrix
    val mult : matrix -> matrix -> matrix
    val transpose : matrix -> matrix
    val norm : matrix -> t

end

module Matrix (R: Ring.Ring) : MatrixADT
with type t = R.t and type matrix = R.t list list = struct

    type t = R.t
    type matrix = t list list

    exception MatrixDimension

    let (+) = R.(+)
    let ( * ) = R.( * )

    (* Helper functions *)
    let rows a = List.length a
    let cols a = List.length (List.nth a 0)
    let get m i j = List.nth (List.nth m i) j

    let dot_prod a b = List.fold_left2 (fun acc na nb -> na*nb+acc) R.zero a b

    (* Main functions *)

    let eq a b = a = b

    let copy a = a

    let add a b =
        if rows a <> rows b || cols a <> cols b then raise MatrixDimension
        else List.map2 (fun row_a row_b -> List.map2 (fun n_a n_b -> n_a+n_b) row_a row_b) a b

    let scalar k a =
        List.map (fun row -> List.map (fun n -> n*k) row) a

    let transpose a = List.init (cols a) (fun row -> List.init (rows a) (fun col -> get a col row))

    (* A_mn * B_np = C_mp *)
    let mult a b = 
        if cols a <> cols b then raise MatrixDimension
        else 
            let b_t = transpose b in
            List.init (rows a) (fun row -> List.init (cols b) (fun col -> dot_prod (List.nth a row) (List.nth b_t col)))

    (* let norm k a = a *)
    let norm a =
        let a_t = transpose a in
        let sums = List.map (fun row -> List.fold_left (fun acc n -> acc+n) R.zero row) a_t in
        List.fold_left (fun curr x -> max curr x) R.zero sums


end
