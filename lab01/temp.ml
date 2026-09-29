(* Write a function that given a pure number returns a conversion table for it among any of the 8 scales. *)

type scale = Celsius | Kelvin | Fahrenheit | Rankine | Delisle | Newton | Reaumur | Romer;;
type temperature = {value : float; scale : scale};;

let c2any t u = 
    match u with
    | Celsius    -> t
    | Kelvin     -> { value = t.value +. 273.15; scale = Kelvin }
    | Fahrenheit -> { value = (t.value *. 9. /. 5. +. 32.); scale = Fahrenheit }
    | Rankine    -> { value = (t.value +. 273.15) *. 9. /. 5.; scale = Rankine }
    | Delisle    -> { value = (100. -. t.value) *. 3. /. 2.; scale = Delisle }
    | Newton     -> { value = t.value *. 33. /. 100.; scale = Newton }
    | Reaumur    -> { value = t.value *. 4. /. 5.; scale = Reaumur }
    | Romer      -> { value = (t.value *. 21. /. 40. +. 7.5); scale = Romer }


