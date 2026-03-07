class_name SkillLabel
extends Control

const SKILL_LABEL: Resource = preload("uid://dy5xdali0qnn3")

signal skill_selected(skill: Skill)

var skill: Skill
@onready var finger: Control = %FingerContainer
@onready var option_text: RichTextLabel = %OptionText

func _ready() -> void:
	if skill:
		option_text.text = skill.name
	focus_entered.connect(_focused)
	focus_exited.connect(_unfocused)

func _focused() -> void:
	print('grabbing focus of ', skill.name)
	finger.show()

func _unfocused() -> void:
	finger.hide()

static func build(_skill: Skill) -> SkillLabel:
	var instance: SkillLabel = SKILL_LABEL.instantiate()
	instance.skill = _skill
	return instance
