#define MENU_MARINE "marine"
#define MENU_XENOMORPH "xeno"
#define MENU_CO "co"
#define MENU_SYNTHETIC "synth"
#define MENU_YAUTJA "yautja"
#define MENU_MENTOR "mentor"
#define MENU_SETTINGS "settings"
#define MENU_SPECIAL "special"
#define MENU_PLTCO "pltco"

GLOBAL_LIST_EMPTY(preferences_datums)

GLOBAL_LIST_INIT(stylesheets, list(
	"Modern" = "common.css",
	"Legacy" = "legacy.css"
))

GLOBAL_LIST_INIT(bgstate_options, list(
	"blank",
	"outerhull",
	"sterile",
	"whitefull"
))

#define MAX_SAVE_SLOTS 20

/datum/preferences
	var/client/owner
	var/atom/movable/screen/preview/preview_front
	var/mob/living/carbon/human/dummy/preview_dummy
	var/atom/movable/screen/rotate/alt/rotate_left
	var/atom/movable/screen/rotate/rotate_right

	var/static/datum/flavor_text_editor/flavor_text_editor = new

	//doohickeys for savefiles
	var/path
	var/default_slot = 1 //Holder so it doesn't default to slot 1, rather the last one used
	var/savefile_version = 0

	var/tgui_say = TRUE
	var/tgui_say_light_mode = FALSE

	//non-preference stuff
	var/warns = 0
	var/muted = 0
	var/last_ip
	var/fps = 60
	var/last_id
	var/save_cooldown = 0 //5s cooldown between saving slots
	var/reload_cooldown = 0 //5s cooldown between loading slots

	//game-preferences
	var/lastchangelog = "" // Saved changlog filesize to detect if there was a change
	var/ooccolor
	var/be_special = 0 // Special role selection
	var/toggle_prefs = TOGGLE_DIRECTIONAL_ATTACK|TOGGLE_MEMBER_PUBLIC|TOGGLE_AMBIENT_OCCLUSION|TOGGLE_VEND_ITEM_TO_HAND // flags in #define/mode.dm
	var/xeno_ability_click_mode = XENO_ABILITY_CLICK_MIDDLE
	var/auto_fit_viewport = FALSE
	var/adaptive_zoom = 0
	var/UI_style = "midnight"
	var/toggles_admin = TOGGLES_ADMIN_DEFAULT
	var/toggles_chat = TOGGLES_CHAT_DEFAULT
	var/toggles_ghost = TOGGLES_GHOST_DEFAULT
	var/toggles_langchat = TOGGLES_LANGCHAT_DEFAULT
	var/toggles_sound = TOGGLES_SOUND_DEFAULT
	var/toggles_flashing = TOGGLES_FLASHING_DEFAULT
	var/toggles_ert = TOGGLES_ERT_DEFAULT
	var/chat_display_preferences = CHAT_TYPE_ALL
	var/item_animation_pref_level = SHOW_ITEM_ANIMATIONS_ALL
	var/pain_overlay_pref_level = PAIN_OVERLAY_BLURRY
	var/flash_overlay_pref = FLASH_OVERLAY_WHITE
	var/crit_overlay_pref = CRIT_OVERLAY_WHITE
	var/UI_style_color = "#ffffff"
	var/UI_style_alpha = 255
	var/View_MC = FALSE
	var/window_skin = 0
	var/list/observer_huds = list(
							"Medical HUD" = FALSE,
							"Security HUD" = FALSE,
							"Squad HUD" = FALSE,
							"Xeno Status HUD" = FALSE
							)
	var/ghost_vision_pref = GHOST_VISION_LEVEL_MID_NVG
	var/ghost_orbit = GHOST_ORBIT_CIRCLE
	var/dual_wield_pref = DUAL_WIELD_FIRE

	//Synthetic specific preferences
	var/synthetic_name = "Undefined"
	var/synthetic_type = SYNTH_GEN_THREE
	//Predator specific preferences.
	var/predator_name = "Undefined"
	var/predator_gender = MALE
	var/predator_age = 100
	var/predator_h_style = "Standard"
	var/predator_skin_color = "tan"
	var/predator_use_legacy = "None"
	var/predator_translator_type = "Modern"
	var/predator_mask_type = 1
	var/predator_armor_type = 1
	var/predator_boot_type = 1
	var/predator_armor_material = "ebony"
	var/predator_mask_material = "ebony"
	var/predator_greave_material = "ebony"
	var/predator_caster_material = "ebony"
	var/predator_cape_type = "None"
	var/predator_cape_color = "#654321"
	var/predator_flavor_text = ""
	//CO-specific preferences
	var/commander_sidearm = "Mateba"
	var/affiliation = "Unaligned"
	//SEA specific preferences

	///holds our preferred job options for jobs
	var/list/pref_special_job_options = list()
	///Holds assignment of character slots to jobs.
	var/list/pref_job_slots = list()

	//WL Council preferences.
	var/yautja_status = WHITELIST_NORMAL
	var/commander_status = WHITELIST_NORMAL
	var/synth_status = WHITELIST_NORMAL

	//character preferences
	var/real_name //our character's name
	var/slot_label //the nickname for the saveslot
	var/be_random_name = FALSE //whether we are a random name every round
	var/human_name_ban = FALSE


	var/be_random_body = 0 //whether we have a random appearance every round
	var/gender = MALE //gender of character (well duh)
	var/age = 19 //age of character
	var/spawnpoint = "Arrivals Shuttle" //where this character will spawn (0-2).
	var/underwear = "Boxers (Camo Conforming)" //underwear type
	var/undershirt = "Undershirt (Tan)" //undershirt type
	var/backbag = 2 //backpack type
	var/preferred_armor = "Random" //preferred armor type (from their primary prep vendor)

	var/h_style = "Crewcut" //Hair type
	var/r_hair = 0 //Hair color
	var/g_hair = 0 //Hair color
	var/b_hair = 0 //Hair color

	var/grad_style = "None" //Hair Gradient type
	var/r_gradient = 0 //Hair Gradient color
	var/g_gradient = 0 //Hair Gradient color
	var/b_gradient = 0 //Hair Gradient color

	var/f_style = "Shaved" //Face hair type
	var/r_facial = 0 //Face hair color
	var/g_facial = 0 //Face hair color
	var/b_facial = 0 //Face hair color

	var/r_skin = 0 //Skin color
	var/g_skin = 0 //Skin color
	var/b_skin = 0 //Skin color
	var/r_eyes = 0 //Eye color
	var/g_eyes = 0 //Eye color
	var/b_eyes = 0 //Eye color
	var/species = "Human"    //Species datum to use.
	var/ethnicity = "Western" //Legacy, kept to update save files
	var/skin_color = "Pale 2" // Skin color
	var/body_size = "Average" // Body Size
	var/body_type = "Lean" // Body Type
	var/language = "None" //Secondary language
	var/list/gear //Custom/fluff item loadout.
	var/preferred_squad = "None"

		//Some faction information.
	var/origin = ORIGIN_USCM
	var/faction = "None" //Antag faction/general associated faction.
	var/religion = RELIGION_AGNOSTICISM  //Religious association.

		//Mob preview
	var/icon/preview_icon = null
	var/icon/preview_icon_front = null
	var/icon/preview_icon_side = null

		//Jobs, uses bitflags
	var/list/job_preference_list = list()

	//Keeps track of preferrence for not getting any wanted jobs
	var/alternate_option = RETURN_TO_LOBBY //Be a marine.

	// maps each organ to either null(intact), "cyborg" or "amputated"
	// will probably not be able to do this for head and torso ;)
	var/list/organ_data = list()

	var/list/flavor_texts = list()

	var/med_record = ""
	var/sec_record = ""
	var/gen_record = ""
	var/exploit_record = ""

	var/weyland_yutani_relation = "Neutral"

	var/uplinklocation = "PDA"

	// OOC Metadata:
	var/metadata = ""
	var/slot_name = ""

	// XENO NAMES
	var/xeno_prefix = "XX"
	var/xeno_postfix = ""
	var/xeno_name_ban = FALSE
	var/xeno_vision_level_pref = XENO_VISION_LEVEL_MID_NVG
	var/playtime_perks = TRUE

	var/stylesheet = "Modern"

	var/lang_chat_disabled = FALSE

	var/show_permission_errors = TRUE

	var/key_buf // A buffer for setting macro keybinds
	var/list/key_mod_buf // A buffer for macro modifiers

	var/hotkeys = TRUE
	var/list/key_bindings = list()

	var/datum/tgui_macro/macros

	var/tgui_fancy = TRUE
	var/tgui_lock = FALSE
	var/window_scale = TRUE

	var/hear_vox = TRUE

	var/hide_statusbar

	var/no_radials_preference = FALSE
	var/no_radial_labels_preference = FALSE

	var/bg_state = "blank" // the icon_state of the floortile background displayed behind the mannequin in character creation
	var/show_job_gear = TRUE // whether the job gear gets equipped to the mannequin in character creation

	//Byond membership status

	var/unlock_content = 0

	var/current_menu = MENU_MARINE

	/// if this client has custom cursors enabled
	var/custom_cursors = TRUE

	/// if this client has tooltips enabled
	var/tooltips = TRUE

	/// A list of tutorials that the client has completed, saved across rounds
	var/list/completed_tutorials = list()
	/// If this client has auto observe enabled, used by /datum/orbit_menu
	var/auto_observe = TRUE

	/// Name for platoon used when spawning as LT
	var/platoon_name = "Sun Riders"
	/// Dropship camo used when spawning as LT
	var/dropship_camo = DROPSHIP_CAMO_JUNGLE
	/// Dropship name used when spawning as LT
	var/dropship_name = "Midway"

	/// Personal weapon that spawns randomly roundstart
	var/personal_weapon = "Ithaca 37 shotgun"

/datum/preferences/New(client/C)
	key_bindings = deep_copy_list(GLOB.hotkey_keybinding_list_by_key) // give them default keybinds and update their movement keys
	macros = new(C, src)
	if(istype(C))
		owner = C
		if(!IsGuestKey(C.key))
			unlock_content = C.IsByondMember()
			load_path(C.ckey)
			if(load_preferences())
				if(load_character())
					return

		C.tgui_say?.load()

	if(!ooccolor)
		ooccolor = CONFIG_GET(string/ooc_color_normal)
	gender = pick(MALE, FEMALE)
	real_name = random_name(gender)
	gear = list()

/datum/preferences/proc/client_reconnected(client/C)
	owner = C
	macros.owner = C

/datum/preferences/Del()
	. = ..()

	// Preferences should not be getting deleted because they are reffed in a list
	var/client_qdeled = isnull(owner) || QDELETED(owner)
	var/client_status = client_qdeled ? "client is null or disposed" : "client is OK"
	var/client_mob_status
	if (client_qdeled)
		client_mob_status = "no client for mob"
	else if (isnull(owner.mob) || QDELETED(owner.mob))
		client_mob_status = "client mob is null or disposed"
	else
		client_mob_status = "client mob is OK"
	CRASH("Preferences deleted unexpectedly: [client_status]; [client_mob_status]")

