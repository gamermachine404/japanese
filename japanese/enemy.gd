extends Node2D

var character:int = 0
var targettext:String
var elapsed:float = 0
var state = 0 #0: alive 1: failed 2:succeeded
var alpha = 1

func _ready():
	pass
	
func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_pressed():
		if event.as_text().to_lower() == String.chr(targettext.unicode_at(character)):
			if character+1 == targettext.length():
				$Label.label_settings.font_color = Color.from_hsv(0.34,1,1,1)
				if state == 0: state = 2
			elif state == 0:
				$Label.label_settings.font_color = Color.from_hsv(0.34,0,1,1)
				character+=1
		elif state == 0:
			$Label.label_settings.font_color = Color.from_hsv(0.10,1,1,1)
			character = 0

func _process(delta):
	if elapsed > 10: state = 1
	if state == 0: 
		elapsed += delta
		return
	if alpha == 1:
		$Label.text = $Label.text + " (" + targettext + ")"
	if alpha <= 0:queue_free()
	alpha -= delta
	if elapsed > 10:
		$Label.label_settings.font_color = Color.from_hsv(0,1,1,alpha)
	else:
		$Label.label_settings.font_color = Color.from_hsv(0.34,1,1,alpha)
