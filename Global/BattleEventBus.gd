extends Node

@warning_ignore_start('UNUSED_SIGNAL')
signal player_action_executed(battle_action: BattleAction)
signal player_action_queued(command: Command)

signal queued_audio_sample(audio: AudioStreamMP3)

signal sent_battle_text(text: String)
signal sent_battle_text_append(text: String)
signal updated_submenu_title(left_text: String, right_text:String)
