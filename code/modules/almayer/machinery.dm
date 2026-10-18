//-----USS Almayer Machinery file -----//
// Put any new machines in here before map is released and everything moved to their proper positions.

/obj/structure/machinery/prop/almayer
	name = "GENERIC USS ALMAYER PROP"
	desc = "THIS SHOULDN'T BE VISIBLE, AHELP 'ART-P01' IF SEEN IN ROUND WITH LOCATION"

/obj/structure/machinery/prop/almayer/hangar/dropship_part_fabricator

/obj/structure/machinery/prop/almayer/computer/PC
	name = "个人桌面终端"
	desc = "连接舰船计算机网络的小型计算机。"
	icon_state = "terminal1"

/obj/structure/machinery/prop/almayer/computer/PC/large
	icon_state = "largecomp"

/obj/structure/machinery/prop/almayer/computer/PC/large/dark
	icon_state = "largecomp_dark"

/obj/structure/machinery/prop/almayer/computer
	name = "系统计算机"
	desc = "连接舰船系统的小型计算机。"

	density = FALSE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 20

	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "terminal"

/obj/structure/machinery/prop/almayer/computer/ex_act(severity)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if (prob(25))
				set_broken()
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if (prob(25))
				deconstruct(FALSE)
				return
			if (prob(50))
				set_broken()
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)
			return
		else
			return

/obj/structure/machinery/prop/almayer/computer/proc/set_broken()
	stat |= BROKEN
	update_icon()

/obj/structure/machinery/prop/almayer/computer/update_icon()
	..()
	icon_state = initial(icon_state)
	if(stat & BROKEN)
		icon_state += "b"
	if(stat & NOPOWER)
		icon_state = initial(icon_state)
		icon_state += "0"

/obj/structure/machinery/prop/almayer/computer/NavCon
	name = "导航控制台"
	desc = "用于规划舰船航线与航向。人工智能负责全部远程导航，这台控制台仅用于星系内航线修正与轨道机动。别乱碰！"

	icon_state = "retro"

/obj/structure/machinery/prop/almayer/computer/NavCon2
	name = "导航控制台2"
	desc = "用于规划舰船航线与航向。人工智能负责全部远程导航，这台控制台仅用于星系内航线修正与轨道机动。别乱碰！"

	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "retro2"

/obj/structure/machinery/prop/almayer/CICmap
	name = "地图桌"
	desc = "显示当前行动地点地图的桌子。"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "maptable"
	anchored = TRUE
	use_power = USE_POWER_IDLE
	density = TRUE
	idle_power_usage = 2
	var/datum/tacmap/map
	///flags that we want to be shown when you interact with this table
	var/minimap_type = MINIMAP_FLAG_USCM
	///The faction that is intended to use this structure (determines type of tacmap used)
	var/faction = FACTION_MARINE

/obj/structure/machinery/prop/almayer/CICmap/Initialize()
	. = ..()

	map = new /datum/tacmap/drawing(src, minimap_type)


/obj/structure/machinery/prop/almayer/CICmap/Destroy()
	QDEL_NULL(map)
	return ..()

/obj/structure/machinery/prop/almayer/CICmap/attack_hand(mob/user)
	. = ..()

	map.tgui_interact(user)

/obj/structure/machinery/prop/almayer/CICmap/computer
	name = "地图终端"
	desc = "显示当前行动地点地图的终端。"
	icon = 'icons/obj/vehicles/interiors/arc.dmi'
	icon_state = "cicmap_computer"
	density = FALSE

/obj/structure/machinery/prop/almayer/CICmap/upp
	minimap_type = MINIMAP_FLAG_UPP
	faction = FACTION_UPP

/obj/structure/machinery/prop/almayer/CICmap/clf
	minimap_type = MINIMAP_FLAG_CLF
	faction = FACTION_CLF

/obj/structure/machinery/prop/almayer/CICmap/pmc
	minimap_type = MINIMAP_FLAG_PMC
	faction = FACTION_PMC

