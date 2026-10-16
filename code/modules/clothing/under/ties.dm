/obj/item/clothing/accessory
	name = "领带"
	desc = "一条新丝绸夹式领带。"
	icon = 'icons/obj/items/clothing/ties.dmi'
	icon_state = "bluetie"
	w_class = SIZE_SMALL
	var/image/inv_overlay = null //overlay used when attached to clothing.
	var/obj/item/clothing/has_suit = null //the suit the tie may be attached to
	var/slot = ACCESSORY_SLOT_DECOR
	var/list/mob_overlay = list()
	var/overlay_state = null
	var/list/accessory_icons = list(WEAR_BODY = 'icons/mob/humans/onmob/ties.dmi', WEAR_JACKET = 'icons/mob/humans/onmob/ties.dmi')
	///Jumpsuit flags that cause the accessory to be hidden. format: "x" OR "(x|y|z)" (w/o quote marks).
	var/jumpsuit_hide_states
	var/high_visibility //if it should appear on examine without detailed view
	var/removable = TRUE
	flags_equip_slot = SLOT_ACCESSORY
	sprite_sheets = list(SPECIES_MONKEY = 'icons/mob/humans/species/monkeys/onmob/ties_monkey.dmi')

/obj/item/clothing/accessory/Initialize()
	. = ..()
	inv_overlay = image("icon" = 'icons/obj/items/clothing/ties_overlay.dmi', "icon_state" = "[item_state? "[item_state]" : "[icon_state]"]")
	flags_atom |= USES_HEARING

/obj/item/clothing/accessory/Destroy()
	if(has_suit)
		has_suit.remove_accessory()
	inv_overlay = null
	. = ..()

/obj/item/clothing/accessory/proc/can_attach_to(mob/user, obj/item/clothing/C)
	return TRUE

//when user attached an accessory to S
/obj/item/clothing/accessory/proc/on_attached(obj/item/clothing/S, mob/living/user, silent)
	if(!istype(S))
		return
	has_suit = S
	forceMove(has_suit)
	has_suit.overlays += get_inv_overlay()

	if(user)
		if(!silent)
			to_chat(user, SPAN_NOTICE("你将[src]装在[has_suit]上。"))
		src.add_fingerprint(user)
	return TRUE

/obj/item/clothing/accessory/proc/on_removed(mob/living/user, obj/item/clothing/C)
	if(!has_suit)
		return
	has_suit.overlays -= get_inv_overlay()
	has_suit = null
	if(usr)
		usr.put_in_hands(src)
		src.add_fingerprint(usr)
	else
		src.forceMove(get_turf(src))
	return TRUE

//default attackby behaviour
/obj/item/clothing/accessory/attackby(obj/item/I, mob/user)
	..()

//default attack_hand behaviour
/obj/item/clothing/accessory/attack_hand(mob/user as mob)
	if(has_suit)
		return //we aren't an object on the ground so don't call parent. If overriding to give special functions to a host item, return TRUE so that the host doesn't continue its own attack_hand.
	..()

///Extra text to append when attached to another clothing item and the host clothing is examined.
/obj/item/clothing/accessory/proc/additional_examine_text()
	return "已装在上面。"

/obj/item/clothing/accessory/blue
	name = "蓝色领带"
	icon_state = "bluetie"

/obj/item/clothing/accessory/red
	name = "红色领带"
	icon_state = "redtie"

/obj/item/clothing/accessory/green
	name = "绿色领带"
	icon_state = "greentie"

/obj/item/clothing/accessory/black
	name = "黑色领带"
	icon_state = "blacktie"

/obj/item/clothing/accessory/gold
	name = "金色领带"
	icon_state = "goldtie"

/obj/item/clothing/accessory/purple
	name = "紫色领带"
	icon_state = "purpletie"

/obj/item/clothing/accessory/horrible
	name = "难看的领带"
	desc = "一条新丝绸夹式领带。这条难看得令人反胃。"
	icon_state = "horribletie"

/obj/item/clothing/accessory/stethoscope
	name = "听诊器"
	desc = "用于聆听人体声音的医疗器械，虽然过时，却仍然实用。戴上它还能让你看起来很懂行。"
	icon_state = "stethoscope"

/obj/item/clothing/accessory/stethoscope/attack(mob/living/carbon/human/being, mob/living/user)
	if(!ishuman(being) || !isliving(user))
		return

	var/body_part = parse_zone(user.zone_selected)
	if(!body_part)
		return

	var/display_body_part = list("chest" = "胸部", "groin" = "腹股沟", "head" = "头部", "eyes" = "眼睛", "mouth" = "嘴部", "right hand" = "右手", "left hand" = "左手", "right arm" = "右臂", "left arm" = "左臂", "right leg" = "右腿", "left leg" = "左腿", "right foot" = "右脚", "left foot" = "左脚")[body_part] || body_part
	var/sound = null
	if(being.stat == DEAD || (being.status_flags & FAKEDEATH))
		sound = "什么也听不到，看来对方已经一命呜呼了"
		user.visible_message("[user]将[src]贴在[being]的[display_body_part]上，仔细聆听。", "你将[src]贴在[being]的[display_body_part]上，然后……你[sound]。")
		return

	switch(body_part)
		if("chest")
			if(skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC)) // only medical personnel can take advantage of it
				if(!ishuman(being))
					return // not a human; only humans have the variable internal_organs_by_name // "cast" it a human type since we confirmed it is one
				if(isnull(being.internal_organs_by_name))
					return // they have no organs somehow
				var/datum/internal_organ/heart/heart = being.internal_organs_by_name["heart"]
				if(heart)
					switch(heart.organ_status)
						if(ORGAN_LITTLE_BRUISED)
							sound = "听到<font color='yellow'>每次心跳都伴有轻微杂音</font>，[being]的心脏可能<font color='yellow'>轻微受损</font>"
						if(ORGAN_BRUISED)
							sound = "听到<font color='orange'>异常的心跳节律</font>，可能是<font color='orange'>心脏受损</font>所致"
						if(ORGAN_BROKEN)
							sound = "听到<font color='red'>不规则心跳和额外心音</font>，可能是泵血功能受损所致，[being]的心脏显然已经<font color='red'>衰竭</font>"
						else
							sound = "听到<font color='green'>正常的心跳节律</font>，[being]的心脏显然很<font color='green'>健康</font>"
				var/datum/internal_organ/lungs/lungs = being.internal_organs_by_name["lungs"]
				if(lungs)
					if(sound)
						sound += "。你还"
					switch(lungs.organ_status)
						if(ORGAN_LITTLE_BRUISED)
							sound += "听到<font color='yellow'>[being]呼吸时伴有少许湿啰音</font>，[being]可能存在<font color='yellow'>轻微肺损伤</font>"
						if(ORGAN_BRUISED)
							sound += "听到<font color='orange'>异常呼吸音</font>，且呼吸明显困难，可能意味着<font color='orange'>肺破裂</font>"
						if(ORGAN_BROKEN)
							sound += "<font color='red'>几乎听不到呼吸音</font>，且呼吸极为困难，[being]的肺部已经<font color='red'>严重衰竭</font>"
						else
							sound += "也听到<font color='green'>正常呼吸音</font>，这说明[being]的肺部大概是<font color='green'>健康</font>的"
				else
					sound = "听不到声音，真的什么也听不到，太奇怪了"
			else
				sound = "听到许多声音……实在很难分辨"
		if("eyes","mouth")
			sound = "什么也听不到。也许这不是个聪明的主意"
		else
			sound = "零星听到一些声音，却得不到有用的信息"
	user.visible_message("[user]将[src]贴在[being]的[display_body_part]上，仔细聆听。", "你将[src]贴在[being]的[display_body_part]上，然后……你[sound]。")

//Medals
/obj/item/clothing/accessory/medal
	name = "medal"
	var/localized_name = "勋章"
	desc = "一枚勋章。"
	icon_state = "bronze"
	var/recipient_name //name of the person this is awarded to.
	var/recipient_rank
	var/medal_citation
	slot = ACCESSORY_SLOT_MEDAL
	high_visibility = TRUE
	jumpsuit_hide_states = UNIFORM_JACKET_REMOVED

/obj/item/clothing/accessory/medal/Initialize()
	. = ..()
	if(localized_name)
		name = localized_name

/obj/item/clothing/accessory/medal/on_attached(obj/item/clothing/S, mob/living/user, silent)
	. = ..()
	if(.)
		RegisterSignal(S, COMSIG_ITEM_EQUIPPED, PROC_REF(remove_medal))

/obj/item/clothing/accessory/medal/proc/remove_medal(obj/item/clothing/C, mob/user, slot)
	SIGNAL_HANDLER
	if(user.real_name != recipient_name && (slot == WEAR_BODY || slot == WEAR_JACKET))
		C.remove_accessory(user, src)
		user.drop_held_item(src)

/obj/item/clothing/accessory/medal/on_removed(mob/living/user, obj/item/clothing/C)
	. = ..()
	if(.)
		UnregisterSignal(C, COMSIG_ITEM_EQUIPPED)

/obj/item/clothing/accessory/medal/attack(mob/living/carbon/human/H, mob/living/carbon/human/user)
	if(!(istype(H) && istype(user)))
		return ..()
	if(recipient_name != H.real_name)
		to_chat(user, SPAN_WARNING("[src]并不是颁发给[H]的。"))
		return

	var/obj/item/clothing/U
	if(H.wear_suit && H.wear_suit.can_attach_accessory(src)) //Prioritises topmost garment, IE service jackets, if possible.
		U = H.wear_suit
	else
		U = H.w_uniform //Will be null if no uniform. That this allows medal ceremonies in which the hero is wearing no pants is correct and just.
	if(!U)
		if(user == H)
			to_chat(user, SPAN_WARNING("你没有穿着可以别上[src]的衣物。"))
		else
			to_chat(user, SPAN_WARNING("[H]没有穿着可以别上[src]的衣物。"))
		return

	if(user == H)
		user.visible_message(SPAN_NOTICE("[user]将[src]别在自己的[U.name]上。"),
		SPAN_NOTICE("你将[src]别在自己的[U.name]上。"))

	else
		if(user.action_busy)
			return
		if(user.a_intent != INTENT_HARM)
			user.affected_message(H,
			SPAN_NOTICE("你开始给[H]别上[src]。"),
			SPAN_NOTICE("[user]开始给你别上[src]。"),
			SPAN_NOTICE("[user]开始给[H]别上[src]。"))
			if(!do_after(user, 20, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, H))
				return
			if(!(U == H.w_uniform || U == H.wear_suit))
				to_chat(user, SPAN_WARNING("你还没别好[src]，[H]就脱下了[U.name]。"))
				return
			user.affected_message(H,
			SPAN_NOTICE("你将[src]别在[H]的[U.name]上。"),
			SPAN_NOTICE("[user]将[src]别在你的[U.name]上。"),
			SPAN_NOTICE("[user]将[src]别在[H]的[U.name]上。"))

		else
			user.affected_message(H,
			SPAN_ALERT("你开始给[H]别上[src]。"),
			SPAN_ALERT("[user]开始给你别上[src]。"),
			SPAN_ALERT("[user]开始给[H]别上[src]。"))
			if(!do_after(user, 10, INTERRUPT_ALL, BUSY_ICON_HOSTILE, H))
				return
			if(!(U == H.w_uniform || U == H.wear_suit))
				to_chat(user, SPAN_WARNING("你还没给[H]别好[src]，对方就脱下了[U.name]。"))
				return
			user.affected_message(H,
			SPAN_DANGER("你猛地将[src.name]的别针穿过[H]的[U.name]，扎进胸口。"),
			SPAN_DANGER("[user]猛地将[src.name]的别针穿过你的[U.name]，扎进你的胸口！"),
			SPAN_DANGER("[user]猛地将[src.name]的别针穿过[H]的[U.name]，扎进胸口。"))

			/*Some duplication from punch code due to attack message and damage stats.
			This does cut damage and awarding multiple medals like this to the same person will cause bleeding.*/
			H.last_damage_data = create_cause_data("macho bullshit", user)
			user.animation_attack_on(H)
			user.flick_attack_overlay(H, "punch")
			playsound(user.loc, "punch", 25, 1)
			H.apply_damage(5, BRUTE, "chest", 1)

			if(!H.stat && H.pain.feels_pain)
				if(prob(35))
					INVOKE_ASYNC(H, TYPE_PROC_REF(/mob, emote), "pain")
				else
					INVOKE_ASYNC(H, TYPE_PROC_REF(/mob, emote), "me", 1, "痛得缩了一下。")

	if(U.can_attach_accessory(src) && user.drop_held_item())
		U.attach_accessory(H, src, TRUE)

