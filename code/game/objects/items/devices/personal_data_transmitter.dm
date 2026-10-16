
#define PDT_BATTERY_DEFAULT_CAPACITY 500
#define PDT_BATTERY_WARNING_CAPACITY 250

#define PDT_BATTERY_SCREEN_DRAW 1
#define PDT_BATTERY_LOCATE_DRAW 4
#define PDT_BATTERY_TOTAL_DRAW PDT_BATTERY_SCREEN_DRAW + PDT_BATTERY_LOCATE_DRAW


/obj/item/device/pdt_locator_tube
	name = "\improper PDT 定位筒"
	desc = "个人数据发射腕带与定位筒套装（PDT/L）的组成部分。启动后，此设备会尝试定位与之配对的个人数据发射腕带。两者使用相同的序列号，便于在混放时辨认。"
	icon_state = "pdt_locator_tube"
	w_class = SIZE_SMALL

	var/obj/item/clothing/accessory/wrist/pdt_bracelet/linked_bracelet
	var/obj/item/cell/crap/battery

/obj/item/device/pdt_locator_tube/Initialize(mapload, obj/item/clothing/accessory/wrist/pdt_bracelet/bracelet)
	. = ..()
	if(bracelet)
		linked_bracelet = bracelet
		linked_bracelet.copied_serial_number = src.serial_number
		RegisterSignal(bracelet, COMSIG_PARENT_PREQDELETED, PROC_REF(handle_bracelet_deletion))
	battery = new(src)
	update_icon()

/obj/item/device/pdt_locator_tube/update_icon()
	overlays.Cut()
	. = ..()
	var/batcheck = TRUE

	if(battery)
		icon_state = "pdt_locator_tube"
		switch(battery.charge)
			//all good
			if(PDT_BATTERY_WARNING_CAPACITY to PDT_BATTERY_DEFAULT_CAPACITY)
				overlays += image('icons/obj/items/devices.dmi', "+pdt_locator_tube_overlay_normal")
			//getting low, warning
			if(PDT_BATTERY_TOTAL_DRAW to PDT_BATTERY_WARNING_CAPACITY)
				overlays += image('icons/obj/items/devices.dmi', "+pdt_locator_tube_overlay_yellow")
			//blinking red, can't do anything but draw screens
			if(PDT_BATTERY_SCREEN_DRAW to PDT_BATTERY_TOTAL_DRAW)
				overlays += image('icons/obj/items/devices.dmi', "+pdt_locator_tube_overlay_red")
			//it's gone...
			else
				batcheck = FALSE
				//overlays += none!!
	else
		icon_state = "pdt_locator_tube_e"
		batcheck = FALSE
	if(batcheck)
		if(linked_bracelet)
			overlays += image('icons/obj/items/devices.dmi', "+pdt_locator_tube_overlay_bracelet_linked")
		else
			overlays += image('icons/obj/items/devices.dmi', "+pdt_locator_tube_overlay_bracelet_unlinked")

/obj/item/device/pdt_locator_tube/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/cell/crap))
		if(battery)
			to_chat(user, SPAN_WARNING("[src]已经装有电池。"))
			return
		user.drop_inv_item_to_loc(W, src)
		battery = W
		to_chat(user, SPAN_NOTICE("你将[battery]装入[src]。"))
		playsound(src, 'sound/machines/pda_button2.ogg', 15, TRUE)
		update_icon()
	else if(istype(W, /obj/item/cell))
		to_chat(user, SPAN_NOTICE("那块工业电池实在太大，根本塞不进这个小小的电池槽。"))
	return ..()

/obj/item/device/pdt_locator_tube/attack_hand(mob/user)
	if(user.get_inactive_hand() == src)
		if(!battery)
			to_chat(user, SPAN_WARNING("[src]没有安装电池。"))
			return
		battery.update_icon()
		user.put_in_hands(battery)
		to_chat(user, SPAN_NOTICE("你从[src]中取出[battery]。"))
		battery = null
		playsound(src, 'sound/machines/pda_button1.ogg', 15, TRUE)
		update_icon()
		return
	return ..()

/obj/item/device/pdt_locator_tube/attack_self(mob/user)
	..()

	if(!battery)
		to_chat(user, SPAN_WARNING("[src]毫无反应！肯定是已经没电了……真是个破烂。你发现电池盖开着。"))
		playsound(src, 'sound/machines/switch.ogg', 15, TRUE)
		return

	if(!battery.use(PDT_BATTERY_SCREEN_DRAW))
		to_chat(user, SPAN_WARNING("[src]毫无反应！肯定是已经没电了……真是个破烂。"))
		playsound(src, 'sound/machines/switch.ogg', 15, TRUE)
		return
	update_icon()

	if(!battery.use(PDT_BATTERY_LOCATE_DRAW))
		to_chat(user, SPAN_WARNING("[src]的显示屏微微亮起：<b>电量不足<b>"))
		playsound(src, 'sound/machines/buzz-sigh.ogg', 15, TRUE)
		return
	update_icon()

	if(!linked_bracelet)
		to_chat(user, SPAN_BOLDWARNING("[src]的显示屏亮起：<b>错误：未检测到已配对的腕带<b>"))
		playsound(src, 'sound/machines/buzz-sigh.ogg', 15, TRUE)
		return

	locate_bracelet(user)