/obj/structure/machinery/prop/almayer/CICmap/rmc
	minimap_type = MINIMAP_FLAG_TWE
	faction = FACTION_TWE

/obj/structure/machinery/prop/almayer/CICmap/toc
	name = "战术地图屏"
	desc = "战术行动中心计算机上用于显示战术地图的屏幕。"
	icon_state =  "toc_map"

/obj/structure/machinery/prop/almayer/CICmap/table
	name = "地图桌"
	desc = "用于规划行动的大型平面地图桌，甚至大到可以当普通桌子使用。"
	icon = 'icons/obj/structures/props/almayer_props96.dmi'
	icon_state = "maptable"
	layer = TABLE_LAYER
	light_system = STATIC_LIGHT
	light_color = "#DAE2FF"
	light_power = 1
	light_range = 2.5
	light_pixel_x = 16
	light_pixel_y = 32
	bound_width = 64
	bound_height = 96

/obj/structure/machinery/prop/almayer/CICmap/table/attackby(obj/item/attacking_item, mob/user, click_data)
	if(!user.drop_inv_item_to_loc(attacking_item, loc))
		return

	auto_align(attacking_item, click_data)
	user.next_move = world.time + 2
	return TRUE

/obj/structure/machinery/prop/almayer/CICmap/table/proc/auto_align(obj/item/new_item, click_data)
	if(!new_item.center_of_mass) // Clothing, material stacks, generally items with large sprites where exact placement would be unhandy.
		new_item.pixel_x = rand(-new_item.randpixel, new_item.randpixel)
		new_item.pixel_y = rand(-new_item.randpixel, new_item.randpixel)
		new_item.pixel_z = 0
		return

	if(!click_data)
		return

	if(!click_data[ICON_X] || !click_data[ICON_Y])
		return

	// Calculation to apply new pixelshift.
	var/mouse_x = text2num(click_data[ICON_X])-1 // Ranging from 0 to 31
	var/mouse_y = text2num(click_data[ICON_Y])-1

	var/cell_x = clamp(floor(mouse_x/CELLSIZE), 0, CELLS-1) // Ranging from 0 to CELLS-1
	var/cell_y = clamp(floor(mouse_y/CELLSIZE), 0, CELLS-1)

	var/list/center = cached_key_number_decode(new_item.center_of_mass)

	new_item.pixel_x = (CELLSIZE * (cell_x + 0.5)) - center["x"]
	new_item.pixel_y = (CELLSIZE * (cell_y + 0.5)) - center["y"]
	new_item.pixel_z = 0

/obj/structure/machinery/prop/almayer/CICmap/table/update_icon()
	..()

	overlays.Cut()

	if(!(stat & NOPOWER))
		var/image/source_image = image(src.icon, icon_state = "[icon_state]_e")
		overlays += emissive_appearance(source_image.icon, source_image.icon_state)
		overlays += mutable_appearance(source_image.icon, source_image.icon_state)
		light_power = 1
	else return

/obj/structure/machinery/prop/almayer/CICmap/table/segment
	icon = 'icons/obj/structures/props/maptable.dmi'
	icon_state = "v_maptable1"
	bound_width = 32
	bound_height = 32
	light_pixel_x = 0
	light_pixel_y = 0

/obj/structure/machinery/prop/almayer/CICmap/table/segment/one
	icon_state = "v_maptable1"

/obj/structure/machinery/prop/almayer/CICmap/table/segment/two
	icon_state = "v_maptable2"

/obj/structure/machinery/prop/almayer/CICmap/table/segment/three
	icon_state = "v_maptable3"

/obj/structure/machinery/prop/almayer/CICmap/table/segment/four
	icon_state = "v_maptable4"

/obj/structure/machinery/prop/almayer/CICmap/table/segment/five
	icon_state = "v_maptable5"

/obj/structure/machinery/prop/almayer/CICmap/table/segment/six
	icon_state = "v_maptable6"

