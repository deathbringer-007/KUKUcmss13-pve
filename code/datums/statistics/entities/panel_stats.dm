//*******************************************************
//*******************STAT PANEL**************************
//*******************************************************


/datum/entity/player_entity/proc/show_statistics(mob/user, datum/entity/statistic/round/viewing_round = GLOB.round_statistics, update_data = FALSE)
	if(update_data)
		update_panel_data(GLOB.round_statistics)
	ui_interact(user)

/datum/entity/player_entity/proc/ui_interact(mob/user, ui_key = "statistics", datum/nanoui/ui, force_open = 1)
	data["menu"] = menu
	data["subMenu"] = subMenu
	data["dataMenu"] = dataMenu

	ui = SSnano.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)

	if(!ui)
		ui = new(user, src, ui_key, "cm_stat_panel.tmpl", "统计", 450, 700, null, -1)
		ui.set_initial_data(data)
		ui.open()

/datum/entity/player_entity/Topic(href, href_list)
	var/mob/user = usr
	user.set_interaction(src)

	if(href_list["menu"])
		menu = href_list["menu"]
	if(href_list["subMenu"])
		subMenu = href_list["subMenu"]
	if(href_list["dataMenu"])
		dataMenu = href_list["dataMenu"]

	SSnano.nanomanager.update_uis(src)

/datum/entity/player_entity/proc/check_eye()
	return