/datum/preferences/proc/ShowChoices(mob/user)
	if(!user || !user.client)
		return
	update_preview_icon()

	var/dat = "<style>"
	dat += "#column1 {width: 30%; float: left;}"
	dat += "#column2 {width: 30%; float: left;}"
	dat += "#column3 {width: 40%; float: left;}"
	dat += ".square {width: 15px; height: 15px; display: inline-block;}"
	dat += "</style>"
	dat += "<body onselectstart='return false;'>"

	dat += "<center>"
	if(path)
		dat += "<a href=\"byond://?src=\ref[user];preference=open_load_dialog\"><b>载入角色槽</b></a> - "
		dat += "<a href=\"byond://?src=\ref[user];preference=save\"><b>保存角色槽</b></a> - "
		dat += "<a href=\"byond://?src=\ref[user];preference=reload\"><b>重新载入角色槽</b></a>"
	else
		dat += "访客设置仅在本次会话中有效。登录 BYOND 账号即可保存角色。"
	dat += "</center>"

	dat += "<hr>"

	dat += "<center>"
	dat += "<a[current_menu == MENU_MARINE ? " class='linkOff'" : ""] href=\"byond://?src=\ref[user];preference=change_menu;menu=[MENU_MARINE]\"><b>人类</b></a> - "
	dat += "<a[current_menu == MENU_PLTCO ? " class='linkOff'" : ""] href=\"byond://?src=\ref[user];preference=change_menu;menu=[MENU_PLTCO]\"><b>排指挥官</b></a> - "
	dat += "<a[current_menu == MENU_XENOMORPH ? " class='linkOff'" : ""] href=\"byond://?src=\ref[user];preference=change_menu;menu=[MENU_XENOMORPH]\"><b>异形</b></a> - "
	if(owner.check_whitelist_status(WHITELIST_COMMANDER))
		dat += "<a[current_menu == MENU_CO ? " class='linkOff'" : ""] href=\"byond://?src=\ref[user];preference=change_menu;menu=[MENU_CO]\"><b>指挥官</b></a> - "
	dat += "<a[current_menu == MENU_SYNTHETIC ? " class='linkOff'" : ""] href=\"byond://?src=\ref[user];preference=change_menu;menu=[MENU_SYNTHETIC]\"><b>合成人</b></a> - "
	if(owner.check_whitelist_status(WHITELIST_PREDATOR))
		dat += "<a[current_menu == MENU_YAUTJA ? " class='linkOff'" : ""] href=\"byond://?src=\ref[user];preference=change_menu;menu=[MENU_YAUTJA]\"><b>铁血战士</b></a> - "
	if(owner.check_whitelist_status(WHITELIST_MENTOR))
		dat += "<a[current_menu == MENU_MENTOR ? " class='linkOff'" : ""] href=\"byond://?src=\ref[user];preference=change_menu;menu=[MENU_MENTOR]\"><b>导师</b></a> - "
	dat += "<a[current_menu == MENU_SETTINGS ? " class='linkOff'" : ""] href=\"byond://?src=\ref[user];preference=change_menu;menu=[MENU_SETTINGS]\"><b>设置</b></a> - "
	dat += "<a[current_menu == MENU_SPECIAL ? " class='linkOff'" : ""] href=\"byond://?src=\ref[user];preference=change_menu;menu=[MENU_SPECIAL]\"><b>特殊角色</b></a>"
	dat += "</center>"

	dat += "<hr>"

	switch(current_menu)
		if(MENU_MARINE)
			dat += "<div id='column1'>"
			dat += "<h1><u><b>姓名：</b></u> "
			dat += "<a href='byond://?_src_=prefs;preference=name;task=input'><b>[real_name]</b></a>"
			dat += "<a href='byond://?_src_=prefs;preference=name;task=random'>&reg</A></h1>"
			dat += "<u><b>角色槽标签：</b></u> "
			dat += "<a href='byond://?_src_=prefs;preference=slot_label;task=input'><b>[slot_label ? "[slot_label]" : "---"]</b></a><br> "
			dat += "<b>始终随机姓名：</b> <a href='byond://?_src_=prefs;preference=rand_name'><b>[be_random_name ? "是" : "否"]</b></a><br>"
			dat += "<b>始终随机外观：</b> <a href='byond://?_src_=prefs;preference=rand_body'><b>[be_random_body ? "是" : "否"]</b></a><br><br>"

			dat += "<h2><b><u>身体信息：</u></b>"
			dat += "<a href='byond://?_src_=prefs;preference=all;task=random'>&reg;</A></h2>"
			dat += "<b>年龄：</b> <a href='byond://?_src_=prefs;preference=age;task=input'><b>[age]</b></a><br>"
			dat += "<b>性别：</b> <a href='byond://?_src_=prefs;preference=gender'><b>[gender == MALE ? "男性" : "女性"]</b></a><br>"
			dat += "<b>肤色：</b> <a href='byond://?_src_=prefs;preference=skin_color;task=input'><b>[preference_label(skin_color)]</b></a><br>"
			dat += "<b>体格：</b> <a href='byond://?_src_=prefs;preference=body_size;task=input'><b>[preference_label(body_size)]</b></a><br>"
			dat += "<b>肌肉发达程度：</b> <a href='byond://?_src_=prefs;preference=body_type;task=input'><b>[preference_label(body_type)]</b></a><br>"
			dat += "<b>特质：</b> <a href='byond://?src=\ref[user];preference=traits;task=open'><b>角色特质</b></a>"
			dat += "<br>"

			dat += "<h2><b><u>职业选择：</u></b></h2>"
			dat += "<br>"
			dat += "\t<a href='byond://?_src_=prefs;preference=job;task=menu'><b>设置职业偏好</b></a>"
			dat += "<br>"
			if(path)
				dat += "\t<a href='byond://?_src_=prefs;preference=job_slot;task=menu'><b>为职业分配角色槽</b></a>"
			dat += "</div>"

			dat += "<div id='column2'>"
			dat += "<h2><b><u>毛发与眼睛：</u></b></h2>"
			dat += "<b>发型：</b> "
			dat += "<a href='byond://?_src_=prefs;preference=h_style;task=input'><b>[preference_label(h_style)]</b></a>"
			dat += " | "
			dat += "<a href='byond://?_src_=prefs;preference=hair;task=input'>"
			dat += "<b>颜色</b> <span class='square' style='background-color: #[num2hex(r_hair, 2)][num2hex(g_hair, 2)][num2hex(b_hair)];'></span>"
			dat += "</a>"
			dat += "<br>"

			if(/datum/character_trait/hair_dye in traits)
				dat += "<b>渐变染发：</b> "
				dat += "<a href='byond://?_src_=prefs;preference=grad_style;task=input'><b>[preference_label(grad_style)]</b></a>"
				dat += " | "
				dat += "<a href='byond://?_src_=prefs;preference=grad;task=input'>"
				dat += "<b>颜色</b> <span class='square' style='background-color: #[num2hex(r_gradient, 2)][num2hex(g_gradient, 2)][num2hex(b_gradient)];'></span>"
				dat += "</a>"
				dat += "<br>"

			dat += "<b>胡须：</b> "
			dat += "<a href='byond://?_src_=prefs;preference=f_style;task=input'><b>[preference_label(f_style)]</b></a>"
			dat += " | "
			dat += "<a href='byond://?_src_=prefs;preference=facial;task=input'>"
			dat += "<b>颜色</b> <span class='square' style='background-color: #[num2hex(r_facial, 2)][num2hex(g_facial, 2)][num2hex(b_facial)];'></span>"
			dat += "</a>"
			dat += "<br>"

			dat += "<b>眼睛：</b> "
			dat += "<a href='byond://?_src_=prefs;preference=eyes;task=input'>"
			dat += "<b>颜色</b> <span class='square' style='background-color: #[num2hex(r_eyes, 2)][num2hex(g_eyes, 2)][num2hex(b_eyes)];'></span>"
			dat += "</a>"
			dat += "<br><br>"

			dat += "<h2><b><u>陆战队装备：</u></b></h2>"
			dat += "<b>个人武器：</b> <a href ='byond://?_src_=prefs;preference=personalweapon;task=input'><b>[preference_label(personal_weapon)]</b></a><br>"
			dat += "<b>内衣：</b> <a href ='byond://?_src_=prefs;preference=underwear;task=input'><b>[preference_label(underwear)]</b></a><br>"
			dat += "<b>贴身上衣：</b> <a href='byond://?_src_=prefs;preference=undershirt;task=input'><b>[preference_label(undershirt)]</b></a><br>"

			dat += "<b>背包类型：</b> <a href ='byond://?_src_=prefs;preference=bag;task=input'><b>[preference_label(GLOB.backbaglist[backbag])]</b></a><br>"

			dat += "<b>偏好护甲样式：</b> <a href ='byond://?_src_=prefs;preference=prefarmor;task=input'><b>[preference_label(preferred_armor)]</b></a><br>"

			dat += "<b>显示职业装备：</b> <a href ='byond://?_src_=prefs;preference=toggle_job_gear'><b>[show_job_gear ? "是" : "否"]</b></a><br>"
			dat += "<b>背景：</b> <a href ='byond://?_src_=prefs;preference=cycle_bg'><b>切换背景</b></a><br>"

			dat += "<b>自选装备：</b> "
			var/total_cost = 0

			if(!islist(gear))
				gear = list()

			if(length(gear))
				dat += "<br>"
				for(var/i = 1; i <= length(gear); i++)
					var/datum/gear/G = GLOB.gear_datums_by_name[gear[i]]
					if(G)
						total_cost += G.cost
						dat += "[preference_label(gear[i])] ([G.cost] 点) <a href='byond://?src=\ref[user];preference=loadout;task=remove;gear=[i]'><b>移除</b></a><br>"

				dat += "<b>已用：</b> [total_cost] 点"
			else
				dat += "无"

			if(total_cost < MAX_GEAR_COST)
				dat += " <a href='byond://?src=\ref[user];preference=loadout;task=input'><b>添加</b></a>"
				if(LAZYLEN(gear))
					dat += " <a href='byond://?src=\ref[user];preference=loadout;task=clear'><b>清空</b></a>"

			dat += "</div>"

			dat += "<div id='column3'>"
			dat += "<h2><b><u>背景信息：</u></b></h2>"
			dat += "<b>出身：</b> <a href='byond://?_src_=prefs;preference=origin;task=input'><b>[preference_label(origin)]</b></a><br/>"
			dat += "<b>宗教：</b> <a href='byond://?_src_=prefs;preference=religion;task=input'><b>[preference_label(religion)]</b></a><br/>"

			dat += "<b>与公司的关系：</b> <a href='byond://?_src_=prefs;preference=wy_relation;task=input'><b>[preference_label(weyland_yutani_relation)]</b></a><br>"
			dat += "<b>偏好小队：</b> <a href='byond://?_src_=prefs;preference=prefsquad;task=input'><b>[preference_label(preferred_squad)]</b></a><br>"

			dat += "<h2><b><u>角色设定：</u></b></h2>"
			if(jobban_isbanned(user, "Records"))
				dat += "<b>你已被禁止使用角色档案。</b><br>"
			else
				dat += "<b>档案：</b> <a href=\"byond://?src=\ref[user];preference=records;record=1\"><b>角色档案</b></a><br>"

			dat += "<b>外观描述：</b> <a href='byond://?src=\ref[user];preference=flavor_text;task=open'><b>[TextPreview(flavor_texts["general"], 15)]</b></a><br>"
			dat += "</div>"

		if(MENU_PLTCO)
			dat += "<div id='column1'>"
			dat += "<h2><b><u>排设置：</u></b></h2>"
			dat += "<b>排名称：</b> <a href='byond://?_src_=prefs;preference=plat_name;task=input'><b>[platoon_name]</b></a><br>"
			dat += "<b>运输艇涂装：</b> <a href='byond://?_src_=prefs;preference=dropship_camo;task=input'><b>[preference_label(dropship_camo)]</b></a><br>"
			dat += "<b>运输艇名称：</b> <a href='byond://?_src_=prefs;preference=dropship_name;task=input'><b>[dropship_name]</b></a><br>"
			dat += "</div>"

		if(MENU_XENOMORPH)
			dat += "<div id='column1'>"
			dat += "<h2><b><u>异形信息：</u></b></h2>"
			var/display_prefix = xeno_prefix ? xeno_prefix : "------"
			var/display_postfix = xeno_postfix ? xeno_postfix : "------"
			dat += "<b>异形编号前缀：</b> <a href='byond://?_src_=prefs;preference=xeno_prefix;task=input'><b>[display_prefix]</b></a><br>"
			dat += "<b>异形编号后缀：</b> <a href='byond://?_src_=prefs;preference=xeno_postfix;task=input'><b>[display_postfix]</b></a><br>"

			dat += "<b>启用游玩时长奖励：</b> <a href='byond://?_src_=prefs;preference=playtime_perks'><b>[playtime_perks? "是" : "否"]</b></a><br>"
			dat += "<b>默认异形夜视等级：</b> <a href='byond://?_src_=prefs;preference=xeno_vision_level_pref;task=input'><b>[preference_label(xeno_vision_level_pref)]</b></a><br>"

			var/tempnumber = rand(1, 999)
			var/postfix_text = xeno_postfix ? ("-"+xeno_postfix) : ""
			var/prefix_text = xeno_prefix ? xeno_prefix : "XX"
			var/xeno_text = "[prefix_text]-[tempnumber][postfix_text]"

			dat += "<b>异形名称示例：</b> [xeno_text]<br>"
			dat += "<br>"
			dat += "</div>"

			dat += "<div id='column2'>"
			dat += "<h2><b><u>职业选择：</u></b></h2>"
			var/n = 0
			var/list/special_roles = list(
			"Xenomorph after<br>unrevivably dead" = 1,
			"Agent" = 0,
			)

			for(var/role_name in special_roles)
				var/ban_check_name
				var/list/missing_requirements = list()

				switch(role_name)
					if("Xenomorph after<br>unrevivably dead")
						ban_check_name = JOB_XENOMORPH

					if("Agent")
						ban_check_name = "Agent"

				if(jobban_isbanned(user, ban_check_name))
					dat += "<b>扮演 [preference_label(role_name)]：</b> <font color=red><b>\[已封禁]</b></font><br>"
				else if(!can_play_special_job(user.client, ban_check_name))
					dat += "<b>扮演 [preference_label(role_name)]：</b> <font color=red><b>\[时长不足]</b></font><br>"
					for(var/r in missing_requirements)
						var/datum/timelock/T = r
						dat += "\t[preference_label(T.name)] - [duration2text(missing_requirements[r])] 小时<br>"
				else
					dat += "<b>扮演 [preference_label(role_name)]：</b> <a href='byond://?_src_=prefs;preference=be_special;num=[n]'><b>[be_special & (1<<n) ? "是" : "否"]</b></a><br>"

				n++
		if(MENU_CO)
			if(owner.check_whitelist_status(WHITELIST_COMMANDER))
				dat += "<div id='column1'>"
				dat += "<h2><b><u>指挥官设置：</u></b></h2>"
				dat += "<b>指挥官白名单等级：</b> <a href='byond://?_src_=prefs;preference=commander_status;task=input'><b>[preference_label(commander_status)]</b></a><br>"
				dat += "<b>指挥官配枪：</b> <a href='byond://?_src_=prefs;preference=co_sidearm;task=input'><b>[preference_label(commander_sidearm)]</b></a><br>"
				dat += "<b>指挥官所属阵营：</b> <a href='byond://?_src_=prefs;preference=co_affiliation;task=input'><b>[preference_label(affiliation)]</b></a><br>"
				dat += "</div>"
			else
				dat += "<b>你尚未获得此角色的白名单资格。</b>"
		if(MENU_SYNTHETIC)
			dat += "<div id='column1'>"
			dat += "<h2><b><u>合成人设置：</u></b></h2>"
			dat += "<b>合成人姓名：</b> <a href='byond://?_src_=prefs;preference=synth_name;task=input'><b>[synthetic_name]</b></a><br>"
			dat += "<b>合成人型号：</b> <a href='byond://?_src_=prefs;preference=synth_type;task=input'><b>[preference_label(synthetic_type)]</b></a><br>"
			dat += "<b>合成人白名单等级：</b> <a href='byond://?_src_=prefs;preference=synth_status;task=input'><b>[preference_label(synth_status)]</b></a><br>"
			dat += "</div>"
		if(MENU_YAUTJA)
			if(owner.check_whitelist_status(WHITELIST_PREDATOR))
				dat += "<div id='column1'>"
				dat += "<h2><b><u>铁血战士信息：</u></b></h2>"
				dat += "<b>铁血战士姓名：</b> <a href='byond://?_src_=prefs;preference=pred_name;task=input'><b>[predator_name]</b></a><br>"
				dat += "<b>铁血战士性别：</b> <a href='byond://?_src_=prefs;preference=pred_gender;task=input'><b>[predator_gender == MALE ? "男性" : "女性"]</b></a><br>"
				dat += "<b>铁血战士年龄：</b> <a href='byond://?_src_=prefs;preference=pred_age;task=input'><b>[predator_age]</b></a><br>"
				dat += "<b>铁血战士棘发样式：</b> <a href='byond://?_src_=prefs;preference=pred_hair;task=input'><b>[preference_label(predator_h_style)]</b></a><br>"
				dat += "<b>铁血战士肤色：</b> <a href='byond://?_src_=prefs;preference=pred_skin;task=input'><b>[preference_label(predator_skin_color)]</b></a><br>"
				dat += "<b>铁血战士外观描述：</b> <a href='byond://?_src_=prefs;preference=pred_flavor_text;task=input'><b>[TextPreview(predator_flavor_text, 15)]</b></a><br>"
				dat += "<b>铁血战士白名单等级：</b> <a href='byond://?_src_=prefs;preference=yautja_status;task=input'><b>[preference_label(yautja_status)]</b></a>"
				dat += "</div>"

				dat += "<div id='column2'>"
				dat += "<h2><b><u>装备设置：</u></b></h2>"
				if(owner.check_whitelist_status(WHITELIST_YAUTJA_LEGACY))
					dat += "<b>传承装备：</b> <a href='byond://?_src_=prefs;preference=pred_use_legacy;task=input'><b>[preference_label(predator_use_legacy)]</b></a><br>"
				dat += "<b>翻译器类型：</b> <a href='byond://?_src_=prefs;preference=pred_trans_type;task=input'><b>[preference_label(predator_translator_type)]</b></a><br>"
				dat += "<b>面具样式：</b> <a href='byond://?_src_=prefs;preference=pred_mask_type;task=input'><b>([predator_mask_type])</b></a><br>"
				dat += "<b>护甲样式：</b> <a href='byond://?_src_=prefs;preference=pred_armor_type;task=input'><b>([predator_armor_type])</b></a><br>"
				dat += "<b>护胫样式：</b> <a href='byond://?_src_=prefs;preference=pred_boot_type;task=input'><b>([predator_boot_type])</b></a><br>"
				dat += "<b>面具材质：</b> <a href='byond://?_src_=prefs;preference=pred_mask_mat;task=input'><b>[preference_label(predator_mask_material)]</b></a><br>"
				dat += "<b>护甲材质：</b> <a href='byond://?_src_=prefs;preference=pred_armor_mat;task=input'><b>[preference_label(predator_armor_material)]</b></a><br>"
				dat += "<b>护胫材质：</b> <a href='byond://?_src_=prefs;preference=pred_greave_mat;task=input'><b>[preference_label(predator_greave_material)]</b></a><br>"
				dat += "<b>肩炮材质：</b> <a href='byond://?_src_=prefs;preference=pred_caster_mat;task=input'><b>[preference_label(predator_caster_material)]</b></a>"
				dat += "</div>"

				dat += "<div id='column3'>"
				dat += "<h2><b><u>服饰设置：</u></b></h2>"
				dat += "<b>披风类型：</b> <a href='byond://?_src_=prefs;preference=pred_cape_type;task=input'><b>[preference_label(capitalize_first_letters(predator_cape_type))]</b></a><br>"
				dat += "<b>披风颜色：</b> "
				dat += "<a href='byond://?_src_=prefs;preference=pred_cape_color;task=input'>"
				dat += "<b>颜色</b> <span class='square' style='background-color: [predator_cape_color];'></span>"
				dat += "</a><br><br>"
				dat += "<b>背景：</b> <a href='byond://?_src_=prefs;preference=cycle_bg'><b>切换背景</b></a>"
				dat += "</div>"
			else
				dat += "<b>你尚未获得此角色的白名单资格。</b>"
		if(MENU_MENTOR)
			if(owner.check_whitelist_status(WHITELIST_MENTOR))
				dat += "<b>这里暂时没有内容。</b>"
			else
				dat += "<b>你尚未获得此角色的白名单资格。</b>"
		if(MENU_SETTINGS)
			dat += "<div id='column1'>"
			dat += "<h2><b><u>输入设置：</u></b></h2>"
			dat += "<b>模式：</b> <a href='byond://?_src_=prefs;preference=hotkeys'><b>[(hotkeys) ? "快捷键模式" : "直接输入聊天"]</b></a><br>"
			dat += "<b>按键绑定：</b> <a href='byond://?_src_=prefs;preference=viewmacros'><b>查看按键绑定</b></a><br>"
			dat += "<br><b>聊天输入框样式：</b> <a href='byond://?_src_=prefs;preference=inputstyle'><b>[tgui_say ? "现代（默认）" : "旧版"]</b></a><br>"
			dat += "<b>聊天输入框配色：</b> <a href='byond://?_src_=prefs;preference=inputcolor'><b>[tgui_say_light_mode ? "浅色模式" : "深色模式（默认）"]</b></a><br>"

			dat += "<h2><b><u>界面自定义：</u></b></h2>"
			dat += "<b>样式：</b> <a href='byond://?_src_=prefs;preference=ui'><b>[preference_label(UI_style)]</b></a><br>"
			dat += "<b>颜色：</b> <a href='byond://?_src_=prefs;preference=UIcolor'><b>[UI_style_color]</b> <table style='display:inline;' bgcolor='[UI_style_color]'><tr><td>__</td></tr></table></a><br>"
			dat += "<b>不透明度：</b> <a href='byond://?_src_=prefs;preference=UIalpha'><b>[UI_style_alpha]</b></a><br><br>"
			dat += "<b>样式表：</b> <a href='byond://?_src_=prefs;preference=stylesheet'><b>[preference_label(stylesheet)]</b></a><br>"
			dat += "<b>隐藏状态栏：</b> <a href='byond://?_src_=prefs;preference=hide_statusbar'><b>[hide_statusbar ? "是" : "否"]</b></a><br>"
			dat += "<b>可用时优先使用下拉菜单：</b> <a href='byond://?_src_=prefs;preference=no_radials_preference'><b>[no_radials_preference ? "是" : "否"]</b></a><br>"
			if(!no_radials_preference)
				dat += "<b>隐藏环形菜单标签：</b> <a href='byond://?_src_=prefs;preference=no_radial_labels_preference'><b>[no_radial_labels_preference ? "是" : "否"]</b></a><br>"
			dat += "<b>自定义鼠标指针：</b> <a href='byond://?_src_=prefs;preference=customcursors'><b>[custom_cursors ? "已启用" : "已禁用"]</b></a><br>"

			dat += "<h2><b><u>聊天设置：</u></b></h2>"
			if(CONFIG_GET(flag/ooc_country_flags))
				dat += "<b>OOC 国旗：</b> <a href='byond://?_src_=prefs;preference=ooc_flag'><b>[(toggle_prefs & TOGGLE_OOC_FLAG) ? "已启用" : "已禁用"]</b></a><br>"
			if(user.client.admin_holder && user.client.admin_holder.rights & R_DEBUG)
				dat += "<b>显示主控制器标签页：</b> <a href='byond://?_src_=prefs;preference=ViewMC'><b>[View_MC ? "是" : "否"]</b></a>"
			if(unlock_content)
				dat += "<b>BYOND 会员身份可见性：</b> <a href='byond://?_src_=prefs;preference=publicity'><b>[(toggle_prefs & TOGGLE_MEMBER_PUBLIC) ? "公开" : "隐藏"]</b></a><br>"
			dat += "<b>幽灵听觉：</b> <a href='byond://?_src_=prefs;preference=ghost_ears'><b>[(toggles_chat & CHAT_GHOSTEARS) ? "所有对话" : "附近生物"]</b></a><br>"
			dat += "<b>幽灵视觉：</b> <a href='byond://?_src_=prefs;preference=ghost_sight'><b>[(toggles_chat & CHAT_GHOSTSIGHT) ? "所有表情动作" : "附近生物"]</b></a><br>"
			dat += "<b>幽灵无线电：</b> <a href='byond://?_src_=prefs;preference=ghost_radio'><b>[(toggles_chat & CHAT_GHOSTRADIO) ? "所有通讯" : "附近扬声器"]</b></a><br>"
			dat += "<b>幽灵窃听：</b> <a href='byond://?_src_=prefs;preference=ghost_spyradio'><b>[(toggles_chat & CHAT_LISTENINGBUG) ? "收听" : "静音"]窃听设备</b></a><br>"
			dat += "<b>幽灵虫巢意志：</b> <a href='byond://?_src_=prefs;preference=ghost_hivemind'><b>[(toggles_chat & CHAT_GHOSTHIVEMIND) ? "显示虫巢意志" : "隐藏虫巢意志"]</b></a><br>"
			dat += "<b>头顶聊天：</b> <a href='byond://?_src_=prefs;preference=lang_chat_disabled'><b>[lang_chat_disabled ? "隐藏" : "显示"]</b></a><br>"
			dat += "<b>头顶表情动作：</b> <a href='byond://?_src_=prefs;preference=langchat_emotes'><b>[(toggles_langchat & LANGCHAT_SEE_EMOTES) ? "显示" : "隐藏"]</b></a><br>"
			dat += "</div>"

			dat += "<div id='column2'>"
			dat += "<h2><b><u>游戏设置：</u></b></h2>"
			dat += "<b>环境光遮蔽：</b> <a href='byond://?_src_=prefs;preference=ambientocclusion'><b>[toggle_prefs & TOGGLE_AMBIENT_OCCLUSION ? "已启用" : "已禁用"]</b></a><br>"
			dat += "<b>视口适配：</b> <a href='byond://?_src_=prefs;preference=auto_fit_viewport'>[auto_fit_viewport ? "自动" : "手动"]</a><br>"
			dat += "<b>自适应缩放：</b> <a href='byond://?_src_=prefs;preference=adaptive_zoom'>[adaptive_zoom ? "[adaptive_zoom * 2]x" : "已禁用"]</a><br>"
			dat += "<b>悬浮提示：</b> <a href='byond://?_src_=prefs;preference=tooltips'><b>[tooltips ? "已启用" : "已禁用"]</b></a><br>"
			dat += "<b>tgui 窗口模式：</b> <a href='byond://?_src_=prefs;preference=tgui_fancy'><b>[(tgui_fancy) ? "精美（默认）" : "兼容（较慢）"]</b></a><br>"
			dat += "<b>tgui 窗口位置：</b> <a href='byond://?_src_=prefs;preference=tgui_lock'><b>[(tgui_lock) ? "主显示器" : "自由放置（默认）"]</b></a><br>"
			dat += "<b>窗口缩放：</b> <a href='byond://?_src_=prefs;preference=window_scale'><b>[window_scale ? "较大窗口（默认）" : "较小缩放"]</b></a><br>"
			dat += "<b>播放管理员音效：</b> <a href='byond://?_src_=prefs;preference=hear_admin_sounds'><b>[(toggles_sound & SOUND_MIDI) ? "是" : "否"]</b></a><br>"
			dat += "<b>幽灵状态播放公告音效：</b> <a href='byond://?_src_=prefs;preference=hear_observer_announcements'><b>[(toggles_sound & SOUND_OBSERVER_ANNOUNCEMENTS) ? "是" : "否"]</b></a><br>"
			dat += "<b>幽灵状态播放传真音效：</b> <a href='byond://?_src_=prefs;preference=hear_faxes'><b>[(toggles_sound & SOUND_FAX_MACHINE) ? "是" : "否"]</b></a><br>"
			dat += "<b>趣味或氛围音效：</b> <a href='byond://?src=\ref[src];action=proccall;procpath=/client/proc/toggle_admin_sound_types'>切换</a><br>"
			dat += "<b>视线模糊效果：</b> <a href='byond://?src=\ref[src];action=proccall;procpath=/client/proc/set_eye_blur_type'>设置</a><br>"
			dat += "<b>闪光效果：</b> <a href='byond://?src=\ref[src];action=proccall;procpath=/client/proc/set_flash_type'>设置</a><br>"
			dat += "<b>濒危效果：</b> <a href='byond://?src=\ref[src];action=proccall;procpath=/client/proc/set_crit_type'>设置</a><br>"
			dat += "<b>播放大厅音乐：</b> <a href='byond://?_src_=prefs;preference=lobby_music'><b>[(toggles_sound & SOUND_LOBBY) ? "是" : "否"]</b></a><br>"
			dat += "<b>播放 VOX 语音公告：</b> <a href='byond://?_src_=prefs;preference=sound_vox'><b>[(hear_vox) ? "是" : "否"]</b></a><br>"
			dat += "<b>默认幽灵夜视等级：</b> <a href='byond://?_src_=prefs;preference=ghost_vision_pref;task=input'><b>[preference_label(ghost_vision_pref)]</b></a><br>"
			dat += "<b>异形技能激活按键：</b> <a href='byond://?_src_=prefs;preference=mouse_button_activation;task=input'><b>[preference_label(xeno_ability_mouse_pref_to_string(xeno_ability_click_mode))]</b></a><br>"
			dat += "<a href='byond://?src=\ref[src];action=proccall;procpath=/client/proc/receive_random_tip'>阅读随机回合提示</a><br>"
			if(CONFIG_GET(flag/allow_Metadata))
				dat += "<b>角色外备注：</b> <a href='byond://?_src_=prefs;preference=metadata;task=input'>编辑</a>"
			dat += "</div>"

			dat += "<div id='column3'>"
			dat += "<h2><b><u>操作设置：</u></b></h2>"
			dat += "<b>允许伤害自己： \
					</b> <a href='byond://?_src_=prefs;preference=toggle_prefs;flag=[TOGGLE_IGNORE_SELF]'><b>[toggle_prefs & TOGGLE_IGNORE_SELF ? "关闭" : "开启"]</b></a><br>"
			dat += "<b>帮助意图安全保护： \
					</b> <a href='byond://?_src_=prefs;preference=toggle_prefs;flag=[TOGGLE_HELP_INTENT_SAFETY]'><b>[toggle_prefs & TOGGLE_HELP_INTENT_SAFETY ? "开启" : "关闭"]</b></a><br>"
			dat += "<b>允许取消激活技能： \
					</b> <a href='byond://?_src_=prefs;preference=toggle_prefs;flag=[TOGGLE_ABILITY_DEACTIVATION_OFF]'><b>[toggle_prefs & TOGGLE_ABILITY_DEACTIVATION_OFF ? "关闭" : "开启"]</b></a><br>"
			dat += "<b>方向辅助： \
					</b> <a href='byond://?_src_=prefs;preference=toggle_prefs;flag=[TOGGLE_DIRECTIONAL_ATTACK]'><b>[toggle_prefs & TOGGLE_DIRECTIONAL_ATTACK ? "开启" : "关闭"]</b></a><br>"
			dat += "<b>自动退出弹匣： \
					</b> <a href='byond://?_src_=prefs;preference=toggle_prefs;flag=[TOGGLE_AUTO_EJECT_MAGAZINE_OFF];flag_undo=[TOGGLE_AUTO_EJECT_MAGAZINE_TO_HAND]'><b>[!(toggle_prefs & TOGGLE_AUTO_EJECT_MAGAZINE_OFF) ? "开启" : "关闭"]</b></a><br>"
			dat += "<b>自动将弹匣退到副手： \
					</b> <a href='byond://?_src_=prefs;preference=toggle_prefs;flag=[TOGGLE_AUTO_EJECT_MAGAZINE_TO_HAND];flag_undo=[TOGGLE_AUTO_EJECT_MAGAZINE_OFF]'><b>[toggle_prefs & TOGGLE_AUTO_EJECT_MAGAZINE_TO_HAND ? "开启" : "关闭"]</b></a><br>"
			dat += "<b>手动将弹匣退到副手： \
					</b> <a href='byond://?_src_=prefs;preference=toggle_prefs;flag=[TOGGLE_EJECT_MAGAZINE_TO_HAND]'><b>[toggle_prefs & TOGGLE_EJECT_MAGAZINE_TO_HAND ? "开启" : "关闭"]</b></a><br>"
			dat += "<b>自动添加标点： \
					</b> <a href='byond://?_src_=prefs;preference=toggle_prefs;flag=[TOGGLE_AUTOMATIC_PUNCTUATION]'><b>[toggle_prefs & TOGGLE_AUTOMATIC_PUNCTUATION ? "开启" : "关闭"]</b></a><br>"
			dat += "<b>战斗模式点击拖拽替代操作： \
					</b> <a href='byond://?_src_=prefs;preference=toggle_prefs;flag=[TOGGLE_COMBAT_CLICKDRAG_OVERRIDE]'><b>[toggle_prefs & TOGGLE_COMBAT_CLICKDRAG_OVERRIDE ? "开启" : "关闭"]</b></a><br>"
			dat += "<b>战斗模式抵近射击替代操作： \
					</b> <a href='byond://?_src_=prefs;preference=toggle_prefs;flag=[TOGGLE_COMBAT_POINTBLANK_OVERRIDE]'><b>[toggle_prefs & TOGGLE_COMBAT_POINTBLANK_OVERRIDE ? "开启" : "关闭"]</b></a><br>"
			dat += "<b>鼠标中键切换双手： \
					</b> <a href='byond://?_src_=prefs;preference=toggle_prefs;flag=[TOGGLE_MIDDLE_MOUSE_SWAP_HANDS]'><b>[toggle_prefs & TOGGLE_MIDDLE_MOUSE_SWAP_HANDS ? "开启" : "关闭"]</b></a><br>"
			dat += "<b>售货机物品直接入手： \
					</b> <a href='byond://?_src_=prefs;preference=toggle_prefs;flag=[TOGGLE_VEND_ITEM_TO_HAND]'><b>[toggle_prefs & TOGGLE_VEND_ITEM_TO_HAND ? "开启" : "关闭"]</b></a><br>"
			dat += "<b>半自动武器弹药显示限制： \
					</b> <a href='byond://?_src_=prefs;preference=toggle_prefs;flag=[TOGGLE_AMMO_DISPLAY_TYPE]'><b>[toggle_prefs & TOGGLE_AMMO_DISPLAY_TYPE ? "开启" : "关闭"]</b></a><br>"
			dat += "<a href='byond://?src=\ref[src];action=proccall;procpath=/client/proc/switch_item_animations'>切换物品动画细节等级</a><br>"
			dat += "<a href='byond://?src=\ref[src];action=proccall;procpath=/client/proc/toggle_dualwield'>切换双持功能</a><br>"
		if(MENU_SPECIAL) //wart
			dat += "<div id='column1'>"
			dat += "<h2><b><u>应急响应小队设置：</u></b></h2>"
			dat += "<b>作为队长加入：</b> <a href='byond://?_src_=prefs;preference=toggles_ert;flag=[PLAY_LEADER]'><b>[toggles_ert & PLAY_LEADER ? "是" : "否"]</b></a><br>"
			dat += "<b>作为医疗兵加入：</b> <a href='byond://?_src_=prefs;preference=toggles_ert;flag=[PLAY_MEDIC]'><b>[toggles_ert & PLAY_MEDIC ? "是" : "否"]</b></a><br>"
			dat += "<b>作为工兵加入：</b> <a href='byond://?_src_=prefs;preference=toggles_ert;flag=[PLAY_ENGINEER]'><b>[toggles_ert & PLAY_ENGINEER ? "是" : "否"]</b></a><br>"
			dat += "<b>作为武器专家加入：</b> <a href='byond://?_src_=prefs;preference=toggles_ert;flag=[PLAY_HEAVY]'><b>[toggles_ert & PLAY_HEAVY ? "是" : "否"]</b></a><br>"
			dat += "<b>作为智能机枪手加入：</b> <a href='byond://?_src_=prefs;preference=toggles_ert;flag=[PLAY_SMARTGUNNER]'><b>[toggles_ert & PLAY_SMARTGUNNER ? "是" : "否"]</b></a><br>"
			if(owner.check_whitelist_status(WHITELIST_SYNTHETIC))
				dat += "<b>作为合成人加入：</b> <a href='byond://?_src_=prefs;preference=toggles_ert;flag=[PLAY_SYNTH]'><b>[toggles_ert & PLAY_SYNTH ? "是" : "否"]</b></a><br>"
			dat += "<b>作为其他角色加入：</b> <a href='byond://?_src_=prefs;preference=toggles_ert;flag=[PLAY_MISC]'><b>[toggles_ert & PLAY_MISC ? "是" : "否"]</b></a><br>"
			dat += "</div>"

	dat += "</div></body>"

	winshow(user, "preferencewindow", TRUE)
	show_browser(user, dat, "偏好设置", "preferencebrowser", width = 1000, height = 800, existing_container = "preferencewindow")
	onclose(user, "preferencewindow", src)

