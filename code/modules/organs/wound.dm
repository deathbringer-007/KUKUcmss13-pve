
/*
					WOUNDS
*/
/datum/wound
	// number representing the current stage
	var/current_stage = 0

	// description of the wound
	var/desc = "wound" //default in case something borks

	// amount of damage this wound causes
	var/damage = 0
	// amount of damage the current wound type requires(less means we need to apply the next healing stage)
	var/min_damage = 0

	// is the wound bandaged/sutured?
	var/bandaged = NONE
	// is the wound salved/grafted?
	var/salved = NONE
	var/created = 0
	// number of wounds of this type
	var/amount = 1

	/*  These are defined by the wound type and should not be changed */

	// stages such as "cut", "deep cut", etc.
	var/list/stages
	// internal wounds can only be fixed through surgery
	var/internal = 0
	// one of CUT, BRUISE, BURN
	var/damage_type = CUT
	// whether this wound needs a bandage/salve to heal at all
	// the maximum amount of damage that this wound can have and still autoheal
	var/autoheal_cutoff = 15

	var/icon/bandaged_icon = null // Icon for gauze over a wound

	// helper lists
	var/tmp/list/desc_list = list()
	var/tmp/list/damage_list = list()

/datum/wound/New(damage)
	created = world.time

	// reading from a list("stage" = damage) is pretty difficult, so build two separate
	// lists from them instead
	for(var/V in stages)
		desc_list += V
		damage_list += stages[V]

	src.damage = damage

	// initialize with the appropriate stage
	src.init_stage(damage)

// returns 1 if there's a next stage, 0 otherwise
/datum/wound/proc/init_stage(initial_damage)
	current_stage = length(stages)

	while(src.current_stage > 1 && src.damage_list[current_stage-1] <= initial_damage / src.amount)
		src.current_stage--

	src.min_damage = damage_list[current_stage]
	src.desc = desc_list[current_stage]

// the amount of damage per wound
/datum/wound/proc/wound_damage()
	return src.damage / src.amount

/datum/wound/proc/can_autoheal()
	if(src.wound_damage() <= autoheal_cutoff)
		return 1

	return is_treated()

// checks whether the wound has been appropriately treated
/datum/wound/proc/is_treated()
	if(damage_type == BRUISE || damage_type == CUT)
		return bandaged
	else if(damage_type == BURN)
		return salved

// Checks whether other other can be merged into src.
/datum/wound/proc/can_merge(datum/wound/other)
	if (other.type != src.type) return 0
	if (other.current_stage != src.current_stage) return 0
	if (other.damage_type != src.damage_type) return 0
	if (!(other.can_autoheal()) != !(src.can_autoheal())) return 0
	if (!(other.bandaged) != !(src.bandaged)) return 0
	if (!(other.salved) != !(src.salved)) return 0
	return 1

/datum/wound/proc/merge_wound(datum/wound/other)
	src.damage += other.damage
	src.amount += other.amount
	src.created = max(src.created, other.created) //take the newer created time

// heal the given amount of damage, and if the given amount of damage was more
// than what needed to be healed, return how much heal was left
// set @heals_internal to also heal internal organ damage
/datum/wound/proc/heal_damage(amount, heals_internal = 0)
	if(src.internal && !heals_internal)
		// heal nothing
		return amount

	var/healed_damage = min(src.damage, amount)
	amount -= healed_damage
	src.damage -= healed_damage

	while(src.wound_damage() < damage_list[current_stage] && current_stage < length(src.desc_list))
		current_stage++
	desc = desc_list[current_stage]
	src.min_damage = damage_list[current_stage]

	// return amount of healing still leftover, can be used for other wounds
	return amount

// opens the wound again
/datum/wound/proc/open_wound(damage)
	src.damage += damage
	bandaged = NONE
	salved = NONE

	while(src.current_stage > 1 && src.damage_list[current_stage-1] <= src.damage / src.amount)
		src.current_stage--

	src.desc = desc_list[current_stage]
	src.min_damage = damage_list[current_stage]

