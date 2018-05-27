date_format = '%Y-%m-%dT%H:%M:%S'

json.id event.id
json.title event.title
json.start event.start.strftime(date_format)
json.end event.end.strftime(date_format)

json.color event.color unless event.color.blank?

json.update_url event_path(event, method: :patch)
json.edit_url edit_event_path(event)