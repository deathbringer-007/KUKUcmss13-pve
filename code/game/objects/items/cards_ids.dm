/* Cards
 * Contains:
 * DATA CARD
 * ID CARD
 * FINGERPRINT CARD HOLDER
 * FINGERPRINT CARD
 */



/*
 * DATA CARDS - Used for the teleporter
 */
/obj/item/card
	name = "卡片"
	desc = "具备卡片应有的功能。"
	icon = 'icons/obj/items/card.dmi'
	w_class = SIZE_TINY
	var/associated_account_number = 0

	var/list/files = list(  )

/obj/item/card/data
	name = "数据磁盘"
	desc = "一张数据磁盘。"
	icon_state = "data"
	var/function = "storage"
	var/data = "null"
	var/special = null
	item_state = "red-id"

/obj/item/card/data/verb/label(t as text)
	set name = "Label Disk"
	set category = "Object"
	set src in usr

	if (t)
		src.name = text("数据磁盘——“[]”", t)
	else
		src.name = "数据磁盘"
	src.add_fingerprint(usr)
	return

/obj/item/card/data/clown
	name = "\proper 小丑星球坐标"
	icon_state = "data"
	item_state = "red-id"
	layer = OBJ_LAYER
	level = 2
	desc = "卡内存有传说中小丑星球的坐标，小心保管。"
	function = "teleporter"
	data = "Clown Land"
	black_market_value = 50

/*
 * ID CARDS
 */

/obj/item/card/id
	name = "全息身份徽章"
	desc = "一片编码压缩玻璃纤维，用于身份识别与门禁控制。"
	icon_state = "id"
	item_state = "red-id"
	var/list/access
	var/faction = FACTION_NEUTRAL
	var/list/faction_group

	/// The name registered_name on the card
	var/registered_name = "Unknown"
	var/datum/weakref/registered_ref = null
	var/registered_gid = 0
	flags_equip_slot = SLOT_ID

	var/blood_type = "\[UNSET\]"

	//alt titles are handled a bit weirdly in order to unobtrusively integrate into existing ID system

	/// can be alt title or the actual job
	var/assignment = null
	/// actual job
	var/rank = null
	/// Marine's paygrade
	var/paygrade = PAY_SHORT_CIV
	/// For medics and engineers to 'claim' a locker
	var/claimedgear = 1

	var/list/uniform_sets = null
	var/list/vended_items

	/// whether the id's onmob overlay only appear when wearing a uniform
	var/pinned_on_uniform = TRUE

	var/modification_log = list()

	var/card_name = "ID Card"

/obj/item/card/id/Initialize(mapload, ...)
	. = ..()

	access = list()

/obj/item/card/id/Destroy()
	. = ..()
	screen_loc = null

/obj/item/card/id/proc/GetJobName() //Used in secHUD icon generation

	var/job_icons = get_all_job_icons()
	var/centcom = get_all_centcom_jobs()

	if(assignment in job_icons)
		return assignment//Check if the job has a hud icon
	if(rank in job_icons)
		return rank
	if(assignment in centcom)
		return "Centcom"//Return with the NT logo if it is a Centcom job
	if(rank in centcom)
		return "Centcom"
	return "Unknown" //Return unknown if none of the above apply

/obj/item/card/id/attack_self(mob/user as mob)
	..()
	user.visible_message("[user]向你展示：[icon2html(src, viewers(user))][name]，职务：[localized_player_label(assignment)]。")
	src.add_fingerprint(user)

/obj/item/card/id/proc/set_user_data(mob/living/carbon/human/H)
	if(!istype(H))
		return

	registered_name = H.real_name
	registered_ref = WEAKREF(H)
	registered_gid = H.gid
	blood_type = H.blood_type

/obj/item/card/id/proc/set_assignment(new_assignment)
	assignment = new_assignment
	name = "[localized_player_label(registered_name)]的[localized_player_label(card_name)]（[localized_player_label(assignment)]）"

