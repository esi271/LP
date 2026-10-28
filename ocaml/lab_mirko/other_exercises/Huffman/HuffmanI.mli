module type HuffmanI =
  sig
    type elt
    type tree
    type code = bool list
    exception EmptyInput
    exception NotFound
    val frequencies : elt list -> (elt * int) list
    val build : (elt * int) list -> tree
    val encode_elt : tree -> elt -> code
    val encode : tree -> elt list -> code
    val decode : tree -> code -> elt list
    val tostring : tree -> string
  end;;
