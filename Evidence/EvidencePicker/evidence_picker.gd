extends Control

signal option_picked
@onready var options: GridContainer = %Options

func choose() -> Evidence:
	for inventory_evidence in Inventory.evidence:
		var new_option = Button.new()
		new_option.action_mode = BaseButton.ACTION_MODE_BUTTON_PRESS
		new_option.text = inventory_evidence.evidence_name
		options.add_child(new_option)
		new_option.pressed.connect(pick_option.bind(inventory_evidence))
		
	options.get_child(0).grab_focus()
	
	var option = await option_picked
	queue_free()
	return option
	
func pick_option(option: Evidence):
	option_picked.emit(option)
	
