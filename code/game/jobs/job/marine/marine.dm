/datum/job/marine
	supervisors = "现任排长"
	selection_class = "job_marine"
	total_positions = 8
	spawn_positions = 8
	allow_additional = 1

/datum/job/marine/generate_entry_message(mob/living/carbon/human/current_human)
	if(current_human.faction == FACTION_TWE)
		entry_message_intro = "你的职位是[preference_label(title)]！<br>你已被编入<b><font size=3 color=[current_human.assigned_squad.equipment_color]>[preference_label(current_human.assigned_squad.name)]</font></b>。[Check_WO() ? "" : "请先前往军官餐厅，在超空间休眠后吃点东西，再到所属分队的整备室领取装备。" ]"
	else if(current_human.assigned_squad)
		entry_message_intro = "你的职位是[preference_label(title)]！<br>你已被编入<b><font size=3 color=[current_human.assigned_squad.equipment_color]>[preference_label(current_human.assigned_squad.name)]</font></b>排。[Check_WO() ? "" : "请先前往自助餐厅，在低温休眠后吃点东西，再到所属小组的整备室领取装备。" ]"
	return ..()

/datum/job/marine/generate_entry_conditions(mob/living/carbon/human/current_human)
	..()
	if(!Check_WO())
		current_human.nutrition = rand(NUTRITION_VERYLOW, NUTRITION_LOW) //Start hungry for the default marine.

/datum/timelock/squad
	name = "Squad Roles"

/datum/timelock/squad/New(name, time_required, list/roles)
	. = ..()
	src.roles = JOB_SQUAD_ROLES_LIST

