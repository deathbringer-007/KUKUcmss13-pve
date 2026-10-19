#define MALFUNCTION_TEMPORARY 1
#define MALFUNCTION_PERMANENT 2


/obj/item/implant
	name = "植入物"
	icon = 'icons/obj/items/devices.dmi'
	icon_state = "implant"
	var/implanted = null
	var/mob/imp_in = null
	var/obj/limb/part = null
	var/implant_color= "b"
	var/allow_reagents = 0
	var/malfunction = 0

/obj/item/implant/proc/do_implant(mob/living/carbon/implantee, target_limb)
	implanted(implantee)
	forceMove(implantee)
	imp_in = implantee
	implanted = TRUE
	if(ishuman(implantee))
		var/mob/living/carbon/human/human = implantee
		var/obj/limb/affected = human.get_limb(target_limb)
		affected.implants += src
		part = affected


/obj/item/implant/proc/trigger(emote, source as mob)
	return

/obj/item/implant/proc/activate()
	return

	// What does the implant do upon injection?
	// return 0 if the implant fails (ex. Revhead and loyalty implant.)
	// return 1 if the implant succeeds (ex. Nonrevhead and loyalty implant.)
/obj/item/implant/proc/implanted(mob/source, mob/user)
	return 1

/obj/item/implant/proc/get_data()
	return "暂无信息"

/obj/item/implant/proc/hear(message, mob/source)
	return

/obj/item/implant/proc/islegal()
	return 0

/obj/item/implant/proc/meltdown() //breaks it down, making implant unrecongizible
	to_chat(imp_in, SPAN_WARNING("你感觉到[part ? "你的[localized_player_label(part.display_name)]" : "体内"]有什么东西正在熔化！"))
	if (part)
		part.take_damage(burn = 15, used_weapon = "Electronics meltdown")
	else
		var/mob/living/M = imp_in
		M.apply_damage(15,BURN)
	name = "熔毁的植入物"
	desc = "烧焦的电路裹在熔化的塑料壳中。不知道原来是什么……"
	icon_state = "implant_melted"
	malfunction = MALFUNCTION_PERMANENT

/obj/item/implant/Destroy()
	if(part)
		part.implants.Remove(src)
	return ..()

/obj/item/implant/tracking
	name = "追踪植入物"
	desc = "用于追踪。"
	var/id = 1

/obj/item/implant/tracking/Initialize(mapload, ...)
	. = ..()
	GLOB.tracking_implant_list += src

/obj/item/implant/tracking/Destroy()
	GLOB.tracking_implant_list -= src
	return ..()

