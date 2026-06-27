extends Node
var loadingscreen := preload("res://scenes/screens/loading_screen.tscn")
var scenetoload: String = "res://scenes/screens/titlescreen.tscn"
var loadfaster := false

## loads the loading screen and then the provided next scene, 
## loads the last loaded scene by default (and initially the title screen)[br]
## if [param shouldloadfaster] is [param true], then it will not intentionally stay on the loading screen for 0.2 seconds
func initiateloadingscreen(nextscene := scenetoload, shouldloadfaster := loadfaster):
	if nextscene != scenetoload:
		scenetoload = nextscene
	loadfaster = shouldloadfaster
	get_tree().change_scene_to_packed(loadingscreen)