/proc/get_statistic_display_label(value)
	if(!istext(value))
		return value
	var/static/list/labels = list(
		"Restart Round" = "重启回合",
		"Continue Playing" = "继续游戏",
		"Distress Signal" = "求救信号",
		"Hunter Games" = "狩猎游戏",
		"Extended" = "自由模式",
		"Faction Clash" = "阵营冲突",
		"Extended - No Spawn" = "自由模式（无生成）",
		"Infection" = "感染",
		"Distress Signal: Lowpop" = "求救信号：低人数",
		"Distress Signal: Lowpop (No Spawn)" = "求救信号：低人数（无生成）",
		"Hive Wars" = "虫巢战争",
		"Whiskey Outpost" = "威士忌哨站",
		"Solaris Ridge" = "索拉里斯山脊",
		"Binhai Supply Station" = "滨海补给站",
		"Bosenmori Basho" = "博森莫里地区",
		"USS Almayer" = "阿尔迈耶号",
		"Calliope Desert Bus" = "卡利俄佩沙漠巴士",
		"BMG-290 Otogi Egress Point" = "BMG-290御伽撤离点",
		"Chinook 91 GSO" = "奇努克91号地球同步轨道站",
		"Canyon 32B" = "32B峡谷",
		"Derelict Almayer" = "废弃阿尔迈耶号",
		"Fiorina Science Annex" = "菲奥里纳科研附属区",
		"CORSAT" = "CORSAT",
		"Calliope Highway" = "卡利俄佩公路",
		"SSV Chapaev" = "恰帕耶夫号",
		"Trijent Dam" = "特里金特大坝",
		"USCSS Firefly" = "萤火虫号",
		"USS Golden Arrow" = "金箭号",
		"USS Golden Arrow (Classic)" = "金箭号（经典版）",
		"HMS Brynhild" = "布伦希尔德号",
		"Ice Colony" = "冰原殖民地",
		"Ice Colony v2" = "冰原殖民地v2",
		"Ice Colony Classic" = "冰原殖民地（经典版）",
		"Kutjevo Refinery" = "库特耶沃精炼厂",
		"LV-522 Chance's Claim" = "LV-522机遇矿区",
		"Kleschers Research Site" = "克莱舍科研区",
		"LV-522 Chance's Claim Forecon" = "LV-522机遇矿区（武装侦察部队）",
		"LV295 Blacksite" = "LV295秘密基地",
		"LV-624" = "LV-624",
		"LV-624 Repaired" = "LV-624（修复版）",
		"New Varadero" = "新巴拉德罗",
		"USS Runtime" = "运行时号",
		"Area of Operation" = "行动区域",
		"New Varadero Repaired" = "新巴拉德罗（修复版）",
		"USS Rover" = "漫游者号",
		"Fiorina Cellblocks" = "菲奥里纳监区",
		"OBW - Oread Garrison" = "OBW——奥瑞亚德驻军基地",
		"Shivas Snowball" = "湿婆雪球",
		"Redemption Valley" = "救赎谷",
		"Ship" = "舰船",
		"SI-391 Sekhmet Swamp" = "SI-391塞赫迈特沼泽",
		"Sorokyne Strata" = "索罗基内地层",
		"Taipei Way-Station" = "台北中转站",
		"USCSS Obsidian Falk" = "黑曜法尔克号",
		"USCSS Onyx Karain" = "缟玛瑙卡赖恩号",
		"Space" = "太空",
		"teeth marks" = "牙印",
		"EMP" = "电磁脉冲",
		"falling" = "坠落",
		"Misadventure" = "意外事故",
		"Electrocution" = "触电",
		"Electronics meltdown" = "电子设备熔毁",
		"High Body Temperature" = "体温过高",
		"Low Body Temperature" = "体温过低",
		"Explosive blast" = "爆炸冲击",
		"An unlucky pull of the trigger during Russian Roulette!" = "俄罗斯轮盘赌中的致命一枪！",
		"Executions Made" = "处决次数",
		"Medals Received" = "获颁勋章数",
		"Medals Given" = "颁授勋章数",
		"Times Shocked" = "触电次数",
		"Grenades Thrown" = "投掷手榴弹数",
		"Flights Piloted" = "驾驶飞行次数",
		"Handcuffs Applied" = "上铐次数",
		"Pills Fed" = "喂服药片数",
		"Accidental Discharges" = "意外走火次数",
		"Fultons Deployed" = "部署富尔顿回收装置数",
		"Disks Decrypted" = "解密磁盘数",
		"Data Uploaded" = "上传数据量",
		"Chemicals Discovered" = "发现化学品数",
		"Supplies Airdropped" = "空投补给数",
		"Bombardments Fired" = "轨道轰炸次数",
		"Barricades Built" = "建造路障数",
		"Barricades Upgraded" = "升级路障数",
		"Barricades Repaired" = "修复路障数",
		"Generators Repaired" = "修复发电机数",
		"APCs Repaired" = "修复区域电力控制器数",
		"Defenses Built" = "建造防御设施数",
		"Corgis Murdered" = "杀死柯基犬数",
		"Cats Murdered" = "杀死猫数",
		"Cows Murdered" = "杀死牛数",
		"Chickens Murdered" = "杀死鸡数",
		"Bones Mended" = "修复骨骼数",
		"Internal Bleedings Stopped" = "止住内出血次数",
		"Brains Mended" = "修复大脑数",
		"Eyes Mended" = "修复眼睛数",
		"Larvae Removed" = "移除幼体数",
		"Shrapnel Removed" = "移除弹片数",
		"Limbs Amputated" = "截肢次数",
		"Organs Repaired" = "修复器官数",
		"Organs Implanted" = "植入器官数",
		"Organs Harvested" = "摘取器官数",
		"Walls Destroyed" = "摧毁墙壁数",
		"Doors Destroyed" = "摧毁门数",
		"Windows Destroyed" = "摧毁窗户数",
		"Xenomorph Major Victory" = "异形大胜",
		"Marine Major Victory" = "陆战队大胜",
		"Xenomorph Minor Victory" = "异形小胜",
		"Marine Minor Victory" = "陆战队小胜",
		"DRAW: Mutual Annihilation" = "平局：同归于尽",
		"Major Zombie Victory" = "丧尸大胜",
		"Wey-Yu PMC Major Success" = "维兰德-汤谷私人军事承包商大胜",
		"Marine Major Success" = "陆战队大胜",
		"Wey-Yu PMC Minor Success" = "维兰德-汤谷私人军事承包商小胜",
		"Marine Minor Success" = "陆战队小胜",
		"DRAW: Stalemate" = "平局：僵持不下",
		"DRAW: My Friends Are Dead" = "平局：战友尽亡",
		"DRAW: Nuclear Explosion" = "平局：核爆",
		"Neutral" = "中立",
		"USCM" = "美国殖民地海军陆战队",
		"USA" = "美国陆军",
		"UACG" = "美洲联盟殖民地卫队",
		"USASF" = "美国航空航天军",
		"Survivor" = "幸存者",
		"UPP" = "进步人民联盟",
		"TWE" = "三世界帝国",
		"Wey-Yu" = "维兰德-汤谷",
		"CLF" = "殖民地解放阵线",
		"TWE Rebel" = "三世界帝国叛军",
		"UA Rebel" = "美洲联盟叛军",
		"UPP Rebel" = "进步人民联盟叛军",
		"PMC" = "私人军事承包商",
		"VAI" = "先锋之箭公司",
		"Colonial Marshal" = "殖民地执法官",
		"WY Death Squad" = "维兰德-汤谷死亡小队",
		"Mercenary" = "雇佣兵",
		"Freelancer" = "自由佣兵",
		"HEFA Order" = "HEFA教团",
		"Dutch's Dozen" = "达奇十二人组",
		"Pirate" = "海盗",
		"Gladiator" = "角斗士",
		"Pizza Delivery" = "披萨外送员",
		"Souto Man" = "索托侠",
		"Colonist" = "殖民者",
		"Yautja" = "铁血战士",
		"Zombie" = "丧尸",
		"Monkey" = "猴子",
		"Malfunctioning Synthetic" = "故障合成人",
		"Predalien" = "憎恶异形",
		"Xenomorph" = "异形",
		"Corrupted Xenomoprh" = "腐化异形",
		"Alpha Xenomorph" = "阿尔法异形",
		"Bravo Xenomorph" = "布拉沃异形",
		"Charlie Xenomorph" = "查理异形",
		"Delta Xenomorph" = "德尔塔异形",
		"throat slit" = "割喉",
		"HE rockets" = "高爆火箭弹",
		"Incendiary rockets" = "燃烧火箭弹",
		"LGM strike" = "激光制导导弹打击",
		"Napalm missile" = "凝固汽油导弹",
		"GAU strike" = "航炮扫射",
		"Laser strike" = "激光打击",
		"cas laser" = "近距空中支援激光",
		"HE mortar" = "高爆迫击炮弹",
		"Incendiary mortar" = "燃烧迫击炮弹",
		"HE MLRS" = "多管火箭炮高爆弹",
		"nuclear explosion" = "核爆",
		"bursting pipe" = "管道爆裂",
		"cremation" = "火化",
		"wildfire" = "野火",
		"existing" = "原有遗体",
		"gibber" = "碎肉机",
		"divine intervention" = "神力干预",
		"adminbus" = "管理员事件",
		"gibbing" = "身体碎裂",
		"Exposure" = "环境暴露",
		"sentry explosion" = "哨戒炮爆炸",
		"defense explosion" = "防御设施爆炸",
		"squashing" = "压死",
		"dropship crash" = "运输艇坠毁",
		"cluster explosion" = "集束爆炸",
		"lifeboat explosive bolt" = "救生艇爆炸螺栓",
		"escape pod malfunction" = "逃生舱故障",
		"crashing shuttle" = "穿梭机坠毁",
		"crashing shuttle fire" = "穿梭机坠毁引发的火灾",
		"Explosion" = "爆炸",
		"Anti-Tank Rocket" = "反坦克火箭弹",
		"accidental UXO detonation" = "未爆弹意外引爆",
		"resin trap" = "树脂陷阱",
		"resin gas trap" = "树脂毒气陷阱",
		"resin acid trap" = "树脂酸液陷阱",
		"Anti-Armor Rocket" = "反装甲火箭弹",
		"railgun round" = "电磁轨道炮弹",
		"P9 SHARP Rifle" = "P9 SHARP步枪",
		"Plasma Blast" = "等离子爆炸",
		"Plasma Eradicator" = "等离子歼灭炮",
		"execution" = "处决",
		"railgun" = "电磁轨道炮",
		"macho bullshit" = "猛男蛮力",
		"hoverpack explosion" = "悬浮背包爆炸",
		"Harmful substance" = "有害物质",
		"chemical explosion" = "化学爆炸",
		"chemical fire" = "化学火灾",
		"yautja self-destruct" = "铁血战士自爆",
		"artillery fire" = "炮击",
		"hijack autodelete" = "劫持后自动移除",
		"dropship flattening" = "运输艇碾压",
		"Burning Mortar Shell" = "燃烧中的迫击炮弹",
		"toxic water" = "有毒水体",
		"splatting" = "摔死",
		"wall tossing" = "撞墙",
		"chestbursting" = "破胸",
		"fisticuffs" = "徒手搏斗",
		"rapid unscheduled disassembly" = "突发性非计划解体",
		"brain extraction" = "大脑摘除",
		"amputation" = "截肢",
		"lost vital limb" = "要害部位缺失",
		"Queen gutting" = "女皇剖腹",
		"gutting" = "剖腹",
		"squished" = "压死",
		"acider kamikaze" = "酸蚀者自爆",
		"sacrificing itself" = "自我牺牲",
		"headbite execution" = "咬头处决",
		"acid shroud gas" = "酸雾",
		"acid shotgun" = "酸液散射",
		"Explosive Blast" = "爆炸冲击",
	)
	if(labels[value])
		return labels[value]
	if(findtext(value, "falling from ") == 1)
		return "从[get_statistic_display_label(copytext(value, length("falling from ") + 1))]坠落"
	if(findtext(value, "failed suicide by ") == 1)
		return "使用[get_statistic_display_label(copytext(value, length("failed suicide by ") + 1))]自杀未遂"
	if(findtext(value, "suicide by ") == 1)
		return "使用[get_statistic_display_label(copytext(value, length("suicide by ") + 1))]自杀"
	if(findtext(value, "russian roulette with ") == 1)
		var/weapon_name = copytext(value, length("russian roulette with ") + 1)
		if(findtext(weapon_name, "an ") == 1)
			weapon_name = copytext(weapon_name, 4)
		else if(findtext(weapon_name, "a ") == 1)
			weapon_name = copytext(weapon_name, 3)
		return "使用[get_statistic_display_label(weapon_name)]玩俄罗斯轮盘"
	var/roadkill_suffix = " roadkill"
	if(length(value) > length(roadkill_suffix) && copytext(value, length(value) - length(roadkill_suffix) + 1) == roadkill_suffix)
		return "被[get_statistic_display_label(copytext(value, 1, length(value) - length(roadkill_suffix) + 1))]碾压"
	var/uxo_suffix = " UXO detonation"
	if(length(value) > length(uxo_suffix) && copytext(value, length(value) - length(uxo_suffix) + 1) == uxo_suffix)
		return "[get_statistic_display_label(copytext(value, 1, length(value) - length(uxo_suffix) + 1))]未爆弹引爆"
	return localized_player_label(value)

