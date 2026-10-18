// Warden
/datum/job/command/warden
	title = JOB_WARDEN
	selection_class = "job_mp"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	supervisors = "宪兵长"
	gear_preset = /datum/equipment_preset/uscm_ship/uscm_police/warden
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>你</a>必须遵守更高标准，除了服务器规则，还须遵守<a href='"+LAW_PLACEHOLDER+"'>陆战队军法</a>，否则可能受到职位封禁或服务器封禁。你的主要职责是维持舰上的和平与秩序。陆战队员在低温休眠数周后可能会变得躁动！此外，你还负责维护安保记录，并监管禁闭室内的囚犯。"

/obj/effect/landmark/start/warden
	name = JOB_WARDEN
	icon_state = "wmp_spawn"
	job = /datum/job/command/warden
