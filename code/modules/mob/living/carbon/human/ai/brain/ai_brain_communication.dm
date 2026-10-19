/datum/human_ai_brain
	/// Lines potentially said when an AI enters combat
	var/list/enter_combat_lines = list(
		"发现敌情！",
		"发现敌情！",
		"妈的——发现敌情！",
		"正前方有敌人！",
		"我们遭遇敌人了！",
		"打起精神！",
		"举枪！",
		"在那儿！",
		"那边！",
		"开火！",
		"开火！",
		"接敌！",
		"接敌！",
		"自由开火！",
		"消灭他们！",
		"火力招呼他们！",
		"扫倒他们！",
		"干死他们！",
		"干掉这帮狗娘养的！",
		"宰了那个混蛋！",
		"干掉那个混蛋！",
		"大干一场！",
		"吃屎去吧！",
		"去死吧，狗娘养的！",
		"吃枪子吧！",
		"吃枪子吧！",
		"狗娘养的，吃枪子吧！",
		"*warcry",
	)

	/// Lines potentially said when an AI exits combat
	var/list/exit_combat_lines = list(
		"停火！",
		"停火！",
		"停止射击！",
		"别开火！",
		"别开火！",
		"敌人清除了！",
		"清除干净了吗？",
		"看起来安全了！",
		"安全了！",
		"保持警戒！",
		"可能还有敌人——保持警戒。",
	)

	/// Lines potentially said when an AI's squadmate dies
	var/list/squad_member_death_lines = list(
		"操！",
		"妈的！",
		"该死！",
		"狗娘养的！",
		"他妈的！",
		"我们这边遭到攻击了！",
		"他们干掉了我们的人——他妈的还击！",
		"狗娘养的，你他妈会付出代价的！",
		"混蛋，你他妈会付出代价的！",
		"队友倒下了！",
		"队友阵亡了！",
		"他们干掉了我们的人！",
	)

	/// Lines potentially said when an AI throws a grenade
	var/list/grenade_thrown_lines = list(
		"手榴弹！",
		"我要投弹了！",
		"手榴弹，躲开！",
		"混蛋，吃我这颗！",
		"原物奉还！",
		"狗娘养的，给你送货来了！",
	)

	/// Lines potentially said when an AI reloads a magazine-fed gun
	var/list/reload_lines = list(
		"换弹中！",
		"换弹中！",
		"更换弹匣！",
		"更换弹匣！",
		"换弹匣！",
		"换弹匣！",
		"掩护我，我在换弹！",
		"需要火力掩护！",
		"掩护我！",
		"弹空！弹空——装填完毕！",
		"我没弹了！",
		"弹空！",
	)

	/// Lines potentially said when an AI reloads a tube-fed gun
	var/list/reload_internal_mag_lines = list(
		"换弹中！",
		"换弹中！",
		"掩护我，我在换弹！",
		"需要火力掩护！",
		"掩护我！",
		"弹空！弹空——装填完毕！",
		"我没弹了！",
		"老天，我他妈需要个快速装弹器！",
		"弹空！",
	)

	/// Currently unused
	var/list/need_healing_lines = list(
		"操他妈的！",
		"操！",
		"妈的！",
		"该死！",
		"狗娘养的！",
		"他妈的！",
		"我的天啊！",
		"我在流血！",
		"天哪——不！",
		"我这边正挨打呢！",
		"我中弹了！",
		"我受伤了！",
		"准备扎注射器！",
		"注射器扎进去了！",
		"我需要纱布！",
		"谁来把这该死的窟窿补上！",
		"需要吗啡！",
	)

	/// Chance that an AI says a voiceline when entering combat
	var/in_combat_line_chance = 100
	/// Chance that an AI says a voiceline when exiting combat
	var/exit_combat_line_chance = 100
	/// Chance that an AI says a voiceline when a squadmember dies
	var/squad_member_death_line_chance = 100
	/// Chance that an AI says a voiceline when they throw a grenade
	var/grenade_thrown_line_chance = 100
	/// Chance that an AI says a voiceline when they reload a gun
	var/reload_line_chance = 100
	/// Currently unused
	var/need_healing_line_chance = 100

/datum/human_ai_brain/proc/say_in_combat_line(chance = in_combat_line_chance)
	if(!length(enter_combat_lines) || !prob(chance) || (tied_human.health < HEALTH_THRESHOLD_CRIT))
		return
	tied_human.say(pick(enter_combat_lines))

/datum/human_ai_brain/proc/say_exit_combat_line(chance = exit_combat_line_chance)
	if(!length(exit_combat_lines) || !prob(chance) || (tied_human.health < HEALTH_THRESHOLD_CRIT))
		return
	tied_human.say(pick(exit_combat_lines))

/datum/human_ai_brain/proc/on_squad_member_death(mob/living/carbon/human/dead_member)
	if(!length(squad_member_death_lines) || !prob(squad_member_death_line_chance) || (tied_human.health < HEALTH_THRESHOLD_CRIT))
		return
	tied_human.say(pick(squad_member_death_lines))

/datum/human_ai_brain/proc/say_grenade_thrown_line(chance = grenade_thrown_line_chance)
	if(!length(grenade_thrown_lines) || !prob(chance) || (tied_human.health < HEALTH_THRESHOLD_CRIT))
		return
	tied_human.say(pick(grenade_thrown_lines))

/datum/human_ai_brain/proc/say_reload_line(chance = reload_line_chance)
	if(!length(reload_lines) || !prob(chance) || (tied_human.health < HEALTH_THRESHOLD_CRIT) || !primary_weapon)
		return
	if(istype(primary_weapon.current_mag, /obj/item/ammo_magazine/internal))
		tied_human.say(pick(reload_internal_mag_lines))
	else
		tied_human.say(pick(reload_lines))

/datum/human_ai_brain/proc/say_need_healing_line(chance = need_healing_line_chance)
	if(!length(need_healing_lines) || !prob(chance) || (tied_human.health < HEALTH_THRESHOLD_CRIT))
		return
	tied_human.say(pick(need_healing_lines))
