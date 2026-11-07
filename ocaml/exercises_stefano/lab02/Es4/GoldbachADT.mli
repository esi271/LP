module type GoldbachADT =
    sig

        type partition = (int * (int * int))
        exception Invalid_input of int

        val goldbach : int -> partition
        val goldbach_list : int * int -> partition list

    end;;