//Vendor for CL stuff
//Bribe items may help marines, but also give CL more control over them
//Bought with points, which regenerate over time

/obj/item/device/portable_vendor
	name = "\improper 自动存取公文箱"
	desc = "公文箱大小的自动存取系统，可高效存放小件物品，并按需取出。"
	icon = 'icons/obj/items/storage/briefcases.dmi'
	icon_state = "secure"
	flags_atom = FPRINT|CONDUCT
	force = 8
	hitsound = "swing_hit"
	throw_speed = SPEED_FAST
	throw_range = 4
	w_class = SIZE_LARGE

	/// to be compared with assigned_role to only allow those to use that machine.
	var/req_role = ""
	var/points = 40
	var/max_points = 50
	var/use_points = TRUE
	var/fabricating = FALSE
	var/broken = FALSE
	var/contraband = FALSE
	var/covert = FALSE //covert = no light, no sound
	var/delay = 3 SECONDS //fabricating time, in seconds

	var/list/purchase_log = list()

	var/list/listed_products = list()
	var/list/contraband_products = list()

	/// needs to be a time define
	var/special_prod_time_lock
	/// list of typepaths
	var/list/special_prods

/obj/item/device/portable_vendor/attack_hand(mob/user)
	if(loc == user)
		attack_self(user)
	else
		..()


/obj/item/device/portable_vendor/attack_self(mob/user)
	..()

	if(!ishuman(user))
		return

	var/mob/living/carbon/human/human_user = user

	src.add_fingerprint(usr)

	if(broken)
		to_chat(user, SPAN_NOTICE("[src]已经损坏，无法修复。"))
		return

	if(!allowed(user))
		to_chat(user, SPAN_WARNING("访问被拒绝。"))
		return

	var/obj/item/card/id/idcard = human_user.get_idcard()
	if(!idcard) //not wearing an ID
		to_chat(human_user, SPAN_WARNING("访问被拒绝。未检测到身份识别卡。"))
		return

	if(!idcard.check_biometrics(human_user))
		to_chat(human_user, SPAN_WARNING("检测到身份识别卡持有者不符。"))
		return

	if(req_role && idcard.rank != req_role)
		to_chat(human_user, SPAN_WARNING("你无权使用此设备。"))
		return


	user.set_interaction(src)
	tgui_interact(user)

/obj/item/device/portable_vendor/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PortableVendor", "[src]")
		ui.open()

/obj/item/device/portable_vendor/ui_data(mob/user)
	. = ..()

	var/list/available_items = list()
	for(var/index in 1 to length(listed_products))
		var/product = listed_products[index]

		var/name = product[1]
		var/cost = product[2]
		var/color = product[4]
		var/description = product[5]

		if(cost > 0)
			name += "（[cost] 点数）"

		var/available = points >= product[2] || !use_points
		available_items += list(list("index" = index, "name" = name, "cost" = cost, "available" = available, "color" = color, "description" = description))

	if(contraband)
		var/non_contraband_product_count = length(listed_products)
		for(var/index in 1 to length(contraband_products))
			var/product = contraband_products[index]

			var/name = product[1]
			var/cost = product[2]
			var/color = product[4]
			var/description = product[5]

			if(cost > 0)
				name += "（[cost] 点数）"

			var/available = points >= product[2] || !use_points
			available_items += list(list("index" = index + non_contraband_product_count, "name" = name, "cost" = cost, "available" = available, "color" = color, "description" = description))

	.["vendor_name"] = name
	.["show_points"] = use_points
	.["current_points"] = floor(points)
	.["max_points"] = max_points
	.["displayed_records"] = available_items


/obj/item/device/portable_vendor/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("vend")
			vend(text2num(params["choice"]), ui.user)

/obj/item/device/portable_vendor/proc/vend(choice, mob/user)
	if(broken)
		return

	if(user.is_mob_incapacitated())
		return

	if(!(in_range(src, user) || ishuman(user)))
		return

	user.set_interaction(src)

	if(!allowed(user))
		to_chat(user, SPAN_WARNING("访问被拒绝。"))
		return

	var/mob/living/carbon/human/human_user = user
	var/obj/item/card/id/id = human_user.get_idcard()

	if(!istype(id))
		to_chat(human_user, SPAN_WARNING("访问被拒绝。未检测到身份识别卡。"))
		return

	if(req_role && req_role != id.rank)
		to_chat(human_user, SPAN_WARNING("你无权使用此设备。"))

	var/list/product
	var/non_contraband_product_count = length(listed_products)
	if(choice > non_contraband_product_count)
		choice -= non_contraband_product_count
		product = contraband_products[choice]
	else
		product = listed_products[choice]

	var/cost = product[2]

	if(use_points && points < cost)
		to_chat(human_user, SPAN_WARNING("点数不足。"))
		return

	var/turf/current_turf = get_turf(src)
	if(length(current_turf.contents) > 25)
		to_chat(human_user, SPAN_WARNING("地面堆放的东西太多，请腾出一些空间。"))
		return

	if(special_prod_time_lock && (product[3] in special_prods))
		if(ROUND_TIME < special_prod_time_lock)
			to_chat(usr, SPAN_WARNING("[src]仍在制造[product[1]]，请再等 [floor((SSticker.mode.round_time_lobby + special_prod_time_lock-world.time)/600)] 分钟后重试。"))
			return

	if(use_points)
		points -= cost

	purchase_log += "[key_name(usr)] bought [product[1]]."

	if(!covert)
		playsound(src, "sound/machines/fax.ogg", 5)
	fabricating = TRUE
	update_overlays()

	addtimer(CALLBACK(src, PROC_REF(spawn_product), product[3], user), delay)