/obj/item/clothing/accessory/medal/can_attach_to(mob/user, obj/item/clothing/C)
	if(user.real_name != recipient_name)
		return FALSE
	return TRUE

/obj/item/clothing/accessory/medal/get_examine_text(mob/user)
	. = ..()

	var/citation_to_read = ""
	if(medal_citation)
		citation_to_read = "嘉奖词写着：“[medal_citation]”。"

	. += "获授者：[recipient_rank] [recipient_name]。[citation_to_read]"

/obj/item/clothing/accessory/medal/bronze
	name = "bronze medal"
	localized_name = "铜质勋章"
	desc = "一枚铜质勋章。"

/obj/item/clothing/accessory/medal/bronze/conduct
	name = MARINE_CONDUCT_MEDAL
	localized_name = "卓越品行勋章"
	desc = "表彰卓越品行的铜质勋章。虽然也是莫大的荣誉，但它是 USCM 最基础的奖章。"
	icon_state = "bronze_b"

/obj/item/clothing/accessory/medal/bronze/heart
	name = MARINE_BRONZE_HEART_MEDAL
	localized_name = "青铜之心勋章"
	desc = "表彰牺牲奉献的心形铜质勋章。通常追授给殉职者，或颁发给因公重伤者。"
	icon_state = "bronze_heart"

/obj/item/clothing/accessory/medal/bronze/science
	name = "nobel sciences award"
	localized_name = "诺贝尔科学奖章"
	desc = "表彰在科学或工程领域作出重大贡献的铜质奖章。"

/obj/item/clothing/accessory/medal/silver
	name = "silver medal"
	localized_name = "银质勋章"
	desc = "一枚银质勋章。"
	icon_state = "silver_b"

/obj/item/clothing/accessory/medal/silver/valor
	name = MARINE_VALOR_MEDAL
	localized_name = "英勇勋章"
	desc = "表彰非凡英勇行为的银质勋章。"

/obj/item/clothing/accessory/medal/silver/security
	name = "robust security award"
	localized_name = "卓越安保奖章"
	desc = "表彰为维护维兰德-汤谷商业利益而英勇战斗、作出牺牲的奖章，通常颁发给安保人员。"

/obj/item/clothing/accessory/medal/gold
	name = "gold medal"
	localized_name = "金质勋章"
	desc = "一枚尊贵的金质勋章。"
	icon_state = "gold_b"

/obj/item/clothing/accessory/medal/gold/captain
	name = "medal of captaincy"
	localized_name = "船长勋章"
	desc = "专门颁发给晋升为船长者的金质勋章，象征船长对维兰德-汤谷承担的法定职责，以及对船员毋庸置疑的指挥权。"

/obj/item/clothing/accessory/medal/gold/heroism
	name = MARINE_HEROISM_MEDAL
	localized_name = "非凡英雄勋章"
	desc = "仅由 USCM 颁发的极其罕见的金质勋章。这是至高无上的荣誉，因此获颁者寥寥无几。"

/obj/item/clothing/accessory/medal/platinum
	name = "platinum medal"
	localized_name = "铂金勋章"
	desc = "一枚极为尊贵的铂金勋章，只有将军才能在特殊情况下颁发。"
	icon_state = "platinum_b"

/obj/item/clothing/accessory/medal/bronze/service
	name = "bronze service medal"
	localized_name = "铜质服役勋章"
	desc = "表彰陆战队员在 USCM 服役的铜质勋章。非常常见，通常是陆战队员获得的第一枚勋章。"
	icon_state = "bronze"

/obj/item/clothing/accessory/medal/silver/service
	name = "silver service medal"
	localized_name = "银质服役勋章"
	desc = "表彰陆战队员在 USCM 服役的闪亮银质勋章。较为常见，代表获授者长期履行职责。"
	icon_state = "silver"
/obj/item/clothing/accessory/medal/gold/service
	name = "gold service medal"
	localized_name = "金质服役勋章"
	desc = "表彰陆战队员在 USCM 服役的尊贵金质勋章。十分罕见，代表获授者长期履行职责。"
	icon_state = "gold"
/obj/item/clothing/accessory/medal/platinum/service
	name = "platinum service medal"
	localized_name = "铂金服役勋章"
	desc = "陆战队员能够获得的最高级别服役勋章，由 USCM 将军亲手颁发，象征获授者极其漫长的服役历程。"
	icon_state = "platinum"

//Armbands
/obj/item/clothing/accessory/armband
	name = "红色臂章"
	desc = "一枚漂亮的红色臂章！"
	icon_state = "red"
	slot = ACCESSORY_SLOT_ARMBAND
	jumpsuit_hide_states = (UNIFORM_SLEEVE_CUT|UNIFORM_JACKET_REMOVED)

/obj/item/clothing/accessory/armband/cargo
	name = "货运臂章"
	desc = "船员用来标明所属部门的臂章。这枚是棕色的。"
	icon_state = "cargo"

/obj/item/clothing/accessory/armband/engine
	name = "工程臂章"
	desc = "船员用来标明所属部门的臂章。这枚是橙色的，还带有反光条！"
	icon_state = "engie"

/obj/item/clothing/accessory/armband/science
	name = "科研臂章"
	desc = "船员用来标明所属部门的臂章。这枚是紫色的。"
	icon_state = "rnd"

/obj/item/clothing/accessory/armband/hydro
	name = "水培臂章"
	desc = "船员用来标明所属部门的臂章。这枚是绿蓝相间的。"
	icon_state = "hydro"

/obj/item/clothing/accessory/armband/med
	name = "医疗臂章"
	desc = "船员用来标明所属部门的臂章。这枚是白色的。"
	icon_state = "med"

/obj/item/clothing/accessory/armband/medgreen
	name = "急救员臂章"
	desc = "船员用来标明所属部门的臂章。这枚是白绿相间的。"
	icon_state = "medgreen"

/obj/item/clothing/accessory/armband/nurse
	name = "护士臂章"
	desc = "新手护士佩戴的臂章，用来表明自己还不是医生。这枚是深红色的。"
	icon_state = "nurse"

/obj/item/clothing/accessory/armband/mpsec
	name = "宪兵臂章"
	desc = "宪兵用来表明身份的臂章。"
	icon_state = "armband_mp"
	slot = ACCESSORY_SLOT_ARMBAND
	jumpsuit_hide_states = (UNIFORM_SLEEVE_CUT|UNIFORM_JACKET_REMOVED)

//patches
/obj/item/clothing/accessory/patch
	name = "USCM 肩章"
	desc = "美国殖民地海军陆战队官兵佩戴的阻燃肩章。"
	icon_state = "uscmpatch"
	jumpsuit_hide_states = (UNIFORM_SLEEVE_CUT|UNIFORM_JACKET_REMOVED)

/obj/item/clothing/accessory/patch/falcon
	name = "USCM 坠落猎鹰肩章"
	desc = "USCM 第 4 旅第 2 营“坠落猎鹰”官兵佩戴的阻燃肩章。"
	icon_state = "fallingfalconspatch"

/obj/item/clothing/accessory/patch/devils
	name = "USCM 太阳恶魔肩章"
	desc = "USCM 第 2 师第 1 团第 3 营“太阳恶魔”官兵佩戴的阻燃肩章。"
	icon_state = "solardevilspatch"

/obj/item/clothing/accessory/patch/forecon
	name = "USCM 武装侦察部队肩章"
	desc = "USCM 武装侦察部队官兵佩戴的阻燃肩章。迅捷、无声、致命。"
	icon_state = "forecon_patch"

/obj/item/clothing/accessory/patch/sapper
	name = "USCM 战斗工兵肩章"
	desc = "USCM 第 2 殖民地支援群第 4 战斗工兵营官兵佩戴的阻燃肩章。"
	icon_state = "sapper_patch"

/obj/item/clothing/accessory/patch/royal_marines
	name = "TWE 皇家陆战突击队肩章"
	desc = "皇家陆战突击队官兵佩戴的阻燃肩章。"
	icon_state = "rmcpatch"

/obj/item/clothing/accessory/patch/twe
	name = "三世界帝国肩章"
	desc = "忠于三世界帝国的官兵佩戴的阻燃肩章，采用 TWE 的旧式标志。"
	icon_state = "twepatch"

/obj/item/clothing/accessory/patch/upp
	name = "UPP 肩章"
	desc = "进步人民联盟联合武装力量官兵佩戴的阻燃肩章。"
	icon_state = "upppatch"

/obj/item/clothing/accessory/patch/upp/airborne
	name = "UPP 空降侦察肩章"
	desc = "第 173 空降侦察排官兵佩戴的阻燃肩章。"
	icon_state = "vdvpatch"

/obj/item/clothing/accessory/patch/upp/naval
	name = "UPP 海军步兵肩章"
	desc = "UPP 海军步兵官兵佩戴的阻燃肩章。"
	icon_state = "navalpatch"

/obj/item/clothing/accessory/patch/usasf
	name = "USASF 肩章"
	desc = "美国航空航天军官兵佩戴的阻燃肩章。"
	icon_state = "usasfpatch"

