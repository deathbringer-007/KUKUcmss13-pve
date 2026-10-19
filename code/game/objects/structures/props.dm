/obj/structure/prop/tower
	name = "损毁的通信塔"
	desc = "一座老旧的公司通讯塔，通过子空间链路在天体之间传递通讯。看起来已饱经风霜。"
	icon = 'icons/obj/structures/machinery/comm_tower.dmi'
	icon_state = "comm_tower_destroyed"
	unslashable = TRUE
	unacidable = TRUE
	density = TRUE
	layer = ABOVE_FLY_LAYER
	bound_height = 96

/obj/structure/prop/dam
	density = TRUE
	unslashable = TRUE

/obj/structure/prop/dam/drill
	name = "采矿钻机"
	desc = "一台老旧的采矿钻机，显然用于采矿。可能也用于钻孔。"
	icon = 'icons/obj/structures/props/drill.dmi'
	icon_state = "drill"
	bound_height = 96
	var/on = FALSE//if this is set to on by default, the drill will start on, doi

/obj/structure/prop/dam/drill/attackby(obj/item/W, mob/user)
	. = ..()
	if(isxeno(user))
		return
	else if (ishuman(user) && HAS_TRAIT(W, TRAIT_TOOL_WRENCH))
		on = !on
		visible_message("你用扳手转动 \the [src] 的控制装置，钻机随即启动。" , "[user] 用扳手转动 \the [src] 的控制装置，钻机随即启动。")

		update()

/obj/structure/prop/dam/drill/proc/update()
	icon_state = "thumper[on ? "-on" : ""]"
	if(on)
		set_light(3)
		playsound(src, 'sound/machines/turbine_on.ogg')
	else
		set_light(0)
		playsound(src, 'sound/machines/turbine_off.ogg')
	return

/obj/structure/prop/dam/drill/Initialize()
	. = ..()
	update()

/obj/structure/prop/dam/truck
	name = "卡车"
	desc = "一辆老旧的卡车，似乎已经抛锚。"
	icon = 'icons/obj/structures/props/vehicles.dmi'
	icon_state = "truck"
	bound_height = 64
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/prop/dam/truck/damaged
	icon_state = "truck_damaged"

/obj/structure/prop/dam/truck/mining
	name = "矿用卡车"
	desc = "一辆老旧的采矿卡车，似乎已经抛锚。"
	icon_state = "truck_mining"

/obj/structure/prop/dam/truck/cargo
	name = "货运卡车"
	desc = "一辆老旧的货运卡车，似乎已经抛锚。"
	icon_state = "truck_cargo"

/obj/structure/prop/dam/van
	name = "厢式货车"
	desc = "一辆老旧的厢型车，似乎已经抛锚。"
	icon = 'icons/obj/structures/props/vehicles.dmi'
	icon_state = "van"
	bound_height = 64
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/prop/dam/van/damaged
	icon_state = "van_damaged"

/obj/structure/prop/dam/crane
	name = "货运起重机"
	icon = 'icons/obj/structures/props/vehicles.dmi'
	icon_state = "crane"
	bound_height = 64
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/prop/dam/crane/damaged
	icon_state = "crane_damaged"

/obj/structure/prop/dam/crane/cargo
	icon_state = "crane_cargo"

/obj/structure/prop/dam/torii
	name = "鸟居"
	desc = "一座传统日式木制鸟居，装饰着灯笼。"
	icon = 'icons/obj/structures/props/torii.dmi'
	icon_state = "torii"
	density = FALSE
	pixel_x = -16
	layer = MOB_LAYER+0.5
	var/lit = 0

/obj/structure/prop/dam/torii/New()
	..()
	Update()

/obj/structure/prop/dam/torii/proc/Update()
	underlays.Cut()
	underlays += "shadow[lit ? "-lit" : ""]"
	icon_state = "torii[lit ? "-lit" : ""]"
	if(lit)
		set_light(6)
	else
		set_light(0)
	return

/obj/structure/prop/dam/torii/attack_hand(mob/user as mob)
	..()
	if(lit)
		lit = !lit
		visible_message("[user] 熄灭了 [src] 上的灯笼。",
			"你熄灭了 [src] 上的火焰。")
		Update()
	return

/obj/structure/prop/dam/torii/attackby(obj/item/W, mob/user)
	var/L
	if(lit)
		return
	if(iswelder(W))
		var/obj/item/tool/weldingtool/WT = W
		if(WT.isOn())
			L = 1
	else if(istype(W, /obj/item/tool/lighter/zippo))
		var/obj/item/tool/lighter/zippo/Z = W
		if(Z.heat_source)
			L = 1
	else if(istype(W, /obj/item/device/flashlight/flare))
		var/obj/item/device/flashlight/flare/FL = W
		if(FL.heat_source)
			L = 1
	else if(istype(W, /obj/item/tool/lighter))
		var/obj/item/tool/lighter/G = W
		if(G.heat_source)
			L = 1
	else if(istype(W, /obj/item/tool/match))
		var/obj/item/tool/match/M = W
		if(M.heat_source)
			L = 1
	else if(istype(W, /obj/item/weapon/energy/sword))
		var/obj/item/weapon/energy/sword/S = W
		if(S.active)
			L = 1
	else if(istype(W, /obj/item/device/assembly/igniter))
		L = 1
	else if(istype(W, /obj/item/attachable/attached_gun/flamer))
		L = 1
	else if(istype(W, /obj/item/weapon/gun/flamer))
		var/obj/item/weapon/gun/flamer/F = W
		if(!(F.flags_gun_features & GUN_TRIGGER_SAFETY))
			L = 1
		else
			to_chat(user, SPAN_WARNING("请先点燃引火火苗！"))

	else if(isgun(W))
		var/obj/item/weapon/gun/G = W
		for(var/slot in G.attachments)
			if(istype(G.attachments[slot], /obj/item/attachable/attached_gun/flamer))
				L = 1
				break
	else if(istype(W, /obj/item/tool/surgery/cautery))
		L = 1
	else if(istype(W, /obj/item/clothing/mask/cigarette))
		var/obj/item/clothing/mask/cigarette/C = W
		if(C.item_state == C.icon_on)
			L = 1
	else if(istype(W, /obj/item/tool/candle))
		if(W.heat_source > 200)
			L = 1
	if(L)
		visible_message("[user] 默默地走到鸟居上的每盏灯笼前，逐一点燃灯芯。")
		lit = TRUE
		Update()

