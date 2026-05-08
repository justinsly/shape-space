extends Node
var loadingscreen := preload("res://scenes/screens/loading_screen.tscn")
var scenetoload: String = "res://scenes/screens/titlescreen.tscn"

## loads the loading screen and then the provided next scene, 
## loads the last loaded scene by default (and initially the title screen)
func initiateloadingscreen(nextscene := scenetoload):
	if nextscene != scenetoload:
		scenetoload = nextscene
	get_tree().change_scene_to_packed(loadingscreen)
