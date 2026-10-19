/obj/structure/sign
	icon = 'icons/obj/structures/props/decals.dmi'
	anchored = TRUE
	opacity = FALSE
	density = FALSE
	unslashable = TRUE
	layer = WALL_OBJ_LAYER

/obj/structure/sign/ex_act(severity)
	deconstruct(FALSE)
	return

/obj/structure/sign/attackby(obj/item/tool as obj, mob/user as mob) //deconstruction
	if(HAS_TRAIT(tool, TRAIT_TOOL_SCREWDRIVER) && !istype(src, /obj/structure/sign/double))
		to_chat(user, "你用 [tool] 松开了标牌的固定件。")
		var/obj/item/sign/S = new(src.loc)
		S.name = name
		S.desc = desc
		S.icon_state = icon_state
		S.sign_state = icon_state
		S.icon = icon
		deconstruct(FALSE)
	else ..()

/obj/item/sign
	name = "标牌"
	desc = ""
	icon = 'icons/obj/structures/props/decals.dmi'
	w_class = SIZE_MEDIUM //big
	var/sign_state = ""

/obj/item/sign/attackby(obj/item/tool as obj, mob/user as mob) //construction
	if(HAS_TRAIT(tool, TRAIT_TOOL_SCREWDRIVER) && isturf(user.loc))
		var/direction = tgui_input_list(usr, "朝哪个方向？", "选择方向。", list("North", "East", "South", "West", "Cancel"))
		if(direction == "Cancel") return
		var/obj/structure/sign/S = new(user.loc)
		switch(direction)
			if("North")
				S.pixel_y = 32
			if("East")
				S.pixel_x = 32
			if("South")
				S.pixel_y = -32
			if("West")
				S.pixel_x = -32
			else return
		S.name = name
		S.desc = desc
		S.icon_state = sign_state
		S.icon = icon
		to_chat(user, "你用 [tool] 固定好了 \the [S]。")
		qdel(src)
	else ..()

//=====================//
// Miscellaneous Signs //
//=====================//

/obj/structure/sign/nosmoking_1
	name = "\improper 禁止吸烟"
	desc = "一块写着“禁止吸烟”的警示牌。"
	icon_state = "nosmoking"

/obj/structure/sign/nosmoking_2
	name = "\improper 禁止吸烟"
	desc = "一块写着“禁止吸烟”的警示牌。"
	icon_state = "nosmoking2"

/obj/structure/sign/goldenplaque
	name = "强者之最强健奖"
	desc = "强大并非某个动作或一种生活方式，而是一种精神状态。唯有意志足够坚定，能在危机中挺身而出、从敌人手中救下同伴的人，才称得上真正强大。朋友们，保持强大。"
	icon_state = "goldenplaque"

/obj/structure/sign/kiddieplaque
	name = "人工智能开发者铭牌"
	desc = "长长的姓名与职务名单旁画着一个小孩。有人在画像下刻下了\"PACKETS\"。"
	icon_state = "kiddieplaque"

/obj/structure/sign/arcturianstopsign
	name = "\improper 大角星人停车标志"
	desc = "这是第一排的几个布拉沃队员在上次上岸休假时，从大角星偷回来的停车标志。"
	icon_state = "arcturian_stop_sign"

/obj/structure/sign/double/maltesefalcon //The sign is 64x32, so it needs two tiles. ;3
	name = "马耳他之鹰"
	desc = "马耳他之鹰太空酒吧餐厅。"

/obj/structure/sign/double/maltesefalcon/left
	icon_state = "maltesefalcon-left"

/obj/structure/sign/double/maltesefalcon/right
	icon_state = "maltesefalcon-right"

//============//
//  Banners  //
//==========//

/obj/structure/sign/banners
	icon = 'icons/obj/structures/props/banners.dmi'

/obj/structure/sign/banners/happybirthdaysteve
	name = "\improper “史蒂夫生日快乐”横幅"
	desc = "一条看起来很寒酸的纸横幅，祝某个叫史蒂夫的人“生 快乐”，连“日”字都漏了。"
	icon_state = "birthdaysteve"

