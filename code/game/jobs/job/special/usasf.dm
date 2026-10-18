/datum/job/seaman/standard
	title = JOB_NAVY_CREWMAN
	gear_preset = /datum/equipment_preset/usasf/crew
	gear_preset_secondary = /datum/equipment_preset/usasf/crew/snipe

/datum/job/seaman/standard/on_config_load()
	entry_message_body = "你是航空航天部队中一名普通舰员，而这正是你的力量所在。你是庞大体系的一环，协助操作穿行星际的舰船，以猛烈火力打击祖国的敌人。呼呀！"
	return ..()

/datum/job/seaman/skittle
	title = JOB_NAVY_SKITTLE
	gear_preset = /datum/equipment_preset/usasf/crew/flight

/datum/job/seaman/skittle/on_config_load()
	entry_message_body = "你是USASF舰船飞行甲板作业组的一员，负责整备航空航天器，并维持其战备状态。呼呀！"
	return ..()

/datum/job/seaman/medic
	title = JOB_NAVY_MEDIC
	gear_preset = /datum/equipment_preset/usasf/corpsman

/datum/job/seaman/medic/on_config_load()
	entry_message_body = "你的职责是让舰员保持健康与战斗力。你也精通用药与治疗，并能施行小型手术。超出你能力范围的伤情，通常可以交给自动手术舱处理。呼呀！"
	return ..()

/datum/job/seaman/engi
	title = JOB_NAVY_ENGI
	gear_preset = /datum/equipment_preset/usasf/engi

/datum/job/seaman/engi/on_config_load()
	entry_message_body = "你的职责是让所在舰船保持最佳状态，修复其执行任务期间产生的各类故障或损伤。呼呀！"
	return ..()

/datum/job/seaman/helljumper
	title = JOB_NAVY_PARA_TECH
	gear_preset = /datum/equipment_preset/usasf/helljumper

/datum/job/seaman/helljumper/on_config_load()
	entry_message_body = "你是精锐的第7伞降救援营成员，配备先进装备，拥有从运输机后舱纵身跃入险境的技能，支援急需援助的友军单位。呼呀！"
	return ..()

//USASF Officers

/datum/job/seaman/pilot
	title = JOB_NAVY_PILOT
	gear_preset = /datum/equipment_preset/usasf/pilot
	gear_preset_secondary = /datum/equipment_preset/usasf/pilot/lesser_rank

/datum/job/seaman/jtac
	title = JOB_NAVY_JTAC
	gear_preset = /datum/equipment_preset/usasf/jtac
	gear_preset_secondary = /datum/equipment_preset/usasf/jtac/lesser_rank

/datum/job/seaman/jtac/on_config_load()
	entry_message_body = "你经常随殖民地陆战队或陆军等地面部队部署，负责协调来自高空的火力支援，打击敌军集结位置。呼呀！"
	entry_message_end = "这一职位的呼叫火力支援通常需要与游戏主持人协调实现。如有疑问，请通过管理员求助功能与其联络。"
	return ..()

/datum/job/seaman/officer
	title = JOB_NAVY_SO
	gear_preset = /datum/equipment_preset/usasf/officer
	gear_preset_secondary = /datum/equipment_preset/usasf/officer/lesser_rank

/datum/job/seaman/flightboss
	title = JOB_NAVY_FLIGHT_BOSS
	gear_preset = /datum/equipment_preset/usasf/flightboss

/datum/job/seaman/chief_engineer
	title = JOB_NAVY_CHIEF_ENGINEER
	gear_preset = /datum/equipment_preset/usasf/chief_engineer

/datum/job/seaman/synth
	title = JOB_NAVY_SYNTH
	gear_preset = /datum/equipment_preset/synth/usasf

/datum/job/seaman/CO
	title = JOB_NAVY_CO
	gear_preset = /datum/equipment_preset/usasf/CO
