extends Node2D
@export var counter : int = 3
@export var speed : int = 200
@export var id : int
var state : int = 0
var nextX : float
var direction : int = 0
const death_timer = preload("res://scenes/misc/delete_component.tscn")
var drop
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.get_parent().global_position.y = 255
	var spot_on_screen_to_spawn_at : int = randi() % 2
	match spot_on_screen_to_spawn_at:
		0:
			self.get_parent().global_position.x = 0
		1:
			self.get_parent().global_position.x = 1900


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(get_parent().global_position.x, ":",get_parent().global_position.y)
	# IF we aren't moving and we aren't dropping items, then we should find a new spot to go
	match state:
		0:
			nextX = randi() % 1300 + 450
			#nextX = 550.0	
			state = 1
			direction = 1 if get_parent().global_position.x - nextX  <= 0 else -1 # Go Left if we are to the right, otherwise go right
			get_parent().get_node("AnimatedSprite2D").flip_h = true if direction == 1 else false
			return
		# We have a spot to go to but we aren't there yet
		1:
			self.get_parent().global_position.x += direction * speed * delta
			#print(int(self.get_parent().global_position.x),":",nextX)
			if check_in_range(self.get_parent().global_position.x,nextX, speed * delta):
				state = 2
			return
		# We have arrived at our spot but we haven't dropped an item yet
		2:
			get_spawnable_drop()
			self.get_parent().add_child(drop)
			state = 3
			return
		# We have run out of things to drop, so lets' be set to despawn!
		3:
			if self.counter == 0:
				self.state = 4
				nextX = randi() % 2
				nextX = 0 if nextX == 0 else 1900
				direction = 1 if get_parent().global_position.x - nextX  <= 0 else -1 # Go Left if we are to the right, otherwise go right
				#get_parent().queue_free()
			return
		# Move towards our despawn position
		4:
			self.get_parent().global_position.x += direction * speed * delta
			#print(int(self.get_parent().global_position.x),":",nextX)
			if check_in_range(self.get_parent().global_position.x,nextX, speed * delta):
				state = 5
			get_parent().get_node("AnimatedSprite2D").flip_h = true if direction == 1 else false
			return
		# We are at our despawn position, so despawn
		5:
			self.get_parent().get_parent().entities_spawned -= 1
			self.get_parent().queue_free()
			
	
# Gets what type of drop we need to drop from the parent then we can pass it to this component
func get_spawnable_drop():
	# For chandler/kris ships which need multiple drops
	if self.id == 2 or self.id == 3:
		match randi() % 2:
			0:
				drop = get_parent().spawnable_drop1.instantiate()
			1:
				drop = get_parent().spawnable_drop2.instantiate()
		return
	drop = get_parent().spawnable_drop.instantiate()
	

func check_in_range(a : float, b : float , range : int ) -> bool:
	if a > b:
		if a - b < range:
			return true
	if a < b:
		if b - a < range:
			return true
	return false
		
