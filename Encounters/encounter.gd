extends Resource

class_name Encounter

@export var location: Location
@export var main_conversation: Conversation
@export var presented_evidence: Dictionary[Evidence, Conversation]
@export var failed_evidence: Conversation
