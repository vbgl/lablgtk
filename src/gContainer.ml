(* $Id$ *)

open StdLabels
open Gaux
open Gobject
open Gtk
open GtkBase
open OGtkProps
open GObj
open GData

open Container

class focus obj = object
  val obj = obj
  (* method circulate = focus obj *)
  method set (child : widget option) =
    let child = may_map child ~f:(fun x -> x#as_widget) in
    set_focus_child obj (Gpointer.optboxed child)
  method set_hadjustment adj =
    set_focus_hadjustment obj
      (Gpointer.optboxed (may_map adj ~f:as_adjustment))
  method set_vadjustment adj =
    set_focus_vadjustment obj
      (Gpointer.optboxed (may_map adj ~f:as_adjustment))
end

class ['a] container_impl obj = object (self)
  inherit ['a] widget_impl obj
  inherit container_props
  method add w = add obj (as_widget w)
  method remove w = remove obj (as_widget w)
  method children = List.map ~f:(new widget) (children obj)
  method focus = new focus obj
end

class container = ['a] container_impl

class container_signals_impl obj = object
  inherit widget_signals_impl obj
  inherit container_sigs
end

class type container_signals = container_signals_impl

class container_full obj = object
  inherit container obj
  method connect = new container_signals_impl obj
end

let cast_container (w : widget) =
  new container_full (cast w#as_widget)

let pack_container ~create =
  Container.make_params ~cont:
    (fun p ?packing ?show () -> pack_return (create p) ~packing ~show)


class virtual ['a] item_container obj = object (self)
  inherit ['b] widget_impl obj
  inherit container_props
  method add (w : 'a) =
    add obj w#as_item
  method remove (w : 'a) =
    remove obj w#as_item
  method private virtual wrap : Gtk.widget obj -> 'a
  method children : 'a list =
    List.map ~f:self#wrap (children obj)
  method set_border_width = set Container.P.border_width obj
  method focus = new focus obj
  method virtual insert : 'a -> pos:int -> unit
  method append (w : 'a) = self#insert w ~pos:(-1)
  method prepend (w : 'a) = self#insert w ~pos:0
end

class item_signals obj = object
  inherit container_signals_impl (obj : [> Gtk.item] obj)
  inherit item_sigs
end
