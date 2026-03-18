@tool
class_name SpriteTextureRect
extends TextureRect

@export var sprite_frames: SpriteFrames
@export var time_to_next: float = 1

var running_sprites: Array[AtlasTexture]
var time_left: float
var sprite_index: int

# func _ready() -> void:
# 	load_sprites("neutral")
# 	time_left = time_to_next


# func load_sprites(key: String) -> void:
# 	sprite_frames.get_frame_texture(
# 	running_sprites = sprite_frames.get_frame_texture(key, 0)
# 	sprite_index = 0

# func _process(delta: float) -> void:
# 	time_left -= delta
# 	if time_left <= 0:
# 		time_left = time_to_next
# 		sprite_index = (sprite_index + 1) % running_sprites.size()
#
#
# 	
