/datum/disease/gbs
	name = "GBS"
	max_stages = 5
	spread = "On contact"
	spread_type = CONTACT_GENERAL
	cure = "Sulfur"
	cure_id = list("sulfur")
	cure_chance = 15//higher chance to cure, since two reagents are required
	agent = "Gravitokinetic Bipotential SADS+"
	affected_species = list("Human")
	curable = 0
	permeability_mod = 1

/datum/disease/gbs/stage_act()
	..()
	switch(stage)
		if(2)
			if(prob(45))
				affected_mob.apply_damage(5, TOX)
				affected_mob.updatehealth()
			if(prob(1))
				affected_mob.emote("sneeze")
		if(3)
			if(prob(5))
				affected_mob.emote("cough")
			else if(prob(5))
				affected_mob.emote("gasp")
			if(prob(10))
				to_chat(affected_mob, SPAN_DANGER("你开始感到十分虚弱……"))
		if(4)
			if(prob(10))
				affected_mob.emote("cough")
			affected_mob.apply_damage(5, TOX)
			affected_mob.updatehealth()
		if(5)
			to_chat(affected_mob, SPAN_DANGER("你感到身体仿佛要从内部撕裂开来……"))
			if(prob(50))
				affected_mob.gib()
		else
			return