/obj/structure/prop/dam/gravestone
	name = "墓碑"
	desc = "传统日式墓碑。"
	icon = 'icons/obj/structures/props/props.dmi'
	icon_state = "gravestone1"

/obj/structure/prop/dam/gravestone/New()
	..()
	icon_state = "gravestone[rand(1,4)]"

/obj/structure/prop/dam/boulder
	name = "巨石"
	icon_state = "boulder1"
	desc = "一块大石头。它可不会做饭。"
	icon = 'icons/obj/structures/props/dam.dmi'
	unslashable = TRUE
	unacidable = TRUE
/obj/structure/prop/dam/boulder/boulder1
	icon_state = "boulder1"
/obj/structure/prop/dam/boulder/boulder2
	icon_state = "boulder2"
/obj/structure/prop/dam/boulder/boulder3
	icon_state = "boulder3"


/obj/structure/prop/dam/large_boulder
	name = "巨石"
	desc = "一块大石头。它可不会做饭。"
	icon = 'icons/obj/structures/props/boulder_large.dmi'
	bound_height = 64
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE
/obj/structure/prop/dam/large_boulder/boulder1
	icon_state = "boulder_large1"
/obj/structure/prop/dam/large_boulder/boulder2
	icon_state = "boulder_large2"

/obj/structure/prop/dam/wide_boulder
	name = "巨石"
	desc = "一块大石头。它可不会做饭。"
	icon = 'icons/obj/structures/props/boulder_wide.dmi'
	bound_height = 32
	bound_width = 64

/obj/structure/prop/dam/wide_boulder/boulder1
	icon_state = "boulder1"

//Use these to replace non-functional machinery 'props' around maps from bay12

/obj/structure/prop/server_equipment
	name = "服务器机架"
	desc = "装满硬盘、微型计算机和以太网线的机架。"
	icon = 'icons/obj/structures/props/server_equipment.dmi'
	icon_state = "rackframe"
	unslashable = TRUE
	density = TRUE
	health = 150

/obj/structure/prop/server_equipment/broken
	name = "损坏的服务器机架"
	desc = "曾经装满硬盘、微型计算机和以太网线的机架，如今大多散落在地上。"
	icon_state = "rackframe_broken"
	health = 100

/obj/structure/prop/server_equipment/yutani_server
	name = "汤谷 OS 服务器箱"
	desc = "汤谷 OS 是公司用来运行几乎所有服务器、银行及管理系统的专有操作系统。2144 年的一次代码泄露，让一些业余黑客认为它大致基于 2017 年版 TempleOS，但公司否认了这些说法。"
	icon_state = "yutani_server_on"

/obj/structure/prop/server_equipment/yutani_server/broken
	icon_state = "yutani_server_broken"

/obj/structure/prop/server_equipment/yutani_server/off
	icon_state = "yutani_server_off"

/obj/structure/prop/server_equipment/laptop
	name = "笔记本电脑"
	desc = "笔记本、便携计算机和卷屏电脑，各种产品尽在当地维兰德超市电子产品区！"
	icon_state = "laptop_off"
	density = FALSE

/obj/structure/prop/server_equipment/laptop/closed
	icon_state = "laptop_closed"

/obj/structure/prop/server_equipment/laptop/on
	icon_state = "laptop_on"
	desc = "屏幕卡在某种循环启动中，闪着难看的刺眼绿光。文字全是鲁索克语，那是美洲联盟与进步人民联盟边境一些朝鲜人定居点衍生出的克里奥尔语。"

//biomass turbine

/obj/structure/prop/turbine //maybe turn this into an actual power generation device? Would be cool!
	name = "动力涡轮"
	icon = 'icons/obj/structures/props/biomass_turbine.dmi'
	icon_state = "biomass_turbine"
	desc = "巨大的涡轮，天知道烧什么。懂行的人大概能把它启动。"
	density = TRUE
	breakable = FALSE
	indestructible = TRUE
	unslashable = TRUE
	unacidable = TRUE
	var/on = FALSE
	bound_width = 32
	bound_height = 96

/obj/structure/prop/turbine/attackby(obj/item/W, mob/user)
	. = ..()
	if(isxeno(user))
		return
	else if (ishuman(user) && HAS_TRAIT(W, TRAIT_TOOL_CROWBAR))
		on = !on
		visible_message("你撬动 [src] 的控制阀，机器颤动起来。" , "[user] 撬动 [src] 的控制阀，整台机器都颤动起来。")

		Update()

/obj/structure/prop/turbine/proc/Update()
	icon_state = "biomass_turbine[on ? "-on" : ""]"
	if (on)
		set_light(3)
		playsound(src, 'sound/machines/turbine_on.ogg')
	else
		set_light(0)
		playsound(src, 'sound/machines/turbine_off.ogg')
	return

/obj/structure/prop/turbine/ex_act(severity, direction)
	return

/obj/structure/prop/turbine_extras
	name = "动力涡轮支撑管架"
	icon = 'icons/obj/structures/props/biomass_turbine.dmi'
	icon_state = "support_struts_r"
	desc = "管子，也可能是支撑架，通向——或者支撑着——那台老大的涡轮。"
	density = FALSE
	breakable = FALSE
	indestructible = TRUE
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/prop/turbine_extras/border
	name = "动力涡轮警示条纹"
	icon_state = "biomass_turbine_border"
	desc = "警示标记。保持安全距离，高压危险！"
	layer = 2.5

/obj/structure/prop/turbine_extras/left
	name = "动力涡轮支撑管架"
	icon_state = "support_struts_l"

/obj/structure/prop/turbine_extras/ex_act(severity, direction)
	return

//power transformer

