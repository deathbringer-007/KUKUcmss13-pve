/obj/effect/landmark/survivor_spawner
	name = "special survivor spawner"
	var/equipment = null
	var/synth_equipment = null
	var/CO_equipment = null
	var/list/intro_text = list()
	var/story_text = ""
	var/roundstart_damage_min = 0
	var/roundstart_damage_max = 0
	var/roundstart_damage_times = 1
	/// Whether or not the spawner is for an inherently hostile survivor subtype.
	var/hostile = FALSE

	var/spawn_priority = LOWEST_SPAWN_PRIORITY

/obj/effect/landmark/survivor_spawner/Initialize(mapload, ...)
	. = ..()
	LAZYINITLIST(GLOB.survivor_spawns_by_priority["[spawn_priority]"])
	GLOB.survivor_spawns_by_priority["[spawn_priority]"] += src

/obj/effect/landmark/survivor_spawner/Destroy()
	GLOB.survivor_spawns_by_priority["[spawn_priority]"] -= src
	return ..()

/obj/effect/landmark/survivor_spawner/proc/check_can_spawn(mob/living/carbon/human/survivor)
	// prevents stacking survivors on top of eachother
	if(locate(/mob/living/carbon/human) in loc)
		return FALSE
	return TRUE

/obj/effect/landmark/survivor_spawner/lv624_crashed_clf
	hostile = TRUE
	equipment = /datum/equipment_preset/survivor/clf
	synth_equipment = /datum/equipment_preset/clf/synth
	intro_text = list("<h2>你是一场迫降事故的幸存者！</h2>",\
	"<span class='notice'>你并不了解异形的威胁。</span>",\
	"<span class='danger'>你的首要目标是养好伤并活下去。若想进攻虫巢，请先使用管理员求助。</span>")
	story_text = "你是一名为殖民地解放阵线而战的士兵。你的舰船收到一颗行星发出的求救信号。那颗行星由美国殖民地海军陆战队控制，与殖民地解放阵线控制的星域接壤。为了从寄生般的暴君手中拯救可怜的殖民者，你和队友登上了名为“玛丽·居里号”的小型飞船。不幸的是，就在接近着陆区时，一团酸液击中船体，损坏了一台引擎。尽管飞行员竭尽全力，飞船还是径直撞上了附近的山体。撞击让你疼痛难忍。你晕头转向地爬起来，发现一条肢体上满是严重的淤伤。其他幸存者也一瘸一拐地处理着伤口；幸运的是，大家都没有受重伤。"
	roundstart_damage_min = 3
	roundstart_damage_max = 10
	roundstart_damage_times = 2

	spawn_priority = SPAWN_PRIORITY_HIGH

/obj/effect/landmark/survivor_spawner/lv624_crashed_clf_leader
	hostile = TRUE
	equipment = /datum/equipment_preset/clf/leader
	synth_equipment = /datum/equipment_preset/clf/synth
	intro_text = list("<h2>你是一场迫降事故的幸存者！</h2>",\
	"<span class='notice'>你并不了解异形的威胁。</span>",\
	"<span class='danger'>你的首要目标是养好伤并活下去。若想进攻虫巢，请先使用管理员求助。</span>")
	story_text = "你是一支殖民地解放阵线小队的队长。你的舰船收到一颗由美国殖民地海军陆战队控制、与解放阵线控制星域接壤的行星发出的求救信号。为了从寄生般的暴君手中拯救可怜的殖民者，你下令带领队伍登上名为“玛丽·居里号”的小型飞船。不幸的是，就在接近着陆区时，一团酸液击中船体，损坏了一台引擎。尽管飞行员竭尽全力，飞船还是径直撞上了附近的山体。撞击让你疼痛难忍。你晕头转向地爬起来，发现一条肢体上满是严重的淤伤。小队中剩下的几名幸存者也一瘸一拐地处理着伤口。幸运的是，你的人都没有受重伤，看起来也仍能听从你的命令。"
	roundstart_damage_min = 2
	roundstart_damage_max = 10
	roundstart_damage_times = 2

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