/obj/structure/sign/banners/maximumeffort
	name = "\improper “全力以赴”横幅"
	desc = "这条横幅上写着德尔塔小队的格言。前些日子的小队电影之夜放了一部老轰炸机电影，此后陆战队员们便采用了这句格言。"
	icon_state = "maximumeffort"

/obj/structure/sign/banners/united_americas_flag
	name = "\improper 美洲联盟旗帜"
	desc = "一面美洲联盟旗帜。根据观看者的政治立场，可能激起爱国热情、恐惧或厌恶。"
	icon_state = "uaflag"
/obj/structure/sign/banners/united_americas_worn
	name = "\improper 美洲联盟旗帜"
	desc = "一面严重磨损的美洲联盟旗帜。根据观看者的政治立场，可能激起爱国热情、恐惧或厌恶。"
	icon_state = "uaflag_worn"
//============//
//  Flags    //
//==========//

/obj/structure/sign/flag
	icon = 'icons/obj/structures/props/flags.dmi'

/obj/structure/sign/flag/upp
	name = "\improper 进步人民联盟旗帜"
	desc = "以力量求团结，以团结求自由"
	icon_state = "upp_flag"

/obj/structure/sign/banners/colonial_marines_flag
	name = "\improper 美国殖民地陆战队旗帜"
	desc = "美国殖民地陆战队旗帜。根据观者的政治倾向，可能激起爱国心、恐惧或厌恶。"
	icon_state = "cmflag"
/obj/structure/sign/banners/colonial_marines_flag_worn
	name = "\improper 破旧的美国殖民地陆战队旗帜"
	desc = "非常破旧的美国殖民地陆战队旗帜。根据观者的政治倾向，可能激起爱国心、恐惧或厌恶。"
	icon_state = "cmflag_worn"
/obj/structure/sign/banners/twe_flag
	name = "\improper 三世界帝国旗帜"
	desc = "三世界帝国旗帜。根据观者的政治倾向，可能激起爱国心、恐惧或厌恶。"
	icon_state = "tweflag"
/obj/structure/sign/banners/twe_worn
	name = "\improper 破旧的三世界帝国旗帜"
	desc = "非常破旧的三世界帝国旗帜。根据观者的政治倾向，可能激起爱国心、恐惧或厌恶。"
	icon_state = "tweflag_worn"
/obj/structure/sign/banners/upp_flag
	name = "\improper 进步人民联盟旗帜"
	desc = "进步人民联盟旗帜。根据观者的政治倾向，可能激起爱国心、恐惧或厌恶。"
	icon_state = "uppflag"
/obj/structure/sign/banners/upp_worn
	name = "\improper 破旧的进步人民联盟旗帜"
	desc = "非常破旧的进步人民联盟旗帜。根据观者的政治倾向，可能激起爱国心、恐惧或厌恶。"
	icon_state = "uppflag_worn"
/obj/structure/sign/banners/usa_flag
	name = "\improper 破旧的美国旗帜"
	desc = "美国旗帜。根据观者的政治倾向，可能激起爱国心、恐惧或厌恶。"
	icon_state = "usaflag"
/obj/structure/sign/banners/usa_worn
	name = "\improper 破旧的美国旗帜"
	desc = "非常破旧的美国旗帜。根据观者的政治倾向，可能激起爱国心、恐惧或厌恶。"
	icon_state = "usaflag_worn"
/obj/structure/sign/banners/brazil_flag
	name = "\improper 巴西旗帜"
	desc = "巴西旗帜。可能激起爱国心或恐惧，但不会让人厌恶，人人都喜欢巴西。"
	icon_state = "brazilflag"
/obj/structure/sign/banners/brazil_worn
	name = "\improper 破旧的巴西旗帜"
	desc = "巴西旗帜。可能激起爱国心或恐惧，但不会让人厌恶，人人都喜欢巴西。"
	icon_state = "brazilflag_worn"