/obj/item/clothing/accessory/patch/usasf/helljumper
	name = "空降救援肩章"
	desc = "USASF 第 7 空降救援营硬汉们佩戴的阻燃肩章。双脚朝下，直入地狱！"
	icon_state = "helljumperpatch"

/obj/item/clothing/accessory/patch/army
	name = "美国陆军肩章"
	desc = "美国陆军官兵佩戴的阻燃肩章。"
	icon_state = "armypatch"

/obj/item/clothing/accessory/patch/army/infantry
	name = "陆军步兵肩章"
	desc = "第 1 骑兵师官兵佩戴的阻燃肩章。"
	icon_state = "infantrypatch"

/obj/item/clothing/accessory/patch/army/spook
	name = "陆军情报肩章"
	desc = "第 525 陆军情报旅官兵佩戴的阻燃肩章。"
	icon_state = "spookpatch"

/obj/item/clothing/accessory/patch/army/armor
	name = "陆军装甲兵肩章"
	desc = "第 32 装甲旅官兵佩戴的阻燃肩章。"
	icon_state = "armorpatch"

/obj/item/clothing/accessory/patch/cmb/brazil_police
	name = "巴西殖民地军警肩章"
	desc = "巴西军警人员佩戴的阻燃肩章。"
	icon_state = "brazilpolicepatch"

//Flag patches
/obj/item/clothing/accessory/patch/ua
	name = "美洲联盟旗帜肩章"
	desc = "印有美洲联盟旗帜的阻燃肩章。这个超级大国由南北美洲及其星际殖民地组成。"
	icon_state = "uaflagpatch"

/obj/item/clothing/accessory/patch/brazil

	name = "巴西国旗肩章"
	desc = "印有巴西国旗的阻燃肩章。巴西是地球上的南美洲大国。"
	icon_state = "brazilpatch"

/obj/item/clothing/accessory/patch/usa
	name = "美国国旗肩章"
	desc = "印有美利坚合众国国旗的阻燃肩章。美国是地球上的北美洲大国，也是美洲联盟的主导强国。"
	icon_state = "usaflagpatch"

//Ribbons
/obj/item/clothing/accessory/patch/ribbon/topography
	name = "USCM 地形导航绶带"
	desc = "授予完成 USCMC 地形导航课程选拔训练的陆战队员的阻燃绶带。"
	icon_state = "topography"

/obj/item/clothing/accessory/patch/ribbon/topography/honor
	name = "USCM 荣誉地形导航绶带"
	desc = "授予以班级第一名成绩完成 USCMC 地形导航课程选拔训练的陆战队员的阻燃绶带。"
	icon_state = "topography_honor"

//misc

/obj/item/clothing/accessory/dogtags
	name = "可挂式身份牌"
	desc = "一副结实的身份牌，原本供美国殖民地海军陆战队员挂在脖子上。但由于预算调整、队员遗失身份牌，以及多起误吞事故，现在改为挂在制服或护甲上。"
	icon_state = "dogtag"
	slot = ACCESSORY_SLOT_MEDAL

/obj/item/clothing/accessory/poncho
	name = "USCM 斗篷"
	desc = "USCM 制式斗篷有适应各种气候的型号，专为制式护甲各型设计，贴合舒适，能按需保暖或散热。陆战队员还能奢求什么呢？大家亲切地叫它“安心毯”。"
	icon_state = "poncho"
	slot = ACCESSORY_SLOT_PONCHO
	var/has_variation = TRUE

/obj/item/clothing/accessory/poncho/Initialize()
	. = ..()
	if(has_variation)
		select_gamemode_skin(/obj/item/clothing/accessory/poncho)
		inv_overlay = image("icon" = 'icons/obj/items/clothing/ties_overlay.dmi', "icon_state" = "[icon_state]")
		update_icon()

/obj/item/clothing/accessory/poncho/green
	icon_state = "poncho"
	has_variation = FALSE

/obj/item/clothing/accessory/poncho/brown
	icon_state = "d_poncho"
	has_variation = FALSE

/obj/item/clothing/accessory/poncho/black
	icon_state = "u_poncho"
	has_variation = FALSE

/obj/item/clothing/accessory/poncho/blue
	icon_state = "c_poncho"
	has_variation = FALSE

/obj/item/clothing/accessory/poncho/purple
	icon_state = "s_poncho"
	has_variation = FALSE

/obj/item/clothing/accessory/poncho/green/army
	name = "磨旧的斗篷"
	desc = "制式斗篷有适应各种气候的型号，专为 M3 和 M4 系列护甲设计，舒适合身，能按需保暖或散热。士兵还能奢求什么呢？大家亲切地叫它“安心毯”。"

/obj/item/clothing/accessory/bomb //Suicide vesst
	name = "炸弹背心"
	desc = "由 C4 和普通携行背心胡乱拼成，彻头彻尾的疯子用它来制造恐怖与恐惧。"
	icon_state = "bomb_vest"
	var/datum/action/item_action/activation
	var/mob/living/wearer
	slot = ACCESSORY_SLOT_UTILITY

/obj/item/clothing/accessory/bomb/Destroy()
	wearer = null
	if(!QDELETED(activation))
		QDEL_NULL(activation)
	. = ..()

/obj/item/clothing/accessory/bomb/on_attached(obj/item/clothing/S, mob/living/carbon/human/user)
	. = ..()
	wearer = user
	activation = new /datum/action/item_action/bomb/activate(src)
	activation.give_to(wearer)

/obj/item/clothing/accessory/bomb/on_removed(mob/living/user, obj/item/clothing/C)
	. = ..()
	QDEL_NULL(activation)

/datum/action/item_action/bomb/activate
	var/activated = FALSE

/datum/action/item_action/bomb/activate/New(mob/living/user, obj/item/holder)
	..()
	name = "启动炸弹背心"
	button.name = name
	button.overlays.Cut()
	button.overlays += image('icons/obj/items/clothing/ties.dmi', button, "bomb_vest")

/datum/action/item_action/bomb/activate/can_use_action()
	var/mob/living/carbon/human/H = owner
	if(!H || H.is_mob_incapacitated(TRUE)) //Can't activate if incapacitated

		return
	if(activated) //don't detonate twice
		return
	return TRUE

/datum/action/item_action/bomb/activate/action_activate()
	. = ..()
	var/mob/living/carbon/human/H = owner
	H.visible_message(SPAN_ALERTWARNING("[H]启动了炸弹背心！快趴下！"), SPAN_ALERTWARNING("你启动了炸弹背心！见证我吧！"))
	playsound(H, 'sound/items/bomb_vest.ogg', 100, 1)
	activated = TRUE

	addtimer(CALLBACK(src, PROC_REF(detonate), FALSE), 3 SECONDS)

/datum/action/item_action/bomb/activate/proc/detonate()
	var/mob/living/carbon/human/H = owner
	var/turf/epicenter = get_turf(H)
	target.ex_act(400, null, src, H, 100)
	cell_explosion(epicenter, 150, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data(initial(name), H))
	H.gib()
	qdel(src)

//Ties that can store stuff

/obj/item/storage/internal/accessory
	storage_slots = 3

/obj/item/clothing/accessory/storage
	name = "携行装具"
	desc = "手不够用时，用它来携带物品。"
	icon_state = "webbing"
	w_class = SIZE_LARGE //too big to store in other pouches
	var/obj/item/storage/internal/hold = /obj/item/storage/internal/accessory
	slot = ACCESSORY_SLOT_UTILITY
	high_visibility = TRUE

/obj/item/clothing/accessory/storage/Initialize()
	. = ..()
	hold = new hold(src)

/obj/item/clothing/accessory/storage/Destroy()
	QDEL_NULL(hold)
	return ..()

/obj/item/clothing/accessory/storage/clicked(mob/user, list/mods)
	if(mods[ALT_CLICK] && !isnull(hold) && loc == user && !user.get_active_hand()) //To pass quick-draw attempts to storage. See storage.dm for explanation.
		return
	. = ..()

/obj/item/clothing/accessory/storage/attack_hand(mob/user as mob, mods)
	if (!isnull(hold) && hold.handle_attack_hand(user, mods))
		..(user)
	return TRUE

/obj/item/clothing/accessory/storage/MouseDrop(obj/over_object as obj)
	if (has_suit || hold)
		return

	if (hold.handle_mousedrop(usr, over_object))
		..(over_object)

/obj/item/clothing/accessory/storage/attackby(obj/item/W, mob/user)
	return hold.attackby(W, user)

/obj/item/clothing/accessory/storage/emp_act(severity)
	. = ..()
	hold.emp_act(severity)

/obj/item/clothing/accessory/storage/hear_talk(mob/M, msg)
	hold.hear_talk(M, msg)
	..()

/obj/item/clothing/accessory/storage/attack_self(mob/user)
	..()
	to_chat(user, SPAN_NOTICE("你倒空了[src]。"))
	var/turf/T = get_turf(src)
	hold.storage_close(usr)
	for(var/obj/item/I in hold.contents)
		hold.remove_from_storage(I, T)
	src.add_fingerprint(user)

/obj/item/clothing/accessory/storage/on_attached(obj/item/clothing/C, mob/living/user, silent)
	. = ..()
	if(.)
		C.w_class = w_class //To prevent monkey business.
		C.verbs += /obj/item/clothing/suit/storage/verb/toggle_draw_mode

/obj/item/clothing/accessory/storage/on_removed(mob/living/user, obj/item/clothing/C)
	. = ..()
	if(.)
		C.w_class = initial(C.w_class)
		C.verbs -= /obj/item/clothing/suit/storage/verb/toggle_draw_mode

/obj/item/storage/internal/accessory/webbing
	bypass_w_limit = list(
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/smg,
		/obj/item/ammo_magazine/sniper,
		/obj/item/ammo_magazine/plasma,
	)

/obj/item/clothing/accessory/storage/webbing
	name = "携行带"
	desc = "结实的合成棉带和搭扣组成的携行装具，随时为你分担负重。"
	icon_state = "webbing"
	hold = /obj/item/storage/internal/accessory/webbing

/obj/item/clothing/accessory/storage/webbing/five_slots
	hold = /obj/item/storage/internal/accessory/webbing/five_slots

/obj/item/storage/internal/accessory/webbing/five_slots
	storage_slots = 5

/obj/item/storage/internal/accessory/black_vest
	storage_slots = 5

/obj/item/clothing/accessory/storage/black_vest
	name = "黑色携行背心"
	desc = "结实的黑色合成棉背心，有许多口袋，可以装下你需要却拿不下的东西。"
	icon_state = "vest_black"
	hold = /obj/item/storage/internal/accessory/black_vest