/**
 * Job Preferences: Preferences for role at round start.
 *
 * Arguments:
 * * limit - The amount of jobs allowed per column.
 * * splitJobs - Allows you split the table by job. You can make different tables for each department by including their heads.
 * * width - Screen' width.
 * * height - Screen's height.
 */
/datum/preferences/proc/SetChoices(mob/user, limit = 21, list/splitJobs = list(JOB_CHIEF_REQUISITION, JOB_WO_CMO), width = 950, height = 750)
	if(!GLOB.RoleAuthority)
		return

	var/host_bypass = FALSE
	if(user.client?.admin_holder?.check_for_rights(R_HOST))
		host_bypass = TRUE

	var/HTML = "<body>"
	HTML += "<tt><center>"
	HTML += "<b>设置职业分配优先级</b><br>不可用的职业已划除。<br><br>"
	HTML += "<center><a href='byond://?_src_=prefs;preference=job;task=close'>完成</a></center><br>" // Easier to press up here.
	HTML += "<table width='100%' cellpadding='1' cellspacing='0' style='color: black;'><tr><td valign='top' width='20%'>" // Table within a table for alignment, also allows you to easily add more colomns.
	HTML += "<table width='100%' cellpadding='1' cellspacing='0'>"
	var/index = -1

	//The job before the current job. I only use this to get the previous jobs color when I'm filling in blank rows.

	var/list/active_role_names = GLOB.gamemode_roles[GLOB.master_mode]
	if(!active_role_names)
		active_role_names = GLOB.ROLES_DISTRESS_SIGNAL

	for(var/role_name as anything in active_role_names)
		var/datum/job/job = GLOB.RoleAuthority.roles_by_name[role_name]
		if(!job)
			debug_log("Missing job for prefs: [role_name]")
			continue
		index++
		if((index >= limit) || (job.title in splitJobs))
			HTML += "</table></td><td valign='top' width='20%'><table width='100%' cellpadding='1' cellspacing='0'>"
			index = 0

		HTML += "<tr class='[job.selection_class]'><td width='30%' align='center'>"

		if(jobban_isbanned(user, job.title))
			HTML += "<b><del>[preference_label(job.disp_title)]</del></b></td><td width='10%' align='center'></td><td><b>已封禁</b></td></tr>"
			continue
		else if(!job.check_whitelist_status(user))
			HTML += "<b><del>[preference_label(job.disp_title)]</del></b></td><td width='10%' align='center'></td><td>需要白名单</td></tr>"
			continue
		else if(!job.can_play_role(user.client))
			var/list/missing_requirements = job.get_role_requirements(user.client)
			HTML += "<b><del>[preference_label(job.disp_title)]</del></b></td><td width='10%' align='center'></td><td>时长不足</td></tr>"
			for(var/r in missing_requirements)
				var/datum/timelock/T = r
				HTML += "<tr class='[job.selection_class]'><td width='40%' align='middle'>[preference_label(T.name)]</td><td width='10%' align='center'></td><td>[duration2text(missing_requirements[r])] 小时</td></tr>"
			continue

		HTML += "<b>[preference_label(job.disp_title)]</b></td><td width='10%' align='center'>"

		if(job.job_options)
			if(pref_special_job_options)
				pref_special_job_options[role_name] = sanitize_inlist(pref_special_job_options[role_name], job.job_options, job.job_options[1])
			else
				pref_special_job_options[role_name] = job.job_options[1]

			var/txt = job.job_options[pref_special_job_options[role_name]]
			HTML += "<a href='byond://?_src_=prefs;preference=special_job_select;task=input;text=[job.title]'><b>[preference_label(txt)]</b></a>"

		HTML += "</td><td width='50%'>"

		var/cur_priority = get_job_priority(job.title)

		var/b_color
		var/priority_text
		for (var/j in NEVER_PRIORITY to LOW_PRIORITY)
			switch (j)
				if(NEVER_PRIORITY)
					b_color = "red"
					priority_text = "从不"
				if(PRIME_PRIORITY)
					b_color = "purple"
					priority_text = "首选"
				if(HIGH_PRIORITY)
					b_color = "blue"
					priority_text = "高"
				if(MED_PRIORITY)
					b_color = "green"
					priority_text = "中"
				if(LOW_PRIORITY)
					b_color = "orange"
					priority_text = "低"

			if(j == PRIME_PRIORITY && !host_bypass && (!job.prime_priority || user.client?.get_total_human_playtime() < JOB_PLAYTIME_TIER_2))
				continue

			HTML += "<a class='[j == cur_priority ? b_color : "inactive"]' href='byond://?_src_=prefs;preference=job;task=input;text=[job.title];target_priority=[j];'>[priority_text]</a>"
			if (j < 4)
				HTML += "&nbsp"

		HTML += "</td></tr>"

	HTML += "</td></tr></table>"
	HTML += "</center></table>"

	if(user.client?.prefs) //Just makin sure
		var/b_color = "green"
		var/msg = "偏好职业不可用时随机分配职业"

		if(user.client.prefs.alternate_option == BE_MARINE)
			b_color = "red"
			msg = "偏好职业不可用时成为陆战队员"
		else if(user.client.prefs.alternate_option == RETURN_TO_LOBBY)
			b_color = "purple"
			msg = "偏好职业不可用时返回大厅"

		HTML += "<center><br><a class='[b_color]' href='byond://?_src_=prefs;preference=job;task=random'>[msg]</a></center><br>"

	HTML += "<center><a href='byond://?_src_=prefs;preference=job;task=reset'>重置</a></center>"
	HTML += "</tt></body>"

	close_browser(user, "preferences")
	show_browser(user, HTML, "职业偏好", "mob_occupation", width = width, height = height)
	onclose(user, "mob_occupation", user.client, list("_src_" = "prefs", "preference" = "job", "task" = "close"))
	return