/obj/item/implant/tracking/get_data()
		var/dat = {"<b>植入物规格：</b><BR>
<b>名称：</b> 追踪信标<BR>
<b>使用期限：</b> 宿主死亡后仍可运行 10 分钟<BR>
<b>重要事项：</b> 无<BR>
<HR>
<b>植入物详情：</b> <BR>
<b>功能：</b> 持续发射低功率信号，可用于追踪。<BR>
<b>特殊功能：</b><BR>
<i>神经安全保护</i>——特殊外壳可吸收过高电压；一旦发生故障，芯片便会自毁，
从而确保受植者安全。植入物会熔化并分解为
对生物体安全的成分。<BR>
<b>稳定性：</b> 电势差可能导致过度充电并烧毁电路，虽然风险很小。
因此，神经毒素可能造成严重损伤。<HR>
详细参数：<BR>"}
		return dat

/obj/item/implant/tracking/emp_act(severity)
	. = ..()
	if (malfunction) //no, dawg, you can't malfunction while you are malfunctioning
		return
	malfunction = MALFUNCTION_TEMPORARY

	var/delay = 20
	switch(severity)
		if(1)
			if(prob(60))
				meltdown()
		if(2)
			delay = rand(5 MINUTES, 15 MINUTES) //from 5 to 15 minutes of free time

	spawn(delay)
		malfunction--


/obj/item/implant/dexplosive
	name = "爆炸物"
	desc = "砰的一声，灰飞烟灭。"
	icon_state = "implant_evil"

/obj/item/implant/dexplosive/get_data()
	var/dat = {"
<b>植入物规格：</b><BR>
<b>名称：</b> 强健公司 RX-78 员工管理植入物<BR>
<b>使用期限：</b> 死亡时启动。<BR>
<b>重要事项：</b> 会爆炸<BR>
<HR>
<b>植入物详情：</b><BR>
<b>功能：</b> 内置小型电引爆炸药，在收到特定编码信号或宿主死亡时引爆。<BR>
<b>特殊功能：</b> 会爆炸<BR>
<b>稳定性：</b> 植入物偶尔会受到人体免疫系统侵蚀，从而发生故障。"}
	return dat


/obj/item/implant/dexplosive/trigger(emote, source as mob)
	if(emote == "deathgasp")
		src.activate("death")
	return


/obj/item/implant/dexplosive/activate(cause)
	if((!cause) || (!src.imp_in)) return 0
	explosion(src, -1, 0, 2, 3, 0)//This might be a bit much, dono will have to see.
	if(src.imp_in)
		src.imp_in.gib()

/obj/item/implant/dexplosive/islegal()
	return 0

//BS12 Explosive
/obj/item/implant/explosive
	name = "爆炸植入物"
	desc = "军用微型生物炸药，极其危险。"
	var/elevel = "Localized Limb"
	var/phrase = "supercalifragilisticexpialidocious"
	icon_state = "implant_evil"
	flags_atom = USES_HEARING

/obj/item/implant/explosive/get_data()
	var/dat = {"
<b>植入物规格：</b><BR>
<b>名称：</b> 强健公司 RX-78 威慑型植入物<BR>
<b>使用期限：</b> 收到口令时启动。<BR>
<b>重要事项：</b> 会爆炸<BR>
<HR>
<b>植入物详情：</b><BR>
<b>功能：</b> 内置小型电引爆炸药，在收到特定编码信号或宿主死亡时引爆。<BR>
<b>特殊功能：</b> 会爆炸<BR>
<b>稳定性：</b> 植入物偶尔会受到人体免疫系统侵蚀，从而发生故障。"}
	return dat

/obj/item/implant/explosive/hear_talk(mob/M as mob, msg)
	hear(msg)
	return

/obj/item/implant/explosive/hear(msg)
	var/list/replacechars = list("'" = "","\"" = "",">" = "","<" = "","(" = "",")" = "")
	msg = sanitize_simple(msg, replacechars)
	if(findtext(msg,phrase))
		activate()
		qdel(src)

/obj/item/implant/explosive/activate()
	if (malfunction == MALFUNCTION_PERMANENT)
		return

	var/need_gib = null
	if(istype(imp_in, /mob/))
		var/mob/T = imp_in
		message_admins("Explosive implant triggered in [T] ([T.key]). [ADMIN_JMP(T)] ")
		log_game("Explosive implant triggered in [T] ([T.key]).")
		need_gib = 1

		if(ishuman(imp_in))
			if (elevel == "Localized Limb")
				if(part) //For some reason, small_boom() didn't work. So have this bit of working copypaste.
					var/malf_msg = "你听到[imp_in][part ? "的[localized_player_label(part.display_name)]" : "体内"]传来哔声！"
					imp_in.visible_message(SPAN_DANGER(malf_msg))
					playsound(loc, 'sound/items/countdown.ogg', 25, 1, 6)
					sleep(25)
					if (istype(part,/obj/limb/chest) || \
						istype(part,/obj/limb/groin) || \
						istype(part,/obj/limb/head))
						part.createwound(BRUISE, 60) //mangle them instead
						explosion(get_turf(imp_in), -1, -1, 2, 3)
						qdel(src)
					else
						explosion(get_turf(imp_in), -1, -1, 2, 3)
						part.droplimb(0, 0, "dismemberment")
						qdel(src)
			if (elevel == "Destroy Body")
				explosion(get_turf(T), -1, 0, 1, 6)
				T.gib()
			if (elevel == "Full Explosion")
				explosion(get_turf(T), 0, 1, 3, 6)
				T.gib()

		else
			explosion(get_turf(imp_in), 0, 1, 3, 6)

	if(need_gib)
		imp_in.gib()


/obj/item/implant/explosive/implanted(mob/source as mob)
	elevel = localized_native_alert(usr, "你想选择哪种爆炸方式？", "植入物爆炸方式", "Localized Limb", "Destroy Body", "Full Explosion")
	phrase = input("请选择启动口令：") as text
	var/list/replacechars = list("'" = "","\"" = "",">" = "","<" = "","(" = "",")" = "")
	phrase = sanitize_simple(phrase, replacechars)
	usr.mind.store_memory("[source]体内的爆炸植入物可通过说出包含“[src.phrase]”的内容激活。输入 <B>say [src.phrase]</B> 尝试引爆。", 0, 0)
	to_chat(usr, "[source]体内的爆炸植入物可通过说出包含“[src.phrase]”的内容激活。输入 <B>say [src.phrase]</B> 尝试引爆。")
	return 1

/obj/item/implant/explosive/emp_act(severity)
	. = ..()
	if (malfunction)
		return
	malfunction = MALFUNCTION_TEMPORARY
	switch (severity)
		if (2.0) //Weak EMP will make implant tear limbs off.
			if (prob(50))
				small_boom()
		if (1.0) //strong EMP will melt implant either making it go off, or disarming it
			if (prob(70))
				if (prob(50))
					small_boom()
				else
					if (prob(50))
						activate() //50% chance of bye bye
					else
						meltdown() //50% chance of implant disarming
	spawn (20)
		malfunction--

/obj/item/implant/explosive/islegal()
	return 0

/obj/item/implant/explosive/proc/small_boom()
	if (ishuman(imp_in) && part)
		var/malf_msg = "你听到[imp_in][part ? "的[localized_player_label(part.display_name)]" : "体内"]传来哔声！"
		imp_in.visible_message(SPAN_DANGER(malf_msg))
		playsound(loc, 'sound/items/countdown.ogg', 25, 1, 6)
		spawn(25)
			if (ishuman(imp_in) && part)
				//No tearing off these parts since it's pretty much killing
				//and you can't replace groins
				if (istype(part,/obj/limb/chest) || \
					istype(part,/obj/limb/groin) || \
					istype(part,/obj/limb/head))
					part.createwound(BRUISE, 60) //mangle them instead
				else
					part.droplimb(0, 0, "dismemberment")
			explosion(get_turf(imp_in), -1, -1, 2, 3)
			qdel(src)

/obj/item/implant/chem
	name = "化学植入物"
	desc = "用于注射药剂。"
	allow_reagents = 1

/obj/item/implant/chem/Initialize()
	. = ..()
	GLOB.chem_implant_list += src
	create_reagents(50)

/obj/item/implant/chem/Destroy()
	GLOB.chem_implant_list -= src
	return ..()

/obj/item/implant/chem/get_data()
	var/dat = {"
<b>植入物规格：</b><BR>
<b>名称：</b> 强健公司 MJ-420 囚犯管理植入物<BR>
<b>使用期限：</b> 死亡时停止运行，但仍留在体内。<BR>
<b>重要事项： 系统消耗受植者体内的营养，因此受植者<BR>
会出现食欲增加的现象。</B><BR>
<HR>
<b>植入物详情：</b><BR>
<b>功能：</b> 内置可容纳多种化学物质的小胶囊。收到特定编码信号后，<BR>
植入物会将其中的化学物质直接释放到血液中。<BR>
<b>特殊功能：</b>
<i>微型胶囊</i>——可使用普通注射器注入任意化学物质，容量为 50 单位。<BR>
仅在尚未从原装外壳中取出时才能填充。<BR>
<b>稳定性：</b> 只要受植者存活，植入物就能持续运行。但若受植者营养不良，<BR>
植入物可能变得不稳定，提前注射或直接损坏。"}
	return dat



/obj/item/implant/chem/trigger(emote, source as mob)
	if(emote == "deathgasp")
		src.activate(src.reagents.total_volume)
	return


/obj/item/implant/chem/activate(cause)
	if((!cause) || (!src.imp_in)) return 0
	var/mob/living/carbon/R = src.imp_in
	src.reagents.trans_to(R, cause)
	to_chat(R, "你听到一声微弱的哔声。")
	if(!src.reagents.total_volume)
		to_chat(R, "你听到胸口传来轻微的咔嗒声。")
		spawn(0)
			qdel(src)
	return

/obj/item/implant/chem/emp_act(severity)
	. = ..()
	if (malfunction)
		return
	malfunction = MALFUNCTION_TEMPORARY

	switch(severity)
		if(1)
			if(prob(60))
				activate(20)
		if(2)
			if(prob(30))
				activate(5)

	spawn(20)
		malfunction--

/obj/item/implant/loyalty
	name = "忠诚植入物"
	desc = "让人变得忠诚之类的东西。"

/obj/item/implant/loyalty/get_data()
	var/dat = {"
<b>植入物规格：</b><BR>
<b>名称：</b> 维兰德-汤谷员工管理植入物<BR>
<b>使用期限：</b> 十年。<BR>
<b>重要事项：</b> 受植人员被标记为维兰德-汤谷的财产，并接受公司的监控。<BR>
<HR>
<b>植入物详情：</b><BR>
<b>功能：</b> 将宿主标记为维兰德-汤谷的财产，并启用特殊监控功能。<BR>
<b>特殊功能：</b> 提高宿主抵抗洗脑技术的能力。<BR>
<b>稳定性：</b> 植入物可使用约十年。"}
	return dat

/obj/item/implant/loyalty/implanted(mob/M)
	if(!ishuman(M)) return
	if(isyautja(M)) return
	var/mob/living/carbon/human/H = M
	to_chat(H, SPAN_NOTICE("你已被标记为维兰德-汤谷的效忠者，总部将会监控你。你仍然保有自由意志和正常心智。"))
	return 1

/obj/item/implant/adrenalin
	name = "肾上腺素"
	desc = "消除所有眩晕和击倒效果。"
	var/uses

/obj/item/implant/adrenalin/get_data()
	var/dat = {"
<b>植入物规格：</b><BR>
<b>名称：</b> 赛博太阳工业肾上腺素植入物<BR>
<b>使用期限：</b> 五天。<BR>
<b>重要事项：</b> <font color='red'>非法</font><BR>
<HR>
<b>植入物详情：</b> 受植者可主动注射大量肾上腺素。<BR>
<b>功能：</b> 内含可刺激人体大量分泌肾上腺素的纳米机器人。<BR>
<b>特殊功能：</b> 可预防和解除大多数洗脑效果。<BR>
<b>稳定性：</b> 纳米机器人耗尽前仅可使用三次。"}
	return dat


/obj/item/implant/adrenalin/trigger(emote, mob/source as mob)
	if (src.uses < 1) return 0
	if (emote == "pale")
		src.uses--
		to_chat(source, SPAN_NOTICE("你突然感觉精力充沛！"))
		source.set_effect(0, STUN)
		source.set_effect(0, WEAKEN)
		source.set_effect(0, PARALYZE)

	return


/obj/item/implant/adrenalin/implanted(mob/source)
	source.mind.store_memory("植入物可通过 pale 表情指令激活。输入 <B>say *pale</B> 尝试启动。", 0, 0)
	to_chat(source, "肾上腺素植入物可通过 pale 表情指令激活。输入 <B>say *pale</B> 尝试启动。")
	return 1


/obj/item/implant/death_alarm
	name = "死亡警报植入物"
	desc = "监测宿主生命体征，并在其死亡时发送无线电警报。"
	var/mobname = "Will Robinson"

/obj/item/implant/death_alarm/get_data()
	var/dat = {"
<b>植入物规格：</b><BR>
<b>名称：</b> 维兰德-汤谷“利润率”型员工生命体征传感器<BR>
<b>使用期限：</b> 死亡时启动。<BR>
<b>重要事项：</b> 向船员报告人员死亡。<BR>
<HR>
<b>植入物详情：</b><BR>
<b>功能：</b> 内置小型无线电发信器，在宿主生命体征消失时触发。<BR>
<b>特殊功能：</b> 向船员报告人员死亡。<BR>
<b>稳定性：</b> 植入物偶尔会受到人体免疫系统侵蚀，从而发生故障。"}
	return dat

/obj/item/implant/death_alarm/process()
	if (!implanted) return
	var/mob/M = imp_in

	if(QDELETED(M)) // If the mob got gibbed
		activate()
	else if(M.stat == 2)
		activate("death")

/obj/item/implant/death_alarm/activate(cause)
	var/mob/M = imp_in
	var/area/t = get_area(M)
	switch (cause)
		if("death")
			STOP_PROCESSING(SSobj, src)
		if ("emp")
			var/obj/item/device/radio/headset/a = new /obj/item/device/radio/headset(null)
			var/name = t.name
			ai_silent_announcement("[mobname]已在[name]死亡！", "[mobname]的死亡警报")
			qdel(a)
		else
			var/obj/item/device/radio/headset/a = new /obj/item/device/radio/headset(null)
			ai_silent_announcement("[mobname]已死亡——滋滋——在、在、在……", "[mobname]的死亡警报")
			qdel(a)
			STOP_PROCESSING(SSobj, src)

/obj/item/implant/death_alarm/emp_act(severity) //for some reason alarms stop going off in case they are emp'd, even without this
	. = ..()
	if (malfunction) //so I'm just going to add a meltdown chance here
		return
	malfunction = MALFUNCTION_TEMPORARY

	activate("emp") //let's shout that this dude is dead
	if(severity == 1)
		if(prob(40)) //small chance of obvious meltdown
			meltdown()
		else if (prob(60)) //but more likely it will just quietly die
			malfunction = MALFUNCTION_PERMANENT
		STOP_PROCESSING(SSobj, src)

	spawn(20)
		malfunction--

/obj/item/implant/death_alarm/implanted(mob/source as mob)
	mobname = source.real_name
	START_PROCESSING(SSobj, src)
	return 1

/obj/item/implant/compressed
	name = "压缩物质植入物"
	desc = "采用压缩物质技术，可储存一件物品。"
	icon_state = "implant_evil"
	var/activation_emote = "sigh"
	var/obj/item/scanned = null

/obj/item/implant/compressed/get_data()
	var/dat = {"
<b>植入物规格：</b><BR>
<b>名称：</b> 维兰德-汤谷“利润率”型员工生命体征传感器<BR>
<b>使用期限：</b> 死亡时启动。<BR>
<b>重要事项：</b> 向船员报告人员死亡。<BR>
<HR>
<b>植入物详情：</b><BR>
<b>功能：</b> 内置小型无线电发信器，在宿主生命体征消失时触发。<BR>
<b>特殊功能：</b> 向船员报告人员死亡。<BR>
<b>稳定性：</b> 植入物偶尔会受到人体免疫系统侵蚀，从而发生故障。"}
	return dat

/obj/item/implant/compressed/trigger(emote, mob/source as mob)
	if (src.scanned == null)
		return 0

	if (emote == src.activation_emote)
		to_chat(source, "[src.scanned.name]解除压缩时，周围的空气泛起光芒。")
		activate()

/obj/item/implant/compressed/activate()
	var/turf/t = get_turf(src)
	if (imp_in)
		imp_in.put_in_hands(scanned)
	else
		scanned.forceMove(t)
	qdel(src)

/obj/item/implant/compressed/implanted(mob/source as mob)
	src.activation_emote = localized_input_list(usr, "请选择启动表情指令：", "表情指令", list("blink", "blink_r", "eyebrow", "chuckle", "twitch_s", "frown", "nod", "blush", "giggle", "grin", "groan", "shrug", "smile", "pale", "sniff", "whimper", "wink"))
	if (source.mind)
		source.mind.store_memory("压缩物质植入物可通过 [src.activation_emote] 表情指令激活。输入 <B>say *[src.activation_emote]</B> 尝试启动。", 0, 0)
	to_chat(source, "压缩物质植入物可通过 [src.activation_emote] 表情指令激活。输入 <B>say *[src.activation_emote]</B> 尝试启动。")
	return 1

/obj/item/implant/compressed/islegal()
	return 0

/obj/item/implant/poison_tooth
	name = "牙齿"
	desc = "这颗看起来格外干净。"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "tooth"
	w_class = SIZE_TINY
	var/activation_emote
	var/poison_reagent = "cyanide"
	var/poison_amount = 50

/obj/item/implant/poison_tooth/meltdown()
	return

/obj/item/implant/poison_tooth/trigger(emote, mob/source)
	if (emote == activation_emote)
		activate()

/obj/item/implant/poison_tooth/activate()
	if(iscarbon(imp_in))
		var/mob/living/carbon/mob = imp_in
		if(!mob.reagents)
			return
		to_chat(mob, SPAN_WARNING("你感觉毒牙碎裂，将少许液体洒入口中……"))
		mob.reagents.add_reagent(poison_reagent, poison_amount)
		playsound(imp_in, 'sound/items/poison_tooth.ogg', 15, TRUE)
	qdel(src)

/obj/item/implant/poison_tooth/implanted(mob/source)
	activation_emote = localized_input_list(usr, "请选择启动表情指令：", "表情指令", list("grin", "smile"))
	if (source.mind)
		source.mind.store_memory("毒牙可通过 [activation_emote] 表情指令咬碎。输入 <B>say *[src.activation_emote]</B> 尝试启动。", 0, 0)
	to_chat(source, SPAN_NOTICE("毒牙可通过 [activation_emote] 表情指令咬碎。输入 <B>say *[src.activation_emote]</B> 尝试启动。"))
	return TRUE

/obj/item/implant/poison_tooth/islegal()
	return FALSE

/obj/item/implant/poison_tooth/preset/implanted(mob/source)
	activation_emote = pick("grin", "smile")
	if (source.mind)
		source.mind.store_memory("毒牙可通过 [activation_emote] 表情指令咬碎。输入 <B>say *[src.activation_emote]</B> 尝试启动。", 0, 0)
	to_chat(source, SPAN_NOTICE("毒牙可通过 [activation_emote] 表情指令咬碎。输入 <B>say *[src.activation_emote]</B> 尝试启动。"))
	return TRUE

/obj/item/implant/poison_tooth/cia
	poison_reagent = "cia_toxin"

/obj/item/implant/poison_tooth/preset/cia
	poison_reagent = "cia_toxin"

/obj/item/implant/poison_tooth/mss
	poison_reagent = "mss_toxin"

/obj/item/implant/poison_tooth/preset/mss
	poison_reagent = "mss_toxin"


/obj/item/storage/syringe_case/poison_tooth
	storage_slots = 4
	can_hold = list(
		/obj/item/implant/poison_tooth,
		/obj/item/tool/surgery/hemostat/miniature,
		/obj/item/paper,
		/obj/item/reagent_container/syringe,
	)

/obj/item/storage/syringe_case/poison_tooth/fill_preset_inventory()
	new /obj/item/implant/poison_tooth(src)
	new /obj/item/tool/surgery/hemostat/miniature(src)
	new /obj/item/reagent_container/syringe/oxycodone(src)
	var/obj/item/paper/paper = new(src)
	paper.info = "1. 注射一剂羟考酮。\n2. 使用<b>止血钳</b>从<b>口腔</b>拔出一颗臼齿。\n3. 小心地装入这颗牙齿。"
	paper.update_icon()