/obj/effect/landmark/survivor_spawner/lv624_crashed_clf_engineer
	hostile = TRUE
	equipment = /datum/equipment_preset/clf/engineer
	synth_equipment = /datum/equipment_preset/clf/synth
	intro_text = list("<h2>你是一场迫降事故的幸存者！</h2>",\
	"你并不了解异形的威胁。",\
	"你的首要目标是养好伤并活下去。若想进攻虫巢，请先使用管理员求助。")
	story_text = "你是一名为殖民地解放阵线而战的工程师。你的舰船收到一颗行星发出的求救信号。那颗行星由美国殖民地海军陆战队控制，与殖民地解放阵线控制的星域接壤。为了从寄生般的暴君手中拯救可怜的殖民者，你和队友登上了名为“玛丽·居里号”的小型飞船。不幸的是，就在接近着陆区时，一团酸液击中船体，损坏了一台引擎。尽管飞行员竭尽全力，飞船还是径直撞上了附近的山体。撞击让你疼痛难忍。你晕头转向地爬起来，发现一条肢体上满是严重的淤伤。其他幸存者也一瘸一拐地处理着伤口；幸运的是，大家都没有受重伤。"
	roundstart_damage_min = 3
	roundstart_damage_max = 10
	roundstart_damage_times = 2

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

/obj/effect/landmark/survivor_spawner/lv624_crashed_clf_medic
	hostile = TRUE
	equipment = /datum/equipment_preset/clf/medic
	synth_equipment = /datum/equipment_preset/clf/synth
	intro_text = list("<h2>你是一场迫降事故的幸存者！</h2>",\
	"你并不了解异形的威胁。",\
	"你的首要目标是养好伤并活下去。若想进攻虫巢，请先使用管理员求助。")
	story_text = "你是一名为殖民地解放阵线而战的医生。你的舰船收到一颗行星发出的求救信号。那颗行星由美国殖民地海军陆战队控制，与殖民地解放阵线控制的星域接壤。为了从寄生般的暴君手中拯救可怜的殖民者，你和队友登上了名为“玛丽·居里号”的小型飞船。不幸的是，就在接近着陆区时，一团酸液击中船体，损坏了一台引擎。尽管飞行员竭尽全力，飞船还是径直撞上了附近的山体。撞击让你疼痛难忍。你晕头转向地爬起来，发现一条肢体上满是严重的淤伤。其他幸存者也一瘸一拐地处理着伤口；幸运的是，大家都没有受重伤。"
	roundstart_damage_min = 3
	roundstart_damage_max = 10
	roundstart_damage_times = 2

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

//Weyland-Yutani Survivors//

/obj/effect/landmark/survivor_spawner/lv624_corporate_dome_cl
	equipment = /datum/equipment_preset/colonist/whitecollar
	synth_equipment = /datum/equipment_preset/synth/survivor/wy/security_synth
	intro_text = list("<h2>你是拉撒路着陆区最后一名活着的公司高管！</h2>",\
	"<span class='notice'>你了解异形的威胁。</span>",\
	"<span class='danger'>你的首要目标是在这场爆发中活下去。</span>")
	story_text = "你是维兰德-汤谷派驻LV-624的公司联络员。你事先获知，有人从殖民地东北方的外星神庙中带回了一批模样极其古怪的卵。公司聘用你，正是看中了你的精明；研究穹顶的培养槽中孵出第一只“抱脸虫”时，你便决定在办公室里为最坏的情况做好准备。事实证明你是对的：那些曾说你疯了、把这些东西当成新型“合成人”的人，如今全都死了。正是这份多疑，让你和随行的公司安保人员成为仅存的幸存者。异形的猛攻从未停歇，一名安保员击中了燃料罐，导致穹顶的一部分被炸毁，许多防御设施也已被腐蚀殆尽。你必须活下去，并设法联系维兰德-汤谷。"

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

/obj/effect/landmark/survivor_spawner/lv624_corporate_dome_goon
	equipment = /datum/equipment_preset/colonist/security/weyland
	synth_equipment = /datum/equipment_preset/synth/survivor/wy/security_synth
	intro_text = list("<h2>你是一名公司安保员！</h2>",\
	"<span class='notice'>你了解异形的威胁。</span>",\
	"<span class='danger'>你的首要目标是在这场爆发中活下去。</span>")
	story_text = "你是维兰德-汤谷派驻LV-624的公司安保员。有一天，公司联络员突然把你叫到一旁，要求你尽快从工程部和执法官办公室搬来物资，送进联络员办公室。你开始加固公司穹顶，那名高管告诉你，某种可怕的东西将席卷整个殖民地，只有你们能幸免。结果联络员说对了：那些被称为“异形”的东西突破研究穹顶的收容，开始摧毁整个殖民地。它们随后袭击公司穹顶，企图杀光你们。你们勉强抵挡住了进攻，却损失了一名安保员和大量防御设施。联络员说，很快就能找到联系维兰德-汤谷的办法；在救援到来之前，你们必须坚守。"

	spawn_priority = SPAWN_PRIORITY_HIGH