/**
 * Job Assignments window: Assign unique characters to a particular job.
 *
 * Arguments:
 * * limit - The amount of jobs allowed per column.
 * * splitJobs - Allows you split the table by job. You can make different tables for each department by including their heads.
 * * width - Screen' width.
 * * height - Screen's height.
 */
/datum/preferences/proc/set_job_slots(mob/user, limit = 21, list/splitJobs = list(JOB_CHIEF_REQUISITION, JOB_WO_CMO), width = 950, height = 750)
	if(!GLOB.RoleAuthority)
		return

	var/HTML = "<body>"
	HTML += "<tt><center>"
	HTML += "<b>为职业分配角色槽。</b><br>不可用的职业已划除。<br><br>"
	HTML += "<center><a href='byond://?_src_=prefs;preference=job_slot;task=close'>完成</a></center><br>" // Easier to press up here.
	HTML += "<table width='100%' cellpadding='1' cellspacing='0' style='color: black;'><tr><td valign='top' width='20%'>" // Table within a table for alignment, also allows you to easily add more colomns.
	HTML += "<table width='100%' cellpadding='1' cellspacing='0'>"
	var/index = -1

	//The job before the current job. I only use this to get the previous jobs color when I'm filling in blank rows.

	var/list/active_role_names = GLOB.gamemode_roles[GLOB.master_mode]
	if(!active_role_names)
		active_role_names = GLOB.ROLES_DISTRESS_SIGNAL

	for(var/role_name as anything in active_role_names)
		var/datum/job/job = GLOB.RoleAuthority.roles_by_name[role_name]
		if(!job)
			debug_log("Missing job for prefs: [role_name]")
			continue
		index++
		if((index >= limit) || (job.title in splitJobs))
			HTML += "</table></td><td valign='top' width='20%'><table width='100%' cellpadding='1' cellspacing='0'>"
			index = 0

		HTML += "<tr class='[job.selection_class]'><td width='40%' align='right'>"
		if(jobban_isbanned(user, job.title))
			HTML += "<b><del>[preference_label(job.disp_title)]</del></b></td><td width='60%'><b>已封禁</b></td></tr>"
			continue
		else if(!job.check_whitelist_status(user))
			HTML += "<b><del>[preference_label(job.disp_title)]</del></b></td><td width='60%'>需要白名单</td></tr>"
			continue
		else if(!job.can_play_role(user.client))
			HTML += "<b><del>[preference_label(job.disp_title)]</del></b></td><td width='60%'>时长不足</td></tr>"
			continue

		HTML += "<b>[preference_label(job.disp_title)]</b></td>"

		var/slot_name = get_job_slot_name(job.title)
		HTML += "<td width='60%'><a href='byond://?_src_=prefs;preference=job_slot;task=assign;target_job=[job.title];'>[slot_name]</a>"
		HTML += "</td></tr>"

	HTML += "</td></tr></table>"
	HTML += "</center></table><br>"

	var/b_color
	var/msg
	if(toggle_prefs & TOGGLE_START_JOIN_CURRENT_SLOT)
		b_color = "red"
		msg = "回合开始时加入将忽略此设置。"
	else
		b_color = "green"
		msg = "回合开始时加入将使用此设置。"
	HTML += "<center><a class='[b_color]' href='byond://?_src_=prefs;preference=job_slot;task=start_join'>[msg]</a></center>"
	if(toggle_prefs & TOGGLE_LATE_JOIN_CURRENT_SLOT)
		b_color = "red"
		msg = "中途加入回合将忽略此设置。"
	else
		b_color = "green"
		msg = "中途加入回合将使用此设置。"
	HTML += "<center><a class='[b_color]' href='byond://?_src_=prefs;preference=job_slot;task=late_join'>[msg]</a></center>"

	HTML += "<center><a href='byond://?_src_=prefs;preference=job_slot;task=reset'>重置</a></center>"
	HTML += "</tt></body>"

	close_browser(user, "preferences")
	show_browser(user, HTML, "职业分配", "job_slots_assignment", width = width, height = height)
	onclose(user, "job_slots_assignment", user.client, list("_src_" = "prefs", "preference" = "job_slot", "task" = "close"))
	return

/datum/preferences/proc/SetRecords(mob/user)
	var/HTML = "<body onselectstart='return false;'>"
	HTML += "<tt><center>"
	HTML += "<b>设置角色档案</b><br>"

	HTML += "<a href=\"byond://?src=\ref[user];preference=records;task=med_record\">医疗档案</a><br>"

	HTML += TextPreview(med_record,40)

	HTML += "<br><br><a href=\"byond://?src=\ref[user];preference=records;task=gen_record\">雇佣档案</a><br>"

	HTML += TextPreview(gen_record,40)

	HTML += "<br><br><a href=\"byond://?src=\ref[user];preference=records;task=sec_record\">安保档案</a><br>"

	HTML += TextPreview(sec_record,40)

	HTML += "<br>"
	HTML += "<a href=\"byond://?src=\ref[user];preference=records;records=-1\">完成</a>"
	HTML += "</center></tt>"

	close_browser(user, "preferences")
	show_browser(user, HTML, "设置档案", "records", width = 350, height = 300)
	return

/datum/preferences/proc/SetJob(mob/user, role, priority)
	var/datum/job/job = GLOB.RoleAuthority.roles_by_name[role]
	if(!job)
		close_browser(user, "mob_occupation")
		ShowChoices(user)
		return

	SetJobDepartment(job, priority)

	SetChoices(user)
	return 1

/datum/preferences/proc/ResetJobs()
	if(length(job_preference_list))
		for(var/job in job_preference_list)
			job_preference_list[job] = NEVER_PRIORITY
		return

	if(!GLOB.RoleAuthority)
		return

	job_preference_list = list()
	for(var/role in GLOB.RoleAuthority.roles_by_path)
		var/datum/job/J = GLOB.RoleAuthority.roles_by_path[role]
		job_preference_list[J.title] = NEVER_PRIORITY

/datum/preferences/proc/get_job_priority(J)
	if(!J)
		return FALSE

	if(!length(job_preference_list))
		ResetJobs()

	return job_preference_list[J]

