extends CanvasLayer

signal restart
var achievedScore : int
var lastPlaceScore : int

func _on_restart_button_pressed():
	restart.emit()

func _on_leaderboards_button_pressed():
	if !$HTTPRequest.request_completed.is_connected(_on_get_request_completed):
		$HTTPRequest.request_completed.connect(_on_get_request_completed)
	$HTTPRequest.request("https://nagrujofunkcijata.azurewebsites.net/api/GetRows")
	
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
	$ColorRect/EnterUsernameButton.disabled = true
	$ColorRect/EnterScoreButton.disabled = true
	if (lastPlaceScore == 0 or lastPlaceScore < achievedScore) and $ColorRect/UserTextInput.text != "":
		if !$HTTPRequest.request_completed.is_connected(_on_post_request_completed):
			$HTTPRequest.request_completed.connect(_on_post_request_completed)
		var json = JSON.stringify(
		{
			"playerName": $ColorRect/UserTextInput.text,
			"playerScore": achievedScore
		})
		var headers = ["Content-Type: application/json"]
		$HTTPRequest.request("https://nagrujofunkcijata.azurewebsites.net/api/InsertRow", headers, HTTPClient.METHOD_POST, json)
	
	
	$ColorRect/RestartButton.show()
	$ColorRect/LeaderboardsButton.show()
	$ColorRect/EnterScoreButton.show()
	$ColorRect/UserTextInput.hide()
	$ColorRect/EnterUsernameButton.hide()
	$ColorRect/scoreCalculationLabel.show()
	
	$ColorRect.size.y = 224
	$ColorRect.position.y = 360
	
	$ColorRect/UserTextInput.text=""
	

func getGameScoreAndReset(gameOverScore):
	achievedScore = gameOverScore
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

func _on_get_request_completed(_result, _response_code, _headers, body):
	$ColorRect/leaderBoardScroll/leaderBoardLabel.text = ""
	var json = JSON.parse_string(body.get_string_from_utf8())
	var brojac = 1
	
	if json != null:
		lastPlaceScore = json[len(json)-1]["playerScore"]
		
		for row in json:
			$ColorRect/leaderBoardScroll/leaderBoardLabel.text += str(brojac) + ". " + row["playerName"] + "    Score: " + str(row["playerScore"]) + "\n"
			brojac += 1
	

func _on_post_request_completed(_result, _response_code, _headers, body):
	pass


func _on_refresh_button_pressed():
	$ColorRect/RefreshButton.disabled = true
	if !$HTTPRequest.request_completed.is_connected(refreshLeaderboard):
		$HTTPRequest.request_completed.connect(refreshLeaderboard)
	$HTTPRequest.request("https://nagrujofunkcijata.azurewebsites.net/api/GetRows")
	await get_tree().create_timer(10).timeout 
	$ColorRect/RefreshButton.disabled = false
	
func refreshLeaderboard(_result, _response_code, _headers, body):
	$ColorRect/leaderBoardScroll/leaderBoardLabel.text = ""
	var json = JSON.parse_string(body.get_string_from_utf8())
	var brojac = 1
	
	if !json == null:
		lastPlaceScore = json[len(json)-1]["playerScore"]
		
		for row in json:
			$ColorRect/leaderBoardScroll/leaderBoardLabel.text += str(brojac) + ". " + row["playerName"] + "    Score: " + str(row["playerScore"]) + "\n"
			brojac += 1


func _on_visibility_changed():
	$ColorRect/EnterUsernameButton.disabled = false
	$ColorRect/EnterScoreButton.disabled = false
