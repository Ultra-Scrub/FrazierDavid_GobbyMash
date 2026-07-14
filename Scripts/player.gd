extends CharacterBody3D
class_name Player

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

#get the gravity from the project settings to be synced with RigidBody nodes
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var sensivity = 0.003
var cooldown:bool = false
var gold = 0
var hp = 50
var damage = 10
var maxhp = 50
var target = []

@onready var GoldLabel = $HUD/GoldLabel
@onready var HPBar = $HUD/HPBar
@onready var camera = $Firstperson
@onready var animationplayer = $AnimationPlayer
@onready var attackcooldown = $AttackCoooldown

func player():
	pass

func _ready():
	HPBar.max_value = 50
	$Firstperson.current = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _switch_veiw():
	if Input.is_action_just_pressed("switch"):
		if camera == $Firstperson:
			camera = $Head
			$Head/Thirdperson.current = true
		else:
			camera = $Firstperson
			$Firstperson.current = true

func attack():
	if Input.is_action_just_pressed("attack") and cooldown == false:
		animationplayer.play("SwordSwing")
		cooldown = true
		attackcooldown.start()

func deal_damage():
	target.hp -= damage

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sensivity)
		camera.rotate_x(-event.relative.y * sensivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(70))

func update_HUD():
	HPBar.value = hp
	GoldLabel.text = str(gold)

func _process(_delta):
	update_HUD()
	attack()
	_switch_veiw()
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _on_attack_coooldown_timeout() -> void:
	cooldown = false
	pass # Replace with function body.


func _on_attackzone_body_entered(body: Node3D) -> void:
	if body.has_method("enemy"):
		target.append(body)


func _on_attackzone_body_exited(body: Node3D) -> void:
	if body.has_method("enemy"):
		target.erase(body)