/// Returns a list of all the proference's jobs set to the priority argument
/datum/preferences/proc/get_jobs_by_priority(priority)
	var/list/jobs_to_return = list()

	if(!length(job_preference_list))
		ResetJobs()
		return jobs_to_return

	for(var/job in job_preference_list)
		if(job_preference_list[job] == priority)
			jobs_to_return += job

	return jobs_to_return

/// Returns TRUE if any job has a priority other than NEVER, FALSE otherwise.
/datum/preferences/proc/has_job_priorities()
	if(!length(job_preference_list))
		ResetJobs()
		return FALSE

	for(var/job in job_preference_list)
		if(job_preference_list[job] != NEVER_PRIORITY)
			return TRUE

	return FALSE

/datum/preferences/proc/SetJobDepartment(datum/job/J, priority)
	if(!J || priority < 0 || priority > 4)
		return FALSE

	if(!length(job_preference_list))
		ResetJobs()

	// Need to set old HIGH priority to 2
	if(priority == PRIME_PRIORITY)
		for(var/job in job_preference_list)
			if(job_preference_list[job] == PRIME_PRIORITY)
				job_preference_list[job] = MED_PRIORITY

	if(priority == HIGH_PRIORITY)
		for(var/job in job_preference_list)
			if(job_preference_list[job] == HIGH_PRIORITY)
				job_preference_list[job] = MED_PRIORITY

	job_preference_list[J.title] = priority
	return TRUE

/datum/preferences/proc/assign_job_slot(mob/user, target_job)
	var/list/slot_options = list("随机姓名与外观" = JOB_SLOT_RANDOMISED_SLOT, "当前角色槽" = JOB_SLOT_CURRENT_SLOT)
	var/savefile/S = new /savefile(path)
	var/slot_name
	for(var/slot in 1 to MAX_SAVE_SLOTS)
		S.cd = "/character[slot]"
		S["real_name"] >> slot_name
		if(slot_name)
			slot_options["[slot_name]（角色槽 #[slot]）"] = slot
	var/chosen_slot = preference_input_list(user, "为 [preference_label(target_job)] 职业分配角色", "分配角色槽", slot_options)
	if(chosen_slot)
		pref_job_slots[target_job] = slot_options[chosen_slot]
	set_job_slots(user)

/datum/preferences/proc/get_job_slot_name(job_title)
	. = "当前角色槽"
	if(!(job_title in pref_job_slots))
		return
	var/slot_number = pref_job_slots[job_title]
	switch(slot_number)
		if(JOB_SLOT_RANDOMISED_SLOT)
			return "随机姓名与外观"
		if(1 to MAX_SAVE_SLOTS)
			var/savefile/S = new /savefile(path)
			S.cd = "/character[slot_number]"
			return "[S["real_name"]]（角色槽 #[slot_number]）"

/datum/preferences/proc/reset_job_slots()
	pref_job_slots = list()
	var/datum/job/J
	for(var/role in GLOB.RoleAuthority.roles_by_path)
		J = GLOB.RoleAuthority.roles_by_path[role]
		pref_job_slots[J.title] = JOB_SLOT_CURRENT_SLOT

