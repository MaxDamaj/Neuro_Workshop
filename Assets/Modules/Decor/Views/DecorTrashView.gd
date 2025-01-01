extends DecorTableView
class_name DecorTrashView

func try_add_item(itemName : String):
	EventsProvider.call_event("%s thrown away" % itemName.replace('_', ' '))
	return true