//=====================//
// SEMIOTIC STANDARD  //
//===================//

/obj/structure/sign/safety
	name = "标牌"
	icon = 'icons/obj/structures/props/semiotic_standard.dmi'
	desc = "标示标准符号的标牌。星际商业委员会要求几乎所有地方都张贴这些标志，以保障你的安全。"
	anchored = TRUE
	opacity = FALSE
	density = FALSE

/obj/structure/sign/safety/airlock
	name = "气闸标志"
	desc = "标准符号，表示附近有气闸。"
	icon_state = "airlock"

/obj/structure/sign/safety/ammunition
	name = "弹药库标志"
	desc = "标准符号，表示附近有弹药库。"
	icon_state = "ammo"

/obj/structure/sign/safety/analysis_lab
	name = "分析实验室标志"
	desc = "标准符号，表示附近有分析实验室。"
	icon_state = "analysislab"

/obj/structure/sign/safety/autodoc
	name = "自动医疗舱标志"
	desc = "标准符号，表示附近有自动医疗舱。"
	icon_state = "autodoc"

/obj/structure/sign/safety/autoopenclose
	name = "自动启闭阀标志"
	desc = "标准符号，表示附近有自动切断阀。"
	icon_state = "autoopenclose"

/obj/structure/sign/safety/bathmens
	name = "男卫生间标志"
	desc = "标准符号，表示附近有男卫生间。"
	icon_state = "bathmens"

/obj/structure/sign/safety/bathunisex
	name = "通用卫生间标志"
	desc = "标准符号，表示附近有通用卫生间。"
	icon_state = "bathunisex"

/obj/structure/sign/safety/bathwomens
	name = "女卫生间标志"
	desc = "标准符号，表示附近有女卫生间。"
	icon_state = "bathwomens"

/obj/structure/sign/safety/biohazard
	name = "生物危害标志"
	desc = "标准符号，表示附近有生物危害。"
	icon_state = "biohazard"

/obj/structure/sign/safety/biolab
	name = "生物实验室标志"
	desc = "标准符号，表示附近有生物实验室。"
	icon_state = "biolab"

/obj/structure/sign/safety/bridge
	name = "舰桥标志"
	desc = "标准符号，表示附近有舰桥。"
	icon_state = "bridge"

/obj/structure/sign/safety/bulkhead_door
	name = "舱壁门标志"
	desc = "标准符号，表示附近有舱壁门。"
	icon_state = "bulkheaddoor"

/obj/structure/sign/safety/chem_lab
	name = "化学实验室标志"
	desc = "标准符号，表示附近有化学实验室。"
	icon_state = "chemlab"

/obj/structure/sign/safety/coffee
	name = "咖啡标志"
	desc = "标准符号，表示附近有咖啡——任何星舰船员的命脉。"
	icon_state = "coffee"

/obj/structure/sign/safety/commline_connection
	name = "通信线路连接点标志"
	desc = "标准符号，表示附近有通信线路连接点。"
	icon_state = "commlineconnection"

/obj/structure/sign/safety/conference_room
	name = "会议室标志"
	desc = "标准符号，表示附近有会议室。"
	icon_state = "confroom"

/obj/structure/sign/safety/cryo
	name = "冷冻休眠库标志"
	desc = "标准符号，表示附近有冷冻休眠库。"
	icon_state = "cryo"

/obj/structure/sign/safety/debark_lounge
	name = "离舰休息厅标志"
	desc = "标准符号，表示附近有离舰休息厅。"
	icon_state = "debarkationlounge"

/obj/structure/sign/safety/distribution_pipes
	name = "分配管线标志"
	desc = "标准符号，表示附近有分配管线。"
	icon_state = "distpipe"

/obj/structure/sign/safety/east
	name = "\improper 东向标志"
	desc = "标准符号，表示目标位于东侧。"
	icon_state = "east"

