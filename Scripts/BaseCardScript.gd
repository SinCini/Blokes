extends Node2D
class_name Card
var timer
var parent
var cardName = "test"
var pointValue = 0
var timeValue = 0
var usesPoints = false
var changesTime = false
var setsTime = false
var usesD6 = false
func SetValues(name1, points, time, changetime, settime, d6):
	cardName = name1
	pointValue = points
	timeValue = time
	changesTime = changetime
	setsTime = settime
	usesD6 = d6
func _enter_tree():
	parent = get_parent()
# Called when the node enters the scene tree for the first time.
func _ready():
	if(setsTime || changesTime):
		timer = parent.get_parent().GetGameTimer()
		pass
func UseBloke():
	if(cardName.contains("No")):
		#Disable previous bloke
		pass
	if(usesPoints):
		if(usesD6):
			#roll dice depending on time value
			parent.AddPoints()
		else:
			parent.AddPoints(pointValue)
	if(setsTime):
		SetTime()
	else: if(changesTime):
		ChangeTime()
func ChangeTime():
	var tempTime = timer.time_left
	if(usesD6):
		#tempTime += D6 of time value
		timer.start(tempTime)
	else:
		tempTime += timeValue
		timer.start(tempTime)
func SetTime():
	if(timeValue < 60):
		var tempTime = timer.time_left
		tempTime *= timeValue
		timer.start(tempTime)
	else:
		timer.start(timeValue)
func SetSprite(x, y):
	#voidset_cell(layer: int, coords: Vector2i, source_id: int = -1, atlas_coords: Vector2i = Vector2i(-1, -1)
	$CardSprite.set_cell(0, Vector2i(0,0), 1, Vector2i(x,y))
func SetActive(boolean):
	if(boolean):
		show()
	else:
		hide()
func GetCardName():
	return cardName
func _on_select_pressed():
	parent.SetSelectedBloke(self)
	parent.ToggleUseBloke(true)
	pass # Replace with function body.