/obj/structure/machinery/prop/almayer/CICmap/table/horizontal
	icon_state = "h_maptable"
	bound_width = 96
	bound_height = 64
	light_pixel_x = 32
	light_pixel_y = 16

/obj/structure/machinery/prop/almayer/CICmap/table/horizontal/segment
	icon = 'icons/obj/structures/props/maptable.dmi'
	icon_state = "h_maptable1"
	bound_width = 32
	bound_height = 32
	light_pixel_x = 0
	light_pixel_y = 0

/obj/structure/machinery/prop/almayer/CICmap/table/horizontal/segment/one
	icon_state = "h_maptable1"

/obj/structure/machinery/prop/almayer/CICmap/table/horizontal/segment/two
	icon_state = "h_maptable2"

/obj/structure/machinery/prop/almayer/CICmap/table/horizontal/segment/three
	icon_state = "h_maptable3"

/obj/structure/machinery/prop/almayer/CICmap/table/horizontal/segment/four
	icon_state = "h_maptable4"

/obj/structure/machinery/prop/almayer/CICmap/table/horizontal/segment/five
	icon_state = "h_maptable5"

/obj/structure/machinery/prop/almayer/CICmap/table/horizontal/segment/six
	icon_state = "h_maptable6"

//Nonpower using props

/obj/structure/prop/almayer
	name = "GENERIC USS ALMAYER PROP"
	desc = "THIS SHOULDN'T BE VISIBLE, AHELP 'ART-P02' IF SEEN IN ROUND WITH LOCATION"
	density = TRUE
	anchored = TRUE
	unslashable = TRUE

/obj/structure/prop/almayer/minigun_crate
	name = "30毫米弹药箱"
	desc = "装满30毫米弹的箱子，供运输艇的一类武器吊舱使用。移动它需要某种起重设备。"
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "30mm_crate"

/obj/structure/prop/almayer/sadar_decoration
	name = "\improper 已用尽的M83A2肩射反装甲导弹发射筒"
	desc = "一具用过的M83A2发射筒，曾在近千米外幸运地击毁一辆坦克，因此被留下作纪念。侧面刻着一道计数痕迹，记录它的首次击杀。"
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "sadar_decoration"
	density = FALSE

/obj/structure/prop/almayer/computers
	var/hacked = FALSE

/obj/structure/prop/almayer/computers/update_icon()
	. = ..()

	overlays.Cut()

	if(hacked)
		overlays += "+hacked"

/obj/structure/prop/almayer/computers/mission_planning_system
	name = "\improper MPS IV计算机"
	desc = "第四代任务规划系统，改进了殖民地陆战队运输艇驾驶员的任务规划与航图绘制能力，可按战斗需求定制航线和武器配置。"
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "mps"

/obj/structure/prop/almayer/computers/mapping_computer
	name = "\improper CMPS II计算机"
	desc = "第二代通用地图制作系统，整合卫星与舰船系统的传感数据，为殖民地陆战队驾驶员制作标准化行星地图。"
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "mapping_comp"

/obj/structure/prop/almayer/computers/sensor_computer1
	name = "传感器计算机"
	desc = "改装为舰船传感器计算机的IBM 10系列计算机。虽然有些老旧，仍能胜任工作。"
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "sensor_comp1"

/obj/structure/prop/almayer/computers/sensor_computer2
	name = "传感器计算机"
	desc = "改装为舰船传感器计算机的IBM 10系列计算机。虽然有些老旧，仍能胜任工作。"
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "sensor_comp2"

/obj/structure/prop/almayer/computers/sensor_computer3
	name = "传感器计算机"
	desc = "改装为舰船传感器计算机的IBM 10系列计算机。虽然有些老旧，仍能胜任工作。"
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "sensor_comp3"

