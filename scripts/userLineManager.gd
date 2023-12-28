extends Node2D

# 추후 game manager 에서 관리
const Y_MIN = 400 + 10 * 3
const Y_MAX = 400 + 700 - 10 * 3

var userLineScene = preload("res://assets/userLine.tscn")
var userLineMinH

var generatingLine = false

func _vertical_line_pressed(verticalLineNode):
    generatingLine = true
    
    var userLine = userLineScene.instantiate()
    userLineMinH = userLine.get_child(0).mesh.radius * 2
    
    userLine.startVerticalNode = verticalLineNode
    userLine.position.x = verticalLineNode.position.x
    userLine.position.y = max(min(get_viewport().get_mouse_position().y, Y_MAX), Y_MIN)
    userLine.setLineLength(userLineMinH)
    add_child(userLine)
                
                                                                                        
func _process(delta):
    if generatingLine:
        var newline = get_child(-1)
        if Input.is_mouse_button_pressed(1):
            var end = get_viewport().get_mouse_position()
            # 수직선에 닿았을 때
            if newline.stickFlg:
                end.x = newline.endVerticalNode.position.x
            # 위/아래 경계선 내로 지정
            end.y = max(min(end.y, Y_MAX), Y_MIN)
            
            var diff = end - newline.position
            newline.rotation = atan2(diff.y, diff.x) - PI/2
            if diff.length() > userLineMinH:
                newline.setLineLength(diff.length())
        else:
            generatingLine = false
            if not newline.checkIsProper():
                newline.queue_free()
