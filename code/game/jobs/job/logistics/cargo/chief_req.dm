/datum/job/logistics/requisition
	title = JOB_CHIEF_REQUISITION
	selection_class = "job_qm"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/qm
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>你的职责</a>是向陆战队员发放补给，包括武器配件。货运技师可以协助你，但你在本部门拥有最终决定权。确保他们没有偷懒。你可以要求领取物资时办理文书手续，但不要故意刁难陆战队员，除非你想被赶下台。士气高昂的舰船才能顺畅运转。"

/obj/effect/landmark/start/requisition
	name = JOB_CHIEF_REQUISITION
	icon_state = "ro_spawn"
	job = /datum/job/logistics/requisition
