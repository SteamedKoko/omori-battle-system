class_name BattleAudioPlayer
extends AudioStreamPlayer


func _ready() -> void:
	BattleEventBus.queued_audio_sample.connect(play_sample)

func play_sample(sample: AudioStreamMP3) -> void:
	stream = sample
	play()
