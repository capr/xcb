--xcb/shape.h from libxcb-shape0-dev package v1.10-2ubuntu1 from ubuntu 14

local ffi = require'ffi'
require'xcb_h'

ffi.cdef[[
// xcb/shape.h
enum {
	XCB_SHAPE_MAJOR_VERSION = 1,
	XCB_SHAPE_MINOR_VERSION = 1,
};
extern xcb_extension_t xcb_shape_id;
typedef uint8_t xcb_shape_op_t;
typedef struct xcb_shape_op_iterator_t {
    xcb_shape_op_t *data;
    int rem;
    int index;
} xcb_shape_op_iterator_t;
typedef uint8_t xcb_shape_kind_t;
typedef struct xcb_shape_kind_iterator_t {
    xcb_shape_kind_t *data;
    int rem;
    int index;
} xcb_shape_kind_iterator_t;
typedef enum xcb_shape_so_t {
    XCB_SHAPE_SO_SET = 0,
    XCB_SHAPE_SO_UNION = 1,
    XCB_SHAPE_SO_INTERSECT = 2,
    XCB_SHAPE_SO_SUBTRACT = 3,
    XCB_SHAPE_SO_INVERT = 4
} xcb_shape_so_t;
typedef enum xcb_shape_sk_t {
    XCB_SHAPE_SK_BOUNDING = 0,
    XCB_SHAPE_SK_CLIP = 1,
    XCB_SHAPE_SK_INPUT = 2
} xcb_shape_sk_t;
enum {
	XCB_SHAPE_NOTIFY     = 0,
};
typedef struct xcb_shape_notify_event_t {
    uint8_t response_type;
    xcb_shape_kind_t shape_kind;
    uint16_t sequence;
    xcb_window_t affected_window;
    int16_t extents_x;
    int16_t extents_y;
    uint16_t extents_width;
    uint16_t extents_height;
    xcb_timestamp_t server_time;
    uint8_t shaped;
    uint8_t pad0[11];
} xcb_shape_notify_event_t;
typedef struct xcb_shape_query_version_cookie_t {
    unsigned int sequence;
} xcb_shape_query_version_cookie_t;
enum {
	XCB_SHAPE_QUERY_VERSION = 0,
};
typedef struct xcb_shape_query_version_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
} xcb_shape_query_version_request_t;
typedef struct xcb_shape_query_version_reply_t {
    uint8_t response_type;
    uint8_t pad0;
    uint16_t sequence;
    uint32_t length;
    uint16_t major_version;
    uint16_t minor_version;
} xcb_shape_query_version_reply_t;
enum {
	XCB_SHAPE_RECTANGLES = 1,
};
typedef struct xcb_shape_rectangles_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_shape_op_t operation;
    xcb_shape_kind_t destination_kind;
    uint8_t ordering;
    uint8_t pad0;
    xcb_window_t destination_window;
    int16_t x_offset;
    int16_t y_offset;
} xcb_shape_rectangles_request_t;
enum {
	XCB_SHAPE_MASK       = 2,
};
typedef struct xcb_shape_mask_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_shape_op_t operation;
    xcb_shape_kind_t destination_kind;
    uint8_t pad0[2];
    xcb_window_t destination_window;
    int16_t x_offset;
    int16_t y_offset;
    xcb_pixmap_t source_bitmap;
} xcb_shape_mask_request_t;
enum {
	XCB_SHAPE_COMBINE    = 3,
};
typedef struct xcb_shape_combine_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_shape_op_t operation;
    xcb_shape_kind_t destination_kind;
    xcb_shape_kind_t source_kind;
    uint8_t pad0;
    xcb_window_t destination_window;
    int16_t x_offset;
    int16_t y_offset;
    xcb_window_t source_window;
} xcb_shape_combine_request_t;
enum {
	XCB_SHAPE_OFFSET     = 4,
};
typedef struct xcb_shape_offset_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_shape_kind_t destination_kind;
    uint8_t pad0[3];
    xcb_window_t destination_window;
    int16_t x_offset;
    int16_t y_offset;
} xcb_shape_offset_request_t;
typedef struct xcb_shape_query_extents_cookie_t {
    unsigned int sequence;
} xcb_shape_query_extents_cookie_t;
enum {
	XCB_SHAPE_QUERY_EXTENTS = 5,
};
typedef struct xcb_shape_query_extents_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_window_t destination_window;
} xcb_shape_query_extents_request_t;
typedef struct xcb_shape_query_extents_reply_t {
    uint8_t response_type;
    uint8_t pad0;
    uint16_t sequence;
    uint32_t length;
    uint8_t bounding_shaped;
    uint8_t clip_shaped;
    uint8_t pad1[2];
    int16_t bounding_shape_extents_x;
    int16_t bounding_shape_extents_y;
    uint16_t bounding_shape_extents_width;
    uint16_t bounding_shape_extents_height;
    int16_t clip_shape_extents_x;
    int16_t clip_shape_extents_y;
    uint16_t clip_shape_extents_width;
    uint16_t clip_shape_extents_height;
} xcb_shape_query_extents_reply_t;
enum {
	XCB_SHAPE_SELECT_INPUT = 6,
};
typedef struct xcb_shape_select_input_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_window_t destination_window;
    uint8_t enable;
    uint8_t pad0[3];
} xcb_shape_select_input_request_t;
typedef struct xcb_shape_input_selected_cookie_t {
    unsigned int sequence;
} xcb_shape_input_selected_cookie_t;
enum {
	XCB_SHAPE_INPUT_SELECTED = 7,
};
typedef struct xcb_shape_input_selected_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_window_t destination_window;
} xcb_shape_input_selected_request_t;
typedef struct xcb_shape_input_selected_reply_t {
    uint8_t response_type;
    uint8_t enabled;
    uint16_t sequence;
    uint32_t length;
} xcb_shape_input_selected_reply_t;
typedef struct xcb_shape_get_rectangles_cookie_t {
    unsigned int sequence;
} xcb_shape_get_rectangles_cookie_t;
enum {
	XCB_SHAPE_GET_RECTANGLES = 8,
};
typedef struct xcb_shape_get_rectangles_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_window_t window;
    xcb_shape_kind_t source_kind;
    uint8_t pad0[3];
} xcb_shape_get_rectangles_request_t;
typedef struct xcb_shape_get_rectangles_reply_t {
    uint8_t response_type;
    uint8_t ordering;
    uint16_t sequence;
    uint32_t length;
    uint32_t rectangles_len;
    uint8_t pad0[20];
} xcb_shape_get_rectangles_reply_t;
void
xcb_shape_op_next (xcb_shape_op_iterator_t *i );
xcb_generic_iterator_t
xcb_shape_op_end (xcb_shape_op_iterator_t i );
void
xcb_shape_kind_next (xcb_shape_kind_iterator_t *i );
xcb_generic_iterator_t
xcb_shape_kind_end (xcb_shape_kind_iterator_t i );
xcb_shape_query_version_cookie_t
xcb_shape_query_version (xcb_connection_t *c );
xcb_shape_query_version_cookie_t
xcb_shape_query_version_unchecked (xcb_connection_t *c );
xcb_shape_query_version_reply_t *
xcb_shape_query_version_reply (xcb_connection_t *c ,
                               xcb_shape_query_version_cookie_t cookie ,
                               xcb_generic_error_t **e );
