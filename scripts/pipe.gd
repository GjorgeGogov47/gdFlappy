extends Area2D

signal hit
signal scored
var banknotaScore : int


func _ready():
	match randi_range(1,5):
		1:
			$ScoreArea/BanknoteSprite.texture=load("res://assets/sprites/banknoti/banknoti10.jpg")
			banknotaScore = 10
		2:
			$ScoreArea/BanknoteSprite.texture=load("res://assets/sprites/banknoti/banknoti50.jpg")
			banknotaScore = 50
		3:
			$ScoreArea/BanknoteSprite.texture=load("res://assets/sprites/banknoti/banknoti100.jpg")
			banknotaScore = 100
		4:
			$ScoreArea/BanknoteSprite.texture=load("res://assets/sprites/banknoti/banknoti500.jpg")
			banknotaScore = 500
		5:
			$ScoreArea/BanknoteSprite.texture=load("res://assets/sprites/banknoti/banknoti1000.jpg")
			banknotaScore = 1000

func _on_body_entered(body):
	hit.emit()


func _on_score_area_body_entered(body):
	if $ScoreArea/BanknoteSprite != null:
		scored.emit()
		$ScoreArea/BanknoteSprite.queue_free()
