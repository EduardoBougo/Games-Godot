extends Node

signal score_update
signal freeze

var highscore := 0

# --- Variavel Player Global ---
var player

# --- Variavel Score Global ---
var score : = 0:
	set(value):
		score = value
		score_update.emit(value)
		if score > highscore:
			highscore = score
