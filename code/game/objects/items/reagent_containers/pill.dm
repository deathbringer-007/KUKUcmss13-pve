////////////////////////////////////////////////////////////////////////////////
/// Pills.
////////////////////////////////////////////////////////////////////////////////

/// Returns a list mapping pill icon classes to icon states
/proc/map_pill_icons()
	var/list/picks
	var/list/mappings = list()
	for(var/icon_class in PILL_ICON_CLASSES)
		if(!picks) picks = init_list_range(PILL_ICON_CHOICES, 1)
		mappings[icon_class] = "pill[pick_n_take(picks)]"
	// Keep extra as padding for random pills
	picks += init_list_range(PILL_ICON_CHOICES, 1)
	mappings["random"] = picks
	return mappings

/obj/item/reagent_container/pill
	name = "药片"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = null
	item_state = "pill"
	possible_transfer_amounts = null
	w_class = SIZE_TINY
	volume = 60
	reagent_desc_override = TRUE //it has a special examining mechanic
	ground_offset_x = 7
	ground_offset_y = 7
	var/identificable = TRUE //can medically trained people tell what's in it?
	var/pill_desc = "一种不明药片。" // The real description of the pill, shown when examined by a medically trained person
	var/pill_icon_class = "random" // Pills with the same icon class share icons
	var/list/pill_initial_reagents // Default reagents if any
	var/fluff_text = "药片" //what this object is logically, used for actions descriptions like force feeding

/obj/item/reagent_container/pill/Initialize(mapload, ...)
	. = ..()
	if(pill_initial_reagents)
		for(var/reagent in pill_initial_reagents)
			reagents.add_reagent(reagent, pill_initial_reagents[reagent])
	update_icon()

/obj/item/reagent_container/pill/update_icon()
	. = ..()
	if(!icon_state)
		icon_state = GLOB.pill_icon_mappings[pill_icon_class]

/obj/item/reagent_container/pill/get_examine_text(mob/user)
	. = ..()
	if(pill_desc)
		var/pill_info = display_contents(user)
		if(pill_info)
			. += pill_info

/obj/item/reagent_container/pill/display_contents(mob/user)
	if(isxeno(user))
		return
	if(!identificable)
		return
	. = ""
	if(skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_TRAINED))
		. += "[pill_desc]\n"
	. += ..()