int
xcb_shape_rectangles_sizeof (const void *_buffer ,
                             uint32_t rectangles_len );
xcb_void_cookie_t
xcb_shape_rectangles_checked (xcb_connection_t *c ,
                              xcb_shape_op_t operation ,
                              xcb_shape_kind_t destination_kind ,
                              uint8_t ordering ,
                              xcb_window_t destination_window ,
                              int16_t x_offset ,
                              int16_t y_offset ,
                              uint32_t rectangles_len ,
                              const xcb_rectangle_t *rectangles );
xcb_void_cookie_t
xcb_shape_rectangles (xcb_connection_t *c ,
                      xcb_shape_op_t operation ,
                      xcb_shape_kind_t destination_kind ,
                      uint8_t ordering ,
                      xcb_window_t destination_window ,
                      int16_t x_offset ,
                      int16_t y_offset ,
                      uint32_t rectangles_len ,
                      const xcb_rectangle_t *rectangles );
xcb_void_cookie_t
xcb_shape_mask_checked (xcb_connection_t *c ,
                        xcb_shape_op_t operation ,
                        xcb_shape_kind_t destination_kind ,
                        xcb_window_t destination_window ,
                        int16_t x_offset ,
                        int16_t y_offset ,
                        xcb_pixmap_t source_bitmap );
