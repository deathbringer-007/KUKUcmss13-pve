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
		"Modern" = "现代",
		"Legacy" = "旧版",
		"Darkmode" = "深色模式",
		"Lightmode" = "浅色模式",
		"Xenomorph after unrevivable death" = "彻底死亡且无法复活后成为异形",
		"Faction US Army HUD" = "美国陆军阵营抬头显示",
		"Faction USASF HUD" = "美国航空航天军阵营抬头显示",
		"Faction CMB HUD" = "殖民地执法局阵营抬头显示",
		"Faction UPP HUD" = "进步人民联盟阵营抬头显示",
		"Faction Wey-Yu HUD" = "维兰德-汤谷阵营抬头显示",
		"Faction TWE HUD" = "三世界帝国阵营抬头显示",
		"Faction CLF HUD" = "殖民地解放阵线阵营抬头显示",
		"Faction UACG HUD" = "美洲联盟殖民地卫队阵营抬头显示",
		"circular" = "圆形",
		"triangular" = "三角形",
		"square" = "正方形",
		"hexagonal" = "六边形",
		"pentagonal" = "五边形",
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
		"Alive" = "存活",
		"Dead" = "死亡",
		"Gibbed" = "被撕碎",
		"Cryo" = "冷冻休眠",
		"Base" = "基础形态",
		"chest" = "胸部",
		"groin" = "腹股沟",
		"red" = "红色",
		"green" = "绿色",
		"orange" = "橙色",
		"yellow" = "黄色",
		"black" = "黑色",
		"white" = "白色",
		"blue" = "蓝色",
		"none" = "无",
		"SQ1" = "第一战斗组",
		"SQ2" = "第二战斗组",
		"SQ3" = "第三战斗组",
		"SQ4" = "第四战斗组",
		"royal jelly of slaughter" = "屠戮蜂王浆",
		"royal jelly of resilience" = "坚韧蜂王浆",
		"royal jelly of sabotage" = "破袭蜂王浆",
		"royal jelly of proliferation" = "繁衍蜂王浆",
		"royal jelly of rejuvenation" = "复苏蜂王浆",
		"distinguished conduct medal" = "卓越品行勋章",
		"bronze heart medal" = "青铜之心勋章",
		"medal of valor" = "英勇勋章",
		"medal of exceptional heroism" = "非凡英雄勋章",
		"Corrupted" = "腐化",
		"Feral" = "野生",
		"Forsaken" = "遗弃",
		"Inquisitive" = "好奇",
		"Mutated" = "变异",
		"Tamed" = "驯化",
		"Renegade" = "叛离",
		"Alpha" = "阿尔法",
		"Bravo" = "布拉沃",
		"Charlie" = "查理",
		"Delta" = "德尔塔",
		"Normal Hive" = "普通虫巢",
		"Corrupted Hive" = "腐化虫巢",
		"Feral Hive" = "野生虫巢",
		"Forsaken Hive" = "遗弃虫巢",
		"Mutated Hive" = "变异虫巢",
		"Tamed Hive" = "驯化虫巢",
		"Renegade Hive" = "叛离虫巢",
		"Alpha Hive" = "阿尔法虫巢",
		"Bravo Hive" = "布拉沃虫巢",
		"Charlie Hive" = "查理虫巢",
		"Delta Hive" = "德尔塔虫巢",
		"Tutorial Hive" = "教程虫巢",
		"Hellhound Pack" = "地狱猎犬群",
		"Watcher" = "守望者",
		"Dancer" = "舞者",
		"Oppressor" = "压迫者",
		"Warden" = "守护者",
		"Vanguard" = "先锋",
		"Trapper" = "设陷者",
		"Hedgehog" = "刺猬",
		"Resin Whisperer" = "树脂低语者",
		"Eggsac" = "卵囊",
		"Berserker" = "狂战士",
		"Acider" = "酸蚀者",
		"Healer" = "治疗者",
		"Gardener" = "园丁",
		"Charger" = "冲撞者",
		"Steelcrest" = "钢冠",
		"Vampire" = "吸血鬼",
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
	var/static/list/batch_labels = list(
		"Ghost" = "成为幽灵",
		"Stay in body" = "留在身体中",
		"Aghost" = "管理员幽灵",
		"Underground Zombie" = "地下丧尸",
		"Yautja Ship" = "铁血舰船",
		"Human Ship" = "人类舰船",
		"Your clan" = "你的氏族",
		"Issue Order" = "下达命令",
		"Issue Order - Move" = "命令：前进",
		"Issue Order - Hold" = "命令：坚守",
		"Issue Order - Focus" = "命令：集中火力",
		"Protective Form" = "防护形态",
		"Immobile Form" = "固守形态",
		"Repair Form" = "修复形态",
		"Psychic Whipser" = "心灵低语",
		"Call Droppod" = "呼叫空降舱",
		"Recall Droppod" = "召回空降舱",
		"Activable Cult Ability" = "启用教团能力",
		"Speak in Hivemind" = "虫巢意识交流",
		"Obtain Equipment" = "领取装备",
		"Activable Leader Ability" = "启用领袖能力",
		"Convert" = "转化",
		"Psychic Stun" = "心灵震慑",
		"Mutiny abilities" = "叛乱能力",
		"Begin Mutiny" = "发动叛乱",
		"Cancel View" = "取消观察",
		"Vehicle Unbuckle" = "解除载具束缚",
		"Exit MG" = "离开机枪",
		"Toggle Sensor Antenna" = "切换传感器天线",
		"Send Order" = "发送命令",
		"Team Omega (G)" = "欧米伽小队（G）",
		"Commissar" = "政委",
		"Selena" = "塞莱娜",
		"Hart" = "哈特",
		"Elite" = "精英",
		"Juggernaut" = "重装战士",
		"Legion" = "军团",
		"Wooki" = "伍基",
		"Santa" = "圣诞老人",
		"thoracic cavity" = "胸腔",
		"abdominal cavity" = "腹腔",
		"cranial cavity" = "颅腔",
		"ribcage" = "胸廓",
		"skull" = "颅骨",
		"ribs" = "肋骨",
		"pelvis" = "骨盆",
		"Upper deck Foreship" = "上层甲板前部",
		"Upper deck Midship" = "上层甲板中部",
		"Upper deck Aftship" = "上层甲板后部",
		"Lower deck Foreship" = "下层甲板前部",
		"Lower deck Midship" = "下层甲板中部",
		"Lower deck Aftship" = "下层甲板后部",
		"Emergency Launch" = "紧急发射",
		"shuttle" = "穿梭机",
		"dock" = "停靠点",
		"In Transit" = "航行中",
		"*SSD*" = "*离线*",
		"*Deceased*" = "*死亡*",
		"Disabled" = "失能",
		"delta" = "德尔塔",
		"dropship-lz1" = "着陆区1",
		"dropship-lz2" = "着陆区2",
		"No id" = "无身份卡",
		"No job" = "无职业",
		"completed" = "已完成",
		"rejected" = "已拒绝",
		"10x24mm, slugs, buckshot, and 10x20mm rounds" = "10×24毫米弹、独头弹、鹿弹和10×20毫米弹",
		"Explosives and grenades" = "炸药与手榴弹",
		"Rocket ammo" = "火箭弹",
		"Sniper ammo" = "狙击弹药",
		"Anti-Material Sniper ammo" = "反器材狙击弹药",
		"Pyrotechnician tanks" = "火焰兵燃料罐",
		"Scout ammo" = "侦察兵弹药",
		"Smartgun ammo" = "智能机枪弹药",
		"Hotkey" = "快捷键模式",
		"Classic" = "经典模式",
		"Generic Action" = "通用动作",
		"Use item" = "使用物品",
		"hive core" = "虫巢核心",
		"hive cluster" = "虫巢团块",
		"hive pylon" = "巢群尖塔",
		"egg morpher" = "卵化器",
		"recovery node" = "恢复节点",
		"thick resin nest" = "厚实树脂巢穴",
		"Special Resin Structure" = "特殊树脂建筑",
		"Plain" = "普通",
		"Plain (Green)" = "普通（绿色）",
		"Weapons" = "武器",
		"Supply" = "补给",
		"Ammo" = "弹药",
		"Ammo (Black)" = "弹药（黑色）",
		"Ammo (Flame)" = "弹药（火焰）",
		"Construction" = "建造物资",
		"Science" = "科研",
		"Hydroponics" = "水培",
		"Medical" = "医疗",
		"Internals" = "供氧",
		"Explosives" = "爆炸物",
		"corrupted " = "腐化",
		"alpha " = "阿尔法",
		"bravo " = "布拉沃",
		"charlie " = "查理",
		"delta " = "德尔塔",
		"feral " = "野生",
		"forsaken " = "遗弃",
		"inquisitive " = "好奇",
		"mutated " = "变异",
		"tamed " = "驯化",
		"renegade " = "叛离",
		"Retry" = "重试",
		"Disconnect" = "断开连接",
		"CLIENT" = "客户端",
		"EMOTE" = "动作",
		"ADMIN" = "管理",
		"XENO" = "异形",
		"CARBON" = "碳基生物",
		"HUMAN" = "人类",
		"HUMAN COMBAT" = "人类战斗",
		"HUMAN INVENTORY" = "人类装备",
		"ROBOT" = "机器人",
		"YAUTJA" = "铁血战士",
		"VEHICLES" = "载具",
		"MISC" = "其他",
		"MOVEMENT" = "移动",
		"COMMUNICATION" = "通讯",
		"OBSERVER" = "观察者",
		"XENO EMOTE" = "异形动作",
		"HUMAN EMOTE" = "人类动作",
		"YAUTJA EMOTE" = "铁血战士动作",
		"SYNTH EMOTE" = "合成人动作",
		"Small" = "小型",
		"Big" = "大型",
		"Yautja" = "铁血战士",
		"Stay loyal" = "继续效忠女皇",
		"Obey the talls" = "服从高个子",
		"explosive" = "高爆",
		"incendiary" = "燃烧",
		"cluster" = "集束",
		"nerve" = "神经毒剂",
		"UNKNOWN" = "未知",
		"L: Discord" = "链接：Discord",
		"L: Xeno Quickstart Guide" = "链接：异形快速入门指南",
		"L: Marine Quickstart Guide" = "链接：陆战队员快速入门指南",
		"L: Current Map" = "链接：当前地图",
		"A: No plasma regen" = "解答：等离子体不恢复",
		"A: Devour as Xeno" = "解答：异形吞噬",
		"T: Tunnel" = "隧道",
		"E: Event in progress" = "活动进行中",
		"R: Radios" = "无线电",
		"B: Binoculars" = "双筒望远镜",
		"D: Joining disabled" = "已禁止加入",
		"L: Leaving the server" = "离开服务器",
		"M: Macros" = "宏设置",
		"C: Changelog" = "更新日志",
		"H: Clear Cache" = "清理缓存",
		"O: Combat Click-Drag Override" = "战斗点击与拖拽覆盖",
		"any buried larva" = "任意虫巢的地底幼体",
		"middle click" = "鼠标中键",
		"right click" = "鼠标右键",
		"shift click" = "Shift 点击",
		"donut" = "甜甜圈",
		"egg" = "鸡蛋",
		"candle" = "蜡烛",
		"crayon" = "蜡笔",
		"cigarette" = "香烟",
		"cigar" = "雪茄",
		"match" = "火柴",
		"vial" = "小瓶",
		"tradingcard" = "收藏卡",
		"ID Card" = "身份卡",
		"dog tags" = "军籍牌",
		"The Corporation" = "公司",
		"The USCM" = "美国殖民地海军陆战队",
		"Provost Office" = "宪兵监察处",
		"Central Command" = "中央指挥部",
		"\[UNSET\]" = "未设置",
		"Agent" = "特工",
		"Corporate Mercenary" = "公司雇佣兵",
		"General Public" = "公众",
		"Weyland-Yutani" = "维兰德-汤谷",
		"USCM High Command" = "殖民地海军陆战队最高司令部",
		"CMB Incident Command Center, Local Operations" = "殖民地执法局地方行动事件指挥中心",
		"USCM Provost Office" = "殖民地海军陆战队宪兵监察处",
		"Various Press Organizations" = "各新闻机构",
		"Three World Empire" = "三世界帝国",
		"Union of Progress Peoples" = "进步人民联盟",
		"Colonial Liberation Front" = "殖民地解放阵线",
		"Weyland-Yutani Public Network" = "维兰德-汤谷公共网络",
		"Colonial Marshal Bureau, Anchorpoint Station" = "殖民地执法局锚点空间站分局",
		"NC4 UA Federal Secure Network - CMB Relay" = "NC4 美洲联盟联邦安全网络——殖民地执法局中继",
		"W-Y Local Office" = "维兰德-汤谷地方办事处",
		"Weyland-Yutani Secure Network" = "维兰德-汤谷安全网络",
		"W-Y Liaison" = "维兰德-汤谷联络员",
		"Weyland-Yutani Quantum Relay" = "维兰德-汤谷量子中继",
		"USCM Local Operations" = "殖民地海军陆战队地方行动部",
		"USCM Encrypted Network" = "殖民地海军陆战队加密网络",
		"CIC" = "作战情报中心",
		"Commanding Officer" = "指挥官",
		"USCM High Command Quantum Relay" = "殖民地海军陆战队最高司令部量子中继",
		"Brig" = "禁闭室",
		"Chief MP" = "宪兵长",
		"Light Purple" = "浅紫色",
		"Grey" = "灰色",
		"Green" = "绿色",
		"Cyan" = "青色",
		"Bordeaux" = "酒红色",
		"Aquamarine" = "海蓝色",
		"Orange" = "橙色",
		"Red" = "红色",
		"Blue" = "蓝色",
		"Purple" = "紫色",
		"Yellow" = "黄色",
		"White" = "白色",
		"Black" = "黑色",
		"Quiet" = "低声",
		"Raised" = "提高音量",
		"Important" = "重要通话",
		"Critical" = "紧急通话",
		"Section Sergeant" = "分队士官",
		"Squad Leader" = "小队长",
		"Platoon Commander" = "排长",
		"Landing Zone" = "着陆区",
		"Fireteam Leader" = "战斗组长",
		"Banish (500)" = "放逐（500）",
		"Re-Admit (100)" = "重新接纳（100）",
		"De-evolve (500)" = "退化（500）",
		"Reward Jelly (500)" = "赐予蜂王浆（500）",
		"Exchange larva for evolution (100)" = "以幼体换取进化（100）",
		"Add Personal Ally" = "添加私人盟友",
		"Remove Personal Ally" = "移除私人盟友",
		"Clear Personal Allies" = "清空私人盟友",
		"low power stun bolts" = "低功率眩晕弹",
		"high power stun bolts" = "高功率眩晕弹",
		"plasma immobilizers" = "等离子束缚弹",
		"plasma spheres" = "等离子球",
		"plasma bolts" = "等离子束",
		"frenzy" = "狂暴",
		"warding" = "守护",
		"recovery" = "恢复",
		"help" = "帮助",
		"cancel" = "取消",
		"pounce" = "飞扑",
		"lunge" = "突进",
		"Medical HUD" = "医疗抬头显示",
		"Security HUD" = "安保抬头显示",
		"Squad HUD" = "小队抬头显示",
		"card:spades" = "黑桃",
		"card:clubs" = "梅花",
		"card:diamonds" = "方块",
		"card:hearts" = "红桃",
		"card:wild" = "万能",
		"card:wild-draw-four" = "万能加四",
		"card:red" = "红色",
		"card:purple" = "紫色",
		"card:blue" = "蓝色",
		"card:yellow" = "黄色",
		"card:ace" = "A",
		"card:one" = "1",
		"card:two" = "2",
		"card:three" = "3",
		"card:four" = "4",
		"card:five" = "5",
		"card:six" = "6",
		"card:seven" = "7",
		"card:eight" = "8",
		"card:nine" = "9",
		"card:ten" = "10",
		"card:jack" = "J",
		"card:queen" = "Q",
		"card:king" = "K",
		"card:skip" = "跳过",
		"card:draw-two" = "加二",
		"card:reverse" = "反转",
	)
	var/static/list/extra_labels = list(
		"Sentry" = "哨戒炮",
		"Spotlight" = "探照灯",
		"Targeting" = "目标指示",
		"Medevac" = "医疗后送",
		"Fulton" = "富尔顿回收",
		"slash" = "撕砍",
		"slashes" = "撕砍",
		"attack" = "攻击",
		"attacks" = "攻击",
		"commands" = "命令道",
		"Light Grey" = "浅灰色",
		"Light Green" = "浅绿色",
		"A-Section Sergeant" = "A分队士官",
		"B-Section Sergeant" = "B分队士官",
		"Troop Commander" = "部队指挥官",
		"Section/Team Leader" = "分队／战斗组长",
		"Platoon Sergeant" = "排军士",
		"Operation Leader" = "行动指挥官",
		"Team Leader" = "战斗组长",
		"Xeno Status HUD" = "异形状态抬头显示",
		"half night vision" = "半夜视",
		"full night vision" = "全夜视",
		"no night vision" = "关闭夜视",
		"trading card" = "集换卡",
		"Clown Land" = "小丑乐园",
		"Power Alarms" = "电力警报",
		"Atmosphere Alarms" = "大气警报",
		"Fire Alarms" = "火警",
		"Localized Limb" = "局部肢体",
		"Destroy Body" = "摧毁身体",
		"Full Explosion" = "完全爆炸",
		"card:zero" = "0",
		"card:green" = "绿色",
		"Help" = "帮助",
		"Frenzy" = "狂暴",
		"Warding" = "守护",
		"Recovery" = "恢复",
		"oxygen" = "氧气",
		"nitrogen" = "氮气",
		"carbon dioxide" = "二氧化碳",
		"phoron" = "弗燃素",
		"Light" = "轻型",
		"Heavy" = "重型",
		"Upper Deck" = "上层甲板",
		"Lower Deck" = "下层甲板",
	)
	return labels[value] || batch_labels[value] || extra_labels[value] || preference_label(value)


