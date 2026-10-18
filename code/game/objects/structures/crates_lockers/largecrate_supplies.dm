/*SPAWNING LANDMARKS*/
//Check below to see what the crates contain, these landmarks will spawn in a bunch of crates at once, to make it easy to spawn in supplies.
/obj/effect/landmark/supplyspawner
	name = "supply spawner"
	var/list/supply = list()

/obj/effect/landmark/supplyspawner/New()
	..()
	if(/turf/open in range(1))
		var/list/T = list()
		for(var/turf/open/O in range(1))
			T += O
		if(length(supply))
			for(var/s in supply)
				var/amount = supply[s]
				for(var/i = 1, i <= amount, i++)
					new s (pick(T))
		sleep(-1)
	qdel(src)


/obj/effect/landmark/supplyspawner/weapons
	name = "weapon supplies"
	supply = list(
		/obj/structure/largecrate/supply/weapons/m41a = 2,
		/obj/structure/largecrate/supply/weapons/shotgun = 2,
		/obj/structure/largecrate/supply/weapons/m39 = 2,
		/obj/structure/largecrate/supply/weapons/pistols = 2,
		/obj/structure/largecrate/supply/weapons/flamers = 2,
		/obj/structure/largecrate/supply/weapons/hpr = 2,
		/obj/structure/closet/crate/secure/mortar_ammo/mortar_kit = 1,
		/obj/structure/largecrate/supply/explosives/mines = 2,
		/obj/structure/largecrate/supply/explosives/grenades = 2,
	)

/obj/effect/landmark/supplyspawner/ammo
	name = "ammunition supplies"
	supply = list(
		/obj/structure/largecrate/supply/ammo/m41a = 4,
		/obj/structure/largecrate/supply/ammo/m41a_box = 4,
		/obj/structure/largecrate/supply/ammo/shotgun = 4,
		/obj/structure/largecrate/supply/ammo/m39 = 4,
		/obj/structure/largecrate/supply/ammo/pistol = 4,
	)

/obj/effect/landmark/supplyspawner/engineering
	name = "engineering supplies"
	supply = list(
		/obj/structure/largecrate/supply/supplies/metal = 5,
		/obj/structure/largecrate/supply/supplies/plasteel = 3,
		/obj/structure/largecrate/supply/supplies/sandbags = 5,
		/obj/structure/largecrate/supply/generator = 1,
		/obj/structure/largecrate/supply/floodlights = 2,
		/obj/structure/largecrate/supply/supplies/flares = 3,
		/obj/structure/largecrate/supply/powerloader = 1,
		/obj/structure/largecrate/machine/recycler = 2,
	)

/obj/effect/landmark/supplyspawner/turrets
	name = "defensive gun emplacement supplies"
	supply = list(
		/obj/structure/largecrate/supply/weapons/m56d = 2,
		/obj/structure/largecrate/supply/ammo/sentry = 1,
		/obj/structure/largecrate/supply/ammo/m56d = 1,
	)

/obj/effect/landmark/supplyspawner/food
	name = "food crate supplies"
	supply = list(/obj/structure/largecrate/supply/supplies/mre = 3, /obj/structure/largecrate/supply/supplies/water = 2)

/obj/effect/landmark/supplyspawner/medical
	name = "medical supplies"
	supply = list(
		/obj/structure/largecrate/supply/medicine/medkits = 2,
		/obj/structure/largecrate/supply/medicine/blood = 2,
		/obj/structure/largecrate/supply/medicine/iv = 2,
		/obj/structure/largecrate/supply/medicine/medivend = 2,
		/obj/structure/largecrate/machine/autodoc = 3,
		/obj/structure/largecrate/machine/bodyscanner = 1,
		/obj/structure/largecrate/machine/sleeper = 2,
		/obj/structure/largecrate/supply/medicine/optable = 1,
		/obj/structure/largecrate/supply/supplies/tables_racks = 1,
	)
