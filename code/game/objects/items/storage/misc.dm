/obj/item/storage/pill_bottle/dice
	name = "骰子包"
	desc = "装有骰子的小容器。"

/obj/item/storage/pill_bottle/dice/fill_preset_inventory()
		new /obj/item/toy/dice( src )
		new /obj/item/toy/dice/d20( src )

/*
 * Donut Box
 */

/obj/item/storage/donut_box
	icon = 'icons/obj/items/food.dmi'
	icon_state = "donutbox"
	name = "好吃！甜甜圈"
	desc = "一盒令人垂涎的“<i>好吃！</i>”牌甜甜圈。"
	storage_slots = 6
	var/startswith = 6
	var/open = 0
	can_hold = list(/obj/item/reagent_container/food/snacks/donut)
	foldable = /obj/item/stack/sheet/cardboard

/obj/item/storage/donut_box/fill_preset_inventory()
	for(var/i=1; i <= startswith; i++)
		new /obj/item/reagent_container/food/snacks/donut/normal(src)

/obj/item/storage/donut_box/attack_self(mob/user as mob)
	var/message = "你[open ? "合上[src]。那就下次再吃吧。" : "打开[src]。嗯……甜甜圈。"]"
	to_chat(user, message)
	open = !open
	update_icon()
	if(!length(contents))
		..()
	return

/obj/item/storage/donut_box/update_icon()
	overlays.Cut()
	if(!open)
		icon_state = "donutbox"
		return
	icon_state = "donutbox_o"
	var/i = 0
	for(var/obj/item/reagent_container/food/snacks/donut/D in contents)
		i++
		var/image/img = image('icons/obj/items/food.dmi', "[D.overlay_state]-[i]")
		overlays += img

/obj/item/storage/donut_box/empty
	icon_state = "donutbox_o"
	startswith = 0

/*
 * Mateba Case
 */

/obj/item/storage/mateba_case
	icon = 'icons/obj/items/storage/kits.dmi'
	icon_state = "matebacase"
	name = "马特巴改装套件盒"
	desc = "用于存放马特巴左轮手枪改装工具和零件的木盒。附有三种长度的枪管和更换枪管所需的扳手。"
	storage_slots = 5
	can_hold = list(/obj/item/attachable/mateba, /obj/item/weapon/gun/revolver/mateba, /obj/item/weapon/mateba_key)

/obj/item/storage/mateba_case/captain/fill_preset_inventory()
	new /obj/item/attachable/mateba/short(src)
	new /obj/item/attachable/mateba(src)
	new /obj/item/attachable/mateba/long(src)
	new /obj/item/weapon/mateba_key(src)

/obj/item/storage/mateba_case/captain/council
	icon_state = "c_matebacase"
	name = "上校马特巴改装套件盒"
	desc = "用于存放马特巴左轮手枪改装工具和零件的黑檀木盒，专为上校定制。"

/obj/item/storage/mateba_case/general
	icon_state = "c_matebacase"
	name = "将军马特巴改装套件盒"
	desc = "用于存放马特巴左轮手枪改装工具和零件的黑檀木盒，适配将官级金色马特巴，附有金色枪管配件。"

/obj/item/storage/mateba_case/general/fill_preset_inventory()
	new /obj/item/attachable/mateba/short/dark(src)
	new /obj/item/attachable/mateba/dark(src)
	new /obj/item/attachable/mateba/long/dark(src)
	new /obj/item/weapon/mateba_key(src)

//6 pack

/obj/item/storage/beer_pack
	name = "啤酒包"
	desc = "一包阿斯彭罐装啤酒。"
	icon = 'icons/obj/items/drinkcans.dmi'
	icon_state = "6_pack_6"
	item_state = "souto_classic"
	storage_slots = 6
	can_hold = list(/obj/item/reagent_container/food/drinks/cans/aspen)

/obj/item/storage/beer_pack/fill_preset_inventory()
	for(var/i in 1 to 6)
		new /obj/item/reagent_container/food/drinks/cans/aspen(src)

/obj/item/storage/beer_pack/update_icon()
	if(length(contents) == 1)
		var/turf/T = get_turf(src)
		var/obj/item/reagent_container/food/drinks/cans/aspen/B = new(T)
		if(ishuman(loc))
			var/mob/living/carbon/human/H = loc
			H.temp_drop_inv_item(src)
			H.put_in_inactive_hand(B)
		qdel(src)
	else
		icon_state = "6_pack_[length(contents)]"

