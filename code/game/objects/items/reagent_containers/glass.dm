////////////////////////////////////////////////////////////////////////////////
/// (Mixing) Glass
////////////////////////////////////////////////////////////////////////////////

/obj/item/reagent_container/glass
	name = " "
	var/base_name = " "
	desc = " "
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = null
	item_state = null
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60)
	volume = 60
	var/splashable = TRUE
	flags_atom = FPRINT|OPENCONTAINER
	transparent = TRUE

	var/list/can_be_placed_into = list(
		/obj/structure/machinery/chem_master/,
		/obj/structure/machinery/chem_dispenser/,
		/obj/structure/machinery/reagentgrinder,
		/obj/structure/surface/table,
		/obj/structure/closet,
		/obj/structure/sink,
		/obj/item/storage,
		/obj/item/clothing,
		/obj/structure/machinery/cryo_cell,
		/obj/item/explosive,
		/obj/item/mortar_shell/custom,
		/obj/item/ammo_magazine/rocket/custom,
		/obj/structure/machinery/bot/medbot,
		/obj/structure/machinery/computer/pandemic,
		/obj/item/storage/secure/safe,
		/obj/structure/machinery/iv_drip,
		/obj/structure/machinery/disposal,
		/mob/living/simple_animal/cow,
		/mob/living/simple_animal/hostile/retaliate/goat,
		/obj/structure/machinery/medical_pod/sleeper,
		/obj/structure/machinery/smartfridge/,
		/obj/structure/machinery/biogenerator,
		/obj/structure/machinery/reagent_analyzer,
		/obj/structure/machinery/centrifuge,
		/obj/structure/machinery/autodispenser,
		/obj/structure/machinery/constructable_frame)

/obj/item/reagent_container/glass/Initialize()
	. = ..()
	base_name = name

/obj/item/reagent_container/glass/get_examine_text(mob/user)
	. = ..()
	if(get_dist(user, src) > 2 && user != loc)
		return
	if(!is_open_container())
		. += SPAN_INFO("气密盖将它完全封住。")

/obj/item/reagent_container/glass/attack_self()
	..()
	if(splashable)
		if(is_open_container())
			to_chat(usr, SPAN_NOTICE("你盖上了[src]的盖子。"))
			flags_atom ^= OPENCONTAINER
		else
			to_chat(usr, SPAN_NOTICE("你取下了[src]的盖子。"))
			flags_atom |= OPENCONTAINER
		update_icon()

