extends Label

func update_disconnect_screen(player_index: int) -> void:
	text = "Controller {i} Diconnected...\nReconnect to continue".format({"i": player_index + 1})
