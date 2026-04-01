class_name BattleEnums
extends Node

enum Emotions {
	NEUTRAL,
	HAPPY,
	ECSTATIC,
	MANIC,
	SAD,
	DEPRESSED,
	MISERABLE,
	ANGRY,
	ENRAGED,
	FURIOUS,
	SPAMTON,
}

enum ApplicableTarget {
	None,
	Ally,
	Enemy,
	Self,
	AllEnemy,
	AllAlly,
	All,
}

enum DebuffType {
	None,
	Defense,
	MajorDefense,
	Attack,
	MajorAttack
}

enum StatType {
	Attack,
	Defense,
	Speed,
	Luck
}