/obj/item/reagent_container/glass/afterattack(obj/target, mob/user , flag)
	if(!reagents)
		create_reagents(volume)

	if(!is_open_container_or_can_be_dispensed_into() || !flag)
		return

	for(var/type in src.can_be_placed_into)
		if(istype(target, type))
			return

	if(is_open_container() && ismob(target) && target.reagents && reagents.total_volume && user.a_intent == INTENT_HARM && splashable)
		to_chat(user, SPAN_NOTICE("你将溶液泼到[target]上。"))
		playsound(target, 'sound/effects/slosh.ogg', 25, 1)

		var/mob/living/M = target
		var/list/injected = list()
		for(var/datum/reagent/R in src.reagents.reagent_list)
			injected += R.name
		var/contained = english_list(injected)
		M.last_damage_data = create_cause_data(initial(name), user)
		M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been splashed with [src.name] by [user.name] ([user.ckey]). Reagents: [contained]</font>")
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to splash [M.name] ([M.key]). Reagents: [contained]</font>")
		msg_admin_attack("[user.name] ([user.ckey]) splashed [M.name] ([M.key]) with [src.name] (REAGENTS: [contained]) (INTENT: [uppertext(intent_text(user.a_intent))]) in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)

		visible_message(SPAN_WARNING("[user]向[target]泼了什么东西！"))
		reagents.reaction(target, TOUCH)
		if(!QDELETED(src))
			reagents.clear_reagents()
		return
	else if(istype(target, /obj/structure/reagent_dispensers)) //A dispenser. Transfer FROM it TO us.
		var/obj/structure/reagent_dispensers/D = target
		D.add_fingerprint(user)
		if(D.dispensing)
			if(!target.reagents.total_volume && target.reagents)
				to_chat(user, SPAN_WARNING("[target]是空的。"))
				return

			if(reagents.total_volume >= reagents.maximum_volume)
				to_chat(user, SPAN_WARNING("[src]已经装满。"))
				return

			var/trans = target.reagents.trans_to(src, target:amount_per_transfer_from_this)

			if(!trans)
				to_chat(user, SPAN_DANGER("你没能从[target]中抽取试剂。"))
				return

			to_chat(user, SPAN_NOTICE("你将[target]中[trans]单位的内容物装入[src]。"))
		else
			if(is_open_container_or_can_be_dispensed_into())
				if(reagents && !reagents.total_volume)
					to_chat(user, SPAN_WARNING("[src]是空的。"))
					return

				if(D.reagents.total_volume >= D.reagents.maximum_volume)
					to_chat(user, SPAN_WARNING("[D]已经装满。"))
					return

				var/trans = reagents.trans_to(D, D:amount_per_transfer_from_this)

				if(!trans)
					to_chat(user, SPAN_DANGER("你没能向[target]中加入试剂。"))
					return

				to_chat(user, SPAN_NOTICE("你将[src]中[trans]单位的内容物装入[D]。"))
			else
				to_chat(user, SPAN_WARNING("你必须先打开容器！"))

	else if(is_open_container() && target.is_open_container() && target.reagents) //Something like a glass. Player probably wants to transfer TO it.

		if(!reagents.total_volume)
			to_chat(user, SPAN_WARNING("[src]是空的。"))
			return

		if(target.reagents.total_volume >= target.reagents.maximum_volume)
			to_chat(user, SPAN_WARNING("[target]已经装满。"))
			return

		var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this)

		if(!trans)
			to_chat(user, SPAN_DANGER("你没能向[target]中加入试剂。"))
			return

		to_chat(user, SPAN_NOTICE("你向[target]中转移了[trans]单位溶液。"))

	else if(istype(target, /obj/structure/machinery/smartfridge))
		return

	else if(is_open_container() && (reagents.total_volume) && (user.a_intent == INTENT_HARM) && splashable)
		to_chat(user, SPAN_NOTICE("你将溶液泼到[target]上。"))
		playsound(target, 'sound/effects/slosh.ogg', 25, 1)
		reagents.reaction(target, TOUCH)
		if(!QDELETED(src))
			reagents.clear_reagents()
		return

/obj/item/reagent_container/glass/attackby(obj/item/W as obj, mob/user as mob)
	if(HAS_TRAIT(W, TRAIT_TOOL_PEN))
		var/prior_label_text
		var/datum/component/label/labelcomponent = src.GetComponent(/datum/component/label)
		if(labelcomponent)
			prior_label_text = labelcomponent.label_name
		var/tmp_label = sanitize(input(user, "为[name]输入标签","Label", prior_label_text))
		if(tmp_label == "" || !tmp_label)
			if(labelcomponent)
				labelcomponent.remove_label()
				user.visible_message(SPAN_NOTICE("[user]撕下了[src]上的标签。"), \
				SPAN_NOTICE("你撕下了[src]上的标签。"))
				return
			else
				return
		if(length(tmp_label) > MAX_NAME_LEN)
			to_chat(user, SPAN_WARNING("标签最多只能有[MAX_NAME_LEN]个字符。"))
		else
			user.visible_message(SPAN_NOTICE("[user]给[src]贴上“[tmp_label]”的标签。"), \
			SPAN_NOTICE("你给[src]贴上“[tmp_label]”的标签。"))
			AddComponent(/datum/component/label, tmp_label)
			playsound(src, "paper_writing", 15, TRUE)
	else
		. = ..()

