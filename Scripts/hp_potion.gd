extends Node3D


@export var rotation_speed :float = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate_y(rotation_speed * delta)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		queue_free()
