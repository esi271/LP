module G = (Goldbach.Goldbach : GoldbachADT.GoldbachADT)

let main () =
    let inputs = [4; 6; 8; 10; 12; 14; 16; 18; 20] in
    let range1 = 10 in
    let range2 = 21 in
    List.iter(
        fun e ->
            let (e, (n1, n2)) = G.goldbach e in
            Printf.printf "%d = %d + %d\n" e n1 n2 
    ) inputs;
    Printf.printf "\ngoldbach_list(%d,%d)\n" range1 range2;
    List.iter(
        fun (n, (n1, n2)) ->
            Printf.printf "%d = %d + %d\n" n n1 n2 

    ) (G.goldbach_list (range1, range2));;

main ();;