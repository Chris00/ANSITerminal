(* File: ANSITerminal_unix.ml
   Allow colors, cursor movements, erasing,... under Unix shells.
   *********************************************************************

   Copyright 2024 by Fabrice LE FESSANT, OCamlPro

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public License
   version 3 as published by the Free Software Foundation, with the
   special exception on linking described in file LICENSE.

   This library is distributed in the hope that it will be useful, but
   WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the file
   LICENSE for more details.
*)

include ANSITerminal_common

type implementation = UNIX | WINDOWS

let implementation = ref
    ( match Sys.getenv "ANSITerminal" with
      | "UNIX" -> UNIX
      | "WINDOWS" -> WINDOWS
      | exception Not_found
      | _ ->
        match Sys.os_type with
        | "Unix" | "Cygwin" -> UNIX
        | _ -> WINDOWS )

let use_windows_implementation bool =
  implementation := if bool then WINDOWS else UNIX

module U = ANSITerminal_unix
module W = ANSITerminal_win

let print_string style s =
  match !implementation with
  | UNIX -> U.print_string style s
  | WINDOWS -> W.print_string style s

let prerr_string style s =
  match !implementation with
  | UNIX -> U.prerr_string style s
  | WINDOWS -> W.prerr_string style s

let printf style fmt =
  match !implementation with
  | UNIX -> U.printf style fmt
  | WINDOWS -> W.printf style fmt

let eprintf style fmt =
  match !implementation with
  | UNIX -> U.eprintf style fmt
  | WINDOWS -> W.eprintf style fmt

let sprintf style fmt =
  match !implementation with
  | UNIX -> U.sprintf style fmt
  | WINDOWS -> W.sprintf style fmt

let scroll n =
  match !implementation with
  | UNIX -> U.scroll n
  | WINDOWS -> W.scroll n

let size () =
  match !implementation with
  | UNIX -> U.size ()
  | WINDOWS -> W.size ()

let resize w h =
  match !implementation with
  | UNIX -> U.resize w h
  | WINDOWS -> W.resize w h

let save_cursor () =
  match !implementation with
  | UNIX -> U.save_cursor ()
  | WINDOWS -> W.save_cursor ()

let restore_cursor () =
  match !implementation with
  | UNIX -> U.restore_cursor ()
  | WINDOWS -> W.restore_cursor ()

let set_cursor x y =
  match !implementation with
  | UNIX -> U.set_cursor x y
  | WINDOWS -> W.set_cursor x y

let move_cursor x y =
  match !implementation with
  | UNIX -> U.move_cursor x y
  | WINDOWS -> W.move_cursor x y

let move_bol () =
  match !implementation with
  | UNIX -> U.move_bol ()
  | WINDOWS -> W.move_bol ()

let pos_cursor () =
  match !implementation with
  | UNIX -> U.pos_cursor ()
  | WINDOWS -> W.pos_cursor ()

let erase loc =
  match !implementation with
  | UNIX -> U.erase loc
  | WINDOWS -> W.erase loc

let implementation () =
  match !implementation with
  | UNIX -> "UNIX"
  | WINDOWS -> "WINDOWS"
