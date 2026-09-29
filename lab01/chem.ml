(* Put into a list, called alkaline_earth_metals, the atomic numbers of the six alkaline earth metals:
    beryllium (4), magnesium (12), calcium (20), strontium (38), barium (56), and radium (88). *)

let alkaline_earth_metals = ("beryllium",4)::("magnesium",12)::("calcium",20)::("strontium",38)::("barium",56)::("radium",88)::[];;

(* Write a function that returns the highest atomic number in alkaline_earth_metals. *)

let max a b = if (snd a) > (snd b) then a else b;;

let highest list =
    let rec aux m = function 
        | h :: t -> aux (max h m) t
        | [] -> m
    in aux (List.hd list) list;;

(* Write a function that sorts alkaline_earth_metals in ascending order (from the lightest to the heaviest). *)

let compare_el a b = if (snd a) > (snd b) then 1 else (if (snd a) = (snd b) then 0 else -1);;
let compare_el_name a b = if (fst a) > (fst b) then 1 else (if (fst a) = (fst b) then 0 else -1);;

let sort_asc f list = List.sort f list;;

(* Put into a second list, called noble_gases, the noble gases: helium (2), neon (10), argon (18), krypton (36), xenon (54), and radon (86). *)

let noble_gases = ("helium", 2)::("neon", 10)::("argon", 18)::("krypton", 36)::("xenon", 54)::("radon", 86)::[];;

(* Write a function (or a group of functions) that merges the two lists and print the result as couples (name, atomic number) sorted in ascending order on the element names. *)

let merge_elems f l1 l2 = List.merge compare_el_name (sort_asc compare_el_name alkaline_earth_metals) (sort_asc compare_el_name noble_gases);;