/obj/item/device/portable_vendor/proc/spawn_product(typepath, mob/user)
	var/obj/new_item = new typepath(get_turf(src))
	user.put_in_any_hand_if_possible(new_item)
	fabricating = FALSE
	update_overlays()

/obj/item/device/portable_vendor/proc/update_overlays()
	if(covert)
		return

	if(overlays) overlays.Cut()
	if (broken)
		overlays += image(icon, "securespark")
	else if (fabricating)
		overlays += image(icon, "secureb")
	else
		overlays += image(icon, "secure0")


/obj/item/device/portable_vendor/process()
	points = min(max_points, points+0.05)

/obj/item/device/portable_vendor/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)
	update_overlays()

/obj/item/device/portable_vendor/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()


/obj/item/device/portable_vendor/proc/malfunction()
	var/turf/T = get_turf(src)
	T.visible_message(SPAN_WARNING("[src]剧烈震动，内部零件纷纷损坏！"))
	broken = 1
	STOP_PROCESSING(SSobj, src)
	update_overlays()

	playsound(src, 'sound/effects/sparks4.ogg', 60, 1)
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(2, 1, src)
	s.start()

/obj/item/device/portable_vendor/emp_act(severity)
	. = ..()
	if (broken)
		return
	if (prob(40*severity))
		malfunction()

/obj/item/device/portable_vendor/ex_act(severity)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if(prob(80))
				malfunction()
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				deconstruct(FALSE)
				return
			else
				malfunction()
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)
			return


