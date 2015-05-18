--xcb/xfixes.h from libxcb-xfixes0-dev package v1.10-2ubuntu1 from ubuntu 14

require'xcb_h'
require'xcb_shape_h'
require'xcb_render_h'
local ffi = require'ffi'

ffi.cdef[[
// xcb/xfixes.h
enum {
	XCB_XFIXES_MAJOR_VERSION = 5,
	XCB_XFIXES_MINOR_VERSION = 0,
};
extern xcb_extension_t xcb_xfixes_id;
typedef struct xcb_xfixes_query_version_cookie_t {
    unsigned int sequence;
} xcb_xfixes_query_version_cookie_t;
enum {
	XCB_XFIXES_QUERY_VERSION = 0,
};
typedef struct xcb_xfixes_query_version_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    uint32_t client_major_version;
    uint32_t client_minor_version;
} xcb_xfixes_query_version_request_t;
typedef struct xcb_xfixes_query_version_reply_t {
    uint8_t response_type;
    uint8_t pad0;
    uint16_t sequence;
    uint32_t length;
    uint32_t major_version;
    uint32_t minor_version;
    uint8_t pad1[16];
} xcb_xfixes_query_version_reply_t;
typedef enum xcb_xfixes_save_set_mode_t {
    XCB_XFIXES_SAVE_SET_MODE_INSERT = 0,
    XCB_XFIXES_SAVE_SET_MODE_DELETE = 1
} xcb_xfixes_save_set_mode_t;
typedef enum xcb_xfixes_save_set_target_t {
    XCB_XFIXES_SAVE_SET_TARGET_NEAREST = 0,
    XCB_XFIXES_SAVE_SET_TARGET_ROOT = 1
} xcb_xfixes_save_set_target_t;
typedef enum xcb_xfixes_save_set_mapping_t {
    XCB_XFIXES_SAVE_SET_MAPPING_MAP = 0,
    XCB_XFIXES_SAVE_SET_MAPPING_UNMAP = 1
} xcb_xfixes_save_set_mapping_t;
enum {
	XCB_XFIXES_CHANGE_SAVE_SET = 1,
};
typedef struct xcb_xfixes_change_save_set_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    uint8_t mode;
    uint8_t target;
    uint8_t map;
    uint8_t pad0;
    xcb_window_t window;
} xcb_xfixes_change_save_set_request_t;
typedef enum xcb_xfixes_selection_event_t {
    XCB_XFIXES_SELECTION_EVENT_SET_SELECTION_OWNER = 0,
    XCB_XFIXES_SELECTION_EVENT_SELECTION_WINDOW_DESTROY = 1,
    XCB_XFIXES_SELECTION_EVENT_SELECTION_CLIENT_CLOSE = 2
} xcb_xfixes_selection_event_t;
typedef enum xcb_xfixes_selection_event_mask_t {
    XCB_XFIXES_SELECTION_EVENT_MASK_SET_SELECTION_OWNER = 1,
    XCB_XFIXES_SELECTION_EVENT_MASK_SELECTION_WINDOW_DESTROY = 2,
    XCB_XFIXES_SELECTION_EVENT_MASK_SELECTION_CLIENT_CLOSE = 4
} xcb_xfixes_selection_event_mask_t;
enum {
	XCB_XFIXES_SELECTION_NOTIFY = 0,
};
typedef struct xcb_xfixes_selection_notify_event_t {
    uint8_t response_type;
    uint8_t subtype;
    uint16_t sequence;
    xcb_window_t window;
    xcb_window_t owner;
    xcb_atom_t selection;
    xcb_timestamp_t timestamp;
    xcb_timestamp_t selection_timestamp;
    uint8_t pad0[8];
} xcb_xfixes_selection_notify_event_t;
enum {
	XCB_XFIXES_SELECT_SELECTION_INPUT = 2,
};
typedef struct xcb_xfixes_select_selection_input_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_window_t window;
    xcb_atom_t selection;
    uint32_t event_mask;
} xcb_xfixes_select_selection_input_request_t;
typedef enum xcb_xfixes_cursor_notify_t {
    XCB_XFIXES_CURSOR_NOTIFY_DISPLAY_CURSOR = 0
} xcb_xfixes_cursor_notify_t;
typedef enum xcb_xfixes_cursor_notify_mask_t {
    XCB_XFIXES_CURSOR_NOTIFY_MASK_DISPLAY_CURSOR = 1
} xcb_xfixes_cursor_notify_mask_t;
enum {
	XCB_XFIXES_CURSOR_NOTIFY = 1,
};
typedef struct xcb_xfixes_cursor_notify_event_t {
    uint8_t response_type;
    uint8_t subtype;
    uint16_t sequence;
    xcb_window_t window;
    uint32_t cursor_serial;
    xcb_timestamp_t timestamp;
    xcb_atom_t name;
    uint8_t pad0[12];
} xcb_xfixes_cursor_notify_event_t;
enum {
	XCB_XFIXES_SELECT_CURSOR_INPUT = 3,
};
typedef struct xcb_xfixes_select_cursor_input_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_window_t window;
    uint32_t event_mask;
} xcb_xfixes_select_cursor_input_request_t;
typedef struct xcb_xfixes_get_cursor_image_cookie_t {
    unsigned int sequence;
} xcb_xfixes_get_cursor_image_cookie_t;
enum {
	XCB_XFIXES_GET_CURSOR_IMAGE = 4,
};
typedef struct xcb_xfixes_get_cursor_image_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
} xcb_xfixes_get_cursor_image_request_t;
typedef struct xcb_xfixes_get_cursor_image_reply_t {
    uint8_t response_type;
    uint8_t pad0;
    uint16_t sequence;
    uint32_t length;
    int16_t x;
    int16_t y;
    uint16_t width;
    uint16_t height;
    uint16_t xhot;
    uint16_t yhot;
    uint32_t cursor_serial;
    uint8_t pad1[8];
} xcb_xfixes_get_cursor_image_reply_t;
typedef uint32_t xcb_xfixes_region_t;
typedef struct xcb_xfixes_region_iterator_t {
    xcb_xfixes_region_t *data;
    int rem;
    int index;
} xcb_xfixes_region_iterator_t;
enum {
	XCB_XFIXES_BAD_REGION = 0,
};
typedef struct xcb_xfixes_bad_region_error_t {
    uint8_t response_type;
    uint8_t error_code;
    uint16_t sequence;
} xcb_xfixes_bad_region_error_t;
typedef enum xcb_xfixes_region_enum_t {
    XCB_XFIXES_REGION_NONE = 0
} xcb_xfixes_region_enum_t;
enum {
	XCB_XFIXES_CREATE_REGION = 5,
};
typedef struct xcb_xfixes_create_region_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_xfixes_region_t region;
} xcb_xfixes_create_region_request_t;
enum {
	XCB_XFIXES_CREATE_REGION_FROM_BITMAP = 6,
};
typedef struct xcb_xfixes_create_region_from_bitmap_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_xfixes_region_t region;
    xcb_pixmap_t bitmap;
} xcb_xfixes_create_region_from_bitmap_request_t;
enum {
	XCB_XFIXES_CREATE_REGION_FROM_WINDOW = 7,
};
typedef struct xcb_xfixes_create_region_from_window_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_xfixes_region_t region;
    xcb_window_t window;
    xcb_shape_kind_t kind;
    uint8_t pad0[3];
} xcb_xfixes_create_region_from_window_request_t;
enum {
	XCB_XFIXES_CREATE_REGION_FROM_GC = 8,
};
typedef struct xcb_xfixes_create_region_from_gc_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_xfixes_region_t region;
    xcb_gcontext_t gc;
} xcb_xfixes_create_region_from_gc_request_t;
enum {
	XCB_XFIXES_CREATE_REGION_FROM_PICTURE = 9,
};
typedef struct xcb_xfixes_create_region_from_picture_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_xfixes_region_t region;
    xcb_render_picture_t picture;
} xcb_xfixes_create_region_from_picture_request_t;
enum {
	XCB_XFIXES_DESTROY_REGION = 10,
};
typedef struct xcb_xfixes_destroy_region_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_xfixes_region_t region;
} xcb_xfixes_destroy_region_request_t;
enum {
	XCB_XFIXES_SET_REGION = 11,
};
typedef struct xcb_xfixes_set_region_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_xfixes_region_t region;
} xcb_xfixes_set_region_request_t;
enum {
	XCB_XFIXES_COPY_REGION = 12,
};
typedef struct xcb_xfixes_copy_region_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_xfixes_region_t source;
    xcb_xfixes_region_t destination;
} xcb_xfixes_copy_region_request_t;
enum {
	XCB_XFIXES_UNION_REGION = 13,
};
typedef struct xcb_xfixes_union_region_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_xfixes_region_t source1;
    xcb_xfixes_region_t source2;
    xcb_xfixes_region_t destination;
} xcb_xfixes_union_region_request_t;
enum {
	XCB_XFIXES_INTERSECT_REGION = 14,
};
typedef struct xcb_xfixes_intersect_region_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_xfixes_region_t source1;
    xcb_xfixes_region_t source2;
    xcb_xfixes_region_t destination;
} xcb_xfixes_intersect_region_request_t;
enum {
	XCB_XFIXES_SUBTRACT_REGION = 15,
};
typedef struct xcb_xfixes_subtract_region_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_xfixes_region_t source1;
    xcb_xfixes_region_t source2;
    xcb_xfixes_region_t destination;
} xcb_xfixes_subtract_region_request_t;
enum {
	XCB_XFIXES_INVERT_REGION = 16,
};
typedef struct xcb_xfixes_invert_region_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_xfixes_region_t source;
    xcb_rectangle_t bounds;
    xcb_xfixes_region_t destination;
} xcb_xfixes_invert_region_request_t;
enum {
	XCB_XFIXES_TRANSLATE_REGION = 17,
};
typedef struct xcb_xfixes_translate_region_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_xfixes_region_t region;
    int16_t dx;
    int16_t dy;
} xcb_xfixes_translate_region_request_t;
enum {
	XCB_XFIXES_REGION_EXTENTS = 18,
};
typedef struct xcb_xfixes_region_extents_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_xfixes_region_t source;
    xcb_xfixes_region_t destination;
} xcb_xfixes_region_extents_request_t;
typedef struct xcb_xfixes_fetch_region_cookie_t {
    unsigned int sequence;
} xcb_xfixes_fetch_region_cookie_t;
enum {
	XCB_XFIXES_FETCH_REGION = 19,
};
typedef struct xcb_xfixes_fetch_region_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_xfixes_region_t region;
} xcb_xfixes_fetch_region_request_t;
typedef struct xcb_xfixes_fetch_region_reply_t {
    uint8_t response_type;
    uint8_t pad0;
    uint16_t sequence;
    uint32_t length;
    xcb_rectangle_t extents;
    uint8_t pad1[16];
} xcb_xfixes_fetch_region_reply_t;
enum {
	XCB_XFIXES_SET_GC_CLIP_REGION = 20,
};
typedef struct xcb_xfixes_set_gc_clip_region_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_gcontext_t gc;
    xcb_xfixes_region_t region;
    int16_t x_origin;
    int16_t y_origin;
} xcb_xfixes_set_gc_clip_region_request_t;
enum {
	XCB_XFIXES_SET_WINDOW_SHAPE_REGION = 21,
};
typedef struct xcb_xfixes_set_window_shape_region_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_window_t dest;
    xcb_shape_kind_t dest_kind;
    uint8_t pad0[3];
    int16_t x_offset;
    int16_t y_offset;
    xcb_xfixes_region_t region;
} xcb_xfixes_set_window_shape_region_request_t;
enum {
	XCB_XFIXES_SET_PICTURE_CLIP_REGION = 22,
};
typedef struct xcb_xfixes_set_picture_clip_region_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_render_picture_t picture;
    xcb_xfixes_region_t region;
    int16_t x_origin;
    int16_t y_origin;
} xcb_xfixes_set_picture_clip_region_request_t;
enum {
	XCB_XFIXES_SET_CURSOR_NAME = 23,
};
typedef struct xcb_xfixes_set_cursor_name_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_cursor_t cursor;
    uint16_t nbytes;
    uint8_t pad0[2];
} xcb_xfixes_set_cursor_name_request_t;
typedef struct xcb_xfixes_get_cursor_name_cookie_t {
    unsigned int sequence;
} xcb_xfixes_get_cursor_name_cookie_t;
enum {
	XCB_XFIXES_GET_CURSOR_NAME = 24,
};
typedef struct xcb_xfixes_get_cursor_name_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_cursor_t cursor;
} xcb_xfixes_get_cursor_name_request_t;
typedef struct xcb_xfixes_get_cursor_name_reply_t {
    uint8_t response_type;
    uint8_t pad0;
    uint16_t sequence;
    uint32_t length;
    xcb_atom_t atom;
    uint16_t nbytes;
    uint8_t pad1[18];
} xcb_xfixes_get_cursor_name_reply_t;
typedef struct xcb_xfixes_get_cursor_image_and_name_cookie_t {
    unsigned int sequence;
} xcb_xfixes_get_cursor_image_and_name_cookie_t;
enum {
	XCB_XFIXES_GET_CURSOR_IMAGE_AND_NAME = 25,
};
typedef struct xcb_xfixes_get_cursor_image_and_name_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
} xcb_xfixes_get_cursor_image_and_name_request_t;
typedef struct xcb_xfixes_get_cursor_image_and_name_reply_t {
    uint8_t response_type;
    uint8_t pad0;
    uint16_t sequence;
    uint32_t length;
    int16_t x;
    int16_t y;
    uint16_t width;
    uint16_t height;
    uint16_t xhot;
    uint16_t yhot;
    uint32_t cursor_serial;
    xcb_atom_t cursor_atom;
    uint16_t nbytes;
    uint8_t pad1[2];
} xcb_xfixes_get_cursor_image_and_name_reply_t;
enum {
	XCB_XFIXES_CHANGE_CURSOR = 26,
};
typedef struct xcb_xfixes_change_cursor_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_cursor_t source;
    xcb_cursor_t destination;
} xcb_xfixes_change_cursor_request_t;
enum {
	XCB_XFIXES_CHANGE_CURSOR_BY_NAME = 27,
};
typedef struct xcb_xfixes_change_cursor_by_name_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_cursor_t src;
    uint16_t nbytes;
    uint8_t pad0[2];
} xcb_xfixes_change_cursor_by_name_request_t;
enum {
	XCB_XFIXES_EXPAND_REGION = 28,
};
typedef struct xcb_xfixes_expand_region_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_xfixes_region_t source;
    xcb_xfixes_region_t destination;
    uint16_t left;
    uint16_t right;
    uint16_t top;
    uint16_t bottom;
} xcb_xfixes_expand_region_request_t;
enum {
	XCB_XFIXES_HIDE_CURSOR = 29,
};
typedef struct xcb_xfixes_hide_cursor_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_window_t window;
} xcb_xfixes_hide_cursor_request_t;
enum {
	XCB_XFIXES_SHOW_CURSOR = 30,
};
typedef struct xcb_xfixes_show_cursor_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_window_t window;
} xcb_xfixes_show_cursor_request_t;
typedef uint32_t xcb_xfixes_barrier_t;
typedef struct xcb_xfixes_barrier_iterator_t {
    xcb_xfixes_barrier_t *data;
    int rem;
    int index;
} xcb_xfixes_barrier_iterator_t;
typedef enum xcb_xfixes_barrier_directions_t {
    XCB_XFIXES_BARRIER_DIRECTIONS_POSITIVE_X = 1,
    XCB_XFIXES_BARRIER_DIRECTIONS_POSITIVE_Y = 2,
    XCB_XFIXES_BARRIER_DIRECTIONS_NEGATIVE_X = 4,
    XCB_XFIXES_BARRIER_DIRECTIONS_NEGATIVE_Y = 8
} xcb_xfixes_barrier_directions_t;
enum {
	XCB_XFIXES_CREATE_POINTER_BARRIER = 31,
};
typedef struct xcb_xfixes_create_pointer_barrier_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_xfixes_barrier_t barrier;
    xcb_window_t window;
    uint16_t x1;
    uint16_t y1;
    uint16_t x2;
    uint16_t y2;
    uint32_t directions;
    uint8_t pad0[2];
    uint16_t num_devices;
} xcb_xfixes_create_pointer_barrier_request_t;
enum {
	XCB_XFIXES_DELETE_POINTER_BARRIER = 32,
};
typedef struct xcb_xfixes_delete_pointer_barrier_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_xfixes_barrier_t barrier;
} xcb_xfixes_delete_pointer_barrier_request_t;
xcb_xfixes_query_version_cookie_t
xcb_xfixes_query_version (xcb_connection_t *c ,
                          uint32_t client_major_version ,
                          uint32_t client_minor_version );