/obj/item/reagent_container/glass/beaker
	name = "烧杯"
	desc = "一个烧杯，最多容纳 60 单位。"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "beaker"
	item_state = "beaker"
	matter = list("glass" = 500)
	attack_speed = 4

/obj/item/reagent_container/glass/beaker/on_reagent_change()
	update_icon()

/obj/item/reagent_container/glass/beaker/pickup(mob/user)
	..()
	update_icon()

/obj/item/reagent_container/glass/beaker/dropped(mob/user)
	..()
	update_icon()

/obj/item/reagent_container/glass/beaker/attack_hand()
	..()
	update_icon()

/obj/item/reagent_container/glass/beaker/update_icon()
	overlays.Cut()

	if(reagents && reagents.total_volume)
		var/image/filling = image('icons/obj/items/reagentfillings.dmi', src, "[icon_state]10")

		var/percent = floor((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 9) filling.icon_state = "[icon_state]-10"
			if(10 to 24) filling.icon_state = "[icon_state]10"
			if(25 to 49) filling.icon_state = "[icon_state]25"
			if(50 to 74) filling.icon_state = "[icon_state]50"
			if(75 to 79) filling.icon_state = "[icon_state]75"
			if(80 to 90) filling.icon_state = "[icon_state]80"
			if(91 to INFINITY) filling.icon_state = "[icon_state]100"

		filling.color = mix_color_from_reagents(reagents.reagent_list)
		overlays += filling

	if(!is_open_container())
		var/image/lid = image(icon, src, "lid_[initial(icon_state)]")
		overlays += lid

/obj/item/reagent_container/glass/minitank
	name = "MS-11 智能补充罐"
	desc = "坚固的小型储罐，可补充原本需要纳米医疗系统才能补充的自动注射器。依靠微芯片技术，它能自动将合适的药剂注入大多数单药剂自动注射器，但无法只补充一部分。顶部阀门可将试剂转移至其他容器，或彻底排空。"
	icon = 'icons/obj/items/tank.dmi'
	icon_state = "mini_reagent_tank"
	matter = list("metal" = 500)
	attack_speed = 4
	volume = 180
	w_class = SIZE_SMALL
	splashable = FALSE
	can_be_placed_into = list(
		/obj/structure/machinery/chem_master/,
		/obj/structure/machinery/chem_dispenser/,
		/obj/structure/machinery/reagentgrinder,
		/obj/structure/surface/table,
		/obj/structure/closet,
		/obj/structure/sink,
		/obj/item/storage,
		/obj/item/clothing,
		/obj/structure/machinery/bot/medbot,
		/obj/structure/machinery/computer/pandemic,
		/obj/item/storage/secure/safe,
		/obj/structure/machinery/iv_drip,
		/obj/structure/machinery/disposal,
		/obj/structure/machinery/medical_pod/sleeper,
		/obj/structure/machinery/smartfridge/,
		/obj/structure/machinery/biogenerator,
		/obj/structure/machinery/reagent_analyzer,
		/obj/structure/machinery/centrifuge,
		/obj/structure/machinery/autodispenser,
		/obj/structure/machinery/constructable_frame,
	)

/obj/item/reagent_container/glass/minitank/on_reagent_change()
	update_icon()


/obj/item/reagent_container/glass/minitank/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/reagent_container/hypospray/autoinjector))
		var/obj/item/reagent_container/hypospray/autoinjector/A = W
		if(A.mixed_chem)
			to_chat(user, SPAN_WARNING("自动注射器接不上[src]的阀门，大概不兼容。"))
			return
		if(reagents.has_reagent(A.chemname, A.volume))
			reagents.trans_id_to(A, A.chemname, A.volume)
			A.uses_left = 3
			A.update_icon()
			playsound(src.loc, 'sound/effects/refill.ogg', 25, 1, 3)
		else
			to_chat(user, SPAN_WARNING("[src]上的小 LED 闪了闪。储罐无法给[A]补充药剂，可能是不兼容，也可能是相应药剂不足！"))
			. = ..()
			return
		to_chat(user, SPAN_INFO("你成功用[src]为[A]补充了药剂！"))

