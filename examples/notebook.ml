(**************************************************************************)
(*    Lablgtk - Examples                                                  *)
(*                                                                        *)
(*    This code is in the public domain.                                  *)
(*    You may freely copy parts of it in your application.                *)
(*                                                                        *)
(**************************************************************************)

(* $Id$ *)

open GMain

let main () =
  GMain.init ();
  let window = GWindow.window ~title:"Notebook" ~border_width:10 () in
  window#connect#destroy ~callback:Main.quit;
  let notebook = GPack.notebook ~packing:window#add () in
  let button = GButton.button ~label:"Page 1" 
    ~packing:(fun w -> ignore (notebook#append_page w)) () in
  button#connect#clicked ~callback:
    (fun () -> prerr_endline "Hello again - cool button 1 was pressed");

  let button = GButton.button ~label:"Page 2" 
   ~packing:(fun w -> ignore (notebook#append_page w))
    () in
  button#connect#clicked ~callback:
    (fun () -> prerr_endline "Hello again - cool button 2 was pressed");
  notebook#connect#switch_page 
    ~callback:(fun i -> prerr_endline ("Page switch to " ^ string_of_int i));
  button#connect#clicked ~callback:
    (fun () -> prerr_endline "Coucou");
  window#show ();
  Main.main ()

let _ = main ()

(* Local Variables: *)
(* compile-command: "ocamlc -I ../src -w s lablgtk.cma gtkInit.cmo notebook.ml" *)
(* End: *)
