extends CanvasLayer

@onready var health_label: Label = $HUDContainer/HealthPanel/VBoxContainer/HealthLabel
@onready var health_bar: ProgressBar = $HUDContainer/HealthPanel/VBoxContainer/HealthBar
@onready var crystal_label: Label = $HUDContainer/CrystalsPanel/CrystalLabel
@onready var quest_label: Label = $HUDContainer/QuestPanel/QuestLabel

func _ready() -> void:
	QuestManager.quest_updated.connect(update_quest_info)
	update_quest_info()

func update_health(current: int, max: int) -> void:
	health_bar.max_value = max
	health_bar.value = current
	health_label.text = "LIFE: %d/%d" % [current, max]

func update_quest_info() -> void:
	crystal_label.text = "CRYSTALS: %d/%d" % [
		QuestManager.collected_crystals,
		QuestManager.required_crystals
	]
	match QuestManager.quest_state:
		QuestManager.QuestState.NOT_STARTED:
			quest_label.text = "MISSION: Talk to Han Solo"
		QuestManager.QuestState.ACTIVE:
			quest_label.text = "MISSION: Collect the crystals"
		QuestManager.QuestState.READY_TO_DELIVER:
			quest_label.text = "MISSION: Deliver the crystals to Han Solo"
		QuestManager.QuestState.COMPLETED:
			quest_label.text = "MISSION COMPLETE"
