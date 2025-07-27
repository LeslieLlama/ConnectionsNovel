extends Control
@onready var map_nodes: Control = %MapNodes
var nav_button = preload("res://Themes/navigation_button.tscn")
signal button_pressed(Encounter)

func get_map_node(location: Location) -> MapLocation:
	for node: MapLocation in map_nodes.get_children():
		if node.location == location:
			return node
	return null

func display_encounter_choices(time_slot: TimeSlot):
	for encounter in time_slot.encounters:
		var map_node = get_map_node(encounter.location)
		
		var button = nav_button.instantiate()
		button.text = "Connect with {0}".format([
			encounter.character.character_name,
			encounter.location.location_name])
		button.visible = true
		add_child(button)
		button.global_position = map_node.global_position-button.size/2
		
		button.pressed.connect(location_selected.bind(encounter))
		
	return await button_pressed
		
func location_selected(encounter: Encounter):
	button_pressed.emit(encounter)
