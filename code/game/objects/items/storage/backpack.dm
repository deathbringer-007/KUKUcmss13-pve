/*
 * Backpack
 */

/obj/item/storage/backpack
	name = "背包"
	desc = "背在背上，用来装东西。"
	icon = 'icons/obj/items/clothing/backpacks.dmi'
	icon_state = "backpack"
	w_class = SIZE_LARGE
	flags_equip_slot = SLOT_BACK //ERROOOOO
	max_w_class = SIZE_MEDIUM
	storage_slots = null
	max_storage_space = 21
	drop_sound = "armorequip"
	var/worn_accessible = FALSE //whether you can access its content while worn on the back
	var/bag_open_time = 2 SECONDS //How long it takes to open the bag
	var/obj/item/card/id/locking_id = null
	var/is_id_lockable = FALSE
	var/lock_overridable = TRUE
	var/xeno_icon_state = null //the icon_state for xeno's wearing this (using the dmi defined in default_xeno_onmob_icons list)
	var/list/xeno_types = null //what xeno types can equip this backpack

/obj/item/storage/backpack/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/card/id/) && is_id_lockable && ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/card/id/card = W
		toggle_lock(card, H)
		return

	if (..() && use_sound)
		playsound(loc, use_sound, 15, TRUE, 6)

/obj/item/storage/backpack/attack(mob/living/target_mob, mob/living/user)
	if(!xeno_icon_state)
		return ..()
	if(target_mob.back)
		return ..()
	if(user.a_intent != INTENT_HELP)
		return ..()
	if(!xeno_types || !(target_mob.type in xeno_types))
		return ..()
	if(!isxeno(target_mob))
		return ..()
	if(HAS_TRAIT(target_mob, TRAIT_XENONID))
		return ..() // We don't have backpack sprites for xenoids (yet?)
	var/mob/living/carbon/xenomorph/xeno = target_mob
	if(target_mob.stat != DEAD) // If the Xeno is alive, fight back
		var/mob/living/carbon/carbon_user = user
		if(!carbon_user || !carbon_user.ally_of_hivenumber(xeno.hivenumber))
			user.KnockDown(rand(xeno.caste.tacklestrength_min, xeno.caste.tacklestrength_max))
			playsound(user.loc, 'sound/weapons/pierce.ogg', 25, TRUE)
			user.visible_message(SPAN_WARNING("[user]试图将[src]绑到[target_mob]身上，却被一尾巴抽中了头！"))
			return FALSE

	user.visible_message(SPAN_NOTICE("[user]开始将[src]绑到[target_mob]身上。"), \
	SPAN_NOTICE("你开始将[src]绑到[target_mob]身上。"), null, 5, CHAT_TYPE_FLUFF_ACTION)
	if(!do_after(user, HUMAN_STRIP_DELAY * user.get_skill_duration_multiplier(SKILL_CQC), INTERRUPT_ALL, BUSY_ICON_GENERIC, target_mob, INTERRUPT_MOVED, BUSY_ICON_GENERIC))
		to_chat(user, SPAN_WARNING("你的操作被打断了！"))
		return FALSE

	// Ensure conditions still valid
	if(src != user.get_active_hand())
		return FALSE
	if(!user.Adjacent(target_mob))
		return FALSE
	user.drop_inv_item_on_ground(src)
	if(!src || QDELETED(src)) //Might be self-deleted?
		return FALSE

	// Create their vis object if needed
	if(!xeno.backpack_icon_holder)
		xeno.backpack_icon_holder = new(null, xeno)
		xeno.vis_contents += xeno.backpack_icon_holder

	target_mob.put_in_back(src)
	return FALSE

/obj/item/storage/backpack/proc/toggle_lock(obj/item/card/id/card, mob/living/carbon/human/H)
	if(QDELETED(locking_id))
		to_chat(H, SPAN_NOTICE("你锁上了[src]！"))
		locking_id = card
	else
		if(locking_id.registered_name == card.registered_name || (lock_overridable && (ACCESS_MARINE_SENIOR in card.access)))
			to_chat(H, SPAN_NOTICE("你解锁了[src]！"))
			locking_id = null
		else
			to_chat(H, SPAN_NOTICE("身份识别锁拒绝了你的身份卡。"))
	update_icon()

/obj/item/storage/backpack/equipped(mob/user, slot, silent)
	if(slot == WEAR_BACK)
		mouse_opacity = MOUSE_OPACITY_OPAQUE //so it's easier to click when properly equipped.
		if(use_sound && !silent)
			playsound(loc, use_sound, 15, TRUE, 6)
		if(!worn_accessible) //closes it if it's open.
			storage_close(user)
	..()

/obj/item/storage/unequipped(mob/user, slot, silent)
	if(slot == WEAR_BACK)
		if(use_sound && !silent)
			playsound(loc, use_sound, 15, TRUE, 6)
	..()

/obj/item/storage/backpack/dropped(mob/user)
	mouse_opacity = initial(mouse_opacity)
	..()


/obj/item/storage/backpack/open(mob/user)
	if(!is_accessible_by(user))
		return
	if(locking_id && !compare_id(user))//if id locked we the user's id against the locker's
		to_chat(user, SPAN_NOTICE("[src]被[locking_id.registered_name]的身份卡锁定了！你决定别碰它。"))
		return
	..()

/obj/item/storage/backpack/storage_close(mob/user)
	UnregisterSignal(user, COMSIG_MOVABLE_PRE_MOVE)
	..()

/obj/item/storage/backpack/proc/is_accessible_by(mob/user)
	// If the user is already looking inside this backpack.
	if(user.s_active == src)
		return TRUE
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!worn_accessible)
			if(H.back == src && !user.action_busy) //Not doing any timed actions?
				to_chat(H, SPAN_NOTICE("你开始打开[src]，检查里面的东西。"))
				if(!do_after(user, bag_open_time, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC)) //Timed opening.
					to_chat(H, SPAN_WARNING("你的操作被打断了！"))
					return FALSE
				RegisterSignal(user, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(storage_close)) //Continue along the proc and allow opening if not locked; close on movement.
			else if(H.back == src) //On back and doing timed actions?
				return FALSE
	return TRUE

/obj/item/storage/backpack/empty(mob/user, turf/T)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.back == src && !worn_accessible && !content_watchers) //Backpack on back needs to be opened; if it's already opened, it can be emptied immediately.
			if(!is_accessible_by(user))
				return
	if(locking_id && !compare_id(user))//if id locked we the user's id against the locker's
		to_chat(user, SPAN_NOTICE("[src]被[locking_id.registered_name]的身份卡锁定了！你决定别碰它。"))
		return
	..()

//Returns true if the user's id matches the lock's
/obj/item/storage/backpack/proc/compare_id(mob/living/carbon/human/H)
	var/obj/item/card/id/card = H.get_idcard()
	if(!card || locking_id.registered_name != card.registered_name)
		return FALSE
	else return TRUE

