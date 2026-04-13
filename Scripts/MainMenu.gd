extends CanvasLayer

const GAME_BOARD = preload("res://Scenes/game_scene.tscn")
const GAME_LOBBY = preload("res://Scenes/game_lobby.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	
	if(Multiplayer.tube_enabled):
		%EnetMenu.hide()
	else:
		%TubeMenu.hide()
	%Join.pressed.connect(On_Join)
	%Quit.pressed.connect(func(): get_tree().quit())
	
	%LineEditID.text_changed.connect(Update_ID)
	%LineEditName.text_changed.connect(Update_Username)
	%JoinTube.disabled = true
	%JoinTube.pressed.connect(On_Join_Tube)
	%QuitTube.pressed.connect(func(): get_tree().quit())
	%ButtonCreateTube.pressed.connect(On_Create_Tube)
	
	Multiplayer.tube_client.error_raised.connect(on_error_raised)
	if(OS.has_feature('server')):
		Multiplayer.Start_Server()
		await get_tree().create_timer(0.1).timeout
		AddGameBoard()
		hide()
	
func On_Join():
	AddGameBoard()
	Multiplayer.Join_Server()
	hide()

func AddGameBoard():
	var new_gameBoard = GAME_BOARD.instantiate()
	var new_gameLobby = GAME_LOBBY.instantiate()
	get_tree().current_scene.add_child(new_gameBoard)
	get_tree().current_scene.add_child(new_gameLobby)
	Global.SetLobby()

func Update_ID(new_text: String):
	if(new_text != ''):
		%JoinTube.disabled= false
func Update_Username(new_text: String):
	Global.username = new_text
func On_Join_Tube():
	multiplayer.connected_to_server.connect(AddGameBoard)
	Multiplayer.Tube_Join(%LineEditID.text)
	
	hide()

func On_Create_Tube():
	AddGameBoard()
	Multiplayer.Tube_Create()
	hide()

func on_error_raised(_code, _message):
	%LineEditID.text =''
	%JoinTube.add_theme_color_override('font_disabled_color', Color.DARK_RED)
	%JoinTube.disabled = true
	Multiplayer.Clean_Up_Signals()
	
