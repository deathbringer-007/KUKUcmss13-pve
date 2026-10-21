#define CAT_NORMAL list("name" = "", "icon" = "")
#define CAT_HIDDEN list("name" = "Contraband", "icon" = "user-secret")
#define CAT_COIN list("name" = "Premium", "icon" = "coins")

#define VENDING_WIRE_EXTEND 1
#define VENDING_WIRE_IDSCAN 2
#define VENDING_WIRE_SHOCK 3
#define VENDING_WIRE_SHOOT_INV 4

GLOBAL_LIST_INIT(vending_wire_descriptions, flatten_numeric_alist(alist(
		VENDING_WIRE_EXTEND = "库存控制计算机",
		VENDING_WIRE_IDSCAN = "身份卡扫描器",
		VENDING_WIRE_SHOCK = "接地保护",
		VENDING_WIRE_SHOOT_INV = "出货电机控制",
	)))

#define VEND_HAND 1

/datum/data/vending_product
	var/product_name = "generic"
	var/product_path = null
	var/amount = 0
	var/max_amount
	var/price = 0
	var/display_color = "white"
	var/category

GLOBAL_LIST_EMPTY_TYPED(total_vending_machines, /obj/structure/machinery/vending)

/obj/structure/machinery/vending
	name = "自动售货机"
	desc = "一台普通的售货机。"
	icon = 'icons/obj/structures/machinery/vending.dmi'
	icon_state = "generic"
	anchored = TRUE
	density = TRUE
	layer = BELOW_OBJ_LAYER
	projectile_coverage = PROJECTILE_COVERAGE_MAX

	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	var/vend_power_usage = 150

	/// if false, the vendor will not send sales pitches
	var/active = TRUE
	/// if set, uses sleep() in product spawn proc (mostly for seeds to retrieve correct names).
	var/delay_product_spawn
	/// if the vendor can vend an item
	var/vend_ready = TRUE
	/// time delay between items can be vended
	var/vend_delay = 1 SECONDS

	// A /datum/data/vending_product instance of what we're paying for right now.
	var/datum/data/vending_product/currently_vending = null

	// To be filled out at compile time
	var/list/products = list() // For each, use the following pattern:
	var/list/contraband = list() // list(/type/path = amount, /type/path2 = amount2)
	var/list/premium = list() // No specified amount = only one in stock
	var/list/prices  = list() // Prices for each item, list(/type/path = price), items not in the list don't have a price.

	/// string of slogans separated by semicolons, optional
	var/product_slogans = ""
	/// string of small ad messages in the vending screen - random chance
	var/product_ads = ""

	/// Used to increase prices of a specific type of vendor.
	var/product_type = VENDOR_PRODUCT_TYPE_UNDEF

	var/list/product_records = list()
	var/list/hidden_records = list()
	var/list/coin_records = list()
	var/list/slogan_list = list()

	/// sent after vending an item
	var/vend_reply
	var/last_reply = 0
	/// when did we last pitch?
	var/last_slogan = 0
	/// how long until we can pitch again?
	var/slogan_delay = 600
	/// icon_state when vending
	var/icon_vend
	/// icon_state when failing to vend
	var/icon_deny
	/// shock customers like an airlock.
	var/seconds_electrified = 0
	/// fire items at customers! We're broken!
	var/shoot_inventory = FALSE
	/// stop spouting those godawful pitches!
	var/shut_up = FALSE
	/// can we access the hidden inventory?
	var/extended_inventory = FALSE
	/// if the vendor is currently being hacked
	var/panel_open = FALSE
	var/wires = 15
	var/obj/item/coin/coin
	var/announce_hacked = TRUE

	/// if true, checks the relevant account has enough money before vending
	var/check_accounts = FALSE
	var/obj/item/spacecash/ewallet/ewallet
	var/is_tipped_over = FALSE

	/// if true, will never shoot inventory or allow all access
	var/hacking_safety = FALSE
	wrenchable = TRUE
	var/vending_dir

/obj/structure/machinery/vending/Initialize(mapload, ...)
	. = ..()
	LAZYADD(GLOB.total_vending_machines, src)
	slogan_list = splittext(product_slogans, ";")

	// So not all machines speak at the exact same time.
	// The first time this machine says something will be at slogantime + this random value,
	// so if slogantime is 10 minutes, it will say it at somewhere between 10 and 20 minutes after the machine is crated.
	last_slogan = world.time + rand(0, slogan_delay)

	build_inventory(products)
		//Add hidden inventory
	build_inventory(contraband, 1)
	build_inventory(premium, 0, 1)
	power_change()
	start_processing()

/obj/structure/machinery/vending/Destroy()
	LAZYREMOVE(GLOB.total_vending_machines, src)
	return ..()

