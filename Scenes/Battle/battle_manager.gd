class_name BattleManager
extends Node2D

var players: Array[BattlePlayer] = []
var enemies: Array[BattleEnemy] = []

const OMORI_DATA = preload("uid://bd2jyxc6fp1v8")
const AUBREY_DATA = preload("uid://dgybubuhy6o62")
const HERO_DATA = preload("uid://dtb7nn2gdr48b")
const KEL_DATA = preload("uid://dmbkp1igy7jw8")
const SUDO_STATS = preload("uid://bv83gxiv347g4")

func _ready():
	battle_loop()

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

	var omori: BattlePlayer = BattlePlayer.new(OMORI_DATA)
	var kel: BattlePlayer = BattlePlayer.new(KEL_DATA)
	var aubrey: BattlePlayer = BattlePlayer.new(AUBREY_DATA)
	var hero: BattlePlayer = BattlePlayer.new(HERO_DATA)

	var enemy: BattleEnemy = BattleEnemy.new(SUDO_STATS)

	players.push_back(omori)
	players.push_back(kel)
	players.push_back(hero)
	players.push_back(aubrey)

	enemies.push_back(enemy)

	add_child(omori)
	add_child(aubrey)
	add_child(kel)
	add_child(hero)

	add_child(enemy)



func end_battle() -> void:
	pass

func battle_loop() -> void:
	start_battle()

	var player_won = false
	var enemy_won = false

	while(!player_won and !enemy_won):
		for player in players:
			if player.is_alive():
				var to_attack: Array[BattleEnemy] = enemies.filter(func(e): return e.is_alive())
				player.act(to_attack)
				await player.acted

		for enemy in enemies:
			if enemy.is_alive():
				var to_attack: Array[BattlePlayer] = players.filter(func(e): return e.is_alive())
				if !to_attack:
					break
				enemy.act(to_attack)
				await enemy.acted

		player_won = enemies.filter(func(e): return e.is_alive()).size() == 0
		enemy_won = players.filter(func(e): return e.is_alive()).size() == 0


	print('ending battle ', player_won, enemy_won)
	end_battle()
