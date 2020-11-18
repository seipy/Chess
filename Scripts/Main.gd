extends Spatial

var Pawn = preload("res://Scenes/Pawn.tscn")
var Rook = preload("res://Scenes/Rook.tscn")
var Knight = preload("res://Scenes/Knight.tscn")
var Bishop = preload("res://Scenes/Bishop.tscn")
var Queen = preload("res://Scenes/Queen.tscn")
var King = preload("res://Scenes/King.tscn")
var Move = preload("res://Scenes/Move.tscn")

var map_
var select_
var mesh_
var name_
var moves_ = []
var moveMesh_

#export (PackedScene) var Pawn
#export (PackedScene) var Figure

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	
	
	
	map_ = []
	var map = map_
	map.resize(8)
	for pos in range(8):
		map[pos] = []
		map[pos].resize(8)
	
	for Pawns in range(8):
		var B_pawn = Pawn.instance()
		B_pawn.resetColor("black")
		map[6][Pawns] = B_pawn
		add_child(B_pawn)
		var W_pawn = Pawn.instance()
		W_pawn.resetColor("white")
		map[1][Pawns] = W_pawn
		add_child(W_pawn)
	
	for Else in [0,7]:
		var B_Rook = Rook.instance()
		B_Rook.resetColor("black")
		map[7][Else] = B_Rook
		add_child(B_Rook)
		var W_Rook = Rook.instance()
		W_Rook.resetColor("white")
		map[0][Else] = W_Rook
		add_child(W_Rook)
		
		var B_Knight = Knight.instance()
		B_Knight.resetColor("black")
		map[7][1+Else*5/7] = B_Knight
		add_child(B_Knight)
		var W_Knight = Knight.instance()
		W_Knight.resetColor("white")
		map[0][6+Else*-5/7] = W_Knight
		add_child(W_Knight)
		
		var B_Bishop = Bishop.instance()
		B_Bishop.resetColor("black")
		map[7][2+Else*3/7] = B_Bishop
		add_child(B_Bishop)
		var W_Bishop = Bishop.instance()
		W_Bishop.resetColor("white")
		map[0][5+Else*-3/7] = W_Bishop
		add_child(W_Bishop)
		
	var B_Queen = Queen.instance()
	B_Queen.resetColor("black")
	map[7][4] = B_Queen
	add_child(B_Queen)
	var W_Queen = Queen.instance()
	W_Queen.resetColor("white")
	map[0][4] = W_Queen
	add_child(W_Queen)
	
	var B_King = King.instance()
	B_King.resetColor("black")
	map[7][3] = B_King
	add_child(B_King)
	var W_King = King.instance()
	W_King.resetColor("white")
	map[0][3] = W_King
	add_child(W_King)
	
	print(map)
	
	for Load in range(8):
		for Load2 in range(8):
			var figure = map[Load][Load2]
			if figure != null:
				figure.set_translation(Vector3(Load*3-10.5,10,Load2*3-10.5))
	

#	for PawnLoad in range(8):
#		var pawn = Figure.instance()
#		add_child(pawn)
#		pawn.set_translation(Vector3(7.5,3,PawnLoad*3-10.5))
	
#	figure.position =
# Called every frame. 'delta' is the elapsed time since the previous frame.
func getSelectPosition():
	for check in range(8):
		for check2 in range(8):
			if map_[check][check2] == select_:
				print(check,check2)
				return [check,check2]

