extends Control
@onready var start_button: Button = %StartButton

const MAIN_SCENE = preload("res://Scenes/main_scene.tscn")

func _on_start_button_pressed() -> void:
	start_button.hide()
	var main_scene = MAIN_SCENE.instantiate()
	add_child(main_scene)
	
	await main_scene.game_completed
	
	main_scene.queue_free()
	start_button.show()