/obj/item/storage/backpack/update_icon()
	overlays.Cut()

	if(content_watchers) //If someone's looking inside it, don't close the flap. Lockables display as temporarily unlocked.
		if(is_id_lockable)
			overlays += "+[icon_state]_unlocked"
		return

	if(locking_id) // if it's locked, we expect the casing to be shut.
		overlays += "+[icon_state]_full"
		overlays += "+[icon_state]_locked"
		return
	else if(is_id_lockable)
		overlays += "+[icon_state]_unlocked"

	var/sum_storage_cost = 0
	for(var/obj/item/I in contents)
		sum_storage_cost += I.get_storage_cost()
	if(!sum_storage_cost)
		return

	else if(sum_storage_cost <= max_storage_space * 0.5)
		overlays += "+[icon_state]_half"
	else
		overlays += "+[icon_state]_full"

/obj/item/storage/backpack/get_examine_text(mob/user)
	. = ..()
	if(is_id_lockable)
		. += "配有身份识别锁，刷身份卡即可锁定或解锁。"
		if(lock_overridable)
			. += "具有指挥级权限可强制解锁。"

/*
 * Backpack Types
 */

/obj/item/storage/backpack/holding
	name = "次元背包"
	desc = "通向局部蓝空间口袋的背包。"
	icon_state = "holdingpack"
	max_w_class = SIZE_LARGE
	max_storage_space = 28

/obj/item/storage/backpack/holding/attackby(obj/item/W as obj, mob/user as mob)
	if(crit_fail)
		to_chat(user, SPAN_DANGER("蓝空间发生器没有运行。"))
		return
	if(istype(W, /obj/item/storage/backpack/holding) && !W.crit_fail)
		to_chat(user, SPAN_DANGER("两个装置的蓝空间接口冲突，发生故障。"))
		qdel(W)
		return
	..()

/obj/item/storage/backpack/holding/proc/failcheck(mob/user as mob)
	if (prob(src.reliability)) return 1 //No failure
	if (prob(src.reliability))
		to_chat(user, SPAN_DANGER("蓝空间传送门阻止了你塞入另一件物品。")) //light failure
	else
		to_chat(user, SPAN_DANGER("蓝空间发生器故障！"))
		for (var/obj/thing in contents) //it broke, delete what was in it
			qdel(thing)
		crit_fail = 1
		icon_state = "brokenpack"


//==========================//JOKE PACKS\\================================\\

/obj/item/storage/backpack/santabag
	name = "圣诞老人的礼物袋"
	desc = "太空圣诞老人用它在圣诞节给太空里所有乖孩子送玩具！哇，真大！"
	icon_state = "giftbag"
	item_state = "giftbag"
	w_class = SIZE_LARGE
	storage_slots = 30
	max_w_class = SIZE_MASSIVE
	worn_accessible = TRUE
	actions_types = list(/datum/action/item_action/specialist/santabag)

/obj/item/storage/backpack/santabag/Initialize()
	. = ..()
	refill_santa_bag()

/obj/item/storage/backpack/santabag/proc/refill_santa_bag(mob/living/user)
	var/current_items = length(contents)
	var/total_to_refill = storage_slots - current_items
	for(var/total_storage_slots in 1 to total_to_refill)
		new /obj/item/m_gift(src)
	if(!user)
		return
	playsound(user, 'sound/items/jingle_long.wav', 25, TRUE)
	to_chat(user, SPAN_GREEN("你用圣诞魔法重新装满了礼物袋！"))

/obj/item/storage/backpack/santabag/item_action_slot_check(mob/user, slot)
	if(HAS_TRAIT(user, TRAIT_SANTA)) //Only the Santa himself knows how to use this bag properly.
		return TRUE

/datum/action/item_action/specialist/santabag/New(mob/living/user, obj/item/holder)
	..()
	name = "Refill Gift Bag"
	action_icon_state = holder?.icon_state
	button.name = "重新装满礼物袋"
	button.overlays.Cut()
	button.overlays += image(holder?.icon_state, button, action_icon_state)

/datum/action/item_action/specialist/santabag/can_use_action()
	return TRUE

/datum/action/item_action/specialist/santabag/action_activate()
	. = ..()
	var/obj/item/storage/backpack/santabag/santa_bag = holder_item
	santa_bag.refill_santa_bag(owner)
	update_button_icon()

/obj/item/storage/backpack/cultpack
	name = "战利品架"
	desc = "既能携带额外装备，也能自豪地宣示你的疯狂。"
	icon_state = "cultpack"

/obj/item/storage/backpack/clown
	name = "冯·鸣笛顿的傻笑"
	desc = "这，这东西。它让你对逝去的时代心生恐惧：灰色工装和精神不稳定的船员，叛徒与流氓。谢天谢地，你现在是陆战队员。"
	icon_state = "clownpack"
	black_market_value = 25

//==========================//COLONY/CIVILIAN PACKS\\================================\\

/obj/item/storage/backpack/medic
	name = "医疗背包"
	desc = "专为无菌环境设计的背包。"
	icon_state = "medicalpack"

/obj/item/storage/backpack/security //Universal between USCM MPs & Colony, should be split at some point.
	name = "安保背包"
	desc = "非常结实的背包。"
	icon_state = "securitypack"

/obj/item/storage/backpack/industrial
	name = "工业背包"
	desc = "工程人员等使用的结实背包，看起来就很像个背包。"
	icon_state = "engiepack"
	item_state = "engiepack"

/obj/item/storage/backpack/toxins
	name = "实验室背包"
	desc = "供实验室和其他科研机构使用的轻型背包。"
	icon_state = "toxpack"

/obj/item/storage/backpack/hydroponics
	name = "草药师背包"
	desc = "绿色背包，带有许多存放植物和工具的口袋。"
	icon_state = "hydpack"

/obj/item/storage/backpack/genetics
	name = "遗传学家背包"
	desc = "带有磁盘和其他工作工具插槽的背包。"
	icon_state = "genpack"

/obj/item/storage/backpack/virology
	name = "无菌背包"
	desc = "由抗病原体面料制成的无菌背包。"
	icon_state = "viropack"

/obj/item/storage/backpack/chemistry
	name = "化学背包"
	desc = "用于装烧杯、药瓶和瓶子的橙色背包。"
	icon_state = "chempack"

/*
 * Satchel Types
 */

/obj/item/storage/backpack/satchel
	name = "皮革挎包"
	desc = "优质皮革制成的精美挎包，看起来价格不菲。"
	icon_state = "satchel"
	worn_accessible = TRUE
	storage_slots = null
	max_storage_space = 15

/obj/item/storage/backpack/satchel/blue
	name = "皮革挎包"
	desc = "精制皮革制成的华丽挎包，看起来相当昂贵。这件是蓝色的。"
	icon_state = "satchel-blue"

/obj/item/storage/backpack/satchel/black
	name = "皮革挎包"
	desc = "精制皮革制成的华丽挎包，看起来相当昂贵。这件是黑色的。"
	icon_state = "satchel-black"

/obj/item/storage/backpack/satchel/withwallet

/obj/item/storage/backpack/satchel/withwallet/fill_preset_inventory()
	new /obj/item/storage/wallet/random( src )

/obj/item/storage/backpack/satchel/lockable
	name = "安全皮革挎包"
	desc = "优质皮革制成的精美挎包，带有锁具。"
	is_id_lockable = TRUE

/obj/item/storage/backpack/satchel/lockable/liaison
	lock_overridable = FALSE

/obj/item/storage/backpack/satchel/blue
	icon_state = "satchel_blue"

