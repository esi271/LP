module M0 = Monoid.Monoid(
    struct

        type t = bool
        type set = bool list

        let elements = [true; false]
        let identity = false
        let add = ( || )
        let contains b = true
    end
);;

module M1 = Monoid.Monoid(
    struct

        type t = int
        type set = int list

        let n = 5
        let elements = List.init n (fun n -> n)
        let identity = 0
        let add a b= (a + b) mod n
        let contains e = List.mem e elements
    end
);;

module M2 = Monoid.Monoid(
    struct

        type t = int
        type set = int list

        let n = 5
        let elements = List.init n (fun n -> n)
        let identity = 1
        let add a b= (a + b) mod n
        let contains e = List.mem e elements
    end
);;

module G0 = Group.Group(
    struct
        type t = bool
        type set = bool list

        let elements = [true; false]
        let identity = false
        let add = ( || )
        let contains b = true
    end
)

module G1 = Group.Group(
    struct
        type t = int
        type set = int list

        let elements = List.init 11 (fun n -> n - 5)
        let identity = 0
        let add = ( + )
        let contains b = true
    end
)

module G2 = Group.Group(
    struct
        type t = int
        type set = int list

        let n = 4
        let elements = List.init n (fun n -> n)
        let identity = 1
        let add a b = (a * b) mod n
        let contains e = List.mem e elements
    end
)

module G3 = Group.Group(
    struct
        type t = string
        type set = string list

        let n = 4
        let elements = List.init n (fun i -> String.make i 'a')
        let identity = ""
        let add a b = if String.length a > String.length b then a else b
        let contains e = String.for_all(fun c -> c = 'a') e
    end
)


module R0 = Ring.Ring(
    struct
        type t = int
        type set = int list

        let elements = []
        let identity = 0
        let addition = ( + )
        let multiplication = ( * )
        let contains n = n = 0

    end
)

module R1 = Ring.Ring(
    struct
        type t = int
        type set = int list

        let elements = List.init 11 (fun n -> n - 5)
        let identity = 0
        let addition = ( + )
        let multiplication = ( * )
        let contains b = true
      
    end
)

module R2 = Ring.Ring(
    struct
        type t = int
        type set = int list

        let n = 4
        let elements = List.init n (fun n -> n)
        let identity = 0
        let addition a b = (a + b) mod n
        let multiplication a b = (a * b) mod n
        let contains e = List.mem e elements
      
    end
)


let main () =
    print_endline("Monoid");
    print_endline ("Check S = {True, False} add = or i = False");
    print_endline (string_of_bool (M0.is_monoid () ));

    print_endline ("Check S = Zn={0,1,...,n-1} add = + where a+b=(a+b)%n i = 0");
    print_endline (string_of_bool (M1.is_monoid () ));

    print_endline ("Check S = Zn={0,1,...,n-1} add = + where a+b=(a+b)%n i = 1");
    print_endline (string_of_bool (M2.is_monoid () ));
    print_endline ("");


    print_endline("Group");
    print_endline ("Check S = {True, False}, add = or, i = False");
    print_endline (string_of_bool (G0.is_group () ));

    print_endline ("Check S = Z, add = +, i = 0");
    print_endline (string_of_bool (G1.is_group () ));

    print_endline ("Check S = Z4 = {0, 1, 2, 3}, add = * where a*b=(a*b)%4, i = 1");
    print_endline (string_of_bool (G2.is_group () ));

    print_endline ("Check S = {a}*, add: {a}*×{a}* --> {a}* where x1·x2 is x1 if #x1 > #x2, x2 otherwise, i = the empty string");
    print_endline (string_of_bool (G3.is_group () ));
    print_endline ("");

    print_endline("Rings");
    print_endline("Check S = {0} add = + where 0+0=0 mul = * where 0*0=0 i = 0");
    print_endline (string_of_bool (R0.is_ring () ));
    print_endline("Check S = Z add = + mul = * i = 0");
    print_endline (string_of_bool (R1.is_ring () ));
    print_endline("Check S = Z4 = {0,1,2,3} add = + where a+b=(a+b)%4 mul = * where a*b=(a*b)%4 i = 0");
    print_endline (string_of_bool (R2.is_ring () ));;



main ();;