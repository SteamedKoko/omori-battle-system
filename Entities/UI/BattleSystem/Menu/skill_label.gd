class_name SkillLabel
extends Control

const SKILL_LABEL: Resource = preload("uid://dy5xdali0qnn3")

var skill: Skill

@onready var finger: Control = %FingerContainer
@onready var option_text: RichTextLabel = %OptionText

func _ready() -> void:
	if skill:
		option_text.text = skill.name

	focus_entered.connect(_focused)
	focus_exited.connect(_unfocused)

func _focused() -> void:
	BattleEventBus.updated_submenu_title.emit("Cost: ", str(skill.cost))
	BattleEventBus.sent_battle_text.emit("%s\n%s\nCost: %s" % [skill.name, skill.description, skill.cost])
	finger.show()

func _unfocused() -> void:
	finger.hide()

static func build(_skill: Skill) -> SkillLabel:
	var instance: SkillLabel = SKILL_LABEL.instantiate()
	instance.skill = _skill
	return instance
