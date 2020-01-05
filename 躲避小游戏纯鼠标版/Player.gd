extends Area2D

signal hit

export var speed = 400
var extents
var screen_size
var this_viewport
var jid = Vector2()

func _ready():
	screen_size = get_viewport_rect().size
	hide()


func yidon(delta):
	var velocity = Vector2()
	
	if Input.is_action_pressed("click"):
		this_viewport = get_viewport().get_mouse_position()
		velocity.x = this_viewport.x - jid.x
		velocity.y = this_viewport.y - jid.y
		if this_viewport.y > jid.y:
			$AnimatedSprite.animation = "up"
			$AnimatedSprite.flip_v = true
		else:
			$AnimatedSprite.animation = "right"
			$AnimatedSprite.flip_v = false
		# 此处为简写，判断布尔=真情况 
		$AnimatedSprite.flip_h = this_viewport.x < jid.x
	if velocity.length() > 0:
        $AnimatedSprite.play()
	else:
        $AnimatedSprite.stop()
	position += velocity * delta
	# 做一个限制，不然就出屏幕了。
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	jid = position


func _process(delta):
	yidon(delta)

func _on_Player_body_entered(body):
	hide()
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
