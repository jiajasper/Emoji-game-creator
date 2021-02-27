extends Node2D

var can_place = true 

var do_save = false

onready var level = get_node("/root/main/Level")
onready var tile_map : TileMap = level.get_node("TileMap")
onready var popup : FileDialog = get_node("/root/main/Item_Select/FileDialog")

var current_item


func _ready():
	pass 

func _process(delta):
	global_position = get_global_mouse_position()
	
	if Global.playing == false:
		if !Global.place_tile:
			if (!Global.filesystem_shown):
				if(current_item != null and can_place and Input.is_action_just_pressed("mb_left")):
					var new_item = current_item.instance()
					level.add_child(new_item)
					new_item.owner = level #this is very important, to save objects, otherwise only tiles will be saved.
					new_item.global_position = get_global_mouse_position()
		else:
			if (!Global.filesystem_shown):
				if(can_place):
					if Input.is_action_pressed("mb_left"):
						place_tile()
					if Input.is_action_pressed("mb_right"):
						remove_tile()
	
	if Input.is_action_pressed("save"):
		Global.filesystem_shown = true
		do_save = true
		popup.mode = 4
		popup.show()		
	if Input.is_action_pressed("load"):
		Global.filesystem_shown = true
		do_save = true
		popup.mode = 0
		popup.show()			
	
	pass
	
func place_tile():
	var mousepos = tile_map.world_to_map(get_global_mouse_position())
	tile_map.set_cell(mousepos.x,mousepos.y,Global.current_tile)

func remove_tile():
	var mousepos = tile_map.world_to_map(get_global_mouse_position())
	tile_map.set_cell(mousepos.x,mousepos.y,-1)

func save_level():
	var toSave : PackedScene = PackedScene.new()
	tile_map.owner = level
	toSave.pack(level)
	ResourceSaver.save(popup.current_path + ".tscn",toSave)
	
func load_level():
	var toLoad : PackedScene = PackedScene.new()
	toLoad = ResourceLoader.load(popup.current_path)
	var this_level = toLoad.instance()
	get_parent().remove_child(level)
	level.queue_free()
	get_parent().add_child(this_level)
	tile_map = get_parent().get_node("/root/main/Level/TileMap")
	level = this_level
	
func _on_FileDialog_confirmed():
	if popup.window_title == "Save a File":
		save_level()
	else:
		load_level()
	pass
	
func _on_FileDialog_hide():
	Global.filesystem_shown = false
	do_save = false 
	pass
