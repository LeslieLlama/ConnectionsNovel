extends Control

const DIALOGUE_SCENE = preload("res://Scenes/dialogue_scene.tscn")
const MAP_SCENE = preload("res://Scenes/map_scene.tscn")

@export var encounters: EncounterList


func _ready() -> void:
	for time_slot in encounters.encounters:
		var encounter = await show_map(time_slot)
		await do_encounter(encounter)

func do_encounter(encounter: Encounter):
	var dialogue_scene = DIALOGUE_SCENE.instantiate()
	add_child(dialogue_scene)
	await dialogue_scene.do_encounter(encounter)
	dialogue_scene.queue_free()
	
func show_map(time_slot: TimeSlot) -> Encounter:
	var map_scene = MAP_SCENE.instantiate()
	add_child(map_scene)
	var encounter = await map_scene.display_encounter_choices(time_slot)
	map_scene.queue_free()
	
	return encounter
