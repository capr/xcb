--xcb/shm.h from libxcb-shm0 package v1.10-2ubuntu1 from ubuntu 14

local ffi = require'ffi'
require'xcb_h'

ffi.cdef[[
enum {
	XCB_SHM_MAJOR_VERSION = 1,
	XCB_SHM_MINOR_VERSION = 2,
};
extern xcb_extension_t xcb_shm_id;
typedef uint32_t xcb_shm_seg_t;
typedef struct xcb_shm_seg_iterator_t {
    xcb_shm_seg_t *data;
    int rem;
    int index;
} xcb_shm_seg_iterator_t;
enum {
	XCB_SHM_COMPLETION   = 0,
};
typedef struct xcb_shm_completion_event_t {
    uint8_t response_type;
    uint8_t pad0;
    uint16_t sequence;
    xcb_drawable_t drawable;
    uint16_t minor_event;
    uint8_t major_event;
    uint8_t pad1;
    xcb_shm_seg_t shmseg;
    uint32_t offset;
} xcb_shm_completion_event_t;
enum {
	XCB_SHM_BAD_SEG      = 0,
};
typedef xcb_value_error_t xcb_shm_bad_seg_error_t;
typedef struct xcb_shm_query_version_cookie_t {
    unsigned int sequence;
} xcb_shm_query_version_cookie_t;
enum {
	XCB_SHM_QUERY_VERSION = 0,
};
typedef struct xcb_shm_query_version_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
} xcb_shm_query_version_request_t;
typedef struct xcb_shm_query_version_reply_t {
    uint8_t response_type;
    uint8_t shared_pixmaps;
    uint16_t sequence;
    uint32_t length;
    uint16_t major_version;
    uint16_t minor_version;
    uint16_t uid;
    uint16_t gid;
    uint8_t pixmap_format;
    uint8_t pad0[15];
} xcb_shm_query_version_reply_t;
enum {
	XCB_SHM_ATTACH       = 1,
};
typedef struct xcb_shm_attach_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_shm_seg_t shmseg;
    uint32_t shmid;
    uint8_t read_only;
    uint8_t pad0[3];
} xcb_shm_attach_request_t;
enum {
	XCB_SHM_DETACH       = 2,
};
typedef struct xcb_shm_detach_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_shm_seg_t shmseg;
} xcb_shm_detach_request_t;
enum {
	XCB_SHM_PUT_IMAGE    = 3,
};
typedef struct xcb_shm_put_image_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_drawable_t drawable;
    xcb_gcontext_t gc;
    uint16_t total_width;
    uint16_t total_height;
    uint16_t src_x;
    uint16_t src_y;
    uint16_t src_width;
    uint16_t src_height;
    int16_t dst_x;
    int16_t dst_y;
    uint8_t depth;
    uint8_t format;
    uint8_t send_event;
    uint8_t pad0;
    xcb_shm_seg_t shmseg;
    uint32_t offset;
} xcb_shm_put_image_request_t;
typedef struct xcb_shm_get_image_cookie_t {
    unsigned int sequence;
} xcb_shm_get_image_cookie_t;
enum {
	XCB_SHM_GET_IMAGE    = 4,
};
typedef struct xcb_shm_get_image_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_drawable_t drawable;
    int16_t x;
    int16_t y;
    uint16_t width;
    uint16_t height;
    uint32_t plane_mask;
    uint8_t format;
    uint8_t pad0[3];
    xcb_shm_seg_t shmseg;
    uint32_t offset;
} xcb_shm_get_image_request_t;
typedef struct xcb_shm_get_image_reply_t {
    uint8_t response_type;
    uint8_t depth;
    uint16_t sequence;
    uint32_t length;
    xcb_visualid_t visual;
    uint32_t size;
} xcb_shm_get_image_reply_t;
enum {
	XCB_SHM_CREATE_PIXMAP = 5,
};
typedef struct xcb_shm_create_pixmap_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_pixmap_t pid;
    xcb_drawable_t drawable;
    uint16_t width;
    uint16_t height;
    uint8_t depth;
    uint8_t pad0[3];
    xcb_shm_seg_t shmseg;
    uint32_t offset;
} xcb_shm_create_pixmap_request_t;
enum {
	XCB_SHM_ATTACH_FD    = 6,
};
typedef struct xcb_shm_attach_fd_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_shm_seg_t shmseg;
    uint8_t read_only;
    uint8_t pad0[3];
} xcb_shm_attach_fd_request_t;
typedef struct xcb_shm_create_segment_cookie_t {
    unsigned int sequence;
} xcb_shm_create_segment_cookie_t;
enum {
	XCB_SHM_CREATE_SEGMENT = 7,
};
typedef struct xcb_shm_create_segment_request_t {
    uint8_t major_opcode;
    uint8_t minor_opcode;
    uint16_t length;
    xcb_shm_seg_t shmseg;
    uint32_t size;
    uint8_t read_only;
    uint8_t pad0[3];
} xcb_shm_create_segment_request_t;
typedef struct xcb_shm_create_segment_reply_t {
    uint8_t response_type;
    uint8_t nfd;
    uint16_t sequence;
    uint32_t length;
    uint8_t pad0[24];
} xcb_shm_create_segment_reply_t;
void
xcb_shm_seg_next (xcb_shm_seg_iterator_t *i );
xcb_generic_iterator_t
xcb_shm_seg_end (xcb_shm_seg_iterator_t i );
xcb_shm_query_version_cookie_t
xcb_shm_query_version (xcb_connection_t *c );
xcb_shm_query_version_cookie_t
xcb_shm_query_version_unchecked (xcb_connection_t *c );
xcb_shm_query_version_reply_t *
xcb_shm_query_version_reply (xcb_connection_t *c ,
                             xcb_shm_query_version_cookie_t cookie ,
                             xcb_generic_error_t **e );
