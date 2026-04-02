class_name BattleAudioManager
extends Node

@onready var music_stream_player = AudioStreamPlayer.new()
@onready var sound_effect_stream_player = AudioStreamPlayer.new()

const SUDO_THEME = preload("uid://dcvdgp11h2ree")
const SYS_MOVE = preload("uid://c28thvl6kw0if")
const SYS_BUZZER = preload("uid://dmdsckhgutssy")
const SYS_CANCEL = preload("uid://b6yyc16r0c3pl")
const SYS_SELECT = preload("uid://ccn81gj75vu5v")

func _ready() -> void:
	music_stream_player.bus = "Music"
	sound_effect_stream_player.bus = "SoundEffect"
	add_child(music_stream_player)
	add_child(sound_effect_stream_player)

	BattleEventBus.queued_sound_effect.connect(play_sound_effect)
	BattleEventBus.queued_music.connect(play_music)

	BattleEventBus.menu_cancelled.connect(func(): play_sound_effect(SYS_CANCEL))
	BattleEventBus.menu_confirmed.connect(func(): play_sound_effect(SYS_SELECT))
	BattleEventBus.menu_moved.connect(func(): play_sound_effect(SYS_MOVE))
	BattleEventBus.menu_not_allowed.connect(func(): play_sound_effect(SYS_BUZZER))

	play_music(SUDO_THEME)

func play_music(stream: AudioStream) -> void:
	music_stream_player.stream = stream
	music_stream_player.play()

func play_sound_effect(stream: AudioStream) -> void:
	sound_effect_stream_player.stream = stream
	sound_effect_stream_player.play()