xcb_xfixes_query_version_cookie_t
xcb_xfixes_query_version_unchecked (xcb_connection_t *c ,
                                    uint32_t client_major_version ,
                                    uint32_t client_minor_version );
xcb_xfixes_query_version_reply_t *
xcb_xfixes_query_version_reply (xcb_connection_t *c ,
                                xcb_xfixes_query_version_cookie_t cookie ,
                                xcb_generic_error_t **e );
xcb_void_cookie_t
xcb_xfixes_change_save_set_checked (xcb_connection_t *c ,
                                    uint8_t mode ,
                                    uint8_t target ,
                                    uint8_t map ,
                                    xcb_window_t window );
xcb_void_cookie_t
xcb_xfixes_change_save_set (xcb_connection_t *c ,
                            uint8_t mode ,
                            uint8_t target ,
                            uint8_t map ,
                            xcb_window_t window );
xcb_void_cookie_t
xcb_xfixes_select_selection_input_checked (xcb_connection_t *c ,
                                           xcb_window_t window ,
                                           xcb_atom_t selection ,
                                           uint32_t event_mask );
xcb_void_cookie_t
xcb_xfixes_select_selection_input (xcb_connection_t *c ,
                                   xcb_window_t window ,
                                   xcb_atom_t selection ,
                                   uint32_t event_mask );
