# HTTP Util GD
HTTP utilies for Godot 3.x.

## HTTP Server
An HTTP server that can be configured declaratively or imperatively.

### Examples

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