/*NEW SUPPLY CRATES*/
//Lotsocrates for lotsosupplies for events, meaning less setup time.
//Wooden crates and not metal ones so we don't have a ton of metal crates laying around
//SHOULD contain everything needed for events. Should.

/obj/structure/largecrate/supply
	name = "补给箱"
	fill_from_loc = FALSE
	var/list/supplies = list()

/obj/structure/largecrate/supply/Initialize()
	. = ..()
	if(length(supplies))
		for(var/s in supplies)
			var/amount = supplies[s]
			for(var/i = 1, i <= amount, i++)
				new s (src)

/obj/structure/largecrate/supply/weapons
	name = "武器箱"
	icon_state = "chest"
	parts_type = /obj/item/stack/sheet/metal
	unpacking_sound = 'sound/effects/metalhit.ogg'

/obj/structure/largecrate/supply/weapons/m41a
	name = "\improper M41A脉冲步枪武器箱（10支）"
	desc = "一只武器箱，内装十支M41A步枪。"
	supplies = list(/obj/item/weapon/gun/rifle/m41a = 10)

/obj/structure/largecrate/supply/weapons/shotgun
	name = "\improper M37A2泵动霰弹枪武器箱（10支）"
	desc = "一只武器箱，内装十支M37A2泵动霰弹枪。"
	supplies = list(/obj/item/weapon/gun/shotgun/pump = 10)

/obj/structure/largecrate/supply/weapons/m39
	name = "\improper M39冲锋枪武器箱（8支）"
	desc = "一只武器箱，内装八支M39冲锋枪。"
	supplies = list(/obj/item/weapon/gun/smg/m39 = 8)

/obj/structure/largecrate/supply/weapons/pistols
	name = "副武器箱（20把）"
	desc = "一只武器箱，内装八把M44左轮手枪和十二把M4A3制式手枪。"
	supplies = list(/obj/item/weapon/gun/revolver/m44 = 6, /obj/item/weapon/gun/pistol/m4a3 = 12)

/obj/structure/largecrate/supply/weapons/flamers
	name = "\improper M240A1焚烧器武器箱（4具）"
	desc = "一只武器箱，内装四具M240A1焚烧器。"
	supplies = list(/obj/item/weapon/gun/flamer = 4)

/obj/structure/largecrate/supply/weapons/hpr
	name = "\improper M41AE2重型脉冲步枪武器箱（2支）"
	desc = "一只武器箱，内装两支M41AE2重型脉冲步枪。"
	supplies = list(/obj/item/weapon/gun/rifle/lmg = 2)

/obj/structure/largecrate/supply/weapons/m56d
	name = "\improper M56D架设式智能机枪箱（2套）"
	desc = "一只补给箱，内装两套盒装M56D架设式智能机枪。"
	supplies = list(/obj/item/storage/box/m56d_hmg = 2)



/obj/structure/largecrate/supply/ammo
	name = "弹药箱"
	icon_state = "case"

/obj/structure/largecrate/supply/ammo/m41a
	name = "\improper M41A弹匣箱（20个）"
	desc = "一只弹药箱，内装20个M41A弹匣。"
	supplies = list(/obj/item/ammo_magazine/rifle = 20)

/obj/structure/largecrate/supply/ammo/m41a/half
	name = "\improper M41A弹匣箱（10个）"
	desc = "一只弹药箱，内装10个M41A弹匣。"
	supplies = list(/obj/item/ammo_magazine/rifle = 10)

/obj/structure/largecrate/supply/ammo/m41a/extended
	name = "\improper M41A加长弹匣箱（20个）"
	desc = "一只弹药箱，内装20个M41A加长弹匣。"
	supplies = list(/obj/item/ammo_magazine/rifle/extended = 20)


/obj/structure/largecrate/supply/ammo/m41amk1
	name = "\improper M41A弹匣箱（20个）"
	desc = "一只弹药箱，内装20个M41A MK1弹匣。"
	supplies = list(/obj/item/ammo_magazine/rifle/m41aMK1 = 20)