/obj/item/card/id/GetAccess()
	return access

/obj/item/card/id/GetID()
	return src

/obj/item/card/id/verb/read()
	set name = "Read ID Card"
	set category = "Object"
	set src in usr

	to_chat(usr, "[icon2html(src, usr)][name]：卡上当前职务为[localized_player_label(assignment)]。")
	to_chat(usr, "卡上的血型为[blood_type]。")

/obj/item/card/id/proc/check_biometrics(mob/living/carbon/human/target)
	if(registered_ref && (registered_ref != WEAKREF(target)))
		return FALSE
	if(target.real_name != registered_name)
		return FALSE
	return TRUE

/obj/item/card/id/data
	name = "全息身份徽章"
	desc = "朴素的量产全息徽章。"
	icon_state = "data"

/obj/item/card/id/lanyard
	name = "全息身份挂绳"
	desc = "粗制的全息身份挂绳，便宜得不能再便宜。"
	icon_state = "lanyard"
	item_state = "blue-id"

/obj/item/card/id/silver
	name = "全息身份徽章"
	desc = "象征荣誉与奉献的镀银全息徽章。"
	icon_state = "silver"
	item_state = "silver_id"

/obj/item/card/id/silver/clearance_badge
	name = "公司医生徽章"
	desc = "公司全息徽章，采用指纹锁，具有 3 级权限，通常由公司医生持有。"
	icon_state = "clearance"
	var/credits_to_give = 15 //gives the equivalent clearance access in credits

/obj/item/card/id/silver/clearance_badge/scientist
	name = "公司科学家徽章"
	desc = "公司全息徽章，采用指纹锁，具有 4 级权限，通常由公司科学家持有。"
	credits_to_give = 27

/obj/item/card/id/silver/clearance_badge/cl
	name = "公司联络员徽章"
	desc = "采用独特公司橙白配色的全息徽章，指纹锁定，具有 5 级权限，通常由公司联络员持有。"
	icon_state = "cl"
	credits_to_give = 42

/obj/item/card/id/silver/clearance_badge/manager
	name = "公司经理徽章"
	desc = "采用公司标准橙白配色的全息徽章，底部独特地未封口。指纹锁定，具有 5-X 级权限，通常由公司经理持有。"
	icon_state = "pmc"
	credits_to_give = 47

/obj/item/card/id/pizza
	name = "披萨送餐员徽章"
	desc = "上面写着：“披萨送餐员工会第 217 分会”，“使命必达！”"
	icon_state = "pizza"
	item_state = "gold_id"

/obj/item/card/id/souto
	name = "索托侠"
	desc = "上面写着：“独一无二！”"
	icon_state = "gold"
	item_state = "gold_id"

/obj/item/card/id/gold
	name = "全息身份徽章"
	desc = "象征权力与力量的镀金全息徽章。"
	icon_state = "gold"
	item_state = "gold_id"

/obj/item/card/id/visa
	name = "破旧的签证卡"
	desc = "采用独特公司橙白配色的全息徽章。"
	icon_state = "visa"

/obj/item/card/id/silver/cl
	name = "公司全息徽章"
	desc = "采用独特公司橙白配色的全息徽章。"
	icon_state = "cl"

/obj/item/card/id/gold/council
	name = "全息身份徽章"
	desc = "真正的青铜金色上校全息徽章。象征威望与权威，也能当出色的镇纸。"
	icon_state = "commodore"

/obj/item/card/id/pmc
	name = "\improper 私人军事公司全息徽章"
	desc = "公司全息徽章，底部独特地未封口。"
	icon_state = "pmc"
	registered_name = "The Corporation"
	assignment = "Corporate Mercenary"

/obj/item/card/id/pmc/New()
	access = get_access(ACCESS_LIST_WY_ALL)
	..()

/obj/item/card/id/pmc/ds
	name = "\improper 公司全息徽章"
	desc = "列有呼号和血型，仅配发给白幕协议小队。"
	icon_state = "ds"

