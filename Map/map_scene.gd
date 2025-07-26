extends Control
@onready var map_nodes: Control = %MapNodes

signal button_pressed(Encounter)

func get_map_node(location: Location) -> MapLocation:
	for node: MapLocation in map_nodes.get_children():
		if node.location == location:
			return node
	return null

func display_encounter_choices(time_slot: TimeSlot):
	for encounter in time_slot.encounters:
		var map_node = get_map_node(encounter.location)
		
		var button = Button.new()
		button.text = "Connect with {0} in the {1}".format([
			encounter.character.character_name,
			encounter.location.location_name])

		add_child(button)
		button.global_position = map_node.global_position-button.size/2
		
		button.pressed.connect(location_selected.bind(encounter))
		
	return await button_pressed
		
func location_selected(encounter: Encounter):
	button_pressed.emit(encounter)