/obj/item/storage/backpack/satchel/black
	icon_state = "satchel_black"

/obj/item/storage/backpack/satchel/norm
	name = "挎包"
	desc = "看起来很时髦的挎包。"
	icon_state = "satchel-norm"

/obj/item/storage/backpack/satchel/eng
	name = "工业挎包"
	desc = "带额外口袋的结实挎包。"
	icon_state = "satchel-eng"

/obj/item/storage/backpack/satchel/med
	name = "医疗挎包"
	desc = "医疗部门使用的无菌挎包。"
	icon_state = "satchel-med"

/obj/item/storage/backpack/satchel/vir
	name = "病毒学家挎包"
	desc = "采用病毒学家配色的无菌挎包。"
	icon_state = "satchel-vir"

/obj/item/storage/backpack/satchel/chem
	name = "化学家挎包"
	desc = "采用化学家配色的无菌挎包。"
	icon_state = "satchel-chem"

/obj/item/storage/backpack/satchel/gen
	name = "遗传学家挎包"
	desc = "采用遗传学家配色的无菌挎包。"
	icon_state = "satchel-gen"

/obj/item/storage/backpack/satchel/tox
	name = "科学家挎包"
	desc = "适合携带科研材料。"
	icon_state = "satchel-tox"

/obj/item/storage/backpack/satchel/sec //Universal between USCM MPs & Colony, should be split at some point.
	name = "安保挎包"
	desc = "结实的挎包，由两个侧袋和一个大内袋组成。布料僵硬，背着不太舒服。"
	icon_state = "satchel-sec"

/obj/item/storage/backpack/satchel/hyd
	name = "水培挎包"
	desc = "用于植物相关工作的绿色挎包。"
	icon_state = "satchel_hyd"

//==========================// MARINE BACKPACKS\\================================\\
//=======================================================================\\

/obj/item/storage/backpack/marine
	name = "轻型 IMP 背包"
	desc = "USCM 与美国陆军的制式背包，利用 M3 护甲的直觉式挂载点系统将装备带入战场。"
	icon_state = "imp"
	item_state = "imp"
	has_gamemode_skin = FALSE //replace this with the atom_flag NO_SNOW_TYPE at some point, just rename it to like, NO_MAP_VARIANT_SKIN

/obj/item/storage/backpack/marine/standard
	has_gamemode_skin = FALSE

/obj/item/storage/backpack/marine/ammo_rack
	name = "IMP 弹药架"
	desc = "带有固定扣的裸露 IMP 框架，原本用于挂载多个弹药箱；凭借陆战队员的巧思，任何笨重箱子也能装上。方便携带额外弹药或物资。"
	has_gamemode_skin = FALSE
	storage_slots = 3
	icon_state = "ammo_pack_0"
	can_hold = list(/obj/item/ammo_box, /obj/item/stack/folding_barricade)
	max_w_class = SIZE_HUGE
	throw_range = 0
	xeno_types = null
	var/base_icon_state = "ammo_pack"
	var/move_delay_mult = 0.4

/obj/item/storage/backpack/marine/ammo_rack/update_icon()
	. = ..()
	icon_state = "[base_icon_state]_[length(contents)]"

/obj/item/storage/backpack/marine/ammo_rack/pickup(mob/user, silent)
	. = ..()
	RegisterSignal(user, COMSIG_HUMAN_POST_MOVE_DELAY, PROC_REF(handle_movedelay))

/obj/item/storage/backpack/marine/ammo_rack/proc/handle_movedelay(mob/user, list/movedata)
	SIGNAL_HANDLER
	if(locate(/obj/item/storage/backpack/marine/ammo_rack) in user.contents)
		movedata["move_delay"] += move_delay_mult

/obj/item/storage/backpack/marine/ammo_rack/dropped(mob/user, silent)
	. = ..()
	UnregisterSignal(user, COMSIG_HUMAN_POST_MOVE_DELAY)

/obj/item/storage/backpack/marine/medic
	name = "USCM 医疗兵背包"
	desc = "USCM 医疗兵使用的制式背包。"
	icon_state = "marinepack_medic"
	item_state = "marinepack_medic"
	xeno_icon_state = "medicpack"
	xeno_types = list(/mob/living/carbon/xenomorph/runner, /mob/living/carbon/xenomorph/praetorian, /mob/living/carbon/xenomorph/drone, /mob/living/carbon/xenomorph/warrior, /mob/living/carbon/xenomorph/defender, /mob/living/carbon/xenomorph/sentinel, /mob/living/carbon/xenomorph/spitter)

/obj/item/storage/backpack/marine/medic/standard
	has_gamemode_skin = FALSE

/obj/item/storage/backpack/marine/medic/upp
	name = "UPP 医疗兵背包"
	desc = "偏远星区 UPP 医疗兵使用的少见配发背包。你敢肯定，上面有个褪色的 USCM 标志。"

/obj/item/storage/backpack/marine/tech
	name = "USCM 技术员背包"
	desc = "USCM 技术员使用的制式背包。"
	icon_state = "marinepack_techi"
	item_state = "marinepack_techi"
	xeno_icon_state = "marinepack"
	xeno_types = list(/mob/living/carbon/xenomorph/runner, /mob/living/carbon/xenomorph/praetorian, /mob/living/carbon/xenomorph/drone, /mob/living/carbon/xenomorph/warrior, /mob/living/carbon/xenomorph/defender, /mob/living/carbon/xenomorph/sentinel, /mob/living/carbon/xenomorph/spitter)

/obj/item/storage/backpack/marine/satchel/intel
	name = "USCM 轻型远征包"
	desc = "基于 IMP 系统的重型背包，可挂在胸前或身侧，单手即可快速取用。通常配发给 USCM 情报官。"
	icon_state = "marinebigsatch"
	max_storage_space = 20

/obj/item/storage/backpack/marine/satchel/intel/chestrig
	name = "USCM 远征胸挂"
	desc = "基于 IMP 系统的重型胸挂，单手即可快速取用。通常配发给 USCM 情报官。"
	icon_state = "intel_chestrig"
	max_storage_space = 20

/obj/item/storage/backpack/marine/satchel
	name = "USCM 挎包"
	desc = "部分 USCM 士兵与支援人员携带的重型挎包。"
	icon_state = "marinesatch"
	worn_accessible = TRUE
	storage_slots = null
	max_storage_space = 15
	xeno_types = null

/obj/item/storage/backpack/marine/satchel/standard
	has_gamemode_skin = FALSE

/obj/item/storage/backpack/marine/satchel/big //wacky squad marine loadout item, its the IO backpack.
	name = "\improper 美国殖民地陆战队后勤 IMP 背包"
	desc = "后勤人员制式背包，偶尔也会在长期远征和深空行动中配发给战斗人员。"
	icon_state = "marinebigsatch"
	worn_accessible = TRUE
	storage_slots = null
	max_storage_space = 21 //backpack size

/obj/item/storage/backpack/marine/satchel/medic
	name = "USCM 医疗兵挎包"
	desc = "USCM 医疗兵使用的重型挎包，牺牲容量以提高便利性。顶盖缝有一块小标章。"
	icon_state = "marinesatch_medic"

/obj/item/storage/backpack/marine/satchel/medic/standard
	has_gamemode_skin = FALSE