/obj/structure/largecrate/supply/ammo/m41amk1/forecon
	supplies = list(/obj/item/ammo_magazine/rifle/m41aMK1/recon = 20)

/obj/structure/largecrate/supply/ammo/m41a_box
	name = "\improper M41A弹药盒箱（4盒）"
	desc = "一只弹药箱，内装4盒600发装M41A弹药。"
	supplies = list(/obj/item/ammo_box/rounds = 4)

/obj/structure/largecrate/supply/ammo/shotgun
	name = "12号口径霰弹弹药箱（20盒）"
	desc = "一只弹药箱，内装8盒独头弹、8盒鹿弹和4盒箭形弹。"
	supplies = list(/obj/item/ammo_magazine/shotgun/slugs = 8, /obj/item/ammo_magazine/shotgun/buckshot = 8, /obj/item/ammo_magazine/shotgun/flechette = 4)

/obj/structure/largecrate/supply/ammo/m39
	name = "\improper M39高速弹匣箱（16个）"
	desc = "一只弹药箱，内装16个M39高速弹匣。"
	supplies = list(/obj/item/ammo_magazine/smg/m39 = 16)

/obj/structure/largecrate/supply/ammo/m39/half
	name = "\improper M39高速弹匣箱（8个）"
	desc = "一只弹药箱，内装8个M39高速弹匣。"
	supplies = list(/obj/item/ammo_magazine/smg/m39 = 8)

/obj/structure/largecrate/supply/ammo/pistol
	name = "副武器弹药箱（40个）"
	desc = "一只弹药箱，内装16个M44快速装弹器和24个M4A3弹匣。"
	supplies = list(/obj/item/ammo_magazine/revolver = 16, /obj/item/ammo_magazine/pistol = 24)

/obj/structure/largecrate/supply/ammo/pistol/half
	name = "副武器弹药箱（20个）"
	desc = "一只弹药箱，内装8个M44快速装弹器和12个M4A3弹匣。"
	supplies = list(/obj/item/ammo_magazine/revolver = 8, /obj/item/ammo_magazine/pistol = 12)

/obj/structure/largecrate/supply/ammo/sentry
	name = "\improper UA 571-C弹鼓箱（6个）"
	desc = "一只弹药箱，内装6个UA 571-C哨戒炮弹鼓。"
	supplies = list(/obj/item/ammo_magazine/sentry = 6)

/obj/structure/largecrate/supply/ammo/m56d
	name = "\improper M56D弹鼓箱（6个）"
	desc = "一只弹药箱，内装6个M56D弹鼓。"
	supplies = list(/obj/item/ammo_magazine/m56d = 6)

/obj/structure/largecrate/supply/ammo/type71
	name = "\improper 71式弹匣箱（20个）"
	desc = "一只弹药箱，内装20个71式弹匣。"
	supplies = list(/obj/item/ammo_magazine/rifle/type71 = 20)

/obj/structure/largecrate/supply/ammo/nsg23
	name = "\improper NSG L23A1弹匣箱（20个）"
	desc = "一只弹药箱，内装20个NSG L23A1弹匣。"
	supplies = list(/obj/item/ammo_magazine/rifle/nsg23 = 20)

/obj/structure/largecrate/supply/ammo/supply_drop
	icon_state = "secure_crate_strapped"
	desc = "一只弹药箱，装有你需要的全部物品。"
	supplies = list(
		/obj/item/ammo_box/magazine/mk1/large = 1,
		/obj/item/ammo_box/rounds/smartgun = 2,
		/obj/item/ammo_box/magazine/shotgun/buckshot = 2,
		/obj/item/ammo_box/magazine/shotgun = 2,
		/obj/item/storage/box/guncase/heavy/fuel = 1,
		/obj/item/ammo_magazine/sentry = 2,
		/obj/item/ammo_box/magazine/m49a/a19/pve = 1,
	)

