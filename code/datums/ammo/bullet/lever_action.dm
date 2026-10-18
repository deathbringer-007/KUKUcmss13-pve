/*
//======
					Lever Action
//======
*/

/datum/ammo/bullet/lever_action
	name = "杠杆步枪弹"

	damage = 80
	penetration = 0
	accuracy = HIT_ACCURACY_TIER_1
	shell_speed = AMMO_SPEED_TIER_6
	accurate_range = 14
	handful_state = "lever_action_bullet"
	shell_casing = /obj/effect/decal/ammo_casing

//unused and not working. need to refactor MD code. Unobtainable.
//intended mechanic is to have xenos hit with it show up very frequently on any MDs around
/datum/ammo/bullet/lever_action/tracker
	name = "杠杆步枪追踪弹"
	icon_state = "redbullet"
	damage = 70
	penetration = ARMOR_PENETRATION_TIER_3
	accuracy = HIT_ACCURACY_TIER_1
	handful_state = "tracking_lever_action_bullet"

/datum/ammo/bullet/lever_action/tracker/on_hit_mob(mob/M, obj/projectile/P, mob/user)
	//SEND_SIGNAL(user, COMSIG_BULLET_TRACKING, user, M)
	M.visible_message(SPAN_DANGER("你听到 [M] 的[M.mob_size > MOB_SIZE_HUMAN ? "几丁质外壳" : "皮肤"]下传来微弱的哔声。"))

/datum/ammo/bullet/lever_action/training
	name = "杠杆步枪空包弹"
	icon_state = "blank"
	damage = 70  //blanks CAN hurt you if shot very close
	penetration = 0
	accuracy = HIT_ACCURACY_TIER_1
	damage_falloff = DAMAGE_FALLOFF_BLANK //not much, though (comparatively)
	shell_speed = AMMO_SPEED_TIER_5
	handful_state = "training_lever_action_bullet"

//unused, and unobtainable... for now
/datum/ammo/bullet/lever_action/marksman
	name = "杠杆步枪精确射击弹"
	shrapnel_chance = 0
	damage_falloff = 0
	accurate_range = 12
	damage = 70
	penetration = ARMOR_PENETRATION_TIER_6
	shell_speed = AMMO_SPEED_TIER_6
	handful_state = "marksman_lever_action_bullet"

/datum/ammo/bullet/lever_action/xm88
	name = ".458 SOCOM子弹"

	damage = 104
	penetration = ARMOR_PENETRATION_TIER_2
	accuracy = HIT_ACCURACY_TIER_1
	shell_speed = AMMO_SPEED_TIER_6
	accurate_range = 14
	handful_state = "boomslang_bullet"

/datum/ammo/bullet/lever_action/xm88/pen20
	penetration = ARMOR_PENETRATION_TIER_4

/datum/ammo/bullet/lever_action/xm88/pen30
	penetration = ARMOR_PENETRATION_TIER_6

/datum/ammo/bullet/lever_action/xm88/pen40
	penetration = ARMOR_PENETRATION_TIER_8

/datum/ammo/bullet/lever_action/xm88/pen50
	penetration = ARMOR_PENETRATION_TIER_10
