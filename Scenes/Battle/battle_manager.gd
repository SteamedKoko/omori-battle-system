class_name BattleManager
extends Node2D

signal player_turn_end
signal enemy_turn_end

const OMORI_DATA = preload("uid://bd2jyxc6fp1v8")
const AUBREY_DATA = preload("uid://dgybubuhy6o62")
const HERO_DATA = preload("uid://dtb7nn2gdr48b")
const KEL_DATA = preload("uid://dmbkp1igy7jw8")
const SUDO_DATA = preload("uid://bgcmm1twyftdq")

const player_panel_presets: Array[Control.LayoutPreset] = [
	Control.LayoutPreset.PRESET_BOTTOM_LEFT,
	Control.LayoutPreset.PRESET_TOP_LEFT,
	Control.LayoutPreset.PRESET_BOTTOM_RIGHT,
	Control.LayoutPreset.PRESET_TOP_RIGHT,
]

var players: Array[BattlePlayer] = []
var enemies: Array[BattleEnemy] = []
var player_turn_index: int = 0
var players_to_act: Array[BattlePlayer] = []
var player_action_stack: Array[Command] = []

@onready var player_menu: PlayerMenu = %PlayerMenu
@onready var player_panel_container: MarginContainer = %PlayerPanelContainer
@onready var start_menu: Control = %StartMenu
@onready var fight_button: BattleButton = %FightButton
@onready var run_button: BattleButton = %RunButton
@onready var battle_text: RichTextLabel = %BattleText

func _ready():
	player_menu.cancel_pressed.connect(go_previous_player)
	BattleEventBus.player_action_queued.connect(queue_player_action)
	BattleEventBus.sent_battle_text.connect(populate_text)
	start_battle([OMORI_DATA, AUBREY_DATA, KEL_DATA, HERO_DATA], [SUDO_DATA, SUDO_DATA])
	%RunButton.pressed.connect(attempt_run)
	%FightButton.pressed.connect(start_player_menu)
	battle_loop()

func refocus_main_menu() -> void:
	player_menu.hide()
	start_menu.show()
	fight_button.grab_focus()


func populate_text(text: String) -> void:
	battle_text.text = text


func start_battle(init_players: Array[PlayerData], init_enemies: Array[EnemyData]) -> void:
	for i in range(init_players.size()):
		var data: PlayerData = init_players[i]
		var player_panel: PlayerPanel = PlayerPanel.build(player_panel_presets[i], data)
		var player: BattlePlayer = BattlePlayer.new(data, player_panel)
		player_panel_container.add_child(player_panel)
		players.push_back(player)
		add_child(player)

	for i in range(init_enemies.size()):
		var data: EnemyData = init_enemies[i].duplicate(true)
		var enemy: BattleEnemy = BattleEnemy.build(data)
		enemies.push_back(enemy)
		%EnemyContainer.add_child(enemy)


func attempt_run() -> void:
	battle_text.text = "You can't run sucker"
	player_turn_end.emit()

func queue_player_action(command: Command) -> void:
	player_action_stack.push_back(command)
	players_to_act[player_turn_index].unfocus_player()
	go_next_player()

func go_next_player() -> void:
	player_turn_index += 1
	if player_turn_index >= players_to_act.size():
		player_turn_end.emit()
		return

	var current_player: BattlePlayer = players_to_act[player_turn_index]
	current_player.focus_player()
	print('current player ', current_player.player_data.player_name)
	player_menu.load_player(current_player, self)
	if player_turn_index > 0:
		player_menu.open_menu()

func go_previous_player() -> void:
	if player_turn_index <= 0:
		refocus_main_menu()
		return

	players_to_act[player_turn_index].unfocus_player()
	player_turn_index = max(player_turn_index - 1, 0)
	player_action_stack.pop_back()

	var current_player = players_to_act[player_turn_index]
	current_player.focus_player()
	player_menu.load_player(current_player, self)
		

func player_turn_sequence_start() -> void:
	%StartMenu.show()
	%FightButton.grab_focus()
	players_to_act = []
	player_action_stack = []
	player_turn_index = -1
	for player in players:
		if player.is_alive():
			players_to_act.push_back(player)

	go_next_player()


func clean_player_menu() -> void:
	player_menu.hide()
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


func execute_player_actions() -> void:
	for enemy in enemies:
		if enemy.is_alive():
			enemy.target_select(false)

	while(player_action_stack.size() > 0):
		var action: Command = player_action_stack.pop_front()
		await action.execute()

	for enemy in enemies:
		if enemy.is_alive():
			enemy.target_deselect(false)
	

func battle_loop() -> void:
	var player_won = false
	var enemy_won = false

	while(!player_won and !enemy_won):
		player_turn_sequence_start()
		await player_turn_end
		clean_player_menu()

		await execute_player_actions()

		enemy_turn_start()
		await enemy_turn_end

		player_won = enemies.filter(func(e): return e.is_alive()).size() == 0
		enemy_won = players.filter(func(e): return e.is_alive()).size() == 0


	print('ending battle ', player_won, enemy_won)