/obj/item/clothing/accessory/storage/black_vest/attackby(obj/item/W, mob/living/user)
	if(HAS_TRAIT(W, TRAIT_TOOL_WIRECUTTERS) && skillcheck(user, SKILL_RESEARCH, SKILL_RESEARCH_TRAINED))
		var/components = 0
		var/obj/item/reagent_container/glass/beaker/vial
		var/obj/item/cell/battery
		for(var/obj/item in hold.contents)
			if(istype(item, /obj/item/device/radio) || istype(item, /obj/item/stack/cable_coil) || istype(item, /obj/item/device/healthanalyzer))
				components++
			else if(istype(item, /obj/item/reagent_container/hypospray) && !istype(item, /obj/item/reagent_container/hypospray/autoinjector))
				var/obj/item/reagent_container/hypospray/H = item
				if(H.mag)
					vial = H.mag
				components++
			else if(istype(item, /obj/item/cell))
				battery = item
				components++
			else
				components--
		if(components == 5)
			var/obj/item/clothing/accessory/storage/black_vest/acid_harness/AH
			if(istype(src, /obj/item/clothing/accessory/storage/black_vest/brown_vest))
				AH = new /obj/item/clothing/accessory/storage/black_vest/acid_harness/brown(get_turf(loc))
			else
				AH = new /obj/item/clothing/accessory/storage/black_vest/acid_harness(get_turf(loc))
			if(vial)
				AH.vial = vial
				AH.hold.handle_item_insertion(vial)
			AH.battery = battery
			AH.hold.handle_item_insertion(battery)
			qdel(src)
			return
	. = ..()

/obj/item/clothing/accessory/storage/black_vest/brown_vest
	name = "棕色携行背心"
	desc = "磨旧的棕色合成棉背心，有许多口袋，能解放你的双手。"
	icon_state = "vest_brown"

/obj/item/clothing/accessory/storage/black_vest/waistcoat
	name = "战术马甲"
	desc = "时髦的黑色马甲，配有许多隐蔽的收纳袋，实用与时尚兼顾，又不影响外观。"
	icon_state = "waistcoat"

/obj/item/clothing/accessory/storage/tool_webbing
	name = "工具携行带"
	desc = "棕色合成棉携行带，功能类似民用工具围裙，但更加耐用，适合野外使用。"
	hold = /obj/item/storage/internal/accessory/tool_webbing

/obj/item/clothing/accessory/storage/tool_webbing/small
	name = "小型工具携行带"
	desc = "棕色合成棉携行带，功能类似民用工具围裙，但更加耐用，适合野外使用。这是小型廉价版本。"
	hold = /obj/item/storage/internal/accessory/tool_webbing/small

/obj/item/storage/internal/accessory/tool_webbing
	storage_slots = 7
	can_hold = list(
		/obj/item/tool/screwdriver,
		/obj/item/tool/wrench,
		/obj/item/tool/weldingtool,
		/obj/item/tool/crowbar,
		/obj/item/tool/wirecutters,
		/obj/item/stack/cable_coil,
		/obj/item/device/multitool,
		/obj/item/tool/shovel/etool,
		/obj/item/weapon/gun/smg/nailgun/compact,
	)

/obj/item/storage/internal/accessory/tool_webbing/small
	storage_slots = 6

/obj/item/clothing/accessory/storage/tool_webbing/small/equipped
	hold = /obj/item/storage/internal/accessory/tool_webbing/small/equipped

/obj/item/storage/internal/accessory/tool_webbing/small/equipped/fill_preset_inventory()
	new /obj/item/tool/screwdriver(src)
	new /obj/item/tool/wrench(src)
	new /obj/item/tool/weldingtool(src)
	new /obj/item/tool/crowbar(src)
	new /obj/item/tool/wirecutters(src)
	new /obj/item/device/multitool(src)

/obj/item/clothing/accessory/storage/tool_webbing/equipped
	hold = /obj/item/storage/internal/accessory/tool_webbing/equipped

/obj/item/storage/internal/accessory/tool_webbing/equipped/fill_preset_inventory()
	new /obj/item/tool/screwdriver(src)
	new /obj/item/tool/wrench(src)
	new /obj/item/tool/weldingtool(src)
	new /obj/item/tool/crowbar(src)
	new /obj/item/tool/wirecutters(src)
	new /obj/item/stack/cable_coil(src)
	new /obj/item/device/multitool(src)

/obj/item/clothing/accessory/storage/tool_webbing/tactical
	hold = /obj/item/storage/internal/accessory/tool_webbing/tactical

/obj/item/storage/internal/accessory/tool_webbing/tactical/fill_preset_inventory()
	new /obj/item/tool/screwdriver/tactical(src)
	new /obj/item/tool/wrench(src)
	new /obj/item/tool/weldingtool/largetank(src)
	new /obj/item/tool/crowbar/tactical(src)
	new /obj/item/tool/wirecutters/tactical(src)
	new /obj/item/stack/cable_coil(src)
	new /obj/item/device/multitool(src)

/obj/item/storage/internal/accessory/surg_vest
	storage_slots = 14
	can_hold = list(
		/obj/item/tool/surgery,
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/stack/nanopaste,
	)

/obj/item/storage/internal/accessory/surg_vest/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/storage/surgical_tray))
		var/obj/item/storage/surgical_tray/ST = W
		if(!length(ST.contents))
			return
		if(length(contents) >= storage_slots)
			to_chat(user, SPAN_WARNING("手术器械携行背心已经装满了。"))
			return
		if(!do_after(user, 5 SECONDS * user.get_skill_duration_multiplier(SKILL_MEDICAL), INTERRUPT_ALL, BUSY_ICON_GENERIC))
			return
		for(var/obj/item/I in ST)
			if(length(contents) >= storage_slots)
				break
			ST.remove_from_storage(I)
			attempt_item_insertion(I, TRUE, user)
		user.visible_message("[user]将器械从[ST]转移到手术器械携行背心中。", SPAN_NOTICE("你将器械从[ST]转移到手术器械携行背心中。"), max_distance = 3)
		return
	return ..()

