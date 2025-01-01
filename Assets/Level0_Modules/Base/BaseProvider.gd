#Base class for providers
extends Node
class_name BaseProvider

func _add_to_dictionary(path : String, dict : Dictionary):
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	while true:
		var file_name = dir.get_next()
		
		if ('.tres.remap' in file_name):
			file_name = file_name.trim_suffix('.remap')
		if (file_name == ""):
			#break the while loop when get_next() returns ""
			break
		elif !file_name.begins_with(".") and !file_name.ends_with(".import"):
			var file = load(path + "/" + file_name)
			dict[file.resource_name] = file
	dir.list_dir_end()
