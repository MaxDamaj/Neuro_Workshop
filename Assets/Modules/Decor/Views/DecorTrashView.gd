extends DecorTableView
class_name DecorTrashView

func try_add_item(itemName : String):
	EventsProvider.call_event("%s thrown away" % ItemsProvider.get_item_name(itemName))
	return true