/obj/structure/machinery/vending/update_icon()
	overlays.Cut()
	if(panel_open)
		overlays += image(icon, "[initial(icon_state)]-panel")
	if(stat & BROKEN)
		icon_state = "[initial(icon_state)]-broken"
	else if(stat & NOPOWER)
		icon_state = "[initial(icon_state)]-off"
	else
		icon_state = initial(icon_state)

/obj/structure/machinery/vending/ex_act(severity)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if(prob(25))
				INVOKE_ASYNC(src, PROC_REF(malfunction))
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				INVOKE_ASYNC(src, PROC_REF(malfunction))
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)

/obj/structure/machinery/vending/proc/select_gamemode_equipment(gamemode)
	return

/obj/structure/machinery/vending/proc/build_inventory(list/productlist, hidden = FALSE, req_coin = FALSE)

	for(var/typepath in productlist)
		var/amount = productlist[typepath]
		var/price = prices[typepath]
		if(isnull(amount)) amount = 1

		var/obj/item/temp_path = typepath
		var/datum/data/vending_product/product = new /datum/data/vending_product()

		product.product_path = typepath
		product.amount = amount
		product.price = price
		product.max_amount = amount

		if(ispath(typepath, /obj/item/weapon/gun) || ispath(typepath, /obj/item/ammo_magazine) || ispath(typepath, /obj/item/explosive/grenade) || ispath(typepath, /obj/item/weapon/gun/flamer) || ispath(typepath, /obj/item/storage) )
			product.display_color = "black"
		else
			product.display_color = "white"

		if(hidden)
			product.category=CAT_HIDDEN
			hidden_records += product
		else if(req_coin)
			product.category=CAT_COIN
			coin_records += product
		else
			product_records += product

		product.product_name = initial(temp_path.name)

/obj/structure/machinery/vending/get_repair_move_text(include_name = TRUE)
	if(!stat)
		return

	var/possessive = include_name ? "[src]的" : "它的"
	var/nominative = include_name ? "[src]" : "它"

	if(stat & BROKEN)
		return "[possessive]损坏面板仍需<b>拧松</b>并拆下。"
	else if(stat & REPAIR_STEP_ONE)
		return "[possessive]断裂电线仍需<b>剪断</b>并从售货机中移除。"
	else if(stat & REPAIR_STEP_TWO)
		return "[nominative]需要安装<b>新电线</b>。"
	else if(stat & REPAIR_STEP_THREE)
		return "[nominative]需要安装<b>金属</b>面板。"
	else if(stat & REPAIR_STEP_FOUR)
		return "[possessive]新面板需要<b>拧紧固定</b>。"
	else
		return "[nominative]存在供电问题。"