xcb_void_cookie_t
xcb_xfixes_select_cursor_input_checked (xcb_connection_t *c ,
                                        xcb_window_t window ,
                                        uint32_t event_mask );
xcb_void_cookie_t
xcb_xfixes_select_cursor_input (xcb_connection_t *c ,
                                xcb_window_t window ,
                                uint32_t event_mask );
int
xcb_xfixes_get_cursor_image_sizeof (const void *_buffer );
xcb_xfixes_get_cursor_image_cookie_t
xcb_xfixes_get_cursor_image (xcb_connection_t *c );
xcb_xfixes_get_cursor_image_cookie_t
xcb_xfixes_get_cursor_image_unchecked (xcb_connection_t *c );
uint32_t *
xcb_xfixes_get_cursor_image_cursor_image (const xcb_xfixes_get_cursor_image_reply_t *R );
int
xcb_xfixes_get_cursor_image_cursor_image_length (const xcb_xfixes_get_cursor_image_reply_t *R );
xcb_generic_iterator_t
xcb_xfixes_get_cursor_image_cursor_image_end (const xcb_xfixes_get_cursor_image_reply_t *R );
xcb_xfixes_get_cursor_image_reply_t *
xcb_xfixes_get_cursor_image_reply (xcb_connection_t *c ,
                                   xcb_xfixes_get_cursor_image_cookie_t cookie ,
                                   xcb_generic_error_t **e );
