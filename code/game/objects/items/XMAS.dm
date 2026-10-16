
/mob/living/carbon/human/var/opened_gift = 0

/obj/item/m_gift //Marine Gift
	name = "礼物"
	desc = "一份USCM制式礼物。"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "gift1"
	item_state = "gift1"

/obj/item/m_gift/Initialize()
	. = ..()
	pixel_x = rand(-10,10)
	pixel_y = rand(-10,10)
	if(w_class > 0 && w_class < 4)
		icon_state = "gift[w_class]"
	else
		icon_state = "gift[pick(1, 2, 3)]"
	return

/obj/item/m_gift/attack_self(mob/M)
	..()

	var/mob/living/carbon/human/H = M
	if(istype(H))
		if(H.opened_gift == 1)
			to_chat(H, SPAN_NOTICE("这不是你的礼物，拆开它总觉得不太对。"))
		if(H.opened_gift == 2)
			to_chat(H, SPAN_NOTICE("圣诞老人知道你干了什么坏事，可你还是又拆了一份礼物。"))
		if(H.opened_gift == 3)
			to_chat(H, SPAN_NOTICE("就连格林奇也嫌恶地瞪着你……"))
		if(H.opened_gift == 4)
			to_chat(H, SPAN_NOTICE("你正在毁掉圣诞节的美好，希望你开心。"))
		if(H.opened_gift == 5)
			to_chat(H, SPAN_DANGER("好吧，恭喜你，你已经毁了5名陆战队员的圣诞节。"))
		if(H.opened_gift > 5)
			to_chat(H, SPAN_DANGER("你已经毁了[H.opened_gift]名陆战队员的圣诞节……"))

		H.opened_gift++
	/// Check if it has the possibility of being a FANCY present
	var fancy = rand(1,100)
	/// Checks if it might be one of the ULTRA fancy presents.
	var exFancy = rand(1,20)
	/// Default, just in case
	var gift_type = /obj/item/storage/fancy/crayons
	if(fancy > 90)
		if(exFancy == 1)
			to_chat(M, SPAN_NOTICE("这他妈是什么东西？？？"))
			gift_type = /obj/item/clothing/mask/facehugger/lamarr
			var/obj/item/I = new gift_type(M)
			M.temp_drop_inv_item(src)
			M.put_in_hands(I)
			I.add_fingerprint(M)
			qdel(src)
			return
		if(exFancy > 15)
			to_chat(M, SPAN_NOTICE("噢，正是我需要的……该死的BFAB跳跃空爆破片手榴弹。"))
			gift_type = /obj/item/ammo_box/magazine/nade_box/bfab
			var/obj/item/I = new gift_type(M)
			M.temp_drop_inv_item(src)
			M.put_in_hands(I)
			I.add_fingerprint(M)
			qdel(src)
			return
		else
			gift_type = pick(
			/obj/item/weapon/gun/revolver/mateba,
			/obj/item/weapon/gun/pistol/heavy,
			/obj/item/weapon/sword,
			/obj/item/weapon/energy/sword/green,
			/obj/item/weapon/energy/sword/red,
			/obj/item/attachable/heavy_barrel,
			/obj/item/attachable/extended_barrel,
			/obj/item/attachable/burstfire_assembly,
			)
			to_chat(M, SPAN_NOTICE("这才是真正的礼物！！！"))
			var/obj/item/I = new gift_type(M)
			M.temp_drop_inv_item(src)
			M.put_in_hands(I)
			I.add_fingerprint(M)
			qdel(src)
			return
	else if (fancy <=5)
		to_chat(M, SPAN_NOTICE("他妈的，里面是空的。去他的CM。"))
		M.temp_drop_inv_item(src)
		qdel(src)
		return


	gift_type = pick(
		/obj/item/storage/box/snappops,
		/obj/item/storage/fancy/crayons,
		/obj/item/storage/belt/champion,
		/obj/item/tool/soap/deluxe,
		/obj/item/explosive/grenade/smokebomb,
		/obj/item/poster,
		/obj/item/toy/bikehorn,
		/obj/item/toy/beach_ball,
		/obj/item/weapon/banhammer,
		/obj/item/toy/crossbow,
		/obj/item/toy/gun,
		/obj/item/toy/katana,
		/obj/item/toy/prize/deathripley,
		/obj/item/toy/prize/durand,
		/obj/item/toy/prize/fireripley,
		/obj/item/toy/prize/gygax,
		/obj/item/toy/prize/honk,
		/obj/item/toy/prize/marauder,
		/obj/item/toy/prize/mauler,
		/obj/item/toy/prize/odysseus,
		/obj/item/toy/prize/phazon,
		/obj/item/toy/prize/ripley,
		/obj/item/toy/prize/seraph,
		/obj/item/toy/spinningtoy,
		/obj/item/clothing/accessory/horrible,
		/obj/item/clothing/shoes/slippers,
		/obj/item/clothing/shoes/slippers_worn,
		/obj/item/clothing/head/collectable/tophat/super,
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/reddot,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/bipod,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/stock/rifle,
		/obj/item/attachable/scope)

	if(!ispath(gift_type,/obj/item)) return
	to_chat(M, SPAN_NOTICE("至少不是空的……"))
	var/obj/item/I = new gift_type(M)
	M.temp_drop_inv_item(src)
	M.put_in_hands(I)
	I.add_fingerprint(M)
	qdel(src)
	return
