extends Control
@onready var label: Label = %Label

const TWEEN_TIME: float = 0.5
const DISPLAY_TIME: float = 1.0

func display(evidence: Evidence):
	label.text = "New Evidence: "+evidence.evidence_name
	
	var start_y = position.y
	var tween = create_tween()
	tween.tween_property(self, "position:y", 0, TWEEN_TIME)
	tween.tween_property(self, "position:y", start_y, TWEEN_TIME).set_delay(DISPLAY_TIME)
	
	await tween.finished
	queue_free()
