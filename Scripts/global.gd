extends Node

var username := ''
var playersInGame = []
var lobby
func AddPlayer(player):
	playersInGame.append(player)
	lobby.UpdateLobby()
func RemovePlayer(peer_id):
	var player_to_remove = playersInGame.find(func(item): return item.name == str(peer_id))
	if(player_to_remove != -1):
		playersInGame[player_to_remove].remove()
		lobby.UpdateLobby()
func ClearPlayers():
	lobby = TYPE_NIL
	playersInGame = []
func GetPlayersInGame():
	return playersInGame
func SetLobby():
	lobby = get_node("/root/Main/GameLobby")
