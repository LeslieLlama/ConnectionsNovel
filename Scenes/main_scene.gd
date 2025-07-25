extends Control

const DIALOGUE_SCENE = preload("res://Scenes/dialogue_scene.tscn")

@export var test_encounter: Encounter

func _ready() -> void:
	do_encounter(test_encounter)

func do_encounter(encounter: Encounter):
	var dialogue_scene = DIALOGUE_SCENE.instantiate()
	add_child(dialogue_scene)
	await dialogue_scene.do_encounter(encounter)
	dialogue_scene.queue_free()