/obj/structure/prop/power_transformer
	name = "电力变压器"
	icon = 'icons/obj/structures/props/power_transformer.dmi'
	icon_state = "transformer"
	bound_width = 64
	bound_height = 64
	desc = "控制电力流向及接入电路的无源电气元件。"
	unslashable = TRUE

//cash registers

/obj/structure/prop/cash_register
	name = "数字收银机"
	desc = "西格森牌销售终端，接受信用凭单；有人操作时也收现金。据说它与西格森工作乔伊使用相同逻辑板。你的财务状况开始不稳定了。"
	icon = 'icons/obj/structures/props/cash_register.dmi'
	icon_state = "cash_register"
	density = TRUE
	unslashable = TRUE
	health = 50

/obj/structure/prop/cash_register/open
	icon_state = "cash_register_open"

/obj/structure/prop/cash_register/broken
	icon_state = "cash_register_broken"

/obj/structure/prop/cash_register/broken/open
	icon_state = "cash_register_broken_open"

/obj/structure/prop/cash_register/off
	icon_state = "cash_register_off"

/obj/structure/prop/cash_register/off/open
	icon_state = "cash_register_off_open"

/obj/structure/prop/structure_lattice //instance me by direction for color variants
	name = "结构格架"
	desc = "像钢筋，只不过在太空里。"
	icon = 'icons/obj/structures/structures.dmi'
	icon_state = "structure_lattice"
	unslashable = TRUE
	density = TRUE //impassable by default

/obj/structure/prop/resin_prop
	name = "覆满树脂的物体"
	desc = "好吧，现在没用了。"
	icon = 'icons/obj/resin_objects.dmi'
	icon_state = "watertank"
	unslashable = TRUE

//industructible props
/obj/structure/prop/invuln
	name = "instanceable object"
	desc = "this needs to be defined by a coder"
	icon = 'icons/obj/structures/structures.dmi'
	icon_state = "structure_lattice"
	indestructible = TRUE
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/prop/invuln/ex_act(severity, direction)
	return

/obj/structure/prop/invuln/static_corpse

/obj/structure/prop/invuln/static_corpse/afric_zimmer
	name = "阿弗里克·齐默尔曼少校"
	desc = "阿弗里克·齐默尔曼少校的遗骸。整个头都不见了。有人落下了泪。"
	icon = 'icons/obj/structures/props/64x64.dmi'
	icon_state = "afric_zimmerman"
	density = FALSE

/obj/structure/prop/invuln/lifeboat_hatch_placeholder
	density = FALSE
	name = "失灵的舱口"
	desc = "光靠撬棍可搞不定这个。"
	icon = 'icons/obj/structures/machinery/bolt_target.dmi'
	icon_state = "closed"

/obj/structure/prop/invuln/lifeboat_hatch_placeholder/terminal
	icon = 'icons/obj/structures/machinery/bolt_terminal.dmi'
	icon_state = "closed"

/obj/structure/prop/invuln/dropship_parts //for TG shuttle system
	density = TRUE

/obj/structure/prop/invuln/dropship_parts/beforeShuttleMove() //moves content but leaves the turf behind (for cool space turf)
	. = ..()
	if(. & MOVE_AREA)
		. |= MOVE_CONTENTS
		. &= ~MOVE_TURF

/obj/structure/prop/invuln/dropship_parts/lifeboat
	name = "救生艇"
	icon_state = ""
	icon = 'icons/turf/lifeboat.dmi'

#define STATE_COMPLETE 0
#define STATE_FUEL 1
#define STATE_IGNITE 2

/obj/structure/prop/brazier
	name = "火盆"
	desc = "火盆里的光比手电筒和照明棒暗得多，但没有什么能取代与朋友围坐炉火旁的感觉。"
	icon = 'icons/obj/structures/structures.dmi'
	icon_state = "brazier"
	density = TRUE
	health = 150
	light_range = 6
	light_on = TRUE
	light_color = LIGHT_COLOR_FIRE
	unslashable = TRUE
	/// What obj this becomes when it gets to its next stage of construction / ignition
	var/frame_type
	/// What is used to progress to the next stage
	var/state = STATE_COMPLETE

/obj/structure/prop/brazier/Initialize()
	. = ..()

	if(!light_on)
		set_light(0)

/obj/structure/prop/brazier/get_examine_text(mob/user)
	. = ..()
	switch(state)
		if(STATE_FUEL)
			. += "[src]需要添加木材作为燃料。"
		if(STATE_IGNITE)
			. += "[src]需要点火。"

/obj/structure/prop/brazier/attackby(obj/item/hit_item, mob/user)
	switch(state)
		if(STATE_COMPLETE)
			return ..()
		if(STATE_FUEL)
			if(!istype(hit_item, /obj/item/stack/sheet/wood))
				return ..()
			var/obj/item/stack/sheet/wood/wooden_boards = hit_item
			if(!wooden_boards.use(5))
				to_chat(user, SPAN_WARNING("木材不足！"))
				return
			user.visible_message(SPAN_NOTICE("[user]将[hit_item]装入[src]。"))
		if(STATE_IGNITE)
			if(!hit_item.heat_source)
				return ..()
			if(!do_after(user, 3 SECONDS, INTERRUPT_MOVED, BUSY_ICON_BUILD))
				return
			user.visible_message(SPAN_NOTICE("[user]用[hit_item]点燃了[src]。"))

	new frame_type(loc)
	qdel(src)

/obj/structure/prop/brazier/frame
	name = "空火盆"
	desc = "一个空火盆。"
	icon_state = "brazier_frame"
	light_on = FALSE
	frame_type = /obj/structure/prop/brazier/frame/full
	state = STATE_FUEL

/obj/structure/prop/brazier/frame/full
	name = "装满的空火盆"
	desc = "一个空火盆，却又装满了。什么？？？用焊枪之类的热源点燃它。"
	icon_state = "brazier_frame_filled"
	frame_type = /obj/structure/prop/brazier
	state = STATE_IGNITE

/obj/structure/prop/brazier/torch
	name = "火把"
	desc = "一根火把。"
	icon_state = "torch"
	density = FALSE
	light_range = 5

