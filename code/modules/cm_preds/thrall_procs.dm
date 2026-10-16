//Claim gear, same as the Hunter's get.
/obj/item/clothing/gloves/yautja/proc/buy_thrall_gear()
	set name = "领取装备"
	set desc = "在铁血战士的飞船上领取装备，只能领取一次。"
	set category = "Thrall.Misc"
	set src in usr

	var/mob/living/carbon/human/wearer = usr
	if(wearer.gloves != src)
		to_chat(wearer, SPAN_WARNING("你需要戴着仆从护腕才能这样做。"))
		return

	if(wearer.hunter_data.claimed_equipment)
		to_chat(wearer, SPAN_WARNING("你已经领取过装备了。"))
		return

	if(wearer.is_mob_incapacitated() || wearer.body_position == LYING_DOWN /* replace by mobility_flags */ || wearer.buckled)
		to_chat(wearer, SPAN_WARNING("你现在无法这样做。"))
		return

	if(!istype(get_area(wearer), /area/yautja))
		to_chat(wearer, SPAN_WARNING("这里不行，只能在飞船上领取。"))
		return

	var/sure = alert("一排强力武器展现在你面前。请谨慎选择装备；中途取消将无法领到装备。","确定？","开始狩猎","现在不领")
	if(sure == "开始狩猎")
		var/list/hmelee = list(YAUTJA_THRALL_GEAR_MACHETE = image(icon = 'icons/obj/items/weapons/weapons.dmi', icon_state = "machete"), YAUTJA_THRALL_GEAR_RAPIER = image(icon = 'icons/obj/items/weapons/weapons.dmi', icon_state = "ceremonial"), YAUTJA_THRALL_GEAR_CLAYMORE = image(icon = 'icons/obj/items/weapons/weapons.dmi', icon_state = "mercsword"), YAUTJA_THRALL_GEAR_FIREAXE = image(icon = 'icons/obj/items/weapons/weapons.dmi', icon_state = "fireaxe"))
		var/list/ymelee = list(YAUTJA_GEAR_GLAIVE = image(icon = 'icons/obj/items/hunter/pred_gear.dmi', icon_state = "glaive"), YAUTJA_GEAR_WHIP = image(icon = 'icons/obj/items/hunter/pred_gear.dmi', icon_state = "whip"), YAUTJA_GEAR_SWORD = image(icon = 'icons/obj/items/hunter/pred_gear.dmi', icon_state = "clansword"), YAUTJA_GEAR_SCYTHE = image(icon = 'icons/obj/items/hunter/pred_gear.dmi', icon_state = "predscythe"), YAUTJA_GEAR_STICK = image(icon = 'icons/obj/items/hunter/pred_gear.dmi', icon_state = "combistick"), YAUTJA_GEAR_SPEAR = image(icon = 'icons/obj/items/hunter/pred_gear.dmi', icon_state = "spearhunter"))

		var/main_weapon
		var/use_radials = wearer.client.prefs?.no_radials_preference ? FALSE : TRUE
		var/type = alert("你打算尝试外星武器，还是坚持使用人类武器？", "人类武器还是外星武器？", "始终坚持人类武器", "试试外星武器")
		if(type == "始终坚持人类武器")
			main_weapon = use_radials ? show_radial_menu(wearer, wearer, hmelee) : tgui_input_list(wearer, "你想用哪件武器狩猎？", "近战武器", hmelee)
		else
			main_weapon = use_radials ? show_radial_menu(wearer, wearer, ymelee) : tgui_input_list(wearer, "你想用哪件武器狩猎？", "近战武器", ymelee)
		if(!main_weapon)
			return //We don't want them to cancel out then get nothing.

		if(wearer.gloves != src)
			to_chat(wearer, SPAN_WARNING("你需要戴着仆从护腕才能这样做。"))
			return

		if(wearer.hunter_data.claimed_equipment)
			to_chat(src, SPAN_WARNING("你已经领取过装备了。"))
			return

		var/obj/item/spawned_weapon
		switch(main_weapon)
			if(YAUTJA_GEAR_GLAIVE)
				spawned_weapon = new /obj/item/weapon/twohanded/yautja/glaive(wearer.loc)
			if(YAUTJA_GEAR_SPEAR)
				spawned_weapon = new /obj/item/weapon/twohanded/yautja/spear(wearer.loc)
			if(YAUTJA_GEAR_WHIP)
				spawned_weapon = new /obj/item/weapon/yautja/chain(wearer.loc)
			if(YAUTJA_GEAR_SWORD)
				spawned_weapon = new /obj/item/weapon/yautja/sword(wearer.loc)
			if(YAUTJA_GEAR_SCYTHE)
				spawned_weapon = new /obj/item/weapon/yautja/scythe(wearer.loc)
			if(YAUTJA_GEAR_STICK)
				spawned_weapon = new /obj/item/weapon/yautja/combistick(wearer.loc)
			if(YAUTJA_THRALL_GEAR_MACHETE)
				spawned_weapon = new /obj/item/weapon/sword/machete(wearer.loc)
			if(YAUTJA_THRALL_GEAR_RAPIER)
				spawned_weapon = new /obj/item/weapon/sword/ceremonial(wearer.loc)
			if(YAUTJA_THRALL_GEAR_CLAYMORE)
				spawned_weapon = new /obj/item/weapon/sword(wearer.loc)
			if(YAUTJA_THRALL_GEAR_FIREAXE)
				spawned_weapon = new /obj/item/weapon/twohanded/fireaxe(wearer.loc)

		if(istype(spawned_weapon, /obj/item/weapon/yautja))
			var/obj/item/weapon/yautja/yautja_melee = spawned_weapon
			yautja_melee.human_adapted = TRUE
		else if(istype(spawned_weapon, /obj/item/weapon/twohanded/yautja))
			var/obj/item/weapon/twohanded/yautja/yautja_melee = spawned_weapon
			yautja_melee.human_adapted = TRUE
		spawned_weapon.desc += " 它看起来经过了改装，供人类使用。"

		wearer.hunter_data.claimed_equipment = TRUE

		verbs -= /obj/item/clothing/gloves/yautja/proc/buy_thrall_gear
		new /obj/item/clothing/suit/armor/yautja/thrall(wearer.loc)
		new /obj/item/clothing/shoes/yautja/thrall(wearer.loc)
		new /obj/item/clothing/under/chainshirt/thrall(wearer.loc)
		new /obj/item/clothing/mask/gas/yautja/thrall(wearer.loc)