/obj/effect/landmark/survivor_spawner/bigred_crashed_pmc
	equipment = /datum/equipment_preset/survivor/pmc
	synth_equipment = /datum/equipment_preset/synth/survivor/pmc
	intro_text = list("<h2>你是一场迫降事故的幸存者！</h2>",\
	"<span class='notice'>你并不了解异形的威胁。</span>",\
	"<span class='danger'>你的首要目标是养好伤并活下去。若想进攻虫巢，请先使用管理员求助。</span>")
	story_text = "你是一名维兰德-汤谷私人军事承包商雇佣兵。你的飞船原本正前往索拉里斯山脊，护送一名助理经理。途中，飞船收到殖民地遭到袭击的求救信号。飞行员担心是殖民地解放阵线发动了进攻，便全速驶向殖民地。然而进入大气层时引擎发生故障，过载使你失去了意识。你带着伤醒来……发现飞船已经坠毁在殖民地。身边的队友都死了，但还有几人不见踪影。也许他们活了下来，已经去了别处？你需要查明殖民地发生了什么，寻找可能幸存的队友，并设法联系维兰德-汤谷。"
	roundstart_damage_min = 3
	roundstart_damage_max = 10
	roundstart_damage_times = 2

	spawn_priority = SPAWN_PRIORITY_HIGH

/obj/effect/landmark/survivor_spawner/bigred_crashed_pmc_medic
	equipment = /datum/equipment_preset/pmc/medic
	synth_equipment = /datum/equipment_preset/synth/survivor/pmc
	intro_text = list("<h2>你是一场迫降事故的幸存者！</h2>",\
	"你并不了解异形的威胁。",\
	"你的首要目标是养好伤并活下去。若想进攻虫巢，请先使用管理员求助。")
	story_text = "你是一名维兰德-汤谷私人军事承包商医疗兵。你的飞船原本正前往索拉里斯山脊，护送一名助理经理。途中，飞船收到殖民地遭到袭击的求救信号。飞行员担心是殖民地解放阵线发动了进攻，便全速驶向殖民地。然而进入大气层时引擎发生故障，过载使你失去了意识。你带着伤醒来……发现飞船已经坠毁在殖民地。身边的队友都死了，但还有几人不见踪影。也许他们活了下来，已经去了别处？你需要查明殖民地发生了什么，寻找可能幸存的队友，并设法联系维兰德-汤谷。"
	roundstart_damage_min = 3
	roundstart_damage_max = 10
	roundstart_damage_times = 2

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

/obj/effect/landmark/survivor_spawner/bigred_crashed_pmc_engineer
	equipment = /datum/equipment_preset/pmc/standard
	synth_equipment = /datum/equipment_preset/synth/survivor/pmc
	intro_text = list("<h2>你是一场迫降事故的幸存者！</h2>",\
	"你并不了解异形的威胁。",\
	"你的首要目标是养好伤并活下去。若想进攻虫巢，请先使用管理员求助。")
	story_text = "你是一名维兰德-汤谷私人军事承包商工程师。你的飞船原本正前往索拉里斯山脊，护送一名助理经理。途中，飞船收到殖民地遭到袭击的求救信号。飞行员担心是殖民地解放阵线发动了进攻，便全速驶向殖民地。然而进入大气层时引擎发生故障，过载使你失去了意识。你带着伤醒来……发现飞船已经坠毁在殖民地。身边的队友都死了，但还有几人不见踪影。也许他们活了下来，已经去了别处？你需要查明殖民地发生了什么，寻找可能幸存的队友，并设法联系维兰德-汤谷。"
	roundstart_damage_min = 3
	roundstart_damage_max = 10
	roundstart_damage_times = 2

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

/obj/effect/landmark/survivor_spawner/bigred_crashed_cl
	equipment = /datum/equipment_preset/colonist/whitecollar
	synth_equipment = /datum/equipment_preset/synth/survivor/pmc
	intro_text = list("<h2>你是一场迫降事故的幸存者！</h2>",\
	"<span class='notice'>你并不了解异形的威胁。</span>",\
	"<span class='danger'>你的首要目标是养好伤并活下去。若想进攻虫巢，请先使用管理员求助。</span>")
	story_text = "你是维兰德-汤谷的一名助理经理，原本正搭乘私人军事承包商的飞船，在护卫下前往索拉里斯山脊。途中，飞船收到殖民地遭到袭击的求救信号。飞行员担心是殖民地解放阵线发动了进攻，便全速驶向殖民地。然而进入大气层时引擎发生故障，过载使你失去了意识。你带着伤醒来……发现飞船已经坠毁在殖民地。身边的承包商护卫都死了，但还有几人不见踪影。也许他们活了下来，已经去了别处？你必须站起来，并设法联系维兰德-汤谷。"
	roundstart_damage_min = 3
	roundstart_damage_max = 10
	roundstart_damage_times = 2

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