/obj/item/storage/internal/accessory/surg_vest/equipped/fill_preset_inventory()
	new /obj/item/tool/surgery/scalpel/pict_system(src)
	new /obj/item/tool/surgery/scalpel(src)
	new /obj/item/tool/surgery/hemostat(src)
	new /obj/item/tool/surgery/retractor(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/tool/surgery/cautery(src)
	new /obj/item/tool/surgery/circular_saw(src)
	new /obj/item/tool/surgery/surgicaldrill(src)
	new /obj/item/tool/surgery/bonegel(src)
	new /obj/item/tool/surgery/bonesetter(src)
	new /obj/item/tool/surgery/FixOVein(src)
	new /obj/item/stack/nanopaste(src)
	new /obj/item/tool/surgery/surgical_line(src)
	new /obj/item/tool/surgery/synthgraft(src)

/obj/item/clothing/accessory/storage/surg_vest
	name = "手术器械携行背心"
	desc = "专为携带手术器械设计的绿色合成棉背心。"
	icon_state = "vest_surg"
	hold = /obj/item/storage/internal/accessory/surg_vest

/obj/item/clothing/accessory/storage/surg_vest/equipped
	hold = /obj/item/storage/internal/accessory/surg_vest/equipped

/obj/item/clothing/accessory/storage/surg_vest/blue
	name = "蓝色手术器械携行背心"
	desc = "专为携带手术器械设计的哑光蓝色合成棉背心。"
	icon_state = "vest_blue"

/obj/item/clothing/accessory/storage/surg_vest/blue/equipped
	hold = /obj/item/storage/internal/accessory/surg_vest/equipped

/obj/item/clothing/accessory/storage/surg_vest/drop_blue
	name = "蓝色手术器械挂袋"
	desc = "专为携带手术器械设计的哑光蓝色合成棉挂袋。"
	icon_state = "drop_pouch_surgical_blue"

/obj/item/clothing/accessory/storage/surg_vest/drop_blue/equipped
	hold = /obj/item/storage/internal/accessory/surg_vest/equipped

/obj/item/clothing/accessory/storage/surg_vest/drop_green
	name = "绿色手术器械挂袋"
	desc = "专为携带手术器械设计的绿色合成棉挂袋。"
	icon_state = "drop_pouch_surgical_green"

/obj/item/clothing/accessory/storage/surg_vest/drop_green/equipped
	hold = /obj/item/storage/internal/accessory/surg_vest/equipped

/obj/item/clothing/accessory/storage/surg_vest/drop_green/upp
	hold = /obj/item/storage/internal/accessory/surg_vest/drop_green/upp

/obj/item/storage/internal/accessory/surg_vest/drop_green/upp/fill_preset_inventory()
	new /obj/item/tool/surgery/scalpel(src)
	new /obj/item/tool/surgery/hemostat(src)
	new /obj/item/tool/surgery/retractor(src)
	new /obj/item/tool/surgery/cautery(src)
	new /obj/item/tool/surgery/circular_saw(src)
	new /obj/item/tool/surgery/surgicaldrill(src)
	new /obj/item/tool/surgery/scalpel/pict_system(src)
	new /obj/item/tool/surgery/bonesetter(src)
	new /obj/item/tool/surgery/FixOVein(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/nanopaste(src)
	new /obj/item/tool/surgery/bonegel(src)
	new /obj/item/tool/surgery/bonegel(src)
	new /obj/item/reagent_container/blood/OMinus(src)

/obj/item/clothing/accessory/storage/surg_vest/drop_black
	name = "黑色手术器械挂袋"
	desc = "专为携带手术器械设计的战术黑色合成棉挂袋。"
	icon_state = "drop_pouch_surgical_black"

/obj/item/clothing/accessory/storage/surg_vest/drop_black/equipped
	hold = /obj/item/storage/internal/accessory/surg_vest/equipped

/obj/item/clothing/accessory/storage/knifeharness
	name = "M272 型飞刀背心"
	desc = "USCM 曾使用的老式 M272 型飞刀背心，以合成棉制成，最多可容纳 5 把刀。"
	icon_state = "vest_knives"
	hold = /obj/item/storage/internal/accessory/knifeharness

/obj/item/clothing/accessory/storage/knifeharness/attack_hand(mob/user, mods)
	if(!mods || !mods[ALT_CLICK] || !length(hold.contents))
		return ..()

	hold.contents[length(contents)].attack_hand(user, mods)

/obj/item/storage/internal/accessory/knifeharness
	storage_slots = 5
	max_storage_space = 5
	can_hold = list(
		/obj/item/tool/kitchen/utensil/knife,
		/obj/item/tool/kitchen/utensil/pknife,
		/obj/item/tool/kitchen/knife,
		/obj/item/attachable/bayonet,
		/obj/item/weapon/throwing_knife,
	)
	storage_flags = STORAGE_ALLOW_QUICKDRAW|STORAGE_FLAGS_POUCH

	COOLDOWN_DECLARE(draw_cooldown)

/obj/item/storage/internal/accessory/knifeharness/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/weapon/throwing_knife(src)

/obj/item/storage/internal/accessory/knifeharness/attack_hand(mob/user, mods)
	. = ..()

	if(!COOLDOWN_FINISHED(src, draw_cooldown))
		to_chat(user, SPAN_WARNING("你需要等一会儿才能再拔出一把刀！"))
		return FALSE

	if(length(contents))
		contents[length(contents)].attack_hand(user, mods)
		COOLDOWN_START(src, draw_cooldown, BAYONET_DRAW_DELAY)

/obj/item/storage/internal/accessory/knifeharness/_item_insertion(obj/item/inserted_item, prevent_warning = 0)
	..()
	playsound(src, 'sound/weapons/gun_shotgun_shell_insert.ogg', 15, TRUE)

/obj/item/storage/internal/accessory/knifeharness/_item_removal(obj/item/removed_item, atom/new_location)
	..()
	playsound(src, 'sound/weapons/gun_shotgun_shell_insert.ogg', 15, TRUE)

/obj/item/clothing/accessory/storage/knifeharness/duelling
	name = "装饰华丽的背带"
	desc = "用筋腱和皮革制成、装饰繁复的背带，带有两个刀环。"
	icon_state = "unathiharness2"
	hold = /obj/item/storage/internal/accessory/knifeharness/duelling

/obj/item/storage/internal/accessory/knifeharness/duelling
	storage_slots = 2
	max_storage_space = 2
	can_hold = list(
		/obj/item/weapon/unathiknife,
	)

/obj/item/storage/internal/accessory/knifeharness/duelling/fill_preset_inventory()
	new /obj/item/weapon/unathiknife(src)
	new /obj/item/weapon/unathiknife(src)

/obj/item/clothing/accessory/storage/droppouch
	name = "挂袋"
	desc = "方便携带零散物品的小袋。"
	icon_state = "drop_pouch"
	hold = /obj/item/storage/internal/accessory/drop_pouch

/obj/item/clothing/accessory/storage/droppouch/upp
	icon_state = "upp_drop_pouch_alt"

/obj/item/clothing/accessory/storage/droppouch/rmc
	icon_state = "rmc_drop_pouch_alt"

/obj/item/storage/internal/accessory/drop_pouch
	w_class = SIZE_LARGE //Allow storage containers that's medium or below
	storage_slots = null
	max_w_class = SIZE_MEDIUM
	max_storage_space = 8 //weight system like backpacks, hold enough for 2 medium (normal) size items, or 4 small items, or 8 tiny items
	cant_hold = list( //Prevent inventory powergame
		/obj/item/storage/firstaid,
		/obj/item/storage/bible,
		/obj/item/storage/toolkit,
		)
	storage_flags = NONE //no verb, no quick draw, no tile gathering

/obj/item/clothing/accessory/storage/smallpouch
	name = "小型收纳袋"
	desc = "用来携带少量物品的小袋，通常装有单兵急救包的物资。"
	icon_state = "pouch"
	hold = /obj/item/storage/internal/accessory/smallpouch

/obj/item/clothing/accessory/storage/smallpouch/upp
	icon_state = "upp_pouch_alt"

/obj/item/clothing/accessory/storage/smallpouch/rmc
	icon_state = "rmc_pouch_alt"

/obj/item/storage/internal/accessory/smallpouch
	w_class = SIZE_LARGE
	max_w_class = SIZE_SMALL
	storage_flags = NONE
	storage_slots = 4

/obj/item/clothing/accessory/storage/holster
	name = "肩部枪套"
	desc = "带有附袋的手枪套，还可容纳两个弹匣或快速装弹器。"
	icon_state = "holster"
	high_visibility = TRUE
	hold = /obj/item/storage/internal/accessory/holster

/obj/item/storage/internal/accessory/holster
	w_class = SIZE_LARGE
	max_w_class = SIZE_MEDIUM
	var/obj/item/weapon/gun/current_gun
	var/sheatheSound = 'sound/weapons/gun_pistol_sheathe.ogg'
	var/drawSound = 'sound/weapons/gun_pistol_draw.ogg'
	storage_flags = STORAGE_ALLOW_QUICKDRAW|STORAGE_FLAGS_POUCH
	can_hold = list(

//Can hold variety of pistols and revolvers together with ammo for them. Can also hold the flare pistol and signal/illumination flares.
	/obj/item/weapon/gun/pistol,
	/obj/item/weapon/gun/energy/taser,
	/obj/item/weapon/gun/revolver,
	/obj/item/ammo_magazine/pistol,
	/obj/item/ammo_magazine/revolver,
	/obj/item/weapon/gun/flare,
	/obj/item/device/flashlight/flare
	)

/obj/item/storage/internal/accessory/holster/on_stored_atom_del(atom/movable/AM)
	if(AM == current_gun)
		current_gun = null

/obj/item/clothing/accessory/storage/holster/attack_hand(mob/user, mods)
	var/obj/item/storage/internal/accessory/holster/H = hold
	if(H.current_gun && ishuman(user) && (loc == user || has_suit))
		if(mods && mods[ALT_CLICK] && length(H.contents) > 1) //Withdraw the most recently inserted magazine, if possible.
			var/obj/item/I = H.contents[length(H.contents)]
			if(isgun(I))
				I = H.contents[length(H.contents) - 1]
			I.attack_hand(user)
		else
			H.current_gun.attack_hand(user)
		return

	..()

/obj/item/storage/internal/accessory/holster/can_be_inserted(obj/item/W, mob/user, stop_messages = FALSE)
	if( ..() ) //If the parent did their thing, this should be fine. It pretty much handles all the checks.
		if(isgun(W))
			if(current_gun)
				if(!stop_messages)
					to_chat(usr, SPAN_WARNING("[src]里已经有[W]了。"))
				return
		else //Must be ammo.
			var/ammo_slots = storage_slots - 1 //We have a slot reserved for the gun
			var/ammo_stored = length(contents)
			if(current_gun)
				ammo_stored--
			if(ammo_stored >= ammo_slots)
				if(!stop_messages)
					to_chat(usr, SPAN_WARNING("[src]装不下更多弹匣了。"))
				return
		return 1

/obj/item/storage/internal/accessory/holster/_item_insertion(obj/item/W)
	if(isgun(W))
		current_gun = W //If there's no active gun, we want to make this our gun
		playsound(src, sheatheSound, 15, TRUE)
	. = ..()

/obj/item/storage/internal/accessory/holster/_item_removal(obj/item/W)
	if(isgun(W))
		current_gun = null
		playsound(src, drawSound, 15, TRUE)
	. = ..()

/obj/item/clothing/accessory/storage/holster/armpit
	name = "肩部枪套"
	desc = "磨损的手枪套，非常适合隐蔽携带。"
	icon_state = "holster"

/obj/item/clothing/accessory/storage/holster/waist
	name = "腰部枪套"
	desc = "一个手枪套。"
	icon_state = "holster_hip"
	item_state = "holster_hip"

//Knife sheath, for the really big kinds of knives you get in the loadout
//Butchered holster code

/obj/item/clothing/accessory/storage/sheath
	name = "大型刀鞘"
	desc = "做工精良的皮革刀鞘，看起来足以容纳一把大刀，勉强还能塞进一把砍刀。"
	icon_state = "holster_knife"
	high_visibility = TRUE
	hold = /obj/item/storage/internal/accessory/sheath

/obj/item/storage/internal/accessory/sheath
	storage_slots = 1
	w_class = SIZE_LARGE
	max_w_class = SIZE_LARGE
	var/obj/item/weapon/current_blade
	var/sheatheSound = 'sound/handling/holsterin.ogg'
	var/drawSound = 'sound/handling/holsterout.ogg'
	storage_flags = STORAGE_ALLOW_QUICKDRAW
	can_hold = list(
		/obj/item/weapon/knife/marine/bowie,
		/obj/item/weapon/knife/marine/bowie/kukri,
		/obj/item/weapon/sword/machete,
		/obj/item/weapon/sword/machete/arnold,
		/obj/item/weapon/sword/machete/arnold/weak,
	)

/obj/item/storage/internal/accessory/sheath/on_stored_atom_del(atom/movable/AM)
	if(AM == current_blade)
		current_blade = null

/obj/item/clothing/accessory/storage/sheath/attack_hand(mob/user, mods)
	var/obj/item/storage/internal/accessory/sheath/S = hold
	if(S.current_blade && ishuman(user) && (loc == user || has_suit))
		S.current_blade.attack_hand(user)
		return

	..()

/obj/item/storage/internal/accessory/sheath/can_be_inserted(obj/item/W, mob/user, stop_messages = FALSE)
	if( ..() ) //If the parent did their thing, this should be fine. It pretty much handles all the checks.
		if(isweapon(W))
			if(current_blade)
				if(!stop_messages)
					to_chat(usr, SPAN_WARNING("[src]里已经有[W]了。"))
				return
		return 1

/obj/item/storage/internal/accessory/sheath/_item_insertion(obj/item/W)
	if(isweapon(W))
		current_blade = W //If there's no active gun, we want to make this our gun
		playsound(src, sheatheSound, 15, TRUE)
	. = ..()

/obj/item/storage/internal/accessory/sheath/_item_removal(obj/item/W)
	if(isweapon(W))
		current_blade = null
		playsound(src, drawSound, 15, TRUE)
	. = ..()

/*
	Holobadges are worn on the belt or neck, and can be used to show that the holder is an authorized
	Security agent - the user details can be imprinted on the badge with a Security-access ID card,
	or they can be emagged to accept any ID for use in disguises.
*/

/obj/item/clothing/accessory/holobadge

	name = "全息警徽"
	desc = "这枚发出蓝光的警徽表明持有者就是法律的化身。"
	icon_state = "holobadge"
	flags_equip_slot = SLOT_WAIST
	jumpsuit_hide_states = UNIFORM_JACKET_REMOVED

	var/stored_name = null

/obj/item/clothing/accessory/holobadge/cord
	icon_state = "holobadge-cord"
	flags_equip_slot = SLOT_FACE

/obj/item/clothing/accessory/holobadge/attack_self(mob/user)
	..()

	if(!stored_name)
		to_chat(user, "还没刷入身份信息就挥舞警徽，实在没什么意义。")
		return
	if(isliving(user))
		user.visible_message(SPAN_DANGER("[user]出示了维兰德-汤谷内部安保执法授权徽章。\n上面写着：[stored_name]，维兰德-汤谷安保。"),SPAN_DANGER("你出示了维兰德-汤谷内部安保执法授权徽章。\n上面写着：[stored_name]，维兰德-汤谷安保。"))

/obj/item/clothing/accessory/holobadge/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/card/id))

		var/obj/item/card/id/id_card = null

		if(istype(O, /obj/item/card/id))
			id_card = O

		if(ACCESS_MARINE_BRIG in id_card.access)
			to_chat(user, "你将身份卡信息写入警徽。")
			stored_name = id_card.registered_name
			name = "全息警徽（[stored_name]）"
			desc = "这枚发出蓝光的警徽表明[stored_name]就是法律的化身。"
		else
			to_chat(user, "你的权限不足，[src]拒绝了操作。")
		return
	..()