/obj/structure/machinery/vending/attackby(obj/item/item, mob/user)
	if(is_tipped_over)
		to_chat(user, "先把它扶正！")
		return FALSE

	if(HAS_TRAIT(item, TRAIT_TOOL_SCREWDRIVER))
		if(stat == WORKING)
			panel_open = !panel_open
			to_chat(user, "你[panel_open ? "打开" : "关闭"]了维护面板。")
			update_icon()
			return TRUE
		else if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
			to_chat(user, SPAN_WARNING("你不知道如何修理损坏的[src.name]。"))
			return FALSE
		else if(stat & BROKEN)
			to_chat(user, SPAN_NOTICE("你开始拧松[src]损坏的面板。"))
			if(!do_after(user, 3 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, numticks = 3))
				to_chat(user, SPAN_WARNING("你停止拧松[src]损坏的面板。"))
				return FALSE
			to_chat(user, SPAN_NOTICE("你拧松并拆下[src]损坏的面板，露出了许多断裂的电线。"))
			stat &= ~BROKEN
			stat |= REPAIR_STEP_ONE
			return TRUE
		else if(stat & REPAIR_STEP_FOUR)
			to_chat(user, SPAN_NOTICE("你开始固定[src]的新面板。"))
			if(!do_after(user, 3 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, numticks = 3))
				to_chat(user, SPAN_WARNING("你停止固定[src]的新面板。"))
				return FALSE
			to_chat(user, SPAN_NOTICE("你固定好了[src]的新面板，售货机已完全修复。"))
			stat &= ~REPAIR_STEP_FOUR
			stat |= FULLY_REPAIRED
			update_icon()
			return TRUE
		else
			var/msg = get_repair_move_text()
			to_chat(user, SPAN_WARNING("[msg]"))
			return FALSE
	else if(HAS_TRAIT(item, TRAIT_TOOL_WIRECUTTERS))
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
			to_chat(user, SPAN_WARNING("你不知道如何修理损坏的[src.name]。"))
			return FALSE
		else if(stat == WORKING && panel_open)
			attack_hand(user)
			return
		else if(stat & REPAIR_STEP_ONE)
			to_chat(user, SPAN_NOTICE("你开始移除[src]断裂的电线。"))
			if(!do_after(user, 3 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, numticks = 3))
				to_chat(user, SPAN_WARNING("你停止移除[src]断裂的电线。"))
				return FALSE
			to_chat(user, SPAN_NOTICE("你移除了[src]断裂的电线。"))
			stat &= ~REPAIR_STEP_ONE
			stat |= REPAIR_STEP_TWO
			return TRUE
		else
			var/msg = get_repair_move_text()
			to_chat(user, SPAN_WARNING("[msg]"))
			return FALSE
	else if(istype(item, /obj/item/stack/cable_coil))
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
			to_chat(user, SPAN_WARNING("你不知道如何修理损坏的[src.name]。"))
			return FALSE
		var/obj/item/stack/cable_coil/CC = item
		if(stat & REPAIR_STEP_TWO)
			if(CC.amount < 5)
				to_chat(user, SPAN_WARNING("需要更多电缆卷才能替换拆下的电线。"))
			to_chat(user, SPAN_NOTICE("你开始替换[src]拆下的电线。"))
			if(!do_after(user, 3 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, numticks = 3))
				to_chat(user, SPAN_WARNING("你停止替换[src]拆下的电线。"))
				return FALSE
			if(!CC || !CC.use(5))
				to_chat(user, SPAN_WARNING("需要更多电缆卷才能替换拆下的电线。"))
				return FALSE
			to_chat(user, SPAN_NOTICE("你移除了[src]断裂的电线。"))
			stat &= ~REPAIR_STEP_TWO
			stat |= REPAIR_STEP_THREE
			return TRUE
		else
			var/msg = get_repair_move_text()
			to_chat(user, SPAN_WARNING("[msg]"))
			return
	else if(istype(item, /obj/item/stack/sheet/metal))
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
			to_chat(user, SPAN_WARNING("你不知道如何修理损坏的[src.name]。"))
			return FALSE
		var/obj/item/stack/sheet/metal/M = item
		if(stat & REPAIR_STEP_THREE)
			to_chat(user, SPAN_NOTICE("你开始为[src]制作新面板。"))
			if(!do_after(user, 3 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, numticks = 3))
				to_chat(user, SPAN_WARNING("你停止为[src]制作新面板。"))
				return FALSE
			if(!M || !M.use(1))
				to_chat(user, SPAN_WARNING("你需要一块金属板来制作新面板。"))
				return FALSE
			to_chat(user, SPAN_NOTICE("你为[src]制作了新面板。"))
			stat &= ~REPAIR_STEP_THREE
			stat |= REPAIR_STEP_FOUR
			return TRUE
		else
			var/msg = get_repair_move_text()
			to_chat(user, SPAN_WARNING("[msg]"))
			return
	else if(HAS_TRAIT(item, TRAIT_TOOL_WRENCH))
		if(!wrenchable) return

		if(do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			if(!src) return
			playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
			switch (anchored)
				if (0)
					anchored = TRUE
					user.visible_message("[user]拧紧了将[src]固定在地板上的螺栓。", "你拧紧了将[src]固定在地板上的螺栓。")
				if (1)
					user.visible_message("[user]松开了将[src]固定在地板上的螺栓。", "你松开了将[src]固定在地板上的螺栓。")
					anchored = FALSE
		return
	else if(HAS_TRAIT(item, TRAIT_TOOL_MULTITOOL) || HAS_TRAIT(item, TRAIT_TOOL_WIRECUTTERS))
		if(panel_open)
			attack_hand(user)
		return
	else if(istype(item, /obj/item/coin))
		if(coin)
			user.balloon_alert(user, "已经有硬币了！")
			return
		if(user.drop_inv_item_to_loc(item, src))
			coin = item
			to_chat(user, SPAN_NOTICE("你将[item]投入[src]。"))
			tgui_interact(user)
		return
	else if(istype(item, /obj/item/spacecash))
		if(inoperable())
			return
		user.set_interaction(src)
		if(seconds_electrified && shock(user, 100))
			return
		tgui_interact(user)
		return

	..()

/obj/structure/machinery/vending/proc/scan_card(obj/item/card/card)
	if(!currently_vending) return
	if (istype(card, /obj/item/card/id))
		visible_message(SPAN_INFO("[usr]在[src]上刷了一张卡。"))
		var/datum/money_account/CH = get_account(card.associated_account_number)
		if (CH) // Only proceed if card contains proper account number.
			if(!CH.suspended)
				if(CH.security_level != 0) //If card requires pin authentication (ie seclevel 1 or 2)
					if(GLOB.vendor_account)
						var/attempt_pin = tgui_input_number(usr, "输入密码", "售货机交易")
						var/datum/money_account/D = attempt_account_access(card.associated_account_number, attempt_pin, 2)
						transfer_and_vend(D)
					else
						to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("无法访问账户。请检查安全设置后重试。")]")
				else
					//Just Vend it.
					transfer_and_vend(CH)
			else
				to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("关联账户已被冻结。")]")
		else
			to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("错误：无法访问你的账户。若问题持续，请联系技术支持。")]")