xcb_void_cookie_t
xcb_shm_attach_checked (xcb_connection_t *c ,
                        xcb_shm_seg_t shmseg ,
                        uint32_t shmid ,
                        uint8_t read_only );
xcb_void_cookie_t
xcb_shm_attach (xcb_connection_t *c ,
                xcb_shm_seg_t shmseg ,
                uint32_t shmid ,
                uint8_t read_only );
xcb_void_cookie_t
xcb_shm_detach_checked (xcb_connection_t *c ,
                        xcb_shm_seg_t shmseg );
xcb_void_cookie_t
xcb_shm_detach (xcb_connection_t *c ,
                xcb_shm_seg_t shmseg );
xcb_void_cookie_t
xcb_shm_put_image_checked (xcb_connection_t *c ,
                           xcb_drawable_t drawable ,
                           xcb_gcontext_t gc ,
                           uint16_t total_width ,
                           uint16_t total_height ,
                           uint16_t src_x ,
                           uint16_t src_y ,
                           uint16_t src_width ,
                           uint16_t src_height ,
                           int16_t dst_x ,
                           int16_t dst_y ,
                           uint8_t depth ,
                           uint8_t format ,
                           uint8_t send_event ,
                           xcb_shm_seg_t shmseg ,
                           uint32_t offset );
xcb_void_cookie_t
xcb_shm_put_image (xcb_connection_t *c ,
                   xcb_drawable_t drawable ,
                   xcb_gcontext_t gc ,
                   uint16_t total_width ,
                   uint16_t total_height ,
                   uint16_t src_x ,
                   uint16_t src_y ,
                   uint16_t src_width ,
                   uint16_t src_height ,
                   int16_t dst_x ,
                   int16_t dst_y ,
                   uint8_t depth ,
                   uint8_t format ,
                   uint8_t send_event ,
                   xcb_shm_seg_t shmseg ,
                   uint32_t offset );
xcb_shm_get_image_cookie_t
xcb_shm_get_image (xcb_connection_t *c ,
                   xcb_drawable_t drawable ,
                   int16_t x ,
                   int16_t y ,
                   uint16_t width ,
                   uint16_t height ,
                   uint32_t plane_mask ,
                   uint8_t format ,
                   xcb_shm_seg_t shmseg ,
                   uint32_t offset );
xcb_shm_get_image_cookie_t
xcb_shm_get_image_unchecked (xcb_connection_t *c ,
                             xcb_drawable_t drawable ,
                             int16_t x ,
                             int16_t y ,
                             uint16_t width ,
                             uint16_t height ,
                             uint32_t plane_mask ,
                             uint8_t format ,
                             xcb_shm_seg_t shmseg ,
                             uint32_t offset );
xcb_shm_get_image_reply_t *
xcb_shm_get_image_reply (xcb_connection_t *c ,
                         xcb_shm_get_image_cookie_t cookie ,
                         xcb_generic_error_t **e );
xcb_void_cookie_t
xcb_shm_create_pixmap_checked (xcb_connection_t *c ,
                               xcb_pixmap_t pid ,
                               xcb_drawable_t drawable ,
                               uint16_t width ,
                               uint16_t height ,
                               uint8_t depth ,
                               xcb_shm_seg_t shmseg ,
                               uint32_t offset );
xcb_void_cookie_t
xcb_shm_create_pixmap (xcb_connection_t *c ,
                       xcb_pixmap_t pid ,
                       xcb_drawable_t drawable ,
                       uint16_t width ,
                       uint16_t height ,
                       uint8_t depth ,
                       xcb_shm_seg_t shmseg ,
                       uint32_t offset );
xcb_void_cookie_t
xcb_shm_attach_fd_checked (xcb_connection_t *c ,
                           xcb_shm_seg_t shmseg ,
                           int32_t shm_fd ,
                           uint8_t read_only );
xcb_void_cookie_t
xcb_shm_attach_fd (xcb_connection_t *c ,
                   xcb_shm_seg_t shmseg ,
                   int32_t shm_fd ,
                   uint8_t read_only );
xcb_shm_create_segment_cookie_t
xcb_shm_create_segment (xcb_connection_t *c ,
                        xcb_shm_seg_t shmseg ,
                        uint32_t size ,
                        uint8_t read_only );
xcb_shm_create_segment_cookie_t
xcb_shm_create_segment_unchecked (xcb_connection_t *c ,
                                  xcb_shm_seg_t shmseg ,
                                  uint32_t size ,
                                  uint8_t read_only );
xcb_shm_create_segment_reply_t *
xcb_shm_create_segment_reply (xcb_connection_t *c ,
                              xcb_shm_create_segment_cookie_t cookie ,
                              xcb_generic_error_t **e );
int *
xcb_shm_create_segment_reply_fds (xcb_connection_t *c ,
                                  xcb_shm_create_segment_reply_t *reply );
]]
