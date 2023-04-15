extends QuiverInteractableObjectAction

func trigger(object: QuiverInteractableObject, character: QuiverCharacter):
	get_node("/root/TinyWizardDemo/Camera2D/GUI/CardChoice").visible = true
	get_node("/root/TinyWizardDemo/Camera2D/GUI/CardChoice").new_cards(get_parent())
