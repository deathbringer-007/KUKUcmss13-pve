/obj/item/storage/toolbox/antag
	name = "可疑的工具箱"
	desc = "一个小巧而可疑的工具箱，小到能装进包里。"
	icon_state = "syndicate"
	item_state = "toolbox_syndi"

	w_class = SIZE_MEDIUM

	storage_slots = 8

/obj/item/storage/toolbox/antag/Initialize(mapload, ...)
	. = ..()
	var/color = pick("red","yellow","green","blue","pink","orange","cyan","white")
	new /obj/item/tool/screwdriver(src)
	new /obj/item/tool/wrench(src)
	new /obj/item/tool/weldingtool(src)
	new /obj/item/tool/crowbar(src)
	new /obj/item/stack/cable_coil(src,30,color)
	new /obj/item/tool/wirecutters(src)
	new /obj/item/device/multitool(src)
	new /obj/item/pamphlet/engineer/antag(src)

/obj/item/pamphlet/skill/engineer/antag
	name = "可疑的手册"
	desc = "用于快速传授重要知识的手册。上面印有工程徽记，内容使用暗语写成。"
	trait = /datum/character_trait/skills/miniengie/antag
	bypass_pamphlet_limit = TRUE

/obj/item/pamphlet/engineer/antag/attack_self(mob/living/carbon/human/user)
	if(!user.skills || !istype(user))
		return

	if(!skillcheckexplicit(user, SKILL_ANTAG, SKILL_ANTAG_AGENT))
		to_chat(user, SPAN_WARNING("这本手册使用暗语写成！你看不太懂。"))
		return

	. = ..()