/obj/item/reagent_container/glass/minitank/verb/flush_tank(mob/user)
	set category = "Object"
	set name = "排空储罐"
	set src in usr
	if(usr.is_mob_incapacitated()) return
	if(src.reagents.total_volume == 0)
		to_chat(user, SPAN_WARNING("里面已经空了！"))
		return
	playsound(src.loc, 'sound/effects/slosh.ogg', 25, 1, 3)
	to_chat(user, SPAN_WARNING("你操作排空阀，成功排空了[src]！"))
	reagents.clear_reagents()
	update_icon() // just to be sure
	return

/obj/item/reagent_container/glass/minitank/update_icon()
	overlays.Cut()
	if(reagents && reagents.total_volume)
		var/image/filling = image('icons/obj/items/reagentfillings.dmi', src, "[icon_state]10")
		var/percent = floor((reagents.total_volume / volume) * 100)
		var/round_percent = 0
		if(percent > 24) round_percent = round(percent, 25)
		else round_percent = 10
		filling.icon_state = "[icon_state][round_percent]"
		filling.color = mix_color_from_reagents(reagents.reagent_list)
		overlays += filling

/obj/item/reagent_container/glass/beaker/large
	name = "大型烧杯"
	desc = "一个大烧杯，最多容纳 120 单位。"
	icon_state = "beakerlarge"
	matter = list("glass" = 5000)
	volume = 120
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60,120)

/obj/item/reagent_container/glass/beaker/silver
	name = "大型银烧杯"
	desc = "大型银烧杯，容量 240 单位，烧杯本身可作为银催化剂。"
	icon_state = "beakersilver"
	volume = 240
	matter = list("silver" = 5000)
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60,120,240)
	pixel_y = 5

/obj/item/reagent_container/glass/beaker/noreact
	name = "低温静滞烧杯"
	desc = "储存化学品时可阻止其发生反应的低温静滞烧杯，容量 60 单位。"
	icon_state = "beakernoreact"
	matter = list("glass" = 500)
	volume = 60
	amount_per_transfer_from_this = 10
	flags_atom = FPRINT|OPENCONTAINER|NOREACT

/obj/item/reagent_container/glass/beaker/bluespace
	name = "蓝空间烧杯"
	desc = "容量加大的烧杯，采用蓝色有机玻璃以承受更高压力，因此被亲切地称为“蓝空间”。容量 300 单位。"
	icon_state = "beakerbluespace"
	matter = list("glass" = 10000)
	volume = 300
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,20,25,30,40,60,80,120,300)


/obj/item/reagent_container/glass/beaker/vial
	name = "小药瓶"
	desc = "小玻璃试管，最多容纳 30 单位。"
	icon_state = "vial"
	volume = 30
	amount_per_transfer_from_this = 10
	matter = list()
	possible_transfer_amounts = list(5,10,15,25,30)
	flags_atom = FPRINT|OPENCONTAINER
	ground_offset_x = 9
	ground_offset_y = 8

/obj/item/reagent_container/glass/beaker/vial/epinephrine
	name = "肾上腺素小药瓶"

/obj/item/reagent_container/glass/beaker/vial/epinephrine/Initialize()
	. = ..()
	reagents.add_reagent("adrenaline", 30)
	update_icon()

/obj/item/reagent_container/glass/beaker/vial/tricordrazine
	name = "广效康复嗪小药瓶"

/obj/item/reagent_container/glass/beaker/vial/tricordrazine/Initialize()
	. = ..()
	reagents.add_reagent("tricordrazine", 30)
	update_icon()

