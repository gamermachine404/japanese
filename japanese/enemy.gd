extends Node2D

var character:int = 0
var targettext:String

func _ready():
	pass

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_pressed():
		if event.as_text() == String.chr(targettext.unicode_at(character)):
			if character == targettext.length():
				pass
			else:
				character+=1
		else:
			character = 0
