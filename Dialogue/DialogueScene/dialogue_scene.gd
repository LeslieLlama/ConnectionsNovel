extends Control

@onready var textbox: Label = %Textbox
@onready var portrait: TextureRect = %Portrait
@onready var background: TextureRect = %Background
@onready var namebox: Label = %Namebox

var current_speaker_name: String
var text_tween: Tween

const TEXT_SPEED: float = 0.02

signal text_advanced

func do_encounter(encounter: Encounter):
	background.texture = encounter.location.background
	for line in encounter.main_conversation.lines:
		await display_line(line)
		
func display_line(line: ConversationLine):
	textbox.text = line.text
	if line.speaker_sprite:
		current_speaker_name = line.speaker_sprite.character.character_name
		portrait.texture = line.speaker_sprite.sprite
		
	if line.is_player_speaking:
		namebox.text = "Jann"
	else:
		namebox.text = current_speaker_name
	
	textbox.visible_characters = 0
	if text_tween:
		text_tween.kill()
	
	text_tween = create_tween()
	text_tween.tween_property(textbox, "visible_characters", len(line.text), TEXT_SPEED*len(line.text))
	
	await text_advanced
	
	if textbox.visible_characters < len(line.text):
		text_tween.kill()
		textbox.visible_characters = len(line.text)
		
		await text_advanced
		
	if line.recieved_evidence:
		Inventory.add_evidence(line.recieved_evidence)
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("advance"):
		text_advanced.emit()
