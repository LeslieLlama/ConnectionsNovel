extends Resource

class_name ConversationLine

enum LineType {
	Character,
	Player,
	Narration,
}

@export var speaker_sprite: CharacterSprite
@export var line_type: LineType
@export_multiline var text: String
@export var recieved_evidence: Evidence
@export var update_background: Texture2D