/obj/item/clothing/accessory/holobadge/attack(mob/living/carbon/human/M, mob/living/user)
	if(isliving(user))
		user.visible_message(SPAN_DANGER("[user]凑到[M]面前，执意把[src]怼到对方脸上。"),SPAN_DANGER("你凑到[M]面前，执意把[src]怼到对方脸上。你就是法律。"))

/obj/item/storage/box/holobadge
	name = "全息警徽盒"
	desc = "一个声称装有全息警徽的盒子。"

/obj/item/storage/box/holobadge/New()
	new /obj/item/clothing/accessory/holobadge(src)
	new /obj/item/clothing/accessory/holobadge(src)
	new /obj/item/clothing/accessory/holobadge(src)
	new /obj/item/clothing/accessory/holobadge(src)
	new /obj/item/clothing/accessory/holobadge/cord(src)
	new /obj/item/clothing/accessory/holobadge/cord(src)
	..()
	return

/obj/item/clothing/accessory/storage/owlf_vest
	name = "\improper OWLF 特工背心"
	desc = "外观精致的防弹背心，用于安装在制服上。" //No stats for these yet, just placeholder implementation.
	icon = 'icons/obj/items/clothing/ties.dmi'
	icon_state = "owlf_vest"
	item_state = "owlf_vest"

/obj/item/clothing/accessory/flak
	name = "M67 防破片背心"
	desc = "运输机机组等作战支援人员穿着的旧式防破片背心，智能机枪手偶尔也会使用。比后继的 M70 舒适得多，可穿在大多数战斗护甲内，但防弹能力不尽人意。"
	icon_state = "flak"
	item_state = "flak"
	w_class = SIZE_MEDIUM
	var/tucked_in = FALSE

/obj/item/clothing/accessory/flak/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("<b>拿在手中使用</b>即可切换穿着方式。")

/obj/item/clothing/accessory/flak/attack_self(mob/user)
	..()

	tucked_in = !tucked_in
	if(tucked_in)
		icon_state = "[initial(icon_state)]_slim"
		user.visible_message(SPAN_NOTICE("[user]收起了[src]的袖子。"), SPAN_NOTICE("你收起了[src]的袖子。"))
	else
		icon_state = initial(icon_state)
		user.visible_message(SPAN_NOTICE("[user]决定让[src]保持蓬松舒适的样子。"), SPAN_NOTICE("你决定让[src]保持蓬松舒适的样子。"))
	item_state = icon_state

/obj/item/clothing/accessory/flak/od
	icon_state = "flakod"
	item_state = "flakod"

//===========================//Wrist-worn accessories, just watches currently\\================================\\

/obj/item/clothing/accessory/wrist
	name = "手环"
	desc = "用布条制成的简单手环。"
	icon_state = "bracelet"
	item_state = null
	slot = ACCESSORY_SLOT_WRIST_L
	var/which_wrist = "左手腕"

/obj/item/clothing/accessory/wrist/get_examine_text(mob/user)
	. = ..()

	switch(slot)
		if(ACCESSORY_SLOT_WRIST_L)
			which_wrist = "左手腕"
		if(ACCESSORY_SLOT_WRIST_R)
			which_wrist = "右手腕"
	. += "它将戴在[which_wrist]上。"

/obj/item/clothing/accessory/wrist/additional_examine_text()
	return "戴在[which_wrist]上。"

/obj/item/clothing/accessory/wrist/attack_self(mob/user)
	..()

	switch(slot)
		if(ACCESSORY_SLOT_WRIST_L)
			slot = ACCESSORY_SLOT_WRIST_R
			to_chat(user, SPAN_NOTICE("[src]将戴在右手腕上。"))
		if(ACCESSORY_SLOT_WRIST_R)
			slot = ACCESSORY_SLOT_WRIST_L
			to_chat(user, SPAN_NOTICE("[src]将戴在左手腕上。"))

/obj/item/clothing/accessory/wrist/watch
	name = "精工脉搏计腕表"
	desc = "S234-501A 型耐用石英腕表，配发给大多数完成基础训练的殖民地陆战队员。"
	icon_state = "wristwatch_basic"
	item_state = "wristwatch_black"
	w_class = SIZE_SMALL
	flags_equip_slot = SLOT_HANDS

/obj/item/clothing/accessory/wrist/watch/get_examine_text(mob/user)
	. = ..()

	. += "显示时间：[SPAN_NOTICE("[worldtime2text()]")]"

/obj/item/clothing/accessory/wrist/watch/additional_examine_text()
	. = ..()

	. += "显示时间：[SPAN_NOTICE("[worldtime2text()]")]"

/obj/item/storage/box/watch_box
	name = "\improper 精工脉搏计腕表收纳盒"
	desc = "坚固耐用的收纳盒，在不佩戴时妥善保护昂贵的腕表。"
	icon = 'icons/obj/items/storage/kits.dmi'
	icon_state = "pdt_box"
	can_hold = list(/obj/item/clothing/accessory/wrist/watch)
	foldable = /obj/item/stack/sheet/cardboard
	storage_slots = 1
	w_class = SIZE_SMALL
	max_w_class = SIZE_SMALL

/obj/item/storage/box/watch_box/fill_preset_inventory()
	new /obj/item/clothing/accessory/wrist/watch(src)

/obj/item/clothing/accessory/wrist/watch/bishop
	name = "精工 7A28-6000 腕表"
	desc = "一款精致的黑色腕表。一旦正确校时，便能始终准确走时。献给追求精准的鉴赏家。"
	icon_state = "wristwatch_bishop"
	item_state = "wristwatch_black"

/obj/item/storage/box/watch_box/bishop
	name = "\improper 精工 7A28-6000 腕表收纳盒"

/obj/item/storage/box/watch_box/bishop/fill_preset_inventory()
	new /obj/item/clothing/accessory/wrist/watch/bishop(src)

/obj/item/clothing/accessory/wrist/watch/ripley
	name = "精工 7A28-7000 腕表"
	desc = "这款不对称腕表内置开创性的指针式石英计时机芯，适合那些在众人倒下后仍能屹立不倒的人。"
	icon_state = "wristwatch_ripley"
	item_state = "wristwatch_silver"

/obj/item/storage/box/watch_box/ripley
	name = "\improper 精工 7A28-7000 腕表收纳盒"

/obj/item/storage/box/watch_box/ripley/fill_preset_inventory()
	new /obj/item/clothing/accessory/wrist/watch/ripley(src)

/obj/item/clothing/accessory/wrist/watch/burke
	name = "精工 H556-5050 腕表"
	desc = "面向银河各地初级主管和“公司人”的高档腕表。耀眼，却不过分张扬。"
	icon_state = "wristwatch_burke"
	item_state = "wristwatch_silver"

/obj/item/storage/box/watch_box/burke
	name = "\improper 精工 H556-5050 腕表收纳盒"

/obj/item/storage/box/watch_box/burke/fill_preset_inventory()
	new /obj/item/clothing/accessory/wrist/watch/burke(src)

/obj/item/clothing/accessory/wrist/watch/dallas
	name = "萨马尼 E-125 腕表"
	desc = "以“精准数字腕表的新曙光”为宣传口号的 E-125，深受民用航空航天业人士欢迎。"
	icon_state = "wristwatch_dallas"
	item_state = "wristwatch_fancy"

/obj/item/storage/box/watch_box/dallas
	name = "\improper 萨马尼 E-125 腕表收纳盒"

/obj/item/storage/box/watch_box/dallas/fill_preset_inventory()
	new /obj/item/clothing/accessory/wrist/watch/dallas(src)

//===========================//CUSTOM ARMOR COSMETIC PLATES\\================================\\

/obj/item/clothing/accessory/pads
	name = "\improper M3 肩甲"
	desc = "M3 护甲系统的附加护甲，抵挡擦边攻击，并遮护胸甲的臂部开口，防御弹片。"
	icon_state = "pads"
	item_state = "pads"
	slot = ACCESSORY_SLOT_DECORARMOR

/obj/item/clothing/accessory/pads/Initialize(mapload)
	. = ..()
	if(!(flags_atom & NO_SNOW_TYPE))
		select_gamemode_skin(type)
	update_icon()

/obj/item/clothing/accessory/pads/bracers
	name = "\improper M3 护臂"
	desc = "M3 护甲系统的附加护甲。一对保护前臂的复合防弹护臂，带有固定绑带，防止上下滑动。"
	icon_state = "bracers"
	item_state = "bracers"
	slot = ACCESSORY_SLOT_DECORBRACER

/obj/item/clothing/accessory/pads/bracers/standard
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/accessory/pads/neckguard
	name = "\improper M3 护颈"
	desc = "M3 护甲系统的附加护甲。简单的聚合物防弹板，用于抵挡跳弹和弹片。"
	icon_state = "neckguard"
	item_state = "neckguard"
	slot = ACCESSORY_SLOT_DECORNECK

/obj/item/clothing/accessory/pads/neckguard/uacg
	desc = "UACG M3 护甲系统的附加护甲。简单的聚合物防弹板，用于抵挡跳弹和弹片。"
	icon_state = "neckguard_uacg"
	item_state = "neckguard_uacg"
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/accessory/pads/greaves
	name = "\improper M3 护胫"
	desc = "M3 护甲系统的附加护甲。轻质聚合物双片式护板包覆小腿，防御弹片和手枪弹。"
	icon_state = "shinguards"
	item_state = "shinguards"
	slot = ACCESSORY_SLOT_DECORSHIN

/obj/item/clothing/accessory/pads/greaves/standard
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/accessory/pads/kneepads
	name = "\improper M3 护膝"
	desc = "M3 护甲系统的附加护甲。耐冲击强化外壳与聚合物内衬能抵挡弹片和低威力弹药。"
	icon_state = "thighguards"
	item_state = "thighguards"
	slot = ACCESSORY_SLOT_DECORKNEE

/obj/item/clothing/accessory/pads/kneepads/standard
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/accessory/pads/groin
	name = "\improper M3 腹股沟护板"
	desc = "M3 护甲系统的附加护甲。剪切增稠液态护甲覆盖腹部和腹股沟，生殖器部位另有强化碳化硼迎弹面。扣装于 M3 胸甲内侧。"
	icon_state = "groinplate"
	item_state = "groinplate"
	slot = ACCESSORY_SLOT_DECORGROIN

/obj/item/clothing/accessory/pads/groin/uacg
	desc = "UACG M3 护甲系统的附加护甲。剪切增稠液态护甲覆盖腹部和腹股沟，生殖器部位另有强化碳化硼迎弹面。扣装于 M3 胸甲内侧。"
	icon_state = "groinplate_uacg"
	item_state = "groinplate_uacg"
	slot = ACCESSORY_SLOT_DECORGROIN
	flags_atom = NO_SNOW_TYPE


//===========================//USASF CUSTOM ARMOR PLATES\\================================\\

