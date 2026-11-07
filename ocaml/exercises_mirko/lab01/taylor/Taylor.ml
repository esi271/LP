module Taylor =
struct

    let fact n =
        let rec fact acc res = 
            if acc = 0 then res else fact (acc - 1) res * acc in
        fact n 1;;

    let sin x n =
        let rec sin count res =
            if count > n then res else 
                sin (count + 1) (
                    res +.
                        (((-1.)**(float_of_int count))*.(x**float_of_int (2*count+1))/. float_of_int (fact (2*count+1))))
        in
        sin 0 0.;;

    let cos x n =
        let rec cos count res =
            if count >= n then res else 
                cos (count + 1) (
                    res+.
                        (((-1.)**(float_of_int count))*.
                        (x**float_of_int (2*count))/. float_of_int (fact (2*count))))
        in
        cos 0 0.;;

end
