/datum/disease/rhumba_beat
	name = "伦巴节拍病"
	max_stages = 5
	spread = "接触传播"
	spread_type = CONTACT_GENERAL
	cure = "奇卡奇卡砰！"
	cure_id = list("phoron")
	agent = "未知"
	affected_species = list("Human")
	permeability_mod = 1

/datum/disease/rhumba_beat/stage_act()
	..()
	switch(stage)
		if(1)
			if(affected_mob.ckey == "rosham")
				src.cure()
		if(2)
			if(affected_mob.ckey == "rosham")
				src.cure()
			if(prob(45))
				affected_mob.apply_damage(5, TOX)
				affected_mob.updatehealth()
			if(prob(1))
				to_chat(affected_mob, SPAN_DANGER("你感到有些异样……"))
		if(3)
			if(affected_mob.ckey == "rosham")
				src.cure()
			if(prob(5))
				to_chat(affected_mob, SPAN_DANGER("你突然想跳舞……"))
			else if(prob(5))
				affected_mob.emote("gasp")
			else if(prob(10))
				to_chat(affected_mob, SPAN_DANGER("你忍不住想跟着节拍摇摆……"))
		if(4)
			if(affected_mob.ckey == "rosham")
				src.cure()
			if(prob(10))
				affected_mob.emote("gasp")
				to_chat(affected_mob, SPAN_DANGER("你感到炽热的节奏在体内涌动……"))
			if(prob(20))
				affected_mob.apply_damage(5, TOX)
				affected_mob.updatehealth()
		if(5)
			if(affected_mob.ckey == "rosham")
				src.cure()
			to_chat(affected_mob, SPAN_DANGER("你的身体已经无法容纳伦巴舞的节拍……"))
			if(prob(50))
				affected_mob.gib()
		else
			return