void
xcb_xfixes_region_next (xcb_xfixes_region_iterator_t *i );
xcb_generic_iterator_t
xcb_xfixes_region_end (xcb_xfixes_region_iterator_t i );
int
xcb_xfixes_create_region_sizeof (const void *_buffer ,
                                 uint32_t rectangles_len );
xcb_void_cookie_t
xcb_xfixes_create_region_checked (xcb_connection_t *c ,
                                  xcb_xfixes_region_t region ,
                                  uint32_t rectangles_len ,
                                  const xcb_rectangle_t *rectangles );
xcb_void_cookie_t
xcb_xfixes_create_region (xcb_connection_t *c ,
                          xcb_xfixes_region_t region ,
                          uint32_t rectangles_len ,
                          const xcb_rectangle_t *rectangles );
xcb_void_cookie_t
xcb_xfixes_create_region_from_bitmap_checked (xcb_connection_t *c ,
                                              xcb_xfixes_region_t region ,
                                              xcb_pixmap_t bitmap );
xcb_void_cookie_t
xcb_xfixes_create_region_from_bitmap (xcb_connection_t *c ,
                                      xcb_xfixes_region_t region ,
                                      xcb_pixmap_t bitmap );
xcb_void_cookie_t
xcb_xfixes_create_region_from_window_checked (xcb_connection_t *c ,
                                              xcb_xfixes_region_t region ,
                                              xcb_window_t window ,
                                              xcb_shape_kind_t kind );