/datum/preferences/proc/process_link(mob/user, list/href_list)


	switch(href_list["preference"])
		if("job")
			switch(href_list["task"])
				if("close")
					close_browser(user, "mob_occupation")
					ShowChoices(user)
				if("reset")
					ResetJobs()
					SetChoices(user)
				if("random")
					if(alternate_option == GET_RANDOM_JOB || alternate_option == BE_MARINE)
						alternate_option++
					else if(alternate_option == RETURN_TO_LOBBY)
						alternate_option = 0
					else
						return 0
					SetChoices(user)
				if("input")
					var/priority = text2num(href_list["target_priority"])
					SetJob(user, href_list["text"], priority)
				else
					SetChoices(user)
			return TRUE
		if("job_slot")
			switch(href_list["task"])
				if("close")
					close_browser(user, "job_slots_assignment")
					ShowChoices(user)
				if("assign")
					assign_job_slot(user, href_list["target_job"])
				if("start_join")
					toggle_prefs ^= TOGGLE_START_JOIN_CURRENT_SLOT
					set_job_slots(user)
				if("late_join")
					toggle_prefs ^= TOGGLE_LATE_JOIN_CURRENT_SLOT
					set_job_slots(user)
				if("reset")
					reset_job_slots()
					set_job_slots(user)
				else
					set_job_slots(user)
			return TRUE
		if("loadout")
			switch(href_list["task"])
				if("input")
					var/gear_category = preference_input_list(user, "选择装备类别：", "添加装备", GLOB.gear_datums_by_category)
					if(!gear_category)
						return
					var/choice = preference_input_list(user, "选择要添加的装备：", gear_category, GLOB.gear_datums_by_category[gear_category])
					if(!choice)
						return

					var/total_cost = 0
					var/datum/gear/G
					if(isnull(gear) || !islist(gear))
						gear = list()
					if(length(gear))
						for(var/gear_name in gear)
							G = GLOB.gear_datums_by_name[gear_name]
							total_cost += G?.cost

					G = GLOB.gear_datums_by_category[gear_category][choice]
					total_cost += G.cost
					if(total_cost <= MAX_GEAR_COST)
						gear += G.display_name
						to_chat(user, SPAN_NOTICE("已添加“[preference_label(G.display_name)]”，消耗 [G.cost] 点（剩余 [MAX_GEAR_COST - total_cost] 点）。"))
					else
						to_chat(user, SPAN_WARNING("添加“[preference_label(choice)]”将超出自选装备的 [MAX_GEAR_COST] 点上限。"))

				if("remove")
					var/i_remove = text2num(href_list["gear"])
					if(i_remove < 1 || i_remove > length(gear)) return
					gear.Cut(i_remove, i_remove + 1)

				if("clear")
					gear.Cut()

		if("flavor_text")
			flavor_text_editor.tgui_interact(user)
			return

		if("records")
			if(text2num(href_list["record"]) >= 1)
				SetRecords(user)
				return
			else
				close_browser(user, "records")

			switch(href_list["task"])
				if("med_record")
					var/medmsg = input(usr,"在此填写医疗档案。字数上限为 [MAX_RECORDS_MESSAGE_LEN]。","医疗档案",html_decode(med_record)) as message

					if(medmsg != null)
						medmsg = copytext(medmsg, 1, MAX_RECORDS_MESSAGE_LEN)
						medmsg = html_encode(medmsg)

						med_record = medmsg
						SetRecords(user)

				if("sec_record")
					var/secmsg = input(usr,"在此填写安保档案。字数上限为 [MAX_RECORDS_MESSAGE_LEN]。","安保档案",html_decode(sec_record)) as message

					if(secmsg != null)
						secmsg = copytext(secmsg, 1, MAX_RECORDS_MESSAGE_LEN)
						secmsg = html_encode(secmsg)

						sec_record = secmsg
						SetRecords(user)
				if("gen_record")
					var/genmsg = input(usr,"在此填写雇佣档案。字数上限为 [MAX_RECORDS_MESSAGE_LEN]。","雇佣档案",html_decode(gen_record)) as message

					if(genmsg != null)
						genmsg = copytext(genmsg, 1, MAX_RECORDS_MESSAGE_LEN)
						genmsg = html_encode(genmsg)

						gen_record = genmsg
						SetRecords(user)

		if("hotkeys")
			hotkeys = !hotkeys
			if(hotkeys)
				winset(user, null, "input.focus=true")
			else
				winset(user, null, "input.focus=false")

		if("traits")
			switch(href_list["task"])
				if("open")
					open_character_traits(user)
					return TRUE
				if("change_slot")
					var/trait_group = text2path(href_list["trait_group"])
					if(!GLOB.character_trait_groups[trait_group])
						trait_group = null
					open_character_traits(user, trait_group)
					return TRUE
				if("give_trait")
					var/trait_group = text2path(href_list["trait_group"])
					if(!GLOB.character_trait_groups[trait_group])
						trait_group = null
					var/trait = text2path(href_list["trait"])
					var/datum/character_trait/character_trait = GLOB.character_traits[trait]
					character_trait?.try_give_trait(src)
					open_character_traits(user, trait_group)
					if(character_trait.refresh_choices)
						ShowChoices(user)
					if(character_trait.refresh_mannequin)
						update_preview_icon()
					return TRUE
				if("remove_trait")
					var/trait_group = text2path(href_list["trait_group"])
					if(!GLOB.character_trait_groups[trait_group])
						trait_group = null
					var/trait = text2path(href_list["trait"])
					var/datum/character_trait/character_trait = GLOB.character_traits[trait]
					character_trait?.try_remove_trait(src)
					open_character_traits(user, trait_group)
					if(character_trait.refresh_choices)
						ShowChoices(user)
					if(character_trait.refresh_mannequin)
						update_preview_icon()
					return TRUE

		if("toggle_job_gear")
			show_job_gear = !show_job_gear

		if("cycle_bg")
			bg_state = next_in_list(bg_state, GLOB.bgstate_options)

	switch (href_list["task"])
		if ("random")
			switch (href_list["preference"])
				if ("name")
					var/datum/origin/character_origin = GLOB.origins[origin]
					real_name = character_origin.generate_human_name(gender)
				if ("age")
					age = rand(AGE_MIN, AGE_MAX)
				if ("skin_color")
					skin_color = random_skin_color()
				if ("body_type")
					body_type = random_body_type()
				if ("body_size")
					body_size = random_body_size()
				if ("hair")
					r_hair = rand(0,255)
					g_hair = rand(0,255)
					b_hair = rand(0,255)
				if ("h_style")
					h_style = random_hair_style(gender, species)
				if ("facial")
					r_facial = rand(0,255)
					g_facial = rand(0,255)
					b_facial = rand(0,255)
				if ("f_style")
					f_style = random_facial_hair_style(gender, species)
				if ("underwear")
					underwear = gender == MALE ? pick(GLOB.underwear_m) : pick(GLOB.underwear_f)
					ShowChoices(user)
				if ("undershirt")
					undershirt = gender == MALE ? pick(GLOB.undershirt_m) : pick(GLOB.undershirt_f)
					ShowChoices(user)
				if ("eyes")
					r_eyes = rand(0,255)
					g_eyes = rand(0,255)
					b_eyes = rand(0,255)

				if ("s_color")
					r_skin = rand(0,255)
					g_skin = rand(0,255)
					b_skin = rand(0,255)
				if ("bag")
					backbag = rand(1,2)

				if ("all")
					randomize_appearance()
		if("input")
			var/datum/entity/player/player = get_player_from_key(user.ckey)
			var/whitelist_flags = player.whitelist_flags

			switch(href_list["preference"])
				if("name")
					if(human_name_ban)
						to_chat(user, SPAN_NOTICE("你已被禁止自定义人类姓名。"))
						return
					var/raw_name = input(user, "请输入角色姓名：", "角色偏好")  as text|null
					if (!isnull(raw_name)) // Check to ensure that the user entered text (rather than cancel.)
						var/new_name = reject_bad_name(raw_name)
						if(new_name)
							real_name = new_name
						else
							to_chat(user, "<font color='red'>姓名无效。长度应为 2 至 [MAX_NAME_LEN] 个字符，仅可包含 A-Z、a-z、-、' 和 .。</font>")

				if("slot_label")
					var/raw_name = input(user, "为此角色槽设置简短标签或标识。这不是角色在游戏内的昵称：", "角色偏好")  as text|null
					if (raw_name) // Check to ensure that the user entered text (rather than cancel.)
						var/new_name = reject_bad_name(raw_name)
						if(new_name)
							slot_label = new_name
						else
							to_chat(user, "<font color='red'>角色槽标签无效。长度应为 2 至 [MAX_NAME_LEN] 个字符，仅可包含 A-Z、a-z、-、' 和 .。</font>")

				if("xeno_vision_level_pref")
					var/static/list/vision_level_choices = list(XENO_VISION_LEVEL_NO_NVG, XENO_VISION_LEVEL_MID_NVG, XENO_VISION_LEVEL_FULL_NVG)
					var/choice = preference_input_list(user, "选择默认异形夜视等级", "夜视等级", vision_level_choices, theme="hive_status")
					if(!choice)
						return
					xeno_vision_level_pref = choice
				if("ghost_vision_pref")
					var/static/list/vision_level_choices = list(GHOST_VISION_LEVEL_NO_NVG, GHOST_VISION_LEVEL_MID_NVG, GHOST_VISION_LEVEL_FULL_NVG)
					var/choice = preference_input_list(user, "选择默认幽灵夜视等级", "夜视等级", vision_level_choices)
					if(!choice)
						return
					ghost_vision_pref = choice
				if("mouse_button_activation")
					var/static/list/mouse_button_list = list(
						xeno_ability_mouse_pref_to_string(XENO_ABILITY_CLICK_MIDDLE) = XENO_ABILITY_CLICK_MIDDLE,
						xeno_ability_mouse_pref_to_string(XENO_ABILITY_CLICK_SHIFT) = XENO_ABILITY_CLICK_SHIFT,
						xeno_ability_mouse_pref_to_string(XENO_ABILITY_CLICK_RIGHT) = XENO_ABILITY_CLICK_RIGHT
					)
					var/choice = preference_input_list(user, "选择激活异形和人类技能的按键。", "技能激活鼠标按键", mouse_button_list)
					if(!choice)
						return
					xeno_ability_click_mode = mouse_button_list[choice]
					// This isn't that great of a way to do it, but ability code is already not that modular considering
					// the fact that we have two datums for xeno/human abilities. Might need to refactor abilities as a whole in the future
					// so that the `activable` type is the parent of both xeno/human abilities - it would get rid of this headache in an instant.
					if(isxeno(user))
						var/mob/living/carbon/xenomorph/xeno = user
						if(xeno.selected_ability)
							var/datum/action/xeno_action/activable/ability = xeno.selected_ability
							xeno.set_selected_ability(null)
							xeno.set_selected_ability(ability)
					if(ishuman(user))
						var/mob/living/carbon/human/human = user
						if(human.selected_ability)
							var/datum/action/human_action/activable/ability = human.selected_ability
							human.set_selected_ability(null)
							human.set_selected_ability(ability)
				if("plat_name")
					var/raw_name = input(user, "请输入排名称：", "角色偏好")  as text|null
					if(length(raw_name) > 16 || !length(raw_name)) // Check to ensure that the user entered text (rather than cancel.)
						to_chat(user, "<font color='red'>姓名无效。长度应为 2 至 [MAX_NAME_LEN] 个字符，仅可包含 A-Z、a-z、-、' 和 .。</font>")
					else
						platoon_name = raw_name

				if ("dropship_camo")
					var/new_camo = preference_input_list(user, "选择排属运输艇的涂装：", "角色偏好", GLOB.dropship_camos)

					if (new_camo)
						dropship_camo = new_camo

				if("dropship_name")
					var/raw_name = input(user, "请输入排属运输艇的名称：", "角色偏好")  as text|null
					if(length(raw_name) > 10 || !length(raw_name)) // Check to ensure that the user entered text (rather than cancel.)
						to_chat(user, "<font color='red'>姓名无效。长度应为 2 至 [MAX_NAME_LEN] 个字符，仅可包含 A-Z、a-z、-、' 和 .。</font>")
					else
						dropship_name = raw_name

				if("synth_name")
					var/raw_name = input(user, "请输入合成人姓名：", "角色偏好")  as text|null
					if(raw_name) // Check to ensure that the user entered text (rather than cancel.)
						var/new_name = reject_bad_name(raw_name)
						if(new_name) synthetic_name = new_name
						else to_chat(user, "<font color='red'>姓名无效。长度应为 2 至 [MAX_NAME_LEN] 个字符，仅可包含 A-Z、a-z、-、' 和 .。</font>")
				if("synth_type")
					var/new_synth_type = preference_input_list(user, "选择合成人型号：", "制造商与型号", PLAYER_SYNTHS)
					if(new_synth_type) synthetic_type = new_synth_type
				if("pred_name")
					var/raw_name = input(user, "请输入铁血战士姓名：", "角色偏好")  as text|null
					if(raw_name) // Check to ensure that the user entered text (rather than cancel.)
						var/new_name = reject_bad_name(raw_name)
						if(new_name) predator_name = new_name
						else to_chat(user, "<font color='red'>姓名无效。长度应为 2 至 [MAX_NAME_LEN] 个字符，仅可包含 A-Z、a-z、-、' 和 .。</font>")
				if("pred_gender")
					predator_gender = predator_gender == MALE ? FEMALE : MALE
				if("pred_age")
					var/new_predator_age = tgui_input_number(user, "设置铁血战士年龄（175 至 3000）：", "角色偏好", 1234, 3000, 175)
					if(new_predator_age)
						predator_age = max(min( floor(text2num(new_predator_age)), 3000),175)
				if("pred_use_legacy")
					var/legacy_choice = preference_input_list(user, "选择要使用的传承套装：", "传承套装", PRED_LEGACIES)
					if(!legacy_choice)
						return
					predator_use_legacy = legacy_choice
				if("pred_trans_type")
					var/new_translator_type = preference_input_list(user, "选择翻译器类型。", "翻译器类型", PRED_TRANSLATORS)
					if(!new_translator_type)
						return
					predator_translator_type = new_translator_type
				if("pred_mask_type")
					var/new_predator_mask_type = tgui_input_number(user, "选择面具样式：\n（1–12）", "选择面具", 1, 12, 1)
					if(new_predator_mask_type) predator_mask_type = floor(text2num(new_predator_mask_type))
				if("pred_armor_type")
					var/new_predator_armor_type = tgui_input_number(user, "选择护甲样式：\n（1–7）", "选择护甲", 1, 7, 1)
					if(new_predator_armor_type) predator_armor_type = floor(text2num(new_predator_armor_type))
				if("pred_boot_type")
					var/new_predator_boot_type = tgui_input_number(user, "选择护胫样式：\n（1–4）", "选择护胫", 1, 4, 1)
					if(new_predator_boot_type) predator_boot_type = floor(text2num(new_predator_boot_type))
				if("pred_mask_mat")
					var/new_pred_mask_mat = preference_input_list(user, "选择面具材质：", "面具材质", PRED_MATERIALS)
					if(!new_pred_mask_mat)
						return
					predator_mask_material = new_pred_mask_mat
				if("pred_armor_mat")
					var/new_pred_armor_mat = preference_input_list(user, "选择护甲材质：", "护甲材质", PRED_MATERIALS)
					if(!new_pred_armor_mat)
						return
					predator_armor_material = new_pred_armor_mat
				if("pred_greave_mat")
					var/new_pred_greave_mat = preference_input_list(user, "选择护胫材质：", "护胫材质", PRED_MATERIALS)
					if(!new_pred_greave_mat)
						return
					predator_greave_material = new_pred_greave_mat
				if("pred_caster_mat")
					var/new_pred_caster_mat = preference_input_list(user, "选择肩炮材质：", "肩炮材质", PRED_MATERIALS + "retro")
					if(!new_pred_caster_mat)
						return
					predator_caster_material = new_pred_caster_mat
				if("pred_cape_type")
					var/datum/job/J = GLOB.RoleAuthority.roles_by_name[JOB_PREDATOR]
					var/whitelist_status = GLOB.clan_ranks_ordered[J.get_whitelist_status(owner)]

					var/list/options = list("None" = "None")
					for(var/cape_name in GLOB.all_yautja_capes)
						var/obj/item/clothing/yautja_cape/cape = GLOB.all_yautja_capes[cape_name]
						if(whitelist_status >= initial(cape.clan_rank_required) || (initial(cape.councillor_override) && (whitelist_flags & (WHITELIST_YAUTJA_COUNCIL|WHITELIST_YAUTJA_COUNCIL_LEGACY))))
							options += list(capitalize_first_letters(cape_name) = cape_name)

					var/new_cape = preference_input_list(user, "选择披风类型：", "披风类型", options)
					if(!new_cape)
						return
					predator_cape_type = options[new_cape]
				if("pred_cape_color")
					var/new_cape_color = input(user, "选择披风颜色：", "披风颜色", predator_cape_color) as color|null
					if(!new_cape_color)
						return
					predator_cape_color = new_cape_color
				if("pred_hair")
					var/new_h_style = preference_input_list(user, "选择棘发样式：", "棘发样式", GLOB.yautja_hair_styles_list)
					if(!new_h_style)
						return
					predator_h_style = new_h_style
				if("pred_skin")
					var/new_skin_color = preference_input_list(user, "选择肤色：", "肤色", PRED_SKIN_COLOR)
					if(!new_skin_color)
						return
					predator_skin_color = new_skin_color
				if("pred_flavor_text")
					var/pred_flv_raw = input(user, "填写铁血战士的外观描述。字数上限为 [MAX_FLAVOR_MESSAGE_LEN]：", "外观描述", predator_flavor_text) as message
					if(!pred_flv_raw)
						predator_flavor_text = ""
						return
					predator_flavor_text = strip_html(pred_flv_raw, MAX_FLAVOR_MESSAGE_LEN)

				if("commander_status")
					var/list/options = list("Normal" = WHITELIST_NORMAL)

					if(whitelist_flags & (WHITELIST_COMMANDER_COUNCIL|WHITELIST_COMMANDER_COUNCIL_LEGACY))
						options += list("Council" = WHITELIST_COUNCIL)
					if(whitelist_flags & (WHITELIST_COMMANDER_LEADER|WHITELIST_COMMANDER_COLONEL))
						options += list("Leader" = WHITELIST_LEADER)

					var/new_commander_status = preference_input_list(user, "选择指挥官白名单等级。", "指挥官白名单等级", options)

					if(!new_commander_status)
						return

					commander_status = options[new_commander_status]

				if("co_sidearm")
					var/list/options = CO_GUNS

					if(whitelist_flags & (WHITELIST_COMMANDER_COUNCIL|WHITELIST_COMMANDER_COUNCIL_LEGACY))
						options += COUNCIL_CO_GUNS
					else
						options -= COUNCIL_CO_GUNS

					var/new_co_sidearm = preference_input_list(user, "选择偏好的配枪。", "指挥官配枪", options)
					if(!new_co_sidearm)
						return
					commander_sidearm = new_co_sidearm

				if("co_affiliation")
					var/new_co_affiliation = preference_input_list(user, "选择所属阵营。", "指挥官所属阵营", FACTION_ALLEGIANCE_USCM_COMMANDER)
					if(!new_co_affiliation)
						return
					affiliation = new_co_affiliation


				if("yautja_status")
					var/list/options = list("Normal" = WHITELIST_NORMAL)

					if(whitelist_flags & (WHITELIST_YAUTJA_COUNCIL|WHITELIST_YAUTJA_COUNCIL_LEGACY))
						options += list("Council" = WHITELIST_COUNCIL)
					if(whitelist_flags & WHITELIST_YAUTJA_LEADER)
						options += list("Leader" = WHITELIST_LEADER)

					var/new_yautja_status = preference_input_list(user, "选择铁血战士白名单等级。", "铁血战士白名单等级", options)

					if(!new_yautja_status)
						return

					yautja_status = options[new_yautja_status]

				if("synth_status")
					var/list/options = list("Normal" = WHITELIST_NORMAL)

					if(whitelist_flags & (WHITELIST_SYNTHETIC_COUNCIL|WHITELIST_SYNTHETIC_COUNCIL_LEGACY))
						options += list("Council" = WHITELIST_COUNCIL)
					if(whitelist_flags & WHITELIST_SYNTHETIC_LEADER)
						options += list("Leader" = WHITELIST_LEADER)

					var/new_synth_status = preference_input_list(user, "选择合成人白名单等级。", "合成人白名单等级", options)

					if(!new_synth_status)
						return

					synth_status = options[new_synth_status]

				if("xeno_prefix")
					if(xeno_name_ban)
						to_chat(user, SPAN_WARNING(FONT_SIZE_BIG("你已被禁止自定义异形名称。")))
						xeno_prefix = ""
						return

					var/new_xeno_prefix = input(user, "设置异形编号前缀，使用一到两个大写字母。留空则使用默认值“XX”。", "异形编号前缀") as text|null
					new_xeno_prefix = uppertext(new_xeno_prefix)

					var/prefix_length = length(new_xeno_prefix)

					if(prefix_length > 3)
						to_chat(user, SPAN_WARNING(FONT_SIZE_BIG("异形编号前缀无效，最多只能包含 3 个字母。")))
						return

					if(prefix_length == 3)
						if(xeno_postfix)
							to_chat(user, SPAN_WARNING(FONT_SIZE_BIG("使用三个字母的前缀时不能添加后缀。")))
							return

					if(length(new_xeno_prefix)==0)
						xeno_prefix = "XX"
						owner.load_xeno_name()
					else
						var/all_ok = TRUE
						for(var/i=1, i<=length(new_xeno_prefix), i++)
							var/ascii_char = text2ascii(new_xeno_prefix,i)
							if(ascii_char < 65 || ascii_char > 90)
								all_ok = FALSE //everything else - won't
						if(all_ok)
							xeno_prefix = new_xeno_prefix
							owner.load_xeno_name()
						else
							to_chat(user, "<font color='red'>异形编号前缀无效，应包含一到两个字母。</font>")

				if("xeno_postfix")
					if(xeno_name_ban)
						to_chat(user, SPAN_WARNING(FONT_SIZE_BIG("你已被禁止自定义异形名称。")))
						xeno_postfix = ""
						return

					if(length(xeno_prefix) == 3)
						to_chat(user, SPAN_WARNING(FONT_SIZE_BIG("使用三个字母的前缀时不能添加后缀。")))
						return

					var/new_xeno_postfix = input(user, "设置异形编号后缀：一个大写字母，后面可附一位数字。留空则移除后缀。", "异形编号后缀") as text|null
					new_xeno_postfix = uppertext(new_xeno_postfix)
					if(length(new_xeno_postfix)>2)
						to_chat(user, SPAN_WARNING(FONT_SIZE_BIG("异形编号后缀无效，最多只能包含 2 个字符。")))
						return
					else if(length(new_xeno_postfix)==0)
						xeno_postfix = ""
						owner.load_xeno_name()
					else
						var/all_ok = TRUE
						var/first_char = TRUE
						for(var/i=1, i<=length(new_xeno_postfix), i++)
							var/ascii_char = text2ascii(new_xeno_postfix,i)

							switch(ascii_char)
								// A  .. Z
								if(65 to 90) //Uppercase Letters will work on first char
									if(length(xeno_prefix)!=2)
										to_chat(user, SPAN_WARNING(FONT_SIZE_BIG("使用三个字母的前缀时不能添加后缀。")))
										return

								// 0  .. 9
								if(48 to 57) //Numbers will work if not the first char
									if(first_char)
										all_ok = FALSE

								else
									all_ok = FALSE //everything else - won't

							first_char = FALSE
						if(all_ok)
							xeno_postfix = new_xeno_postfix
							owner.load_xeno_name()
						else
							to_chat(user, "<font color='red'>异形编号后缀无效，应为一个字母，后面可附一位数字。</font>")

				if("age")
					var/new_age = tgui_input_number(user, "设置角色年龄：\n（[AGE_MIN]–[AGE_MAX]）", "角色偏好", 19, AGE_MAX, AGE_MIN)
					if(new_age)
						age = max(min( floor(text2num(new_age)), AGE_MAX),AGE_MIN)

				if("metadata")
					var/new_metadata = input(user, "填写希望其他玩家看到的信息，例如角色扮演偏好：", "游戏偏好" , metadata)  as message|null
					if(new_metadata)
						metadata = strip_html(new_metadata)

				if("hair")
					if(species == "Human")
						var/new_hair = input(user, "选择角色发色：", "角色偏好", rgb(r_hair, g_hair, b_hair)) as color|null
						if(new_hair)
							r_hair = hex2num(copytext(new_hair, 2, 4))
							g_hair = hex2num(copytext(new_hair, 4, 6))
							b_hair = hex2num(copytext(new_hair, 6, 8))

				if("h_style")
					var/list/valid_hairstyles = list()
					for(var/hairstyle in GLOB.hair_styles_list)
						var/datum/sprite_accessory/sprite_accessory = GLOB.hair_styles_list[hairstyle]
						if( !(species in sprite_accessory.species_allowed))
							continue
						if(!sprite_accessory.selectable)
							continue

						valid_hairstyles[hairstyle] = GLOB.hair_styles_list[hairstyle]
					valid_hairstyles = sortList(valid_hairstyles)

					var/new_h_style = preference_input_list(user, "选择角色发型：", "角色偏好", valid_hairstyles)
					if(new_h_style)
						h_style = new_h_style

				if("grad")
					if(species == "Human")
						var/new_hair_grad = input(user, "选择角色渐变染发颜色：", "角色偏好", rgb(r_gradient, g_gradient, b_gradient)) as color|null
						if(new_hair_grad)
							r_gradient = hex2num(copytext(new_hair_grad, 2, 4))
							g_gradient = hex2num(copytext(new_hair_grad, 4, 6))
							b_gradient = hex2num(copytext(new_hair_grad, 6, 8))

				if("grad_style")
					var/list/valid_hair_gradients = list()
					for(var/hair_gradient in GLOB.hair_gradient_list)
						var/datum/sprite_accessory/sprite_accessory = GLOB.hair_gradient_list[hair_gradient]
						if(!(species in sprite_accessory.species_allowed))
							continue
						if(!sprite_accessory.selectable)
							continue
						valid_hair_gradients[hair_gradient] = GLOB.hair_gradient_list[hair_gradient]
					valid_hair_gradients = sortList(valid_hair_gradients)

					var/new_h_gradient_style = preference_input_list(user, "选择角色渐变染发样式：", "角色偏好", valid_hair_gradients)
					if(new_h_gradient_style)
						grad_style = new_h_gradient_style

				if ("skin_color")
					var/new_skin_color = preference_input_list(user, "选择角色肤色：", "角色偏好", GLOB.skin_color_list)

					if (new_skin_color)
						skin_color = new_skin_color

				if ("body_size")
					var/new_body_size = preference_input_list(user, "选择角色体格：", "角色偏好", GLOB.body_size_list)

					if (new_body_size)
						body_size = new_body_size

				if ("body_type")
					var/new_body_type = preference_input_list(user, "选择角色肌肉发达程度：", "角色偏好", GLOB.body_type_list)

					if (new_body_type)
						body_type = new_body_type

				if ("body_size")
					var/new_body_size = preference_input_list(user, "选择角色体格：", "角色偏好", GLOB.body_size_list)

					if (new_body_size)
						body_size = new_body_size

				if("facial")
					var/new_facial = input(user, "选择角色胡须颜色：", "角色偏好", rgb(r_facial, g_facial, b_facial)) as color|null
					if(new_facial)
						r_facial = hex2num(copytext(new_facial, 2, 4))
						g_facial = hex2num(copytext(new_facial, 4, 6))
						b_facial = hex2num(copytext(new_facial, 6, 8))

				if("f_style")
					var/list/valid_facialhairstyles = list()
					for(var/facialhairstyle in GLOB.facial_hair_styles_list)
						var/datum/sprite_accessory/sprite_accessory = GLOB.facial_hair_styles_list[facialhairstyle]
						if(gender == MALE && sprite_accessory.gender == FEMALE)
							continue
						if(gender == FEMALE && sprite_accessory.gender == MALE)
							continue
						if( !(species in sprite_accessory.species_allowed))
							continue
						if(!sprite_accessory.selectable)
							continue

						valid_facialhairstyles[facialhairstyle] = GLOB.facial_hair_styles_list[facialhairstyle]
					valid_facialhairstyles = sortList(valid_facialhairstyles)

					var/new_f_style = preference_input_list(user, "选择角色胡须样式：", "角色偏好", valid_facialhairstyles)
					if(new_f_style)
						f_style = new_f_style

				if("personalweapon")
					var/new_weapon = preference_input_list(user, "选择角色个人武器：", "角色偏好（仅限 USCM）", GLOB.personal_weapons_list+"None")
					if(new_weapon)
						personal_weapon = new_weapon
					ShowChoices(user)

				if("underwear")
					var/list/underwear_options = gender == MALE ? GLOB.underwear_m : GLOB.underwear_f
					var/old_gender = gender
					var/new_underwear = preference_input_list(user, "选择角色内衣：", "角色偏好", underwear_options-GLOB.underwear_restricted)
					if(old_gender != gender)
						return
					if(new_underwear)
						underwear = new_underwear
					ShowChoices(user)

				if("undershirt")
					var/list/undershirt_options = gender == MALE ? GLOB.undershirt_m : GLOB.undershirt_f
					var/old_gender = gender
					var/new_undershirt = preference_input_list(user, "选择角色贴身上衣：", "角色偏好", undershirt_options-GLOB.undershirt_restricted)
					if(old_gender != gender)
						return
					if(new_undershirt)
						undershirt = new_undershirt
					ShowChoices(user)

				if("eyes")
					var/new_eyes = input(user, "选择角色眼睛颜色：", "角色偏好", rgb(r_eyes, g_eyes, b_eyes)) as color|null
					if(new_eyes)
						r_eyes = hex2num(copytext(new_eyes, 2, 4))
						g_eyes = hex2num(copytext(new_eyes, 4, 6))
						b_eyes = hex2num(copytext(new_eyes, 6, 8))


				if("ooccolor")
					var/new_ooccolor = input(user, "选择 OOC 聊天颜色：", "游戏偏好", ooccolor) as color|null
					if(new_ooccolor)
						ooccolor = new_ooccolor

				if("bag")
					var/new_backbag = preference_input_list(user, "选择角色背包类型：", "角色偏好", GLOB.backbaglist)
					if(new_backbag)
						backbag = GLOB.backbaglist.Find(new_backbag)

				if("wy_relation")
					var/new_relation = preference_input_list(user, "选择与维兰德-汤谷公司的关系。这表示其他人调查角色背景后能够得知的立场，而非角色内心的真实想法。", "角色偏好", list("Loyal", "Supportive", "Neutral", "Skeptical", "Opposed"))
					if(new_relation)
						weyland_yutani_relation = new_relation

				if("prefsquad")
					var/new_pref_squad = preference_input_list(user, "选择偏好的小队。", "角色偏好", list("Alpha", "Bravo", "Charlie", "Delta", "None"))
					if(new_pref_squad)
						preferred_squad = new_pref_squad

				if("prefarmor")
					var/new_pref_armor = preference_input_list(user, "选择角色默认护甲样式：", "角色偏好", GLOB.armor_style_list)
					if(new_pref_armor)
						preferred_armor = new_pref_armor
						// Update the dummy with the new armor style.
						update_preview_icon()

				if("limbs")
					var/limb_name = preference_input_list(user, "选择要更改的肢体：", "肢体", list("Left Leg","Right Leg","Left Arm","Right Arm","Left Foot","Right Foot","Left Hand","Right Hand"))
					if(!limb_name) return

					var/limb = null
					var/second_limb = null // if you try to change the arm, the hand should also change
					var/third_limb = null  // if you try to unchange the hand, the arm should also change
					switch(limb_name)
						if("Left Leg")
							limb = "l_leg"
							second_limb = "l_foot"
						if("Right Leg")
							limb = "r_leg"
							second_limb = "r_foot"
						if("Left Arm")
							limb = "l_arm"
							second_limb = "l_hand"
						if("Right Arm")
							limb = "r_arm"
							second_limb = "r_hand"
						if("Left Foot")
							limb = "l_foot"
							third_limb = "l_leg"
						if("Right Foot")
							limb = "r_foot"
							third_limb = "r_leg"
						if("Left Hand")
							limb = "l_hand"
							third_limb = "l_arm"
						if("Right Hand")
							limb = "r_hand"
							third_limb = "r_arm"

					var/new_state = preference_input_list(user, "选择肢体状态：", "肢体状态", list("Normal","Prothesis")) //"Amputated")
					if(!new_state) return

					switch(new_state)
						if("Normal")
							organ_data[limb] = null
							if(third_limb)
								organ_data[third_limb] = null
						if("Prothesis")
							organ_data[limb] = "cyborg"
							if(second_limb)
								organ_data[second_limb] = "cyborg"
							if(third_limb && organ_data[third_limb] == "amputated")
								organ_data[third_limb] = null
				if("organs")
					var/organ_name = preference_input_list(user, "选择要更改的器官：", "器官", list("Heart", "Eyes"))
					if(!organ_name) return

					var/organ = null
					switch(organ_name)
						if("Heart")
							organ = "heart"
						if("Eyes")
							organ = "eyes"

					var/new_state = preference_input_list(user, "选择器官状态：", "器官状态", list("Normal","Assisted","Mechanical"))
					if(!new_state) return

					switch(new_state)
						if("Normal")
							organ_data[organ] = null
						if("Assisted")
							organ_data[organ] = "assisted"
						if("Mechanical")
							organ_data[organ] = "mechanical"

				if("skin_style")
					var/skin_style_name = preference_input_list(user, "选择新的皮肤样式", "皮肤样式", list("default1", "default2", "default3"))
					if(!skin_style_name) return

				if("origin")
					var/choice = preference_input_list(user, "选择角色出身。", "选择出身", GLOB.player_origins)
					var/datum/origin/picked_choice = GLOB.origins[choice]
					if(!picked_choice)
						return
					if(tgui_alert(user, "你选择了 [preference_label(picked_choice.name)]。[picked_choice.desc]", "所选出身", list("确认", "取消")) == "取消")
						return
					if(choice)
						origin = choice

				if("religion")
					var/choice = preference_input_list(user, "选择宗教。", "选择宗教", GLOB.religion_choices + "Other")
					if(!choice)
						return
					if(choice == "Other")
						var/raw_choice = input(user, "请输入宗教名称。")  as text|null
						if(raw_choice)
							religion = strip_html(raw_choice) // This only updates itself in the UI when another change is made, eg. save slot or changing other char settings.
						return
					religion = choice

				if("special_job_select")
					var/datum/job/job = GLOB.RoleAuthority.roles_by_name[href_list["text"]]
					if(!job)
						close_browser(user, "mob_occupation")
						ShowChoices(user)
						return

					var/list/filtered_options = job.filter_job_option(user)

					var/new_special_job_variant = preference_input_list(user, "选择偏好的职业分支：", "偏好职业分支", filtered_options)
					if(!new_special_job_variant)
						return
					pref_special_job_options[job.title] = new_special_job_variant

					SetChoices(user)
					return
		else
			switch(href_list["preference"])
				if("publicity")
					if(unlock_content)
						toggle_prefs ^= TOGGLE_MEMBER_PUBLIC

				if("ooc_flag")
					if(CONFIG_GET(flag/ooc_country_flags))
						toggle_prefs ^= TOGGLE_OOC_FLAG
					else
						to_chat(user, SPAN_WARNING("当前服务器配置已禁用 OOC 国旗！"))

				if("gender")
					if(gender == MALE)
						gender = FEMALE
					else
						gender = MALE
					underwear = sanitize_inlist(underwear, gender == MALE ? GLOB.underwear_m : GLOB.underwear_f, initial(underwear))
					undershirt = sanitize_inlist(undershirt, gender == MALE ? GLOB.undershirt_m : GLOB.undershirt_f, initial(undershirt))

				if("hear_adminhelps")
					toggles_sound ^= SOUND_ADMINHELP

				if("ui")
					var/ui_style_choice = preference_input_list(user, "选择界面样式", "界面样式", GLOB.custom_human_huds)
					if(ui_style_choice)
						UI_style = ui_style_choice

				if("UIcolor")
					var/UI_style_color_new = input(user, "选择界面颜色，不建议使用深色！", UI_style_color) as color|null
					if(UI_style_color_new)
						UI_style_color = UI_style_color_new

				if("UIalpha")
					var/UI_style_alpha_new = tgui_input_number(user, "设置界面不透明度，范围为 50 至 255", "设置不透明度", 255, 255, 50)
					if(!UI_style_alpha_new || !(UI_style_alpha_new <= 255 && UI_style_alpha_new >= 50))
						return
					UI_style_alpha = UI_style_alpha_new

				if("stylesheet")
					var/stylesheet_new = preference_input_list(user, "选择样式表（影响非 NanoUI 界面）", "选择样式表", GLOB.stylesheets)
					stylesheet = stylesheet_new

				if("hide_statusbar")
					hide_statusbar = !hide_statusbar
					if(hide_statusbar)
						winset(owner, "mapwindow.status_bar", "text=\"\"")
						winset(owner, "mapwindow.status_bar", "is-visible=false")
					else
						winset(owner, "mapwindow.status_bar", "is-visible=true")


				if("no_radials_preference")
					no_radials_preference = !no_radials_preference

				if("no_radial_labels_preference")
					no_radial_labels_preference = !no_radial_labels_preference

				if("ViewMC")
					if(user.client.admin_holder && user.client.admin_holder.rights & R_DEBUG)
						View_MC = !View_MC

				if("playtime_perks")
					playtime_perks = !playtime_perks

				if("be_special")
					var/num = text2num(href_list["num"])
					be_special ^= (1<<num)

				if("rand_name")
					be_random_name = !be_random_name

				if("rand_body")
					be_random_body = !be_random_body

				if("hear_admin_sounds")
					toggles_sound ^= SOUND_MIDI
					if(!(toggles_sound & SOUND_MIDI))
						user?.client?.tgui_panel?.stop_music()

				if("hear_observer_announcements")
					toggles_sound ^= SOUND_OBSERVER_ANNOUNCEMENTS

				if("hear_faxes")
					toggles_sound ^= SOUND_FAX_MACHINE

				if("lobby_music")
					toggles_sound ^= SOUND_LOBBY
					if(toggles_sound & SOUND_LOBBY)
						user << sound(SSticker.login_music, repeat = 0, wait = 0, volume = 85, channel = 1)
					else
						user << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1)

				if("sound_vox")
					hear_vox = !hear_vox

				if("ghost_ears")
					toggles_chat ^= CHAT_GHOSTEARS

				if("ghost_sight")
					toggles_chat ^= CHAT_GHOSTSIGHT

				if("ghost_radio")
					toggles_chat ^= CHAT_GHOSTRADIO

				if("ghost_spyradio")
					toggles_chat ^= CHAT_LISTENINGBUG

				if("ghost_hivemind")
					toggles_chat ^= CHAT_GHOSTHIVEMIND

				if("langchat_emotes")
					toggles_langchat ^= LANGCHAT_SEE_EMOTES

				if("lang_chat_disabled")
					lang_chat_disabled = !lang_chat_disabled

				if("viewmacros")
					macros.tgui_interact(usr)

				if("toggle_prefs")
					var/flag = text2num(href_list["flag"])
					var/flag_undo = text2num(href_list["flag_undo"])
					toggle_prefs ^= flag
					if (toggle_prefs & flag && toggle_prefs & flag_undo)
						toggle_prefs ^= flag_undo

				if("switch_prefs") //wart
					var/list/pref_list = list(text2num(href_list["flag1"]), text2num(href_list["flag2"]), text2num(href_list["flag3"]))
					var/pref_new = preference_input_list(user, "选择所需的偏好等级", "选择偏好等级", pref_list)
					for(var/flag in pref_list)
						//remove all flags in list
						if(CHECK_BITFIELD(toggle_prefs, flag))
							DISABLE_BITFIELD(toggle_prefs, flag)
					//add the new flag
					ENABLE_BITFIELD(toggle_prefs, pref_new)

				if("toggles_ert")
					var/flag = text2num(href_list["flag"])
					toggles_ert ^= flag

				if("ambientocclusion")
					toggle_prefs ^= TOGGLE_AMBIENT_OCCLUSION
					var/atom/movable/screen/plane_master/game_world/plane_master = locate() in user?.client.screen
					if (!plane_master)
						return
					plane_master.backdrop(user?.client.mob)

				if("auto_fit_viewport")
					auto_fit_viewport = !auto_fit_viewport
					if(auto_fit_viewport && owner)
						owner.fit_viewport()

				if("adaptive_zoom")
					adaptive_zoom += 1
					if(adaptive_zoom == 3)
						adaptive_zoom = 0
					owner?.adaptive_zoom()

				if("tooltips")
					tooltips = !tooltips
					save_preferences()

					if(!tooltips)
						closeToolTip()
						return

					if(!owner.tooltips)
						owner.tooltips = new(owner)

				if("inputstyle")
					var/result = tgui_alert(user, "选择聊天输入框样式：", "输入框样式", list("现代", "旧版"))
					if(!result)
						return
					if(result == "旧版")
						tgui_say = FALSE
						to_chat(user, SPAN_NOTICE("你现在使用旧版界面。"))
					else
						tgui_say = TRUE
						to_chat(user, SPAN_NOTICE("你现在使用新版界面。"))
					user?.client.update_special_keybinds()
					save_preferences()

				if("inputcolor")
					var/result = tgui_alert(user, "选择聊天输入框配色：", "输入框样式", list("深色模式", "浅色模式"))
					if(!result)
						return
					if(result == "浅色模式")
						tgui_say_light_mode = TRUE
						to_chat(user, SPAN_NOTICE("聊天输入框已切换为浅色模式。"))
					else
						tgui_say_light_mode = FALSE
						to_chat(user, SPAN_NOTICE("聊天输入框已切换为深色模式。"))
					user?.client.tgui_say?.load()
					save_preferences()

				if("customcursors")
					owner?.do_toggle_custom_cursors(owner?.mob)

				if("save")
					if(save_cooldown > world.time)
						to_chat(user, SPAN_WARNING("请等待 [floor((save_cooldown-world.time)/10)] 秒后再试。"))
						return
					var/datum/origin/character_origin = GLOB.origins[origin]
					var/name_error = character_origin.validate_name(real_name)
					if(name_error)
						tgui_alert(user, name_error, "姓名无效", list("确认"))
						return
					save_preferences()
					save_character()
					save_cooldown = world.time + 50
					var/mob/new_player/np = user
					if(istype(np))
						np.new_player_panel_proc()

				if("reload")
					if(reload_cooldown > world.time)
						to_chat(user, SPAN_WARNING("请等待 [floor((reload_cooldown-world.time)/10)] 秒后再试。"))
						return
					load_preferences()
					load_character()
					reload_cooldown = world.time + 50

				if("open_load_dialog")
					if(!IsGuestKey(user.key))
						open_load_dialog(user)
						return TRUE

				if("close_load_dialog")
					close_load_dialog(user)
					return TRUE

				if("changeslot")
					load_character(text2num(href_list["num"]))
					close_load_dialog(user)
					var/mob/new_player/np = user
					if(istype(np))
						np.new_player_panel_proc()
				if("tgui_fancy")
					tgui_fancy = !tgui_fancy
				if("tgui_lock")
					tgui_lock = !tgui_lock
				if("window_scale")
					window_scale = !window_scale
					owner.tgui_say?.load()

				if("change_menu")
					current_menu = href_list["menu"]
	ShowChoices(user)
	return 1


