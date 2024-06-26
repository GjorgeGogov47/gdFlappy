extends Node

@export var pipe_scene: PackedScene

var game_running : bool
var game_over : bool
var scroll
var score
const SCROLL_SPEED : int = 4
var screen_size : Vector2i
var ground_height : int
var pipes : Array
const PIPE_DELAY : int = 100
const PIPE_RANGE : int = 200

var musicPlaybackVar : float
var musicFLagFirst : bool = true


#Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_window().size
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()
	new_game()

func new_game():
	#reset variables
	game_running = false
	game_over = false
	$GameOver.hide()
	scroll = 0
	score = 0
	$ScoreLabel.text = "Легален кеш: 0"
	#reset pipes
	get_tree().call_group("pipeGroup", "queue_free")
	pipes.clear()
	generate_pipes()
	$Bird.reset()
	

func _input(event):
	if game_over == false:
		if Input.is_action_just_pressed("fly"):
			if game_running == false:
				start_game()
			else:
				if $Bird.flying:
					$Bird.flap()
					check_top()

func start_game():
	game_running = true
	$Bird.flying = true
	$Bird.flap()
	#start pipe timer
	$PipeTimer.start()

#Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_running:
		scroll += SCROLL_SPEED
		#reset scroll
		if scroll >= screen_size.x:
			scroll = 0
		#move ground node
		$Ground.position.x = -scroll
		#move pipes
		for pipe in pipes:
			pipe.position.x -= SCROLL_SPEED


func _on_pipe_timer_timeout():
	generate_pipes()

func generate_pipes():
	var pipe = pipe_scene.instantiate()
	pipe.position.x = screen_size.x + PIPE_DELAY
	pipe.position.y = (screen_size.y - ground_height) / 2 + randi_range(-PIPE_RANGE, PIPE_RANGE)
	pipe.hit.connect(bird_hit)
	pipe.scored.connect(scoredFunc.bind(pipe))
	add_child(pipe)
	pipes.append(pipe)

func scoredFunc(pipeObj):
	score += pipeObj.banknotaScore
	$ScoreLabel.text = "Легален кеш: " + str(score)

func check_top():
	if $Bird.position.y < 0:
		$Bird.falling = true
		stop_game()

func stop_game():
	var fallingVoiceLineIndex : int = randi_range(1,8)
	var fallingVoiceLine : AudioStreamPlayer2D = get_node("FallingSounds/AudioStreamPlayer2D" + str(fallingVoiceLineIndex))
	if fallingVoiceLine is AudioStreamPlayer2D:
		fallingVoiceLine.play()
	
	$PipeTimer.stop()
	$GameOver.getGameScoreAndReset(score)
	$GameOver.show()
	$Bird.flying = false
	game_running = false
	game_over = true
	

func bird_hit():
	$Bird.falling = true
	if game_running == true:
		stop_game()

func _on_ground_hit():
	$Bird/AnimatedSprite2D.play("yamcha")
	$Bird.falling = false
	if game_running == true:
		stop_game()


func _on_game_over_restart():
	$Bird/AnimatedSprite2D.play("ljetivNaKrov")
	new_game()


func _on_music_toggle_pressed():
	var globalMusicNode : AudioStreamPlayer2D = get_node("/root/Music")
	if globalMusicNode is AudioStreamPlayer2D:
		if globalMusicNode.playing:
			musicPlaybackVar = globalMusicNode.get_playback_position()
			globalMusicNode.stop()
		elif !globalMusicNode.playing:
			globalMusicNode.play(musicPlaybackVar)
	
	if musicFLagFirst:
		musicFLagFirst = false
		$warningLabel.show()
		while $warningLabel.modulate.a > 0:
			$warningLabel.modulate.a -= 0.1
			await get_tree().create_timer(0.15).timeout