xcb_void_cookie_t
xcb_xfixes_create_region_from_window (xcb_connection_t *c ,
                                      xcb_xfixes_region_t region ,
                                      xcb_window_t window ,
                                      xcb_shape_kind_t kind );
xcb_void_cookie_t
xcb_xfixes_create_region_from_gc_checked (xcb_connection_t *c ,
                                          xcb_xfixes_region_t region ,
                                          xcb_gcontext_t gc );
xcb_void_cookie_t
xcb_xfixes_create_region_from_gc (xcb_connection_t *c ,
                                  xcb_xfixes_region_t region ,
                                  xcb_gcontext_t gc );
xcb_void_cookie_t
xcb_xfixes_create_region_from_picture_checked (xcb_connection_t *c ,
                                               xcb_xfixes_region_t region ,
                                               xcb_render_picture_t picture );
xcb_void_cookie_t
xcb_xfixes_create_region_from_picture (xcb_connection_t *c ,
                                       xcb_xfixes_region_t region ,
                                       xcb_render_picture_t picture );
xcb_void_cookie_t
xcb_xfixes_destroy_region_checked (xcb_connection_t *c ,
                                   xcb_xfixes_region_t region );
xcb_void_cookie_t
xcb_xfixes_destroy_region (xcb_connection_t *c ,
                           xcb_xfixes_region_t region );
