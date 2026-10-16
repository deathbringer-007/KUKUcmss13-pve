/obj/item/clothing/gloves/captain
	desc = "华贵的蓝色手套，配有漂亮的金色饰边。真气派。"
	name = "舰长手套"
	icon_state = "captain"
	item_state = "egloves"
	flags_cold_protection = BODY_FLAG_HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROT
	flags_heat_protection = BODY_FLAG_HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROT

/obj/item/clothing/gloves/cyborg
	desc = "哔哔，啵啵，嘟嘟。"
	name = "赛博格手套"
	icon_state = "black"
	item_state = "r_hands"
	siemens_coefficient = 1

/obj/item/clothing/gloves/swat
	desc = "这副战术手套具有一定的防火和抗冲击性能。"
	name = "\improper SWAT 战术手套"
	icon_state = "black"
	item_state = "swat_gl"
	siemens_coefficient = 0.6
	permeability_coefficient = 0.05

	flags_cold_protection = BODY_FLAG_HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROT
	flags_heat_protection = BODY_FLAG_HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROT

/obj/item/clothing/gloves/combat //Combined effect of SWAT gloves and insulated gloves
	desc = "这副战术手套具有一定的防火和抗冲击性能。"
	name = "作战手套"
	icon_state = "black"
	item_state = "swat_gl"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	flags_cold_protection = BODY_FLAG_HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROT
	flags_heat_protection = BODY_FLAG_HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROT

/obj/item/clothing/gloves/latex
	name = "乳胶手套"
	desc = "无菌乳胶手套。"
	icon_state = "latex"
	item_state = "lgloves"
	siemens_coefficient = 0.30
	permeability_coefficient = 0.35

/obj/item/clothing/gloves/botanic_leather
	desc = "这副皮手套可防护荆棘、倒刺、尖刺等植物带来的伤害。"
	name = "植物学家皮手套"
	icon_state = "leather"
	item_state = "ggloves"
	permeability_coefficient = 0.9
	siemens_coefficient = 0.9

/obj/item/clothing/gloves/botanic_leather/generic
	desc = "这副厚皮手套非常适合操作重型机械、需要稳固抓握的人使用。"
	name = "装配工手套"

/obj/item/clothing/gloves/boxing
	name = "拳击手套"
	desc = "因为你实在需要再找个借口揍同事。"
	icon_state = "boxing"
	item_state = "boxing"
	force = 0//don't actually deal damage
	attack_verb = list("挥拳击打","拳击","刺拳击打","击打","上勾拳击打", "拳打", "猛击")
	var/pain_dam = 20
	var/box_sound = list('sound/weapons/punch1.ogg')//placeholder
	var/knockout_sound = 'sound/effects/knockout.ogg'


/obj/item/clothing/gloves/boxing/Touch(atom/A, proximity)
	var/mob/living/M = loc
	var/painforce = pain_dam
	var/boxing_verb = pick(attack_verb)
	if (A in range(1, M))
		if(isliving(A) && M.a_intent == INTENT_HARM)
			if(isyautja(A) || isxeno(A))
				return 0
			if (ishuman(A))
				var/mob/living/carbon/human/L = A
				var/boxing_icon = pick("boxing_up","boxing_down","boxing_left","boxing_right")
				if (!istype(L.gloves, /obj/item/clothing/gloves/boxing))
					to_chat(M, SPAN_WARNING("你不能和[A]打拳击，对方没有戴拳击手套！"))
					return 1
				if (L.halloss > 100)
					playsound(loc, knockout_sound, 50, FALSE)
					M.show_message(FONT_SIZE_LARGE(SPAN_WARNING("击倒！")), SHOW_MESSAGE_VISIBLE)
					return 1
				if (L.body_position == LYING_DOWN || L.stat == UNCONSCIOUS)//Can't beat 'em while they're down.
					to_chat(M, SPAN_WARNING("你不能和[A]打拳击，对方已经倒下了！"))
					return 1
				M.visible_message(SPAN_DANGER("[M] [boxing_verb] [A]!"))
				L.apply_effect(painforce, AGONY)
				M.animation_attack_on(L)
				M.flick_attack_overlay(L, boxing_icon)
				playsound(loc, pick(box_sound), 25, 1)
				return 1

/obj/item/clothing/gloves/boxing/attackby(obj/item/W, mob/user)
	if(HAS_TRAIT(W, TRAIT_TOOL_WIRECUTTERS) || W.sharp == IS_SHARP_ITEM_ACCURATE || W.sharp == IS_SHARP_ITEM_BIG)
		to_chat(user, SPAN_NOTICE("剪开这么好的拳击手套实在太不体面了。")) //Nope
		return
	..()

/obj/item/clothing/gloves/boxing/green
	icon_state = "boxinggreen"
	item_state = "boxinggreen"

/obj/item/clothing/gloves/boxing/blue
	icon_state = "boxingblue"
	item_state = "boxingblue"

/obj/item/clothing/gloves/boxing/yellow
	icon_state = "boxingyellow"
	item_state = "boxingyellow"

/obj/item/clothing/gloves/white
	name = "白色手套"
	desc = "看起来相当雅致。"
	icon_state = "white"
	item_state = "white"
