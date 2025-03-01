(**************************************************************************)
(*    Lablgtk - Examples                                                  *)
(*                                                                        *)
(*    This code is in the public domain.                                  *)
(*    You may freely copy parts of it in your application.                *)
(*                                                                        *)
(**************************************************************************)

(* $Id$ *)

open GMain

let rec fix ~f ~eq x =
  let x' = f x in
  if eq x x' then x
  else fix ~f ~eq x'

let eq_float x y = abs_float (x -. y) < 1e-13

let _ =
  let _ = Main.init () in
  let top = GWindow.window () in
  top#connect#destroy ~callback:Main.quit;
  let vbox = GPack.vbox ~packing: top#add () in
  let entry = GEdit.entry ~max_length: 20 ~packing: vbox#add () in
  let tips = GData.tooltips () in
  tips#set_tip entry#coerce ~text:"Initial value for fix-point";
  let result =
    GEdit.entry ~max_length: 20 ~editable: false ~packing: vbox#add () in

  entry#connect#activate ~callback:
    begin fun () ->
      let x = try float_of_string entry#text with _ -> 0.0 in
      entry#set_text (string_of_float (cos x));
      let res = fix ~f:cos ~eq:eq_float x in
      result#set_text (string_of_float res)
    end;
  top#show ();
  Main.main ()
