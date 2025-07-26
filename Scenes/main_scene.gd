extends Control

const DIALOGUE_SCENE = preload("res://Scenes/dialogue_scene.tscn")
const MAP_SCENE = preload("res://Scenes/map_scene.tscn")
@onready var screen_fade: ColorRect = %ScreenFade
const SCREEN_FADE_TIME = 0.4

@export var intro_scene: Conversation
@export var encounters: EncounterList

func _ready() -> void:
	Inventory.clear()
	await do_intro_scene()
	for time_slot in encounters.encounters:
		var encounter = await show_map(time_slot)
		await do_encounter(encounter)

func do_intro_scene():
	var dialogue_scene = DIALOGUE_SCENE.instantiate()
	add_child(dialogue_scene)
	await dialogue_scene.display_conversation(intro_scene)
	await screen_transition()
	dialogue_scene.queue_free()

func do_encounter(encounter: Encounter):
	var dialogue_scene = DIALOGUE_SCENE.instantiate()
	add_child(dialogue_scene)
	await dialogue_scene.do_encounter(encounter)
	await screen_transition()
	dialogue_scene.queue_free()

func show_map(time_slot: TimeSlot) -> Encounter:
	var map_scene = MAP_SCENE.instantiate()
	add_child(map_scene)
	var encounter = await map_scene.display_encounter_choices(time_slot)
	await screen_transition()
	map_scene.queue_free()
	
	return encounter

func screen_transition():
	screen_fade.show()
	screen_fade.color.a = 0
	var tween = create_tween()
	tween.tween_property(screen_fade, "color:a", 1, SCREEN_FADE_TIME)
	
	await tween.finished
	
	tween = create_tween()
	tween.tween_property(screen_fade, "color:a", 0, SCREEN_FADE_TIME)