/obj/item/storage/box/loadout
	name = "储物箱"
	desc = "能放入一把手枪和若干弹匣的木盒。"
	icon = 'icons/obj/items/storage/kits.dmi'
	icon_state = "matebacase"
	w_class = SIZE_MEDIUM
	max_w_class = SIZE_MEDIUM
	storage_slots = 7

/obj/item/storage/box/loadout/T73_loadout
	name = "73 式收纳盒"
	desc = "内装一把已装填的 73 式手枪及备用弹匣的小盒子。"
	can_hold = list(/obj/item/weapon/gun/pistol/t73, /obj/item/ammo_magazine/pistol/t73)

/obj/item/storage/box/loadout/T73_loadout/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/t73())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol/t73(src)

/obj/item/storage/box/loadout/ZHNK72_loadout
	name = "ZHNK-72 收纳盒"
	desc = "内装一把已装填的 ZHNK-72 及备用快速装弹器的小盒子。"
	can_hold = list(/obj/item/weapon/gun/revolver/upp, /obj/item/ammo_magazine/revolver/upp)

/obj/item/storage/box/loadout/ZHNK72_loadout/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/revolver/upp())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/revolver/upp(src)

/obj/item/storage/box/loadout/M4A3_custom_loadout
	name = "M4A3 收纳盒"
	desc = "内装一把已装填的 M4A3 及备用弹匣的大号收纳盒。"
	can_hold = list(/obj/item/weapon/gun/pistol/m4a3/custom, /obj/item/ammo_magazine/pistol)

/obj/item/storage/box/loadout/M4A3_custom_loadout/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/m4a3/custom())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol(src)

/obj/item/storage/box/loadout/HG45_civilian_loadout
	name = "HG 45“雄鹰”收纳盒"
	desc = "内装一把已装填的 HG 45“雄鹰”及备用弹匣的大号收纳盒。"
	can_hold = list(/obj/item/weapon/gun/pistol/highpower, /obj/item/ammo_magazine/pistol/highpower)

/obj/item/storage/box/loadout/HG45_civilian_loadout/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/highpower())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol/highpower(src)

/obj/item/storage/box/loadout/HG45_marine_loadout
	name = "HG 45“海军”收纳盒"
	desc = "内装一把已装填的 HG 45“海军”及备用弹匣的大号收纳盒。"
	can_hold = list(/obj/item/weapon/gun/pistol/highpower/black, /obj/item/ammo_magazine/pistol/highpower/black)

/obj/item/storage/box/loadout/HG45_marine_loadout/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/highpower/black())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol/highpower/black(src)

/obj/item/storage/box/loadout/HG44_loadout
	name = "HG 44“自动马格南”收纳盒"
	desc = "内装一把已装填的 HG 44“自动马格南”及备用弹匣的大号收纳盒。"
	can_hold = list(/obj/item/weapon/gun/pistol/highpower/automag, /obj/item/ammo_magazine/pistol/highpower/automag)

/obj/item/storage/box/loadout/HG44_loadout/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/highpower/automag())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol/highpower/automag(src)

/obj/item/storage/box/loadout/Spearhead_loadout
	name = "矛头军械收纳盒"
	desc = "内装一把已装填的矛头军械左轮手枪及备用快速装弹器的大号收纳盒。"
	can_hold = list(/obj/item/weapon/gun/revolver/spearhead, /obj/item/ammo_magazine/revolver/spearhead)

/obj/item/storage/box/loadout/Spearhead_loadout/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/revolver/spearhead())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/revolver/spearhead(src)

/obj/item/storage/box/loadout/Spearhead_loadout/custom
	name = "矛头军械收纳盒"
	desc = "内装一把已装填的矛头军械左轮手枪及备用快速装弹器的大号收纳盒。"
	can_hold = list(/obj/item/weapon/gun/revolver/spearhead/black, /obj/item/ammo_magazine/revolver/spearhead)

/obj/item/storage/box/loadout/Spearhead_loadout/custom/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/revolver/spearhead/black())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/revolver/spearhead(src)

/obj/item/storage/box/loadout/M1911_loadout
	name = "M1911 收纳盒"
	desc = "内装一把已装填的 M1911 及备用弹匣的大号收纳盒。"
	can_hold = list(/obj/item/weapon/gun/pistol/m1911, /obj/item/ammo_magazine/pistol/m1911)

/obj/item/storage/box/loadout/M1911_loadout/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/m1911())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol/m1911(src)

/obj/item/storage/box/loadout/M44_loadout
	name = "M44 收纳盒"
	desc = "内装一把已装填的 M44 左轮手枪及备用快速装弹器的大号收纳盒。"
	can_hold = list(/obj/item/weapon/gun/revolver/m44, /obj/item/ammo_magazine/revolver)

