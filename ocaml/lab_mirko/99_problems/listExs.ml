let rec last = function
    | [] -> None
    | [x] -> Some x
    | h :: t -> last t

let rec last_two = function
    | [] | [_] -> None
    | [x; y] -> Some (x,y)
    | h :: t -> last_two t

let at n l =
    let rec at curr = function
        | [] -> None
        | h :: t -> if curr = 0 then Some h else at (curr-1) t in
    at n l

let length l = 
    let rec length acc = function
        | [] -> acc
        | _ :: t -> length (acc+1) t in
    length 0 l

let rev l =
    let rec rev acc = function
        | [] -> acc
        | h :: t -> rev (h::acc) t in
    rev [] l

let is_palindrome l1 = List.rev l1 = l1

type 'a node = One of 'a | Many of 'a node list

let flatten l =
    let rec flatten acc = function
        | [] -> acc
        | One x :: t -> flatten (x :: acc) t
        | Many x :: t -> flatten (flatten acc x) t in
    List.rev (flatten [] l)

let rec compress = function
    | x :: (y :: _ as t) -> if x = y then compress t else x :: compress t
    | x -> x


let pack l =
    let rec pack acc curr = function
        | [] -> []
        | [x] -> (x::curr) :: acc
        | x :: (b :: _ as t) -> 
                if x = b then pack acc (x :: curr) t
                else pack ((x::curr)::acc) [] t in
    List.rev (pack [] [] l)
