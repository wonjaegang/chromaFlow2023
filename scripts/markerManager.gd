extends Node2D

var markerScene = preload("res://assets/marker.tscn")


func _on_in_game_manager_generate_marker(pos, color, isStart):
    var marker = markerScene.instantiate()
    marker.position = pos
    marker.get_node("mesh").modulate = color
    if isStart:
        get_node("startManager").add_child(marker)
    else:
        get_node("endManager").add_child(marker)
                        
                        
                                                                        
