import pixel_splatter/internal/wx_bindings as wx
import pixel_splatter/window

pub opaque type Canvas {
  Canvas(image: wx.Image)
}

pub fn new(data: BitArray, width_height: #(Int, Int)) -> Canvas {
  wx.new()
  Canvas(wx.image_new(width_height.0, width_height.1, data))
}

pub fn paint(canvas: Canvas, painter: window.Painter, position: #(Int, Int)) {
  wx.dc_draw_bitmap(
    window.painter_dc(painter),
    wx.bitmap_new(canvas.image),
    position,
  )
}
