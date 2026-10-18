/*
//////////////////////////////////////

Headache

	Noticeable.
	Highly resistant.
	Increases stage speed.
	Not transmittable.
	Low Level.

BONUS
	Displays an annoying message!
	Should be used for buffing your disease.

//////////////////////////////////////
*/

/datum/symptom/headache

	name = "头痛"
	stealth = -1
	resistance = 4
	stage_speed = 2
	transmittable = 0
	level = 1

/datum/symptom/headache/Activate(datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB))
		var/mob/living/M = A.affected_mob
		to_chat(M, SPAN_NOTICE("[pick("你感到头疼。", "你的头开始一阵阵地痛。")]"))
	return
