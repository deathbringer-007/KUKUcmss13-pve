/obj/item/implant/neurostim
	name = "神经刺激植入物"
	desc = "调节痛觉和感官功能的植入物。能够减轻疼痛、改善平衡，并增强对过度刺激和方向感紊乱的抵抗力。为促使佩戴者服从，植入物听到特定口令（无线电传音除外）时会施加惩罚性刺激。植入物可能随时间推移受到免疫系统侵蚀，因此偶尔会发生故障。"
	var/phrase = "supercalifragilisticexpialidocious"
	var/last_activated = 0
	var/implant_age = 0 //number of ticks since being implanted
	icon_state = "implant_evil"

/obj/item/implant/neurostim/get_data()
	var/dat = {"
<b>植入物规格：</b><BR>
<b>名称：</b> 维兰德-汤谷 NX-35 神经刺激植入物<BR>
<HR>
<b>植入物详情：</b><BR>
<b>功能：</b> 刺激并调节感觉运动功能，优化身体表现。能够改善平衡，并增强对过度刺激和方向感紊乱的抵抗力。<BR>
<b>特殊功能：</b> 为促使佩戴者服从，植入物收到指定口令时会施加惩罚性刺激。<BR>
<b>可靠性：</b> 植入物会受到免疫系统侵蚀，因此偶尔会发生故障。"}
	return dat

/obj/item/implant/neurostim/Initialize()
	. = ..()
	flags_atom |= USES_HEARING

/obj/item/implant/neurostim/hear_talk(mob/M as mob, msg)
	hear(msg)
	return

/obj/item/implant/neurostim/hear(msg)
	msg = strip_html(msg)
	if(findtext(msg,phrase))
		activate(0)

/obj/item/implant/neurostim/activate(accidental = 0)
	set waitfor = 0

	if(malfunction == MALFUNCTION_PERMANENT)
		return
	if(world.time - last_activated < 50)
		return
	if(!imp_in)
		playsound(src, 'sound/machines/twobeep.ogg', 60, 1)
		return

	last_activated = world.time

	if(istype(imp_in, /mob/living/))
		var/mob/living/M = imp_in
		if(accidental) //was triggered by random chance or EMP
			playsound(M, 'sound/machines/buzz-two.ogg', 60, 1)
			var/malf_msg = "[imp_in][part ? "的[part.display_name]" : "体内"]有什么东西在嗡嗡作响。"
			imp_in.visible_message(SPAN_WARNING(malf_msg))
		else
			playsound(M, 'sound/machines/twobeep.ogg', 60, 1)
			var/malf_msg = "[imp_in][part ? "的[part.display_name]" : "体内"]有什么东西在发出哔哔声。"
			imp_in.visible_message(SPAN_WARNING(malf_msg))
		sleep(10)
		playsound(M, 'sound/effects/sparks2.ogg', 60, 1)
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(2, 1, src)
		s.start()
		sleep(5)

		var/mob_pain_msg = "剧痛贯穿了[part ? "你的[part.display_name]" : "你的全身"]！"
		M.visible_message(SPAN_DANGER("[M]痛得浑身抽搐！"), SPAN_DANGER(mob_pain_msg))
		M.flash_eyes(1, TRUE)
		M.apply_effect(10, STUN)
		M.apply_effect(10, WEAKEN)
		M.apply_damage(100, HALLOSS, part)
		M.apply_damage(5, BURN, part, 0, 0, src)

	else
		playsound(src, 'sound/machines/twobeep.ogg', 60, 1)


/obj/item/implant/neurostim/implanted(mob/source, mob/user)
	var/p = strip_html(input(user, "请设置激活口令："))
	if(!p)
		return 0
	phrase = p
	user.mind.store_memory("说出含有口令''[src.phrase]''的话，即可让[source]体内的[src]施加惩罚性刺激。输入<B>say [src.phrase]</B>即可尝试激活。", 0, 0)
	to_chat(user, SPAN_NOTICE("说出含有口令''[src.phrase]''的话，即可让[source]体内的[src]施加惩罚性刺激。输入<B>say [src.phrase]</B>即可尝试激活。"))
	START_PROCESSING(SSobj, src)
	return 1


/obj/item/implant/neurostim/process()

	if(!ismob(imp_in) || malfunction == MALFUNCTION_PERMANENT)
		STOP_PROCESSING(SSobj, src)
		return

	implant_age++

	if(prob(min(0.2, implant_age * 0.00005))) //becomes more likely to randomly activate over time
		activate(1)

	else if(world.time - last_activated > 600)
		if(iscarbon(imp_in))
			var/mob/living/carbon/C = imp_in
			if(!C.reagents)
				return
			var/neuraline_inject_amount = max(1-C.reagents.get_reagent_amount("neuraline"), 0)

			C.reagents.add_reagent("neuraline", neuraline_inject_amount, null, 1)


/obj/item/implant/neurostim/emp_act(severity)
	. = ..()
	if (malfunction)
		return
	if (prob(80))
		activate(1)
	else
		meltdown()


/obj/item/implant/neurostim/meltdown()
	STOP_PROCESSING(SSobj, src)
	. = ..()


/obj/item/implant/neurostim/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()


/obj/item/implanter/neurostim
	name = "植入器"

/obj/item/implanter/neurostim/New()
	src.imp = new /obj/item/implant/neurostim(src)
	..()
	update()
	return