/obj/item/storage/backpack/marine/satchel/tech
	name = "USCM 技术员胸挂"
	desc = "部分 USCM 技术员使用的重型胸挂。"
	icon_state = "marinesatch_techi"

/obj/item/storage/backpack/marine/satchel/chestrig
	name = "USCM 胸挂"
	desc = "部分 USCM 人员使用的胸挂。"
	icon_state = "chestrig"
	has_gamemode_skin = FALSE

GLOBAL_LIST_EMPTY_TYPED(radio_packs, /obj/item/storage/backpack/marine/satchel/rto)

/obj/item/storage/backpack/marine/satchel/rto
	name = "USCM 无线电话背包"
	desc = "用于与中央指挥部通讯的重型背包，通常由无线电话员携带。"
	icon_state = "rto_backpack"
	item_state = "rto_backpack"
	has_gamemode_skin = FALSE

	flags_item = ITEM_OVERRIDE_NORTHFACE

	var/phone_category = PHONE_MARINE
	var/list/networks_receive = list(FACTION_MARINE)
	var/list/networks_transmit = list(FACTION_MARINE)

	actions_types = list(/datum/action/item_action/rto_pack/use_phone)

/obj/item/storage/backpack/marine/satchel/rto/Initialize()
	. = ..()

	AddComponent(/datum/component/phone, phone_category = phone_category, networks_receive = networks_receive, networks_transmit = networks_transmit, overlay_interactable = TRUE)
	RegisterSignal(src, COMSIG_ATOM_PHONE_PICKED_UP, PROC_REF(phone_picked_up))
	RegisterSignal(src, COMSIG_ATOM_PHONE_HUNG_UP, PROC_REF(phone_hung_up))
	RegisterSignal(src, COMSIG_ATOM_PHONE_RINGING, PROC_REF(phone_ringing))
	RegisterSignal(src, COMSIG_ATOM_PHONE_STOPPED_RINGING, PROC_REF(phone_stopped_ringing))

/datum/action/item_action/rto_pack/use_phone/New(mob/living/user, obj/item/holder)
	..()
	name = "Use Phone"
	button.name = "使用电话"
	button.overlays.Cut()
	var/image/phone_overlay = image('icons/obj/items/misc.dmi', button, "rpb_phone")
	button.overlays += phone_overlay

/datum/action/item_action/rto_pack/use_phone/action_activate()
	. = ..()
	for(var/obj/item/storage/backpack/marine/satchel/rto/radio_backpack in owner)
		SEND_SIGNAL(radio_backpack, COMSIG_ATOM_PHONE_BUTTON_USE, user = owner)
		return

/obj/item/storage/backpack/marine/satchel/rto/proc/phone_picked_up()
	icon_state = PHONE_OFF_BASE_UNIT_ICON_STATE

/obj/item/storage/backpack/marine/satchel/rto/proc/phone_hung_up()
	icon_state = PHONE_ON_BASE_UNIT_ICON_STATE

/obj/item/storage/backpack/marine/satchel/rto/proc/phone_ringing()
	icon_state = PHONE_RINGING_ICON_STATE

/obj/item/storage/backpack/marine/satchel/rto/proc/phone_stopped_ringing()
	if(icon_state == PHONE_OFF_BASE_UNIT_ICON_STATE)
		return
	icon_state = PHONE_ON_BASE_UNIT_ICON_STATE

/obj/item/storage/backpack/marine/satchel/rto/upp_net
	name = "\improper 进步人民联盟无线电话背包"
	networks_receive = list(FACTION_UPP)
	networks_transmit = list(FACTION_UPP)

/obj/item/storage/backpack/marine/satchel/rto/small
	name = "\improper 美国殖民地陆战队小型无线电话背包"
	max_storage_space = 10

/obj/item/storage/backpack/marine/satchel/rto/small/upp_net
	name = "\improper 进步人民联盟无线电话背包"
	networks_receive = list(FACTION_UPP)
	networks_transmit = list(FACTION_UPP)
	phone_category = PHONE_UPP_SOLDIER

/obj/item/storage/backpack/marine/satchel/rto/io
	phone_category = PHONE_IO

/obj/item/storage/backpack/marine/smock
	name = "M3 狙击手罩衣"
	desc = "专门设计的罩衣，口袋可满足狙击手的各种需要。"
	icon_state = "smock"
	worn_accessible = TRUE
	xeno_types = null

/obj/item/storage/backpack/marine/marsoc
	name = "USCM SOF IMP 战术行军背包"
	icon_state = "tacrucksack"
	desc = "背上这样的背包，你会忘记自己正走在要命的地狱行军路上。"
	worn_accessible = TRUE
	has_gamemode_skin = FALSE
	xeno_types = null

/obj/item/storage/backpack/marine/rocketpack
	name = "USCM IMP M22 火箭弹携行袋"
	desc = "专门适配 USCM 标准 M3 式护甲 IMP 挂架的背包，由两根防水加强筒和底部的小挎包组成。两根筒原本装火箭弹，但也没人阻止你塞别的东西。"
	icon_state = "rocketpack"
	worn_accessible = TRUE
	has_gamemode_skin = FALSE //monkeysfist101 never sprited a snowtype but included duplicate icons. Why?? Recolor and touch up sprite at a later date.
	xeno_types = null

/obj/item/storage/backpack/marine/grenadepack
	name = "USCM IMP M63A1 手榴弹挎包"
	desc = "带有专用手榴弹袋的安全挎包，可降低二次引燃风险。"
	icon_state = "grenadierpack"
	overlays = list("+grenadierpack_unlocked")
	worn_accessible = TRUE
	max_storage_space = 36 //12 grenades
	storage_slots = 12
	can_hold = list(/obj/item/explosive/grenade)
	is_id_lockable = TRUE
	has_gamemode_skin = FALSE
	xeno_types = null

/obj/item/storage/backpack/marine/grenadepack/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/ammo_box/magazine/nade_box) || istype(W, /obj/item/storage/backpack/marine/grenadepack) || istype(W, /obj/item/storage/belt/grenade))
		dump_into(W,user)
	else
		return ..()

/obj/item/storage/backpack/marine/mortarpack
	name = "USCM 迫击炮弹背包"
	desc = "专门用于携带 M402 迫击炮弹药的背包。"
	icon_state = "mortarpack"
	max_w_class = SIZE_HUGE
	storage_slots = 12
	can_hold = list(/obj/item/mortar_shell, /obj/item/device/binoculars)
	xeno_types = null

/obj/item/storage/backpack/marine/mortarpack/full/fill_preset_inventory()
	new /obj/item/mortar_shell/flare(src)
	new /obj/item/mortar_shell/flare(src)
	new /obj/item/mortar_shell/flare(src)
	new /obj/item/mortar_shell/he(src)
	new /obj/item/mortar_shell/he(src)
	new /obj/item/mortar_shell/he(src)
	new /obj/item/mortar_shell/he(src)
	new /obj/item/mortar_shell/he(src)
	new /obj/item/mortar_shell/incendiary(src)
	new /obj/item/mortar_shell/incendiary(src)
	new /obj/item/mortar_shell/incendiary(src)
	new /obj/item/mortar_shell/incendiary(src)

