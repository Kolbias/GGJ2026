extends Node2D

var starting_location := Vector2i(0, 3)
var finish_location := Vector2i(7, 3)
var map = Array()

var rooms = {
	0: " ",
	1: "⊤",
	2: "⊢",
	3: "⊥",
	4: "⊣"
}

var handledMap = Array()

func _ready():
	for i in range(7):
		var row = Array()
		row.resize(8)
		row.fill(" ")
		map.append(row)
	
	for row in range(7):
		for col in range(8):
			var possibilities = [0, 1, 2, 3, 4]
			var loc = Vector2i(col, row)
			if loc == starting_location:
				print("made it to start")
				print(loc)
				possibilities = [1, 3, 4] 
			elif loc == finish_location:
				print("made it to end")
				print(loc)
				possibilities = [1, 2, 3]
			handledMap.append([loc, possibilities])
	
	collapse()
	
	for row in map:
		print(row)

func collapse():
	var changes = true
	while changes:
		changes = false
		handledMap.sort_custom(
			func(a, b): return a[1].size() < b[1].size()
		)
		
		for cell in handledMap:
			if cell[1].size() == 1:
				pass
			
	
	print(handledMap)
