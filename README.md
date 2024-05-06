# pixel_splatter

[![Package Version](https://img.shields.io/hexpm/v/pixel_splatter)](https://hex.pm/packages/pixel_splatter)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/pixel_splatter/)

A very simple gleam library to create windows and draw pixels for the erlang target.

```sh
gleam add pixel_splatter
```

```gleam
import gleam/bytes_builder
import gleam/erlang/process
import gleam/iterator
import pixel_splatter/canvas
import pixel_splatter/window

pub fn main() {
  let size = #(1024, 512)
  let colours =
    {
      let width_range = iterator.range(from: 0, to: size.0 - 1)
      let height_range = iterator.range(from: 0, to: size.1 - 1)
      use y <- iterator.flat_map(height_range)
      use x <- iterator.map(width_range)
      let r = x % 256
      let g = y % 256
      <<r, g, 255>>
    }
    |> iterator.to_list
    |> bytes_builder.concat_bit_arrays
    |> bytes_builder.to_bit_array
  let my_canvas = canvas.new(colours, size)

  let assert Ok(my_window) =
    window.new("Example Title")
    |> window.handler_connect_selector_blocking(window.Destroy)
    |> window.handler_connect_selector(window.Create)
    |> window.handler_connect_selector(window.Paint)
    |> window.handler_connect_painter(fn(painter: window.Painter) {
      canvas.paint(my_canvas, painter, #(0, 0))
    })
    |> window.show

  loop(my_window)
}

fn loop(my_window: window.Window) -> Nil {
  case
    my_window
    |> window.selector
    |> process.select_forever
  {
    window.Destroy -> Nil
    _ -> loop(my_window)
  }
}
```

Further documentation can be found at <https://hexdocs.pm/pixel_splatter>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
gleam shell # Run an Erlang shell
```