/obj/item/reagent_container/glass/beaker/vial/sedative
	name = "水合氯醛小药瓶"

/obj/item/reagent_container/glass/beaker/vial/sedative/Initialize()
	. = ..()
	reagents.add_reagent("chloralhydrate", 30)
	update_icon()

/obj/item/reagent_container/glass/beaker/vial/kilodermlipo
	name = "小药瓶（体温稳定）"
	desc = "内含用于稳定体温的利波拉嗪，以及用于快速治疗烧伤的克洛坦和德玛林，三者比例为 1:2:3。"

/obj/item/reagent_container/glass/beaker/vial/kilodermlipo/Initialize()
	. = ..()
	reagents.add_reagent("leporazine", 5)
	reagents.add_reagent("kelotane", 10)
	reagents.add_reagent("dermaline", 15)
	update_icon()

/obj/item/reagent_container/glass/beaker/vial/random
	var/tier

/obj/item/reagent_container/glass/beaker/vial/random/Initialize()
	. = ..()
	var/random_chem
	if(tier)
		random_chem = pick(GLOB.chemical_gen_classes_list[tier])
	else
		random_chem = pick( prob(3);pick(GLOB.chemical_gen_classes_list["C1"]),\
							prob(5);pick(GLOB.chemical_gen_classes_list["C2"]),\
							prob(7);pick(GLOB.chemical_gen_classes_list["C3"]),\
							prob(10);pick(GLOB.chemical_gen_classes_list["C4"]),\
							prob(15);pick(GLOB.chemical_gen_classes_list["C5"]),\
							prob(25);pick(GLOB.chemical_gen_classes_list["T1"]),\
							prob(15);pick(GLOB.chemical_gen_classes_list["T2"]),\
							prob(10);pick(GLOB.chemical_gen_classes_list["T3"]),\
							prob(5);pick(GLOB.chemical_gen_classes_list["T4"]),\
							prob(15);"")
	if(random_chem)
		reagents.add_reagent(random_chem, 30)
		update_icon()

/obj/item/reagent_container/glass/beaker/vial/random/good/Initialize()
	tier = pick("C5","T4")
	. = ..()

/obj/item/reagent_container/glass/beaker/cryoxadone
	name = "低温修复酮烧杯"

/obj/item/reagent_container/glass/beaker/cryoxadone/Initialize()
	. = ..()
	reagents.add_reagent("cryoxadone", 30)
	update_icon()

/obj/item/reagent_container/glass/beaker/cryopredmix
	name = "低温混合药剂烧杯"

/obj/item/reagent_container/glass/beaker/cryopredmix/Initialize()
	. = ..()
	reagents.add_reagent("cryoxadone", 30)
	reagents.add_reagent("clonexadone", 30)
	update_icon()

/obj/item/reagent_container/glass/beaker/sulphuric
	name = "硫酸烧杯"

/obj/item/reagent_container/glass/beaker/sulphuric/Initialize()
	. = ..()
	reagents.add_reagent("sulphuric acid", 60)
	update_icon()

/obj/item/reagent_container/glass/beaker/ethanol
	name = "乙醇烧杯"

/obj/item/reagent_container/glass/beaker/ethanol/Initialize()
	. = ..()
	reagents.add_reagent("ethanol", 60)
	update_icon()

/obj/item/reagent_container/glass/beaker/large/phosphorus
	name = "磷烧杯"

/obj/item/reagent_container/glass/beaker/large/phosphorus/Initialize()
	. = ..()
	reagents.add_reagent("phosphorus", 120)
	update_icon()

/obj/item/reagent_container/glass/beaker/large/lithium
	name = "锂烧杯"

/obj/item/reagent_container/glass/beaker/large/lithium/Initialize()
	. = ..()
	reagents.add_reagent("lithium", 120)
	update_icon()

/obj/item/reagent_container/glass/beaker/large/sodiumchloride
	name = "氯化钠烧杯"