int
xcb_xfixes_set_region_sizeof (const void *_buffer ,
                              uint32_t rectangles_len );
xcb_void_cookie_t
xcb_xfixes_set_region_checked (xcb_connection_t *c ,
                               xcb_xfixes_region_t region ,
                               uint32_t rectangles_len ,
                               const xcb_rectangle_t *rectangles );
xcb_void_cookie_t
xcb_xfixes_set_region (xcb_connection_t *c ,
                       xcb_xfixes_region_t region ,
                       uint32_t rectangles_len ,
                       const xcb_rectangle_t *rectangles );
xcb_void_cookie_t
xcb_xfixes_copy_region_checked (xcb_connection_t *c ,
                                xcb_xfixes_region_t source ,
                                xcb_xfixes_region_t destination );
xcb_void_cookie_t
xcb_xfixes_copy_region (xcb_connection_t *c ,
                        xcb_xfixes_region_t source ,
                        xcb_xfixes_region_t destination );
xcb_void_cookie_t
xcb_xfixes_union_region_checked (xcb_connection_t *c ,
                                 xcb_xfixes_region_t source1 ,
                                 xcb_xfixes_region_t source2 ,
                                 xcb_xfixes_region_t destination );
xcb_void_cookie_t
xcb_xfixes_union_region (xcb_connection_t *c ,
                         xcb_xfixes_region_t source1 ,
                         xcb_xfixes_region_t source2 ,
                         xcb_xfixes_region_t destination );
xcb_void_cookie_t
xcb_xfixes_intersect_region_checked (xcb_connection_t *c ,
                                     xcb_xfixes_region_t source1 ,
                                     xcb_xfixes_region_t source2 ,
                                     xcb_xfixes_region_t destination );
xcb_void_cookie_t
xcb_xfixes_intersect_region (xcb_connection_t *c ,
                             xcb_xfixes_region_t source1 ,
                             xcb_xfixes_region_t source2 ,
                             xcb_xfixes_region_t destination );
xcb_void_cookie_t
xcb_xfixes_subtract_region_checked (xcb_connection_t *c ,
                                    xcb_xfixes_region_t source1 ,
                                    xcb_xfixes_region_t source2 ,
                                    xcb_xfixes_region_t destination );
xcb_void_cookie_t
xcb_xfixes_subtract_region (xcb_connection_t *c ,
                            xcb_xfixes_region_t source1 ,
                            xcb_xfixes_region_t source2 ,
                            xcb_xfixes_region_t destination );
xcb_void_cookie_t
xcb_xfixes_invert_region_checked (xcb_connection_t *c ,
                                  xcb_xfixes_region_t source ,
                                  xcb_rectangle_t bounds ,
                                  xcb_xfixes_region_t destination );
xcb_void_cookie_t
xcb_xfixes_invert_region (xcb_connection_t *c ,
                          xcb_xfixes_region_t source ,
                          xcb_rectangle_t bounds ,
                          xcb_xfixes_region_t destination );
xcb_void_cookie_t
xcb_xfixes_translate_region_checked (xcb_connection_t *c ,
                                     xcb_xfixes_region_t region ,
                                     int16_t dx ,
                                     int16_t dy );
xcb_void_cookie_t
xcb_xfixes_translate_region (xcb_connection_t *c ,
                             xcb_xfixes_region_t region ,
                             int16_t dx ,
                             int16_t dy );
xcb_void_cookie_t
xcb_xfixes_region_extents_checked (xcb_connection_t *c ,
                                   xcb_xfixes_region_t source ,
                                   xcb_xfixes_region_t destination );
xcb_void_cookie_t
xcb_xfixes_region_extents (xcb_connection_t *c ,
                           xcb_xfixes_region_t source ,
                           xcb_xfixes_region_t destination );
int
xcb_xfixes_fetch_region_sizeof (const void *_buffer );
xcb_xfixes_fetch_region_cookie_t
xcb_xfixes_fetch_region (xcb_connection_t *c ,
                         xcb_xfixes_region_t region );
xcb_xfixes_fetch_region_cookie_t
xcb_xfixes_fetch_region_unchecked (xcb_connection_t *c ,
                                   xcb_xfixes_region_t region );
