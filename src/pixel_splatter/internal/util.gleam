import gleam/erlang/process.{type Subject}

pub fn call_forever(
  subject: Subject(request),
  make_request: fn(Subject(response)) -> request,
) -> response {
  let reply_subject = process.new_subject()
  let monitor = process.monitor_process(process.subject_owner(subject))

  process.send(subject, make_request(reply_subject))

  let assert Ok(result) =
    process.new_selector()
    |> process.selecting(reply_subject, Ok)
    |> process.selecting_process_down(monitor, fn(_) { Error(Nil) })
    |> process.select_forever()

  process.demonitor_process(monitor)
  result
}
