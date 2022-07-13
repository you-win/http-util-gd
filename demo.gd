extends CanvasLayer

const HttpUtil = preload("res://addons/http-util/http_util.gd")

var _server: HttpUtil.Server

#-----------------------------------------------------------------------------#
# Builtin functions                                                           #
#-----------------------------------------------------------------------------#

func _init() -> void:
	OS.center_window()
	
	_server = HttpUtil.Server.new({
		"routes": {
			"/": {
				"handler": self,
				"method": "default",
				"args": [
					"some arg"
				]
			},
			"/declarative": {
				"handler": self,
				"method": "hello_declarative",
				"options": {
					"pass_stream_peer": true,
					"can_return_null": true
				}
			}
		},
		"options": {
			
		}
	})
	_server.add_route("/imperative").handler(self).method("imperative_hello").build()
	
	_server.start(9999)

func _input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	
	event = event as InputEventMouseButton
	
	if event.pressed and event.button_index == BUTTON_LEFT:
		print("is_alive %s" % str(_server._server_thread.is_alive()))
		print("is_active %s" % str(_server._server_thread.is_active()))

func _exit_tree() -> void:
	_server.stop()

#-----------------------------------------------------------------------------#
# Connections                                                                 #
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Private functions                                                           #
#-----------------------------------------------------------------------------#

func default(response, something) -> int:
	print("index")
	print("my arg %s" % str(something))
	
	return OK

func hello_declarative(response, peer):
	print("hello declarative")
	print(peer.get_status())
	
	(peer as StreamPeerTCP).disconnect_from_host()

func imperative_hello(response: Dictionary) -> int:
	print("Hello imperative")
	
	response.body = "hello"
	
	return OK

#-----------------------------------------------------------------------------#
# Public functions                                                            #
#-----------------------------------------------------------------------------#
