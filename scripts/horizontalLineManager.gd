extends Node2D

var yMin
var yMax
var userLineMinH
var userLineColor
var generatingLine = false
var isChecking = false

var horizontalLineScene = preload("res://assets/horizontalLine.tscn")


func connectLineGenerateSignal():
    """
    수직선 시그널 연결
    """
    for verticalLine in $"../verticalLineManager".get_children():
        verticalLine.verticalLinePressed.connect(_vertical_line_pressed)


func _vertical_line_pressed(verticalLineNode: Node2D):
    """
    userLine 생성하여 출력, 마커 이동 중엔 X
    """
    if $"../markerManager".isPlaying:
        return
        
    generatingLine = true
    var userLine = horizontalLineScene.instantiate()
    add_child(userLine)
    userLine.isUserLine = true
    userLine.startVerticalNode = verticalLineNode
    userLine.get_node("mesh").modulate = userLineColor
    var posX = verticalLineNode.position.x
    var posY = max(min(get_viewport().get_mouse_position().y, yMax), yMin)
    userLine.setLinePosition(Vector2(posX, posY), Vector2(posX, posY))
                
     
func generateLine(startPos, endPos, type, color):
    """
    레벨 시작 시 수평선 생성
    """
    var horizontalLine = horizontalLineScene.instantiate()
    add_child(horizontalLine)
    if type == "nrm":
        pass
    elif type == "arR":
        pass
    elif type == "arL":
        pass
    elif type == "ice":
        pass
    else:
        pass
    horizontalLine.get_node("mesh").modulate = color
    horizontalLine.setLinePosition(startPos, endPos)

                                                                                        
func _process(_delta):
    if generatingLine:
        setGeneratingUserLine()     
          

func setGeneratingUserLine():
    """
    터치/드래그로 생성중인 userLine 위치조정 및 생성/삭제
    """
    var newline = get_child(-1)
    
    # 터치 중에는 마우스 포인터의 위치를 따라 선 이동
    if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
        var end = get_viewport().get_mouse_position()
        # 수직선에 닿았을 때
        if newline.endVerticalNode:
            end.x = newline.endVerticalNode.position.x
            newline.stickFlg = true
        # 위/아래 범위 내로 지정
        end.y = max(min(end.y, yMax), yMin)
        # 선 자세 설정
        newline.setLinePosition(newline.position, end)
            
    # 터치 종료시 생성 또는 삭제
    else:
        generatingLine = false
        # overlapping 계산이 상대적으로 느려 타이머 사용
        isChecking = true
        await get_tree().create_timer(0.05).timeout
        
        # 삭제 전 터치로 이미 삭제 고려
        if is_instance_valid(newline):
            if not newline.checkIsProper():
                newline.queue_free()
        isChecking = false


func _on_reset_button_pressed():
    if $"../markerManager".isPlaying or isChecking:
        return
        
    for line in get_children():
        if line.isUserLine:
            line.queue_free()
        
