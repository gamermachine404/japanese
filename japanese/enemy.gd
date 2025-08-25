extends Node2D

var character:int = 0
var targettext:String
var alpha = 1

func _ready():
	pass
	
func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_pressed():
		if event.as_text().to_lower() == String.chr(targettext.unicode_at(character)):
			if character+1 == targettext.length():
				$Label.label_settings.font_color = Color.from_hsv(0.34,1,1,1)
				if alpha == 1: alpha = 0.99
			elif alpha == 1:
				$Label.label_settings.font_color = Color.from_hsv(0.34,0,1,1)
				character+=1
		elif alpha == 1:
			$Label.label_settings.font_color = Color.from_hsv(0,1,1,1)
			character = 0

func _process(delta):
	if alpha == 1:return
	if alpha <= 0:queue_free()
	alpha -= delta
	$Label.label_settings.font_color = Color.from_hsv(0.34,1,1,alpha)
