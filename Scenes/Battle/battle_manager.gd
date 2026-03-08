class_name BattleManager
extends Node2D

var players: Array[BattlePlayer] = []
var enemies: Array[BattleEnemy] = []

signal player_turn_end
signal enemy_turn_end

@onready var player_menu: PlayerMenu = %PlayerMenu
@onready var start_menu: Control = %StartMenu
@onready var fight_button: BattleButton = %FightButton
@onready var battle_text: RichTextLabel = %BattleText

const OMORI_DATA = preload("uid://bd2jyxc6fp1v8")
const AUBREY_DATA = preload("uid://dgybubuhy6o62")
const HERO_DATA = preload("uid://dtb7nn2gdr48b")
const KEL_DATA = preload("uid://dmbkp1igy7jw8")
const SUDO_STATS = preload("uid://bv83gxiv347g4")

func _ready():
	player_menu.closed_menu.connect(refocus_main_menu)
	BattleEventBus.sent_battle_text.connect(populate_text)
	battle_loop()

func refocus_main_menu() -> void:
	start_menu.show()
	%FightButton.grab_focus()


func populate_text(text: String) -> void:
	battle_text.text = text


func start_battle() -> void:
	#player panels
	var omori_panel: PlayerPanel = PlayerPanel.build(Control.LayoutPreset.PRESET_BOTTOM_LEFT, OMORI_DATA)
	var kel_panel = PlayerPanel.build(Control.LayoutPreset.PRESET_BOTTOM_RIGHT, KEL_DATA)
	var aubrey_panel = PlayerPanel.build(Control.LayoutPreset.PRESET_TOP_LEFT, AUBREY_DATA)
	var hero_panel = PlayerPanel.build(Control.LayoutPreset.PRESET_TOP_RIGHT, HERO_DATA)
	%PlayerPanelContainer.add_child(omori_panel)
	%PlayerPanelContainer.add_child(kel_panel)
	%PlayerPanelContainer.add_child(aubrey_panel)
	%PlayerPanelContainer.add_child(hero_panel)

	var omori: BattlePlayer = BattlePlayer.new(OMORI_DATA, omori_panel)
	var kel: BattlePlayer = BattlePlayer.new(KEL_DATA, kel_panel)
	var aubrey: BattlePlayer = BattlePlayer.new(AUBREY_DATA, aubrey_panel)
	var hero: BattlePlayer = BattlePlayer.new(HERO_DATA, hero_panel)

	var enemy: BattleEnemy = BattleEnemy.new(SUDO_STATS)

	players.push_back(omori)
	players.push_back(aubrey)
	players.push_back(kel)
	players.push_back(hero)

	enemies.push_back(enemy)

	add_child(omori)
	add_child(aubrey)
	add_child(kel)
	add_child(hero)

	add_child(enemy)

	%RunButton.pressed.connect(attempt_run)
	%FightButton.pressed.connect(start_player_menu)


func end_battle() -> void:
	pass


func attempt_run() -> void:
	battle_text.text = "You can't run sucker"
	player_turn_end.emit()


func player_turn_start() -> void:
	#select fight or run
	#show menu fight run
	%StartMenu.show()
	%FightButton.grab_focus()
	for player in players:
		if player.is_alive():
			var to_attack: Array[BattleEnemy] = enemies.filter(func(e): return e.is_alive())
			player_menu.load_player(player)
			player.act(to_attack)
			await player.acted

	player_turn_end.emit()


func clean_player_menu() -> void:
	%PlayerMenu.hide()
	%StartMenu.hide()


func start_player_menu() -> void:
	%StartMenu.hide()
	%PlayerMenu.show()
	%PlayerMenu.open_menu()


func enemy_turn_start() -> void:
	for enemy in enemies:
		if enemy.is_alive():
			var to_attack: Array[BattlePlayer] = players.filter(func(e): return e.is_alive())
			if !to_attack:
				break
			enemy.act(to_attack)
			await enemy.acted
	
	enemy_turn_end.emit()


func battle_loop() -> void:
	start_battle()

	var player_won = false
	var enemy_won = false

	while(!player_won and !enemy_won):
		player_turn_start()
		await player_turn_end
		await clean_player_menu()

		enemy_turn_start()
		await enemy_turn_end

		player_won = enemies.filter(func(e): return e.is_alive()).size() == 0
		enemy_won = players.filter(func(e): return e.is_alive()).size() == 0


	print('ending battle ', player_won, enemy_won)
	end_battle()
