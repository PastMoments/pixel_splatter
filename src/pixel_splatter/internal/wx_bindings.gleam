pub type EventType {
  Create
  Destroy
  Paint
}

type Object(derived) =
  derived

// WxObject
type EvtHandler(derived) =
  derived

// WxEventHandler
type Window(derived) =
  derived

// WxWindow
pub type Frame

// WxObject
type DC(derived) =
  derived

// WxDC
pub type PaintDC

// WxObject
pub type Image

// WxObject
pub type Bitmap

@external(erlang, "wx", "new")
pub fn new() -> Nil

@external(erlang, "wxFrame", "new")
pub fn frame_new(parent: Object(Nil), id: Int, title: String) -> Frame

@external(erlang, "wxWindow", "show")
pub fn show_window(this: Window(Frame)) -> Bool

@external(erlang, "wxWindow", "refresh")
pub fn window_refresh(this: Window(Frame)) -> Nil

@external(erlang, "wx", "null")
pub fn null() -> Object(Nil)

pub type HandlerOption {
  //Id(id: Int)
  //Skip(bool: Bool)
  Callback(func: fn(Nil, Nil) -> Nil)
}

@external(erlang, "wxPaintDC", "new")
pub fn paint_dc_new(this: Window(Frame)) -> PaintDC

@external(erlang, "wxImage", "new")
pub fn image_new(width: Int, height: Int, data: BitArray) -> Image

@external(erlang, "wxDC", "drawBitmap")
pub fn dc_draw_bitmap(dc: DC(PaintDC), bitmap: Bitmap, pt: #(Int, Int)) -> Nil

@external(erlang, "wxBitmap", "new")
pub fn bitmap_new(img: Image) -> Bitmap

@external(erlang, "wxEvtHandler", "connect")
pub fn evt_handler_connect(
  this: EvtHandler(Frame),
  event_type: EventType,
  options: List(HandlerOption),
) -> Nil
// @external(erlang, "wxEvtHandler", "disconnect")
// fn evt_handler_disconnect(
//   this: EvtHandler(Frame),
//   event_type: EventType,
//   options: List(HandlerOption),
// ) -> Bool