/obj/item/reagent_container/glass/beaker/large/sodiumchloride/Initialize()
	. = ..()
	reagents.add_reagent("sodiumchloride", 120)
	update_icon()

/obj/item/reagent_container/glass/beaker/large/potassiumchloride
	name = "氯化钾烧杯"

/obj/item/reagent_container/glass/beaker/large/potassiumchloride/Initialize()
	. = ..()
	reagents.add_reagent("potassium_chloride", 120)
	update_icon()

/obj/item/reagent_container/glass/canister
	name = "氢气罐"
	desc = "内装加压氢气的罐子，可补充储罐。"
	icon = 'icons/obj/items/tank.dmi'
	icon_state = "canister_hydrogen"
	item_state = "anesthetic"
	amount_per_transfer_from_this = 100
	possible_transfer_amounts = list(50,100,200,300,400)
	volume = 400
	splashable = FALSE // you can't spill a canister
	var/reagent = "hydrogen"

/obj/item/reagent_container/glass/canister/Initialize()
	. = ..()
	reagents.add_reagent(reagent, 400)

/obj/item/reagent_container/glass/canister/afterattack(obj/target, mob/user , flag)
	if(!istype(target, /obj/structure/reagent_dispensers))
		return
	. = ..()

/obj/item/reagent_container/glass/canister/ammonia
	name = "氨气罐"
	desc = "内装加压氨的罐子，可补充储罐。"
	icon_state = "canister_ammonia"
	reagent = "ammonia"

/obj/item/reagent_container/glass/canister/methane
	name = "甲烷罐"
	desc = "内装加压甲烷的罐子，可补充储罐。"
	icon_state = "canister_methane"
	reagent = "methane"

/obj/item/reagent_container/glass/canister/pacid
	name = "聚三酸罐"
	desc = "内装加压聚三酸的罐子，可补充储罐。"
	icon_state = "canister_pacid"
	reagent = "pacid"

/obj/item/reagent_container/glass/canister/oxygen
	name = "氧气罐"
	desc = "内装加压氧气的罐子，可补充储罐。"
	icon_state = "canister_oxygen"
	reagent = "oxygen"

/obj/item/reagent_container/glass/pressurized_canister // See the Pressurized Reagent Canister Pouch
	name = "加压药剂罐"
	desc = "加压容器，是加压试剂罐携行袋的内部组件。仅兼容其专用携行袋、机器或储罐。"
	icon = 'icons/obj/items/tank.dmi'
	icon_state = "pressurized_reagent_container"
	item_state = "anesthetic"
	amount_per_transfer_from_this = 0
	possible_transfer_amounts = null
	volume = 480
	splashable = FALSE
	w_class = SIZE_MASSIVE
	flags_atom = CAN_BE_DISPENSED_INTO
	matter = list("glass" = 2000)

/obj/item/reagent_container/glass/pressurized_canister/Initialize()
	. = ..()
	update_icon()

/obj/item/reagent_container/glass/pressurized_canister/attackby(obj/item/I, mob/user)
	return

/obj/item/reagent_container/glass/pressurized_canister/afterattack(obj/target, mob/user, flag)
	if(!istype(target, /obj/structure/reagent_dispensers))
		return
	. = ..()

/obj/item/reagent_container/glass/pressurized_canister/on_reagent_change()
	update_icon()

/obj/item/reagent_container/glass/pressurized_canister/update_icon()
	color = COLOR_WHITE
	if(reagents)
		color = mix_color_from_reagents(reagents.reagent_list)
	..()

/obj/item/reagent_container/glass/bucket
	desc = "一个水桶，容量 120 单位。"
	name = "水桶"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "bucket"
	item_state = "bucket"
	matter = list("metal" = 2000)
	w_class = SIZE_MEDIUM
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = list(10,20,30,60,120)
	volume = 120
	flags_atom = FPRINT|OPENCONTAINER