/obj/structure/sign/safety/electronics
	name = "星舰电气系统标志"
	desc = "标准符号，表示附近有星舰电气系统，只是把电气系统说得高级了些。"
	icon_state = "astronics"

/obj/structure/sign/safety/elevator
	name = "电梯标志"
	desc = "标准符号，表示附近有电梯。"
	icon_state = "elevator"

/obj/structure/sign/safety/escapepod
	name = "逃生舱标志"
	desc = "标准符号，表示附近有逃生舱。"
	icon_state = "escapepod"

/obj/structure/sign/safety/exhaust
	name = "排气口标志"
	desc = "标准符号，表示附近有引擎或发电机排气口。"
	icon_state = "exhaust"

/obj/structure/sign/safety/fire_haz
	name = "火灾危险标志"
	desc = "标准符号，表示附近有火灾危险。"
	icon_state = "firehaz"

/obj/structure/sign/safety/firingrange
	name = "实弹射击场标志"
	desc = "标准符号，表示附近有实弹射击场。"
	icon_state = "firingrange"

/obj/structure/sign/safety/food_storage
	name = "常温食品库标志"
	desc = "标准符号，表示附近有未冷藏食品储存区。"
	icon_state = "foodstorage"

/obj/structure/sign/safety/galley
	name = "厨房标志"
	desc = "标准符号，表示附近有厨房。"
	icon_state = "galley"

/obj/structure/sign/safety/hazard
	name = "危险标志"
	desc = "标准符号，表示附近有危险。小心！"
	icon_state = "hazard"

/obj/structure/sign/safety/high_rad
	name = "高放射性区域标志"
	desc = "标准符号，表示附近有高放射性区域。"
	icon_state = "highrad"

/obj/structure/sign/safety/high_voltage
	name = "高压电标志"
	desc = "标准符号，表示附近有高压电流。"
	icon_state = "highvoltage"

/obj/structure/sign/safety/hvac
	name = "\improper 暖通空调标志"
	desc = "标准符号，表示附近有……暖通空调系统。这块牌子一定已更新为新标准。"
	icon_state = "hvac"

/obj/structure/sign/safety/hvac_old
	name = "\improper 暖通空调标志"
	desc = "标准符号，表示附近有暖通空调系统。这块牌子仍采用旧标准。"
	icon_state = "hvacold"

/obj/structure/sign/safety/intercom
	name = "对讲机标志"
	desc = "标准符号，表示附近有对讲机。"
	icon_state = "comm"

/obj/structure/sign/safety/ladder
	name = "梯子标志"
	desc = "标准符号，表示附近有梯子。"
	icon_state = "ladder"

/obj/structure/sign/safety/laser
	name = "激光标志"
	desc = "标准符号，表示附近有激光。通常没听起来那么酷。"
	icon_state = "laser"

/obj/structure/sign/safety/life_support
	name = "生命维持系统标志"
	desc = "标准符号，表示附近有生命维持系统。"
	icon_state = "lifesupport"

/obj/structure/sign/safety/maint
	name = "维护通道标志"
	desc = "标准符号，表示附近有维护通道。"
	icon_state = "maint"

/obj/structure/sign/safety/manualopenclose
	name = "手动启闭阀标志"
	desc = "标准符号，表示附近有手动启闭阀。"
	icon_state = "manualopenclose"

/obj/structure/sign/safety/med_cryo
	name = "医用低温静滞舱标志"
	desc = "标准符号，表示附近有医用低温静滞舱。"
	icon_state = "medcryo"

/obj/structure/sign/safety/med_life_support
	name = "医疗生命维持系统标志"
	desc = "标准符号，表示附近有医疗区生命维持系统。"
	icon_state = "medlifesupport"

/obj/structure/sign/safety/medical
	name = "医疗区标志"
	desc = "标准符号，表示附近有医疗区。"
	icon_state = "medical"