/obj/effect/landmark/survivor_spawner/shivas_panic_room_cl
	equipment = /datum/equipment_preset/colonist/whitecollar
	synth_equipment = /datum/equipment_preset/synth/survivor/wy/corporate_synth
	intro_text = list("<h2>你是殖民地最后一名活着的资深行政主管！</h2>",\
	"<span class='notice'>你了解异形的威胁。</span>",\
	"<span class='danger'>你的首要目标是在这场爆发中活下去。</span>")
	story_text = "你是维兰德-汤谷派驻“伊弗利特”的助理运营经理。这场爆发将一切搅得天翻地覆。你和其他公司人员逃进运营部避险室，随后听到外面传来枪声，便关闭了百叶防护门。你们的食物、饮水和弹药都快用完了，而那些武器正是你曾经说过“毫无用处”、浪费公司经费的东西。你记得施塔尔行政主管曾向范围内的所有舰船发出求救信标，希望公司能够收到，随后便跑去了太空港。此后你再没见过他。那些被称为“异形”的生物曾试图攻击防护门、闯进来，却没有成功。它们很快就会再次尝试。你必须活下去，并设法联系维兰德-汤谷。"

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

/obj/effect/landmark/survivor_spawner/shivas_panic_room_doc
	equipment = /datum/equipment_preset/colonist/doctor
	synth_equipment = /datum/equipment_preset/synth/survivor/emt_synth
	intro_text = list("<h2>你是殖民地的一名医生！</h2>",\
	"<span class='notice'>你了解异形的威胁。</span>",\
	"<span class='danger'>你的首要目标是在这场爆发中活下去。</span>")
	story_text = "你是维兰德-汤谷在“伊弗利特”雇用的一名医生。这场爆发将一切搅得天翻地覆。你和其他公司人员逃进运营部避险室，随后听到外面传来枪声，便关闭了百叶防护门。你们的食物、饮水和武器弹药都快用完了。你记得异形有某种会紧贴人脸的植入生物，随后……就会有东西穿过肋骨，从人的胸口破体而出。医疗区曾接收过许多这样的病例。那些被称为“异形”的生物曾试图攻击防护门、闯进来，却没有成功。它们很快就会再次尝试。你必须活下去，并设法联系维兰德-汤谷。"

	spawn_priority = SPAWN_PRIORITY_HIGH

/obj/effect/landmark/survivor_spawner/shivas_panic_room_sci
	equipment = /datum/equipment_preset/colonist/researcher
	synth_equipment = /datum/equipment_preset/synth/survivor/scientist_synth
	intro_text = list("<h2>你是殖民地的一名维兰德-汤谷科学家！</h2>",\
	"<span class='notice'>你了解异形的威胁。</span>",\
	"<span class='danger'>你的首要目标是在这场爆发中活下去。</span>")
	story_text = "你是维兰德-汤谷在“伊弗利特”雇用的一名科学家。这场爆发将一切搅得天翻地覆。你和其他公司人员逃进运营部避险室，随后听到外面传来枪声，便关闭了百叶防护门。你们的食物、饮水和武器弹药都快用完了。你记得研究主任克拉克将这些生物命名为XX-121；它们有许多不同的类型，似乎还有某种“领袖”。你也知道，它们的酸液一旦碰到人或防护门，就会造成致命后果。你早已逃离实验室，有些同事此后便再没见过。那些被称为“异形”的生物曾试图攻击防护门、闯进来，却没有成功。它们很快就会再次尝试。你必须活下去，并设法联系维兰德-汤谷。"

	spawn_priority = SPAWN_PRIORITY_HIGH

/obj/effect/landmark/survivor_spawner/shivas_panic_room_civ
	equipment = /datum/equipment_preset/colonist
	synth_equipment = /datum/equipment_preset/synth/survivor/chef_synth
	intro_text = list("<h2>你是殖民地的一名工人！</h2>",\
	"<span class='notice'>你了解异形的威胁。</span>",\
	"<span class='danger'>你的首要目标是在这场爆发中活下去。</span>")
	story_text = "你是维兰德-汤谷在“伊弗利特”雇用的一名平民职员。这场爆发将一切搅得天翻地覆。你和其他公司人员逃进运营部避险室，随后听到外面传来枪声，便关闭了百叶防护门。你们的食物、饮水和武器弹药都快用完了。你记得警报突然响起，自己便和其他几人一同逃向避险室，希望能在救援到来之前躲过危险。如今你正和其他人一起等待它们对避险室的第二次进攻。第一次，那些被称为“异形”的生物曾试图攻击防护门、闯进来，却没有成功。它们很快就会再次尝试。你必须活下去，并设法联系维兰德-汤谷。"

	spawn_priority = SPAWN_PRIORITY_MEDIUM

