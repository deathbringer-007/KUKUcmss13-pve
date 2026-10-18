//Xenomicrobes

/datum/disease/xeno_transformation
	name = "Unknown Mutagenic Disease"
	max_stages = 5
	spread = "注射传播"
	spread_type = SPECIAL
	cure = "未知"
	cure_chance = 5
	agent = "里普利致突变微生物"
	affected_species = list("Human")
	hidden = list(1, 0)
	stage_minimum_age = 100

/datum/disease/xeno_transformation/stage_act()
	..()
	switch(stage)
		if(2)
			if (prob(3))
				to_chat(affected_mob, "你的喉咙有些发痒。")
		if(3)
			if (prob(5))
				to_chat(affected_mob, SPAN_DANGER("你的喉咙痒得厉害。"))
				affected_mob.take_limb_damage(1)
			if (prob(8))
				to_chat(affected_mob, SPAN_DANGER("你的皮肤感到紧绷。"))
				affected_mob.take_limb_damage(2)
			if (prob(4))
				to_chat(affected_mob, SPAN_DANGER("你的头部传来一阵刺痛。"))
				affected_mob.apply_effect(2, PARALYZE)
			if (prob(4))
				to_chat(affected_mob, SPAN_DANGER("你感觉有什么东西在动……就在体内。"))
			if (prob(5))
				to_chat(affected_mob, "\italic " + pick("我们很快就会融为一体……", "必须……吞噬……", "捕获……", "我们是完美的。"))
		if(4)
			if (prob(10))
				to_chat(affected_mob, pick(SPAN_DANGER("你的皮肤感到十分紧绷。"), SPAN_DANGER("你的血液沸腾了！")))
				affected_mob.take_limb_damage(3)
			if (prob(5))
				affected_mob.whisper(pick("我们很快就会融为一体……", "必须……吞噬……", "捕获……", "我们是完美的。", "嘶嘶嘶！"))
			if (prob(8))
				to_chat(affected_mob, SPAN_DANGER("你能感觉到……体内……有什么东西。"))
		if(5)
			to_chat(affected_mob, SPAN_DANGER("你的皮肤变得异常粗硬……"))
			affected_mob.apply_damage(10, TOX)
			affected_mob.updatehealth()
			if(prob(40))
				var/turf/T = find_loc(affected_mob)
				gibs(T)
				var/mob/living/carbon/human/H = affected_mob
				H.Alienize(XENO_T1_CASTES)
				src.cure()