/obj/structure/largecrate/supply/ammo/supply_drop_upp
	icon_state = "secure_crate_strapped"
	desc = "一只弹药箱，装有你需要的全部物品。"
	supplies = list(
		/obj/item/ammo_box/magazine/type71/large = 1,
		/obj/item/ammo_box/rounds/pkp = 2,
		/obj/item/ammo_magazine/shotgun/buckshot/heavy = 2,
		/obj/item/ammo_magazine/shotgun/slug/heavy = 2,
		/obj/item/storage/box/guncase/heavy/uppfuel = 1,
		/obj/item/ammo_magazine/sentry/upp = 2,
	)

/obj/structure/largecrate/supply/explosives
	name = "爆炸物补给箱"
	desc = "一只装有爆炸物的箱子。"
	icon_state = "case_double"

/obj/structure/largecrate/supply/explosives/mines
	name = "\improper M20A2阔剑地雷箱（25枚）"
	desc = "箱内装有5盒M20A2阔剑地雷，每盒5枚。"
	supplies = list(/obj/item/storage/box/explosive_mines = 5)

/obj/structure/largecrate/supply/explosives/grenades
	name = "\improper M40 HEDP手榴弹箱（50枚）"
	desc = "箱内装有2盒M40 HEDP手榴弹，每盒25枚。"
	supplies = list(/obj/item/ammo_box/magazine/nade_box = 2)

/obj/structure/largecrate/supply/explosives/grenades/less
	name = "\improper M40 HEDP手榴弹箱（25枚）"
	desc = "箱内装有1盒M40 HEDP手榴弹，共25枚。"
	icon_state = "case"
	supplies = list(/obj/item/ammo_box/magazine/nade_box = 1)

/obj/structure/largecrate/supply/explosives/mortar_he
	name = "80毫米高爆迫击炮弹箱（25发）"
	desc = "箱内装有25发80毫米高爆迫击炮弹。"
	supplies = list(/obj/item/mortar_shell/he = 25)

/obj/structure/largecrate/supply/explosives/mortar_incend
	name = "80毫米燃烧迫击炮弹箱（25发）"
	desc = "箱内装有25发80毫米燃烧迫击炮弹。"
	supplies = list(/obj/item/mortar_shell/incendiary = 25)

/obj/structure/largecrate/supply/explosives/mortar_flare
	name = "80毫米照明迫击炮弹箱（25发）"
	desc = "箱内装有25发80毫米照明迫击炮弹。"
	supplies = list(/obj/item/mortar_shell/flare = 25)

/obj/structure/largecrate/supply/explosives/mortar_smoke
	name = "80毫米烟幕迫击炮弹箱（25发）"
	desc = "箱内装有25发80毫米烟幕迫击炮弹。"
	supplies = list(/obj/item/mortar_shell/smoke = 25)

/obj/structure/largecrate/supply/explosives/himat
	name = "HIMAT导弹箱（25枚）"
	desc = "箱内装有25枚HIMAT导弹。"
	supplies = list(/obj/item/mortar_shell/himat = 25)

/obj/structure/largecrate/supply/explosives/himat_training
	name = "HIMAT训练导弹箱（25枚）"
	desc = "箱内装有25枚HIMAT训练导弹。"
	supplies = list(/obj/item/mortar_shell/himat/training = 25)

/obj/structure/largecrate/supply/explosives/himat_explosive
	name = "HIMAT高爆导弹箱（25枚）"
	desc = "箱内装有25枚HIMAT高爆导弹。"
	supplies = list(/obj/item/mortar_shell/himat/explosive = 25)

/obj/structure/largecrate/supply/explosives/himat_antipersonnel
	name = "HIMAT反人员导弹箱（25枚）"
	desc = "箱内装有25枚HIMAT反人员导弹。"
	supplies = list(/obj/item/mortar_shell/himat/antipersonnel = 25)

