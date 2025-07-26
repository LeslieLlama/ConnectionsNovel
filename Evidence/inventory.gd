extends Node

@export var evidence: Array[Evidence]
const EVIDENCE_POPUP = preload("res://Evidence/evidence_popup.tscn")

func add_evidence(new_evidence: Evidence):
	if !evidence.has(new_evidence):
		evidence.append(new_evidence)
		var evidence_popup = EVIDENCE_POPUP.instantiate()
		get_parent().add_child(evidence_popup)
		evidence_popup.display(new_evidence)

func remove_evidence(picked_evidence: Evidence):
	evidence.erase(picked_evidence)
func clear():
	evidence.clear()