/obj/structure/machinery/vending/proc/transfer_and_vend(datum/money_account/acc)
	if(acc)
		var/transaction_amount = currently_vending.price
		if(transaction_amount <= acc.money)

			//transfer the money
			acc.money -= transaction_amount
			GLOB.vendor_account.money += transaction_amount

			//create entries in the two account transaction logs
			var/datum/transaction/T = new()
			T.target_name = "[GLOB.vendor_account.owner_name]（通过[name]）"
			T.purpose = "购买[currently_vending.product_name]"
			if(transaction_amount > 0)
				T.amount = "([transaction_amount])"
			else
				T.amount = "[transaction_amount]"
			T.source_terminal = name
			T.date = GLOB.current_date_string
			T.time = worldtime2text()
			acc.transaction_log.Add(T)
							//
			T = new()
			T.target_name = acc.owner_name
			T.purpose = "购买[currently_vending.product_name]"
			T.amount = "[transaction_amount]"
			T.source_terminal = name
			T.date = GLOB.current_date_string
			T.time = worldtime2text()
			GLOB.vendor_account.transaction_log.Add(T)

			// Vend the item
			vend(currently_vending, usr)
			currently_vending = null
		else
			to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("你的钱不够！")]")
	else
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("错误：无法访问你的账户。若问题持续，请联系技术支持。")]")

/obj/structure/machinery/vending/proc/GetProductIndex(datum/data/vending_product/product)
	var/list/plist
	if(product.category == CAT_NORMAL)
		plist = product_records
	else if(product.category == CAT_HIDDEN)
		plist = hidden_records
	else if(product.category == CAT_COIN)
		plist = coin_records
	else
		warning("UNKNOWN CATEGORY [product.category] IN TYPE [product.product_path] INSIDE [type]!")
	return plist.Find(product)

/obj/structure/machinery/vending/proc/GetProductByID(pid, category)
	if(category == CAT_NORMAL)
		return product_records[pid]
	else if(category == CAT_HIDDEN)
		return hidden_records[pid]
	else if(category == CAT_COIN)
		return coin_records[pid]
	else
		warning("UNKNOWN PRODUCT: PID: [pid], CAT: [category] INSIDE [type]!")

/obj/structure/machinery/vending/attack_hand(mob/user)
	if(is_tipped_over)
		if(user.action_busy)
			return
		user.visible_message(SPAN_NOTICE("[user]开始用力将[src]扶回原位！"), SPAN_NOTICE("你开始用力将[src]扶回原位……"))
		if(do_after(user, 80, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY))
			user.visible_message(SPAN_NOTICE("[user]扶正了[src]！"), SPAN_NOTICE("你扶正了[src]！"))
			flip_back()
		return

	if(inoperable())
		return

	user.set_interaction(src)

	if(seconds_electrified && shock(user, 100))
		return

	tgui_interact(user)

/obj/structure/machinery/vending/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Vending", name)
		ui.open()

/obj/structure/machinery/vending/ui_act(action, params)
	. = ..()

	var/mob/user = usr

	if(.)
		return
	switch(action)
		if("vend")
			. = vend(params)
		if("cutwire")
			if(!panel_open)
				return FALSE
			var/obj/item/held_item = user.get_held_item()
			if (!held_item || !HAS_TRAIT(held_item, TRAIT_TOOL_WIRECUTTERS))
				to_chat(user, "你需要剪线钳！")
				return TRUE

			var/wire = params["wire"]
			cut(wire)
			return TRUE
		if("fixwire")
			if(!panel_open)
				return FALSE
			var/obj/item/held_item = user.get_held_item()
			if (!held_item || !HAS_TRAIT(held_item, TRAIT_TOOL_WIRECUTTERS))
				to_chat(user, "你需要剪线钳！")
				return TRUE
			var/wire = params["wire"]
			mend(wire)
			return TRUE
		if("pulsewire")
			if(!panel_open)
				return FALSE
			var/obj/item/held_item = user.get_held_item()
			if (!held_item || !HAS_TRAIT(held_item, TRAIT_TOOL_MULTITOOL))
				to_chat(user, "你需要多功能工具！")
				return TRUE
			var/wire = params["wire"]
			if (isWireCut(wire))
				to_chat(usr, "无法向剪断的电线发送脉冲。")
				return TRUE
			pulse(wire)
			return TRUE

