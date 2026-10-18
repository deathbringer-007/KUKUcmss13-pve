/**
 * Creates a TGUI alert window and returns the user's response.
 *
 * This proc should be used to create alerts that the caller will wait for a response from.
 * Arguments:
 * * user - The user to show the alert to.
 * * message - The content of the alert, shown in the body of the TGUI window.
 * * title - The of the alert modal, shown on the top of the TGUI window.
 * * buttons - The options that can be chosen by the user, each string is assigned a button on the UI.
 * * timeout - The timeout of the alert, after which the modal will close and qdel itself. Set to zero for no timeout.
 * * autofocus - The bool that controls if this alert should grab window focus.
 * * ui_state - The TGUI UI state that will be returned in ui_state(). Default: always_state
 */
/proc/tgui_alert(mob/user, message = "", title, list/buttons = list("Ok"), timeout = 60 SECONDS, autofocus = TRUE, ui_state = GLOB.always_state)
	if (!user)
		user = usr
	if (!istype(user))
		if (istype(user, /client))
			var/client/client = user
			user = client.mob
		else
			return null

	if(isnull(user.client))
		return null

	var/datum/tgui_modal/alert = new(user, message, title, buttons, timeout, autofocus, ui_state)
	alert.tgui_interact(user)
	alert.wait()
	if (alert)
		. = alert.choice
		qdel(alert)

/**
 * Creates an asynchronous TGUI alert window with an associated callback.
 *
 * This proc should be used to create alerts that invoke a callback with the user's chosen option.
 * Arguments:
 * * user - The user to show the alert to.
 * * message - The content of the alert, shown in the body of the TGUI window.
 * * title - The of the alert modal, shown on the top of the TGUI window.
 * * buttons - The options that can be chosen by the user, each string is assigned a button on the UI.
 * * callback - The callback to be invoked when a choice is made.
 * * timeout - The timeout of the alert, after which the modal will close and qdel itself. Set to zero for no timeout.
 * * autofocus - The bool that controls if this alert should grab window focus.
 * * ui_state - The TGUI UI state that will be returned in ui_state(). Default: always_state
 */
/proc/tgui_alert_async(mob/user, message = "", title, list/buttons = list("Ok"), datum/callback/callback, timeout = 60 SECONDS, autofocus = TRUE, ui_state = GLOB.always_state)
	if (!user)
		user = usr
	if (!istype(user))
		if (istype(user, /client))
			var/client/client = user
			user = client.mob
		else
			return null

	if(isnull(user.client))
		return null

	var/datum/tgui_modal/async/alert = new(user, message, title, buttons, callback, timeout, autofocus, ui_state)
	alert.tgui_interact(user)

/**
 * # tgui_modal
 *
 * Datum used for instantiating and using a TGUI-controlled modal that prompts the user with
 * a message and has buttons for responses.
 */
/datum/tgui_modal
	/// The title of the TGUI window
	var/title
	/// The textual body of the TGUI window
	var/message
	/// The list of buttons (responses) provided on the TGUI window
	var/list/buttons
	/// The button that the user has pressed, null if no selection has been made
	var/choice
	/// The time at which the tgui_modal was created, for displaying timeout progress.
	var/start_time
	/// The lifespan of the tgui_modal, after which the window will close and delete itself.
	var/timeout
	/// The bool that controls if this modal should grab window focus
	var/autofocus
	/// Boolean field describing if the tgui_modal was closed by the user.
	var/closed
	/// The TGUI UI state that will be returned in ui_state(). Default: always_state
	var/datum/ui_state/state

/datum/tgui_modal/New(mob/user, message, title, list/buttons, timeout, autofocus, ui_state)
	src.autofocus = autofocus
	src.buttons = buttons.Copy()
	src.message = message
	src.title = title
	src.state = ui_state
	if (timeout)
		src.timeout = timeout
		start_time = world.time
		QDEL_IN(src, timeout)

/datum/tgui_modal/Destroy(force, ...)
	SStgui.close_uis(src)
	state = null
	buttons = null // TG QDEL_NULLs this
	return ..()

/**
 * Waits for a user's response to the tgui_modal's prompt before returning. Returns early if
 * the window was closed by the user.
 */
/datum/tgui_modal/proc/wait()
	while (!choice && !closed && !QDELETED(src))
		stoplag(0.2 SECONDS)

/datum/tgui_modal/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AlertModal")
		ui.open()

/datum/tgui_modal/ui_close(mob/user)
	. = ..()
	closed = TRUE

/datum/tgui_modal/ui_state(mob/user)
	return state

/datum/tgui_modal/ui_static_data(mob/user)
	var/list/data = list()
	data["autofocus"] = autofocus
	data["buttons"] = buttons
	data["message"] = message
	data["large_buttons"] = FALSE // Pref?
	data["swapped_buttons"] = FALSE // Pref?
	data["title"] = title
	return data