//Link to thrall bracer, enabling most of it's abilities
/obj/item/clothing/gloves/yautja/hunter/verb/link_bracer()
	set name = "连接仆从护腕"
	set desc = "将你的护腕与仆从的护腕连接。"
	set category = "Yautja.Thrall"
	set src in usr

	var/mob/living/carbon/human/user = usr
	if(!istype(user))
		return
	if(!user.hunter_data)
		to_chat(user, SPAN_WARNING("错误：未检测到猎人数据。"))
		return

	if(linked_bracer)
		to_chat(user, SPAN_YAUTJABOLD("[icon2html(src)] <b>[src]</b>发出提示音：连接已经建立！"))
		return

	if(user.gloves != src)
		to_chat(user, SPAN_WARNING("你没有戴护腕！"))
		return
	else if(!owner || user != owner)
		to_chat(user, SPAN_YAUTJABOLD("[icon2html(src)] <b>[src]</b>发出提示音：检测到错误的使用者！"))
		return

	var/mob/living/carbon/human/T = user.hunter_data.thrall
	if(!T)
		to_chat(user, SPAN_WARNING("你没有可以连接的仆从！"))
		return
	else if(!istype(T.gloves, /obj/item/clothing/gloves/yautja/thrall))
		to_chat(user, SPAN_YAUTJABOLD("[icon2html(src)] <b>[src]</b>发出提示音：你的仆从没有戴护腕！"))
		return
	else
		var/obj/item/clothing/gloves/yautja/thrall/thrall_gloves = T.gloves

		linked_bracer = thrall_gloves
		thrall_gloves.linked_bracer = src
		thrall_gloves.owner = T
		thrall_gloves.verbs += /obj/item/clothing/gloves/yautja/proc/buy_thrall_gear
		T.client?.init_verbs()

		to_chat(user, SPAN_YAUTJABOLD("[icon2html(src)] <b>[src]</b>发出提示音：你的护腕已与仆从连接。"))
		if(notification_sound)
			playsound(loc, 'sound/items/pred_bracer.ogg', 75, 1)

		to_chat(T, SPAN_WARNING("[thrall_gloves]咔哒一声，牢牢锁在了你的手腕上。"))
		to_chat(T, SPAN_YAUTJABOLD("[icon2html(thrall_gloves)] <b>[thrall_gloves]</b>发出提示音：主人已将护腕与你的护腕连接。"))
		if(thrall_gloves.notification_sound)
			playsound(thrall_gloves.loc, 'sound/items/pred_bracer.ogg', 75, 1)

// Message thrall or master
/obj/item/clothing/gloves/yautja/verb/bracer_message()
	set name = "传送消息"
	set desc = "供仆从与主人直接通讯。"
	set src in usr

	var/mob/living/carbon/human/messenger = usr
	if(!istype(messenger))
		return

	var/mob/living/carbon/human/receiver
	var/messenger_title = "仆从"
	var/receiver_title = "主人"
	if(messenger.hunter_data.thralled)
		receiver = messenger.hunter_data.thralled_set
	else
		receiver = messenger.hunter_data.thrall
		messenger_title = "主人"
		receiver_title = "仆从"

	if(!istype(receiver))
		to_chat(messenger, SPAN_WARNING("你没有可以发送消息的对象！"))
		return
	if(!istype(receiver.gloves, /obj/item/clothing/gloves/yautja))
		to_chat(messenger, SPAN_WARNING("你的[receiver_title]没有戴护腕！"))
		return

	var/message = sanitize(input(messenger, "输入要发送的消息：", "发送消息") as null|text)
	if(!message)
		return

	if(!istype(receiver))
		to_chat(messenger, SPAN_WARNING("你没有可以发送消息的对象！"))
		return
	var/obj/item/clothing/gloves/yautja/receiver_gloves = receiver.gloves
	if(!istype(receiver_gloves))
		to_chat(messenger, SPAN_WARNING("你的[receiver_title]没有戴护腕！"))
		return

	to_chat(receiver, SPAN_YAUTJABOLD("<b>[receiver_gloves]</b>响起提示音，传来了你的[messenger_title]的消息：[message]"))
	to_chat(messenger, SPAN_YAUTJABOLD("<b>[src]</b>发出提示音：你向[receiver_title]发送了“[message]”。"))

	if(notification_sound)
		playsound(loc, 'sound/items/pred_bracer.ogg', 75, 1)
	if(receiver_gloves.notification_sound)
		playsound(receiver_gloves.loc, 'sound/items/pred_bracer.ogg', 75, 1)

	log_game("HUNTER: [key_name(messenger)] has sent [key_name(receiver)] the message '[message]' via bracer")

/obj/item/clothing/gloves/yautja/hunter/bracer_message()
	set category = "Yautja.Thrall"
	. = ..()

/obj/item/clothing/gloves/yautja/thrall/bracer_message()
	set category = "Thrall"
	. = ..()
