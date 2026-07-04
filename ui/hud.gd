extends CanvasLayer

@onready var _lives_label: Label = $Panel/VBox/Lives/LivesLabel
@onready var _coins_label: Label = $Panel/VBox/Coins/CoinsLabel
@onready var _wave_label: Label = $Panel/VBox/WaveLabel


func _process(_delta: float) -> void:
	_lives_label.text = str(GameState.lives)
	_coins_label.text = str(GameState.coins)
	_wave_label.text = "Wave " + str(GameState.wave_number)
