/datum/job/command/pilot/dropship_pilot
	title = JOB_DROPSHIP_PILOT
	total_positions = 1
	spawn_positions = 1
	allow_additional = TRUE
	scaled = TRUE
	supervisors = "辅助支援军官"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/dp
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>你的职责是驾驶、保护和维护舰上的运输机。</a>虽然你是军官，但你的权限仅限于运输机内，在那里你可以指挥士兵。如果你没有驾驶，指挥部仍可使用自动驾驶作为后备方案，但不要无故离开运输机。"

// Dropship Roles is both DP, GP and DCC combined to not force people to backtrack
AddTimelock(/datum/job/command/pilot/dropship_pilot, list(
	JOB_DROPSHIP_ROLES = 2 HOURS
))

/obj/effect/landmark/start/pilot/dropship_pilot
	name = JOB_DROPSHIP_PILOT
	icon_state = "po_spawn"
	job = /datum/job/command/pilot/dropship_pilot
