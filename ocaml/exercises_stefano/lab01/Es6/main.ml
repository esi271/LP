module T = (Taylor.Taylor : TaylorADT.TaylorADT);;

let () =
  Printf.printf "%f\n" (T.sin 1.0 5);
  Printf.printf "%f\n" (T.cos 1.0 5);;