/// G-8-a general pouch belt
/obj/item/storage/backpack/general_belt
	name = "G8-A 通用杂物袋"
	desc = "轻便的小袋，可夹在阿玛特系统 M3 式护甲上增加储物空间。新款 G8-A 也能固定在腰间，只是不太舒服。"
	max_storage_space = 10
	w_class = SIZE_LARGE
	max_w_class = SIZE_MEDIUM
	flags_equip_slot = SLOT_WAIST
	icon = 'icons/obj/items/clothing/belts.dmi'
	icon_state = "g8pouch"
	item_state = "g8pouch"
	has_gamemode_skin = FALSE
	can_hold_skill = list()

/obj/item/storage/backpack/general_belt/equipped(mob/user, slot)
	switch(slot)
		if(WEAR_WAIST, WEAR_J_STORE) //The G8 can be worn on several armors.
			mouse_opacity = MOUSE_OPACITY_OPAQUE //so it's easier to click when properly equipped.
	..()

/obj/item/storage/backpack/general_belt/dropped(mob/user)
	mouse_opacity = initial(mouse_opacity)
	..()

/obj/item/storage/backpack/general_belt/standard
	can_hold_skill = FALSE

/obj/item/storage/backpack/general_belt/upp
	name = "式 48-M 通用杂物袋"
	desc = "轻便的小袋，可夹在 UPP U 式护甲上增加储物空间。新款 48-M 也能固定在腰间，只是不太舒服。"
	icon_state = "upp_g8pouch"
	item_state = "upp_g8pouch"
	has_gamemode_skin = FALSE

//this preset is for the US Army machinegunner.
/obj/item/storage/backpack/general_belt/army
	desc = "可戴在腰部或背部的小型轻便携行袋，能大量携带较大的弹匣。"
//this fills the preset's ammo belt
/obj/item/storage/backpack/general_belt/army/fill_preset_inventory()
		new /obj/item/ammo_magazine/hpr_box/ap (src)
		new /obj/item/ammo_magazine/hpr_box/ap (src)

#define FULL_CAMO_ALPHA 15
#define VISIBLE_CAMO_ALPHA 60

#define FULL_PVE_CAMO_ALPHA 30
#define VISIBLE_PVE_CAMO_ALPHA 75

// Scout Cloak
/obj/item/storage/backpack/marine/satchel/scout_cloak
	name = "\improper M68 热隐蔽披风"
	desc = "轻型热信号抑制与光学伪装能力弱于美国殖民地陆战队标准吉利服，但可穿在战斗护甲外，给予穿着者很高的机动性与多环境适应能力。"
	icon_state = "scout_cloak"
	unacidable = TRUE
	indestructible = TRUE
	has_gamemode_skin = FALSE //same sprite for all gamemode.
	var/camo_active = FALSE
	var/full_camo_alpha = FULL_PVE_CAMO_ALPHA
	var/incremental_shooting_camo_penalty = 30
	var/current_camo = FULL_PVE_CAMO_ALPHA
	var/visible_camo_alpha = VISIBLE_PVE_CAMO_ALPHA
	var/camouflage_break = 8 SECONDS
	var/cloak_cooldown
	var/camo_message_delay = 2 SECONDS

	actions_types = list(/datum/action/item_action/specialist/toggle_cloak)

/obj/item/storage/backpack/marine/satchel/scout_cloak/dropped(mob/user)
	if(ishuman(user) && !issynth(user))
		deactivate_camouflage(user, FALSE)

	. = ..()

/obj/item/storage/backpack/marine/satchel/scout_cloak/attack_self(mob/user)
	..()
	camouflage()

/obj/item/storage/backpack/marine/satchel/scout_cloak/verb/camouflage()
	set name = "Activate Cloak"
	set desc = "启动披风的迷彩功能。"
	set category = "Scout"
	set src in usr
	if(!usr || usr.is_mob_incapacitated(TRUE))
		return

	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/H = usr

	if(H.back != src)
		to_chat(H, SPAN_WARNING("你必须穿着披风才能启动它！"))
		return

	if(camo_active)
		deactivate_camouflage(H)
		return

	if(cloak_cooldown && cloak_cooldown > world.time)
		to_chat(H, SPAN_WARNING("你的披风故障了，暂时无法启动！"))
		return

	RegisterSignal(H,  list(
		COMSIG_MOB_FIRED_GUN,
		COMSIG_MOB_FIRED_GUN_ATTACHMENT)
		, PROC_REF(fade_in))
	RegisterSignal(H, COMSIG_HUMAN_EXTINGUISH, PROC_REF(wrapper_fizzle_camouflage))
	RegisterSignal(H, list(
		COMSIG_MOB_DEATH,
		COMSIG_MOB_EFFECT_CLOAK_CANCEL
	), PROC_REF(deactivate_camouflage))

	camo_active = TRUE
	ADD_TRAIT(H, TRAIT_CLOAKED, TRAIT_SOURCE_EQUIPMENT(WEAR_BACK))
	H.visible_message(SPAN_DANGER("[H]凭空消失！"), SPAN_NOTICE("你启动了披风的伪装功能。"), max_distance = 4)
	playsound(H.loc, 'sound/effects/cloak_scout_on.ogg', 15, TRUE)
	H.unset_interaction()

	H.alpha = full_camo_alpha
	H.FF_hit_evade = 1000

	var/datum/mob_hud/security/advanced/SA = GLOB.huds[MOB_HUD_SECURITY_ADVANCED]
	SA.remove_from_hud(H)
	var/datum/mob_hud/xeno_infection/XI = GLOB.huds[MOB_HUD_XENO_INFECTION]
	XI.remove_from_hud(H)

	anim(H.loc, H, 'icons/mob/mob.dmi', null, "cloak", null, H.dir)
	return TRUE


/obj/item/storage/backpack/marine/satchel/scout_cloak/proc/fade_in(mob/user)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/H = user
	if(camo_active)
		if(current_camo < full_camo_alpha)
			current_camo = full_camo_alpha
		current_camo = clamp(current_camo + incremental_shooting_camo_penalty, full_camo_alpha, 255)
		H.alpha = current_camo
		if(current_camo > visible_camo_alpha)
			REMOVE_TRAIT(H, TRAIT_CLOAKED, TRAIT_SOURCE_EQUIPMENT(WEAR_BACK))
			to_chat(H, SPAN_BOLDNOTICE("披风无法再将你完全隐藏！"))
		addtimer(CALLBACK(src, PROC_REF(fade_out_finish), H), camouflage_break, TIMER_OVERRIDE|TIMER_UNIQUE)
		animate(H, alpha = full_camo_alpha + 5, time = camouflage_break, easing = LINEAR_EASING, flags = ANIMATION_END_NOW)

/obj/item/storage/backpack/marine/satchel/scout_cloak/proc/fade_out_finish(mob/living/carbon/human/H)
	if(camo_active && H.back == src)
		ADD_TRAIT(H, TRAIT_CLOAKED, TRAIT_SOURCE_EQUIPMENT(WEAR_BACK))
		to_chat(H, SPAN_BOLDNOTICE("你的披风微微闪烁，重新恢复完美伪装！"))
		animate(H, alpha = full_camo_alpha)
		current_camo = full_camo_alpha