/obj/item/clothing/accessory/pads/navy
	name = "\improper M4 肩甲"
	desc = "USASF M4 护甲系统的附加护甲，抵挡擦边攻击，并遮护胸甲的臂部开口，防御弹片。"
	icon_state = "u_pads"
	item_state = "u_pads"
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/accessory/pads/greaves/navy
	name = "\improper M4 护胫"
	desc = "M4 护甲系统的附加护甲。轻质聚合物双片式护板包覆小腿，防御弹片和手枪弹。"
	icon_state = "u_shinguards"
	item_state = "u_shinguards"
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/accessory/pads/groin/navy
	name = "\improper M4 腹股沟护板"
	desc = "USASF M4 护甲系统的附加护甲。剪切增稠液态护甲覆盖腹部和腹股沟，生殖器部位另有强化碳纤维复合迎弹面。扣装于 M3 胸甲内侧。"
	icon_state = "u_groinplate"
	item_state = "u_groinplate"
	slot = ACCESSORY_SLOT_DECORGROIN

//===========================//UPP CUSTOM ARMOR PLATES\\================================\\

/obj/item/clothing/accessory/upppads
	name = "\improper 6B90 臂甲"
	desc = "为 6B90 护甲系统设计的臂甲。"
	icon_state = "upp_arms"
	item_state = "upp_arms"
	slot = ACCESSORY_SLOT_DECORARMOR

/obj/item/clothing/accessory/upppads/legs
	name = "\improper 6B90 护腿"
	desc = "为 6B90 护甲系统设计的护胫。"
	icon_state = "upp_greaves"
	item_state = "upp_greaves"
	slot = ACCESSORY_SLOT_DECORSHIN

/obj/item/clothing/accessory/upppads/crotch
	name = "\improper 6B90 护裆"
	desc = "为 6B90 护甲系统设计的护裆板。"
	icon_state = "upp_crotch"
	item_state = "upp_crotch"
	slot = ACCESSORY_SLOT_DECORGROIN

//===========================//TWE CUSTOM ARMOR PLATES\\================================\\

/obj/item/clothing/accessory/twepads
	name = "\improper 红隼肩垫"
	desc = "为红隼护甲系统设计的肩垫。"
	icon_state = "rmc_arms"
	item_state = "rmc_arms"
	slot = ACCESSORY_SLOT_DECORARMOR

/obj/item/clothing/accessory/twepads/legs
	name = "\improper 红隼护腿"
	desc = "为红隼护甲系统设计的护胫。"
	icon_state = "rmc_greaves"
	item_state = "rmc_greaves"
	slot = ACCESSORY_SLOT_DECORSHIN

//===========================//CUSTOM ARMOR PAINT\\================================\\

/obj/item/clothing/accessory/paint
	name = "骷髅护甲涂料"
	desc = "用于在陆战队护甲上绘制骷髅图案的一组涂料。"
	icon_state = "skull"
	item_state = "skull"
	slot = ACCESSORY_SLOT_PAINT

/obj/item/clothing/accessory/paint/heart
	name = "爱心护甲涂料"
	desc = "用于在陆战队护甲上绘制爱心图案的一组涂料。"
	icon_state = "heart"
	item_state = "heart"

/obj/item/clothing/accessory/paint/medic
	name = "红十字护甲涂料"
	desc = "用于在陆战队护甲上绘制红十字的一组涂料。"
	icon_state = "medic"
	item_state = "medic"

/obj/item/clothing/accessory/paint/uaflag
	name = "美洲联盟旗帜护甲涂料"
	desc = "用于在陆战队护甲上绘制红、白、黑三色旗帜的一组涂料。"
	icon_state = "uaflag"
	item_state = "uaflag"

/obj/item/clothing/accessory/paint/usflag
	name = "美国国旗护甲涂料"
	desc = "用于在陆战队护甲上绘制红、白、蓝三色旗帜的一组涂料。"
	icon_state = "usflag"
	item_state = "usflag"

/obj/item/clothing/accessory/paint/target
	name = "靶标护甲涂料"
	desc = "用于在陆战队护甲上绘制靶标图案的一组涂料。"
	icon_state = "target"
	item_state = "target"

/obj/item/clothing/accessory/paint/alcoholism
	name = "笑脸护甲涂料"
	desc = "用于在陆战队护甲上绘制笑脸的一组涂料。"
	icon_state = "smileyface"
	item_state = "smileyface"

/obj/item/clothing/accessory/paint/melancholy
	name = "无表情脸护甲涂料"
	desc = "用于在陆战队护甲上绘制脸部图案的一组涂料，不过这张脸显得漠不关心。"
	icon_state = "neutralface"
	item_state = "neutralface"

/obj/item/clothing/accessory/paint/cross
	name = "十字架护甲涂料"
	desc = "用于在陆战队护甲上绘制宗教符号的一组涂料。"
	icon_state = "cross"
	item_state = "cross"

/obj/item/clothing/accessory/paint/inscription
	name = "文字护甲涂料"
	desc = "用于在陆战队护甲上写下一段话的一组涂料。"
	icon_state = "inscription"
	item_state = "inscription"

/obj/item/clothing/accessory/paint/fire
	name = "火焰护甲涂料"
	desc = "用于在陆战队护甲上绘制炽热火焰的一组涂料。"
	icon_state = "mixtape"
	item_state = "mixtape"

/obj/item/clothing/accessory/paint/sg
	name = "迷彩涂料"
	desc = "供智能机枪手涂抹在承重背带上的一组涂料，使其色调更深。"
	icon_state = "blacksg"
	item_state = "blacksg"
	slot = ACCESSORY_SLOT_SGPAINT

//===========================//CUSTOM ARMOR WEBBING\\================================\\

/obj/item/clothing/accessory/storage/webbing/m3
	name = "\improper M3 型携行带"
	desc = "由结实的合成棉带和搭扣组成，适配 USCMC 制式 M3 型陆战队护甲。这是用于通用收纳的精简型号。"
	icon_state = "m3webbing"
	hold = /obj/item/storage/internal/accessory/webbing/m3generic
	slot = ACCESSORY_SLOT_M3UTILITY
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/accessory/storage/webbing/m3/Initialize(mapload)
	. = ..()
	if(!(flags_atom & NO_SNOW_TYPE))
		select_gamemode_skin(type)
	update_icon()


/obj/item/storage/internal/accessory/webbing/m3generic
	cant_hold = list(
		/obj/item/ammo_magazine/handful/shotgun,
		/obj/item/ammo_magazine/rifle,
	)

/obj/item/clothing/accessory/storage/webbing/m3/mag
	name = "\improper M3 型弹匣携行带"
	desc = "M3 型携行带的变型，配有脉冲步枪弹匣袋。"
	icon_state = "m3webbingmag"
	hold = /obj/item/storage/internal/accessory/webbing/m3mag

/obj/item/storage/internal/accessory/webbing/m3mag
	can_hold = list(
		/obj/item/attachable/bayonet,
		/obj/item/weapon/knife,
		/obj/item/device/flashlight/flare,
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/m60,
		/obj/item/ammo_magazine/smg,
		/obj/item/ammo_magazine/pistol,
		/obj/item/ammo_magazine/revolver,
		/obj/item/ammo_magazine/sniper,
		/obj/item/ammo_magazine/handful,
		/obj/item/explosive/grenade,
		/obj/item/explosive/mine,
		/obj/item/reagent_container/food/snacks,
		/obj/item/ammo_magazine/plasma,
	)
	bypass_w_limit = list(
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/smg,
		/obj/item/ammo_magazine/plasma,
	)

//Partial Pre-load For Props

/obj/item/clothing/accessory/storage/webbing/m3/mag/mk1
	hold = /obj/item/storage/internal/accessory/webbing/m3mag/mk1

/obj/item/storage/internal/accessory/webbing/m3mag/mk1/fill_preset_inventory()
	new /obj/item/ammo_magazine/rifle/m41aMK1(src)
	new /obj/item/ammo_magazine/rifle/m41aMK1(src)

//===

/obj/item/clothing/accessory/storage/webbing/m3/shotgun
	name = "\improper M3 型霰弹携行带"
	desc = "略作改装的 M3 型手榴弹携行带，适用于 12 号霰弹。"
	icon_state = "m3webbingshotgun"
	hold = /obj/item/storage/internal/accessory/black_vest/m3shotgun

/obj/item/storage/internal/accessory/black_vest/m3shotgun
	can_hold = list(
		/obj/item/ammo_magazine/handful,
	)

/obj/item/clothing/accessory/storage/webbing/m3/small
	name = "\improper M3 型小袋携行带"
	desc = "配有各种口袋和收纳袋的 M3 型携行带，可携带多种小型物品。"
	icon_state = "m3webbingsmall"
	hold = /obj/item/storage/internal/accessory/black_vest/m3generic
	slot = ACCESSORY_SLOT_M3UTILITY

//Pre-load For Army Props
//===
/obj/item/clothing/accessory/storage/webbing/m3/small/army
	name = "\improper PBAS 携行带"
	desc = "结实的携行带，适配美国陆军制式防护系统，配有各种口袋和收纳袋，可携带多种小型物品。"
	icon_state = "armywebbing"
	hold = /obj/item/storage/internal/accessory/black_vest/m3generic/army

/obj/item/storage/internal/accessory/black_vest/m3generic/army/fill_preset_inventory()
	new /obj/item/storage/box/mre(src)
	new /obj/item/reagent_container/food/drinks/flask/canteen(src)
	new /obj/item/tool/crowbar/tactical(src)
	new /obj/item/tool/shovel/etool(src)

/obj/item/clothing/accessory/storage/webbing/m3/small/army/alt
	hold = /obj/item/storage/internal/accessory/black_vest/m3generic/armyalt

/obj/item/storage/internal/accessory/black_vest/m3generic/armyalt/fill_preset_inventory()
	new /obj/item/storage/box/mre(src)
	new /obj/item/reagent_container/food/drinks/flask/canteen(src)
	new /obj/item/tool/crowbar/tactical(src)
	new /obj/item/tool/shovel/etool(src)
	new /obj/item/explosive/plastic/breaching_charge(src)

/obj/item/clothing/accessory/storage/webbing/m3/small/army/leader
	hold = /obj/item/storage/internal/accessory/black_vest/m3generic/armyleader

/obj/item/storage/internal/accessory/black_vest/m3generic/armyleader/fill_preset_inventory()
	new /obj/item/storage/box/mre(src)
	new /obj/item/reagent_container/food/drinks/flask/canteen(src)
	new /obj/item/tool/crowbar/tactical(src)
	new /obj/item/tool/shovel/etool(src)
	new /obj/item/device/binoculars/range/designator(src)

//===

/obj/item/clothing/accessory/storage/webbing/m3/m40
	name = "\improper M3 型手榴弹携行带"
	desc = "M3 型携行带的变型，带有收纳 M40 壳体手榴弹的挂环。"
	icon_state = "m3webbingm40"
	hold = /obj/item/storage/internal/accessory/black_vest/m3grenade