//*******************************************************
//*******************KILL PANEL**************************
//*******************************************************


/datum/entity/statistic/round/proc/show_kill_feed(mob/user)
	tgui_interact(user)

/datum/entity/statistic/round/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "KillPanel", "击杀记录")
		ui.open()
		ui.set_autoupdate(FALSE)

/datum/entity/statistic/round/ui_state(mob/user)
	return GLOB.always_state

/datum/entity/statistic/round/ui_data(mob/user)
	var/list/data = list()

	data["death_data"] = death_data

	return data

/datum/entity/statistic/round/proc/check_eye()
	return

//*******************************************************
//*******************PLAYER DATA*************************
//*******************************************************

/datum/entity/player_entity/proc/update_panel_data(datum/entity/statistic/round/viewing_round = GLOB.round_statistics)
	data["current_time"] = worldtime2text()

	if(viewing_round)
		viewing_round.update_panel_data()
		data["round"] = viewing_round.round_data["round"]

	if(player_stats["human"])
		var/datum/entity/player_stats/human/H = player_stats["human"]
		var/list/humans_killed = list()
		var/list/xenos_killed = list()
		var/list/medal_list = list()
		var/list/death_list = list()
		var/list/weapon_stats_list = list()
		var/list/job_stats_list = list()
		var/list/niche_stats_list = list()
		var/list/top_weapon = null
		var/list/human_nemesis = null

		if(H.nemesis)
			human_nemesis = list("name" = get_statistic_display_label(H.nemesis.name), "value" = H.nemesis.value)

		if(H.top_weapon)
			top_weapon = list(
				"name" = sanitize(get_statistic_display_label(H.top_weapon.name)),
				"total_kills" = H.top_weapon.total_kills,
				"total_hits" = H.top_weapon.total_hits,
				"total_shots" = H.top_weapon.total_shots,
				"total_shots_hit" = H.top_weapon.total_shots_hit,
				"total_friendly_fire" = H.top_weapon.total_friendly_fire
			)

		for(var/iteration in H.humans_killed)
			var/datum/entity/statistic/S = H.humans_killed[iteration]
			humans_killed += list(list("name" = get_statistic_display_label(S.name), "value" = S.value))

		for(var/iteration in H.xenos_killed)
			var/datum/entity/statistic/S = H.xenos_killed[iteration]
			xenos_killed += list(list("name" = get_statistic_display_label(S.name), "value" = S.value))

		for(var/iteration in H.niche_stats)
			var/datum/entity/statistic/S = H.niche_stats[iteration]
			niche_stats_list += list(list("name" = get_statistic_display_label(S.name), "value" = S.value))

		for(var/datum/entity/statistic/medal/S in H.medal_list)
			medal_list += list(list(
				"medal_type" = sanitize(get_statistic_display_label(S.medal_type)),
				"recipient" = sanitize(S.recipient_name),
				"recipient_job" = sanitize(get_statistic_display_label(S.recipient_role)),
				"citation" = sanitize(S.citation),
				"giver" = sanitize(S.giver_name)
			))

		for(var/datum/entity/statistic/death/S in H.death_list)
			var/list/damage_list = list()
			if(S.total_brute)
				damage_list += list(list("name" = "物理伤害", "value" = S.total_brute))
			if(S.total_burn)
				damage_list += list(list("name" = "烧伤", "value" = S.total_burn))
			if(S.total_oxy)
				damage_list += list(list("name" = "缺氧", "value" = S.total_oxy))
			if(S.total_tox)
				damage_list += list(list("name" = "毒素伤害", "value" = S.total_tox))
			death_list += list(list(
				"mob_name" = sanitize(S.mob_name),
				"job_name" = get_statistic_display_label(S.role_name),
				"area_name" = sanitize_area(S.area_name),
				"cause_name" = sanitize(get_statistic_display_label(S.cause_name)),
				"total_kills" = S.total_kills,
				"total_damage" = damage_list,
				"time_of_death" = duration2text(S.time_of_death),
				"total_time_alive" = duration2text(S.total_time_alive),
				"total_damage_taken" = S.total_damage_taken,
				"x" = S.x,
				"y" = S.y,
				"z" = S.z
			))

		for(var/iteration in H.weapon_stats_list)
			var/datum/entity/weapon_stats/S = H.weapon_stats_list[iteration]
			if(!S.display_stat)
				continue
			var/list/weapon_humans_killed = list()
			var/list/weapon_xenos_killed = list()
			var/list/weapon_niche_stats_list = list()

			for(var/sub_iteration in S.humans_killed)
				var/datum/entity/statistic/D = S.humans_killed[sub_iteration]
				weapon_humans_killed += list(list("name" = get_statistic_display_label(D.name), "value" = D.value))

			for(var/sub_iteration in S.xenos_killed)
				var/datum/entity/statistic/D = S.xenos_killed[sub_iteration]
				weapon_xenos_killed += list(list("name" = get_statistic_display_label(D.name), "value" = D.value))

			for(var/sub_iteration in S.niche_stats)
				var/datum/entity/statistic/D = S.niche_stats[sub_iteration]
				weapon_niche_stats_list += list(list("name" = get_statistic_display_label(D.name), "value" = D.value))

			weapon_stats_list += list(list(
				"name" = sanitize(get_statistic_display_label(S.name)),
				"total_kills" = S.total_kills,
				"total_hits" = S.total_hits,
				"total_shots" = S.total_shots,
				"total_shots_hit" = S.total_shots_hit,
				"total_friendly_fire" = S.total_friendly_fire,
				"humans_killed" = weapon_humans_killed,
				"xenos_killed" = weapon_xenos_killed,
				"niche_stats" = weapon_niche_stats_list
			))

		for(var/iteration in H.job_stats_list)
			var/datum/entity/player_stats/job/S = H.job_stats_list[iteration]
			if(!S.display_stat)
				continue
			var/list/job_humans_killed = list()
			var/list/job_xenos_killed = list()
			var/list/job_death_list = list()
			var/list/job_niche_stats_list = list()
			var/list/job_nemesis = null

			if(S.nemesis)
				job_nemesis = list("name" = get_statistic_display_label(S.nemesis.name), "value" = S.nemesis.value)

			for(var/sub_iteration in S.humans_killed)
				var/datum/entity/statistic/D = S.humans_killed[sub_iteration]
				job_humans_killed += list(list("name" = get_statistic_display_label(D.name), "value" = D.value))

			for(var/sub_iteration in S.xenos_killed)
				var/datum/entity/statistic/D = S.xenos_killed[sub_iteration]
				job_xenos_killed += list(list("name" = get_statistic_display_label(D.name), "value" = D.value))

			for(var/sub_iteration in S.niche_stats)
				var/datum/entity/statistic/D = S.niche_stats[sub_iteration]
				job_niche_stats_list += list(list("name" = get_statistic_display_label(D.name), "value" = D.value))

			for(var/datum/entity/statistic/death/DS in S.death_list)
				var/list/damage_list = list()
				if(DS.total_brute)
					damage_list += list(list("name" = "物理伤害", "value" = DS.total_brute))
				if(DS.total_burn)
					damage_list += list(list("name" = "烧伤", "value" = DS.total_burn))
				if(DS.total_oxy)
					damage_list += list(list("name" = "缺氧", "value" = DS.total_oxy))
				if(DS.total_tox)
					damage_list += list(list("name" = "毒素伤害", "value" = DS.total_tox))
				death_list += list(list(
					"mob_name" = sanitize(DS.mob_name),
					"job_name" = get_statistic_display_label(DS.role_name),
					"area_name" = sanitize_area(DS.area_name),
					"cause_name" = sanitize(get_statistic_display_label(DS.cause_name)),
					"total_kills" = DS.total_kills,
					"total_damage" = damage_list,
					"time_of_death" = duration2text(DS.time_of_death),
					"total_time_alive" = duration2text(DS.total_time_alive),
					"total_damage_taken" = DS.total_damage_taken,
					"x" = DS.x,
					"y" = DS.y,
					"z" = DS.z
				))

			job_stats_list += list(list(
				"name" = get_statistic_display_label(S.name),
				"total_kills" = S.total_kills,
				"total_deaths" = S.total_deaths,
				"total_playtime" = duration2text(S.total_playtime),
				"total_rounds_played" = S.total_rounds_played,
				"steps_walked" = S.steps_walked,
				"total_friendly_fire" = S.total_friendly_fire,
				"total_revives" = S.total_revives,
				"total_lives_saved" = S.total_lives_saved,
				"total_shots" = S.total_shots,
				"total_shots_hit" = S.total_shots_hit,
				"total_screams" = S.total_screams,
				"nemesis" = job_nemesis,
				"humans_killed" = job_humans_killed,
				"xenos_killed" = job_xenos_killed,
				"job_death_list" = job_death_list,
				"niche_stats" = job_niche_stats_list
			))

		data["human"] = list(
			"total_kills" = H.total_kills,
			"total_deaths" = H.total_deaths,
			"total_playtime" = duration2text(H.total_playtime),
			"total_rounds_played" = H.total_rounds_played,
			"steps_walked" = H.steps_walked,
			"total_friendly_fire" = H.total_friendly_fire,
			"total_revives" = H.total_revives,
			"total_lives_saved" = H.total_lives_saved,
			"total_shots" = H.total_shots,
			"total_shots_hit" = H.total_shots_hit,
			"total_screams" = H.total_screams,
			"nemesis" = human_nemesis,
			"humans_killed" = humans_killed,
			"xenos_killed" = xenos_killed,
			"medal_list" = medal_list,
			"death_list" = death_list,
			"weapon_stats_list" = weapon_stats_list,
			"job_stats_list" = job_stats_list,
			"niche_stats" = niche_stats_list,
			"top_weapon" = top_weapon
		)

	if(player_stats["xeno"])
		var/datum/entity/player_stats/xeno/H = player_stats["xeno"]
		var/list/humans_killed = list()
		var/list/xenos_killed = list()
		var/list/medal_list = list()
		var/list/death_list = list()
		var/list/caste_stats_list = list()
		var/list/niche_stats_list = list()
		var/list/top_caste = null
		var/list/xeno_nemesis = null

		if(H.nemesis)
			xeno_nemesis = list("name" = get_statistic_display_label(H.nemesis.name), "value" = H.nemesis.value)

		if(H.top_caste)
			top_caste = list(
				"name" = get_statistic_display_label(H.top_caste.name),
				"total_kills" = H.top_caste.total_kills,
				"total_deaths" = H.top_caste.total_deaths,
				"total_playtime" = duration2text(H.top_caste.total_playtime),
				"total_rounds_played" = H.top_caste.total_rounds_played,
			)

		for(var/iteration in H.humans_killed)
			var/datum/entity/statistic/S = H.humans_killed[iteration]
			humans_killed += list(list("name" = get_statistic_display_label(S.name), "value" = S.value))

		for(var/iteration in H.xenos_killed)
			var/datum/entity/statistic/S = H.xenos_killed[iteration]
			xenos_killed += list(list("name" = get_statistic_display_label(S.name), "value" = S.value))

		for(var/iteration in H.niche_stats)
			var/datum/entity/statistic/S = H.niche_stats[iteration]
			niche_stats_list += list(list("name" = get_statistic_display_label(S.name), "value" = S.value))

		for(var/datum/entity/statistic/medal/S in H.medal_list)
			medal_list += list(list(
				"medal_type" = sanitize(get_statistic_display_label(S.medal_type)),
				"recipient" = sanitize(S.recipient_name),
				"recipient_job" = sanitize(get_statistic_display_label(S.recipient_role)),
				"citation" = sanitize(S.citation),
				"giver" = sanitize(S.giver_name)
			))

		for(var/datum/entity/statistic/death/S in H.death_list)
			var/list/damage_list = list()
			if(S.total_brute)
				damage_list += list(list("name" = "物理伤害", "value" = S.total_brute))
			if(S.total_burn)
				damage_list += list(list("name" = "烧伤", "value" = S.total_burn))
			if(S.total_oxy)
				damage_list += list(list("name" = "缺氧", "value" = S.total_oxy))
			if(S.total_tox)
				damage_list += list(list("name" = "毒素伤害", "value" = S.total_tox))
			death_list += list(list(
				"mob_name" = sanitize(S.mob_name),
				"job_name" = get_statistic_display_label(S.role_name),
				"area_name" = sanitize_area(S.area_name),
				"cause_name" = sanitize(get_statistic_display_label(S.cause_name)),
				"total_kills" = S.total_kills,
				"total_damage" = damage_list,
				"time_of_death" = duration2text(S.time_of_death),
				"total_time_alive" = duration2text(S.total_time_alive),
				"total_damage_taken" = S.total_damage_taken,
				"x" = S.x,
				"y" = S.y,
				"z" = S.z
			))

		for(var/iteration in H.caste_stats_list)
			var/datum/entity/player_stats/caste/S = H.caste_stats_list[iteration]
			if(!S.display_stat)
				continue
			var/list/caste_abilities_used = list()
			var/list/caste_humans_killed = list()
			var/list/caste_xenos_killed = list()
			var/list/caste_death_list = list()
			var/list/caste_niche_stats_list = list()
			var/list/caste_nemesis = null

			if(S.nemesis)
				caste_nemesis = list("name" = get_statistic_display_label(S.nemesis.name), "value" = S.nemesis.value)

			for(var/sub_iteration in S.abilities_used)
				var/datum/entity/statistic/D = S.abilities_used[sub_iteration]
				caste_abilities_used += list(list("name" = get_statistic_display_label(D.name), "value" = D.value))

			for(var/sub_iteration in S.humans_killed)
				var/datum/entity/statistic/D = S.humans_killed[sub_iteration]
				caste_humans_killed += list(list("name" = get_statistic_display_label(D.name), "value" = D.value))

			for(var/sub_iteration in S.xenos_killed)
				var/datum/entity/statistic/D = S.xenos_killed[sub_iteration]
				caste_xenos_killed += list(list("name" = get_statistic_display_label(D.name), "value" = D.value))

			for(var/sub_iteration in S.niche_stats)
				var/datum/entity/statistic/D = S.niche_stats[sub_iteration]
				caste_niche_stats_list += list(list("name" = get_statistic_display_label(D.name), "value" = D.value))

			for(var/datum/entity/statistic/death/DS in S.death_list)
				var/list/damage_list = list()
				if(DS.total_brute)
					damage_list += list(list("name" = "物理伤害", "value" = DS.total_brute))
				if(DS.total_burn)
					damage_list += list(list("name" = "烧伤", "value" = DS.total_burn))
				if(DS.total_oxy)
					damage_list += list(list("name" = "缺氧", "value" = DS.total_oxy))
				if(DS.total_tox)
					damage_list += list(list("name" = "毒素伤害", "value" = DS.total_tox))
				death_list += list(list(
					"mob_name" = sanitize(DS.mob_name),
					"job_name" = get_statistic_display_label(DS.role_name),
					"area_name" = sanitize_area(DS.area_name),
					"cause_name" = sanitize(get_statistic_display_label(DS.cause_name)),
					"total_kills" = DS.total_kills,
					"total_damage" = damage_list,
					"time_of_death" = duration2text(DS.time_of_death),
					"total_time_alive" = duration2text(DS.total_time_alive),
					"total_damage_taken" = DS.total_damage_taken,
					"x" = DS.x,
					"y" = DS.y,
					"z" = DS.z
				))

			caste_stats_list += list(list(
				"name" = get_statistic_display_label(S.name),
				"total_kills" = S.total_kills,
				"total_hits" = S.total_hits,
				"total_deaths" = S.total_deaths,
				"total_playtime" = duration2text(S.total_playtime),
				"total_rounds_played" = S.total_rounds_played,
				"steps_walked" = S.steps_walked,
				"nemesis" = caste_nemesis,
				"humans_killed" = caste_humans_killed,
				"xenos_killed" = caste_xenos_killed,
				"death_list" = caste_death_list,
				"abilities_used" = caste_abilities_used,
				"niche_stats" = caste_niche_stats_list
			))

		data["xeno"] = list(
			"total_kills" = H.total_kills,
			"total_deaths" = H.total_deaths,
			"total_playtime" = duration2text(H.total_playtime),
			"total_rounds_played" = H.total_rounds_played,
			"steps_walked" = H.steps_walked,
			"total_hits" = H.total_hits,
			"nemesis" = xeno_nemesis,
			"humans_killed" = humans_killed,
			"xenos_killed" = xenos_killed,
			"medal_list" = medal_list,
			"death_list" = death_list,
			"caste_stats_list" = caste_stats_list,
			"niche_stats" = niche_stats_list,
			"top_caste" = top_caste
		)

