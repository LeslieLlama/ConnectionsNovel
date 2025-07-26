extends Control

const EVIDENCE_PICKER = preload("res://Evidence/EvidencePicker/evidence_picker.tscn")

@onready var textbox: Label = %Textbox
@onready var portrait: TextureRect = %Portrait
@onready var background: TextureRect = %Background
@onready var namebox: Label = %Namebox
@onready var namebox_panel: Panel = %NameboxPanel
@onready var name_container: Control = %NameContainer

var current_speaker_name: String
var text_tween: Tween

const TEXT_SPEED: float = 0.02

signal text_advanced

func do_encounter(encounter: Encounter):
	background.texture = encounter.location.background
	await display_conversation(encounter.main_conversation)
	
	if Inventory.evidence:
		var evidence_picker = EVIDENCE_PICKER.instantiate()
		add_child(evidence_picker)
		
		await get_tree().process_frame
		var picked_evidence = await evidence_picker.choose()
		
		if picked_evidence in encounter.presented_evidence:
			await display_conversation(encounter.presented_evidence[picked_evidence])
		elif picked_evidence:
			await display_conversation(encounter.failed_evidence)

func display_conversation(conversation: Conversation):
	for line in conversation.lines:
		await display_line(line)

func switch_background(new_background: Texture2D):
	background.show()
	background.modulate = Color.WHITE
	var tween = create_tween()
	tween.tween_property(background, "modulate", Color.BLACK, 0.4)
	
	await tween.finished
	background.texture = new_background
	
	tween = create_tween()
	tween.tween_property(background, "modulate", Color.WHITE, 0.4)
	

func display_line(line: ConversationLine):
	textbox.show()
	textbox.text = line.text
	if line.update_background:
		switch_background(line.update_background)
	
	if line.speaker_sprite:
		current_speaker_name = line.speaker_sprite.character.character_name
		portrait.texture = line.speaker_sprite.sprite
		
	if line.line_type == line.LineType.Player:
		namebox.text = "Jann"
		name_container.show()
	elif line.line_type == line.LineType.Character:
		namebox.text = current_speaker_name
		name_container.show()
	else:
		name_container.hide()
	
	if Input.is_action_pressed("skip"):
		textbox.visible_characters = len(line.text)
		await get_tree().create_timer(0.1).timeout
	else:
		textbox.visible_characters = 0
		if text_tween:
			text_tween.kill()
		
		text_tween = create_tween()
		text_tween.tween_property(textbox, "visible_characters", len(line.text), TEXT_SPEED*len(line.text))
		
		await wait_for_text_advancement()
		
		if textbox.visible_characters < len(line.text):
			text_tween.kill()
			textbox.visible_characters = len(line.text)
			
			await wait_for_text_advancement()
		
	if line.consumed_evidence:
		Inventory.remove_evidence(line.consumed_evidence)
		
	if line.recieved_evidence:
		Inventory.add_evidence(line.recieved_evidence)
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("advance"):
		text_advanced.emit()

func wait_for_text_advancement():
	if Input.is_action_pressed("skip"):
		return
	else:
		await text_advanced
