extends Node2D

const LINE_WIDTH = 20
const LINE_MARGIN = 30
const VERTICAL_OFFSET_Y = 300
const VERTICAL_INTERVAL_ARRAY = [0, 0, 150, 100, 50]
const VERTICAL_HEIGHT = 700
const MARKER_OFFSET = 20
const MARKER_RADIUS = 20

signal generateVerticalLine(pos)
signal generateHorizontalLine(startPos, endPos, type)
signal generateStartMarker(pos, color)
signal generateEndMarker(pos, color)

var boardMap1 = [[1, 0],
                 [0, 1],
                 [2, 2],]
var lines1 = {type = ["nrm", "nrm"],
              colorDot = [Color(1, 0, 0), null],}
                           
                              
func _ready():
    createBoard(boardMap1, lines1)
    
    
func createBoard(boardMap, lines):
    """
    보드정보에 맞추어 보드 생성
    """
    var mapSize = [boardMap.size(), boardMap[0].size()]
    var verticalInterval = VERTICAL_INTERVAL_ARRAY[mapSize[1]]
    var verticalX = (get_viewport_rect().size[0] - verticalInterval * (mapSize[1] - 1)) * 0.5
    var verticalPos = []
    for verticalIdx in range(mapSize[1]):
        var pos = Vector2(verticalX, VERTICAL_OFFSET_Y)
        verticalPos.append(pos)
        verticalX += verticalInterval
        
        emit_signal("generateVerticalLine", pos)
        emit_signal("generateStartMarker", pos - Vector2(0, MARKER_OFFSET), 0)
        emit_signal("generateEndMarker", pos + Vector2(0, MARKER_OFFSET + VERTICAL_HEIGHT), 0)
        #  마커 색 전달 필요
    
    var gridHeight = (VERTICAL_HEIGHT - 2 * LINE_MARGIN) / (mapSize[0] + 1)
    for lineIdx in range(lines.type.size()):
        
        # 해당 선의 보드상의 위치 찾기
        var posIdx = []
        for yIdx in range(mapSize[0]):
            for xIdx in range(mapSize[1]):
                if boardMap[yIdx][xIdx] == lineIdx + 1:
                    posIdx.append([yIdx, xIdx])
            if posIdx.size() == 2:
                break
        
        var startPos = Vector2(verticalPos[posIdx[0][1]].x,
                               VERTICAL_OFFSET_Y + LINE_MARGIN + gridHeight * (posIdx[0][0] + 1))
        var endPos = Vector2(verticalPos[posIdx[1][1]].x,
                               VERTICAL_OFFSET_Y + LINE_MARGIN + gridHeight * (posIdx[1][0] + 1))
        emit_signal("generateHorizontalLine", startPos, endPos, lines.type[lineIdx])
        # colorDot 정보 전달 필요
        
        