/// Loads appropriate character slot for the given job as assigned in preferences.
/datum/preferences/proc/find_assigned_slot(job_title, is_late_join = FALSE)
	if(toggle_prefs & (is_late_join ? TOGGLE_LATE_JOIN_CURRENT_SLOT : TOGGLE_START_JOIN_CURRENT_SLOT))
		return
	var/slot_for_job = pref_job_slots[job_title]
	switch(slot_for_job)
		if(JOB_SLOT_RANDOMISED_SLOT)
			be_random_body = TRUE
			be_random_name = TRUE
		if(1 to MAX_SAVE_SLOTS)
			load_character(slot_for_job)

/// Transfers both physical characteristics and character information to character
/datum/preferences/proc/copy_all_to(mob/living/carbon/human/character, job_title, is_late_join = FALSE, check_datacore = FALSE)
	if(!istype(character))
		return

	if(job_title)
		find_assigned_slot(job_title, is_late_join)
	if(check_datacore && !(be_random_body && be_random_name))
		for(var/datum/data/record/record as anything in GLOB.data_core.locked)
			if(record.fields["name"] == real_name)
				be_random_body = TRUE
				be_random_name = TRUE
				break

	if(be_random_name)
		real_name = random_name(gender)

	if(CONFIG_GET(flag/humans_need_surnames))
		var/firstspace = findtext(real_name, " ")
		var/name_length = length(real_name)
		if(!firstspace) //we need a surname
			real_name += " [pick(GLOB.last_names)]"
		else if(firstspace == name_length)
			real_name += "[pick(GLOB.last_names)]"

	character.real_name = real_name
	character.voice = real_name
	character.name = character.real_name

	if(!be_random_body)
		character.flavor_texts["general"] = flavor_texts["general"]
		character.flavor_texts["head"] = flavor_texts["head"]
		character.flavor_texts["face"] = flavor_texts["face"]
		character.flavor_texts["eyes"] = flavor_texts["eyes"]
		character.flavor_texts["torso"] = flavor_texts["torso"]
		character.flavor_texts["arms"] = flavor_texts["arms"]
		character.flavor_texts["hands"] = flavor_texts["hands"]
		character.flavor_texts["legs"] = flavor_texts["legs"]
		character.flavor_texts["feet"] = flavor_texts["feet"]
		character.flavor_texts["helmet"] = flavor_texts["helmet"]
		character.flavor_texts["armor"] = flavor_texts["armor"]

	if(!be_random_name)
		character.med_record = strip_html(med_record, MAX_RECORDS_MESSAGE_LEN)
		character.sec_record = strip_html(sec_record, MAX_RECORDS_MESSAGE_LEN)
		character.gen_record = strip_html(gen_record, MAX_RECORDS_MESSAGE_LEN)
		character.exploit_record = strip_html(exploit_record)

	character.age = age
	character.gender = gender
	character.skin_color = skin_color
	character.body_type = body_type
	character.body_size = body_size

	character.r_eyes = r_eyes
	character.g_eyes = g_eyes
	character.b_eyes = b_eyes

	character.r_hair = r_hair
	character.g_hair = g_hair
	character.b_hair = b_hair

	if(/datum/character_trait/hair_dye in traits)
		character.r_gradient = r_gradient
		character.g_gradient = g_gradient
		character.b_gradient = b_gradient
		character.grad_style = grad_style
	else
		character.r_gradient = initial(character.r_gradient)
		character.g_gradient = initial(character.g_gradient)
		character.b_gradient = initial(character.b_gradient)
		character.grad_style = initial(character.grad_style)

	character.r_facial = r_facial
	character.g_facial = g_facial
	character.b_facial = b_facial

	character.r_skin = r_skin
	character.g_skin = g_skin
	character.b_skin = b_skin

	character.h_style = h_style
	character.f_style = f_style

	character.origin = origin
	character.personal_faction = faction
	character.religion = religion

	// Destroy/cyborgize organs

	for(var/name in organ_data)

		var/status = organ_data[name]
		var/obj/limb/O = character.get_limb(name)
		if(O)
