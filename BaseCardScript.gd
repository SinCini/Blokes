extends Node2D
class_name Card
var timer
var parentNode
var cardName = "test"
var pointValue = 0
var timeValue = 0
var usesPoints = false
var changesTime = false
var setsTime = false
func SetValues(name1, points, time, changetime, settime):
	cardName = name1
	pointValue = points
	timeValue = time
	changesTime = changetime
	setsTime = settime
func _enter_tree():
	parentNode = get_parent()
# Called when the node enters the scene tree for the first time.
func _ready():
	timer = get_tree().current_scene.GetGameTimer()
func UseCard():
	parentNode.AddPoints()
	if(setsTime):
		AdjustTime()
	else: if(changesTime):
		SetTime()
func AdjustTime():
	var tempTime = timer.get_time_left()
	tempTime += timeValue
	timer.set_wait_time(tempTime)
	pass
func SetTime():
	timer.start(timeValue)
	pass
func SetSprite(x, y):
	#voidset_cell(layer: int, coords: Vector2i, source_id: int = -1, atlas_coords: Vector2i = Vector2i(-1, -1)
	$CardSprite.set_cell(0, Vector2i(0,0), 1, Vector2i(x,y))
func SetSpriteActive(boolean):
	if(boolean):
		$CardSprite.show()
	else:
		$CardSprite.hide()