/obj/item/reagent_container/glass/bucket/attackby(obj/item/I, mob/user)
	if(isprox(I))
		to_chat(user, "你将[I]放入[src]。")
		qdel(I)
		user.put_in_hands(new /obj/item/frame/bucket_sensor)
		user.drop_inv_item_on_ground(src)
		qdel(src)
	else if(istype(I, /obj/item/tool/mop))
		var/obj/item/tool/mop/mop = I
		if(reagents.total_volume < 1)
			to_chat(user, SPAN_WARNING("[src]没水了！"))
		else
			reagents.trans_to(mop, mop.max_reagent_volume)
			mop.update_icon()
			to_chat(user, SPAN_NOTICE("你将[mop]浸入[src]中润湿。"))
			playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
		return
	else
		..()

/obj/item/reagent_container/glass/bucket/on_reagent_change()
	update_icon()

/obj/item/reagent_container/glass/bucket/pickup(mob/user)
	..()
	update_icon()

/obj/item/reagent_container/glass/bucket/dropped(mob/user)
	..()
	update_icon()

/obj/item/reagent_container/glass/bucket/attack_hand()
	..()
	update_icon()

/obj/item/reagent_container/glass/bucket/update_icon()
	overlays.Cut()

	if(reagents && reagents.total_volume)
		var/image/filling = image('icons/obj/items/reagentfillings.dmi', src, "[icon_state]-00-65")

		var/percent = floor((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 33) filling.icon_state = "[icon_state]-00-33"
			if(34 to 65) filling.icon_state = "[icon_state]-34-65"
			if(66 to INFINITY) filling.icon_state = "[icon_state]-66-100"

		filling.color = mix_color_from_reagents(reagents.reagent_list)
		overlays += filling

	if(!is_open_container())
		var/image/lid = image(icon, src, "lid_[initial(icon_state)]")
		overlays += lid

/obj/item/reagent_container/glass/bucket/mopbucket
	name = "拖把桶"
	desc = "较大的水桶，通常搭配拖把使用，容量 240 单位。"
	icon_state = "mopbucket"
	matter = list("metal" = 4000)
	w_class = SIZE_LARGE
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = list(10,20,30,60,120,240)
	volume = 240
	flags_atom = FPRINT|OPENCONTAINER

/obj/item/reagent_container/glass/bucket/janibucket
	name = "清洁水桶"
	desc = "能放入清洁推车的大桶，容量 500 单位。"
	icon_state = "janibucket"
	matter = list("metal" = 8000)
	w_class = SIZE_LARGE
	volume = 500


/obj/item/reagent_container/glass/rag
	name = "湿抹布"
	desc = "你猜是用来清理脏东西的。"
	w_class = SIZE_TINY
	icon = 'icons/obj/items/items.dmi'
	icon_state = "rag"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5)
	splashable = FALSE
	volume = 5
	can_be_placed_into = null
	flags_atom = FPRINT|OPENCONTAINER
	flags_item = NOBLUDGEON

/obj/item/reagent_container/glass/rag/attack(atom/target, mob/user)
	if(ismob(target) && target.reagents && reagents.total_volume)
		user.visible_message(SPAN_DANGER("[user]用[src]捂住了[target]！"), SPAN_DANGER("你用[src]捂住了[target]！"), "你听到挣扎声和低沉惊叫。")
		src.reagents.reaction(target, TOUCH)
		spawn(5) src.reagents.clear_reagents()
		return
	else
		..()

/obj/item/reagent_container/glass/rag/afterattack(atom/movable/AM, mob/user, proximity)
	if(!proximity)
		return
	if(istype(AM) && (src in user))
		user.visible_message("[user]开始用[src]擦拭[AM]！")
		if(do_after(user,30, INTERRUPT_ALL, BUSY_ICON_GENERIC))
			user.visible_message("[user]擦干净了[AM]！")
			AM.clean_blood()
