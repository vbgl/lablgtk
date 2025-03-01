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
  let window = GWindow.window () in
  window#connect#destroy ~callback:Main.quit;

  let calendar = GMisc.calendar ~packing:window#add () in
  calendar#connect#day_selected ~callback:
    begin fun () ->
      let (year,month,day) = calendar#date in
      Printf.printf "You selected %d/%d/%02d.\n"
	day (month+1) (year mod 100);
      flush stdout
    end;

  window#show ();
  Main.main ()

let _ = main ()