/obj/structure/sign/safety/nonpress
	name = "前方无压区域标志"
	desc = "标准符号，表示前方区域未加压。"
	icon_state = "nonpressarea"

/obj/structure/sign/safety/nonpress_ag
	name = "有人工重力的无压区域，需穿压力服标志"
	desc = "标准符号，表示附近区域有人工重力，但未加压。"
	icon_state = "nonpressag"

/obj/structure/sign/safety/nonpress_0g
	name = "无重力无压区域，需穿压力服标志"
	desc = "标准符号，表示前方区域未加压，且无人工重力。"
	icon_state = "nonpresszerog"

/obj/structure/sign/safety/north
	name = "\improper 北向标志"
	desc = "标准符号，表示目标位于北侧。"
	icon_state = "north"

/obj/structure/sign/safety/opens_up
	name = "向上开启标志"
	desc = "标准符号，表示附近的门向上开启。"
	icon_state = "opensup"

/obj/structure/sign/safety/outpatient
	name = "门诊标志"
	desc = "标准符号，表示附近有门诊。"
	icon_state = "outpatient"

/obj/structure/sign/safety/fibre_optics
	name = "光子系统（光纤）标志"
	desc = "标准符号，表示附近有光纤线路。"
	icon_state = "fibreoptic"

/obj/structure/sign/safety/press_area_ag
	name = "有人工重力的加压区域标志"
	desc = "标准符号，表示附近有加压但无人工重力的区域。"
	icon_state = "pressareaag"

/obj/structure/sign/safety/press_area
	name = "加压区域标志"
	desc = "标准符号，表示附近有加压区域。"
	icon_state = "pressarea"

/obj/structure/sign/safety/rad_haz
	name = "辐射危险标志"
	desc = "标准符号，表示附近有辐射危险。"
	icon_state = "radhaz"

/obj/structure/sign/safety/rad_shield
	name = "辐射屏蔽区域标志"
	desc = "标准符号，表示附近有辐射屏蔽区域。"
	icon_state = "radshield"

/obj/structure/sign/safety/radio_rad
	name = "无线电辐射标志"
	desc = "标准符号，表示附近有无线电塔产生的辐射。"
	icon_state = "radiorad"

/obj/structure/sign/safety/reception
	name = "接待区标志"
	desc = "标准符号，表示附近有接待区。"
	icon_state = "reception"

/obj/structure/sign/safety/reduction
	name = "区域收窄标志"
	desc = "标准符号，表示前方空间收窄。"
	icon_state = "reduction"

/obj/structure/sign/safety/ref_bio_storage
	name = "冷藏生物材料库标志"
	desc = "标准符号，表示附近有冷藏生物材料库。"
	icon_state = "refbiostorage"

/obj/structure/sign/safety/ref_chem_storage
	name = "冷藏化学品库标志"
	desc = "标准符号，表示附近有冷藏化学品库。"
	icon_state = "refchemstorage"

/obj/structure/sign/safety/restrictedarea
	name = "限制区域标志"
	desc = "标准符号，表示附近有限制区域。"
	icon_state = "restrictedarea"

/obj/structure/sign/safety/fridge
	name = "冷藏食品库标志"
	desc = "标准符号，表示附近有冰箱。"
	icon_state = "fridge"

/obj/structure/sign/safety/refridgeration
	name = "制冷标志"
	desc = "标准符号，表示附近有非食品制冷设施。"
	icon_state = "refridgeration"

/obj/structure/sign/safety/rewire
	name = "重接线系统标志"
	desc = "标准符号，表示附近有重接线系统。"
	icon_state = "rewire"

/obj/structure/sign/safety/security
	name = "安保标志"
	desc = "标准符号，表示附近有执法或安保部队。"
	icon_state = "security"

/obj/structure/sign/safety/south
	name = "\improper 南向标志"
	desc = "标准符号，表示目标位于南侧。"
	icon_state = "south"

/obj/structure/sign/safety/stairs
	name = "楼梯标志"
	desc = "标准符号，表示附近有楼梯。"
	icon_state = "stairs"

