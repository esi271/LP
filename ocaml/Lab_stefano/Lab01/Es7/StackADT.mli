module type StackADT =
    sig 
    
        type 'a stack

        val empty : unit -> 'a stack

        val size : 'a stack -> int

        val push : 'a stack -> 'a -> 'a stack

        val pop : 'a stack -> 'a * 'a stack
    
    end