/proc/localized_tgui_alert(mob/user, message = "", title, list/buttons = list("Ok"), timeout = 60 SECONDS, autofocus = TRUE, ui_state = GLOB.always_state)
	var/list/choices = list()
	for(var/button in buttons)
		var/label = localized_player_label(button)
		if(label in choices)
			label += "（[length(choices) + 1]）"
		choices[label] = button
	var/selected = tgui_alert(user, message, title, choices, timeout, autofocus, ui_state)
	if(isnull(selected))
		return null
	return choices[selected]

/proc/localized_seed_label(value)
	if(!istext(value))
		return value
	if(findtext(value, "modified ") == 1)
		return "改良[localized_seed_label(copytext(value, 10))]"
	if(findtext(value, "mutant ") == 1)
		return "变异[localized_seed_label(copytext(value, 8))]"
	var/static/list/seed_labels = list(
		"strange plant" = "奇异植物",
		"chili" = "辣椒",
		"ice pepper" = "冰椒",
		"berry" = "浆果",
		"glowberry" = "发光浆果",
		"poison berry" = "毒浆果",
		"death berry" = "致命浆果",
		"nettle" = "荨麻",
		"death nettle" = "致命荨麻",
		"tomato" = "番茄",
		"blood tomato" = "血番茄",
		"killer tomato" = "杀人番茄",
		"blue tomato" = "蓝番茄",
		"bluespace tomato" = "蓝空间番茄",
		"eggplant" = "茄子",
		"egg-plant" = "鸡蛋树",
		"apple" = "苹果",
		"golden apple" = "金苹果",
		"ambrosia vulgaris" = "普通仙草",
		"ambrosia deus" = "神圣仙草",
		"chanterelle" = "鸡油菌",
		"brown mold" = "褐霉",
		"plump helmet" = "肥菇",
		"reishi" = "灵芝",
		"liberty cap" = "自由帽菇",
		"fly amanita" = "毒蝇伞",
		"destroying angel" = "毁灭天使菇",
		"tower cap" = "塔帽菇",
		"glowshroom" = "发光菇",
		"plastellium" = "塑钢草",
		"harebell" = "风铃草",
		"poppy" = "罂粟",
		"sunflower" = "向日葵",
		"grape" = "葡萄",
		"green grape" = "绿葡萄",
		"peanut" = "花生",
		"cabbage" = "卷心菜",
		"S'randar's hand" = "斯兰达之手",
		"Messa's tear" = "梅萨之泪",
		"banana" = "香蕉",
		"corn" = "玉米",
		"potato" = "土豆",
		"soybean" = "大豆",
		"wheat" = "小麦",
		"rice" = "水稻",
		"carrot" = "胡萝卜",
		"weed" = "杂草",
		"white-beet" = "白甜菜",
		"sugarcane" = "甘蔗",
		"watermelon" = "西瓜",
		"pumpkin" = "南瓜",
		"lime" = "青柠",
		"lemon" = "柠檬",
		"orange" = "橙子",
		"grass" = "草",
		"cacao" = "可可",
		"cherry" = "樱桃",
		"kudzu" = "葛藤",
		"testing" = "调试植物",
		"seeds" = "种子",
		"spores" = "孢子",
		"nodes" = "根瘤",
		"cuttings" = "插穗",
		"strange plants" = "奇异植物植株",
		"chili plants" = "辣椒植株",
		"ice-pepper plants" = "冰椒植株",
		"berry bush" = "浆果植株",
		"glowberry bush" = "发光浆果植株",
		"poison berry bush" = "毒浆果植株",
		"death berry bush" = "致命浆果植株",
		"nettles" = "荨麻植株",
		"death nettles" = "致命荨麻植株",
		"tomato plant" = "番茄植株",
		"blood tomato plant" = "血番茄植株",
		"killer tomato plant" = "杀人番茄植株",
		"blue tomato plant" = "蓝番茄植株",
		"bluespace tomato plant" = "蓝空间番茄植株",
		"eggplants" = "茄子植株",
		"egg-plants" = "鸡蛋树植株",
		"apple tree" = "苹果植株",
		"gold apple tree" = "金苹果植株",
		"chanterelle mushrooms" = "鸡油菌植株",
		"plump helmet mushrooms" = "肥菇植株",
		"liberty cap mushrooms" = "自由帽菇植株",
		"fly amanita mushrooms" = "毒蝇伞植株",
		"destroying angel mushrooms" = "毁灭天使菇植株",
		"tower caps" = "塔帽菇植株",
		"glowshrooms" = "发光菇植株",
		"harebells" = "风铃草植株",
		"poppies" = "罂粟植株",
		"sunflowers" = "向日葵植株",
		"grapevines" = "葡萄植株",
		"green grapevines" = "绿葡萄植株",
		"peanut vines" = "花生植株",
		"cabbages" = "卷心菜植株",
		"S'randar's hand leaves" = "斯兰达之手叶片",
		"Messa's tear leaves" = "梅萨之泪叶片",
		"banana tree" = "香蕉植株",
		"ears of corn" = "玉米植株",
		"potatoes" = "土豆植株",
		"soybeans" = "大豆植株",
		"wheat stalks" = "小麦植株",
		"rice stalks" = "水稻植株",
		"carrots" = "胡萝卜植株",
		"weeds" = "杂草植株",
		"white-beets" = "白甜菜植株",
		"sugarcanes" = "甘蔗植株",
		"watermelon vine" = "西瓜植株",
		"pumpkin vine" = "南瓜植株",
		"lime trees" = "青柠植株",
		"lemon trees" = "柠檬植株",
		"orange trees" = "橙子植株",
		"cacao tree" = "可可植株",
		"cherry tree" = "樱桃植株",
		"kudzu vines" = "葛藤植株",
		"runtimes" = "调试植物植株",
	)
	return seed_labels[value] || value

/proc/localized_player_list(list/values)
	var/list/labels = list()
	for(var/value in values)
		labels += localized_player_label(value)
	return labels

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