/obj/item/storage/internal/accessory/black_vest/m3grenade
	storage_slots = 7
	can_hold = list(
		/obj/item/explosive/grenade/high_explosive,
		/obj/item/explosive/grenade/high_explosive/super,
		/obj/item/explosive/grenade/high_explosive/airburst/canister,
		/obj/item/explosive/grenade/high_explosive/impact/heap,
		/obj/item/explosive/grenade/high_explosive/impact/tmfrag,
		/obj/item/explosive/grenade/high_explosive/impact/flare,
		/obj/item/explosive/grenade/high_explosive/training,
		/obj/item/explosive/grenade/incendiary,
		/obj/item/explosive/grenade/smokebomb,
		/obj/item/explosive/grenade/smokebomb/green,
		/obj/item/explosive/grenade/smokebomb/red,
		/obj/item/explosive/grenade/metal_foam,
		/obj/item/explosive/grenade/phosphorus,
		/obj/item/explosive/grenade/slug/baton,
		/obj/item/explosive/grenade/tear/marine,
	)

/obj/item/clothing/accessory/storage/webbing/m3/recon
	name = "\improper M3-R 型弹匣携行带"
	desc = "适配制式 M3 型护甲、采用另一种布局的弹匣携行带，仅配发给武装侦察部队。"
	icon_state = "m3rwebbing"
	hold = /obj/item/storage/internal/accessory/webbing/m3mag/recon

/obj/item/storage/internal/accessory/webbing/m3mag/recon
	storage_slots = 4

//Pre-load For Props
//===
/obj/item/clothing/accessory/storage/webbing/m3/recon/mk1
	hold = /obj/item/storage/internal/accessory/webbing/m3mag/recon/mk1

/obj/item/storage/internal/accessory/webbing/m3mag/recon/mk1/fill_preset_inventory()
	new /obj/item/ammo_magazine/rifle/m41aMK1(src)
	new /obj/item/ammo_magazine/rifle/m41aMK1(src)

/obj/item/clothing/accessory/storage/webbing/m3/recon/m49
	hold = /obj/item/storage/internal/accessory/webbing/m3mag/recon/m49

/obj/item/storage/internal/accessory/webbing/m3mag/recon/m49/fill_preset_inventory()
	new /obj/item/ammo_magazine/rifle/m49a/ext(src)
	new /obj/item/ammo_magazine/rifle/m49a/ext(src)
	new /obj/item/ammo_magazine/rifle/m49a/heap(src)
	new /obj/item/ammo_magazine/rifle/m49a/heap(src)
//===

/obj/item/clothing/accessory/storage/webbing/m3/recon/m40
	name = "\improper M3-R 型手榴弹携行带"
	desc = "M3-R 型携行带的变型，适合收纳 M40 壳体手榴弹。"
	icon_state = "m3rwebbingm40"
	hold = /obj/item/storage/internal/accessory/black_vest/m3grenade/recon

/obj/item/storage/internal/accessory/black_vest/m3grenade/recon
	storage_slots = 10

/obj/item/clothing/accessory/storage/webbing/m3/recon/shotgun
	name = "\improper M3-R 型霰弹携行带"
	desc = "供武装侦察部队使用的改装型 M3-R 手榴弹携行带，适用于 12 号霰弹。"
	icon_state = "m3rwebbingshotgun"
	hold = /obj/item/storage/internal/accessory/black_vest/m3shotgun/recon

/obj/item/storage/internal/accessory/black_vest/m3shotgun/recon
	storage_slots = 7

/obj/item/clothing/accessory/storage/webbing/m3/recon/medic
	name = "\improper M3-R 型医务兵携行带"
	desc = "带有 M3-R 型携行带卡扣的大型收纳袋，供缺乏野战医院支援的武装侦察部队随队医务兵携带手术器械。"
	icon_state = "m3rwebbingmedic"
	hold = /obj/item/storage/internal/accessory/black_vest/m3generic/recon

/obj/item/storage/internal/accessory/black_vest/m3generic
	cant_hold = list(
		/obj/item/ammo_magazine/handful/shotgun,
		/obj/item/ammo_magazine/plasma,
	)

/obj/item/storage/internal/accessory/black_vest/m3generic/recon
	storage_slots = 6
	can_hold = list(
		/obj/item/storage/surgical_case/regular,
		/obj/item/reagent_container/blood,
		/obj/item/tool/surgery/surgical_line,
		/obj/item/tool/surgery/synthgraft,
		/obj/item/device/healthanalyzer,
	)

/obj/item/clothing/accessory/storage/webbing/m56
	name = "\improper 夹式收纳袋"
	desc = "供 M56 武器操作员携带少量物品的夹式合成皮革收纳袋。"
	icon_state = "m56pouch"
	hold = /obj/item/storage/internal/accessory/black_vest/m56
	slot = ACCESSORY_SLOT_M56UTILITY

/obj/item/clothing/accessory/storage/webbing/m56/Initialize(mapload)
	. = ..()
	if(!(flags_atom & NO_SNOW_TYPE))
		select_gamemode_skin(type)
	update_icon()

//Pre-load For Props

/obj/item/clothing/accessory/storage/webbing/m56/preset
	hold = /obj/item/storage/internal/accessory/black_vest/m56/preset

/obj/item/storage/internal/accessory/black_vest/m56
	storage_slots = 3

/obj/item/storage/internal/accessory/black_vest/m56/preset/fill_preset_inventory()
	new /obj/item/storage/box/mre(src)
	new /obj/item/tool/shovel/etool/folded(src)
	new /obj/item/reagent_container/food/drinks/flask/canteen(src)

//===

/obj/item/clothing/accessory/storage/webbing/m56/grenade
	name = "\improper 夹式手榴弹挂带"
	desc = "供 M56 武器操作员携带几枚手榴弹的结实合成皮革挂带。"
	icon_state = "m56grenade"
	hold = /obj/item/storage/internal/accessory/black_vest/m56/grenade

/obj/item/storage/internal/accessory/black_vest/m56/grenade
	storage_slots = 4
	can_hold = list(
		/obj/item/explosive/grenade/high_explosive,
		/obj/item/explosive/grenade/high_explosive/super,
		/obj/item/explosive/grenade/high_explosive/airburst/canister,
		/obj/item/explosive/grenade/high_explosive/impact/heap,
		/obj/item/explosive/grenade/high_explosive/impact/tmfrag,
		/obj/item/explosive/grenade/high_explosive/impact/flare,
		/obj/item/explosive/grenade/high_explosive/training,
		/obj/item/explosive/grenade/incendiary,
		/obj/item/explosive/grenade/smokebomb,
		/obj/item/explosive/grenade/smokebomb/green,
		/obj/item/explosive/grenade/smokebomb/red,
		/obj/item/explosive/grenade/metal_foam,
		/obj/item/explosive/grenade/phosphorus,
		/obj/item/explosive/grenade/slug/baton,
		/obj/item/explosive/grenade/tear/marine,
	)

//===========================//CUSTOM UPP ARMOR WEBBING\\================================\\

/obj/item/clothing/accessory/storage/webbing/m3/uppmags
	name = "\improper 90 式弹匣携行带"
	desc = "一套可携带四个弹匣的 UPP 携行带。"
	icon_state = "upp_webbing_magazine"
	hold = /obj/item/storage/internal/accessory/webbing/m3mag/upp
	flags_atom = NO_SNOW_TYPE
	slot = ACCESSORY_SLOT_M3UTILITY

/obj/item/storage/internal/accessory/webbing/m3mag/upp
	storage_slots = 4
	can_hold = list(
		/obj/item/attachable/bayonet,
		/obj/item/device/flashlight/flare,
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/m60,
		/obj/item/ammo_magazine/smg,
		/obj/item/ammo_magazine/pistol,
		/obj/item/ammo_magazine/revolver,
		/obj/item/ammo_magazine/sniper,
		/obj/item/ammo_magazine/handful,
		/obj/item/explosive/grenade,
		/obj/item/explosive/mine,
		/obj/item/reagent_container/food/snacks,
		/obj/item/ammo_magazine/plasma,
	)
	bypass_w_limit = list(
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/smg,
		/obj/item/ammo_magazine/plasma,
	)

/obj/item/clothing/accessory/storage/webbing/m3/uppsmall
	name = "\improper 78 式小袋携行带"
	desc = "配有各种口袋和收纳袋的 UPP 携行带，可携带多种小型物品。"
	icon_state = "upp_webbing_small"
	hold = /obj/item/storage/internal/accessory/black_vest/m3generic
	flags_atom = NO_SNOW_TYPE
	slot = ACCESSORY_SLOT_M3UTILITY

/obj/item/clothing/accessory/storage/webbing/m3/uppgeneral
	name = "\improper 78 式携行带"
	desc = "由结实的合成棉带和搭扣组成，适配 UPP 护甲。这是用于通用收纳的精简型号。"
	icon_state = "upp_webbing_large"
	hold = /obj/item/storage/internal/accessory/webbing/m3generic
	flags_atom = NO_SNOW_TYPE
	slot = ACCESSORY_SLOT_M3UTILITY

//===========================//CUSTOM RMC ARMOR WEBBING\\================================\\

/obj/item/clothing/accessory/storage/webbing/m3/uppsmall/rmc
	name = "\improper 67 式携行带"
	icon_state = "rmc_webbing_small"
	desc = "由结实的合成棉带和搭扣组成，适配皇家陆战队护甲。这是用于通用收纳的精简型号。"

/obj/item/clothing/accessory/storage/webbing/m3/uppmags/rmc
	name = "\improper 82 式弹匣携行带"
	desc = "一套可携带四个弹匣的携行袋，配有卡扣，能安装在皇家陆战队现役制式护甲上。"
	icon_state = "rmc_webbing_magazine"
	hold = /obj/item/storage/internal/accessory/webbing/m3mag/rmc

/obj/item/storage/internal/accessory/webbing/m3mag/rmc
	storage_slots = 4
	can_hold = list(
		/obj/item/ammo_magazine/rifle/nsg23,
		/obj/item/ammo_magazine/sniper,
		/obj/item/ammo_magazine/pistol/vp78,
		/obj/item/ammo_magazine/pistol/vp70,
		/obj/item/ammo_magazine/smg/m39,
	)

//Partial Pre-load For Props
//===
/obj/item/clothing/accessory/storage/webbing/m3/uppsmall/rmc/preset
	hold = /obj/item/storage/internal/accessory/black_vest/m3generic/rmc

/obj/item/storage/internal/accessory/black_vest/m3generic/rmc/fill_preset_inventory()
	new /obj/item/ammo_magazine/pistol/vp78/rmc(src)
	new /obj/item/ammo_magazine/pistol/vp78/rmc(src)
	new /obj/item/ammo_magazine/pistol/vp78/rmc(src)
	new /obj/item/clothing/mask/gas/pmc/royal_marine(src)