func select(select,color):
	for i in moves_:
		i.queue_free()
	moves_.clear()
	
	select_ = select
	var pos = getSelectPosition()
	var pos1 = pos[0]
	var pos2 = pos[1]
	var move_side
	var dont1 = false
	var dont2 = false
	var dont3 = false
	var dont4 = false
	var dont5 = false
	var dont6 = false
	var dont7 = false
	var dont8 = false
	var move_position_y
	var move_position_x
	if name_ == "pawn":
		if color == "white":
			move_side = +2
		if color == "black":
			move_side = -1
		for move_pawn in range (2):
			move_position_y = pos1-move_pawn+move_side
			move_position_x = pos2
			addMoves(move_position_y,move_position_x,color)
	if name_ == "rook":
		for move_rook in range (1,8):
			if dont1 == false:
				move_position_y = pos1-move_rook
				move_position_x = pos2
				dont1 = addMoves(move_position_y,move_position_x,color)
			if dont2 == false:
				move_position_y = pos1+move_rook
				move_position_x = pos2
				dont2 = addMoves(move_position_y,move_position_x,color)
			if dont3 == false:
				move_position_y = pos1
				move_position_x = pos2-move_rook
				dont3 = addMoves(move_position_y,move_position_x,color)
			if dont4 == false:
				move_position_y = pos1
				move_position_x = pos2+move_rook
				dont4 = addMoves(move_position_y,move_position_x,color)
	if name_ == "knight":
		for move_knight in [0,1]:
			move_position_y = pos1+2+(move_knight*-1)
			move_position_x = pos2+1+(move_knight*+1)
			addMoves(move_position_y,move_position_x,color)

			move_position_y = pos1+2+(move_knight*-1)
			move_position_x = pos2-1+(move_knight*-1)
			addMoves(move_position_y,move_position_x,color)

			move_position_y = pos1-2+move_knight*+1
			move_position_x = pos2+1+move_knight*+1
			addMoves(move_position_y,move_position_x,color)

			move_position_y = pos1-2+move_knight*+1
			move_position_x = pos2-1+move_knight*-1
			addMoves(move_position_y,move_position_x,color)
	if name_ == "bishop":
		for move_bishop in range (1,8):
			if dont1 == false:
				move_position_y = pos1-move_bishop
				move_position_x = pos2+move_bishop
				dont1 = addMoves(move_position_y,move_position_x,color)
			if dont2 == false:
				move_position_y = pos1+move_bishop
				move_position_x = pos2+move_bishop
				dont2 = addMoves(move_position_y,move_position_x,color)
			if dont3 == false:
				move_position_y = pos1+move_bishop
				move_position_x = pos2-move_bishop
				dont3 = addMoves(move_position_y,move_position_x,color)
			if dont4 == false:
				move_position_y = pos1-move_bishop
				move_position_x = pos2-move_bishop
				dont4 = addMoves(move_position_y,move_position_x,color)
	if name_ == "queen":
		for move_queen in range (1,8):
			if dont1 == false:
				move_position_y = pos1-move_queen
				move_position_x = pos2
				dont1 = addMoves(move_position_y,move_position_x,color)
			if dont2 == false:
				move_position_y = pos1+move_queen
				move_position_x = pos2
				dont2 = addMoves(move_position_y,move_position_x,color)
			if dont3 == false:
				move_position_y = pos1
				move_position_x = pos2-move_queen
				dont3 = addMoves(move_position_y,move_position_x,color)
			if dont4 == false:
				move_position_y = pos1
				move_position_x = pos2+move_queen
				dont4 = addMoves(move_position_y,move_position_x,color)
			if dont5 == false:
				move_position_y = pos1-move_queen
				move_position_x = pos2+move_queen
				dont5 = addMoves(move_position_y,move_position_x,color)
			if dont6 == false:
				move_position_y = pos1+move_queen
				move_position_x = pos2+move_queen
				dont6 = addMoves(move_position_y,move_position_x,color)
			if dont7 == false:
				move_position_y = pos1+move_queen
				move_position_x = pos2-move_queen
				dont7 = addMoves(move_position_y,move_position_x,color)
			if dont8 == false:
				move_position_y = pos1-move_queen
				move_position_x = pos2-move_queen
				dont8 = addMoves(move_position_y,move_position_x,color)
	if name_ == "king":
		move_position_y = pos1-1
		move_position_x = pos2
		addMoves(move_position_y,move_position_x,color)
		
		move_position_y = pos1+1
		move_position_x = pos2
		addMoves(move_position_y,move_position_x,color)
		
		move_position_y = pos1
		move_position_x = pos2-1
		addMoves(move_position_y,move_position_x,color)
		
		move_position_y = pos1
		move_position_x = pos2+1
		addMoves(move_position_y,move_position_x,color)
		
		move_position_y = pos1-1
		move_position_x = pos2+1
		addMoves(move_position_y,move_position_x,color)
		
		move_position_y = pos1+1
		move_position_x = pos2+1
		addMoves(move_position_y,move_position_x,color)
		
		move_position_y = pos1+1
		move_position_x = pos2-1
		addMoves(move_position_y,move_position_x,color)
		
		move_position_y = pos1-1
		move_position_x = pos2-1
		addMoves(move_position_y,move_position_x,color)

func addMoves(move_position_y,move_position_x,color):
	var move = Move.instance()
	var dont
	move.setPosition([move_position_y,move_position_x])
	if (move_position_x < 8 && move_position_x >= 0) && (move_position_y < 8 && move_position_y > -1):
		if map_[move_position_y][move_position_x] == null:
			add_child(move)
			moves_.append(move)
			move.set_translation(Vector3((move_position_y)*3-10.5,0.7,move_position_x*3-10.5))
			dont = false
		else:
			dont = true
			if map_[move_position_y][move_position_x].getColor() != color: 
	#			vyhozeni
				add_child(move)
				moves_.append(move)
				moveMesh_.set_surface_material(0, preload("res://Materials/red_material.tres"))
				move.set_translation(Vector3((move_position_y)*3-10.5,0.7,move_position_x*3-10.5))
	return dont
					
func getMoveMesh(moveMesh):
	moveMesh_ = moveMesh

func move(move_position):
	select_.set_translation(Vector3(move_position[0]*3-10.5,10,move_position[1]*3-10.5))
	for i in moves_:
		i.queue_free()
	moves_.clear()
	var select_pos = getSelectPosition()
	map_[select_pos[0]][select_pos[1]] = null
	map_[move_position[0]][move_position[1]] = select_
#	select_.get_child(0).sleeping = false
func who(name):
	name_ = name
	print(name_)

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if select_:
				select_.resetColor(select_.getColor())
				for i in moves_:
					i.queue_free()
				moves_.clear()


#func _process(delta: float) -> void:
##	for Load in range(8):
##		for Load2 in range(8):
##			var figure = map_[Load][Load2]
##			figure.unSelectLast()
#
#
#
#	pass
