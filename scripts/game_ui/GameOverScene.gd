extends Node2D


@onready var current_score: Label = $CurrentScore
@onready var highest_score: Label = $HighestScore


func _process(delta: float) -> void:
	current_score.text = "Your score: " + str(global_var.current_score)
	highest_score.text = "Record: " + str(global_var.record_score)