// if(status == "amputated")
// O.amputated = 1
// O.status |= LIMB_DESTROYED
// O.destspawn = 1
			if(status == "cyborg")
				O.status |= LIMB_ROBOT
		else
			var/datum/internal_organ/I = character.internal_organs_by_name[name]
			if(I)
				if(status == "assisted")
					I.mechassist()
				else if(status == "mechanical")
					I.mechanize()

	sanitize_inlist(underwear, gender == MALE ? GLOB.underwear_m : GLOB.underwear_f, initial(underwear)) //I'm sure this is 100% unnecessary, but I'm paranoid... sue me. //HAH NOW NO MORE MAGIC CLONING UNDIES
	sanitize_inlist(undershirt, gender == MALE ? GLOB.undershirt_m : GLOB.undershirt_f, initial(undershirt))
	character.underwear = underwear
	character.undershirt = undershirt

	if(backbag > 2 || backbag < 1)
		backbag = 2 //Same as above
	character.backbag = backbag

	//Debugging report to track down a bug, which randomly assigned the plural gender to people.
	if(character.gender in list(PLURAL, NEUTER))
		if(isliving(src)) //Ghosts get neuter by default
			message_admins("[character] ([character.ckey]) has spawned with their gender as plural or neuter. Please notify coders.")
			character.gender = MALE

// Transfers the character's physical characteristics (age, gender, skin_color, etc) to the mob
/datum/preferences/proc/copy_appearance_to(mob/living/carbon/human/character, safety = 0)
	if(!istype(character))
		return

	character.age = age
	character.gender = gender
	character.skin_color = skin_color
	character.body_type = body_type
	character.body_size = body_size

	character.r_eyes = r_eyes
	character.g_eyes = g_eyes
	character.b_eyes = b_eyes

	character.r_hair = r_hair
	character.g_hair = g_hair
	character.b_hair = b_hair

	if(/datum/character_trait/hair_dye in traits)
		character.r_gradient = r_gradient
		character.g_gradient = g_gradient
		character.b_gradient = b_gradient
		character.grad_style = grad_style
	else
		character.r_gradient = initial(character.r_gradient)
		character.g_gradient = initial(character.g_gradient)
		character.b_gradient = initial(character.b_gradient)
		character.grad_style = initial(character.grad_style)

	character.r_facial = r_facial
	character.g_facial = g_facial
	character.b_facial = b_facial

	character.r_skin = r_skin
	character.g_skin = g_skin
	character.b_skin = b_skin

	character.h_style = h_style
	character.f_style = f_style

	// Destroy/cyborgize organs

	for(var/name in organ_data)

		var/status = organ_data[name]
		var/obj/limb/O = character.get_limb(name)
		if(O)
			if(status == "cyborg")
				O.status |= LIMB_ROBOT
		else
			var/datum/internal_organ/I = character.internal_organs_by_name[name]
			if(I)
				if(status == "assisted")
					I.mechassist()
				else if(status == "mechanical")
					I.mechanize()

	sanitize_inlist(underwear, gender == MALE ? GLOB.underwear_m : GLOB.underwear_f, initial(underwear)) //I'm sure this is 100% unnecessary, but I'm paranoid... sue me. //HAH NOW NO MORE MAGIC CLONING UNDIES
	sanitize_inlist(undershirt, gender == MALE ? GLOB.undershirt_m : GLOB.undershirt_f, initial(undershirt))
	character.underwear = underwear
	character.undershirt = undershirt

	if(backbag > 2 || backbag < 1)
		backbag = 2 //Same as above
	character.backbag = backbag

	//Debugging report to track down a bug, which randomly assigned the plural gender to people.
	if(character.gender in list(PLURAL, NEUTER))
		if(isliving(src)) //Ghosts get neuter by default
			message_admins("[character] ([character.ckey]) has spawned with their gender as plural or neuter. Please notify coders.")
			character.gender = MALE

/datum/preferences/proc/open_load_dialog(mob/user)
	var/dat = "<body onselectstart='return false;'>"
	dat += "<tt><center>"

	var/savefile/S = new /savefile(path)
	if(S)
		dat += "<b>选择要载入的角色槽</b><hr>"
		var/name
		for(var/i=1, i<=MAX_SAVE_SLOTS, i++)
			S.cd = "/character[i]"
			S["real_name"] >> name
			S["slot_label"] >> slot_label
			if(!name) name = "角色[i]"
			if(i==default_slot)
				name = "<b>[name]</b>"
			dat += "<a href='byond://?_src_=prefs;preference=changeslot;num=[i];'>[name] ([slot_label])</a><br>"

	dat += "<hr>"
	dat += "<a href='byond://?src=\ref[user];preference=close_load_dialog'>关闭</a><br>"
	dat += "</center></tt>"
	show_browser(user, dat, "载入角色", "saves")

/datum/preferences/proc/close_load_dialog(mob/user)
	close_browser(user, "saves")

/datum/preferences/proc/parse_key_down(client/source, key)
	SIGNAL_HANDLER
	key = uppertext(key)

	if (key in key_mod_buf)
		return

	if (key in GLOB.key_mods)
		key_mod_buf.Add(key)

/datum/preferences/proc/set_key_buf(client/source, key)
	SIGNAL_HANDLER
	key_buf = ""

	var/key_upper = uppertext(key)

	for (var/mod in key_mod_buf)
		if (mod == key_upper)
			continue
		key_buf += "[mod]+"

	key_mod_buf = null

	key_buf += key

/datum/preferences/proc/read_key()
	// Null out key_buf (it's the main 'signal' for when button has been pressed)
	key_buf = null

	// Initialize key_mod_buf
	key_mod_buf = list()

	// Store the old macro set being used (gonna load back after key_buf is set)
	var/old = params2list(winget(owner, "mainwindow", "macro"))[1]

	alert("点击下方确认，然后输入组合键！")

	RegisterSignal(owner, COMSIG_CLIENT_KEY_DOWN, PROC_REF(parse_key_down))
	RegisterSignal(owner, COMSIG_CLIENT_KEY_UP, PROC_REF(set_key_buf))
	winset(owner, null, "mainwindow.macro=keyreader")
	UNTIL(key_buf)
	winset(owner, null, "mainwindow.macro=[old]")
	UnregisterSignal(owner, list(
		COMSIG_CLIENT_KEY_DOWN,
		COMSIG_CLIENT_KEY_UP,
	))

	alert("组合键为 [key_buf]。")
	return key_buf

/datum/preferences/proc/open_character_traits(mob/user, character_trait_group)
	if(!read_traits)
		read_traits = TRUE
		for(var/trait in traits)
			var/datum/character_trait/character_trait = GLOB.character_traits[trait]
			trait_points -= character_trait.cost
	var/dat = "<body onselectstart='return false;'>"
	dat += "<center>"
	var/datum/character_trait_group/current_trait_group
	var/i = 1
	for(var/trait_group in GLOB.character_trait_groups)
		var/datum/character_trait_group/CTG = GLOB.character_trait_groups[trait_group]
		if(!CTG.group_visible)
			continue
		var/button_class = ""
		if(!character_trait_group && i == 1 || character_trait_group == trait_group)
			button_class = "class='linkOn'"
			current_trait_group = CTG
		dat += "<a style='white-space:nowrap;' href='byond://?_src_=prefs;preference=traits;task=change_slot;trait_group=[trait_group]' [button_class]>"
		dat += CTG.trait_group_name
		dat += "</a>"
		i++
	dat += "</center>"
	dat += "<table>"
	for(var/trait in current_trait_group.traits)
		var/datum/character_trait/character_trait = trait
		if(!character_trait.applyable)
			continue
		var/has_trait = (character_trait.type in traits)
		var/task = has_trait ? "remove_trait" : "give_trait"
		var/button_class = has_trait ? "class='linkOn'" : ""
		dat += "<tr><td width='40%'>"
		if(has_trait || character_trait.can_give_trait(src))
			dat += "<a href='byond://?_src_=prefs;preference=traits;task=[task];trait=[character_trait.type];trait_group=[current_trait_group.type]' [button_class]>"
			dat += "[character_trait.trait_name]"
			dat += "</a>"
		else
			dat += "<i>[character_trait.trait_name]</i>"
		var/cost_text = character_trait.cost ? "（[character_trait.cost] 点）" : ""
		dat += "</td><td>[character_trait.trait_desc][cost_text]</td></tr>"
		dat += ""
	dat += "</table>"
	dat += "</body>"
	show_browser(user, dat, "角色特质", "character_traits")
	update_preview_icon(TRUE)

/// Converts a client's list of completed tutorials into a string for saving
/datum/preferences/proc/tutorial_list_to_savestring()
	if(!length(completed_tutorials))
		return ""

	var/return_string = ""
	var/last_id = completed_tutorials[length(completed_tutorials)]
	for(var/tutorial_id in completed_tutorials)
		return_string += tutorial_id + (tutorial_id != last_id ? ";" : "")
	return return_string

/// Converts a saved string of completed tutorials into a list for in-game use
/datum/preferences/proc/tutorial_savestring_to_list(savestring)
	completed_tutorials = splittext(savestring, ";")
	return completed_tutorials

#undef MENU_MARINE
#undef MENU_XENOMORPH
#undef MENU_CO
#undef MENU_SYNTHETIC
#undef MENU_YAUTJA
#undef MENU_MENTOR
#undef MENU_SETTINGS
#undef MENU_SPECIAL
#undef MENU_PLTCO
