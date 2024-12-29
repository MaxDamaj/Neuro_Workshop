extends Node
class_name NpcsProvider

static var path : NodePath = "/root/MainScene/_Providers/NpcsProvider"

@export var allNpcs : Dictionary

func get_random_npc() -> NpcView:
	var npc = allNpcs.values().pick_random().instantiate()
	return npc

func get_npc(npcName : String) -> NpcView:
	if (allNpcs.has(npcName)):
		return allNpcs[npcName].instantiate()
	return get_random_npc()