/obj/structure/largecrate/supply/explosives/himat_incendiary
	name = "HIMAT燃烧导弹箱（25枚）"
	desc = "箱内装有25枚HIMAT燃烧导弹。"
	supplies = list(/obj/item/mortar_shell/incendiary/himat = 25)


/obj/structure/largecrate/supply/supplies
	name = "补给箱"
	icon_state = "secure_crate"

/obj/structure/largecrate/supply/supplies/flares
	name = "照明弹补给箱（320枚）"
	desc = "一只补给箱，内装2箱照明弹。"
	supplies = list(/obj/item/ammo_box/magazine/misc/flares = 2)

/obj/structure/largecrate/supply/supplies/metal
	name = "金属板补给箱（200张）"
	desc = "一只补给箱，内装4摞金属板，每摞50张。"
	supplies = list(/obj/item/stack/sheet/metal/large_stack = 4)

/obj/structure/largecrate/supply/supplies/plasteel
	name = "塑钢补给箱（60张）"
	desc = "一只补给箱，内装2摞塑钢板，每摞30张。"
	supplies = list(/obj/item/stack/sheet/plasteel/medium_stack = 2)

/obj/structure/largecrate/supply/supplies/sandbags
	name = "沙袋补给箱（100个）"
	desc = "一只补给箱，内装4堆沙袋，每堆25个。"
	supplies = list(/obj/item/stack/sandbags/large_stack = 4)

/obj/structure/largecrate/supply/supplies/tables_racks
	name = "储物设施箱（桌子与置物架各10套）"
	desc = "一只箱子，内装10套桌子零件和10套置物架零件，方便搭建储物设施。"
	supplies = list(/obj/item/frame/table = 10, /obj/item/frame/rack = 10)

/obj/structure/largecrate/supply/supplies/mre
	name = "\improper USCM即食口粮箱（60包）"
	desc = "一只补给箱，内装60包USCM即食口粮。"
	supplies = list(/obj/item/ammo_box/magazine/misc/mre = 5)

/obj/structure/largecrate/supply/supplies/mre/wy
	name = "\improper 维兰德-汤谷口粮箱（60包）"
	desc = "一只补给箱，内装60包维兰德-汤谷品牌口粮。"
	supplies = list(/obj/item/ammo_box/magazine/misc/mre/wy = 5)

/obj/structure/largecrate/supply/supplies/wy_emergency_food
	name = "\improper 维兰德-汤谷应急营养砖箱（100块）"
	desc = "一只补给箱，内装100块维兰德-汤谷应急营养砖。"
	supplies = list(/obj/item/ammo_box/magazine/misc/mre/emergency = 5)

/obj/structure/largecrate/supply/supplies/water
	name = "\improper 维兰德-汤谷瓶装水箱（50瓶）"
	desc = "箱内装有50瓶维兰德-汤谷瓶装泉水。"
	supplies = list(/obj/item/reagent_container/food/drinks/cans/waterbottle = 50)

/obj/structure/largecrate/supply/powerloader
	name = "\improper 卡特彼勒P-5000动力装载机箱"
	desc = "箱内装有1台已组装完成并折叠收纳的卡特彼勒P-5000动力装载机，以及供快速培训使用的手册。"
	supplies = list(
		/obj/vehicle/powerloader = 1,
		/obj/item/pamphlet/skill/powerloader = 1,
	)

/obj/structure/largecrate/supply/floodlights
	name = "泛光灯箱（4盏）"
	desc = "箱内装有4盏泛光灯。"
	supplies = list(/obj/structure/machinery/floodlight = 4)

/obj/structure/largecrate/supply/generator
	name = "\improper P.A.C.M.A.N.发电机箱"
	desc = "箱内装有1台P.A.C.M.A.N.发电机、一些燃料和线缆，足够开始供电。"
	supplies = list(/obj/structure/machinery/power/port_gen/pacman = 1, /obj/item/stack/sheet/mineral/phoron/medium_stack = 1, /obj/item/stack/cable_coil/yellow = 3)