/obj/structure/prop/brazier/frame/full/torch
	name = "未点燃的火把"
	desc = "一根尚未点燃的火把。用焊枪之类的热源点燃它。"
	icon_state = "torch_frame"
	frame_type = /obj/structure/prop/brazier/torch

/obj/item/prop/torch_frame
	name = "未点燃的火把"
	icon = 'icons/obj/structures/structures.dmi'
	desc = "一根未点燃、也未放置的火把。点击墙壁即可放上去。"
	icon_state = "torch_frame"

/obj/structure/prop/brazier/frame/full/campfire
	name = "未点燃的营火"
	desc = "一圈石头围着一堆木柴。要是能点燃就好了。"
	icon_state = "campfire"
	frame_type = /obj/structure/prop/brazier/campfire
	density = FALSE

/obj/structure/prop/brazier/frame/full/campfire/smolder
	name = "阴燃的营火"
	desc = "曾经燃烧却已熄灭的营火，仍能看见余烬，烟雾从中升起。"
	state = STATE_FUEL
	frame_type = /obj/structure/prop/brazier/frame/full/campfire

/obj/structure/prop/brazier/campfire
	name = "营火"
	desc = "一圈石头围着燃烧的木柴。火焰旺盛，噼啪作响。你大概可以把它踩灭。"
	icon = 'icons/obj/structures/structures.dmi'
	icon_state = "campfire_on"
	density = FALSE
	///How many tiles the heating and sound goes
	var/heating_range = 2
	/// time between sounds
	var/time_to_sound = 20
	/// Time for it to burn through fuel
	var/fuel_stage_time = 5 MINUTES
	/// How much fuel it has
	var/remaining_fuel = 10 //Maxes at 10, but burns one when made
	/// If the fire can be manually put out
	var/extinguishable = TRUE
	/// Make no noise
	var/quiet = FALSE

/obj/structure/prop/brazier/campfire/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)
	fuel_drain(TRUE)

/obj/structure/prop/brazier/campfire/get_examine_text(mob/user)
	. = ..()
	switch(remaining_fuel)
		if(7 to INFINITY)
			. += "火焰熊熊燃烧。"
		if(4 to 6)
			. += "火焰温暖地燃烧着。"
		if(-INFINITY to 3)
			. += "余烬几乎快熄灭了。"

/obj/structure/prop/brazier/campfire/process(delta_time)
	if(!isturf(loc))
		return

	for(var/mob/living/carbon/human/mob in range(heating_range, src))
		if(mob.bodytemperature < T20C)
			mob.bodytemperature += min(floor(T20C - mob.bodytemperature)*0.7, 25)
			mob.recalculate_move_delay = TRUE

	if(quiet)
		return
	time_to_sound -= delta_time
	if(time_to_sound <= 0)
		playsound(loc, 'sound/machines/firepit_ambience.ogg', 40, FALSE, heating_range)
		time_to_sound = initial(time_to_sound)

/obj/structure/prop/brazier/campfire/attack_hand(mob/user)
	. = ..()
	if(!extinguishable)
		to_chat(user, SPAN_WARNING("你无法熄灭[src]。"))
		return
	to_chat(user, SPAN_NOTICE("你开始熄灭[src]。"))
	while(remaining_fuel)
		if(user.action_busy || !do_after(user, 3 SECONDS, INTERRUPT_MOVED, BUSY_ICON_BUILD))
			return
		fuel_drain()
		to_chat(user, SPAN_NOTICE("你继续熄灭[src]。"))
	visible_message(SPAN_NOTICE("[user]熄灭了[src]。"))

/obj/structure/prop/brazier/campfire/attackby(obj/item/attacking_item, mob/user)
	if(!istype(attacking_item, /obj/item/stack/sheet/wood))
		to_chat(user, SPAN_NOTICE("你无法用[attacking_item]给[src]添燃料。"))
		return
	var/obj/item/stack/sheet/wood/fuel = attacking_item
	if(remaining_fuel >= initial(remaining_fuel))
		to_chat(user, SPAN_NOTICE("[src]无法再添加燃料。"))
		return
	if(!fuel.use(1))
		to_chat(user, SPAN_NOTICE("你的[attacking_item]不足，无法给[src]添燃料。"))
		return
	visible_message(SPAN_NOTICE("[user]用[fuel]给[src]添了燃料。"))
	remaining_fuel++

/obj/structure/prop/brazier/campfire/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(!extinguishable)
		to_chat(xeno, SPAN_WARNING("你无法熄灭[src]。"))
		return
	to_chat(xeno, SPAN_NOTICE("你开始熄灭[src]。"))
	while(remaining_fuel)
		if(xeno.action_busy || !do_after(xeno, 1 SECONDS, INTERRUPT_MOVED, BUSY_ICON_HOSTILE))
			return
		fuel_drain()
		to_chat(xeno, SPAN_NOTICE("你继续熄灭[src]。"))
	visible_message(SPAN_WARNING("[xeno]熄灭了[src]！"))

/obj/structure/prop/brazier/campfire/proc/fuel_drain(looping)
	remaining_fuel--
	if(!remaining_fuel)
		new /obj/structure/prop/brazier/frame/full/campfire/smolder(loc)
		qdel(src)
		return
	if(!looping || !fuel_stage_time)
		return
	addtimer(CALLBACK(src, PROC_REF(fuel_drain), TRUE), fuel_stage_time)

/obj/structure/prop/brazier/campfire/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

#undef STATE_COMPLETE
#undef STATE_FUEL
#undef STATE_IGNITE

//ICE COLONY PROPS
//Thematically look to Blackmesa's Xen levels. Generic science-y props n' stuff.

/obj/structure/prop/ice_colony
	name = "prop"
	desc = "Call a coder (or a mapper) you shouldn't be seeing this!"
	icon = 'icons/obj/structures/props/ice_colony/props.dmi'
	projectile_coverage = 10
	unslashable = TRUE

/obj/structure/prop/ice_colony/soil_net
	name = "土壤网格"
	desc = "科学家将这种网悬挂在地面上方，形成网格以开展研究。"
	icon_state = "soil_grid"

