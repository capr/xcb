--xcb/xcb_image.h from libxcb-image0-dev package v0.3.9-1ubuntu2 from ubuntu 14

local ffi = require'ffi'
require'xcb_h'
require'xcb_shm_h'

ffi.cdef[[
typedef struct xcb_image_t xcb_image_t;
struct xcb_image_t
{
  uint16_t width;
  uint16_t height;
  xcb_image_format_t format;
  uint8_t scanline_pad;
  uint8_t depth;
  uint8_t bpp;
  uint8_t unit;
  uint32_t plane_mask;
  xcb_image_order_t byte_order;
  xcb_image_order_t bit_order;
  uint32_t stride;
  uint32_t size;
  void * base;
  uint8_t * data;
};
typedef struct xcb_shm_segment_info_t xcb_shm_segment_info_t;
struct xcb_shm_segment_info_t
{
  xcb_shm_seg_t shmseg;
  uint32_t shmid;
  uint8_t *shmaddr;
};
void
xcb_image_annotate (xcb_image_t *image);
xcb_image_t *
xcb_image_create (uint16_t width,
    uint16_t height,
    xcb_image_format_t format,
    uint8_t xpad,
    uint8_t depth,
    uint8_t bpp,
    uint8_t unit,
    xcb_image_order_t byte_order,
    xcb_image_order_t bit_order,
    void * base,
    uint32_t bytes,
    uint8_t * data);
xcb_image_t *
xcb_image_create_native (xcb_connection_t * c,
    uint16_t width,
    uint16_t height,
    xcb_image_format_t format,
    uint8_t depth,
    void * base,
    uint32_t bytes,
    uint8_t * data);
void
xcb_image_destroy (xcb_image_t *image);
xcb_image_t *
xcb_image_get (xcb_connection_t * conn,
        xcb_drawable_t draw,
        int16_t x,
        int16_t y,
        uint16_t width,
        uint16_t height,
        uint32_t plane_mask,
        xcb_image_format_t format);
xcb_void_cookie_t
xcb_image_put (xcb_connection_t * conn,
        xcb_drawable_t draw,
        xcb_gcontext_t gc,
        xcb_image_t * image,
        int16_t x,
        int16_t y,
        uint8_t left_pad);
xcb_image_t *
xcb_image_native (xcb_connection_t * c,
    xcb_image_t * image,
    int convert);
void
xcb_image_put_pixel (xcb_image_t *image,
       uint32_t x,
       uint32_t y,
       uint32_t pixel);
uint32_t
xcb_image_get_pixel (xcb_image_t *image,
       uint32_t x,
       uint32_t y);
xcb_image_t *
xcb_image_convert (xcb_image_t * src,
     xcb_image_t * dst);
xcb_image_t *
xcb_image_subimage(xcb_image_t * image,
     uint32_t x,
     uint32_t y,
     uint32_t width,
     uint32_t height,
     void * base,
     uint32_t bytes,
     uint8_t * data);
xcb_image_t *
xcb_image_shm_put (xcb_connection_t * conn,
     xcb_drawable_t draw,
     xcb_gcontext_t gc,
     xcb_image_t * image,
     xcb_shm_segment_info_t shminfo,
     int16_t src_x,
     int16_t src_y,
     int16_t dest_x,
     int16_t dest_y,
     uint16_t src_width,
     uint16_t src_height,
     uint8_t send_event);
int xcb_image_shm_get (xcb_connection_t * conn,
         xcb_drawable_t draw,
         xcb_image_t * image,
         xcb_shm_segment_info_t shminfo,
         int16_t x,
         int16_t y,
         uint32_t plane_mask);
xcb_image_t *
xcb_image_create_from_bitmap_data (uint8_t * data,
       uint32_t width,
       uint32_t height);
xcb_pixmap_t
xcb_create_pixmap_from_bitmap_data (xcb_connection_t * display,
        xcb_drawable_t d,
        uint8_t * data,
        uint32_t width,
        uint32_t height,
        uint32_t depth,
        uint32_t fg,
        uint32_t bg,
        xcb_gcontext_t * gcp);
]]