/obj/structure/largecrate/supply/generator/super
	name = "\improper S.U.P.E.R.P.A.C.M.A.N.发电机箱"
	desc = "箱内装有1台S.U.P.E.R.P.A.C.M.A.N.发电机、一些燃料、一把扳手和线缆，足够开始供电。"
	supplies = list(/obj/structure/machinery/power/port_gen/pacman/super = 1, /obj/item/stack/sheet/mineral/uranium/small_stack = 4, /obj/item/tool/wrench = 1, /obj/item/stack/cable_coil/pink = 3)

/obj/structure/largecrate/supply/motiondetectors
	name = "\improper 运动探测器箱"
	desc = "箱内装有2台运动探测器。"
	icon_state = "case"
	supplies = list(/obj/item/device/motiondetector = 2)


/obj/structure/largecrate/supply/medicine
	name = "医疗箱"
	desc = "箱内装有医疗用品。"
	icon_state = "chest_white"
	parts_type = /obj/item/stack/sheet/metal
	unpacking_sound = 'sound/effects/metalhit.ogg'

/obj/structure/largecrate/supply/medicine/medkits
	name = "急救用品补给箱（20套）"
	desc = "一只医疗补给箱，内装6套高级急救包、3套标准急救包、3套烧伤急救包，以及抗毒、供氧和抗辐射急救包各2套。"
	supplies = list(
		/obj/item/storage/firstaid/regular = 3,
		/obj/item/storage/firstaid/fire = 3,
		/obj/item/storage/firstaid/adv = 6,
		/obj/item/storage/firstaid/toxin = 2,
		/obj/item/storage/firstaid/o2 = 2,
		/obj/item/storage/firstaid/rad = 2,
	)

/obj/structure/largecrate/supply/medicine/blood
	name = "血液补给箱（12袋）"
	desc = "一只医疗补给箱，内装12袋O型阴性血。"
	supplies = list(/obj/item/reagent_container/blood/OMinus = 12)

/obj/structure/largecrate/supply/medicine/iv
	name = "\improper 输液架箱（3个）"
	desc = "一只医疗补给箱，内装3个输液架。"
	supplies = list(/obj/structure/machinery/iv_drip = 3)

/obj/structure/largecrate/supply/medicine/optable
	name = "手术用品箱（1套）"
	desc = "箱内装有一张手术台、两罐麻醉气体、一套手术工具、一些麻醉注射器和太空清洁剂。"
	supplies = list(/obj/structure/machinery/optable = 1, /obj/item/storage/surgical_tray = 1, /obj/item/tank/anesthetic = 2, /obj/item/reagent_container/spray/cleaner = 1)

/obj/structure/largecrate/supply/medicine/medivend
	name = "\improper 维兰医疗加强型售货机箱（1台）"
	desc = "箱内装有1台维兰医疗加强型医疗售货机。"
	supplies = list(/obj/structure/machinery/cm_vending/sorted/medical = 1)


/obj/structure/largecrate/machine
	name = "机器运输箱"
	desc = "箱内装有一台预先组装好的机器。"
	icon_state = "secure_crate_strapped"
	fill_from_loc = FALSE
	var/dir_needed = EAST //If set to anything but 0, will check that space before spawning in.
	var/unmovable = 1 //If set to 1, then on examine, the user will see a warning that states the contents cannot be moved after opened.

/obj/structure/largecrate/machine/get_examine_text(mob/user)
	. = ..()
	if(unmovable)
		. += SPAN_DANGER("！！警告！！箱内物品拆封后将无法移动！")

/obj/structure/largecrate/machine/unpack(forced)
	if(parts_type)
		new parts_type(loc, 2)
	playsound(src, unpacking_sound, 35)
	qdel(src)

