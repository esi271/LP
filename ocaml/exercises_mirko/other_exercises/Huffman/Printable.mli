module type Printable = sig
  type t
  val tostring : t -> string
end;;