xcb_rectangle_t *
xcb_xfixes_fetch_region_rectangles (const xcb_xfixes_fetch_region_reply_t *R );
int
xcb_xfixes_fetch_region_rectangles_length (const xcb_xfixes_fetch_region_reply_t *R );
xcb_rectangle_iterator_t
xcb_xfixes_fetch_region_rectangles_iterator (const xcb_xfixes_fetch_region_reply_t *R );
xcb_xfixes_fetch_region_reply_t *
xcb_xfixes_fetch_region_reply (xcb_connection_t *c ,
                               xcb_xfixes_fetch_region_cookie_t cookie ,
                               xcb_generic_error_t **e );
xcb_void_cookie_t
xcb_xfixes_set_gc_clip_region_checked (xcb_connection_t *c ,
                                       xcb_gcontext_t gc ,
                                       xcb_xfixes_region_t region ,
                                       int16_t x_origin ,
                                       int16_t y_origin );
xcb_void_cookie_t
xcb_xfixes_set_gc_clip_region (xcb_connection_t *c ,
                               xcb_gcontext_t gc ,
                               xcb_xfixes_region_t region ,
                               int16_t x_origin ,
                               int16_t y_origin );
xcb_void_cookie_t
xcb_xfixes_set_window_shape_region_checked (xcb_connection_t *c ,
                                            xcb_window_t dest ,
                                            xcb_shape_kind_t dest_kind ,
                                            int16_t x_offset ,
                                            int16_t y_offset ,
                                            xcb_xfixes_region_t region );
xcb_void_cookie_t
xcb_xfixes_set_window_shape_region (xcb_connection_t *c ,
                                    xcb_window_t dest ,
                                    xcb_shape_kind_t dest_kind ,
                                    int16_t x_offset ,
                                    int16_t y_offset ,
                                    xcb_xfixes_region_t region );
xcb_void_cookie_t
xcb_xfixes_set_picture_clip_region_checked (xcb_connection_t *c ,
                                            xcb_render_picture_t picture ,
                                            xcb_xfixes_region_t region ,
                                            int16_t x_origin ,
                                            int16_t y_origin );
xcb_void_cookie_t
xcb_xfixes_set_picture_clip_region (xcb_connection_t *c ,
                                    xcb_render_picture_t picture ,
                                    xcb_xfixes_region_t region ,
                                    int16_t x_origin ,
                                    int16_t y_origin );
int
xcb_xfixes_set_cursor_name_sizeof (const void *_buffer );
xcb_void_cookie_t
xcb_xfixes_set_cursor_name_checked (xcb_connection_t *c ,
                                    xcb_cursor_t cursor ,
                                    uint16_t nbytes ,
                                    const char *name );
xcb_void_cookie_t
xcb_xfixes_set_cursor_name (xcb_connection_t *c ,
                            xcb_cursor_t cursor ,
                            uint16_t nbytes ,
                            const char *name );
int
xcb_xfixes_get_cursor_name_sizeof (const void *_buffer );
xcb_xfixes_get_cursor_name_cookie_t
xcb_xfixes_get_cursor_name (xcb_connection_t *c ,
                            xcb_cursor_t cursor );
xcb_xfixes_get_cursor_name_cookie_t
xcb_xfixes_get_cursor_name_unchecked (xcb_connection_t *c ,
                                      xcb_cursor_t cursor );
char *
xcb_xfixes_get_cursor_name_name (const xcb_xfixes_get_cursor_name_reply_t *R );
int
xcb_xfixes_get_cursor_name_name_length (const xcb_xfixes_get_cursor_name_reply_t *R );
xcb_generic_iterator_t
xcb_xfixes_get_cursor_name_name_end (const xcb_xfixes_get_cursor_name_reply_t *R );
xcb_xfixes_get_cursor_name_reply_t *
xcb_xfixes_get_cursor_name_reply (xcb_connection_t *c ,
                                  xcb_xfixes_get_cursor_name_cookie_t cookie ,
                                  xcb_generic_error_t **e );
