/datum/random_fact/ib
	statistic_name = "人"
	statistic_verb = "修复内出血的患者数为"

/datum/random_fact/ib/life_grab_stat(mob/fact_mob)
	return fact_mob.life_ib_total

/datum/random_fact/ib/death_grab_stat(datum/entity/statistic/death/fact_death)
	return fact_death.total_ib_fixed