/datum/tgui_modal/ui_data(mob/user)
	var/list/data = list()
	if(timeout)
		data["timeout"] = CLAMP01((timeout - (world.time - start_time) - 1 SECONDS) / (timeout - 1 SECONDS))
	return data

/datum/tgui_modal/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if (.)
		return
	switch(action)
		if("choose")
			if (!(params["choice"] in buttons))
				CRASH("[ui.user] entered a non-existent button choice: [params["choice"]]")
			set_choice(params["choice"])
			closed = TRUE
			SStgui.close_uis(src)
			return TRUE
		if("cancel")
			closed = TRUE
			SStgui.close_uis(src)
			return TRUE

/datum/tgui_modal/proc/set_choice(choice)
	src.choice = choice

/**
 * # async tgui_modal
 *
 * An asynchronous version of tgui_modal to be used with callbacks instead of waiting on user responses.
 */
/datum/tgui_modal/async
	/// The callback to be invoked by the tgui_modal upon having a choice made.
	var/datum/callback/callback

/datum/tgui_modal/async/New(mob/user, message, title, list/buttons, callback, timeout, autofocus, ui_state)
	..(user, title, message, buttons, timeout, autofocus, ui_state)
	src.callback = callback

/datum/tgui_modal/async/Destroy(force, ...)
	QDEL_NULL(callback)
	. = ..()

/datum/tgui_modal/async/ui_close(mob/user)
	. = ..()
	qdel(src)

/datum/tgui_modal/async/set_choice(choice)
	. = ..()
	if(!isnull(src.choice))
		callback?.InvokeAsync(src.choice)

/datum/tgui_modal/async/wait()
	return

/proc/localized_player_label(value)
	if(!istext(value))
		return value
	var/static/list/labels = list(
		"Yes" = "是",
		"No" = "否",
		"Ok" = "确定",
		"OK" = "确定",
		"Cancel" = "取消",
		"Up" = "向上",
		"Down" = "向下",
		"Title" = "名称",
		"Description" = "说明",
		"Begin the Hunt" = "开始狩猎",
		"No, not now" = "暂不领取",
		"Customize" = "自定义",
		"Wrap" = "包装",
		"Skin" = "剥皮",
		"Behead" = "斩首",
		"Delimb - Right Hand" = "切下右手",
		"Delimb - Left Hand" = "切下左手",
		"Delimb - Right Arm" = "切下右臂",
		"Delimb - Left Arm" = "切下左臂",
		"Delimb - Right Foot" = "切下右脚",
		"Delimb - Left Foot" = "切下左脚",
		"Delimb - Right Leg" = "切下右腿",
		"Delimb - Left Leg" = "切下左腿",
		"Un-Mark as Thralled" = "解除仆从标记",
		"Un-Mark as Honored" = "解除荣誉猎物标记",
		"Un-Mark as Dishonorable" = "解除不名誉猎物标记",
		"Mark as Gear Carrier" = "标记为装备携带者",
		"Un-Mark as Gear Carrier" = "解除装备携带者标记",
		"Mark as Prey" = "标记为猎物",
		"Un-Mark as Prey" = "解除猎物标记",
		"The Lumbering Glaive" = "沉重战刃",
		"The Rending Chain-Whip" = "撕裂链鞭",
		"The Piercing Hunting Sword" = "穿刺猎剑",
		"The Cleaving War-Scythe" = "劈斩战镰",
		"The Adaptive Combi-Stick" = "多用伸缩战矛",
		"The Nimble Spear" = "灵巧长矛",
		"The Fearsome Scimitars" = "骇人弯刀",
		"The Fleeting Spike Launcher" = "迅捷尖刺发射器",
		"The Swift Plasma Pistol" = "轻快等离子手枪",
		"The Purifying Smart-Disc" = "净化智能飞盘",
		"The Formidable Plate Armor" = "坚固板甲",
		"The Steadfast Shield" = "坚毅盾牌",
		"The Agile Drone" = "敏捷无人机",
		"The Imposing Glaive" = "威严战刃",
		"The Ripping War-Scythe" = "撕扯战镰",
		"Broken Light" = "灯具损坏",
		"Shattered Glass" = "玻璃破裂",
		"Minor Structural Damage" = "轻度结构损伤",
		"Major Structural Damage" = "严重结构损伤",
		"Janitorial" = "清洁维护",
		"Chemical Spill" = "化学品泄漏",
		"Fire" = "火灾",
		"Communications Failure" = "通信故障",
		"Power Generation Failure" = "发电系统故障",
		"Electrical Fault" = "电气故障",
		"Support" = "支援需求",
		"Other" = "其他",
		"Root Ticket" = "基础工单",
		"Maintenance Ticket" = "维护工单",
		"Access Ticket" = "访问工单",
		"Pending" = "待处理",
		"Assigned" = "已接取",
		"Completed" = "已完成",
		"Rejected" = "已拒绝",
		"Cancelled" = "已取消",
		"Logged Out" = "未登录",
		"Unauthorized Personnel" = "未授权人员",
		"Validated Incident Reporter" = "已验证的事件报告员",
		"Authorized Visitor" = "授权访客",
		"Certified Personnel" = "认证人员",
		"Working Joe" = "工作乔",
		"AI Service Technician" = "AI维护技师",
		"Unknown" = "未知",
		"unknown" = "未知",
		"Unassigned" = "未分配",
		"None" = "无",
		"No Record." = "无记录",
		"Male" = "男性",
		"Female" = "女性",
		"Human" = "人类",
		"Active" = "正常",
		"*Unconscious*" = "*昏迷*",
		"Conscious" = "清醒",
		"Unconscious" = "昏迷",
		"Physically Unfit" = "身体不适",
		"Stable" = "稳定",
		"*Insane*" = "*精神失常*",
		"*Unstable*" = "*不稳定*",
		"*Watch*" = "*需观察*",
		"*Arrest*" = "*待逮捕*",
		"Incarcerated" = "已监禁",
		"Released" = "已释放",
		"Suspect" = "嫌疑人",
		"NJP" = "非司法惩处",
		"Zombie" = "丧尸语",
		"an unknown language" = "未知语言",
		"Black Goo" = "黑色黏液",
		"Unknown Mutagenic Disease" = "未知致突变疾病",
		"heart" = "心脏",
		"lungs" = "肺",
		"liver" = "肝脏",
		"kidneys" = "肾脏",
		"brain" = "大脑",
		"eyes" = "眼睛",
		"lz1" = "着陆区1",
		"lz2" = "着陆区2",
		"north" = "北",
		"south" = "南",
		"east" = "东",
		"west" = "西",
		"northeast" = "东北",
		"northwest" = "西北",
		"southeast" = "东南",
		"southwest" = "西南",
		"right hand" = "右手",
		"left hand" = "左手",
		"right arm" = "右臂",
		"left arm" = "左臂",
		"right leg" = "右腿",
		"left leg" = "左腿",
		"right foot" = "右脚",
		"left foot" = "左脚",
		"head" = "头部",
		"Young" = "幼年",
		"Mature" = "成熟",
		"Elder" = "长老",
		"Ancient" = "远古",
		"Prime" = "巅峰",
		"Fledgling" = "初生",
		"Veteran" = "老练",
		"Baneful" = "凶煞",
		"Royal" = "皇家",
		"Drone" = "工蜂",
		"Ravager" = "蹂躏者",
		"Lurker" = "潜伏者",
		"Queen" = "女皇",
		"Spitter" = "喷吐者",
		"Defender" = "防御者",
		"Hivelord" = "巢主",
		"Runner" = "疾行者",
		"Sentinel" = "哨兵",
		"Warrior" = "战士",
		"Praetorian" = "禁卫",
		"Carrier" = "搬运者",
		"Crusher" = "碾压者",
		"King" = "异形王",
		"Predalien" = "憎恶异形",
		"Larva" = "幼体",
		"Facehugger" = "抱脸虫",
		"Lesser Drone" = "次级工蜂",
		"Hellhound" = "地狱猎犬",
	)
	return labels[value] || preference_label(value)

