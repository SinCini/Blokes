extends CanvasLayer
# Called when the node enters the scene tree for the first time.
var playerPlateArray: Array[Node] = []
var playerNameArray: Array[Node] = []
var playerHostArray: Array[Node] = []
var hSeparator = []
var playerArray = []
func _ready():
	if(multiplayer.get_unique_id() != 1):
		%StartGameButton.hide()
	%SessionIDLabel.text =  Multiplayer.tube_client.session_id
	%CopySessionButton.pressed.connect(func(): DisplayServer.clipboard_set(Multiplayer.tube_client.session_id))
	playerNameArray = get_tree().get_nodes_in_group('PlayerNames')
	playerPlateArray = get_tree().get_nodes_in_group('PlayerPlates')
	playerHostArray = get_tree().get_nodes_in_group('Host')
	hSeparator = get_tree().get_nodes_in_group("Hseparator")
@rpc("any_peer")
func StartGame():
	get_parent().get_node("GameScene").StartGame()
	HideUI()

func UpdateLobby():
	%SessionIDLabel.text =  Multiplayer.tube_client.session_id
	playerArray = Global.GetPlayersInGame()
	var playersInGame = playerArray.size()
	print("players in lobby " + str(playersInGame))
	for i in range(playersInGame):
		playerPlateArray[i].show()
		if(playerArray[i].GetPlayerID() == 1):
			playerHostArray[i].show()
		playerNameArray[i].text = playerArray[i].GetName()
		if(playerNameArray[i].name == '1'):
			playerHostArray[i].show()
		if(i > 1):
			hSeparator[0].show()
		if(i > 2):
			hSeparator[1].show()
		if(i > 3):
			hSeparator[2].show()
		if(i > 5):
			hSeparator[3].show()
		if(i > 6):
			hSeparator[4].show()
		if(i > 7):
			hSeparator[5].show()
	if(playersInGame > 5):
		%MiddleSeperator.show()
	else:
		%MiddleSeperator.hide()

func _on_start_game_button_pressed() -> void:
	StartGame()

	rpc("StartGame")

func HideUI():
	%PlayerContainer.hide()
	%LobbyButtons.hide()
func _on_leave_lobby_button_pressed() -> void:
	Multiplayer.Leave_Server()
