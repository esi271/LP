(*
Put into a list, called alkaline_earth_metals, the atomic numbers of the six alkaline earth metals: 
beryllium (4), magnesium (12), calcium (20), strontium (38), barium (56), and radium (88). 
*)
type element = {name : string; number : int};;
let alkaline_earth_metals = [{name = "beryllium"; number = 4};
                             {name = "magnesium"; number = 12};
                             {name = "calcium"; number = 20};
                             {name = "strontium"; number = 38};
                             {name = "barium"; number = 56};
                             {name = "radium"; number = 88};
                            ];;

(*
Write a function that returns the highest atomic number in alkaline_earth_metals.
*)
let highest_atomic_number l =
    
    let rec highest max = function
    | hd :: tl ->
        if hd.number > max then highest hd.number tl
        else highest max tl
    | [] -> max

    in match l with
    | hd :: tl -> highest hd.number tl
    | _ -> 0;;

highest_atomic_number alkaline_earth_metals;;

(*
Write a function that sorts alkaline_earth_metals in ascending order (from the lightest to the heaviest).
*)
let compare_elements_number e1 e2 = e1.number >= e2.number;;

let ordered_merge l1 l2 compare =

    let rec merge acc l1 l2 =
        match l1, l2 with
        | [], [] -> List.rev acc
        | hd1 :: tl1, [] -> merge (hd1 :: acc) tl1 []
        | [], hd2 :: tl2 -> merge (hd2 :: acc) [] tl2
        | hd1 :: tl1, hd2 :: tl2 ->
            if (compare hd1 hd2) then merge (hd1 :: acc) tl1 l2
            else merge (hd2 :: acc) l1 tl2
        
        in match l1, l2 with
        | _, [] -> l1
        | [], _ -> l2
        | _ -> merge [] l1 l2;;


let rec sort l compare =
    match l with
    | [] | [_] -> l
    | _ ->
        let rec split acc = function
        | hd :: tl ->
            if List.length (hd :: acc) >= List.length tl then ((hd :: acc), tl)
            else split (hd :: acc) tl
        | [] -> ([], [])
        in
        let (l1, l2) = split [] l in
        mergesort l1 l2 compare

and mergesort l1 l2 compare =
    let sortl1 = sort l1 compare in
    let sortl2 = sort l2 compare in
    match sortl1, sortl2 with
    | [], _ -> sortl2
    | _, [] -> sortl1
    | _ -> ordered_merge sortl1 sortl2 compare;;

    
sort alkaline_earth_metals compare_elements_number;;

(*
Put into a second list, called noble_gases, the noble gases: 
helium (2), neon (10), argon (18), krypton (36), xenon (54), and radon (86). Then
*)
let noble_gases = [{name = "helium"; number = 2};
                   {name = "neon"; number = 10};
                   {name = "argon"; number = 18};
                   {name = "krypton"; number = 36};
                   {name = "xenon"; number = 54};
                   {name = "radon"; number = 86};
                  ];;

(*
Write a function (or a group of functions) that merges the two lists and print the result as couples 
(name, atomic number) sorted in ascending order on the element names.
*)
let compare_elements_name e1 e2 = e1.name <= e2.name;;
mergesort alkaline_earth_metals noble_gases compare_elements_name;;