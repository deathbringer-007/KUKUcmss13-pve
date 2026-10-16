/datum/origin
	var/name = ORIGIN_BASE
	var/desc = "你出生在某个地方。你觉得，那里大概也有些出名的事物。"

/datum/origin/proc/generate_human_name(gender = MALE)
	return pick(gender == MALE ? GLOB.first_names_male : GLOB.first_names_female) + " " + pick(GLOB.last_names)

/// Return null if the name is correct, otherwise return a string containing the error message
/datum/origin/proc/validate_name(name_to_check)
	if(findtext(name_to_check, "A.W. "))
		return "姓名中不能包含“A.W.”，这是人工子宫培育士兵专用的标识。"
	return null

/datum/origin/proc/correct_name(name_to_check, gender = MALE)
	name_to_check = replacetext(name_to_check, "A.W. ", "")
	return name_to_check