/obj/item/storage/backpack/marine/satchel/scout_cloak/proc/wrapper_fizzle_camouflage()
	SIGNAL_HANDLER
	var/mob/wearer = src.loc
	wearer.visible_message(SPAN_DANGER("[wearer]的披风失效了！"), SPAN_DANGER("你的披风失效了！"))
	var/datum/effect_system/spark_spread/sparks = new /datum/effect_system/spark_spread
	sparks.set_up(5, 4, src)
	sparks.start()
	deactivate_camouflage(wearer, TRUE, TRUE)

/obj/item/storage/backpack/marine/satchel/scout_cloak/proc/deactivate_camouflage(mob/living/carbon/human/H, anim = TRUE, forced)
	SIGNAL_HANDLER
	if(!istype(H))
		return FALSE

	UnregisterSignal(H, list(
	COMSIG_MOB_FIRED_GUN,
	COMSIG_MOB_FIRED_GUN_ATTACHMENT,
	COMSIG_HUMAN_EXTINGUISH,
	COMSIG_MOB_DEATH,
	COMSIG_MOB_EFFECT_CLOAK_CANCEL,
	))

	if(forced)
		cloak_cooldown = world.time + 10 SECONDS

	camo_active = FALSE
	REMOVE_TRAIT(H, TRAIT_CLOAKED, TRAIT_SOURCE_EQUIPMENT(WEAR_BACK))
	H.visible_message(SPAN_DANGER("[H]闪烁着重新显现！"), SPAN_WARNING("披风的伪装功能已关闭！"), max_distance = 4)
	playsound(H.loc, 'sound/effects/cloak_scout_off.ogg', 15, TRUE)

	H.alpha = initial(H.alpha)
	H.FF_hit_evade = initial(H.FF_hit_evade)

	var/datum/mob_hud/security/advanced/SA = GLOB.huds[MOB_HUD_SECURITY_ADVANCED]
	SA.add_to_hud(H)
	var/datum/mob_hud/xeno_infection/XI = GLOB.huds[MOB_HUD_XENO_INFECTION]
	XI.add_to_hud(H)

	if(anim)
		anim(H.loc, H,'icons/mob/mob.dmi', null, "uncloak", null, H.dir)

/datum/action/item_action/specialist/toggle_cloak
	ability_primacy = SPEC_PRIMARY_ACTION_1

/datum/action/item_action/specialist/toggle_cloak/New(mob/living/user, obj/item/holder)
	..()
	name = "Toggle Cloak"
	button.name = "切换披风伪装"
	button.overlays.Cut()
	var/image/IMG = image('icons/obj/items/clothing/backpacks.dmi', button, "scout_cloak")
	button.overlays += IMG

/datum/action/item_action/specialist/toggle_cloak/can_use_action()
	var/mob/living/carbon/human/H = owner
	if(istype(H) && !H.is_mob_incapacitated() && holder_item == H.back)
		return TRUE

/datum/action/item_action/specialist/toggle_cloak/action_activate()
	. = ..()
	var/obj/item/storage/backpack/marine/satchel/scout_cloak/SC = holder_item
	SC.camouflage()

/obj/item/storage/backpack/marine/satchel/scout_cloak/invis
	full_camo_alpha = FULL_CAMO_ALPHA
	current_camo = FULL_CAMO_ALPHA
	visible_camo_alpha = VISIBLE_CAMO_ALPHA

// Welder Backpacks //

/obj/item/storage/backpack/marine/engineerpack
	name = "USCM 技术员焊接背包"
	desc = "USCM 技术员使用的专用背包，内置燃料罐，便于快速补充和使用焊炬。"
	icon_state = "welderbackpack"
	item_state = "welderbackpack"
	var/max_fuel = 260
	var/fuel_type = "fuel"
	max_storage_space = 18
	storage_slots = null
	has_gamemode_skin = FALSE
	xeno_types = null

/obj/item/storage/backpack/marine/engineerpack/Initialize()
	. = ..()
	create_reagents(max_fuel) //Lotsa refills
	reagents.add_reagent(fuel_type, max_fuel)


/obj/item/storage/backpack/marine/engineerpack/attackby(obj/item/W, mob/living/user)
	if(reagents.total_volume)
		if(iswelder(W))
			var/obj/item/tool/weldingtool/T = W
			if(T.welding)
				to_chat(user, SPAN_WARNING("好险！幸好你发现焊枪还开着，及时避免了一场灾难。"))
				return
			if(!(T.get_fuel()==T.max_fuel) && reagents.total_volume)
				reagents.trans_to(W, T.max_fuel)
				to_chat(user, SPAN_NOTICE("焊枪已补满燃料！"))
				playsound(loc, 'sound/effects/refill.ogg', 25, TRUE, 3)
				return
		else if(istype(W, /obj/item/ammo_magazine/flamer_tank))
			var/obj/item/ammo_magazine/flamer_tank/FT = W
			if(!FT.current_rounds && reagents.total_volume)
				var/fuel_available = reagents.total_volume < FT.max_rounds ? reagents.total_volume : FT.max_rounds
				reagents.remove_reagent("fuel", fuel_available)
				FT.current_rounds = fuel_available
				playsound(loc, 'sound/effects/refill.ogg', 25, TRUE, 3)
				FT.caliber = "Fuel"
				to_chat(user, SPAN_NOTICE("你用[localized_player_label(FT.caliber)]补满了[FT]。"))
				FT.update_icon()
				return
		else if(isgun(W))
			var/obj/item/weapon/gun/G = W
			for(var/slot in G.attachments)
				if(istype(G.attachments[slot], /obj/item/attachable/attached_gun/flamer))
					var/obj/item/attachable/attached_gun/flamer/F = G.attachments[slot]
					if(F.current_rounds < F.max_rounds)
						var/to_transfer = F.max_rounds - F.current_rounds
						if(to_transfer > reagents.total_volume)
							to_transfer = reagents.total_volume
						reagents.remove_reagent("fuel", to_transfer)
						F.current_rounds += to_transfer
						playsound(loc, 'sound/effects/refill.ogg', 25, TRUE, 3)
						to_chat(user, SPAN_NOTICE("你为[F]补满了燃料。"))
					else
						to_chat(user, SPAN_WARNING("[F]已经装满。"))
					return
	. = ..()

/obj/item/storage/backpack/marine/engineerpack/afterattack(obj/target, mob/user, proximity)
	if(!proximity)
		return
	if(istype(target, /obj/structure/reagent_dispensers))
		if(!(istypestrict(target, /obj/structure/reagent_dispensers/fueltank)))
			to_chat(user, SPAN_NOTICE("必须使用燃料罐填充。"))
			return
		if(reagents.total_volume < max_fuel)
			target.reagents.trans_to(src, max_fuel)
			to_chat(user, SPAN_NOTICE("你打开背包顶部的盖子，从储罐中重新加满。"))
			playsound(loc, 'sound/effects/refill.ogg', 25, TRUE, 3)
			return
		if(reagents.total_volume == max_fuel)
			to_chat(user, SPAN_NOTICE("背包已经装满！"))
			return
	..()

/obj/item/storage/backpack/marine/engineerpack/get_examine_text(mob/user)
	. = ..()
	. += "剩余[reagents.total_volume]单位燃料！"

