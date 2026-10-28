(* sublist version *)
let encode_insub l =
    let rec aux count acc = function
        | [] -> []
        | [x] -> (count+1, x)::acc
        | h :: (b :: _ as t) -> 
                if h = b then aux (count+1) acc t 
                else aux 0 ((count+1, h)::acc) t in
    List.rev (aux 0 [] l)

type 'a rle =
    | One of 'a
    | Many of (int * 'a)

let encode l =
    let create_tup c el = 
        if c = 1 then One el else Many (c, el) in
    let rec aux count acc = function
        | [] -> []
        | [x] -> (create_tup (count + 1) x) :: acc
        | h :: (b :: _ as t) -> 
                if h = b then aux (count+1) acc t 
                else aux 0 (create_tup (count+1) h::acc) t in
    List.rev (aux 0 [] l)

let decode l =
    let rec unwrap acc x n = 
        if n = 1 then x :: acc else unwrap (x::acc) x (n-1)
    in
    let rec decode acc = function
        | [] -> acc
        | One x :: t -> decode (x :: acc) t
        | Many (n,x) :: t -> decode (unwrap acc x n) t in
    List.rev (decode [] l)
