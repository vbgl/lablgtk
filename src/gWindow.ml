(* $Id$ *)

open Misc
open Gtk
open GtkBase
open GtkWindow
open GtkMisc
open GObj
open GContainer

class window_skel obj = object
  inherit container obj
  method add_events = Widget.add_events obj
  method as_window = Window.coerce obj
  method activate_focus () = Window.activate_focus obj
  method activate_default () = Window.activate_default obj
  method add_accel_group = Window.add_accel_group obj
  method set_modal = Window.set_modal obj
  method set_default_size = Window.set_default_size obj
  method set_position = Window.set_position obj
  method set_transient_for : 'a . (#is_window as 'a) -> unit
      = fun w -> Window.set_transient_for obj (w #as_window)
  method set_title = Window.set_title obj
  method set_wm_name name = Window.set_wmclass obj :name
  method set_wm_class cls = Window.set_wmclass obj class:cls
  method set_allow_shrink allow_shrink = Window.set_policy obj :allow_shrink
  method set_allow_grow allow_grow = Window.set_policy obj :allow_grow
  method set_auto_shrink auto_shrink = Window.set_policy obj :auto_shrink
  method show () = Widget.show obj
end

class window_wrapper obj = object
  inherit window_skel (Window.coerce obj)
  method connect = new container_signals ?obj
end

class window ?type:t [< `TOPLEVEL >] ?:title ?:wm_name ?:wm_class ?:position
    ?:allow_shrink ?:allow_grow ?:auto_shrink ?:modal ?:x ?:y
    ?:border_width ?:width ?:height ?:packing ?:show [< false >] =
  let w = Window.create t in
  let () =
    Window.set w ?:title ?:wm_name ?:wm_class ?:position
      ?:allow_shrink ?:allow_grow ?:auto_shrink ?:modal ?:x ?:y;
    Container.set w ?:border_width ?:width ?:height
  in
  object (self)
    inherit window_wrapper w
    initializer pack_return :packing :show (self :> window_wrapper)
  end

class dialog_wrapper obj = object
  inherit window_skel (Dialog.coerce obj)
  method connect = new GContainer.container_signals ?obj
  method action_area = new GPack.box_wrapper (Dialog.action_area obj)
  method vbox = new GPack.box_wrapper (Dialog.vbox obj)
end

class dialog ?:title ?:wm_name ?:wm_class ?:position ?:allow_shrink
    ?:allow_grow ?:auto_shrink ?:modal ?:x ?:y ?:border_width ?:width ?:height
    ?:packing ?:show [< false >] =
  let w = Dialog.create () in
  let () =
    Window.set w ?:title ?:wm_name ?:wm_class ?:position
      ?:allow_shrink ?:allow_grow ?:auto_shrink ?:modal ?:x ?:y;
    Container.set w ?:border_width ?:width ?:height
  in
  object (self)
    inherit dialog_wrapper w
    initializer pack_return :packing :show (self :> dialog_wrapper)
  end

class color_selection_dialog_wrapper obj = object
  inherit window_skel (obj : Gtk.color_selection_dialog obj)
  method connect = new GContainer.container_signals ?obj
  method ok_button =
    new GButton.button_wrapper (ColorSelection.ok_button obj)
  method cancel_button =
    new GButton.button_wrapper (ColorSelection.cancel_button obj)
  method help_button =
    new GButton.button_wrapper (ColorSelection.help_button obj)
  method colorsel =
    new GMisc.color_selection_wrapper (ColorSelection.colorsel obj)
end

class color_selection_dialog ?:title [< "Pick a color" >]
    ?:wm_name ?:wm_class ?:position
    ?:allow_shrink ?:allow_grow ?:auto_shrink ?:modal ?:x ?:y
    ?:border_width ?:width ?:height ?:packing ?:show [< false >] =
  let w = ColorSelection.create_dialog title in
  let () =
    Window.set w ?title:None ?:wm_name ?:wm_class ?:position
      ?:allow_shrink ?:allow_grow ?:auto_shrink ?:modal ?:x ?:y;
    Container.set w ?:border_width ?:width ?:height
  in
  object (self)
    inherit color_selection_dialog_wrapper w
    initializer
      pack_return :packing :show (self :> color_selection_dialog_wrapper)
  end

class file_selection_wrapper obj = object
  inherit window_skel (obj : Gtk.file_selection obj)
  method connect = new GContainer.container_signals ?obj
  method set_filename = FileSelection.set_filename obj
  method get_filename = FileSelection.get_filename obj
  method set_fileop_buttons = FileSelection.set_fileop_buttons obj
  method ok_button =
    new GButton.button_wrapper (FileSelection.get_ok_button obj)
  method cancel_button =
    new GButton.button_wrapper (FileSelection.get_cancel_button obj)
  method help_button =
    new GButton.button_wrapper (FileSelection.get_help_button obj)
end

class file_selection ?:title [< "Choose a file" >] ?:filename
    ?:fileop_buttons [< false >]
    ?:wm_name ?:wm_class ?:position
    ?:allow_shrink ?:allow_grow ?:auto_shrink ?:modal ?:x ?:y
    ?:border_width ?:width ?:height ?:packing ?:show [< false >] =
  let w = FileSelection.create title in
  let () =
    FileSelection.set w ?:filename :fileop_buttons;
    Window.set w ?title:None ?:wm_name ?:wm_class ?:position
      ?:allow_shrink ?:allow_grow ?:auto_shrink ?:modal ?:x ?:y;
    Container.set w ?:border_width ?:width ?:height
  in
  object (self)
    inherit file_selection_wrapper w
    initializer pack_return :packing :show (self :> file_selection_wrapper)
  end