/obj/structure/prop/almayer/missile_tube
	name = "\improper Mk 33反卫星导弹发射系统"
	desc = "可发射多种导弹的冷发射管，常见弹种包括用于攻击卫星和其他航天器的ASAT-21“细剑Ⅳ”导弹，以及用于对地攻击的BGM-227“大锤”导弹。"
	icon = 'icons/obj/structures/props/almayer_props96.dmi'
	icon_state = "missiletubenorth"
	bound_width = 32
	bound_height = 96
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/prop/almayer/whiteboard
	name = "\improper 白板"
	desc = "空白的白色表面，让想法变成计划。如今一片空白，因为人们不断画不合适的东西，所有笔都用干了。"
	icon = 'icons/obj/structures/props/almayer_props64.dmi'
	icon_state = "whiteboard"
	bound_width = 64

/obj/structure/prop/almayer/whiteboard/clear
	name = "\improper 玻璃白板"
	desc = "尽管叫白板，它实际上是一块透明玻璃。为什么要让人看穿白板，直到2182年仍是一大谜团。"
	icon_state = "whiteboard_clear"

/obj/structure/prop/almayer/ship_memorial
	name = "胜利纪念碑"
	desc = "纪念殖民地陆战队的胜利与本舰阵亡将士。碑左侧镌刻着辉煌战绩，右侧列着为殖民地陆战队战死的著名陆战队员姓名。"
	icon = 'icons/obj/structures/props/almayer_props64.dmi'
	icon_state = "ship_memorial"
	bound_width = 64
	bound_height = 32
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/prop/almayer/ship_memorial/golden_arrow
	name = "纪念碑"
	desc = "纪念金箭号阵亡将士的铭牌。名单长得令人遗憾。"
	icon_state = "garrow_memorial"

/obj/structure/prop/almayer/ship_memorial/centcomm
	name = "追思纪念碑"
	desc = "纪念所有已退出CM开发的维护团队成员。这里没有导师的名字。"

/obj/structure/prop/almayer/ship_memorial/centcomm/admin
	desc = "纪念所有已退出CM管理工作的管理员与版主。这里没有导师的名字。"


/obj/structure/prop/almayer/ship_memorial/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/dogtag))
		var/obj/item/dogtag/D = I
		if(D.fallen_names)
			to_chat(user, SPAN_NOTICE("你将[D]放到了[src]上。"))
			GLOB.fallen_list += D.fallen_names
			qdel(D)
		return TRUE
	else
		. = ..()

/obj/structure/prop/almayer/ship_memorial/get_examine_text(mob/user)
	. = ..()
	if((isobserver(user) || ishuman(user)) && GLOB.fallen_list)
		var/faltext = ""
		for(var/i = 1 to length(GLOB.fallen_list))
			if(i != length(GLOB.fallen_list))
				faltext += "[GLOB.fallen_list[i]], "
			else
				faltext += GLOB.fallen_list[i]
		. += SPAN_NOTICE("致阵亡将士：<b>[faltext]</b>。")

/obj/structure/prop/almayer/particle_cannon
	name = "\improper 通用原子75厘米/140倍径Mark 74轨道炮"
	desc = "Mark 74轨道炮是顶尖舰载武器，能以每秒24千米的速度发射直径0.75米的炮弹。新设计的供弹系统还可随时切换多种弹型。"
	icon = 'icons/obj/structures/machinery/artillery.dmi'
	icon_state = "1"
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/prop/almayer/particle_cannon/corsat
	name = "\improper CORSAT-PROTO-QUANTUM-CALCULATOR"
	desc = ""

/obj/structure/prop/almayer/name_stencil
	name = "USS阿尔迈耶号"
	desc = "喷印在船体上的舰名。"
	icon = 'icons/obj/structures/props/almayer_props64.dmi'
	icon_state = "almayer0"
	density = FALSE //dunno who would walk on it, but you know.
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/prop/almayer/hangar_stencil
	name = "地板"
	desc = "喷印在机库地面的大号数字，用于标识运输艇停靠位。"
	icon = 'icons/obj/structures/props/almayer_props96.dmi'
	icon_state = "dropship1"
	density = FALSE
	layer = ABOVE_TURF_LAYER


