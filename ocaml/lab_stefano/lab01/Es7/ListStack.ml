module ListStack =
    struct
        type 'a stack = 'a list

        let empty () = []

        let push s e = e :: s

        let size s = List.length s

        let pop s = 
        match s with
        | hd :: tl -> (hd, tl)
        | [] -> failwith "empty stack"
  end