/obj/structure/prop/ice_colony/ice_crystal
	name = "冰晶"
	desc = "巨大的冰晶。在季节温度大幅变化时，仍有某种化学过程让它保持冻结；美洲联盟大阿根廷科学团队正在希瓦雪球研究此事。"
	icon_state = "ice_crystal"

/obj/structure/prop/ice_colony/ground_wire
	name = "地面标线"
	desc = "一根细黑线悬在两根标记柱之间，大概用来划定区域。"
	icon_state = "small_wire"

/obj/structure/prop/ice_colony/poly_kevlon_roll
	name = "塑料卷"
	desc = "用于搭建临时掩体的大卷聚合凯夫纶塑料。"
	icon_state = "kevlon_roll"
	anchored = FALSE

/obj/structure/prop/ice_colony/surveying_device
	name = "勘测仪"
	desc = "安装在三脚架上的小型激光测距仪与摄像机，涂成醒目的安全黄色。"
	icon_state = "surveying_device"
	anchored = FALSE

/obj/structure/prop/ice_colony/surveying_device/measuring_device
	name = "测量仪"
	desc = "某种用来测量东西的小装置。"
	icon_state = "measuring_device"

/obj/structure/prop/ice_colony/dense
	health = 75
	density = TRUE

/obj/structure/prop/ice_colony/dense/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(xeno.a_intent == INTENT_HARM)
		if(unslashable)
			return
		xeno.animation_attack_on(src)
		playsound(loc, 'sound/effects/metalhit.ogg', 25, 1)
		xeno.visible_message(SPAN_DANGER("[xeno]将[src]切成碎片！"),
		SPAN_DANGER("我们将[src]切成碎片！"), null, 5, CHAT_TYPE_XENO_COMBAT)
		deconstruct(FALSE)
		return XENO_ATTACK_ACTION
	else
		attack_hand(xeno)
		return XENO_NONCOMBAT_ACTION

/obj/structure/prop/ice_colony/dense/ice_tray
	name = "冰块托盘"
	icon_state = "ice_tray"
	desc = "装满深色冰块的托盘。"

/obj/structure/prop/ice_colony/dense/planter_box
	icon_state = "planter_box_soil"
	name = "种植箱"
	desc = "根系格架半埋在种植箱内。"

/obj/structure/prop/ice_colony/dense/planter_box/hydro
	icon_state = "hydro_tray"
	name = "水培格架"
	desc = "连接着两个浮筒的根系格架。"

/obj/structure/prop/ice_colony/dense/planter_box/plated
	icon_state = "planter_box_empty"
	name = "加板种植箱"
	desc = "种植箱是空的。"

/obj/structure/prop/ice_colony/flamingo
	density = FALSE
	name = "草坪火烈鸟"
	desc = "装饰你的郊区草坪……或者冰原殖民地。"
	icon_state = "flamingo"

/obj/structure/prop/ice_colony/flamingo/festive
	name = "节庆草坪火烈鸟"
	desc = "节日期间装饰你的郊区草坪……或者冰原殖民地。虽然这里也没人有地球日历。"
	icon_state = "flamingo_santa"

/obj/structure/prop/ice_colony/hula_girl //todo, animate based on dropship movement -Monkey
	name = "草裙舞女孩"
	desc = "显然，夏威夷曾经有过海滩。"
	icon = 'icons/obj/structures/props/ice_colony/Hula.dmi'
	icon_state = "Hula_Gal"

/obj/structure/prop/ice_colony/hula_girl/attack_hand(mob/user)
	..()
	flick("Hula_Gal_Bounce", src)

/obj/structure/prop/ice_colony/tiger_rug
	name = "虎皮地毯"
	desc = "相当俗气却令人印象深刻的虎皮地毯。出口到边缘地区一定花了大价钱。"
	icon = 'icons/obj/structures/props/ice_colony/Tiger_Rugs.dmi'
	icon_state = "Bengal" //instanceable, lots of variants!

//HOLIDAY THEMED BULLSHIT

/obj/structure/prop/holidays
	projectile_coverage = 0
	density = FALSE
	icon = 'icons/obj/structures/props/holiday_props.dmi'
	desc = "parent object for temporary holiday structures. If you are reading this, go find a mapper and tell them to search up error code: TOO MUCH EGGNOG"//hello future mapper. Next time use the sub types or instance the desc. Thanks -past mapper.
	layer = 4
	health = 50
	anchored = TRUE
	unslashable = TRUE

/obj/structure/prop/holidays/string_lights
	name = "M1 式节庆灯串"
	desc = "这些制式 M1“节庆灯串”挂在支架之间，随着阿尔迈耶号引擎的输出频率闪烁……也可能是当地电网。你这笨陆战队员，最好找布拉沃的人查查。"
	icon_state = "string_lights"


/obj/structure/prop/holidays/string_lights/corner
	icon_state = "strings_lights_corner"

/obj/structure/prop/holidays/string_lights/cap
	icon_state = "string_lights_cap"

/obj/structure/prop/holidays/wreath
	name = "M1 式节庆针叶花环"
	desc = "2140 年，圣路易斯湾地下居住区两个不同地下层因使用真正针叶制作的花环而起火，之后便改为配发这种东西。证据指向银翼杀手事件，但当地警方否认。它们由带有所谓“松木”气味的聚合凯夫纶制成。据美洲走廊的士兵说，SACO 骚乱期间，示威者曾把它们塞进枕套，制成抵挡软尖弹的简易护甲。"
	icon_state = "wreath"
/obj/structure/prop/vehicles
	name = "厢式货车"
	desc = "一辆老旧的厢型车，似乎已经抛锚。"
	icon = 'icons/obj/structures/props/vehicles.dmi'
	icon_state = "van"
	bound_height = 64
	bound_width = 64
	unslashable = FALSE
	unacidable = FALSE

/obj/structure/prop/vehicles/crawler
	name = "殖民地履带车"
	desc = "用于恶劣环境的履带车，由轨道蓝国际供应——“您在航空航天行业的朋友”。该公司是维兰德-汤谷的子公司。"
	icon_state = "crawler"
	density = TRUE