int
xcb_xfixes_get_cursor_image_and_name_sizeof (const void *_buffer );
xcb_xfixes_get_cursor_image_and_name_cookie_t
xcb_xfixes_get_cursor_image_and_name (xcb_connection_t *c );
xcb_xfixes_get_cursor_image_and_name_cookie_t
xcb_xfixes_get_cursor_image_and_name_unchecked (xcb_connection_t *c );
char *
xcb_xfixes_get_cursor_image_and_name_name (const xcb_xfixes_get_cursor_image_and_name_reply_t *R );
int
xcb_xfixes_get_cursor_image_and_name_name_length (const xcb_xfixes_get_cursor_image_and_name_reply_t *R );
xcb_generic_iterator_t
xcb_xfixes_get_cursor_image_and_name_name_end (const xcb_xfixes_get_cursor_image_and_name_reply_t *R );
uint32_t *
xcb_xfixes_get_cursor_image_and_name_cursor_image (const xcb_xfixes_get_cursor_image_and_name_reply_t *R );
int
xcb_xfixes_get_cursor_image_and_name_cursor_image_length (const xcb_xfixes_get_cursor_image_and_name_reply_t *R );
xcb_generic_iterator_t
xcb_xfixes_get_cursor_image_and_name_cursor_image_end (const xcb_xfixes_get_cursor_image_and_name_reply_t *R );
xcb_xfixes_get_cursor_image_and_name_reply_t *
xcb_xfixes_get_cursor_image_and_name_reply (xcb_connection_t *c ,
                                            xcb_xfixes_get_cursor_image_and_name_cookie_t cookie ,
                                            xcb_generic_error_t **e );
xcb_void_cookie_t
xcb_xfixes_change_cursor_checked (xcb_connection_t *c ,
                                  xcb_cursor_t source ,
                                  xcb_cursor_t destination );
xcb_void_cookie_t
xcb_xfixes_change_cursor (xcb_connection_t *c ,
                          xcb_cursor_t source ,
                          xcb_cursor_t destination );
int
xcb_xfixes_change_cursor_by_name_sizeof (const void *_buffer );
xcb_void_cookie_t
xcb_xfixes_change_cursor_by_name_checked (xcb_connection_t *c ,
                                          xcb_cursor_t src ,
                                          uint16_t nbytes ,
                                          const char *name );
xcb_void_cookie_t
xcb_xfixes_change_cursor_by_name (xcb_connection_t *c ,
                                  xcb_cursor_t src ,
                                  uint16_t nbytes ,
                                  const char *name );
xcb_void_cookie_t
xcb_xfixes_expand_region_checked (xcb_connection_t *c ,
                                  xcb_xfixes_region_t source ,
                                  xcb_xfixes_region_t destination ,
                                  uint16_t left ,
                                  uint16_t right ,
                                  uint16_t top ,
                                  uint16_t bottom );
xcb_void_cookie_t
xcb_xfixes_expand_region (xcb_connection_t *c ,
                          xcb_xfixes_region_t source ,
                          xcb_xfixes_region_t destination ,
                          uint16_t left ,
                          uint16_t right ,
                          uint16_t top ,
                          uint16_t bottom );
xcb_void_cookie_t
xcb_xfixes_hide_cursor_checked (xcb_connection_t *c ,
                                xcb_window_t window );
xcb_void_cookie_t
xcb_xfixes_hide_cursor (xcb_connection_t *c ,
                        xcb_window_t window );
xcb_void_cookie_t
xcb_xfixes_show_cursor_checked (xcb_connection_t *c ,
                                xcb_window_t window );
xcb_void_cookie_t
xcb_xfixes_show_cursor (xcb_connection_t *c ,
                        xcb_window_t window );
void
xcb_xfixes_barrier_next (xcb_xfixes_barrier_iterator_t *i );
xcb_generic_iterator_t
xcb_xfixes_barrier_end (xcb_xfixes_barrier_iterator_t i );
int
xcb_xfixes_create_pointer_barrier_sizeof (const void *_buffer );
xcb_void_cookie_t
xcb_xfixes_create_pointer_barrier_checked (xcb_connection_t *c ,
                                           xcb_xfixes_barrier_t barrier ,
                                           xcb_window_t window ,
                                           uint16_t x1 ,
                                           uint16_t y1 ,
                                           uint16_t x2 ,
                                           uint16_t y2 ,
                                           uint32_t directions ,
                                           uint16_t num_devices ,
                                           const uint16_t *devices );
xcb_void_cookie_t
xcb_xfixes_create_pointer_barrier (xcb_connection_t *c ,
                                   xcb_xfixes_barrier_t barrier ,
                                   xcb_window_t window ,
                                   uint16_t x1 ,
                                   uint16_t y1 ,
                                   uint16_t x2 ,
                                   uint16_t y2 ,
                                   uint32_t directions ,
                                   uint16_t num_devices ,
                                   const uint16_t *devices );
xcb_void_cookie_t
xcb_xfixes_delete_pointer_barrier_checked (xcb_connection_t *c ,
                                           xcb_xfixes_barrier_t barrier );
xcb_void_cookie_t
xcb_xfixes_delete_pointer_barrier (xcb_connection_t *c ,
                                   xcb_xfixes_barrier_t barrier );
]]