/obj/item/reagent_container/pill/attack(mob/M, mob/user)
	if(M == user)
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			if(H.species.flags & IS_SYNTHETIC)
				to_chat(H, SPAN_DANGER("你不能吃[fluff_text]。"))
				return

		M.visible_message(SPAN_NOTICE("[user]吞下了[src]。"),
		SPAN_HELPFUL("你吞下了[src]。"))
		var/list/reagents_in_pill = list()
		for(var/datum/reagent/R in reagents.reagent_list)
			reagents_in_pill += R.name
		var/contained = english_list(reagents_in_pill)
		msg_admin_niche("[key_name(user)] swallowed [src] (REAGENTS: [contained]) in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)
		M.drop_inv_item_on_ground(src) //icon update
		if(reagents && reagents.total_volume)
			reagents.set_source_mob(user)
			reagents.trans_to_ingest(M, reagents.total_volume)

		qdel(src)
		return 1

	else if(istype(M, /mob/living/carbon/human) )
		var/mob/living/carbon/human/H = M
		if(H.species.flags & IS_SYNTHETIC)
			to_chat(H, SPAN_DANGER("对方的脑袋是台显示器，你打算把药塞到哪里去？"))
			return

		user.affected_message(M,
			SPAN_HELPFUL("你<b>开始给</b>[M]<b>喂</b>[fluff_text]。"),
			SPAN_HELPFUL("[user]<b>开始给</b>你<b>喂</b>[fluff_text]。"),
			SPAN_NOTICE("[user]开始给[M]喂[fluff_text]。"))

		var/ingestion_time = 30
		if(user.skills)
			ingestion_time = max(10, 30 - 10*user.skills.get_skill_level(SKILL_MEDICAL))

		if(!do_after(user, ingestion_time, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY, M, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
			return
		if(QDELETED(src))
			return

		user.drop_inv_item_on_ground(src) //icon update

		user.affected_message(M,
			SPAN_HELPFUL("你<b>给</b>[M]<b>喂下了</b>[fluff_text]。"),
			SPAN_HELPFUL("[user]<b>给</b>你<b>喂下了</b>[fluff_text]。"),
			SPAN_NOTICE("[user]给[M]喂下了[fluff_text]。"))
		user.count_niche_stat(STATISTICS_NICHE_PILLS)

		var/rgt_list_text = get_reagent_list_text()

		M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been fed [src.name] by [key_name(user)] Reagents: [rgt_list_text]</font>")
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Fed [M.name] by [key_name(M)] Reagents: [rgt_list_text]</font>")
		msg_admin_attack("[key_name(user)] fed [key_name(M)] with [src.name] (REAGENTS: [rgt_list_text]) (INTENT: [uppertext(intent_text(user.a_intent))]) in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)

		if(reagents && reagents.total_volume)
			reagents.set_source_mob(user)
			reagents.trans_to_ingest(M, reagents.total_volume)
		qdel(src)

		return 1

	return 0

/obj/item/reagent_container/pill/afterattack(obj/target, mob/user, proximity)
	if(!proximity) return

	if(target.is_open_container() != 0 && target.reagents)
		if(!target.reagents.total_volume)
			to_chat(user, SPAN_DANGER("[target]是空的，无法溶解[fluff_text]。"))
			return
		to_chat(user, SPAN_NOTICE("你将[fluff_text]溶解在[target]中。"))

		var/rgt_list_text = get_reagent_list_text()

		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Spiked \a [target] with a [fluff_text]. Reagents: [rgt_list_text]</font>")
		msg_admin_attack("[key_name(user)] spiked \a [target] with a [fluff_text] (REAGENTS: [rgt_list_text]) (INTENT: [uppertext(intent_text(user.a_intent))]) in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)

		reagents.trans_to(target, reagents.total_volume)
		for(var/mob/O in viewers(2, user))
			O.show_message(SPAN_DANGER("[user]往[target]里放了些什么。"), SHOW_MESSAGE_VISIBLE)

		QDEL_IN(src, 5)

	return

////////////////////////////////////////////////////////////////////////////////
/// Pills. END
////////////////////////////////////////////////////////////////////////////////

//Pills
/obj/item/reagent_container/pill/antitox
	pill_desc = "抗毒素药片，可中和多种常见毒素并治疗毒素损伤。"
	pill_initial_reagents = list("anti_toxin" = 15)
	pill_icon_class = "atox"

/obj/item/reagent_container/pill/tox
	pill_desc = "毒素药片，毒性极强。"
	pill_initial_reagents = list("toxin" = 50)
	pill_icon_class = "tox"

/obj/item/reagent_container/pill/cyanide
	desc = "一颗氰化物药丸。别吞下去！"
	pill_desc = null//so even non medics can see what this pill is.
	pill_initial_reagents = list("cyanide" = 50)
	pill_icon_class = "tox"

/obj/item/reagent_container/pill/stox
	pill_desc = "通常用于治疗失眠的安眠药片。"
	pill_initial_reagents = list("stoxin" = 15)
	pill_icon_class = "psych"

/obj/item/reagent_container/pill/kelotane
	pill_desc = "克洛坦药片，用于治疗烧伤。"
	pill_initial_reagents = list("kelotane" = 15)
	pill_icon_class = "kelo"

/obj/item/reagent_container/pill/keloderm
	pill_desc = "克洛坦与德玛林复方药片，用于快速治疗烧伤。"
	pill_initial_reagents = list("kelotane" = 10, "dermaline" = 10)
	pill_icon_class = "kelo"

/obj/item/reagent_container/pill/oxycodone
	pill_desc = "羟考酮药片，一种强效止痛药。"
	pill_initial_reagents = list("oxycodone" = 15)
	pill_icon_class = "oxy"

/obj/item/reagent_container/pill/paracetamol
	pill_desc = "对乙酰氨基酚药片，经久不衰的止痛药。"
	pill_initial_reagents = list("paracetamol" = 15)
	pill_icon_class = "para"

/obj/item/reagent_container/pill/tramadol
	pill_desc = "曲马多药片，一种普通止痛药。"
	pill_initial_reagents = list("tramadol" = 15)
	pill_icon_class = "tram"

/obj/item/reagent_container/pill/methylphenidate
	pill_desc = "哌甲酯药片，可提高专注力。"
	pill_initial_reagents = list("methylphenidate" = 15)
	pill_icon_class = "psych"

/obj/item/reagent_container/pill/citalopram
	pill_desc = "西酞普兰药片，一种温和的抗抑郁药。"
	pill_initial_reagents = list("citalopram" = 15)
	pill_icon_class = "psych"

/obj/item/reagent_container/pill/inaprovaline
	pill_desc = "因纳普罗伐林药片，用于稳定患者的病情。"
	pill_initial_reagents = list("inaprovaline" = 30)
	pill_icon_class = "inap"

/obj/item/reagent_container/pill/dexalin
	pill_desc = "右氧林药片，用于治疗缺氧。"
	pill_initial_reagents = list("dexalin" = 15)
	pill_icon_class = "dex"

/obj/item/reagent_container/pill/dexalinplus
	pill_desc = "强化右氧林药片，可立即缓解缺氧。"
	pill_initial_reagents = list("dexalinp" = 10)
	pill_icon_class = "qc"

/obj/item/reagent_container/pill/spaceacillin
	pill_desc = "太空西林药片，用于减缓病毒感染。"
	pill_initial_reagents = list("spaceacillin" = 10)
	pill_icon_class = "spac"

/obj/item/reagent_container/pill/happy
	pill_desc = "快乐药片！快快乐乐，欢欢喜喜！"
	pill_initial_reagents = list("space_drugs" = 15, "sugar" = 15)
	pill_icon_class = "drug"

/obj/item/reagent_container/pill/zombie_powder
	desc = "一枚散发着死亡气息的奇怪药片。"
	pill_desc = "一颗怪异的药片，散发着死亡的气息。"
	pill_initial_reagents = list("zombiepowder" = 8, "copper" = 2) //roughly two minutes of death
	pill_icon_class = "drug"

/obj/item/reagent_container/pill/russianRed
	pill_desc = "俄罗斯红药片，一种十分危险的抗辐射药物。"
	pill_initial_reagents = list("russianred" = 10)
	pill_icon_class = "spac"
/obj/item/reagent_container/pill/peridaxon
	pill_desc = "佩里达酮药片，可暂时遏制内脏损伤造成的影响。"
	pill_initial_reagents = list("peridaxon" = 7)
	pill_icon_class = "peri"

/obj/item/reagent_container/pill/imidazoline
	pill_desc = "咪唑啉药片，用于治疗眼部损伤。"
	pill_initial_reagents = list("imidazoline" = 10)
	pill_icon_class = "imi"

/obj/item/reagent_container/pill/alkysine
	pill_desc = "神经修复素药片，用于治疗脑损伤。"
	pill_initial_reagents = list("alkysine" = 10)
	pill_icon_class = "alky"

/obj/item/reagent_container/pill/imialk
	pill_desc = "含有咪唑啉和神经修复素的药片，用于治疗脑部和眼部损伤。"
	pill_initial_reagents = list("imidazoline" = 10, "alkysine" = 10)
	pill_icon_class = "imi"

/obj/item/reagent_container/pill/bicaridine
	pill_desc = "比卡定药片，用于治疗物理创伤。"
	pill_initial_reagents = list("bicaridine" = 15)
	pill_icon_class = "bica"

/obj/item/reagent_container/pill/merabica
	pill_desc = "美拉林与比卡定复方药片，用于快速治疗物理创伤。"
	pill_initial_reagents = list("bicaridine" = 10, "meralyne" = 10)
	pill_icon_class = "bica"

/obj/item/reagent_container/pill/ultrazine
	pill_desc = "超能嗪药片，一种强效且持久的中枢神经与肌肉复合兴奋剂，极易成瘾。"
	pill_initial_reagents = list("ultrazine" = 5)
	pill_icon_class = "psych"

/obj/item/reagent_container/pill/ultrazine/unmarked
	pill_desc = "一种不明药片。" // Or is it ?

/obj/item/reagent_container/pill/tricordrazine
	pill_desc = "广效康复嗪药片，一种用于治疗各类损伤的弱效通用药物。"
	pill_initial_reagents = list("tricordrazine" = 15)
	pill_icon_class = "tric"

/obj/item/reagent_container/pill/stimulant
	pill_initial_reagents = list("antag_stimulant" = 10)
	pill_icon_class = "stim"

/obj/item/reagent_container/pill/iron
	pill_desc = "铁补充剂药片，用于促进血液再生。"
	pill_initial_reagents = list("iron" = 15, "sugar" = 7.5)
	pill_icon_class = "spac"

/obj/item/reagent_container/pill/nitrogenwater
	pill_desc = "含有氮和水的药片，用于治疗曲马多过量。"
	pill_initial_reagents = list("nitrogen" = 15, "water" = 15)
	pill_icon_class = "spac"
	color = COLOR_BLUE

/obj/item/reagent_container/pill/carbon
	pill_desc = "一颗大块的活性炭药片。人们通常认为它能有效治疗中毒，但实际上它不足以应对大多数情况，尤其是这种剂量。"
	pill_initial_reagents = list("carbon" = 7.5)
	pill_icon_class = "alky"
	color = "#38352e" //pretty dark but not 100% black

/obj/item/reagent_container/pill/ethylredoxrazine
	pill_desc = "乙醇氧化嗪药片，用于治疗酒精中毒，以及类似化学抑制剂造成的相关影响。"
	pill_initial_reagents = list("ethylredoxrazine" = 7.5)
	pill_icon_class = "alky"
	color = COLOR_OLIVE

