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
        let contains n = List.mem n elements
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
        let contains n = List.mem n elements
    end
);;

module G1 = Group.Group(
    struct
        type t = bool
        type set = bool list

        let elements = [true; false]
        let identity = false
        let add = ( || )
        let contains b = true
    end
)

module Z = Group.Group(
    struct
        type t = int
        type set = int list

        let elements = List.init 11 (fun n -> n - 5)
        let identity = 0
        let add = ( + )
        let contains b = true
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

    print_endline("Group");
    print_endline ("Check S = {True, False}, add = or, i = False");
    print_endline (string_of_bool (G1.is_group () ));

    print_endline ("Check S = Z, add = +, i = 0");
    print_endline (string_of_bool (Z.is_group () ));;

main ();;