//*******************************************************
//*******************ROUND DATA**************************
//*******************************************************

/datum/entity/statistic/round/proc/update_panel_data()
	var/map_name
	if(current_map)
		map_name = current_map.name

	var/list/participants_list = list()
	var/list/hijack_participants_list = list()
	var/list/final_participants_list = list()
	var/list/total_deaths_list = list()
	var/list/new_death_stats_list = list()
	var/list/new_weapon_stats_list = list()
	var/list/new_job_stats_list = list()
	var/list/new_caste_stats_list = list()

	for(var/iteration in participants)
		var/datum/entity/statistic/S = participants[iteration]
		participants_list += list(list("name" = get_statistic_display_label(S.name), "value" = S.value))

	for(var/iteration in hijack_participants)
		var/datum/entity/statistic/S = hijack_participants[iteration]
		hijack_participants_list += list(list("name" = get_statistic_display_label(S.name), "value" = S.value))

	for(var/iteration in final_participants)
		var/datum/entity/statistic/S = final_participants[iteration]
		final_participants_list += list(list("name" = get_statistic_display_label(S.name), "value" = S.value))

	for(var/iteration in total_deaths)
		var/datum/entity/statistic/S = total_deaths[iteration]
		total_deaths_list += list(list("name" = get_statistic_display_label(S.name), "value" = S.value))

	for(var/datum/entity/statistic/death/S in death_stats_list)
		if(length(new_death_stats_list) >= STATISTICS_DEATH_LIST_LEN)
			break
		var/list/damage_list = list()
		if(S.total_brute)
			damage_list += list(list("name" = "物理伤害", "value" = S.total_brute))
		if(S.total_burn)
			damage_list += list(list("name" = "烧伤", "value" = S.total_burn))
		if(S.total_oxy)
			damage_list += list(list("name" = "缺氧", "value" = S.total_oxy))
		if(S.total_tox)
			damage_list += list(list("name" = "毒素伤害", "value" = S.total_tox))

		var/new_time_of_death
		if(S.time_of_death)
			new_time_of_death = duration2text(S.time_of_death)
		var/new_total_time_alive
		if(S.total_time_alive)
			new_total_time_alive = duration2text(S.total_time_alive)

		var/death = list(list(
			"mob_name" = sanitize(S.mob_name),
			"job_name" = get_statistic_display_label(S.role_name),
			"area_name" = sanitize_area(S.area_name),
			"cause_name" = sanitize(get_statistic_display_label(S.cause_name)),
			"total_kills" = S.total_kills,
			"total_damage" = damage_list,
			"time_of_death" = new_time_of_death,
			"total_time_alive" = new_total_time_alive,
			"total_damage_taken" = S.total_damage_taken,
			"x" = S.x,
			"y" = S.y,
			"z" = S.z
		))
		if(length(new_death_stats_list) < STATISTICS_DEATH_LIST_LEN)
			new_death_stats_list += death

	for(var/iteration in weapon_stats_list)
		var/datum/entity/weapon_stats/S = weapon_stats_list[iteration]
		if(!S.display_stat)
			continue
		var/list/weapon_humans_killed = list()
		var/list/weapon_xenos_killed = list()
		var/list/weapon_niche_stats_list = list()

		for(var/sub_iteration in S.humans_killed)
			var/datum/entity/statistic/D = S.humans_killed[sub_iteration]
			if(!D)
				continue
			weapon_humans_killed += list(list("name" = get_statistic_display_label(D.name), "value" = D.value))

		for(var/sub_iteration in S.xenos_killed)
			var/datum/entity/statistic/D = S.xenos_killed[sub_iteration]
			if(!D)
				continue
			weapon_xenos_killed += list(list("name" = get_statistic_display_label(D.name), "value" = D.value))

		for(var/sub_iteration in S.niche_stats)
			var/datum/entity/statistic/D = S.niche_stats[sub_iteration]
			if(!D)
				continue
			weapon_niche_stats_list += list(list("name" = get_statistic_display_label(D.name), "value" = D.value))

		new_weapon_stats_list += list(list(
			"name" = sanitize(get_statistic_display_label(S.name)),
			"total_kills" = S.total_kills,
			"total_hits" = S.total_hits,
			"total_shots" = S.total_shots,
			"total_shots_hit" = S.total_shots_hit,
			"total_friendly_fire" = S.total_friendly_fire,
			"humans_killed" = weapon_humans_killed,
			"xenos_killed" = weapon_xenos_killed,
			"niche_stats" = weapon_niche_stats_list
		))

	for(var/iteration in job_stats_list)
		var/datum/entity/player_stats/job/S = job_stats_list[iteration]
		if(!S.display_stat)
			continue
		var/list/job_humans_killed = list()
		var/list/job_xenos_killed = list()
		var/list/job_death_list = list()
		var/list/job_niche_stats_list = list()
		var/list/job_nemesis = null

		if(S.nemesis)
			job_nemesis = list("name" = get_statistic_display_label(S.nemesis.name), "value" = S.nemesis.value)

		for(var/sub_iteration in S.humans_killed)
			var/datum/entity/statistic/D = S.humans_killed[sub_iteration]
			if(!D)
				continue
			job_humans_killed += list(list("name" = get_statistic_display_label(D.name), "value" = D.value))

		for(var/sub_iteration in S.xenos_killed)
			var/datum/entity/statistic/D = S.xenos_killed[sub_iteration]
			if(!D)
				continue
			job_xenos_killed += list(list("name" = get_statistic_display_label(D.name), "value" = D.value))

		for(var/sub_iteration in S.niche_stats)
			var/datum/entity/statistic/D = S.niche_stats[sub_iteration]
			if(!D)
				continue
			job_niche_stats_list += list(list("name" = get_statistic_display_label(D.name), "value" = D.value))

		for(var/datum/entity/statistic/death/DS in S.death_list)
			var/list/damage_list = list()
			if(DS.total_brute)
				damage_list += list(list("name" = "物理伤害", "value" = DS.total_brute))
			if(DS.total_burn)
				damage_list += list(list("name" = "烧伤", "value" = DS.total_burn))
			if(DS.total_oxy)
				damage_list += list(list("name" = "缺氧", "value" = DS.total_oxy))
			if(DS.total_tox)
				damage_list += list(list("name" = "毒素伤害", "value" = DS.total_tox))

			var/new_time_of_death
			if(DS.time_of_death)
				new_time_of_death = duration2text(DS.time_of_death)
			var/new_total_time_alive
			if(DS.total_time_alive)
				new_total_time_alive = duration2text(DS.total_time_alive)

			job_death_list += list(list(
				"mob_name" = sanitize(DS.mob_name),
				"job_name" = get_statistic_display_label(DS.role_name),
				"area_name" = sanitize_area(DS.area_name),
				"cause_name" = sanitize(get_statistic_display_label(DS.cause_name)),
				"total_kills" = DS.total_kills,
				"total_damage" = damage_list,
				"time_of_death" = new_time_of_death,
				"total_time_alive" = new_total_time_alive,
				"total_damage_taken" = DS.total_damage_taken,
				"x" = DS.x,
				"y" = DS.y,
				"z" = DS.z
			))

		new_job_stats_list += list(list(
			"name" = get_statistic_display_label(S.name),
			"total_kills" = S.total_kills,
			"total_deaths" = S.total_deaths,
			"total_playtime" = duration2text(S.total_playtime),
			"total_rounds_played" = S.total_rounds_played,
			"steps_walked" = S.steps_walked,
			"total_friendly_fire" = S.total_friendly_fire,
			"total_revives" = S.total_revives,
			"total_lives_saved" = S.total_lives_saved,
			"total_shots" = S.total_shots,
			"total_shots_hit" = S.total_shots_hit,
			"total_screams" = S.total_screams,
			"nemesis" = job_nemesis,
			"humans_killed" = job_humans_killed,
			"xenos_killed" = job_xenos_killed,
			"job_death_list" = job_death_list,
			"niche_stats" = job_niche_stats_list
		))

	for(var/iteration in caste_stats_list)
		var/datum/entity/player_stats/caste/S = caste_stats_list[iteration]
		if(!S.display_stat)
			continue
		var/list/caste_abilities_used = list()
		var/list/caste_humans_killed = list()
		var/list/caste_xenos_killed = list()
		var/list/caste_death_list = list()
		var/list/caste_niche_stats_list = list()
		var/list/caste_nemesis = null

		if(S.nemesis)
			caste_nemesis = list("name" = get_statistic_display_label(S.nemesis.name), "value" = S.nemesis.value)

		for(var/sub_iteration in S.abilities_used)
			var/datum/entity/statistic/D = S.abilities_used[sub_iteration]
			if(!D)
				continue
			caste_abilities_used += list(list("name" = get_statistic_display_label(D.name), "value" = D.value))

		for(var/sub_iteration in S.humans_killed)
			var/datum/entity/statistic/D = S.humans_killed[sub_iteration]
			if(!D)
				continue
			caste_humans_killed += list(list("name" = get_statistic_display_label(D.name), "value" = D.value))

		for(var/sub_iteration in S.xenos_killed)
			var/datum/entity/statistic/D = S.xenos_killed[sub_iteration]
			if(!D)
				continue
			caste_xenos_killed += list(list("name" = get_statistic_display_label(D.name), "value" = D.value))

		for(var/sub_iteration in S.niche_stats)
			var/datum/entity/statistic/D = S.niche_stats[sub_iteration]
			if(!D)
				continue
			caste_niche_stats_list += list(list("name" = get_statistic_display_label(D.name), "value" = D.value))

		for(var/datum/entity/statistic/death/DS in S.death_list)
			var/list/damage_list = list()
			if(DS.total_brute)
				damage_list += list(list("name" = "物理伤害", "value" = DS.total_brute))
			if(DS.total_burn)
				damage_list += list(list("name" = "烧伤", "value" = DS.total_burn))
			if(DS.total_oxy)
				damage_list += list(list("name" = "缺氧", "value" = DS.total_oxy))
			if(DS.total_tox)
				damage_list += list(list("name" = "毒素伤害", "value" = DS.total_tox))

			var/new_time_of_death
			if(DS.time_of_death)
				new_time_of_death = duration2text(DS.time_of_death)
			var/new_total_time_alive
			if(DS.total_time_alive)
				new_total_time_alive = duration2text(DS.total_time_alive)

			caste_death_list += list(list(
				"mob_name" = sanitize(DS.mob_name),
				"job_name" = get_statistic_display_label(DS.role_name),
				"area_name" = sanitize_area(DS.area_name),
				"cause_name" = sanitize(get_statistic_display_label(DS.cause_name)),
				"total_kills" = DS.total_kills,
				"total_damage" = damage_list,
				"time_of_death" = new_time_of_death,
				"total_time_alive" = new_total_time_alive,
				"total_damage_taken" = DS.total_damage_taken,
				"x" = DS.x,
				"y" = DS.y,
				"z" = DS.z
			))

		new_caste_stats_list += list(list(
			"name" = get_statistic_display_label(S.name),
			"total_kills" = S.total_kills,
			"total_hits" = S.total_hits,
			"total_deaths" = S.total_deaths,
			"total_playtime" = duration2text(S.total_playtime),
			"total_rounds_played" = S.total_rounds_played,
			"steps_walked" = S.steps_walked,
			"nemesis" = caste_nemesis,
			"humans_killed" = caste_humans_killed,
			"xenos_killed" = caste_xenos_killed,
			"death_list" = caste_death_list,
			"abilities_used" = caste_abilities_used,
			"niche_stats" = caste_niche_stats_list
		))

	var/new_time_start
	if(real_time_start)
		new_time_start = time2text(real_time_start)

	var/new_round_length
	if(round_length)
		new_round_length = duration2text(round_length)

	var/new_hijack_time
	if(round_hijack_time)
		new_hijack_time = time2text(round_hijack_time)

	var/new_time_end
	if(real_time_end)
		new_time_end = time2text(real_time_end)

	death_data["death_stats_list"] = new_death_stats_list
	round_data["round"] = list(
		"name" = name,
		"game_mode" = get_statistic_display_label(game_mode),
		"map_name" = get_statistic_display_label(map_name),
		"round_result" = get_statistic_display_label(round_result),
		"real_time_start" = new_time_start,
		"real_time_end" = new_time_end,
		"round_length" = new_round_length,
		"round_hijack_time" = new_hijack_time,
		"end_round_player_population" = end_round_player_population,
		"total_projectiles_fired" = total_projectiles_fired,
		"total_projectiles_hit" = total_projectiles_hit,
		"total_projectiles_hit_human" = total_projectiles_hit_human,
		"total_projectiles_hit_xeno" = total_projectiles_hit_xeno,
		"total_slashes" = total_slashes,
		"total_friendly_fire_instances" = total_friendly_fire_instances,
		"total_huggers_applied" = total_huggers_applied,
		"total_larva_burst" = total_larva_burst,
		"participants" = participants_list,
		"hijack_participants" = hijack_participants_list,
		"final_participants" = final_participants_list,
		"total_deaths" = total_deaths_list,
		"death_stats_list" = new_death_stats_list,
		"weapon_stats_list" = new_weapon_stats_list,
		"job_stats_list" = new_job_stats_list,
		"caste_stats_list" = new_caste_stats_list
	)
