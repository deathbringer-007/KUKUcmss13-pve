
// thermal goggles

/obj/item/clothing/glasses/thermal
	name = "光学热成像扫描镜"
	gender = NEUTER
	desc = "眼镜形状的热成像仪。"
	icon_state = "thermal"
	item_state = "glasses"
	toggleable = TRUE
	vision_flags = SEE_MOBS
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	darkness_view = 12
	invisa_view = 2
	eye_protection = EYE_PROTECTION_NEGATIVE
	deactive_state = "goggles_off"
	fullscreen_vision = /atom/movable/screen/fullscreen/thermal
	var/blinds_on_emp = TRUE

/obj/item/clothing/glasses/thermal/emp_act(severity)
	. = ..()
	if(blinds_on_emp)
		if(istype(src.loc, /mob/living/carbon/human))
			var/mob/living/carbon/human/M = src.loc
			to_chat(M, SPAN_WARNING("光学热成像扫描镜过载，闪瞎了你的双眼！"))
			if(M.glasses == src)
				M.SetEyeBlind(3)
				M.EyeBlur(5)
				if(!(M.disabilities & NEARSIGHTED))
					M.disabilities |= NEARSIGHTED
					spawn(100)
						M.disabilities &= ~NEARSIGHTED


/obj/item/clothing/glasses/thermal/syndi //These are now a traitor item, concealed as mesons. -Pete
	name = "光学介子扫描镜"
	desc = "用于透过任何障碍查看墙壁、地板等物体。"
	icon_state = "meson"
	deactive_state = "degoggles"
	actions_types = list(/datum/action/item_action/toggle)

/obj/item/clothing/glasses/thermal/syndi/bug_b_gone
	name = "灭虫灵热成像护目镜"
	gender = PLURAL
	desc = "满足你的各种猎虫需求！"
	icon_state = "rwelding-g"
	deactive_state = "rwelding-gup"

/obj/item/clothing/glasses/thermal/monocle
	name = "热成像单片眼镜"
	desc = "一副热成像单片眼镜。"
	icon_state = "thermoncle"
	flags_atom = null //doesn't protect eyes because it's a monocle, duh
	toggleable = FALSE
	flags_armor_protection = 0

/obj/item/clothing/glasses/thermal/eyepatch
	name = "光学热成像眼罩"
	desc = "内置热成像光学系统的眼罩。"
	icon_state = "eyepatch"
	item_state = "eyepatch"
	toggleable = FALSE
	flags_armor_protection = 0

/obj/item/clothing/glasses/thermal/jensen
	name = "光学热成像植入镜"
	gender = PLURAL
	desc = "一组可植入的镜片，用于增强视觉。"
	icon_state = "thermalimplants"
	item_state = "syringe_kit"
	toggleable = FALSE

/obj/item/clothing/glasses/thermal/empproof
	desc = "眼镜形状的热成像仪。这副具有电磁脉冲防护功能。"
	blinds_on_emp = FALSE