/obj/structure/prop/vehicles/tank/twe
	name = "\improper FV150“翔保”MkII"
	desc = "FV150“翔保”MkII 在官方文件中被归类为履带式战斗侦察车，简称 CVR(T)。它由维兰德-汤谷与土卫六重型载具制造商加拉尔公司于 2175 年联合开发。吸取 MkI 在澳洲战争中的教训后，进行了重大结构改进，MkII 于 2178 年投产。配备双联装 30 毫米炮和 L58A3 10×28 毫米同轴机枪，备弹分别为 170 发和 1,600 发。最高时速 60 英里，但实战部署满载弹药、考虑地形后，通常稳定在 55 英里。"
	icon = 'icons/obj/vehicles/twe_tank.dmi'
	icon_state = "twe_tank"
	density = TRUE

//overhead prop sets

/obj/structure/prop/invuln/overhead
	layer = ABOVE_FLY_LAYER
	icon = 'icons/obj/structures/props/overhead_ducting.dmi'
	icon_state = "flammable_pipe_1"

/obj/structure/prop/invuln/overhead/flammable_pipe
	name = "密集燃料管线"
	desc = "很可能极其易燃。"
	density = TRUE

/obj/structure/prop/invuln/overhead/flammable_pipe/fly
	density = FALSE


/obj/structure/prop/static_tank
	name = "储液罐"
	desc = "警告，内容物处于高压！"
	icon = 'icons/obj/structures/props/generic_props.dmi'
	icon_state = "tank"
	density = TRUE
	unslashable = TRUE

/obj/structure/prop/static_tank/fuel
	desc = "内含癸图索尔－海波斯帕迪醇，一种不易挥发、尝起来像橙子的液体燃料。除大气火箭助推器外，几乎没有其他用途。"
	icon_state = "weldtank_old"

/obj/structure/prop/static_tank/water
	desc = "内装非饮用水，侧面标签要求饮用前煮沸。闻起来隐约像阿尔迈耶号的淋浴间。"
	icon_state = "watertank_old"

/obj/structure/prop/broken_arcade
	desc = "你看不清屏幕后面的东西，它看起来半人半机器。"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "arcadeb"
	name = "《灵魂电话》游戏改编电影：第二部"

//INVULNERABLE PROPS

/obj/structure/prop/invuln
	layer = ABOVE_MOB_LAYER
	density = TRUE
	icon = 'icons/obj/structures/props/ice_colony/props.dmi'
	icon_state = "ice_tray"

/obj/structure/prop/invuln/catwalk_support
	name = "支撑格架"
	icon_state = "support_lattice"
	desc = "一组大型钢支撑梁的中段。"
	density = FALSE

/obj/structure/prop/invuln/minecart_tracks
	name = "轨道"
	icon_state = "rail"
	icon = 'icons/obj/structures/props/mining.dmi'
	density =  0
	desc = "矿车和轨道载具在上面行驶。"
	layer = 3

/obj/structure/prop/invuln/minecart_tracks/bumper
	name = "轨道缓冲挡"
	icon_state = "rail_bumpers"
	desc = "通常能在轨道末端挡住矿车及其他轨道载具。"

/obj/structure/prop/invuln/dense
	density = TRUE

/obj/structure/prop/invuln/dense/catwalk_support
	name = "支撑格架"
	icon_state = "support_lattice"
	desc = "一组大型钢支撑梁的底座。"

/obj/structure/prop/invuln/dense/ice_tray
	name = "冰块托盘"
	icon_state = "ice_tray"
	desc = "装满深色冰块的托盘。"

/obj/structure/prop/invuln/ice_prefab
	name = "预制建筑"
	desc = "由金属支撑杆和坚固聚合凯夫纶塑料制成的建筑，材料衍生自美洲联盟防弹背心，以及美国殖民地陆战队和进步人民联盟制服所用织物。松散墙面随每阵风摇动。"
	icon = 'icons/obj/structures/props/ice_colony/fabs_tileset.dmi'
	icon_state = "fab"
	density = TRUE
	layer = 3
	bound_width = 32
	bound_height = 32

/obj/structure/prop/invuln/ice_prefab/trim
	layer = ABOVE_MOB_LAYER
	density = FALSE

/obj/structure/prop/invuln/ice_prefab/roof_greeble
	icon = 'icons/obj/structures/props/ice_colony/fabs_greebles.dmi'
	icon_state = "antenna"
	layer = ABOVE_MOB_LAYER
	desc = "风向袋、空调机和太阳能板，天哪！"
	density = FALSE


/obj/structure/prop/invuln/ice_prefab/standalone
	density = TRUE
	icon = 'icons/obj/structures/props/ice_colony/fabs_64.dmi'
	icon_state = "orange"//instance icons
	layer = 3
	bound_width = 64
	bound_height = 64

/obj/structure/prop/invuln/ice_prefab/standalone/trim
	icon_state = "orange_trim"//instance icons
	layer = ABOVE_MOB_LAYER
	density = FALSE

/obj/structure/prop/invuln/remote_console_pod
	name = "遥控控制舱"
	desc = "用于向美国殖民地陆战队作战区域投送遥控驾驶设备的空投舱。"
	icon = 'icons/obj/structures/droppod_32x64.dmi'
	icon_state = "techpod_open"
	layer = DOOR_CLOSED_LAYER

/obj/structure/prop/invuln/overhead_pipe
	name = "顶部管道段"
	desc = ""
	icon = 'icons/obj/pipes/pipes.dmi'
	icon_state = "intact-scrubbers"
	projectile_coverage = 0
	density = FALSE
	layer = RIPPLE_LAYER

/obj/structure/prop/invuln/overhead_pipe/Initialize(mapload)
	. = ..()
	desc = "这是管网的一部分，负责在[is_mainship_level(z) ? copytext(MAIN_SHIP_NAME, 5) : "殖民地"]内输送水，以及不那么愉快的其他液体。"