/obj/item/device/pdt_locator_tube/proc/locate_bracelet(mob/user)
	var/turf/self_turf = get_turf(src)
	var/turf/bracelet_turf = get_turf(linked_bracelet)
	var/area/self_area = get_area(self_turf)
	var/area/bracelet_area = get_area(bracelet_turf)

	if(self_turf.z != bracelet_turf.z || self_area.fake_zlevel != bracelet_area.fake_zlevel)
		to_chat(user, SPAN_BOLDWARNING("[src]的显示屏亮起：<b>无法连接已配对的腕带<b>"))
		playsound(src, 'sound/machines/buzz-sigh.ogg', 15, TRUE)
		return

	var/dist = get_dist(self_turf, bracelet_turf)
	var/direction = dir2text_short(Get_Compass_Dir(self_turf, bracelet_turf))
	var/list/direction_labels = list("N" = "北", "S" = "南", "E" = "东", "W" = "西", "NE" = "东北", "SE" = "东南", "NW" = "西北", "SW" = "西南")
	direction = direction_labels[direction] || direction
	if(dist > 1)
		to_chat(user, SPAN_BOLDNOTICE("[src]的显示屏亮起：<b>[dist] 格－[direction]</b>"))
	else
		to_chat(user, SPAN_BOLDNOTICE("[src]的显示屏亮起：<b>--><--</b>"))
	playsound(src, 'sound/machines/ping.ogg', 15, TRUE)

	linked_bracelet.visible_message(SPAN_BOLDNOTICE("[src]短暂亮起，并发出哔哔声！"), max_distance = 3)
	playsound(linked_bracelet, 'sound/machines/twobeep.ogg', 15, TRUE)
	return

/obj/item/device/pdt_locator_tube/proc/handle_bracelet_deletion()
	linked_bracelet = null
	update_icon()

/obj/item/device/pdt_locator_tube/Destroy()
	linked_bracelet = null
	QDEL_NULL(battery)
	return ..()

/obj/item/clothing/accessory/wrist/pdt_bracelet
	name = "\improper PDT 腕带"
	desc = "个人数据发射器（PDT）是一种个人定位装置，通常通过手术植入太阳系外殖民者等人员的体内。它可在接收设备一定半径内快速确定人员位置，有些型号的范围可达 30 公里。这条腕带是 PDT 技术的可穿戴版本——PDT/L 套装的组成部分。它与配对的定位筒使用相同的序列号，便于在混放时辨认。"
	var/dummy_icon_state = "pdt_watch"
	var/copied_serial_number = null

/obj/item/clothing/accessory/wrist/pdt_bracelet/get_examine_text(mob/user)
	. = ..()
	if(!isxeno(user) && (get_dist(user, src) < 2 || isobserver(user)) && copied_serial_number)
		. += SPAN_INFO("序列号为 [copied_serial_number]。")

/obj/item/clothing/accessory/wrist/pdt_bracelet/Initialize()
	. = ..()
	icon_state = "[dummy_icon_state]_[rand(0, 2)]"

/obj/item/storage/box/pdt_kit
	name = "\improper 《新兵！》PDT/L 战友定位套装"
	desc = "内含一套由 PDT 腕带和配对定位筒组成的 PDT/L 设备，以及一块看起来是硬塞进去的备用电池。"
	desc_lore = "这套设备曾随《新兵！》杂志第 200 期（第 4 季）《没有战友，新兵没命！》附赠，用以促进销量。许多人注意到这些设备的续航很差，因此猜测它们是被重新包装后送往美国殖民地海军陆战队相关军品店的瑕疵品。海军部影像观察处（DNOP）尚未就这些说法发表声明。"
	icon = 'icons/obj/items/storage/kits.dmi'
	icon_state = "pdt_box"
	can_hold = list(/obj/item/device/pdt_locator_tube, /obj/item/clothing/accessory/wrist/pdt_bracelet)
	foldable = /obj/item/stack/sheet/cardboard
	storage_slots = 3
	w_class = SIZE_SMALL
	max_w_class = SIZE_SMALL

/obj/item/storage/box/pdt_kit/fill_preset_inventory()
	new /obj/item/device/pdt_locator_tube(src, new /obj/item/clothing/accessory/wrist/pdt_bracelet(src))
	new /obj/item/cell/crap(src) //it not fitting is intentional

/// THE ADVANCED VERSION... ADMIN SPAWN ONLY... USES TGUI RADAR... ///

/obj/item/storage/box/pdt_kit/advanced
	name = "高级 PDT/L 战友定位套装"
	desc = "内含一套由高级 PDT 腕带和配对定位筒组成的 PDT/L 设备，以及一块看起来是硬塞进去的备用电池。"

/obj/item/storage/box/pdt_kit/advanced/fill_preset_inventory()
	new /obj/item/device/pdt_locator_tube/advanced(src, new /obj/item/clothing/accessory/wrist/pdt_bracelet/advanced(src))
	new /obj/item/cell/crap(src) //it not fitting is intentional

/obj/item/device/pdt_locator_tube/advanced
	name = "高级 PDT 定位筒"
	var/datum/radar/advanced_pdtl/radar

/obj/item/device/pdt_locator_tube/advanced/Initialize(mapload, obj/item/clothing/accessory/wrist/pdt_bracelet/bracelet)
	. = ..()
	radar = new /datum/radar/advanced_pdtl(src)

/obj/item/device/pdt_locator_tube/advanced/Destroy()
	QDEL_NULL(radar)
	. = ..()

/obj/item/device/pdt_locator_tube/advanced/handle_bracelet_deletion()
	. = ..()
	SStgui.close_uis(radar)

/obj/item/device/pdt_locator_tube/advanced/locate_bracelet(mob/user)
	radar.tgui_interact(user)

/obj/item/clothing/accessory/wrist/pdt_bracelet/advanced
	name = "高级 PDT 腕带"