/proc/localized_native_alert(user, message = "", title, button1 = "Ok", button2 = null, button3 = null)
	var/label1 = localized_player_label(button1)
	var/label2 = localized_player_label(button2)
	var/label3 = localized_player_label(button3)
	if(label2 && label2 == label1 && button2 != button1)
		label2 += "（2）"
	if(label3 && ((label3 == label1 && button3 != button1) || (label3 == label2 && button3 != button2)))
		label3 += "（3）"
	var/selected = alert(user, message, title, label1, label2, label3)
	if(isnull(selected))
		return null
	if(selected == label1)
		return button1
	if(selected == label2)
		return button2
	if(selected == label3)
		return button3
	return selected

/proc/localized_input_list(mob/user, message, title = "选择", list/buttons, timeout = 0, theme = null, default, ui_state = GLOB.always_state)
	var/list/choices = list()
	var/default_label
	for(var/button in buttons)
		var/label = localized_player_label("[button]")
		if(label in choices)
			label += "（[length(choices) + 1]）"
		choices[label] = button
		if(button == default)
			default_label = label
	var/selected = tgui_input_list(user, message, title, choices, timeout, theme, default_label, ui_state)
	if(isnull(selected))
		return null
	return choices[selected]

/proc/localized_radial_menu(mob/user, atom/anchor, list/buttons)
	var/list/choices = list()
	var/list/images = list()
	for(var/button in buttons)
		var/label = localized_player_label("[button]")
		if(label in choices)
			label += "（[length(choices) + 1]）"
		choices[label] = button
		images[label] = buttons[button]
	var/selected = show_radial_menu(user, anchor, images)
	if(isnull(selected))
		return null
	return choices[selected]
