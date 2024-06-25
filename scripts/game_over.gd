extends CanvasLayer

signal restart

func _on_restart_button_pressed():
	restart.emit()

func _ready():
	for i in range(1,1000):
		$ColorRect/leaderBoardScroll/leaderBoardLabel.text += str(i) +  ". boyyy\n"
	#$HTTPRequest.request_completed.connect(_on_request_completed)
	#$HTTPRequest.request("https://nagrujofunkcijata47.azurewebsites.net/api/GetItems")
#
#func _on_request_completed(result, response_code, headers, body):
	#var json = JSON.parse_string(body.get_string_from_utf8())
	#for row in json:
		#$ScrollContainer/Label.text += "ID: " + row["id"] + "    Title: " + row["title"] + "\n"
	#


func _on_leaderboards_button_pressed():
	$ColorRect.size.y = 481
	$ColorRect.position.y = 79
	
	$ColorRect/RestartButton.position.x = 3
	$ColorRect/RestartButton.position.y = 422
	
	$ColorRect/EnterScoreButton.position.x = 333
	$ColorRect/EnterScoreButton.position.y = 422
	
	$ColorRect/LeaderboardsButton.hide()
	$ColorRect/leaderBoardScroll.show()
	$ColorRect/RefreshButton.show()
	$ColorRect/scoreCalculationLabel.hide()
	


func _on_enter_score_button_pressed():
	$ColorRect/RestartButton.hide()
	$ColorRect/LeaderboardsButton.hide()
	$ColorRect/EnterScoreButton.hide()
	$ColorRect/UserTextInput.show()
	$ColorRect/EnterUsernameButton.show()
	$ColorRect/leaderBoardScroll.hide()
	$ColorRect/RefreshButton.hide()
	$ColorRect/scoreCalculationLabel.hide()
	
	$ColorRect.size.y = 176
	$ColorRect.position.y = 384
	
	$ColorRect/RestartButton.position.x = 164
	$ColorRect/RestartButton.position.y = 8
	
	$ColorRect/EnterScoreButton.position.x = 332
	$ColorRect/EnterScoreButton.position.y = 168
	
	$ColorRect/LeaderboardsButton.position.x = 4
	$ColorRect/LeaderboardsButton.position.y = 168

func _on_enter_username_button_pressed():
	$ColorRect/RestartButton.show()
	$ColorRect/LeaderboardsButton.show()
	$ColorRect/EnterScoreButton.show()
	$ColorRect/UserTextInput.hide()
	$ColorRect/EnterUsernameButton.hide()
	$ColorRect/scoreCalculationLabel.show()
	
	$ColorRect.size.y = 224
	$ColorRect.position.y = 360
	
	#JSON

func getGameScoreAndReset(gameOverScore):
	
	$ColorRect.size.y = 224
	$ColorRect.position.y = 360
	
	$ColorRect/RestartButton.position.x = 164
	$ColorRect/RestartButton.position.y = 8
	
	$ColorRect/EnterScoreButton.position.x = 332
	$ColorRect/EnterScoreButton.position.y = 168
	
	$ColorRect/LeaderboardsButton.position.x = 4
	$ColorRect/LeaderboardsButton.position.y = 168
	
	$ColorRect/LeaderboardsButton.show()
	$ColorRect/leaderBoardScroll.hide()
	$ColorRect/RefreshButton.hide()
	$ColorRect/scoreCalculationLabel.show()
	
	$ColorRect/scoreCalculationLabel.text = "Браво, сега можеш да купиш\n"
	$ColorRect/scoreCalculationLabel.text += str((float(gameOverScore)/3692000)*100).pad_decimals(3) + "% од скопски стан"
