extends Area2D

signal hit

export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.


func _ready():
	screen_size = get_viewport_rect().size
	hide()


func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right2"):
		velocity.x += 1
	if Input.is_action_pressed("move_left2"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down2"):
		velocity.y += 1
	if Input.is_action_pressed("move_up2"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2.play()
	else:
		$AnimatedSprite2.stop()

	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	if velocity.x != 0:
		$AnimatedSprite2.animation = "walk2"
		$AnimatedSprite2.flip_v = false
		$AnimatedSprite2.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2.animation = "up2"
		$AnimatedSprite2.flip_v = velocity.y > 0


func start(pos):
	position = pos
	show()
	$CollisionShape2D2.disabled = false


func _on_Player2_body_entered (_body):
	hide() # Player disappears after being hit.
	emit_signal("hit")
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D2.set_deferred("disabled", true)



