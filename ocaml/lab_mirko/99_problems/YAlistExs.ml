let duplicate l =
    let rec aux acc = function
        | [] -> acc
        | h :: t -> aux (h::h::acc) t in
    List.rev (aux [] l)

let replicate l n =
    let rec add_n acc n x = 
        if n = 1 then x :: acc else add_n (x::acc) (n-1) x
    in
    let rec aux acc = function
        | [] -> acc
        | h :: t -> aux (add_n acc n h) t
    in
    List.rev (aux [] l)

let drop l n =
    let rec aux acc i = function
        | [] -> acc
        | h :: t when i = n -> aux acc 1 t
        | h :: t -> aux (h::acc) (i+1) t in
    List.rev (aux [] 1 l)

let split l n =
    let rec aux acc i = function
        | [] -> (List.rev acc, [])
        | h :: t when i = n -> (List.rev acc, t)
        | h :: t -> aux (h::acc) (i+1) t in
    aux [] 0 l

let slice l i k =
    let rec aux acc count = function
        | [] -> acc
        | _ when count > k -> acc
        | h :: t when count >= i -> aux (h :: acc) (count+1) t
        | _ :: t -> aux acc (count+1) t in
    List.rev (aux [] 0 l)

let rotate l n =
    let len = List.length l in
    let modn = n mod len in
    (slice l modn (len-1)) @ (slice l 0 (modn-1))

let rec remove_at n = function
    | [] -> []
    | _ :: t when n = 0 -> t
    | h :: t -> h :: (remove_at (n-1) t)

let rec insert_at x n = function
    | [] -> []
    | h :: t -> if n = 0 then x :: h :: t else h :: insert_at x (n-1) t

let range start stop =
    let rec range acc start =
        if start <= stop then
            range (start :: acc) (start+1)
        else
            acc
    in
    List.rev (range [] start)
