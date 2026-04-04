extends Node

const PLAYER = preload("res://Scenes/Player.tscn")
const TUBE_CONTEXT = preload("res://Scripts/tube_context.tres")
#create multiplayer object called 'peer' using Enet networking library
var enet_peer = ENetMultiplayerPeer.new()
var tube_client = TubeClient.new()
var tube_enabled = true
#port that server is listening for comms on
var PORT = 12345
var IP_ADDRESS = '127.0.0.1'
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	if(tube_enabled):
		tube_client.context = TUBE_CONTEXT
		get_tree().root.add_child.call_deferred(tube_client)

func Tube_Create():
	multiplayer.peer_connected.connect(Add_Player)
	multiplayer.peer_disconnected.connect(Remove_Player)
	tube_client.create_session()
	Add_Player(1)
	
func Tube_Join(session_id: String):
	multiplayer.peer_connected.connect(Add_Player)
	multiplayer.peer_disconnected.connect(Remove_Player)
	multiplayer.connected_to_server.connect(On_Connected_To_Server)
	tube_client.join_session(session_id)
	
func Start_Server():
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(Add_Player)
	multiplayer.peer_disconnected.connect(Remove_Player)

func Join_Server():
	enet_peer.create_client(IP_ADDRESS,PORT)
	multiplayer.peer_connected.connect(Add_Player)
	multiplayer.peer_disconnected.connect(Remove_Player)
	multiplayer.connected_to_server.connect(On_Connected_To_Server)
	multiplayer.multiplayer_peer = enet_peer

func On_Connected_To_Server():
	Add_Player(multiplayer.get_unique_id())

func Add_Player(peer_id: int):
	if peer_id == 1 and multiplayer.multiplayer_peer is ENetMultiplayerPeer:
		return
	var new_player = PLAYER.instantiate()
	new_player.name = str(peer_id)
	get_tree().current_scene.add_child(new_player, true)
	
func Remove_Player(peer_id):
	if(peer_id == 1):
		Leave_Server()
		return
		
	var players:Array[Node] = get_tree().get_nodes_in_group('Players')
	var player_to_remove = players.find(func(item): return item.name == str(peer_id))
	if(player_to_remove != -1):
		players[player_to_remove].queue_free()
func Leave_Server():
	if(tube_enabled):
		tube_client.leave_session()

	multiplayer.multiplayer_peer.close()
	multiplayer.multiplayer_peer = null
	Clean_Up_Signals()
	get_tree().reload_current_scene()

func Clean_Up_Signals():
	multiplayer.peer_connected.disconnect(Add_Player)
	multiplayer.peer_disconnected.disconnect(Remove_Player)
	multiplayer.connected_to_server.disconnect(On_Connected_To_Server)
	
func _exit_tree() -> void:
	if(tube_enabled):
		tube_client.leave_session()
	
