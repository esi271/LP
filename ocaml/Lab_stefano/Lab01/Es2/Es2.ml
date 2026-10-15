(*
Beyond the well-known Celsius and Fahrenheit, there are other six temperature scales: 
Kelvin, Rankine, Delisle, Newton, Réaumur, and Rømer
*)
type t_unit =
    | Celsius
    | Fahrenheit
    | Kelvin
    | Rankine 
    | Delisle
    | Newton
    | Reaumur
    | Romer;;

type temperature = {value : float; t_u : t_unit};;

(*
Write a function that given a pure number returns a conversion table for it among any of the 8 scales.
*)
let celsius_to_any n u =
    match u with
    | Celsius -> {value = n; t_u = Celsius}
    | Fahrenheit -> {value = n *. 9. /. 5. +. 32.; t_u = Fahrenheit}
    | Kelvin -> {value = n +. 273.15; t_u = Kelvin}
    | Rankine -> {value = n *. 9. /. 5. +. 491.67; t_u = Rankine}
    | Delisle -> {value = (100. -. n) *. 3. /. 2.; t_u = Delisle}
    | Newton -> {value = n *. 33. /. 100.; t_u = Newton}
    | Reaumur -> {value = n *. 4. /. 5.; t_u =  Reaumur}
    | Romer -> {value = (n *. 21. /. 40.) +. 7.5; t_u = Romer};;

let cons = [Celsius; Fahrenheit; Kelvin; Rankine; Delisle; Newton; Reaumur; Romer];;

let convert_to_all_scales n =
    let cons = [Celsius; Fahrenheit; Kelvin; Rankine; Delisle; Newton; Reaumur; Romer] in
    let rec convert n acc = function
    | hd :: tl -> convert n ((celsius_to_any n hd) :: acc) tl
    | [] -> acc
    in convert n [] (List.rev cons);; 

convert_to_all_scales 16.;;

(*
Write a function that given a temperature in a specified scale returns a list of all the corresponding temperatures in the other scales, 
note that the scale must be specified.
*)
let any_to_celsius t =
    match t.t_u with
    |Celsius -> t
    | Fahrenheit -> { value = (t.value -. 32.) *. 5. /. 9.; t_u = Celsius }
    | Kelvin -> { value = t.value -. 273.15 ; t_u = Celsius }
    | Rankine -> { value = (t.value -. 491.67) *. 5. /. 9.; t_u = Celsius }
    | Delisle -> { value = 100. -. t.value *. 2. /. 3.; t_u = Celsius }
    | Newton -> { value = t.value *. 100. /. 33.; t_u = Celsius }
    | Reaumur -> { value = t.value *. 5. /. 4.; t_u = Celsius }
    | Romer -> { value = (t.value -. 7.5) *. 40. /. 21.; t_u = Celsius } ;;

let convert_to_others t =
    let cons = [Celsius; Fahrenheit; Kelvin; Rankine; Delisle; Newton; Reaumur; Romer] in
    let rec convert t acc = function
    | hd :: tl ->
        if hd <> t.t_u then 
            let in_celsius = any_to_celsius t in 
            let converted = celsius_to_any in_celsius.value hd in
            convert t (converted :: acc) tl
        else convert t acc tl
    | [] -> acc
    in convert t [] cons;;

convert_to_others {value = 18.; t_u = Celsius};;