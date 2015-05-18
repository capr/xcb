--xcb/composite.h from libxcb-composite0-dev package v1.10-2ubuntu1 from ubuntu 14

require'xcb_h'
require'xcb_xfixes_h'
local ffi = require'ffi'

ffi.cdef[[
// xcb/composite.h
enum {
	XCB_COMPOSITE_MAJOR_VERSION = 0,
	XCB_COMPOSITE_MINOR_VERSION = 4,
};
extern xcb_extension_t xcb_composite_id;
typedef enum xcb_composite_redirect_t {
    XCB_COMPOSITE_REDIRECT_AUTOMATIC = 0,
    XCB_COMPOSITE_REDIRECT_MANUAL = 1
} xcb_composite_redirect_t;
typedef struct xcb_composite_query_version_cookie_t {
    unsigned int sequence;
} xcb_composite_query_version_cookie_t;
enum {
	XCB_COMPOSITE_QUERY_VERSION = 0,
};
typedef struct xcb_composite_query_version_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    uint32_t client_major_version;
    uint32_t client_minor_version;
} xcb_composite_query_version_request_t;
typedef struct xcb_composite_query_version_reply_t {
    uint8_t response_type;
    uint8_t pad0;
    uint16_t sequence;
    uint32_t length;
    uint32_t major_version;
    uint32_t minor_version;
    uint8_t pad1[16];
} xcb_composite_query_version_reply_t;
enum {
	XCB_COMPOSITE_REDIRECT_WINDOW = 1,
};
typedef struct xcb_composite_redirect_window_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_window_t window;
    uint8_t update;
    uint8_t pad0[3];
} xcb_composite_redirect_window_request_t;
enum {
	XCB_COMPOSITE_REDIRECT_SUBWINDOWS = 2,
};
typedef struct xcb_composite_redirect_subwindows_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_window_t window;
    uint8_t update;
    uint8_t pad0[3];
} xcb_composite_redirect_subwindows_request_t;
enum {
	XCB_COMPOSITE_UNREDIRECT_WINDOW = 3,
};
typedef struct xcb_composite_unredirect_window_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_window_t window;
    uint8_t update;
    uint8_t pad0[3];
} xcb_composite_unredirect_window_request_t;
enum {
	XCB_COMPOSITE_UNREDIRECT_SUBWINDOWS = 4,
};
typedef struct xcb_composite_unredirect_subwindows_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_window_t window;
    uint8_t update;
    uint8_t pad0[3];
} xcb_composite_unredirect_subwindows_request_t;
enum {
	XCB_COMPOSITE_CREATE_REGION_FROM_BORDER_CLIP = 5,
};
typedef struct xcb_composite_create_region_from_border_clip_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_xfixes_region_t region;
    xcb_window_t window;
} xcb_composite_create_region_from_border_clip_request_t;
enum {
	XCB_COMPOSITE_NAME_WINDOW_PIXMAP = 6,
};
typedef struct xcb_composite_name_window_pixmap_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_window_t window;
    xcb_pixmap_t pixmap;
} xcb_composite_name_window_pixmap_request_t;
typedef struct xcb_composite_get_overlay_window_cookie_t {
    unsigned int sequence;
} xcb_composite_get_overlay_window_cookie_t;
enum {
	XCB_COMPOSITE_GET_OVERLAY_WINDOW = 7,
};
typedef struct xcb_composite_get_overlay_window_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_window_t window;
} xcb_composite_get_overlay_window_request_t;
typedef struct xcb_composite_get_overlay_window_reply_t {
    uint8_t response_type;
    uint8_t pad0;
    uint16_t sequence;
    uint32_t length;
    xcb_window_t overlay_win;
    uint8_t pad1[20];
} xcb_composite_get_overlay_window_reply_t;
enum {
	XCB_COMPOSITE_RELEASE_OVERLAY_WINDOW = 8,
};
typedef struct xcb_composite_release_overlay_window_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_window_t window;
} xcb_composite_release_overlay_window_request_t;
xcb_composite_query_version_cookie_t
xcb_composite_query_version (xcb_connection_t *c ,
                             uint32_t client_major_version ,
                             uint32_t client_minor_version );
xcb_composite_query_version_cookie_t
xcb_composite_query_version_unchecked (xcb_connection_t *c ,
                                       uint32_t client_major_version ,
                                       uint32_t client_minor_version );
xcb_composite_query_version_reply_t *
xcb_composite_query_version_reply (xcb_connection_t *c ,
                                   xcb_composite_query_version_cookie_t cookie ,
                                   xcb_generic_error_t **e );
xcb_void_cookie_t
xcb_composite_redirect_window_checked (xcb_connection_t *c ,
                                       xcb_window_t window ,
                                       uint8_t update );
xcb_void_cookie_t
xcb_composite_redirect_window (xcb_connection_t *c ,
                               xcb_window_t window ,
                               uint8_t update );
xcb_void_cookie_t
xcb_composite_redirect_subwindows_checked (xcb_connection_t *c ,
                                           xcb_window_t window ,
                                           uint8_t update );
xcb_void_cookie_t
xcb_composite_redirect_subwindows (xcb_connection_t *c ,
                                   xcb_window_t window ,
                                   uint8_t update );
xcb_void_cookie_t
xcb_composite_unredirect_window_checked (xcb_connection_t *c ,
                                         xcb_window_t window ,
                                         uint8_t update );
xcb_void_cookie_t
xcb_composite_unredirect_window (xcb_connection_t *c ,
                                 xcb_window_t window ,
                                 uint8_t update );
xcb_void_cookie_t
xcb_composite_unredirect_subwindows_checked (xcb_connection_t *c ,
                                             xcb_window_t window ,
                                             uint8_t update );
xcb_void_cookie_t
xcb_composite_unredirect_subwindows (xcb_connection_t *c ,
                                     xcb_window_t window ,
                                     uint8_t update );
xcb_void_cookie_t
xcb_composite_create_region_from_border_clip_checked (xcb_connection_t *c ,
                                                      xcb_xfixes_region_t region ,
                                                      xcb_window_t window );
xcb_void_cookie_t
xcb_composite_create_region_from_border_clip (xcb_connection_t *c ,
                                              xcb_xfixes_region_t region ,
                                              xcb_window_t window );
xcb_void_cookie_t
xcb_composite_name_window_pixmap_checked (xcb_connection_t *c ,
                                          xcb_window_t window ,
                                          xcb_pixmap_t pixmap );
xcb_void_cookie_t
xcb_composite_name_window_pixmap (xcb_connection_t *c ,
                                  xcb_window_t window ,
                                  xcb_pixmap_t pixmap );
xcb_composite_get_overlay_window_cookie_t
xcb_composite_get_overlay_window (xcb_connection_t *c ,
                                  xcb_window_t window );
xcb_composite_get_overlay_window_cookie_t
xcb_composite_get_overlay_window_unchecked (xcb_connection_t *c ,
                                            xcb_window_t window );
xcb_composite_get_overlay_window_reply_t *
xcb_composite_get_overlay_window_reply (xcb_connection_t *c ,
                                        xcb_composite_get_overlay_window_cookie_t cookie ,
                                        xcb_generic_error_t **e );
xcb_void_cookie_t
xcb_composite_release_overlay_window_checked (xcb_connection_t *c ,
                                              xcb_window_t window );
xcb_void_cookie_t
xcb_composite_release_overlay_window (xcb_connection_t *c ,
                                      xcb_window_t window );
]]
