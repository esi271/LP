## Pattern matching
Il pattern matching serve a scomporre il valore stesso mentre decide quale ramo prendere, e dà accesso diretto ai pezzi interni:
```ocaml
match expression with
    | pattern1 when boolean_expression -> expression1
    | pattern2 when boolean_expression -> expression2
    | _ -> expression3;;
```
I rami vengono **provati in ordine dall'alto verso il basso** e vince il primo che corrisponde. `_` è il catch-all.
<br>
Possiamo omettere nella dichiarazione della funzione il parametro su cui andiamo a fare pattern matching usando questo zucchero sintattico:
``` ocaml
let func = function
    | pattern1 when boolean_expression -> expression1
    | pattern2 when boolean_expression -> expression2
    | _ -> expression3;;
```
È possibile include nel pattern matching più espressioni e poi matchare con i vari pattern:
``` ocaml
match expression1, espression2 with
| pattern1, pattern2 when boolean_expression -> expression3
| pattern1, pattern2 when boolean_expression -> expression4
| _ -> expression5;;
```

