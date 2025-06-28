extends Node2D

@export var first_scene_index: int = 0
@export var editor_scenes: Array[PackedScene]

var loadable_scenes: Array[LoadableScene]
var current_scene: LoadedScene

func _ready() -> void:
	populate_loadable_scenes_list()
	load_level_scene_by_index(first_scene_index)
	return

func _process(delta: float) -> void:
	return

func populate_loadable_scenes_list() -> void:
	for scene in editor_scenes:
		print(add_level_scene_to_scene_array(scene))

func load_level_scene_by_index(index: int) -> LoadedScene:
	if index < 0 or index > loadable_scenes.size():
		return null
	
	return load_level_scene(loadable_scenes[index], index)

func load_level_scene_by_name(scene_name: String) -> LoadedScene:
	var i: int = 0
	while i < loadable_scenes.size():
		if scene_name == loadable_scenes[i].scene_name:
			return load_level_scene(loadable_scenes[i], i)
		i += 1
	
	return null

func load_level_scene(scene_to_load: LoadableScene, index: int) -> LoadedScene:
	if !scene_to_load.scene.can_instantiate():
		return null
	
	if current_scene != null:
		current_scene.scene.queue_free()
		current_scene = null
	
	var new_scene: Node = scene_to_load.scene.instantiate()
	
	if new_scene == null:
		return null
	
	current_scene = LoadedScene.new()
	
	current_scene.scene = new_scene
	current_scene.scene_index = index
	current_scene.scene_name = scene_to_load.scene_name
	
	add_child(new_scene)
	
	print(new_scene.name)
	
	return current_scene

func add_level_scene_to_scene_array(scene: PackedScene) -> int:
	if scene == null:
		return -1
	
	var scene_name: String = scene._bundled["names"][0]
	
	print(scene_name)
	
	var i: int = 0
	while i < loadable_scenes.size():
		if scene_name == loadable_scenes[i].scene_name:
			printerr("Duplicate scene with the name: " + name)
			return -1
		i += 1
	
	var loadable_scene: LoadableScene = LoadableScene.new()
	loadable_scene.scene_name = scene_name
	loadable_scene.scene = scene
	
	loadable_scenes.append(loadable_scene)
	
	return loadable_scenes.size() - 1

func remove_level_scene_from_array_by_index(index: int) -> bool:
	if index < 0 or index > loadable_scenes.size():
		return false
	
	loadable_scenes.remove_at(index)
	readjust_current_level_scenes_index()
	
	return true

func remove_level_scene_from_array_by_name(scene_name: String) -> bool:
	var i: int = 0
	while i < loadable_scenes.size():
		if loadable_scenes[i].scene_name == scene_name:
			loadable_scenes.remove_at(i)
			readjust_current_level_scenes_index()
			return true
		i += 1
	
	return false

func readjust_current_level_scenes_index() -> void:
	var i: int = 0
	while i < loadable_scenes.size():
		if loadable_scenes[i].scene_name == current_scene.scene_name:
			current_scene.scene_index = i
			return
		i += 1


class LoadedScene:
	var scene_index: int
	var scene_name: String
	var scene: Node

class LoadableScene:
	var scene_name: String
	var scene: PackedScene