xcb_void_cookie_t
xcb_shape_mask (xcb_connection_t *c ,
                xcb_shape_op_t operation ,
                xcb_shape_kind_t destination_kind ,
                xcb_window_t destination_window ,
                int16_t x_offset ,
                int16_t y_offset ,
                xcb_pixmap_t source_bitmap );
xcb_void_cookie_t
xcb_shape_combine_checked (xcb_connection_t *c ,
                           xcb_shape_op_t operation ,
                           xcb_shape_kind_t destination_kind ,
                           xcb_shape_kind_t source_kind ,
                           xcb_window_t destination_window ,
                           int16_t x_offset ,
                           int16_t y_offset ,
                           xcb_window_t source_window );
xcb_void_cookie_t
xcb_shape_combine (xcb_connection_t *c ,
                   xcb_shape_op_t operation ,
                   xcb_shape_kind_t destination_kind ,
                   xcb_shape_kind_t source_kind ,
                   xcb_window_t destination_window ,
                   int16_t x_offset ,
                   int16_t y_offset ,
                   xcb_window_t source_window );
xcb_void_cookie_t
xcb_shape_offset_checked (xcb_connection_t *c ,
                          xcb_shape_kind_t destination_kind ,
                          xcb_window_t destination_window ,
                          int16_t x_offset ,
                          int16_t y_offset );
xcb_void_cookie_t
xcb_shape_offset (xcb_connection_t *c ,
                  xcb_shape_kind_t destination_kind ,
                  xcb_window_t destination_window ,
                  int16_t x_offset ,
                  int16_t y_offset );
xcb_shape_query_extents_cookie_t
xcb_shape_query_extents (xcb_connection_t *c ,
                         xcb_window_t destination_window );
xcb_shape_query_extents_cookie_t
xcb_shape_query_extents_unchecked (xcb_connection_t *c ,
                                   xcb_window_t destination_window );
xcb_shape_query_extents_reply_t *
xcb_shape_query_extents_reply (xcb_connection_t *c ,
                               xcb_shape_query_extents_cookie_t cookie ,
                               xcb_generic_error_t **e );
xcb_void_cookie_t
xcb_shape_select_input_checked (xcb_connection_t *c ,
                                xcb_window_t destination_window ,
                                uint8_t enable );
xcb_void_cookie_t
xcb_shape_select_input (xcb_connection_t *c ,
                        xcb_window_t destination_window ,
                        uint8_t enable );
xcb_shape_input_selected_cookie_t
xcb_shape_input_selected (xcb_connection_t *c ,
                          xcb_window_t destination_window );
xcb_shape_input_selected_cookie_t
xcb_shape_input_selected_unchecked (xcb_connection_t *c ,
                                    xcb_window_t destination_window );
xcb_shape_input_selected_reply_t *
xcb_shape_input_selected_reply (xcb_connection_t *c ,
                                xcb_shape_input_selected_cookie_t cookie ,
                                xcb_generic_error_t **e );
int
xcb_shape_get_rectangles_sizeof (const void *_buffer );
xcb_shape_get_rectangles_cookie_t
xcb_shape_get_rectangles (xcb_connection_t *c ,
                          xcb_window_t window ,
                          xcb_shape_kind_t source_kind );
xcb_shape_get_rectangles_cookie_t
xcb_shape_get_rectangles_unchecked (xcb_connection_t *c ,
                                    xcb_window_t window ,
                                    xcb_shape_kind_t source_kind );
xcb_rectangle_t *
xcb_shape_get_rectangles_rectangles (const xcb_shape_get_rectangles_reply_t *R );
int
xcb_shape_get_rectangles_rectangles_length (const xcb_shape_get_rectangles_reply_t *R );
xcb_rectangle_iterator_t
xcb_shape_get_rectangles_rectangles_iterator (const xcb_shape_get_rectangles_reply_t *R );
xcb_shape_get_rectangles_reply_t *
xcb_shape_get_rectangles_reply (xcb_connection_t *c ,
                                xcb_shape_get_rectangles_cookie_t cookie ,
                                xcb_generic_error_t **e );
]]