/obj/structure/machinery/vending/proc/can_vend(user, silent=FALSE)
	. = FALSE
	if(!vend_ready)
		return
	if(panel_open)
		to_chat(user, SPAN_WARNING("售货机的维护面板打开时无法出货！"))
		return
	return TRUE

/obj/structure/machinery/vending/proc/vend(list/params)
	var/mob/user = usr

	. = TRUE
	if(!can_vend(user))
		return
	vend_ready = FALSE //One thing at a time!!
	var/datum/data/vending_product/record = locate(params["ref"])
	var/list/record_to_check = product_records + coin_records
	if(extended_inventory)
		record_to_check = product_records + coin_records + hidden_records
	if(!record || !istype(record) || !record.product_path)
		vend_ready = TRUE
		return
	var/price_to_use = record.price
	if(record in hidden_records)
		if(!extended_inventory)
			vend_ready = TRUE
			return
	else if(!(record in record_to_check))
		vend_ready = TRUE
		message_admins("Vending machine exploit attempted by [key_name_admin(user)]!")
		return
	if(record.amount <= 0)
		speak("[record.name]已售罄。")
		flick(icon_deny, src)
		vend_ready = TRUE
		return

	if(coin_records.Find(record))
		if(!coin)
			speak("需要硬币。")
			vend_ready = TRUE
			return
		if(coin.string_attached)
			if(prob(50))
				to_chat(user, SPAN_NOTICE("你赶在[src]吞下硬币前成功把它拉了出来。"))
				user.put_in_hands(coin)
			else
				to_chat(user, SPAN_NOTICE("你没能及时拉出硬币，机器把它连同绳子一起吞了下去。"))
				QDEL_NULL(coin)
		else
			QDEL_NULL(coin)

	// The checking_id() proc is currently determining whether to pay or not, not exactly just ID
	// So lets treat cash like an alternative ID for these greedy machines
	var/sufficent_cash = FALSE
	var/ripped_off = FALSE
	var/obj/item/spacecash/cash = user.get_active_hand()
	if(!istype(cash))
		cash = user.get_inactive_hand()
	if(istype(cash))
		sufficent_cash = cash.worth >= price_to_use

	var/obj/item/card/id/user_id
	if(checking_id())
		if(ishuman(user))
			var/mob/living/carbon/human/human_user = user
			user_id = human_user.get_idcard()

		if(!allowed(user))
			speak("访问被拒绝。")
			flick(icon_deny, src)
			vend_ready = TRUE
			return

		if(!user_id && !sufficent_cash)
			speak("未找到身份卡。")
			flick(icon_deny, src)
			vend_ready = TRUE
			return

		if(price_to_use)
			var/datum/money_account/account
			if(user_id)
				account = get_account(user_id.associated_account_number)

			if(!account && !sufficent_cash)
				speak("未找到账户。")
				flick(icon_deny, src)
				vend_ready = TRUE
				return

			if(!account || !transfer_money(account, record))
				if (!sufficent_cash)
					speak("你的余额不足以购买[record.product_name]。")
					flick(icon_deny, src)
					vend_ready = TRUE
					return

				insert_money(cash, record)
				if(cash.worth && !istype(cash, /obj/item/spacecash/ewallet))
					qdel(cash)
					ripped_off = TRUE

	speak(vend_reply)
	use_power(active_power_usage)
	if(icon_vend) //Show the vending animation if needed
		flick(icon_vend, src)
	var/obj/item/vended_item
	vended_item = new record.product_path(get_turf(src))
	record.amount--
	playsound(src, "sound/machines/vending.ogg", 40, TRUE)
	if(user.Adjacent(src) && user.put_in_hands(vended_item))
		to_chat(user, SPAN_NOTICE("你从出货口取出[record.product_name]。"))
	else
		to_chat(user, SPAN_WARNING("[record.product_name]掉到了地上！"))
	if(ripped_off)
		flick(icon_deny, src)
		addtimer(VARSET_CALLBACK(src, vend_ready, TRUE), 1 SECONDS)
		addtimer(CALLBACK(src, PROC_REF(speak), "找零不足，请联系主管。"), 1 SECONDS)
		return
	vend_ready = TRUE

