extends Node
class_name NpcsProvider

static var path : NodePath = "/root/MainScene/_Providers/NpcsProvider"

@export var allNpcs : Dictionary

var randomNpcs : Array[PackedScene]

func _ready() -> void:
	for npcId : String in allNpcs:
		if (npcId.contains("random")):
			randomNpcs.append(allNpcs[npcId])

func get_random_npc() -> NpcView:
	var npc = randomNpcs.pick_random().instantiate()
	return npc

func get_npc(npcName : String) -> NpcView:
	if (allNpcs.has(npcName)):
		return allNpcs[npcName].instantiate()
	return get_random_npc()