/obj/item/storage/backpack/marine/engineerpack/satchel
	name = "USCM 技术员焊接挎包"
	desc = "USCM 技术员和工兵使用的专用挎包，内置两个小燃料罐，便于快速补充和使用焊炬。"
	icon_state = "satchel_marine_welder"
	item_state = "satchel_marine_welder"
	max_storage_space = 12
	has_gamemode_skin = FALSE
	max_fuel = 100
	worn_accessible = TRUE

/obj/item/storage/backpack/marine/engineerpack/welder_chestrig
	name = "技术员焊接胸挂"
	desc = "技术员与工兵使用的专用胸挂，带有一个中型燃料罐，便于快速补充和使用焊炬。"
	icon_state = "welder_chestrig"
	item_state = "welder_chestrig"
	max_storage_space = 12
	has_gamemode_skin = FALSE
	max_fuel = 100
	worn_accessible = TRUE

// Pyrotechnician Spec backpack fuel tank
/obj/item/storage/backpack/marine/engineerpack/flamethrower
	name = "USCM 火焰兵 G6-2 燃料罐"
	desc = "USCM 火焰兵使用的专用燃料背罐，配合 M240-T 火焰喷射器使用，并装有一个小型通用储物格。"
	icon_state = "flamethrower_tank"
	max_fuel = 500
	fuel_type = "utnapthal"
	has_gamemode_skin = FALSE

/obj/item/storage/backpack/marine/engineerpack/flamethrower/verb/remove_reagents()
	set name = "Empty canister"
	set category = "Object"

	set src in usr

	if(usr.get_active_hand() != src)
		return

	if(localized_native_alert(usr, "确定要排空[src]吗？", "排空容器", "Yes", "No") != "Yes")
		return

	reagents.clear_reagents()

	playsound(loc, 'sound/effects/refill.ogg', 25, 1, 3)
	to_chat(usr, SPAN_NOTICE("你倒空了[src]。"))
	update_icon()

//this is to revert change for the backpack that are for flametrower usage.
// so that they can use custom mix to refill those backpack
/obj/item/storage/backpack/marine/engineerpack/flamethrower/afterattack(obj/target, mob/user, proximity)
	if(!proximity)
		return
	if (!(istype(target, /obj/structure/reagent_dispensers/fueltank)))
		return

	if (reagents.total_volume >= max_fuel)
		to_chat(user, SPAN_NOTICE("背包已经装满！"))
		return

	if(reagents.total_volume < max_fuel)
		target.reagents.trans_to(src, max_fuel)
		to_chat(user, SPAN_NOTICE("你打开背包顶部的盖子，从储罐中重新加满。"))
		playsound(loc, 'sound/effects/refill.ogg', 25, TRUE, 3)
		return

/obj/item/storage/backpack/marine/engineerpack/flamethrower/attackby(obj/item/W, mob/living/user)
	if (istype(W, /obj/item/ammo_magazine/flamer_tank))
		var/obj/item/ammo_magazine/flamer_tank/FTL = W
		var/missing_volume = FTL.max_rounds - FTL.current_rounds

		//Fuel has to be standard napalm OR tank needs to be empty. We need to have a non-full tank and our backpack be dry
		if (((FTL.caliber == "UT-Napthal Fuel") || (!FTL.current_rounds)) && missing_volume && reagents.total_volume)
			var/fuel_available = reagents.total_volume < missing_volume ? reagents.total_volume : missing_volume
			reagents.remove_reagent("fuel", fuel_available)
			FTL.current_rounds = FTL.current_rounds + fuel_available
			playsound(loc, 'sound/effects/refill.ogg', 25, TRUE, 3)
			FTL.caliber = "UT-Napthal Fuel"
			to_chat(user, SPAN_NOTICE("你用[localized_player_label(FTL.caliber)]补满了[FTL]。"))
			FTL.update_icon()
	. = ..()

/obj/item/storage/backpack/marine/engineerpack/flamethrower/kit
	name = "USCM 火焰兵 G4-1 燃料罐"
	desc = "老得多的双罐燃料背架，中间有一个小型调压器。附有几条绑带，最多可挂三个待补充的喷火器燃料罐。"
	icon_state = "flamethrower_backpack"
	item_state = "flamethrower_backpack"
	max_fuel = 350
	has_gamemode_skin = FALSE
	max_storage_space = 15
	storage_slots = 3
	worn_accessible = TRUE
	can_hold = list(/obj/item/ammo_magazine/flamer_tank, /obj/item/tool/extinguisher)
	storage_flags = STORAGE_FLAGS_POUCH

//----------OTHER FACTIONS AND ERTS----------

/obj/item/storage/backpack/lightpack
	name = "轻型战斗背包"
	desc = "适合远征和短程行动的小型轻便背包。"
	icon_state = "ERT_satchel"
	worn_accessible = TRUE

/obj/item/storage/backpack/lightpack/five_slot
	max_storage_space = 15

/obj/item/storage/backpack/marine/engineerpack/ert
	name = "\improper 轻型技师焊接背包"
	desc = "供远征和短程行动使用的小型轻便背包，带有小燃料罐，能快速补充焊枪。"
	icon_state = "ERT_satchel_welder"
	has_gamemode_skin = FALSE
	worn_accessible = TRUE
	max_fuel = 180

/obj/item/storage/backpack/commando
	name = "突击队背包"
	desc = "维兰德-汤谷突击队携带的重型背包。"
	icon_state = "commandopack"
	worn_accessible = TRUE

/obj/item/storage/backpack/mcommander
	name = "陆战队指挥官背包"
	desc = "这个背包里的东西属于绝密。"
	icon_state = "marinepack"
	storage_slots = null
	max_storage_space = 30

/obj/item/storage/backpack/ivan
	name = "军械库"
	desc = "无形虚空中，诞生出比元素本身更古老的存在。它所过之处，风暴随行。"
	icon_state = "ivan_bag"
	storage_slots = 28
	worn_accessible = TRUE
	max_w_class = SIZE_MASSIVE
	can_hold = list(
		/obj/item/weapon,
	)

/obj/item/storage/backpack/ivan/Initialize()
	. = ..()
	var/list/template_guns = list(/obj/item/weapon/gun/pistol, /obj/item/weapon/gun/revolver, /obj/item/weapon/gun/shotgun, /obj/item/weapon/gun/rifle, /obj/item/weapon/gun/smg, /obj/item/weapon/gun/energy, /obj/item/weapon/gun/launcher, /obj/item/weapon/gun/launcher/grenade, /obj/item/weapon/gun/rifle/sniper)
	var/list/bad_guns = typesof(/obj/item/weapon/gun/pill) + /obj/item/weapon/gun/souto + /obj/item/weapon/gun/smg/nailgun/compact //guns that don't work for some reason
	var/list/emplacements = list(/obj/item/device/m2c_gun , /obj/item/device/m56d_gun/mounted)
	var/list/yautja_guns = typesof(/obj/item/weapon/gun/energy/yautja) + /obj/item/weapon/gun/launcher/spike
	var/list/smartguns = typesof(/obj/item/weapon/gun/smartgun)
	var/list/training_guns = list(
		/obj/item/weapon/gun/rifle/m41a/training,
		/obj/item/weapon/gun/rifle/m49a/training,
		/obj/item/weapon/gun/smg/m39/training,
		/obj/item/weapon/gun/pistol/m4a3/training,
		/obj/item/weapon/gun/pistol/vp70/training) //Ivan doesn't carry toys.

	var/list/picklist = subtypesof(/obj/item/weapon/gun) - (template_guns + bad_guns + emplacements + yautja_guns + smartguns + training_guns)
	var/random_gun = pick(picklist)
	for(var/total_storage_slots in 1 to storage_slots) //minus templates
		new random_gun(src)
		random_gun = pick(picklist)

