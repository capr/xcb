---
tagline: XCB binding
platforms: linux32, linux64
---

## `local xcb_module = require'xcb'`

Binding of [Xorg's XCB] library and higher-level cruft-hiding API.
Created mainly for [nw]'s [xcb backend], but directly usable for X11-only apps.

[Xorg's XCB]:  http://xcb.freedesktop.org/
[xcb backend]: https://github.com/luapower/nw/blob/master/nw_xcb.lua

## API

----------------------------------------------- -----------------------------------------------
__connection__
xcb_module.connect([displayname]) -> xcb        connect and get a XCB API for that connection
xcb.flush()                                     flush the command queue
xcb.screen                                      default screen
__server__
xcb.extension_map() -> {name = true}            get available X extensions
xcb.extension(name) -> true|false               check if an extension is available
__events__
xcb.poll([block]) -> event | nil                poll (or wait) for the next event
xcb.peek() -> event | nil                       get the next event without pulling it
__atoms__
xcb.atom(name) -> atom                          intern an atom
xcb.atom_name(atom) -> s | nil                  get an atom's name
__screens__
xcb.screens() -> iter() -> screen               iterate screens
xcb.depths(screen) -> iter() -> depth           iterate depths of screen
xcb.visuals(depth) -> iter() -> visual          iterate visuals of depth
__constructors and destructors__
xcb.gen_id() -> id                              xcb_generate_id wrapper
xcb.create_window(...)                          xcb_create_window wrapper
xcb.destroy_window(win)                         xcb_destroy_window wrapper
xcb.create_colormap(...)                        xcb_create_colormap wrapper
__window properties__
xcb.list_props(win) -> {name1, ...}             list properties
xcb.delete_prop(win, prop)                      delete a property
xcb.get_string_prop(win, prop) -> s             get a string-type property
xcb.set_string_prop(win, prop, s)               set a string-type property
xcb.get_atom_map_prop(win, prop) -> t           get an atom map-type property
xcb.set_atom_map_prop(win, prop, t)             set an atom map-type property
xcb.set_atom_prop(win, prop, val)               set an atom-type property
xcb.set_cardinal_prop(win, prop, n)             set an integer-type property
xcb.get_window_prop(win, prop) -> win           get a window-type property
xcb.set_window_prop(win, prop, target_win)      set a window-type property
xcb.get_window_list_prop(win, prop) -> t        get a window list-type property
__client message events__
client_message_event(win, type, fmt) -> e       create a client message event
int32_list_event(win, type, n1, ...) -> e       create an integer list event
atom_list_event(win, type, atom1,...) -> e      create an atom list event
send_client_message_to_root(e)                  send a client message to screen.root
__window management__
xcb.get_geometry(win) -> geom                   get window geometry as xcb_get_geometry_reply_t
xcb.net_supported(feature)-> true|false         check the _NET_SUPPORTED atom map
xcb.get_netwn_states(win) -> t                  get _NET_WM_STATE atom map
xcb.set_netwn_states(win, t)                    set _NET_WM_STATE atom map
xcb.change_netwm_states(win,?,p1[,p2])          set or reset one or two _NET_WM_STATE atoms
xcb.get_wm_hints(win) -> hints                  get WM_HINTS as xcb_icccm_wm_hints_t
xcb.set_wm_hints(win, hints)                    set WM_HINTS as xcb_icccm_wm_hints_t
xcb.get_wm_normal_hints(win) -> hints           get WM_NORMAL_HINTS as xcb_icccm_wm_size_hints_t
xcb.set_wm_normal_hints(win, hints)             set WM_NORMAL_HINTS as xcb_icccm_wm_size_hints_t
xcb.set_minmax(win,minw,minh,maxw,maxh)         set min/max part of WM_NORMAL_HINTS
xcb.get_motif_wm_hints(win) -> hints            get _MOTIF_WM_HINTS as xcb_motif_wm_hints_t
xcb.set_motif_wm_hints(win, hints)              set _MOTIF_WM_HINTS as xcb_motif_wm_hints_t
xcb.request_frame_extents(win)                  send _NET_REQUEST_FRAME_EXTENTS
xcb.frame_extents(win) -> x, y, w, h            send _NET_FRAME_EXTENTS
xcb.map(win)                                    show window
xcb.unmap(win)                                  hide window
xcb.activate(win)                               activate window
xcb.minimize(win)                               minimize window
xcb.translate_coords(src_win,dst_win,x,y)->x,y  translate coordinates between windows
xcb.change_pos(win, x, y)                       change window position relative to its parent
xcb.change_size(win, cw, ch)                    change window client area size
xcb.get_title(win) -> title                     get window title
xcb.set_title(win, title)                       set window title and icon name
xcb.query_tree(win) -> win_tree                 get window root, parent and children
__shm__
xcb.shm() -> shm_C                              get C namespace of xcb-shm if server supports shm
__ping protocol__
xcb.pong(e)                                     respond to a _NET_WM_PING event
set_netwm_ping_info(win)                        set _NET_WM_PID and WM_CLIENT_MACHINE
__direct access__
xcb.c                                           xcb_connection_t
xcb.C                                           XCB C namespace
xcb.check(cookie)                               check a request cookie for errors
----------------------------------------------- -----------------------------------------------