//CMB Survivors//

/obj/effect/landmark/survivor_spawner/fiorina_armory_cmb
	equipment = /datum/equipment_preset/cmb/deputy
	synth_equipment = /datum/equipment_preset/cmb/synth
	intro_text = list("<h2>你是殖民地执法局的一名副执法官！</h2>",\
	"<span class='notice'>你了解“外星生物”的威胁。</span>",\
	"<span class='danger'>你的首要目标是在这场侵袭中活下去。</span>")
	story_text = "你是殖民地法警署的一名副执法官。调度员收到声名狼藉的菲奥里纳最高戒备监狱发出的求救信号。你以为又是监狱发生了人手不足的安保部队应付不了的暴动：他们的人员不断被调往银河系的其他地方，这种事早已屡见不鲜。法警署执法官也不是第一次被叫来支援，但不幸的是，这次同样不是你预想中的“小规模暴动”。你们只带着布袋弹抵达着陆区，却发现无人接应。你和队友于是前往军械库，想找军需官了解情况，沿途却只看到囚犯和狱警的尸体。担心囚犯已经拿到武器，队伍正在军械库中换装实弹；这时，一只巨大的外星生物突然从阴影中扑出，抓走了正在祈祷的杰瑞。它拖着人跑得太快，根本追不上，惨叫声也逐渐消失在走廊深处。可怜的家伙。现在，你得决定是继续搜寻线索、查明这里究竟发生了什么，猎杀外面的东西，还是坚守阵地，希望在为时已晚之前，另有人回应求救信号……"

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

/obj/effect/landmark/survivor_spawner/fiorina_armory_riot_control
	equipment = /datum/equipment_preset/colonist/security/prison
	synth_equipment = /datum/equipment_preset/cmb/synth
	intro_text = list("<h2>你是一名美洲联盟防暴警员！</h2>",\
	"<span class='notice'>你了解“外星生物”的威胁。</span>",\
	"<span class='danger'>你的首要目标是在这场侵袭中活下去。</span>")
	story_text = "你是一名美洲联盟防暴警员。调度员收到当地殖民地法警署哨站的请求，希望派人协助一名副执法官处理菲奥里纳的暴动。监狱长期人手不足、混乱不堪，因此你对他们再次发出求救信号、叫你们来替他们干活毫不意外。可不幸的是，这次并不是你预想中的“小规模暴动”。你们只带着布袋弹抵达着陆区，却发现无人接应。你和队友于是前往军械库，想找军需官了解情况，沿途却只看到囚犯和狱警的尸体。担心囚犯已经拿到武器，队伍正在军械库中换装实弹；这时，一只巨大的外星生物突然从阴影中扑出，抓走了正在祈祷的杰瑞。它拖着人跑得太快，根本追不上，惨叫声也逐渐消失在走廊深处。可怜的家伙。现在，你得决定是继续搜寻线索、查明这里究竟发生了什么，猎杀外面的东西，还是坚守阵地，希望在为时已晚之前，另有人回应求救信号……"

	spawn_priority = SPAWN_PRIORITY_HIGH

//Military Survivors//

/obj/effect/landmark/survivor_spawner/lv522_forecon_tech
	equipment = /datum/equipment_preset/survivor/forecon/tech
	spawn_priority = SPAWN_PRIORITY_HIGH

/obj/effect/landmark/survivor_spawner/lv522_forecon_marksman
	equipment = /datum/equipment_preset/survivor/forecon/marksman
	spawn_priority = SPAWN_PRIORITY_MEDIUM

/obj/effect/landmark/survivor_spawner/lv522_forecon_smartgunner
	equipment = /datum/equipment_preset/survivor/forecon/smartgunner
	spawn_priority = SPAWN_PRIORITY_MEDIUM

/obj/effect/landmark/survivor_spawner/lv522_forecon_sniper
	equipment = /datum/equipment_preset/survivor/forecon/sniper
	spawn_priority = SPAWN_PRIORITY_MEDIUM

/obj/effect/landmark/survivor_spawner/lv522_forecon_squad_leader
	equipment = /datum/equipment_preset/survivor/forecon/squad_leader
	spawn_priority = SPAWN_PRIORITY_HIGH