/obj/structure/sign/safety/storage
	name = "储物间标志"
	desc = "标准符号，表示附近有普通干货储藏室。"
	icon_state = "storage"

/obj/structure/sign/safety/suit_storage
	name = "压力服柜标志"
	desc = "标准符号，表示附近有压力服柜。"
	icon_state = "suitstorage"

/obj/structure/sign/safety/synth_storage
	name = "合成人储藏室标志"
	desc = "标准符号，表示附近有合成人储藏室。"
	icon_state = "synthstorage"

/obj/structure/sign/safety/terminal
	name = "计算机终端标志"
	desc = "标准符号，表示附近有计算机终端。"
	icon_state = "terminal"

/obj/structure/sign/safety/tram
	name = "有轨电车线路标志"
	desc = "标准符号，表示附近有有轨电车线路。"
	icon_state = "tramline"

/obj/structure/sign/safety/twilight_zone_terminator
	name = "晨昏分界线标志"
	desc = "标准符号，表示附近有晨昏分界线，远没听起来那么酷。"
	icon_state = "twilightzoneterminator"

/obj/structure/sign/safety/water
	name = "水标志"
	desc = "标准符号，表示附近有水。"
	icon_state = "water"

/obj/structure/sign/safety/waterhazard
	name = "涉水危险标志"
	desc = "标准符号，表示有涉水危险，请让电子设备远离。"
	icon_state = "waterhaz"

/obj/structure/sign/safety/west
	name = "\improper 西向标志"
	desc = "标准符号，表示目标位于西侧。"
	icon_state = "west"

/obj/structure/sign/safety/zero_g
	name = "无人工重力标志"
	desc = "标准符号，表示附近缺乏人工重力。"
	icon_state = "zerog"

/obj/structure/sign/safety/flightcontrol
	name = "\improper 飞行控制标志"
	desc = "标准符号，表示用于飞行控制系统的区域。"
	icon_state = "flightcontrol"

/obj/structure/sign/safety/airtraffictower
	name = "\improper 空管塔台标志"
	desc = "标准符号，表示附近有空管塔台。"
	icon_state = "airtraffictower"

/obj/structure/sign/safety/luggageclaim
	name = "\improper 行李提取区标志"
	desc = "标准符号，表示附近有行李提取区。"
	icon_state = "luggageclaim"

/obj/structure/sign/safety/landingzone
	name = "\improper 着陆区标志"
	desc = "标准符号，表示附近有着陆区。"
	icon_state = "landingzone"

/obj/structure/sign/safety/zero
	name = "数字 0 标志"
	desc = "表示数字 0 的标准符号。"
	icon_state = "0"

/obj/structure/sign/safety/one
	name = "数字 1 标志"
	desc = "表示数字 1 的标准符号。"
	icon_state = "1"

/obj/structure/sign/safety/two
	name = "数字 2 标志"
	desc = "表示数字 2 的标准符号。"
	icon_state = "2"

/obj/structure/sign/safety/three
	name = "数字 3 标志"
	desc = "表示数字 3 的标准符号。"
	icon_state = "3"

/obj/structure/sign/safety/four
	name = "数字 4 标志"
	desc = "表示数字 4 的标准符号。"
	icon_state = "4"

/obj/structure/sign/safety/five
	name = "数字 5 标志"
	desc = "表示数字 5 的标准符号。"
	icon_state = "5"

/obj/structure/sign/safety/six
	name = "数字 6 标志"
	desc = "表示数字 6 的标准符号。"
	icon_state = "6"

/obj/structure/sign/safety/seven
	name = "数字 7 标志"
	desc = "表示数字 7 的标准符号。"
	icon_state = "7"

/obj/structure/sign/safety/eight
	name = "数字 8 标志"
	desc = "表示数字 8 的标准符号。"
	icon_state = "8"

/obj/structure/sign/safety/nine
	name = "数字 9 标志"
	desc = "表示数字 9 的标准符号。"
	icon_state = "9"