// returns whether this wound can absorb the given amount of damage.
// this will prevent large amounts of damage being trapped in less severe wound types
/datum/wound/proc/can_worsen(damage_type, damage)
	if (src.damage_type != damage_type)
		return 0 //incompatible damage types

	if (src.amount > 1)
		return 0

	//with 1.5*, a shallow cut will be able to carry at most 30 damage,
	//37.5 for a deep cut
	//52.5 for a flesh wound, etc.
	var/max_wound_damage = 1.5*src.damage_list[1]
	if (src.damage + damage > max_wound_damage)
		return 0

	return 1

/* WOUND DEFINITIONS **/

//Note that the MINIMUM damage before a wound can be applied should correspond to
//the damage amount for the stage with the same name as the wound.
//e.g. /datum/wound/cut/deep should only be applied for 15 damage and up,
//because in it's stages list, "deep cut" = 15.
/proc/get_wound_type(type = CUT, damage)
	switch(type)
		if(CUT)
			switch(damage)
				if(70 to INFINITY)
					return /datum/wound/cut/massive
				if(60 to 70)
					return /datum/wound/cut/gaping_big
				if(50 to 60)
					return /datum/wound/cut/gaping
				if(25 to 50)
					return /datum/wound/cut/flesh
				if(15 to 25)
					return /datum/wound/cut/deep
				if(0 to 15)
					return /datum/wound/cut/small
		if(BRUISE)
			return /datum/wound/bruise
		if(BURN)
			switch(damage)
				if(50 to INFINITY)
					return /datum/wound/burn/carbonised
				if(40 to 50)
					return /datum/wound/burn/deep
				if(30 to 40)
					return /datum/wound/burn/severe
				if(15 to 30)
					return /datum/wound/burn/large
				if(0 to 15)
					return /datum/wound/burn/moderate
	return null //no wound

/* CUTS **/
/datum/wound/cut/small
	// link wound descriptions to amounts of damage
	stages = list("ugly ripped cut" = 20, "ripped cut" = 10, "cut" = 5, "healing cut" = 2, "small scab" = 0)
	damage_type = CUT

/datum/wound/cut/deep
	stages = list("ugly deep ripped cut" = 25, "deep ripped cut" = 20, "deep cut" = 15, "clotted cut" = 8, "scab" = 2, "fresh skin" = 0)
	damage_type = CUT

/datum/wound/cut/flesh
	stages = list("ugly ripped flesh wound" = 35, "ugly flesh wound" = 30, "flesh wound" = 25, "blood soaked clot" = 15, "large scab" = 5, "fresh skin" = 0)
	damage_type = CUT

/datum/wound/cut/gaping
	stages = list("gaping wound" = 50, "large blood soaked clot" = 25, "large clot" = 15, "small angry scar" = 5, "small straight scar" = 0)
	damage_type = CUT

/datum/wound/cut/gaping_big
	stages = list("big gaping wound" = 60, "healing gaping wound" = 40, "large angry scar" = 10, "large straight scar" = 0)
	damage_type = CUT

/datum/wound/cut/massive
	stages = list("massive wound" = 70, "massive healing wound" = 50, "massive angry scar" = 10,  "massive jagged scar" = 0)
	damage_type = CUT

/* BRUISES **/
/datum/wound/bruise
	stages = list("monumental bruise" = 80, "huge bruise" = 50, "large bruise" = 30,\
				  "moderate bruise" = 20, "small bruise" = 10, "tiny bruise" = 5)
	autoheal_cutoff = 30
	damage_type = BRUISE

/* BURNS **/
/datum/wound/burn/moderate
	stages = list("ripped burn" = 10, "moderate burn" = 5, "healing moderate burn" = 2, "fresh skin" = 0)
	damage_type = BURN

/datum/wound/burn/large
	stages = list("ripped large burn" = 20, "large burn" = 15, "healing large burn" = 5, "fresh skin" = 0)
	damage_type = BURN

/datum/wound/burn/severe
	stages = list("ripped severe burn" = 35, "severe burn" = 30, "healing severe burn" = 10, "burn scar" = 0)
	damage_type = BURN

/datum/wound/burn/deep
	stages = list("ripped deep burn" = 45, "deep burn" = 40, "healing deep burn" = 15,  "large burn scar" = 0)
	damage_type = BURN