///Decorative fire.
/obj/structure/prop/invuln/fire
	name = "火焰"
	desc = "这火一时半会儿灭不了。"
	color = "#FF7700"
	icon = 'icons/effects/fire.dmi'
	icon_state = "dynamic_2"
	layer = MOB_LAYER
	light_range = 3
	light_on = TRUE

/obj/structure/prop/invuln/fusion_reactor
	name = "\improper S-52聚变反应堆"
	desc = "西屋兰 S-52 聚变反应堆，将燃料电池转换为电能，同时产生大量热量。"
	icon = 'icons/obj/structures/machinery/fusion_eng.dmi'
	icon_state = "off"

/obj/structure/prop/invuln/pipe_water
	name = "管道漏水"
	desc = ""
	icon = 'icons/obj/structures/props/watercloset.dmi'
	icon_state = "water"
	density = 0

/obj/structure/prop/invuln/pipe_water/Initialize(mapload)
	. = ..()
	desc = "[is_mainship_level(z) ? copytext(MAIN_SHIP_NAME, 5) : "殖民地"]漏水了！"

/obj/structure/prop/invuln/lattice_prop
	desc = "轻型支撑格架。"
	name = "格架"
	icon = 'icons/obj/structures/props/smoothlattice.dmi'
	icon_state = "lattice0"
	density = FALSE
	layer = RIPPLE_LAYER

/obj/structure/prop/wooden_cross
	name = "木十字架"
	desc = "木制墓碑。因为出自手工而更显敬意，还是因为粗糙歪斜而更显敷衍？"
	icon = 'icons/obj/structures/props/crosses.dmi'
	icon_state = "cross1"
	density = FALSE
	health = 30
	var/inscription
	var/obj/item/helmet
	///This is for cross dogtags.
	var/tagged = FALSE
	///This is for cross engraving/writing.
	var/engraved = FALSE
	var/dogtag_name
	var/dogtag_blood
	var/dogtag_assign

/obj/structure/prop/wooden_cross/Destroy()
	if(helmet)
		helmet.forceMove(loc)
		helmet = null
	if(tagged)
		var/obj/item/dogtag/new_info_tag = new(loc)
		new_info_tag.fallen_names = list(dogtag_name)
		new_info_tag.fallen_assgns = list(dogtag_assign)
		new_info_tag.fallen_blood_types = list(dogtag_blood)
		GLOB.fallen_list_cross -= dogtag_name
	return ..()

/obj/structure/prop/wooden_cross/attackby(obj/item/W, mob/living/user)
	if(istype(W, /obj/item/dogtag))
		var/obj/item/dogtag/dog = W
		if(!tagged)
			tagged = TRUE
			user.visible_message(SPAN_NOTICE("[user]将[W]挂在[src]上。"))
			dogtag_name = popleft(dog.fallen_names)
			dogtag_assign = popleft(dog.fallen_assgns)
			dogtag_blood = popleft(dog.fallen_blood_types)
			GLOB.fallen_list_cross += dogtag_name
			update_icon()
			if(!length(dog.fallen_names))
				qdel(dog)
			else
				return
		else
			to_chat(user, SPAN_WARNING("[src]上已经有身份识别牌了！"))
			balloon_alert(user, "这里已有识别牌！")

	if(istype(W, /obj/item/clothing/head))
		if(helmet)
			to_chat(user, SPAN_WARNING("[helmet]已经放在[src]顶部！"))
			return
		if(!user.drop_inv_item_to_loc(W, src))
			return
		helmet = W
		dir = SOUTH
		var/image/visual_overlay = W.get_mob_overlay(null, WEAR_HEAD)
		visual_overlay.pixel_y = -10 //Base image is positioned to go on a human's head.
		overlays += visual_overlay
		to_chat(user, SPAN_NOTICE("你将[W]放到了[src]顶部。"))
		return

	if(user.a_intent == INTENT_HARM)
		..()
		if(W.force && !(W.flags_item & NOBLUDGEON))
			playsound(src, 'sound/effects/woodhit.ogg', 25, 1)
			update_health(W.force)
		return

	if(W.sharp || W.edge || HAS_TRAIT(W, TRAIT_TOOL_PEN) || istype(W, /obj/item/tool/hand_labeler))
		var/action_msg
		var/time_multiplier
		if(W.sharp || W.edge)
			action_msg = "刻字于"
			time_multiplier = 3
		else
			action_msg = "写字于"
			time_multiplier = 2

		var/message = sanitize(input(user, "你想在 [src] 上写些什么？", "题字"))
		if(!message)
			return
		user.visible_message(SPAN_NOTICE("[user]开始[action_msg][src]。"),\
			SPAN_NOTICE("你开始[action_msg][src]。"), null, 4)

		if(!do_after(user, length(message) * time_multiplier, INTERRUPT_ALL, BUSY_ICON_GENERIC))
			to_chat(user, SPAN_WARNING("你的操作被打断了！"))
		else
			user.visible_message(SPAN_NOTICE("[user]用[W.name][action_msg][src]。"),\
				SPAN_NOTICE("你用[W.name][action_msg][src]。"), null, 4)
			if(inscription)
				inscription += "\n[message]"
			else
				inscription = message
				engraved = TRUE

/obj/structure/prop/wooden_cross/get_examine_text(mob/user)
	. = ..()
	. += (tagged ? "十字架上挂着身份识别牌，上面写着：\"[dogtag_name] - [dogtag_assign] - [dogtag_blood]\"." : "十字架上没有身份识别牌。")
	. += (engraved ? "上面刻着字，内容为：\"[inscription]\"" : "上面没有刻字。")

/obj/structure/prop/wooden_cross/attack_hand(mob/user)
	if(helmet)
		helmet.forceMove(loc)
		user.put_in_hands(helmet)
		to_chat(user, SPAN_NOTICE("你从[src]上取下[helmet]。"))
		helmet = null
		overlays.Cut()

