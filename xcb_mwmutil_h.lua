--https://github.com/GNOME/gtk/blob/master/gdk/x11/MwmUtil.h

local ffi = require'ffi'

ffi.cdef[[

// _MOTIF_WM_HINTS property
// these are int32s, not longs like you find on the net!
typedef struct {
	unsigned int flags;
	unsigned int functions;
	unsigned int decorations;
	int input_mode;
	unsigned int status;
} MotifWmHints;

enum {
	MOTIF_WM_HINTS_ELEMENTS = 5,
	MWM_HINTS_FUNCTIONS     = (1 << 0),
	MWM_HINTS_DECORATIONS   = (1 << 1),
	MWM_HINTS_INPUT_MODE    = (1 << 2),
	MWM_HINTS_STATUS        = (1 << 3),
	MWM_FUNC_ALL            = (1 << 0),
	MWM_FUNC_RESIZE         = (1 << 1),
	MWM_FUNC_MOVE           = (1 << 2),
	MWM_FUNC_MINIMIZE       = (1 << 3),
	MWM_FUNC_MAXIMIZE       = (1 << 4),
	MWM_FUNC_CLOSE          = (1 << 5),
	MWM_DECOR_ALL           = (1 << 0),
	MWM_DECOR_BORDER        = (1 << 1),
	MWM_DECOR_RESIZEH       = (1 << 2),
	MWM_DECOR_TITLE         = (1 << 3),
	MWM_DECOR_MENU          = (1 << 4),
	MWM_DECOR_MINIMIZE      = (1 << 5),
	MWM_DECOR_MAXIMIZE      = (1 << 6),
	MWM_INPUT_MODELESS                  = 0,
	MWM_INPUT_PRIMARY_APPLICATION_MODAL = 1,
	MWM_INPUT_SYSTEM_MODAL              = 2,
	MWM_INPUT_FULL_APPLICATION_MODAL    = 3,
	MWM_INPUT_APPLICATION_MODAL         = 1,
	MWM_TEAROFF_WINDOW      = (1 << 0),
};
]]