//===================//
//   Marine signs   //
//=================//

/obj/structure/sign/ROsign
	name = "\improper 美国殖民地陆战队军需处守则"
	desc = "1. 服务与装备并非你理所当然享有的权利，配件是待遇，不是权利。\n2. 必须穿戴整齐才可接受服务，不得只穿冷冻休眠内衣。\n3. 军需官拥有最终决定权，可拒绝服务。只有代理舰长能推翻其决定。\n4. 请尊重军需人员，他们工作很辛苦。"
	icon_state = "roplaque"

/obj/structure/sign/ROcreed
	name = "\improper 军需兵团信条铭牌"
	desc = "美国军需兵团制定的军需信条简版。这是纯装饰与礼仪用途的缩略版本，篇幅更短，也不含较新的修订内容。"
	desc_lore = {"我是军需官
		我的故事，深藏于这个国家的历史。
		军队的供养者……

		我的熔炉曾在福吉谷燃烧。
		我的牛车沿冰封而车辙纵横的道路，
		运送破产国会拨给我的微薄粮食……
		为饥寒交迫的士兵送去稀少口粮，
		还有火药、盐与铅。

		1812 年，我们乘着我的船匠造出的船赴战。
		在广袤西南的沙漠里，我与你并肩作战。
		我的骡队在寻找水源时倒下，
		我便牵着骆驼继续前行。
		我授予旗帜，供人效忠。
		你佩戴的勋章与徽记，出自我的设计。

		自 1862 年起，我一直寻回阵亡的兄弟，
		从列兵到总统。
		无论战争还是和平，我都带他们回家，
		将他们轻轻安放在荣誉之地。

		我是补给者，也是运输者。
		1898 年，我带你们前往哈瓦那港与菲律宾。
		我送来帐篷，送来缝制制服的卡其布。
		黄热病来袭时，我送来了你躺着的床垫。

		1917 年，我们横渡海洋，在法国的战壕与田野奋战，
		以新的武器、训练、技术与战术投入大战。
		但粮食、水与弹药始终不可或缺，如今又多了燃料。

		我们一同在珍珠港和科雷希多初次流血。
		随后踏上漫长的胜利征程——瓜达尔卡纳尔与北非，西西里与所罗门群岛。
		登陆日，我与你同在奥马哈海滩；前一夜，我就已乘滑翔机与降落伞抵达。
		遍历欧洲与太平洋，我驾驶、挖掘、战斗，直到任务完成。

		1950 年，战争降临半岛，我的降落伞铺满朝鲜灰色天空。
		从釜山防线到长津湖冰冷道路，我始终在那里。
		1965 年，我在南越各处建立火力基地与补给站，
		休伊与奇努克将我的补给送往前线。

		我是军需官。
		我能塑造战斗的进程，
		改变战役的结局。
		Look to me: 军队的供养者……Since 1775.

		我是军需官。我为此自豪。"}
	icon_state = "rocreed"

/obj/structure/sign/prop1
	name = "\improper 美国殖民地陆战队海报"
	desc = "美国殖民地陆战队的标志。"
	icon_state = "prop1"

/obj/structure/sign/prop2
	name = "\improper 美国殖民地陆战队海报"
	desc = "一群穿着制服、英姿飒爽的殖民地陆战队员的褪色海报，大概拍摄于 Alpha 测试之前。"
	icon_state = "prop2"

/obj/structure/sign/prop3
	name = "\improper 美国殖民地陆战队海报"
	desc = "美国殖民地陆战队的旧招募海报。看着它，自豪与真切的懊悔一同涌上心头。"
	icon_state = "prop3"


/obj/structure/sign/catclock
	name = "猫咪时钟"
	desc = "诡异得难以置信的猫咪时钟，随着每一声滴答打量整个房间。"
	icon = 'icons/obj/structures/props/catclock.dmi'
	icon_state = "cat_clock_motion"