/obj/structure/prop/wooden_cross/attack_alien(mob/living/carbon/xenomorph/M)
	M.animation_attack_on(src)
	update_health(rand(M.melee_damage_lower, M.melee_damage_upper))
	playsound(src, 'sound/effects/woodhit.ogg', 25, 1)
	if(health <= 0)
		M.visible_message(SPAN_DANGER("[M]将[src]切成碎片！"), \
		SPAN_DANGER("你将[src]切开！"), null, 5, CHAT_TYPE_XENO_COMBAT)
	else
		M.visible_message(SPAN_DANGER("[M]抓挠了[src]！"), \
		SPAN_DANGER("你劈砍了[src]！"), null, 5, CHAT_TYPE_XENO_COMBAT)
	return XENO_ATTACK_ACTION

/obj/structure/prop/wooden_cross/update_icon()
	if(tagged)
		overlays += mutable_appearance('icons/obj/structures/props/crosses.dmi', "cross_overlay")


/obj/structure/prop/invuln/rope
	name = "绳索"
	desc = "一根固定牢靠的绳索，看起来有人曾躲在那些岩石上。"
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "rope"
	density = FALSE

/obj/structure/prop/pred_flight
	name = "猎手飞行控制台"
	desc = "由猎手设计，用于辅助规划航线和导航的控制台。"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "overwatch"
	unslashable = TRUE
	density = TRUE

/obj/structure/prop/invuln/joey
	name = "工作乔伊酒保"
	desc = "一队陆战队员在上次岸休后从深处仓库搬出来的报废西格森工作乔伊。有人试图把这台清洁合成人改成简陋酒保，但效果不佳。"
	icon = 'icons/obj/structures/props/props.dmi'
	icon_state = "joey"
	unslashable = FALSE
	wrenchable = FALSE
	/// converted into minutes when used to determine cooldown timer between quips
	var/quip_delay_minimum = 5
	/// delay between Quips. Slightly randomized with quip_delay_minimum plus a random number
	COOLDOWN_DECLARE(quip_delay)
	/// delay between attack voicelines. Short but done for anti-spam
	COOLDOWN_DECLARE(damage_delay)
	/// list of quip emotes, taken from Working Joe
	var/static/list/quips = list(
		/datum/emote/living/carbon/human/synthetic/working_joe/greeting/hello,
		/datum/emote/living/carbon/human/synthetic/working_joe/quip/not_liking,
		/datum/emote/living/carbon/human/synthetic/working_joe/greeting/how_can_i_help,
		/datum/emote/living/carbon/human/synthetic/working_joe/farewell/day_never_done,
		/datum/emote/living/carbon/human/synthetic/working_joe/greeting/been_looking_for_you,
		/datum/emote/living/carbon/human/synthetic/working_joe/question/lost,
		/datum/emote/living/carbon/human/synthetic/working_joe/quip/alwaysknow,
		/datum/emote/living/carbon/human/synthetic/working_joe/quip/talk_to_seegson,
		/datum/emote/living/carbon/human/synthetic/working_joe/restricted_area/interloper,
		/datum/emote/living/carbon/human/synthetic/working_joe/quip/seegson_quality,
		/datum/emote/living/carbon/human/synthetic/working_joe/task_update/with_you_shortly
	)
	/// list of voicelines to use when damaged
	var/static/list/damaged = list(
		/datum/emote/living/carbon/human/synthetic/working_joe/damage/damage,
		/datum/emote/living/carbon/human/synthetic/working_joe/damage/that_stings,
		/datum/emote/living/carbon/human/synthetic/working_joe/damage/irresponsible,
		/datum/emote/living/carbon/human/synthetic/working_joe/damage/this_is_futile,
		/datum/emote/living/carbon/human/synthetic/working_joe/warning/hysterical,
		/datum/emote/living/carbon/human/synthetic/working_joe/warning/patience
	)

/obj/structure/prop/invuln/joey/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/structure/prop/invuln/joey/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/prop/invuln/joey/process()
	//check if quip_delay cooldown finished. If so, random chance it says a line
	if(COOLDOWN_FINISHED(src, quip_delay) && prob(10))
		emote(pick(quips))
		var/delay = rand(3) + quip_delay_minimum
		COOLDOWN_START(src, quip_delay, delay MINUTES)

// Advert your eyes.
/obj/structure/prop/invuln/joey/attackby(obj/item/W, mob/user)
	attacked()
	return ..()

/obj/structure/prop/invuln/joey/bullet_act(obj/projectile/P)
	attacked()
	return ..()

/// A terrible way of handling being hit. If signals would work it should be used.
/obj/structure/prop/invuln/joey/proc/attacked()
	if(COOLDOWN_FINISHED(src, damage_delay) && prob(25))
		emote(pick(damaged))
		COOLDOWN_START(src, damage_delay, 8 SECONDS)

/// SAY THE LINE JOE
/obj/structure/prop/invuln/joey/proc/emote(datum/emote/living/carbon/human/synthetic/working_joe/emote)
	if (!emote)
		return FALSE

	for(var/mob/mob in hearers(src, null))
		mob.show_message("<span class='game say'><span class='name'>[src]</span> 说道：\"[initial(emote.say_message)]\"</span>", SHOW_MESSAGE_AUDIBLE)

	var/list/viewers = get_mobs_in_view(7, src)
	for(var/mob/current_mob in viewers)
		if(!(current_mob.client?.prefs.toggles_langchat & LANGCHAT_SEE_EMOTES))
			viewers -= current_mob
	langchat_speech(initial(emote.say_message), viewers, GLOB.all_languages, skip_language_check = TRUE)

	if(initial(emote.sound))
		playsound(loc, initial(emote.sound), 50, FALSE)
	return TRUE

/obj/structure/prop/invuln/joey/normal
	name = "工作乔伊"
	desc = "西格森牌工作乔伊，存放在合成人维护站，随时可以调用。前提是你有钥匙。"
	icon_state = "joe"

/obj/structure/prop/invuln/darkness //I cant take credit for this, whoever made LV671 this was all you
	name = "黑暗"
	icon = 'icons/turf/areas.dmi'
	icon_state = "dark128"
	alpha = 200
	opacity = 0
	mouse_opacity = 0
	layer = 6
	density = 0
