module type MatrixADT =
    sig
        type matrix
        type elm
        exception IncompatibleDimension

        val identity_matrix : int -> matrix
        val zeroes_matrix : int -> matrix
        val create_matrix : elm list list -> matrix
        val matrix_equivalence : matrix -> matrix -> bool
        val matrix_copy : matrix -> matrix
        val matrix_addition : matrix -> matrix -> matrix
        val scalar_matrix_multiplication : elm -> matrix -> matrix
        val matrix_matrix_multiplication : matrix -> matrix -> matrix
        val matrix_transposition : matrix -> matrix
        val matrix_norm : matrix -> elm
        val print : matrix -> unit
      

    end