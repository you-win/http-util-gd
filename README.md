# HTTP Util GD
HTTP utilities for Godot 3.x.

Provided utilities:
* [HTTP Server](#http-server)
* [HTTP Request Builder](#http-request-builder)
* [Server Sent Events](#server-sent-events)

See `demo.tscn` for an example of most utilities.

## HTTP Server
An HTTP server that can be configured declaratively or imperatively.

### Example

Declarative
```GDScript
const HttpUtil = preload("path/to/http_util.gd")

var server

func _init() -> void:
	server = HttpUtil.Server.new({
		"routes": {
			"/": {
				"handler": self,
				"method": "index"
			},
			"/complex": {
				"handler": self,
				"method": "complex",
				"args": [
					true
				],
				"options": {
					# Route-specific options
				}
			}
		},
		"options": {
			# Optional options that apply to all routes
		}
	})
	
	server.start(9000)

func index(response: Dictionary) -> int:
	response.body = "simple response"

	return OK

func complex(response: Dictionary, my_arg):
	response.body = {
		"message": "hello world",
		"other": 1
	}
	
	if my_arg:
		print("we passed an arg!")

	return OK
```

Imperative
```GDScript
const HttpUtil = preload("path/to/http_util.gd")

var server

func _init() -> void:
	server = HttpUtil.Server.new()
	
	server.add_route("/").handler(self).method("hello").build()
	
	server.start(9000)
	
func hello(response):
	response.body = "hello world"

	return OK
```

## HTTP Request Builder
A REST request helper that exists as a `Reference`, not as a `Node`. Requests are constructed via a builder pattern.

### Example

```GDScript
const HttpUtil = preload("path/to/http_util.gd")

func _init() -> void:
	var request := HttpUtil.HttpRequestBuilder.create("www.google.com") \
		.as_get() \
		.default_user_agent() \
		.default_accept_all() \
		.build()
	
	var response = yield(request.send(), "completed")
	
	print(response) # Prints the HTML of www.google.com + headers and the response code
```

## Server Sent Events
An implementation of [Server Sent Events](https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events). Uses Godot's `WebSocketClient` internally.
Needs to be manually polled.

### Example

```GDScript
const HttpUtil = preload("path/to/http_util.gd")

var client

func _init() -> void:
	client = HttpUtil.SSE.new("my_host", {
		"with_credentials": false,
		"newline_type": SSE.NewlineType.LF
	})
	
	subscribe()
	subscribe_to_event()

func _process(delta: float) -> void:
	client.poll()

# Subscribe to all events
func subscribe():
	client.connect("message", self, "_on_message")

# Subscribe to messages to contain a specific event
func subscribe_to_event():
	client.add_event_listener("my_event", self, "_my_event_callback")

func _on_message(message: SSE.ServerSideEvent) -> void:
	print(message.data)

func _my_event_callback(message: SSE.ServerSideEvent):
	print(message.data)
```

## Known issues
- [x] Sending [Postman](https://www.postman.com/) requests against the [HTTP Server](#http-server) will cause the server to hang
  - Postman sends 2 request: an empty request and the actual request. Max retries implemented to abort parsing a request if no data is found in time
