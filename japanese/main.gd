extends Control

const TwoWayDict = preload("res://twowaydict.gd")
const ESCENE = preload("res://enemy.tscn")

static var hiragana_dict:TwoWayDict
static var katakana_dict:TwoWayDict

var counters = {}
var lists = {}
var pick

var stage = 0 #0: hiatus, 1: answering question, 2:done answering question, 3: special case
var ellapsed:float

var mistakes = 0
var he

static func getMatchingDict(nani:String):
	if nani == "he" or nani == "eh":
		return hiragana_dict
	else:
		return katakana_dict

func _ready():
	$StartButton.pressed.connect(startButtonPress)
	$ConfirmButton.pressed.connect(confirmPress)
	
	hiragana_dict = TwoWayDict.new()
	hiragana_dict.appendFromFile("res://hiragana.txt")
	print(hiragana_dict.one)
	print(hiragana_dict.two)
	#katakana_dict = TwoWayDict.new()
	#katakana_dict.appendFromFile("res://katakana.txt")

func _process(delta):
	if Input.is_action_just_pressed("Confirm"):
		confirmPress()
	if stage == 0: return
	ellapsed += delta
	if ellapsed >= 2:
		var newenemy = load("res://enemy.tscn").instantiate()
		pick = counters.keys().pick_random()
		newenemy.find_child("Label").text = lists.get(pick)[counters.get(pick)]
		var tempsettings = LabelSettings.new()
		tempsettings.font_size = 23
		newenemy.find_child("Label").label_settings = tempsettings
		print("New enemy label: " + lists.get(pick)[counters.get(pick)])
		newenemy.targettext = hiragana_dict.getTwoFromOne(lists.get(pick)[counters.get(pick)])
		print("new enemy target text: " + hiragana_dict.getTwoFromOne(lists.get(pick)[counters.get(pick)]))
		newenemy.position.x = randf_range(20, float(get_window().size.x) - 50)
		newenemy.position.y = randf_range(20, float(get_window().size.y) - 50)
		$Playground.add_child(newenemy)
		if counters.get(pick) == lists.get(pick).size() - 1:
			counters.set(pick, 0)
			lists.get(pick).shuffle()
		else:
			counters.set(pick, counters.get(pick) + 1)
		ellapsed = 0
	

func startButtonPress():
	var goodtogo = false
	for i:CheckBox in $StartOptions.get_children():
			if i.button_pressed:
				goodtogo = true
	if goodtogo:
		start()
	else:
		$DumbassLabel.visible = true

func next():
	stage = 0
	if counters.keys().is_empty():
		$Label.text = "Done!"
		if mistakes == 0:
			$SmartassLabel.text = "You made no mistakes!!"
			$SmartassLabel.visible = true
		else:
			$DumbassLabel.text = "You made " + mistakes.to_string() + " mistakes"
			$DumbassLabel.visible = true
		return
	pick = counters.keys().pick_random()
	$SmartassLabel.visible = false
	$DumbassLabel.visible = false
	if pick == "he" or pick == "ke":
		$Label.text = "what does the kana " + lists.get(pick).get(counters.get(pick)) + " sound like?"
	elif pick == "eh" or pick == "ek":
		$Label.text = "which kana has the sound " + lists.get(pick)[counters.get(pick)] + " associated?"
	stage = 1

func confirmPress():
	if stage == 0:
		return
	if stage == 2:
		next()
		return
	if $TextEdit.text == "":
		$DumbassLabel.text = "How about you write something first?"
		$DumbassLabel.visible = true
		return
		
	stage = 0
	
	if getMatchingDict(pick).getEitherOr(lists.get(pick)[counters.get(pick)]) == $TextEdit.text:
		$SmartassLabel.visible = true
	else:
		$DumbassLabel.text = "WRONG! It's actually " + getMatchingDict(pick).getEitherOr(lists.get(pick)[counters.get(pick)])
		$DumbassLabel.visible = true
		mistakes +=1
	counters.set(pick, counters.get(pick)+1)
	if counters.get(pick) == lists.get(pick).size():
		counters.erase(pick)
	stage = 2
	
func start():
	$StartOptions.visible = false
	$StartButton.visible = false
	$DumbassLabel.visible = false
	$Label.visible = false
	$Playground.visible = true
	#$ConfirmButton.visible = true
	#$TextEdit.visible = true
	
	if $StartOptions/HE.button_pressed:
		he = hiragana_dict.one.duplicate()
		he.shuffle()
		counters.set("he", 0)
		lists.set("he", he)
	
	#var enemyscene = load("res://enemy.tscn")
	#var enemy:Node2D = enemyscene.instantiate()
	#add_child(enemy)
	#enemy.position.x = 500
	#enemy.position.y = 500
	
	$Playground.visible=true
	stage = 1
	
func start2():
	$StartOptions.visible = false
	$StartButton.visible = false
	$DumbassLabel.visible = false
	$ConfirmButton.visible = true
	$TextEdit.visible = true
	
	if $StartOptions/HE.button_pressed:
		he = hiragana_dict.one.duplicate()
		he.shuffle()
		counters.set("he", 0)
		lists.set("he", he)
	startGame()

func startGame():
	$Playground.visible=true
	stage = 1
	
