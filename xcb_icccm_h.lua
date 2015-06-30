--xcb/xcb_icccm.h from libxcb-icccm4-dev package v0.4.1-1ubuntu1 from ubuntu 14

local ffi = require'ffi'
require'xcb_h'

ffi.cdef[[
typedef struct {
	xcb_get_property_reply_t *_reply;
	xcb_atom_t encoding;
	uint32_t name_len;
	char *name;
	uint8_t format;
} xcb_icccm_get_text_property_reply_t;
xcb_get_property_cookie_t xcb_icccm_get_text_property(xcb_connection_t *c,
                                                        xcb_window_t window,
                                                        xcb_atom_t property);
xcb_get_property_cookie_t xcb_icccm_get_text_property_unchecked(xcb_connection_t *c,
                                                                  xcb_window_t window,
                                                                  xcb_atom_t property);
uint8_t xcb_icccm_get_text_property_reply(xcb_connection_t *c,
                                            xcb_get_property_cookie_t cookie,
                                            xcb_icccm_get_text_property_reply_t *prop,
                                            xcb_generic_error_t **e);
void xcb_icccm_get_text_property_reply_wipe(xcb_icccm_get_text_property_reply_t *prop);
xcb_void_cookie_t xcb_icccm_set_wm_name_checked(xcb_connection_t *c,
                                                  xcb_window_t window,
                                                  xcb_atom_t encoding,
                                                  uint8_t format,
                                                  uint32_t name_len,
                                                  const char *name);
xcb_void_cookie_t xcb_icccm_set_wm_name(xcb_connection_t *c, xcb_window_t window,
                                          xcb_atom_t encoding, uint8_t format,
                                          uint32_t name_len, const char *name);
xcb_get_property_cookie_t xcb_icccm_get_wm_name(xcb_connection_t *c,
                                                  xcb_window_t window);
xcb_get_property_cookie_t xcb_icccm_get_wm_name_unchecked(xcb_connection_t *c,
                                                            xcb_window_t window);
uint8_t xcb_icccm_get_wm_name_reply(xcb_connection_t *c,
                                      xcb_get_property_cookie_t cookie,
                                      xcb_icccm_get_text_property_reply_t *prop,
                                      xcb_generic_error_t **e);
xcb_void_cookie_t xcb_icccm_set_wm_icon_name_checked(xcb_connection_t *c,
                                                       xcb_window_t window,
                                                       xcb_atom_t encoding,
                                                       uint8_t format,
                                                       uint32_t name_len,
                                                       const char *name);
xcb_void_cookie_t xcb_icccm_set_wm_icon_name(xcb_connection_t *c,
                                               xcb_window_t window,
                                               xcb_atom_t encoding,
                                               uint8_t format,
                                               uint32_t name_len,
                                               const char *name);
xcb_get_property_cookie_t xcb_icccm_get_wm_icon_name(xcb_connection_t *c,
                                                       xcb_window_t window);
xcb_get_property_cookie_t xcb_icccm_get_wm_icon_name_unchecked(xcb_connection_t *c,
                                                                 xcb_window_t window);
uint8_t xcb_icccm_get_wm_icon_name_reply(xcb_connection_t *c,
                                           xcb_get_property_cookie_t cookie,
                                           xcb_icccm_get_text_property_reply_t *prop,
                                           xcb_generic_error_t **e);
xcb_void_cookie_t xcb_icccm_set_wm_colormap_windows_checked(xcb_connection_t *c,
                                                              xcb_window_t window,
                                                              xcb_atom_t wm_colormap_windows_atom,
                                                              uint32_t list_len,
                                                              const xcb_window_t *list);
xcb_void_cookie_t xcb_icccm_set_wm_colormap_windows(xcb_connection_t *c,
                                                      xcb_window_t window,
                                                      xcb_atom_t wm_colormap_windows_atom,
                                                      uint32_t list_len,
                                                      const xcb_window_t *list);
typedef struct {
uint32_t windows_len;
xcb_window_t *windows;
xcb_get_property_reply_t *_reply;
} xcb_icccm_get_wm_colormap_windows_reply_t;
xcb_get_property_cookie_t xcb_icccm_get_wm_colormap_windows(xcb_connection_t *c,
                                                              xcb_window_t window,
                                                              xcb_atom_t wm_colormap_windows_atom);
xcb_get_property_cookie_t xcb_icccm_get_wm_colormap_windows_unchecked(xcb_connection_t *c,
                                                                        xcb_window_t window,
                                                                        xcb_atom_t wm_colormap_windows_atom);
uint8_t xcb_icccm_get_wm_colormap_windows_from_reply(xcb_get_property_reply_t *reply,
                                                       xcb_icccm_get_wm_colormap_windows_reply_t *colormap_windows);
uint8_t xcb_icccm_get_wm_colormap_windows_reply(xcb_connection_t *c,
                                                  xcb_get_property_cookie_t cookie,
                                                  xcb_icccm_get_wm_colormap_windows_reply_t *windows,
                                                  xcb_generic_error_t **e);
void xcb_icccm_get_wm_colormap_windows_reply_wipe(xcb_icccm_get_wm_colormap_windows_reply_t *windows);
xcb_void_cookie_t xcb_icccm_set_wm_client_machine_checked(xcb_connection_t *c,
                                                            xcb_window_t window,
                                                            xcb_atom_t encoding,
                                                            uint8_t format,
                                                            uint32_t name_len,
                                                            const char *name);
xcb_void_cookie_t xcb_icccm_set_wm_client_machine(xcb_connection_t *c,
                                                    xcb_window_t window,
                                                    xcb_atom_t encoding,
                                                    uint8_t format,
                                                    uint32_t name_len,
                                                    const char *name);
xcb_get_property_cookie_t xcb_icccm_get_wm_client_machine(xcb_connection_t *c,
                                                            xcb_window_t window);
xcb_get_property_cookie_t xcb_icccm_get_wm_client_machine_unchecked(xcb_connection_t *c,
                                                                      xcb_window_t window);
uint8_t xcb_icccm_get_wm_client_machine_reply(xcb_connection_t *c,
                                                xcb_get_property_cookie_t cookie,
                                                xcb_icccm_get_text_property_reply_t *prop,
                                                xcb_generic_error_t **e);
xcb_void_cookie_t xcb_icccm_set_wm_class_checked(xcb_connection_t *c,
                                                   xcb_window_t window,
                                                   uint32_t class_len,
                                                   const char *class_name);
xcb_void_cookie_t xcb_icccm_set_wm_class(xcb_connection_t *c,
                                           xcb_window_t window,
                                           uint32_t class_len,
                                           const char *class_name);
typedef struct {
char *instance_name;
char *class_name;
xcb_get_property_reply_t *_reply;
} xcb_icccm_get_wm_class_reply_t;
xcb_get_property_cookie_t xcb_icccm_get_wm_class(xcb_connection_t *c,
                                                   xcb_window_t window);
xcb_get_property_cookie_t xcb_icccm_get_wm_class_unchecked(xcb_connection_t *c,
                                                             xcb_window_t window);
uint8_t
xcb_icccm_get_wm_class_from_reply(xcb_icccm_get_wm_class_reply_t *prop,
                                    xcb_get_property_reply_t *reply);
uint8_t xcb_icccm_get_wm_class_reply(xcb_connection_t *c,
                                       xcb_get_property_cookie_t cookie,
                                       xcb_icccm_get_wm_class_reply_t *prop,
                                       xcb_generic_error_t **e);
void xcb_icccm_get_wm_class_reply_wipe(xcb_icccm_get_wm_class_reply_t *prop);
xcb_void_cookie_t xcb_icccm_set_wm_transient_for_checked(xcb_connection_t *c,
                                                           xcb_window_t window,
                                                           xcb_window_t transient_for_window);
xcb_void_cookie_t xcb_icccm_set_wm_transient_for(xcb_connection_t *c,
                                                   xcb_window_t window,
                                                   xcb_window_t transient_for_window);
xcb_get_property_cookie_t xcb_icccm_get_wm_transient_for(xcb_connection_t *c,
                                                           xcb_window_t window);
xcb_get_property_cookie_t xcb_icccm_get_wm_transient_for_unchecked(xcb_connection_t *c,
                                                                     xcb_window_t window);
uint8_t
xcb_icccm_get_wm_transient_for_from_reply(xcb_window_t *prop,
                                            xcb_get_property_reply_t *reply);
uint8_t xcb_icccm_get_wm_transient_for_reply(xcb_connection_t *c,
                                               xcb_get_property_cookie_t cookie,
                                               xcb_window_t *prop,
                                               xcb_generic_error_t **e);
typedef enum {
XCB_ICCCM_SIZE_HINT_US_POSITION = 1 << 0,
	XCB_ICCCM_SIZE_HINT_US_SIZE = 1 << 1,
	XCB_ICCCM_SIZE_HINT_P_POSITION = 1 << 2,
	XCB_ICCCM_SIZE_HINT_P_SIZE = 1 << 3,
	XCB_ICCCM_SIZE_HINT_P_MIN_SIZE = 1 << 4,
	XCB_ICCCM_SIZE_HINT_P_MAX_SIZE = 1 << 5,
	XCB_ICCCM_SIZE_HINT_P_RESIZE_INC = 1 << 6,
	XCB_ICCCM_SIZE_HINT_P_ASPECT = 1 << 7,
	XCB_ICCCM_SIZE_HINT_BASE_SIZE = 1 << 8,
	XCB_ICCCM_SIZE_HINT_P_WIN_GRAVITY = 1 << 9
} xcb_icccm_size_hints_flags_t;
typedef struct {
	uint32_t flags;
	int32_t x, y;
	int32_t width, height;
	int32_t min_width, min_height;
	int32_t max_width, max_height;
	int32_t width_inc, height_inc;
	int32_t min_aspect_num, min_aspect_den;
	int32_t max_aspect_num, max_aspect_den;
	int32_t base_width, base_height;
	uint32_t win_gravity;
} xcb_size_hints_t;
enum {
	XCB_ICCCM_NUM_WM_SIZE_HINTS_ELEMENTS = 18,
};
void xcb_icccm_size_hints_set_position(xcb_size_hints_t *hints, int user_specified,
                                       int32_t x, int32_t y);
void xcb_icccm_size_hints_set_size(xcb_size_hints_t *hints, int user_specified,
                                   int32_t width, int32_t height);
void xcb_icccm_size_hints_set_min_size(xcb_size_hints_t *hints, int32_t min_width,
                                       int32_t min_height);
void xcb_icccm_size_hints_set_max_size(xcb_size_hints_t *hints, int32_t max_width,
                                       int32_t max_height);
void xcb_icccm_size_hints_set_resize_inc(xcb_size_hints_t *hints, int32_t width_inc,
                                         int32_t height_inc);
void xcb_icccm_size_hints_set_aspect(xcb_size_hints_t *hints, int32_t min_aspect_num,
                                     int32_t min_aspect_den, int32_t max_aspect_num,
                                     int32_t max_aspect_den);
void xcb_icccm_size_hints_set_base_size(xcb_size_hints_t *hints, int32_t base_width,
                                        int32_t base_height);
void xcb_icccm_size_hints_set_win_gravity(xcb_size_hints_t *hints,
                                          xcb_gravity_t win_gravity);
xcb_void_cookie_t xcb_icccm_set_wm_size_hints_checked(xcb_connection_t *c,
                                                      xcb_window_t window,
                                                      xcb_atom_t property,
                                                      xcb_size_hints_t *hints);
xcb_void_cookie_t xcb_icccm_set_wm_size_hints(xcb_connection_t *c,
                                              xcb_window_t window,
                                              xcb_atom_t property,
                                              xcb_size_hints_t *hints);
xcb_get_property_cookie_t xcb_icccm_get_wm_size_hints(xcb_connection_t *c,
                                                      xcb_window_t window,
                                                      xcb_atom_t property);
xcb_get_property_cookie_t xcb_icccm_get_wm_size_hints_unchecked(xcb_connection_t *c,
                                                                xcb_window_t window,
                                                                xcb_atom_t property);
uint8_t xcb_icccm_get_wm_size_hints_reply(xcb_connection_t *c,
                                          xcb_get_property_cookie_t cookie,
                                          xcb_size_hints_t *hints,
                                          xcb_generic_error_t **e);
xcb_void_cookie_t xcb_icccm_set_wm_normal_hints_checked(xcb_connection_t *c,
                                                        xcb_window_t window,
                                                        xcb_size_hints_t *hints);
xcb_void_cookie_t xcb_icccm_set_wm_normal_hints(xcb_connection_t *c,
                                                  xcb_window_t window,
                                                xcb_size_hints_t *hints);
xcb_get_property_cookie_t xcb_icccm_get_wm_normal_hints(xcb_connection_t *c,
                                                          xcb_window_t window);
xcb_get_property_cookie_t xcb_icccm_get_wm_normal_hints_unchecked(xcb_connection_t *c,
                                                                    xcb_window_t window);
uint8_t
xcb_icccm_get_wm_size_hints_from_reply(xcb_size_hints_t *hints,
                                         xcb_get_property_reply_t *reply);
uint8_t xcb_icccm_get_wm_normal_hints_reply(xcb_connection_t *c,
                                            xcb_get_property_cookie_t cookie,
                                            xcb_size_hints_t *hints,
                                            xcb_generic_error_t **e);
typedef struct {
  int32_t flags;
  uint32_t input;
  int32_t initial_state;
  xcb_pixmap_t icon_pixmap;
  xcb_window_t icon_window;
  int32_t icon_x, icon_y;
  xcb_pixmap_t icon_mask;
  xcb_window_t window_group;
} xcb_icccm_wm_hints_t;
enum {
	XCB_ICCCM_NUM_WM_HINTS_ELEMENTS = 9,
};
typedef enum {
  XCB_ICCCM_WM_STATE_WITHDRAWN = 0,
  XCB_ICCCM_WM_STATE_NORMAL = 1,
  XCB_ICCCM_WM_STATE_ICONIC = 3
} xcb_icccm_wm_state_t;
typedef enum {
  XCB_ICCCM_WM_HINT_INPUT = (1 << 0),
  XCB_ICCCM_WM_HINT_STATE = (1 << 1),
  XCB_ICCCM_WM_HINT_ICON_PIXMAP = (1 << 2),
  XCB_ICCCM_WM_HINT_ICON_WINDOW = (1 << 3),
  XCB_ICCCM_WM_HINT_ICON_POSITION = (1 << 4),
  XCB_ICCCM_WM_HINT_ICON_MASK = (1 << 5),
  XCB_ICCCM_WM_HINT_WINDOW_GROUP = (1 << 6),
  XCB_ICCCM_WM_HINT_X_URGENCY = (1 << 8)
} xcb_icccm_wm_t;
enum {
	XCB_ICCCM_WM_ALL_HINTS = (XCB_ICCCM_WM_HINT_INPUT | XCB_ICCCM_WM_HINT_STATE | XCB_ICCCM_WM_HINT_ICON_PIXMAP | XCB_ICCCM_WM_HINT_ICON_WINDOW | XCB_ICCCM_WM_HINT_ICON_POSITION | XCB_ICCCM_WM_HINT_ICON_MASK | XCB_ICCCM_WM_HINT_WINDOW_GROUP),
};
uint32_t xcb_icccm_wm_hints_get_urgency(xcb_icccm_wm_hints_t *hints);
void xcb_icccm_wm_hints_set_input(xcb_icccm_wm_hints_t *hints, uint8_t input);
void xcb_icccm_wm_hints_set_iconic(xcb_icccm_wm_hints_t *hints);
void xcb_icccm_wm_hints_set_normal(xcb_icccm_wm_hints_t *hints);
void xcb_icccm_wm_hints_set_withdrawn(xcb_icccm_wm_hints_t *hints);
void xcb_icccm_wm_hints_set_none(xcb_icccm_wm_hints_t *hints);
void xcb_icccm_wm_hints_set_icon_pixmap(xcb_icccm_wm_hints_t *hints,
                                        xcb_pixmap_t icon_pixmap);
void xcb_icccm_wm_hints_set_icon_mask(xcb_icccm_wm_hints_t *hints, xcb_pixmap_t icon_mask);
void xcb_icccm_wm_hints_set_icon_window(xcb_icccm_wm_hints_t *hints,
                                        xcb_window_t icon_window);
void xcb_icccm_wm_hints_set_window_group(xcb_icccm_wm_hints_t *hints,
                                         xcb_window_t window_group);
void xcb_icccm_wm_hints_set_urgency(xcb_icccm_wm_hints_t *hints);
xcb_void_cookie_t xcb_icccm_set_wm_hints_checked(xcb_connection_t *c,
                                                 xcb_window_t window,
                                                 xcb_icccm_wm_hints_t *hints);
xcb_void_cookie_t xcb_icccm_set_wm_hints(xcb_connection_t *c,
                                         xcb_window_t window,
                                         xcb_icccm_wm_hints_t *hints);
xcb_get_property_cookie_t xcb_icccm_get_wm_hints(xcb_connection_t *c,
                                                 xcb_window_t window);
xcb_get_property_cookie_t xcb_icccm_get_wm_hints_unchecked(xcb_connection_t *c,
                                                           xcb_window_t window);
uint8_t
xcb_icccm_get_wm_hints_from_reply(xcb_icccm_wm_hints_t *hints,
                                  xcb_get_property_reply_t *reply);
uint8_t xcb_icccm_get_wm_hints_reply(xcb_connection_t *c,
                                     xcb_get_property_cookie_t cookie,
                                     xcb_icccm_wm_hints_t *hints,
                                     xcb_generic_error_t **e);
xcb_void_cookie_t xcb_icccm_set_wm_protocols_checked(xcb_connection_t *c,
                                                     xcb_window_t window,
                                                     xcb_atom_t wm_protocols,
                                                     uint32_t list_len,
                                                     xcb_atom_t *list);
xcb_void_cookie_t xcb_icccm_set_wm_protocols(xcb_connection_t *c,
                                             xcb_window_t window,
                                             xcb_atom_t wm_protocols,
                                             uint32_t list_len,
                                             xcb_atom_t *list);
typedef struct {
	uint32_t atoms_len;
	xcb_atom_t *atoms;
	xcb_get_property_reply_t *_reply;
} xcb_icccm_get_wm_protocols_reply_t;
xcb_get_property_cookie_t xcb_icccm_get_wm_protocols(xcb_connection_t *c,
                                                     xcb_window_t window,
                                                     xcb_atom_t wm_protocol_atom);
xcb_get_property_cookie_t xcb_icccm_get_wm_protocols_unchecked(xcb_connection_t *c,
                                                               xcb_window_t window,
                                                               xcb_atom_t wm_protocol_atom);
uint8_t xcb_icccm_get_wm_protocols_from_reply(xcb_get_property_reply_t *reply,
                                              xcb_icccm_get_wm_protocols_reply_t *protocols);
uint8_t xcb_icccm_get_wm_protocols_reply(xcb_connection_t *c,
                                         xcb_get_property_cookie_t cookie,
                                         xcb_icccm_get_wm_protocols_reply_t *protocols,
                                         xcb_generic_error_t **e);
void xcb_icccm_get_wm_protocols_reply_wipe(xcb_icccm_get_wm_protocols_reply_t *protocols);
]]