/obj/structure/prop/almayer/cannon_cables
	name = "\improper 火炮电缆"
	desc = "几根粗大的电缆。"
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "cannon_cables"
	density = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = LADDER_LAYER
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/prop/almayer/cannon_cables/ex_act()
	return

/obj/structure/prop/almayer/cannon_cables/bullet_act()
	return


/obj/structure/prop/almayer/cannon_cable_connector
	name = "\improper 火炮电缆连接器"
	desc = "大型火炮电缆使用的连接器。"
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "cannon_cable_connector"
	density = TRUE
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/prop/almayer/cannon_cable_connector/ex_act()
	return

/obj/structure/prop/almayer/cannon_cable_connector/bullet_act()
	return

/obj/structure/prop/almayer/ai_wallmonitor
	name = "人工智能交互壁挂显示器"
	desc = "嵌入墙壁的显示器，提供多个系统的详细读数。"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "ai_wallmonitor"
	density = FALSE
	pixel_y = 32
	layer = ABOVE_OBJ_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/structure/prop/almayer/ai_wallmonitor/east
	icon_state = "ai_wallmonitor_e"
	pixel_x = 32
	pixel_y = 0

/obj/structure/prop/almayer/ai_wallmonitor/west
	icon_state = "ai_wallmonitor_w"
	pixel_x = -32
	pixel_y = 0




//------- Cryobag Recycler -------//
// Wanted to put this in, but since we still have extra time until tomorrow and this is really simple thing. It just recycles opened cryobags to make it nice-r for medics.
// Also the lack of sleep makes me keep typing cyro instead of cryo. FFS ~Art

/obj/structure/machinery/cryobag_recycler
	name = "休眠袋翻新机"
	desc = "类似小型墓穴的设备，可接收已经使用并打开的休眠袋，更换内衬并安装新的密封件。"
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "recycler"

	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 20

//What is this even doing? Why is it making a new item?
/obj/structure/machinery/cryobag_recycler/attackby(obj/item/W, mob/user) //Hope this works. Don't see why not.
	..()
	if (istype(W, /obj/item))
		if(istype(W, /obj/item/trash/used_stasis_bag)) //possiblity for abuse, but fairly low considering its near impossible to rename something without VV
			var/obj/item/bodybag/cryobag/R = new /obj/item/bodybag/cryobag //lets give them the bag considering having it unfolded would be a pain in the ass.
			R.add_fingerprint(user)
			user.temp_drop_inv_item(W)
			qdel(W)
			user.put_in_hands(R)
			return TRUE
	..()

/obj/structure/closet/basketball
	name = "运动服柜"
	desc = "用于存放运动服的储物柜。"
	icon_state = "purple"
	icon_closed = "purple"
	icon_opened = "purple_open"

/obj/structure/closet/basketball/Initialize()
	. = ..()
	new /obj/item/clothing/under/shorts/grey(src)
	new /obj/item/clothing/under/shorts/black(src)
	new /obj/item/clothing/under/shorts/red(src)
	new /obj/item/clothing/under/shorts/blue(src)
	new /obj/item/clothing/under/shorts/green(src)

/obj/structure/machinery/prop/almayer/overwatch_console
	name = "战术指挥控制台"
	desc = "用于向小队下达命令的先进设备。"
	density = FALSE
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "overwatch"

/obj/structure/machinery/prop/almayer/orbital_cannon_console
	name = "\improper 轨道炮控制台"
	desc = "控制轨道炮装填系统的控制台。"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "ob_console"
	dir = WEST
	flags_atom = ON_BORDER|CONDUCT|FPRINT

/obj/structure/machinery/prop/almayer/CICmap/arc
	name = "地图终端"
	desc = "显示当前行动地点地图的终端。"
	icon = 'icons/obj/vehicles/interiors/arc.dmi'
	icon_state = "arcmap"
	density = FALSE

/obj/structure/machinery/computer/overwatch/almayer/arc
	icon = 'icons/obj/vehicles/interiors/arc.dmi'
	icon_state = "arcconsole"