/obj/item/card/id/marshal
	name = "\improper 殖民地执法局法警金徽章"
	desc = "令人向往的金徽章，表明佩戴者是少数巡逻外缘地区的殖民地执法局法警之一。它象征正义、权威与保护，保护无力自保者，代表对永不背弃之誓言的承诺。"
	icon_state = "cmbmar"
	item_state = "gold_badge"
	paygrade = PAY_SHORT_CMBM

/obj/item/card/id/deputy
	name = "\improper 殖民地执法局副法警银徽章"
	desc = "表明佩戴者为殖民地执法局副法警的银徽章。它象征正义、权威与保护，保护无力自保者，代表对永不背弃之誓言的承诺。"
	icon_state = "cmbdep"
	item_state = "silver_badge"
	paygrade = PAY_SHORT_CMBD

/obj/item/card/id/general
	name = "将官全息徽章"
	desc = "高层中的高层，只授予最尽忠职守的人。"
	icon_state = "general"
	registered_name = "The USCM"
	assignment = "General"

/obj/item/card/id/general/New()
	access = get_access(ACCESS_LIST_MARINE_ALL)

/obj/item/card/id/provost
	name = "军法监察全息徽章"
	desc = "配发给军法监察办公室成员。"
	icon_state = "provost"
	registered_name = "Provost Office"
	assignment = "Provost"

/obj/item/card/id/provost/New()
	access = get_access(ACCESS_LIST_MARINE_ALL)

/obj/item/card/id/adaptive
	name = "特工身份卡"
	access = list(ACCESS_ILLEGAL_PIRATE)

/obj/item/card/id/adaptive/New(mob/user as mob)
	..()
	if(!QDELETED(user)) // Runtime prevention on laggy starts or where users log out because of lag at round start.
		registered_name = ishuman(user) ? user.real_name : "Unknown"
	assignment = "Agent"
	name = "[localized_player_label(registered_name)]的[localized_player_label(card_name)]（[localized_player_label(assignment)]）"

/obj/item/card/id/adaptive/afterattack(obj/item/O as obj, mob/user as mob, proximity)
	if(!proximity)
		return
	if(istype(O, /obj/item/card/id))
		var/obj/item/card/id/target_id = O
		access |= target_id.access
		if(ishuman(user))
			to_chat(user, SPAN_NOTICE("你将卡片扫过身份卡，微型扫描器随即启动，复制了它的权限。"))

/obj/item/card/id/adaptive/attack_self(mob/user as mob)
	switch(localized_native_alert(user, "要展示身份卡，还是更改身份信息？", "选择操作","Rename","Show"))
		if("Rename")
			var/new_name = strip_html(input(user, "要在卡上填写什么姓名？", "特工身份卡姓名", ishuman(user) ? user.real_name : user.name),26)
			if(!new_name || new_name == "Unknown" || new_name == "floor" || new_name == "wall" || new_name == "r-wall") //Same as mob/new_player/prefrences.dm
				to_chat(user, SPAN_WARNING("姓名无效。"))
				return

			var/new_job = strip_html(input(user, "要在卡上填写什么职务？\n注意：除维护区外，不会因此获得其他权限。", "特工身份卡职务", "Assistant"))
			if(!new_job)
				to_chat(user, SPAN_WARNING("职务无效。"))
				return

			var/new_rank = strip_html(input(user, "要在卡上填写什么军衔等级？\n注意：必须使用军衔简码，例如平民为 CIV，陆战队列兵为 ME1。", "特工身份卡军衔", PAY_SHORT_CIV))
			if(!new_rank || !(new_rank in GLOB.paygrades))
				to_chat(user, SPAN_WARNING("军衔等级无效。"))
				return

			registered_name = new_name
			assignment = new_job
			name = "[localized_player_label(registered_name)]的身份卡（[localized_player_label(assignment)]）"
			paygrade = new_rank
			to_chat(user, SPAN_NOTICE("你成功伪造了身份卡。"))
			return
	..()