/obj/item/storage/backpack/souto
	name = "\improper 背负式索托售货机"
	max_storage_space = 30
	desc = "索托至尊发射器的供弹机构，同时也是便携索托售货机！"
	icon_state = "supremo_pack"
	storage_slots = null
	flags_inventory = CANTSTRIP
	unacidable = TRUE
	var/internal_mag = new /obj/item/ammo_magazine/internal/souto
	worn_accessible = TRUE


//----------UPP SECTION----------

/obj/item/storage/backpack/lightpack/upp
	name = "UCP3 战斗包"
	desc = "UPP 军方制式“联盟战斗背包 MK3”。"
	icon_state = "satchel_upp"
	worn_accessible = TRUE
	max_storage_space = 15

//UPP engineer welderpack
/obj/item/storage/backpack/marine/engineerpack/upp
	name = "\improper UCP3-E 技师焊接背包"
	desc = "联盟战斗背包 Mk3 的特殊改型，带有可快速补充焊枪的小燃料罐，供进步人民联盟工兵使用。"
	icon_state = "satchel_upp_welder"
	has_gamemode_skin = FALSE
	worn_accessible = TRUE
	max_fuel = 180
	max_storage_space = 12

/obj/item/storage/backpack/marine/satchel/scout_cloak/upp
	name = "\improper V86 热隐蔽披风"
	desc = "进步人民联盟突击队常用的热光学伪装披风。"
	max_storage_space = 21

/obj/item/storage/backpack/marine/satchel/scout_cloak/upp/invis
	full_camo_alpha = FULL_CAMO_ALPHA
	current_camo = FULL_CAMO_ALPHA
	visible_camo_alpha = VISIBLE_CAMO_ALPHA

#undef FULL_CAMO_ALPHA
#undef VISIBLE_CAMO_ALPHA
#undef FULL_PVE_CAMO_ALPHA
#undef VISIBLE_PVE_CAMO_ALPHA

//----------TWE SECTION----------
/obj/item/storage/backpack/rmc
	has_gamemode_skin = FALSE

/obj/item/storage/backpack/rmc/heavy
	name = "重型 RMC 背包"
	desc = "RMC 部队的重载背包，旨在将尽可能多的装备带入战场。"
	icon_state = "backpack_large"
	item_state = "backpack_large"
	max_storage_space = 24
	bag_open_time = 3 SECONDS

/obj/item/storage/backpack/rmc/medic
	name = "RMC 医疗背包"
	desc = "TWE 军方标准载荷 RMC 战斗背包 MK3，经医疗助理改造，更符合他们的需要。"
	icon_state = "backpack_medium_medic"
	item_state = "backpack_medium_medic"
	worn_accessible = TRUE
	max_storage_space = 21

/obj/item/storage/backpack/rmc/medium
	name = "标准 RMC 背包"
	desc = "TWE 军方标准载荷 RMC 战斗背包 MK3。"
	icon_state = "backpack_medium"
	item_state = "backpack_medium"
	max_storage_space = 18

/obj/item/storage/backpack/marine/engineerpack/satchel/rmc
	name = "RMC 工程背包"
	desc = "TWE 军方制式 RMC 战斗背包 MK3，经心灵手巧的皇家工兵改造，更符合他们的需求。"
	icon_state = "backpack_sapper"
	item_state = "backpack_sapper"
	max_storage_space = 18
	max_fuel = 150
	worn_accessible = TRUE

/obj/item/storage/backpack/rmc/light
	name = "轻型 RMC 背包"
	desc = "TWE 军方轻载型 RMC 战斗背包 MK3。"
	icon_state = "backpack_small"
	item_state = "backpack_small"
	worn_accessible = TRUE
	max_storage_space = 15

/obj/item/storage/backpack/rmc/frame //One sorry sod should have to lug this about spawns in their shuttle currently
	name = "\improper 皇家陆战突击队背架"
	desc = "专为携带突击队装备设计的背包。"
	icon_state = "backpack_frame_0"
	item_state = "backpack_frame"
	max_w_class = SIZE_HUGE
	storage_slots = 7
	can_hold = list(
		/obj/item/storage/firstaid,
		/obj/item/storage/box/packet,
		/obj/item/ammo_box,
		/obj/item/mortar_shell,
	)
	cant_hold = list(
		/obj/item/ammo_box/magazine/nsg23/large = list(SKILL_DOMESTIC, SKILL_DOMESTIC_MASTER),
		/obj/item/ammo_box/magazine/mk1/large = list(SKILL_DOMESTIC, SKILL_DOMESTIC_MASTER),
		) //Jank, but amusing to think that the janitor can store these things in a frame pack whilst a marine commando can't

	var/base_icon_state = "backpack_frame"

/obj/item/storage/backpack/rmc/frame/update_icon()
	. = ..()
	icon_state = "[base_icon_state]_[length(contents)]"

/obj/item/storage/backpack/general_belt/rmc
	name = "L26 式通用杂物腰带"
	desc = "轻便的小袋，可夹在护甲上增加储物空间。这款 RMC 新型号也能固定在腰间，只是不太舒服。"
	icon_state = "rmc_general"
	item_state = "rmc_general"
	has_gamemode_skin = FALSE
	max_storage_space = 10

//----------USASF & ARMY SECTION----------

/obj/item/storage/backpack/marine/satchel/rto/navy
	name = "\improper 美国航空航天部队无线电话背包"
	desc = "用于轨道战舰与前线观测员通信的重型背包。"
	networks_receive = list(FACTION_MARINE, FACTION_NAVY)
	networks_transmit = list(FACTION_MARINE, FACTION_NAVY)

/obj/item/storage/backpack/marine/satchel/rto/army
	name = "\improper 美国陆军无线电话背包"
	desc = "用于野外陆军单位与上级指挥部通信的重型背包。"
	networks_receive = list(FACTION_MARINE, FACTION_ARMY)
	networks_transmit = list(FACTION_MARINE, FACTION_ARMY)

/obj/item/storage/backpack/marine/medic/army
	name = "\improper 陆军战斗医疗背包"
	desc = "美国陆军军医的制式背包。"
	has_gamemode_skin = FALSE

/obj/item/storage/backpack/marine/rocketpack/army
	name = "\improper IMP M22 火箭兵背包"
	desc = "专为标准 M3 和 M4 式护甲上的 IMP 安装架设计，由两根防水加固筒和底部一个小挎包组成。两根筒本来用来装火箭弹，但没人阻止你塞进别的东西。"

/obj/item/storage/backpack/marine/satchel/intel/chestrig/army
	name = "\improper 陆军远征胸挂"
	desc = "基于 IMP 的重型胸挂，单手即可快速取用，通常配发给情报军官。"