/obj/item/device/portable_vendor/corporate
	name = "\improper 维兰德-汤谷自动存取公文箱"
	desc = "公文箱大小的自动存取系统，可高效存放小件物品，并按需取出。本品侧面印有维兰德-汤谷标志。"

	special_prod_time_lock = CL_BRIEFCASE_TIME_LOCK
	special_prods = list(/obj/item/implanter/neurostim, /obj/item/reagent_container/hypospray/autoinjector/ultrazine/liaison)

	req_access = list(ACCESS_WY_EXEC)
	req_role = JOB_CORPORATE_LIAISON
	listed_products = list(
		list("激励用品", 0, null, null, null),
		list("公司安保保镖", 50, /obj/item/handheld_distress_beacon/bodyguard, "white", "向公司安保部门发送加密消息，请求派遣一名公司安保保镖的信标。"),
		list("公司律师团队", 50, /obj/item/handheld_distress_beacon/lawyer, "white", "向公司事务部门发送加密消息，请求派遣公司律师的信标。合同签署人违反条款时需要使用。"),
		list("神经刺激植入物", 30, /obj/item/implanter/neurostim, "white", "调节伤害感受与感官功能的植入物，可减轻疼痛、改善平衡，并提高对过度刺激和定向障碍的抵抗力。为促使受植者服从，它在听到现场说出的口令（不接受无线电）后会施加负面刺激。植入物会随着时间推移被人体免疫系统分解，故障频率逐渐上升。不建议自行使用。"),
		list("超能嗪注射器", 25, /obj/item/reagent_container/hypospray/autoinjector/ultrazine/liaison, "white", "高度成瘾的兴奋剂。短时间内增强身体表现，尤其是奔跑速度。每次注射效果持续约 10 分钟，一次使用超过两针会导致过量。戒断会造成极度不适和幻觉，长期使用会导致幻觉及器官衰竭。有条件地发放可确保使用者服从。不得自行使用。"),
		list("氰化物药丸", 20, /obj/item/reagent_container/pill/cyanide, "white", "一颗氰化物药丸，也称自杀药丸。用来一了百了。"),
		list("陶瓷餐盘", 10, /obj/item/trash/ceramic_plate, "white", "一只陶瓷餐盘，在各种场合都能派上用场。"),
		list("现金", 5, /obj/item/spacecash/c1000/counterfeit, "white", "1000 美元，无标记钞票。"),
		list("维兰德-汤谷加密密钥", 5, /obj/item/device/encryptionkey/WY, "white", "维兰德-汤谷私人通讯加密密钥，用于处理私人事务。"),

		list("烟草用品", 0, null, null, null),
		list("雪茄", 5, /obj/item/storage/fancy/cigar, "white", "一盒未被动过手脚的优质雪茄。"),
		list("香烟", 5, /obj/item/storage/fancy/cigarettes/wypacket, "white", "维兰德-汤谷金装香烟，满足更讲究的品味。"),
		list("芝宝打火机", 5, /obj/item/tool/lighter/zippo/executive, "white", "维兰德-汤谷品牌的芝宝打火机，专为讲究派头的烟客准备。"),

		list("饮品", 0, null, null, null),
		list("清酒", 5, /obj/item/reagent_container/food/drinks/bottle/sake, "white", "维兰德-汤谷清酒，适合正式商务晚宴。"),
		list("啤酒", 5, /obj/item/reagent_container/food/drinks/cans/aspen, "white", "维兰德-汤谷阿斯彭啤酒，适合轻松惬意的夜晚。"),
		list("玻璃杯", 1, /obj/item/reagent_container/food/drinks/drinkingglass, "white", "一只玻璃杯，衬托你的品味。"),
		list("维兰德-汤谷咖啡杯", 1, /obj/item/reagent_container/food/drinks/coffeecup/wy, "white", "维兰德-汤谷咖啡杯，送给想要公司纪念品的陆战队员。"),

		list("文具", 0, null, null, null),
		list("维兰德-汤谷黑色笔", 1, /obj/item/tool/pen/clicky, "white", "维兰德-汤谷出品的笔，随时随地书写正式文书。"),
		list("维兰德-汤谷蓝色笔", 1, /obj/item/tool/pen/blue/clicky, "white", "维兰德-汤谷出品的笔，随时随地挥洒文采。"),
		list("维兰德-汤谷红色笔", 1, /obj/item/tool/pen/red/clicky, "white", "维兰德-汤谷出品的笔，随时随地奋笔疾书，宣泄怒气。"),
		list("维兰德-汤谷绿色笔", 1, /obj/item/tool/pen/green/clicky, "white", "维兰德-汤谷出品的笔，随时随地奋笔疾书，宣泄怒气。"),
		list("纸张", 1, /obj/item/paper, "white", "一张供书写用的崭新纸张。"),
		list("维兰德-汤谷信纸", 1, /obj/item/paper/wy, "white", "一张崭新的维兰德-汤谷品牌信纸，用于记录重要事项。"),
		list("复写纸", 1, /obj/item/paper/carbon, "white", "一张复写纸，一次书写便可留下两份。"),
		list("写字夹板", 1, /obj/item/clipboard, "white", "一块写字夹板，用来收纳写好的文件。"),

		list("杂项", 0, null, null, null),
		list("空心手杖", 15, /obj/item/weapon/pole/fancy_cane/this_is_a_knife, "white", "可藏入常见利器的空心手杖。不附带武器。"),

		list("弹药", 0, null, null, null),
		list("ES-4 电击弹匣", 10, /obj/item/ammo_magazine/pistol/es4, "white", "可装填 19 发专用 9 毫米导电弹。"),

		list("无线电密钥", 0, null, null, null),
		list("阿尔法小队", 15, /obj/item/device/encryptionkey/alpha, "white", "USCM 阿尔法小队的无线电密钥。"),
		list("布拉沃小队", 15, /obj/item/device/encryptionkey/bravo, "white", "USCM 布拉沃小队的无线电密钥。"),
		list("查理小队", 15, /obj/item/device/encryptionkey/charlie, "white", "USCM 查理小队的无线电密钥。"),
		list("德尔塔小队", 15, /obj/item/device/encryptionkey/delta, "white", "USCM 德尔塔小队的无线电密钥。"),
		list("埃科小队", 15, /obj/item/device/encryptionkey/echo, "white", "USCM 埃科小队的无线电密钥。"),
		list("殖民地", 20, /obj/item/device/encryptionkey/colony, "white", "已预设当地殖民地通讯频率的无线电密钥。"),
	)

	contraband_products = list(
		list("违禁品", 0, null, null, null),
		list("维兰德-汤谷私人军事承包商", 20, /obj/item/device/encryptionkey/pmc, "white", "维兰德-汤谷私人军事承包商战斗通讯的无线电密钥。"),
		list("违禁品：殖民地执法局", 40, /obj/item/device/encryptionkey/cmb, "white", "殖民地执法局的无线电密钥。"),
		list("违禁品：殖民地解放阵线", 40, /obj/item/device/encryptionkey/clf, "white", "用于已知当地殖民地解放阵线频率的无线电密钥。"),
		list("违禁品：进步人民联盟", 40, /obj/item/device/encryptionkey/upp, "white", "用于已知进步人民联盟监听频率的无线电密钥。"),
	)