/obj/structure/largecrate/machine/attackby(obj/item/W as obj, mob/user as mob)
	if(HAS_TRAIT(W, TRAIT_TOOL_CROWBAR))
		if(turf_blocked_check())
			to_chat(user, SPAN_WARNING("拆开[src]需要留出一片空地[dir_needed ? "，位置在箱子的[localized_player_label(dir2text(dir_needed))]侧" : ""]。"))
			return
		if(localized_native_alert(user, "确定要在这里拆开 \the [src] 吗？", "确认", "Yes", "No") != "Yes")
			return

		user.visible_message(SPAN_NOTICE("[user]撬开了[src]。"), SPAN_NOTICE("你撬开了[src]。"))
		unpack()
	else
		return attack_hand(user)

/obj/structure/largecrate/machine/proc/turf_blocked_check()
	var/turf/T
	var/turf_blocked = FALSE
	if(dir_needed)
		T = get_step(src, dir_needed)
		if(T.density)
			turf_blocked = TRUE
		else
			for(var/atom/movable/AM in T.contents)
				if(AM.density)
					turf_blocked = TRUE
					break
	else
		T = get_turf(loc)
		if(T.density) //I can totally imagine marines getting this crate on dense turf somehow
			turf_blocked = TRUE
		else
			for(var/atom/movable/AM in T.contents)
				if(AM.density)
					turf_blocked = TRUE
					break
	return turf_blocked

/obj/structure/largecrate/machine/recycler
	name = "回收机箱（1台）"
	desc = "箱内装有1台用于处理垃圾的回收机。"
	dir_needed = 0

/obj/structure/largecrate/machine/recycler/unpack()
	var/turf/T = get_turf(loc)
	if(!istype(T, /turf/open))
		return FALSE

	if(parts_type)
		new parts_type(loc, 2)
	playsound(src, unpacking_sound, 35)

	new /obj/structure/machinery/wo_recycler(loc)

	qdel(src)
	return TRUE

/obj/structure/largecrate/machine/autodoc
	name = "自动医生箱（1台）"
	desc = "箱内装有1台自动医生。"

/obj/structure/largecrate/machine/autodoc/unpack()
	var/turf/T = get_turf(loc)
	if(!istype(T, /turf/open))
		return FALSE

	if(parts_type)
		new parts_type(loc, 2)
	playsound(src, unpacking_sound, 35)

	var/obj/structure/machinery/medical_pod/autodoc/unskilled/E = new (T)
	var/obj/structure/machinery/autodoc_console/C = new (get_step(T, dir_needed))
	E.connected = C
	C.connected = E

	qdel(src)
	return TRUE

/obj/structure/largecrate/machine/bodyscanner
	name = "全身扫描仪箱（1台）"
	desc = "箱内装有1台医用全身扫描仪。"

/obj/structure/largecrate/machine/bodyscanner/unpack()
	var/turf/T = get_turf(loc)
	if(!istype(T, /turf/open))
		return FALSE

	if(parts_type)
		new parts_type(loc, 2)
	playsound(src, unpacking_sound, 35)

	var/obj/structure/machinery/medical_pod/bodyscanner/E = new (T)
	var/obj/structure/machinery/body_scanconsole/C = new (get_step(T, dir_needed))
	C.connected = E

	qdel(src)
	return TRUE

/obj/structure/largecrate/machine/sleeper
	name = "治疗舱箱（1台）"
	desc = "箱内装有1台医用治疗舱。"

/obj/structure/largecrate/machine/sleeper/unpack()
	var/turf/T = get_turf(loc)
	if(!istype(T, /turf/open))
		return FALSE

	if(parts_type)
		new parts_type(loc, 2)
	playsound(src, unpacking_sound, 35)

	var/obj/structure/machinery/medical_pod/sleeper/E = new (T)
	var/obj/structure/machinery/sleep_console/C = new (get_step(T, dir_needed))
	E.connected = C
	C.connected = E

	qdel(src)
	return TRUE
