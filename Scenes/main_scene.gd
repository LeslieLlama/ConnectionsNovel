extends Control

const DIALOGUE_SCENE = preload("res://Scenes/dialogue_scene.tscn")
const MAP_SCENE = preload("res://Scenes/map_scene.tscn")
@onready var screen_fade: ColorRect = %ScreenFade
const SCREEN_FADE_TIME = 0.4

@export var intro_scene: Conversation
@export var encounters: EncounterList

const BAD_ENDING = preload("res://Endings/bad_ending.tres")
const TRUE_ENDING = preload("res://Endings/true_ending.tres")
const THE_TRUE_KILLER = preload("res://Evidence/Evidence/the_true_killer.tres")
const BEFORE_ACCUSATION = preload("res://Encounters/Encounters/06.5_BeforeAccusation.tres")

signal game_completed

func _ready() -> void:
	Inventory.clear()
	await do_conversation(intro_scene)
	for time_slot in encounters.encounters:
		if time_slot == encounters.encounters.back():
			await do_conversation(BEFORE_ACCUSATION)
		
		var encounter = await show_map(time_slot)
		await do_encounter(encounter)
		
	if Inventory.evidence.has(THE_TRUE_KILLER):
		await do_conversation(TRUE_ENDING)
	else:
		await do_conversation(BAD_ENDING)
	
	MusicManager.stop_track()
	game_completed.emit()

func do_conversation(conversation: Conversation):
	var dialogue_scene = DIALOGUE_SCENE.instantiate()
	add_child(dialogue_scene)
	await dialogue_scene.display_conversation(conversation)
	await screen_transition()
	dialogue_scene.queue_free()

func do_encounter(encounter: Encounter):
	MusicManager.play_track(MusicManager.AQUATIC_CONNECTION)
	var dialogue_scene = DIALOGUE_SCENE.instantiate()
	add_child(dialogue_scene)
	await dialogue_scene.do_encounter(encounter)
	MusicManager.stop_track()
	await screen_transition()
	dialogue_scene.queue_free()

func show_map(time_slot: TimeSlot) -> Encounter:
	MusicManager.play_track(MusicManager.CONNECT_THE_DOTS)
	var map_scene = MAP_SCENE.instantiate()
	add_child(map_scene)
	var encounter = await map_scene.display_encounter_choices(time_slot)
	MusicManager.stop_track()
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
