extends Node2D
class_name Card

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
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func _UseCard():
	if(usesPoints):
		$Player.AddPoint()
		pass
	if(setsTime):
		AdjustTime($timer)
		pass
	else: if(changesTime):
		SetTime($timer)
		pass
	pass
func AdjustTime(timer):
	var tempTime = timer.get_wait_time()
	tempTime += timeValue
	timer.set_wait_time(tempTime)
	pass
func SetTime(timer):
	timer.set_wait_time(timeValue)
	pass
func AddPoint(Player):
	Player.AddPoints(pointValue)
	pass