/obj/item/storage/box/loadout/M44_loadout/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/revolver/m44())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/revolver(src)

/obj/item/storage/box/loadout/M44_custom_loadout
	name = "M44 收纳盒"
	desc = "内装一把已装填的 M44 左轮手枪及备用快速装弹器的大号收纳盒。"
	can_hold = list(/obj/item/weapon/gun/revolver/m44/custom, /obj/item/ammo_magazine/revolver)

/obj/item/storage/box/loadout/M44_custom_loadout/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/revolver/m44/custom())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/revolver(src)

/obj/item/storage/box/loadout/CLF_loadout
	name = "蜂鸟收纳盒"
	desc = "内装一把已装填的蜂鸟手枪及备用弹匣的扁平收纳盒。"
	w_class = SIZE_SMALL
	max_w_class = SIZE_TINY
	storage_slots = 4
	can_hold = list(/obj/item/weapon/gun/pistol/clfpistol, /obj/item/ammo_magazine/pistol/clfpistol)

/obj/item/storage/box/loadout/CLF_loadout/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/clfpistol())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol/clfpistol(src)

/obj/item/storage/box/loadout/L54_loadout
	name = "L54A2 收纳盒"
	desc = "内装一把已装填的 L54A2 手枪及备用弹匣的扁平收纳盒。"
	can_hold = list(/obj/item/weapon/gun/pistol/l54, /obj/item/ammo_magazine/pistol/l54)

/obj/item/storage/box/loadout/L54_loadout/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/l54())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol/l54(src)

/obj/item/storage/box/loadout/M9_loadout
	name = "伯莱塔 92FS 收纳盒"
	desc = "内装一把已装填的 M9 手枪及备用弹匣的扁平收纳盒。"
	can_hold = list(/obj/item/weapon/gun/pistol/b92fs, /obj/item/ammo_magazine/pistol/b92fs)

/obj/item/storage/box/loadout/M9_loadout/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/b92fs())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol/b92fs(src)

/obj/item/storage/box/loadout/VP78_loadout
	name = "VP78 收纳盒"
	desc = "内装一把已装填的 VP78 手枪及备用弹匣的扁平收纳盒。"
	can_hold = list(/obj/item/weapon/gun/pistol/vp78, /obj/item/ammo_magazine/pistol/vp78)
//Base VP's been nerfed in this PR, so it can come with full mags now. On par with the automag

/obj/item/storage/box/loadout/VP78_loadout/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/vp78())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol/vp78(src)

/obj/item/storage/box/loadout/bowie
	name = "鲍伊刀收纳盒"
	desc = "内装一把鲍伊格斗刀及精致皮鞘的大号收纳盒。"
	w_class = SIZE_MEDIUM
	max_w_class = SIZE_LARGE	//So the sheath can fit
	can_hold = list(/obj/item/weapon/knife/marine/bowie, /obj/item/clothing/accessory/storage/sheath)

/obj/item/storage/box/loadout/bowie/fill_preset_inventory()
	new /obj/item/clothing/accessory/storage/sheath(src)
	new /obj/item/weapon/knife/marine/bowie(src)

/obj/item/storage/box/loadout/bowie/kukri
	name = "廓尔喀弯刀收纳盒"
	desc = "内装一把廓尔喀多用途弯刀及精致皮鞘的大号收纳盒。"
	can_hold = list(/obj/item/weapon/knife/marine/bowie/kukri, /obj/item/clothing/accessory/storage/sheath)

/obj/item/storage/box/loadout/bowie/kukri/fill_preset_inventory()
	new /obj/item/clothing/accessory/storage/sheath(src)
	new /obj/item/weapon/knife/marine/bowie/kukri(src)

/obj/item/storage/box/loadout/co2_knife
	name = "M8 气瓶刺刀包装"
	desc = "内装一把 M8 气瓶刺刀和两个配套二氧化碳气瓶。感谢你长期订阅《军靴》杂志！"
	icon = 'icons/obj/items/storage/kits.dmi'
	icon_state = "co2_box"
	foldable = TRUE
	storage_slots = 3
	w_class = SIZE_SMALL
	max_w_class = SIZE_SMALL
	can_hold = list(/obj/item/attachable/bayonet/co2, /obj/item/co2_cartridge)

/obj/item/storage/box/loadout/co2_knife/fill_preset_inventory()
	new /obj/item/attachable/bayonet/co2(src)
	new /obj/item/co2_cartridge(src)
	new /obj/item/co2_cartridge(src)
