extends Area2D

signal hit
signal scored
var banknotaScore : int


func _ready():
	match randi_range(1,5):
		1:
			$ScoreArea/BanknoteSprite.texture = load("res://assets/sprites/banknoti/banknoti10.jpg")
			banknotaScore = 10
			$ScoreArea/coinCollectStream.stream = load("res://assets/audio/banknotiSounds/sound10.mp3")
		2:
			$ScoreArea/BanknoteSprite.texture = load("res://assets/sprites/banknoti/banknoti50.jpg")
			banknotaScore = 50
			$ScoreArea/coinCollectStream.stream = load("res://assets/audio/banknotiSounds/sound50.mp3")
		3:
			$ScoreArea/BanknoteSprite.texture = load("res://assets/sprites/banknoti/banknoti100.jpg")
			banknotaScore = 100
			$ScoreArea/coinCollectStream.stream = load("res://assets/audio/banknotiSounds/sound100.mp3")
		4:
			$ScoreArea/BanknoteSprite.texture = load("res://assets/sprites/banknoti/banknoti500.jpg")
			banknotaScore = 500
			$ScoreArea/coinCollectStream.stream = load("res://assets/audio/banknotiSounds/sound500.mp3")
		5:
			$ScoreArea/BanknoteSprite.texture = load("res://assets/sprites/banknoti/banknoti1000.jpg")
			banknotaScore = 1000
			$ScoreArea/coinCollectStream.stream = load("res://assets/audio/banknotiSounds/sound1000.mp3")
	var yo = $ScoreArea/coinCollectStream
	if yo is AudioStreamPlayer2D:
		yo.volume_db = -15

func _on_body_entered(body):
	hit.emit()


func _on_score_area_body_entered(body):
	if $ScoreArea/BanknoteSprite != null:
		scored.emit()
		$ScoreArea/BanknoteSprite.queue_free()
		$ScoreArea/coinCollectStream.play()