/obj/item/card/id/captains_spare
	name = "舰长备用身份卡"
	desc = "那位至高大人物本人的备用身份卡。"
	icon_state = "gold"
	item_state = "gold_id"
	registered_name = "Captain"
	assignment = "Captain"

/obj/item/card/id/captains_spare/New()
	access = get_access(ACCESS_LIST_MARINE_ALL)
	..()

/obj/item/card/id/centcom
	name = "\improper 中央指挥部身份卡"
	desc = "直接来自中央指挥部的身份卡。"
	icon_state = "centcom"
	registered_name = "Central Command"
	assignment = "General"

/obj/item/card/id/centcom/New()
	access = get_access(ACCESS_LIST_WY_ALL)
	..()


/obj/item/card/id/equipped(mob/living/carbon/human/H, slot)
	if(istype(H))
		H.update_inv_head() //updating marine helmet squad coloring
		H.update_inv_wear_suit()
	..()

/obj/item/card/id/dropped(mob/user)
	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_head() //Don't do a full update yet
		H.update_inv_wear_suit()
	..()


/obj/item/card/id/dogtag
	name = "身份识别牌"
	desc = "一块身份识别牌。"
	icon_state = "dogtag"
	item_state = "dogtag"
	pinned_on_uniform = FALSE
	var/dogtag_taken = FALSE
	card_name = "dog tags"

/obj/item/card/id/dogtag/get_examine_text(mob/user)
	. = ..()
	if(ishuman(user))
		. += SPAN_NOTICE("上面写着“[localized_player_label(registered_name)]——[localized_player_label(assignment)]——[localized_player_label(blood_type)]”。")

/obj/item/dogtag
	name = "信息识别牌"
	desc = "阵亡军人的信息识别牌。"
	icon_state = "dogtag_taken"
	icon = 'icons/obj/items/card.dmi'
	w_class = SIZE_TINY
	var/list/fallen_names
	var/list/fallen_blood_types
	var/list/fallen_assgns

/obj/item/dogtag/Initialize()
	. = ..()

	fallen_names = list()
	fallen_blood_types = list()
	fallen_assgns = list()

/obj/item/dogtag/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/dogtag))
		var/obj/item/dogtag/D = I
		to_chat(user, SPAN_NOTICE("你将[length(fallen_names)>1 ? "这些识别牌":"两块识别牌"]合在一起。"))
		name = "信息识别牌组"
		if(D.fallen_names)
			fallen_names += D.fallen_names
			fallen_blood_types += D.fallen_blood_types
			fallen_assgns += D.fallen_assgns
		qdel(D)
		return TRUE
	else
		. = ..()

/obj/item/dogtag/get_examine_text(mob/user)
	. = ..()
	if(ishuman(user) && LAZYLEN(fallen_names))
		var/msg = "[length(fallen_names)>1 ? \
			"共有[length(fallen_names)]块识别牌。<br>上面写着":\
			"有一块身份识别牌。<br>上面写着"]:"
		for (var/i=1 to length(fallen_names))
			msg += "<br>[i]. \"[fallen_names[i]] - [localized_player_label(fallen_assgns[i])] - [fallen_blood_types[i]]\""
		. += SPAN_NOTICE("[msg]")

// Used to authenticate to CORSAT machines. Doesn't do anything except have its type variable
/obj/item/card/data/corsat
	name = "CORSAT 管理认证码"
	desc = "存有 CORSAT 管理认证码之一的数据磁盘，用于解除生物危害封锁。"
	icon_state = "data"
	item_state = "red-id"
	unacidable = 1

/obj/item/card/data/prison
	name = "监狱封锁管理认证码"
	desc = "存有监狱空间站管理认证码之一的数据磁盘，用于解除安保封锁。"
	icon_state = "data"
	item_state = "red-id"
	unacidable = 1
