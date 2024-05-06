import gleam/erlang/process.{type Subject}
import pixel_splatter/internal/util
import pixel_splatter/internal/wx_bindings as wx

pub type WindowEventType {
  Create
  Destroy
  Paint
}

pub opaque type Painter {
  Painter(dc: wx.PaintDC)
}

pub opaque type Window {
  Window(
    parent_subject: Subject(#(WindowEventType, Subject(Nil))),
    frame: wx.Frame,
  )
}

pub fn new(title: String) -> Window {
  wx.new()
  Window(process.new_subject(), wx.frame_new(wx.null(), -1, title))
}

pub fn selector(this: Window) {
  process.new_selector()
  |> process.selecting(this.parent_subject, fn(a) {
    process.send(a.1, Nil)
    a.0
  })
}

pub fn show(this: Window) -> Result(Window, Nil) {
  case wx.show_window(this.frame) {
    True -> Ok(this)
    False -> Error(Nil)
  }
}

pub fn refresh(window: Window) {
  wx.window_refresh(window.frame)
}

fn to_wx_event_type(event: WindowEventType) {
  case event {
    Create -> wx.Create
    Destroy -> wx.Destroy
    Paint -> wx.Paint
  }
}

pub fn handler_connect_selector_blocking(
  this: Window,
  event: WindowEventType,
) -> Window {
  wx.evt_handler_connect(this.frame, to_wx_event_type(event), [
    wx.Callback(fn(_, _) {
      util.call_forever(this.parent_subject, fn(reply_subject) {
        #(event, reply_subject)
      })
    }),
  ])
  this
}

pub fn handler_connect_selector(this: Window, event: WindowEventType) -> Window {
  wx.evt_handler_connect(this.frame, to_wx_event_type(event), [
    wx.Callback(fn(_, _) {
      process.send(this.parent_subject, #(event, process.new_subject()))
    }),
  ])
  this
}

pub fn handler_connect_painter(
  this: Window,
  handler: fn(Painter) -> Nil,
) -> Window {
  wx.evt_handler_connect(this.frame, to_wx_event_type(Paint), [
    wx.Callback(fn(_, _) { handler(Painter(wx.paint_dc_new(this.frame))) }),
  ])
  this
}

// pub fn handler_disconnect() {}

@internal
pub fn painter_dc(painter: Painter) {
  painter.dc
}