/obj/structure/machinery/vending/proc/transfer_money(datum/money_account/user_account, datum/data/vending_product/currently_vending)
	var/transaction_amount = currently_vending.price
	if(!(transaction_amount <= user_account.money))
		return FALSE

	if(user_account.suspended || user_account.security_level != 0)
		return FALSE

	//transfer the money
	user_account.money -= transaction_amount
	GLOB.vendor_account.money += transaction_amount

	//create entries in the two account transaction logs
	var/datum/transaction/new_transaction = new()
	new_transaction.target_name = "[GLOB.vendor_account.owner_name]（通过[name]）"
	new_transaction.purpose = "购买[currently_vending.product_name]"
	if(transaction_amount > 0)
		new_transaction.amount = "([transaction_amount])"
	else
		new_transaction.amount = "[transaction_amount]"
	new_transaction.source_terminal = name
	new_transaction.date = GLOB.current_date_string
	new_transaction.time = worldtime2text()
	user_account.transaction_log.Add(new_transaction)

	new_transaction = new()
	new_transaction.target_name = user_account.owner_name
	new_transaction.purpose = "购买[currently_vending.product_name]"
	new_transaction.amount = "[transaction_amount]"
	new_transaction.source_terminal = name
	new_transaction.date = GLOB.current_date_string
	new_transaction.time = worldtime2text()
	GLOB.vendor_account.transaction_log.Add(new_transaction)

	return TRUE

/obj/structure/machinery/vending/proc/insert_money(obj/item/spacecash/cash, datum/data/vending_product/currently_vending)
	var/transaction_amount = currently_vending.price
	if(transaction_amount > cash.worth)
		return FALSE

	//transfer the money
	cash.worth -= transaction_amount
	GLOB.vendor_account.money += transaction_amount

	//consume the cash if needed
	if(!cash.worth)
		qdel(cash)

	//create entries in the account transaction logs
	var/datum/transaction/new_transaction = new()
	new_transaction.target_name = "CASH"
	new_transaction.purpose = "购买[currently_vending.product_name]"
	new_transaction.amount = "[transaction_amount]"
	new_transaction.source_terminal = name
	new_transaction.date = GLOB.current_date_string
	new_transaction.time = worldtime2text()
	GLOB.vendor_account.transaction_log.Add(new_transaction)

	return TRUE

/**
 * Returns TRUE if this vending machine is scanning for IDs.
 */
/obj/structure/machinery/vending/proc/checking_id()
	if(hacking_safety)
		return TRUE

	if(isWireCut(VENDING_WIRE_IDSCAN))
		return FALSE

	return TRUE

/obj/structure/machinery/vending/ui_data(mob/user)
	. = list()
	var/obj/item/card/id/id_card
	var/datum/money_account/account
	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		id_card = human_user.get_idcard()
		if(id_card)
			account = get_account(id_card.associated_account_number)

	var/cash_worth
	var/obj/item/spacecash/cash = user.get_active_hand()
	if(!istype(cash))
		cash = user.get_inactive_hand()
	if(istype(cash))
		cash_worth = cash.worth

	if(account)
		.["user"] = list()
		.["user"]["name"] = account.owner_name
		.["user"]["cash"] = max(account.money, cash_worth)
		.["user"]["job"] = localized_player_label(id_card.assignment)
	else if(cash_worth)
		.["user"] = list()
		.["user"]["name"] = ""
		.["user"]["cash"] = cash.worth
		.["user"]["job"] =  ""
	else
		.["user"] = null

	.["stock"] = list()
	for(var/datum/data/vending_product/product_record in product_records + coin_records + hidden_records)
		var/list/product_data = list(
			name = product_record.product_name,
			amount = product_record.amount,
		)

		.["stock"][product_record.product_name] = product_data

	.["extended_inventory"] = extended_inventory

	var/list/panel_wires = list()
	for(var/wire in 1 to length(GLOB.vending_wire_descriptions))
		panel_wires += list(list("desc" = GLOB.vending_wire_descriptions[wire], "cut" = isWireCut(wire)))

	.["electrical"] = list(
		"electrified" = seconds_electrified > 0,
		"panel_open" = panel_open,
		"wires" = panel_wires,
		"shoot_inventory" = shoot_inventory,
		"powered" = TRUE,
	)

	.["checking_id"] = checking_id()

	.["access"] = allowed(user)

/obj/structure/machinery/vending/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/structure/machinery/vending/ui_static_data(mob/user)
	var/list/data = list()
	data["product_records"] = list()

	var/list/categories = list()

	data["product_records"] = collect_records_for_static_data(product_records, categories)
	data["coin_records"] = collect_records_for_static_data(coin_records, categories, premium = TRUE)
	data["hidden_records"] = collect_records_for_static_data(hidden_records, categories, premium = TRUE)
	data["categories"] = categories

	return data

