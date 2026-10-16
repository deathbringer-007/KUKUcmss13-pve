//Species unarmed attacks
/datum/unarmed_attack
	var/attack_verb = list("攻击") // Empty hand hurt intent verb.
	var/damage = 0 // Extra empty hand attack damage.
	var/attack_sound = "punch"
	var/miss_sound = 'sound/weapons/punchmiss.ogg'
	var/shredding = FALSE // Calls the old attack_alien() behavior on objects/mobs when on harm intent.
	var/sharp = FALSE
	var/edge = FALSE

/datum/unarmed_attack/proc/is_usable(mob/living/carbon/human/user)
	if(!user.melee_allowed)
		to_chat(user, SPAN_DANGER("你现在无法攻击。"))
		return FALSE

	return TRUE

/datum/unarmed_attack/bite
	attack_verb = list("撕咬", "啃咬", "狠咬", "咬碎")
	attack_sound = 'sound/weapons/bite.ogg'
	shredding = FALSE
	damage = 5
	sharp = TRUE
	edge = TRUE

/datum/unarmed_attack/bite/is_usable(mob/living/carbon/human/user)
	if(!user.melee_allowed)
		return FALSE

	if (user.wear_mask && istype(user.wear_mask, /obj/item/clothing/mask/muzzle))
		return FALSE
	return TRUE

/datum/unarmed_attack/punch
	attack_verb = list("拳击")
	damage = 5

/datum/unarmed_attack/punch/strong
	attack_verb = list("拳击","猛击","穿刺")
	damage = 10

/datum/unarmed_attack/punch/synthetic
	attack_verb = list("拳击","重击","痛击","砸击","撕打")
	attack_sound = 'sound/weapons/synthpunch1.ogg'
	damage = 35

/datum/unarmed_attack/claws
	attack_verb = list("抓挠", "爪击")
	attack_sound = 'sound/weapons/slice.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	damage = 5
	sharp = TRUE
	edge = TRUE

/datum/unarmed_attack/claws/strong
	attack_verb = list("撕砍")
	damage = 10
	shredding = TRUE

/datum/unarmed_attack/bite/strong
	attack_verb = list("撕打")
	damage = 15
	shredding = TRUE