/datum/wound/burn/carbonised
	stages = list("carbonised area" = 50, "healing carbonised area" = 20, "massive burn scar" = 0)
	damage_type = BURN

/* INTERNAL BLEEDING **/
/datum/wound/internal_bleeding
	internal = 1
	stages = list("bruised artery" = 0)

/* EXTERNAL ORGAN LOSS **/
/datum/wound/lost_limb
	damage_type = CUT
	stages = list("ripped stump" = 65, "bloody stump" = 50, "clotted stump" = 25, "scarred stump" = 0)

/datum/wound/lost_limb/can_merge(datum/wound/other)
	return 0 //cannot be merged

/datum/wound/lost_limb/small
	stages = list("ripped stump" = 40, "bloody stump" = 30, "clotted stump" = 15, "scarred stump" = 0)

/proc/localized_wound_label(value)
	if(!istext(value))
		return value
	var/static/list/labels = list(
		"wound" = "伤口",
		"ugly ripped cut" = "严重撕裂伤",
		"ripped cut" = "撕裂伤",
		"cut" = "割伤",
		"healing cut" = "愈合中的割伤",
		"small scab" = "小块结痂",
		"ugly deep ripped cut" = "严重深层撕裂伤",
		"deep ripped cut" = "深层撕裂伤",
		"deep cut" = "深度割伤",
		"clotted cut" = "已凝血的割伤",
		"scab" = "结痂",
		"fresh skin" = "新生皮肤",
		"ugly ripped flesh wound" = "严重撕裂的皮肉伤",
		"ugly flesh wound" = "严重皮肉伤",
		"flesh wound" = "皮肉伤",
		"blood soaked clot" = "浸血血痂",
		"large scab" = "大块结痂",
		"gaping wound" = "开放性伤口",
		"large blood soaked clot" = "大块浸血血痂",
		"large clot" = "大块血痂",
		"small angry scar" = "红肿的小伤疤",
		"small straight scar" = "小条状伤疤",
		"big gaping wound" = "大型开放性伤口",
		"healing gaping wound" = "愈合中的开放性伤口",
		"large angry scar" = "红肿的大伤疤",
		"large straight scar" = "大条状伤疤",
		"massive wound" = "巨大伤口",
		"massive healing wound" = "愈合中的巨大伤口",
		"massive angry scar" = "红肿的巨大伤疤",
		"massive jagged scar" = "巨大的不规则伤疤",
		"monumental bruise" = "极重度瘀伤",
		"huge bruise" = "巨型瘀伤",
		"large bruise" = "大面积瘀伤",
		"moderate bruise" = "中度瘀伤",
		"small bruise" = "小面积瘀伤",
		"tiny bruise" = "轻微瘀伤",
		"ripped burn" = "破损的烧伤",
		"moderate burn" = "中度烧伤",
		"healing moderate burn" = "愈合中的中度烧伤",
		"ripped large burn" = "破损的大面积烧伤",
		"large burn" = "大面积烧伤",
		"healing large burn" = "愈合中的大面积烧伤",
		"ripped severe burn" = "破损的重度烧伤",
		"severe burn" = "重度烧伤",
		"healing severe burn" = "愈合中的重度烧伤",
		"burn scar" = "烧伤瘢痕",
		"ripped deep burn" = "破损的深度烧伤",
		"deep burn" = "深度烧伤",
		"healing deep burn" = "愈合中的深度烧伤",
		"large burn scar" = "大面积烧伤瘢痕",
		"carbonised area" = "炭化组织",
		"healing carbonised area" = "愈合中的炭化组织",
		"massive burn scar" = "巨大的烧伤瘢痕",
		"bruised artery" = "挫伤的动脉",
		"ripped stump" = "撕裂的残肢",
		"bloody stump" = "血淋淋的残肢",
		"clotted stump" = "已凝血的残肢",
		"scarred stump" = "留有瘢痕的残肢"
	)
	var/static/list/treatments = list("salved " = "已涂药的", "grafted " = "已植皮的", "bandaged " = "已包扎的", "sutured " = "已缝合的")
	for(var/prefix in treatments)
		if(findtext(value, prefix) == 1)
			return treatments[prefix] + localized_wound_label(copytext(value, length(prefix) + 1))
	return labels[value] || value