/obj/structure/machinery/vending/proc/collect_records_for_static_data(list/records, list/categories, premium)
	var/static/list/default_category = list(
		"name" = "Products",
		"icon" = "cart-shopping",
	)

	var/list/out_records = list()

	for (var/datum/data/vending_product/record as anything in records)
		var/list/static_record = list(
			path = replacetext(replacetext("[record.product_path]", "/obj/item/", ""), "/", "-"),
			name = record.product_name,
			price = record.price,
			max_amount = record.max_amount,
			ref = REF(record),
		)

		var/list/category = record.category || default_category
		if (!isnull(category))
			if (!(category["name"] in categories))
				categories[category["name"]] = list(
					"icon" = category["icon"],
				)

			static_record["category"] = category["name"]

		if (premium)
			static_record["premium"] = TRUE

		out_records += list(static_record)

	return out_records

/obj/structure/machinery/vending/ui_assets(mob/user)
	return list(get_asset_datum(/datum/asset/spritesheet/vending))

/obj/structure/machinery/vending/proc/release_item(datum/data/vending_product/product, delay_vending = 0, mob/living/carbon/human/user)
	set waitfor = 0

	//We interact with the UI only if a user is present
	//(This function can be called with no user if the machine gets blown up / malfunctions)
	if(user)
		ui_interact(user)

	if (delay_vending)
		use_power(vend_power_usage) //actuators and stuff
		if (icon_vend)
			flick(icon_vend, src) //Show the vending animation if needed
		sleep(delay_vending)
	if (vending_dir == VEND_HAND && istype(user) && Adjacent(user))
		user.put_in_hands(new product.product_path)
	else if (ispath(product.product_path, /obj/item/weapon/gun))
		. = new product.product_path(get_turf(src), 1)
	else
		. = new product.product_path(get_turf(src))

/obj/structure/machinery/vending/MouseDrop_T(atom/movable/A, mob/user)

	if(inoperable())
		return

	if(user.stat || user.is_mob_restrained())
		return

	if(get_dist(user, src) > 1 || get_dist(src, A) > 1)
		return

	if(istype(A, /obj/item))
		var/obj/item/item = A
		stock(item, user)
		ui_interact(user)

/obj/structure/machinery/vending/proc/stock(obj/item/item_to_stock, mob/user)
	var/datum/data/vending_product/product //Let's try with a new datum.
	//More accurate comparison between absolute paths.
	for(product in (product_records + hidden_records + coin_records))
		if(item_to_stock.type == product.product_path && !istype(item_to_stock, /obj/item/storage)) //Nice try, specialists/engis
			if(isgun(item_to_stock))
				var/obj/item/weapon/gun/gun = item_to_stock
				if(gun.in_chamber || (gun.current_mag && !istype(gun.current_mag, /obj/item/ammo_magazine/internal)) || (istype(gun.current_mag, /obj/item/ammo_magazine/internal) && gun.current_mag.current_rounds > 0) )
					to_chat(user, SPAN_WARNING("[gun]仍装有弹药。请先退弹再回存。"))
					return
				for(var/obj/item/attachable/attach in gun.contents) //Search for attachments on the gun. This is the easier method
					if((attach.flags_attach_features & ATTACH_REMOVABLE) && !(is_type_in_list(attach, gun.starting_attachment_types))) //There are attachments that are default and others that can't be removed
						to_chat(user, SPAN_WARNING("[gun]装有非标准配件。请先拆除再回存。"))
						return

			if(istype(item_to_stock, /obj/item/ammo_magazine))
				var/obj/item/ammo_magazine/mag = item_to_stock
				if(mag.current_rounds < mag.max_rounds)
					to_chat(user, SPAN_WARNING("[mag]未装满。请先装满再回存。"))
					return
			if(istype(item_to_stock, /obj/item/device/walkman))
				var/obj/item/device/walkman/item = item_to_stock
				if(item.tape)
					to_chat(user, SPAN_WARNING("先取下磁带！"))
					return

			if(istype(item_to_stock, /obj/item/device/defibrillator))
				var/obj/item/device/defibrillator/defib = item_to_stock
				if(!defib.dcell)
					to_chat(user, SPAN_WARNING("[item_to_stock]必须装有电池才能回存！"))
					return
				if(defib.dcell.charge < defib.dcell.maxcharge)
					to_chat(user, SPAN_WARNING("[item_to_stock]必须充满电才能回存！"))
					return

			if(istype(item_to_stock, /obj/item/cell))
				var/obj/item/cell/cell = item_to_stock
				if(cell.charge < cell.maxcharge)
					to_chat(user, SPAN_WARNING("[item_to_stock]必须充满电才能回存！"))
					return

			if(item_to_stock.loc == user) //Inside the mob's inventory
				if(item_to_stock.flags_item & WIELDED)
					item_to_stock.unwield(user)
				user.temp_drop_inv_item(item_to_stock)

			if(isstorage(item_to_stock.loc)) //inside a storage item
				var/obj/item/storage/S = item_to_stock.loc
				S.remove_from_storage(item_to_stock, user.loc)

			qdel(item_to_stock)
			user.visible_message(SPAN_NOTICE("[user]向[src]补充了[product.product_name]。"),
			SPAN_NOTICE("你向[src]补充了[product.product_name]。"))
			product.amount++
			return //We found our item, no reason to go on.

/obj/structure/machinery/vending/process()
	if(inoperable())
		return

	if(!active)
		return

	if(seconds_electrified > 0)
		seconds_electrified--

	//Pitch to the people!  Really sell it!
	if(((last_slogan + slogan_delay) <= world.time) && (length(slogan_list) > 0) && (!shut_up) && prob(5))
		var/slogan = pick(slogan_list)
		speak(slogan)
		last_slogan = world.time

	if(shoot_inventory && prob(2) && !hacking_safety)
		throw_item()

	return

/obj/structure/machinery/vending/proc/speak(message)
	if(stat & NOPOWER)
		return

	if (!message)
		return

	for(var/mob/mob in hearers(src, null))
		mob.show_message("<span class='game say'><span class='name'>[src]</span>发出电子提示音：“[message]”</span>", SHOW_MESSAGE_AUDIBLE)
	return

//Oh no we're malfunctioning!  Dump out some product and break.
/obj/structure/machinery/vending/proc/malfunction()
	if(stat & BROKEN)
		return
	var/release_amt = rand(3, 4)
	for(var/datum/data/vending_product/product in product_records)
		if (product.amount <= 0) //Try to use a record that actually has something to dump.
			continue
		var/dump_path = product.product_path
		if (!dump_path)
			continue

		while(product.amount > 0 && release_amt > 0)
			release_item(product, 0)
			product.amount--
			release_amt--
		break
	stat |= BROKEN
	update_icon()


//Somebody cut an important wire and now we're following a new definition of "pitch."
/obj/structure/machinery/vending/proc/throw_item()
	var/obj/throw_item = null
	var/mob/living/target = locate() in view(7, src)
	if(!target)
		return 0

	for(var/datum/data/vending_product/product in product_records)
		if (product.amount <= 0) //Try to use a record that actually has something to dump.
			continue
		var/dump_path = product.product_path
		if (!dump_path)
			continue

		product.amount--
		throw_item = release_item(product, 0)
		break
	if (!throw_item)
		return 0
	INVOKE_ASYNC(throw_item, /atom/movable/proc/throw_atom, target, 16, SPEED_AVERAGE, src)
	visible_message(SPAN_WARNING("[src]向[target]发射了[throw_item]！"))
	playsound(src, "sound/machines/vending.ogg", 40, TRUE)
	return 1

/obj/structure/machinery/vending/proc/isWireCut(wire)
	return !(wires & getWireFlag(wire))

/obj/structure/machinery/vending/proc/cut(wire)
	wires ^= getWireFlag(wire)

	switch(wire)
		if(VENDING_WIRE_EXTEND)
			extended_inventory = TRUE
			visible_message(SPAN_NOTICE("[src]底部微弱的黄灯熄灭了。"))
		if(VENDING_WIRE_SHOCK)
			seconds_electrified = -1
			visible_message(SPAN_DANGER("[src]迸射出电弧！"))
		if (VENDING_WIRE_SHOOT_INV)
			if(!shoot_inventory)
				shoot_inventory = TRUE
				visible_message(SPAN_WARNING("[src]开始发出嘈杂的嗡鸣声。"))

/obj/structure/machinery/vending/proc/mend(wire)
	wires |= getWireFlag(wire)

	switch(wire)
		if(VENDING_WIRE_EXTEND)
			extended_inventory = FALSE
			visible_message(SPAN_NOTICE("[src]底部亮起了微弱的黄灯。"))
		if(VENDING_WIRE_SHOCK)
			seconds_electrified = 0
		if (VENDING_WIRE_SHOOT_INV)
			shoot_inventory = FALSE
			visible_message(SPAN_NOTICE("[src]停止了嗡鸣。"))

/obj/structure/machinery/vending/proc/pulse(wire)
	switch(wire)
		if(VENDING_WIRE_EXTEND)
			extended_inventory = !extended_inventory
			visible_message(SPAN_NOTICE("[src]底部微弱的黄灯[extended_inventory ? "亮起" : "熄灭"]了。"))
		if (VENDING_WIRE_SHOCK)
			seconds_electrified = 30
			visible_message(SPAN_DANGER("[src]迸射出电弧！"))
		if (VENDING_WIRE_SHOOT_INV)
			shoot_inventory = !shoot_inventory
			if(shoot_inventory)
				visible_message(SPAN_WARNING("[src]开始发出嘈杂的嗡鸣声。"))
			else
				visible_message(SPAN_NOTICE("[src]停止了嗡鸣。"))
