/datum/effects/neurotoxin
	effect_name = "neurotoxin gas"
	/// Duration of the effect. Also used for intensity aswell
	duration = 0
	// We don't want to damage people when they die
	flags = NO_PROCESS_ON_DEATH | DEL_ON_DEATH
	/// Multiplier for effects. Inputted in directly.
	var/strength = 0
	/// Default per proc message
	var/msg = "你的全身逐渐麻木，很快就感到疲惫不堪！"
	/// Should we stumble on next tick? Changed automatically
	var/stumble = TRUE
	/// Probability of stumbling per proc. Changed by code.
	var/stumble_prob = 0
	/// Chance of blood_cough per proc (damaging)
	var/bloodcough_prob = 0
	/// Whether or not we hallucinate. (small rng stun chance)
	var/hallucinate = TRUE
	// Tick-based chat cooldown so it doesn't get too spammy
	var/chat_cd = 0
	/// Stamina damage per tick. Major balance number.
	var/stam_dam = 7

/datum/effects/neurotoxin/New(atom/thing, mob/from = null)
	..(thing, from, effect_name)

/datum/effects/neurotoxin/validate_atom(atom/thing)
	if(isxeno(thing) || isobj(thing))
		return FALSE

	return ..()

/datum/effects/neurotoxin/process_mob() //yandere dev coding style
	. = ..()
	var/mob/living/carbon/affected_mob = affected_atom
	if(!.)
		return FALSE
	if(affected_mob.stat == DEAD)
		return

	if(issynth(affected_atom))
		return
	
// General effects
	affected_mob.last_damage_data = cause_data
	affected_mob.apply_stamina_damage(stam_dam)
	affected_mob.make_dizzy(12)

// Effect levels (shit that doesn't stack)
	switch(duration)

		if(0 to 9)
			msg = initial(msg)
			bloodcough_prob = initial(bloodcough_prob)
			stumble_prob = initial(stumble_prob)

		if(10 to 14) // 2 ticks in smoke
			msg = SPAN_DANGER("你的身体开始发麻，连手指都感觉不到了！")
			bloodcough_prob = 10

		if(15 to 19) // 3 ticks in smoke
			msg = pick(SPAN_BOLDNOTICE("我为什么会在这里？"),SPAN_HIGHDANGER("你感到全身发麻！"), SPAN_HIGHDANGER("你发现自己的动作变得不受控制！"), SPAN_HIGHDANGER("麻木感蔓延全身，你惊慌失措！"))
			bloodcough_prob = 20
			stumble_prob = 5

		if(20 to 24) // 4 ticks in smoke
			msg = SPAN_DANGER("你的眼睛刺痛，什么都看不见了！")
			bloodcough_prob = 25
			stumble_prob = 25

		if(25 to INFINITY) // 5+ ticks in smoke
			msg = pick(SPAN_BOLDNOTICE("我在做什么？"),SPAN_DANGER("你的听觉逐渐消失，什么都听不见了！"),SPAN_HIGHDANGER("腹部传来一阵剧痛！"),SPAN_HIGHDANGER("全身都在痛！！啊——！！！"),SPAN_HIGHDANGER("你的全身都麻木了，什么都感觉不到了！"),SPAN_HIGHDANGER("你完全感觉不到自己的四肢了！"),SPAN_HIGHDANGER("你的脑海一片空白，什么都想不起来！"))

// Stacking effects below

	if(duration >= 10) // 2 ticks in smoke
		affected_mob.apply_effect(10,pick(SLUR,STUTTER))
		affected_mob.apply_effect(max(affected_mob.eye_blurry, strength), EYE_BLUR)

	if(duration > 14) // 3 ticks in smoke
		affected_mob.apply_effect(5,AGONY)  // Fake crit, a good way to induce panic
		affected_mob.make_jittery(15)
		if(affected_mob.client && ishuman(affected_mob) && hallucinate)
			var/mob/living/carbon/human/affected_human = affected_mob
			process_hallucination(affected_human)
			hallucinate = FALSE
			addtimer(VARSET_CALLBACK(src,hallucinate,TRUE),rand(4 SECONDS,10 SECONDS))

	if(duration > 19) // 4 ticks in smoke, neuro is affecting cereberal activity
		affected_mob.eye_blind = max(affected_mob.eye_blind, floor(strength/4))

	if(duration >= 27) // 5+ ticks in smoke, you are ODing now
		affected_mob.apply_effect(1, DAZE) // Unable to talk and weldervision
		affected_mob.apply_damage(2,TOX)
		affected_mob.SetEarDeafness(max(affected_mob.ear_deaf, floor(strength*1.5))) //Paralysis of hearing system, aka deafness

	if(duration >= 50) // 10+ ticks, apply some semi-perm damage and end their suffering if they are somehow still alive by now
		affected_mob.apply_internal_damage(10,"liver")
		affected_mob.apply_damage(150,OXY)
	// Applying additonal effects and messages
	if(prob(stumble_prob) && stumble)
		if(affected_mob.is_mob_incapacitated())
			return
		affected_mob.visible_message(SPAN_DANGER("[affected_mob] 迷迷糊糊地踏错了步子！")
						,SPAN_HIGHDANGER("你踉跄了一下！"))
		step(affected_mob, pick(CARDINAL_ALL_DIRS))
		affected_mob.apply_effect(5, DAZE) // Unable to talk and weldervision
		affected_mob.make_jittery(25)
		affected_mob.make_dizzy(55)
		affected_mob.emote("pain")
		stumble = FALSE
		addtimer(VARSET_CALLBACK(src,stumble,TRUE),3 SECONDS)
		duration++

	if(prob(bloodcough_prob))
		affected_mob.emote("cough")
		affected_mob.Slow(1)
		affected_mob.apply_damage(5,BRUTE, "chest")
		to_chat(affected_mob, SPAN_DANGER("你咳出了鲜血！"))

	if(chat_cd <= 0)
		to_chat(affected_mob,msg)
		chat_cd++
	else
		chat_cd--

	return TRUE

/datum/effects/neurotoxin/proc/process_hallucination(mob/living/carbon/human/victim)
	switch(rand(0, 100))
		if(0 to 5)
			playsound_client(victim?.client,pick('sound/voice/alien_pounce.ogg','sound/voice/alien_pounce.ogg'))
			victim.KnockDown(3)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,"alien_claw_flesh"), 1 SECONDS)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,"bonebreak"), 1 SECONDS)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,"alien_claw_flesh"), 1.5 SECONDS)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,"alien_claw_flesh"), 2 SECONDS)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,"bonebreak"), 2.5 SECONDS)
			victim.apply_effect(AGONY,10)
			victim.emote("pain")
		if(6 to 10)
			playsound_client(victim.client,'sound/effects/ob_alert.ogg')
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,'sound/weapons/gun_orbital_travel.ogg'), 2 SECONDS)
		if(11 to 16)
			playsound_client(victim.client,'sound/voice/alien_queen_screech.ogg')
			victim.KnockDown(1)
		if(17 to 24)
			hallucination_fakecas_sequence(victim) //Not gonna spam a billion timers for this one so outsourcing to a proc with sleeps is a better async solution
		if(25 to 42)
			to_chat(victim,SPAN_HIGHDANGER("炮弹即将落在[pick(SPAN_UNDERLINE("[pick("你的西侧","你的东侧","你的南侧","你的北侧")]"),SPAN_UNDERLINE("你的正上方"))]！"))
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,'sound/weapons/gun_mortar_travel.ogg'), 1 SECONDS)
		if(43 to 69)
			victim.emote(pick("twitch","drool","moan","giggle"))
			victim.hallucination = 3
			victim.druggy = 3
		if(70 to 100) // sound based hallucination
			playsound_client(client = victim.client, soundin = pick('sound/voice/alien_distantroar_3.ogg','sound/voice/xenos_roaring.ogg','sound/voice/alien_queen_breath1.ogg', 'sound/voice/4_xeno_roars.ogg','sound/misc/notice2.ogg',"bone_break","gun_pulse","metalbang","pry","shatter"),vol = 65)



/datum/effects/neurotoxin/proc/hallucination_fakecas_sequence(mob/living/carbon/human/victim)

	playsound_client(victim.client,'sound/weapons/dropship_sonic_boom.ogg')
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), victim,"运输艇正在向[pick(SPAN_UNDERLINE("[pick("你的西侧","你的东侧","你的南侧","你的北侧")]"),SPAN_UNDERLINE("你的正上方"))]开火！"), 3.5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,'sound/effects/rocketpod_fire.ogg'), 4 SECONDS)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,'sound/effects/gau.ogg'), 5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,'sound/effects/rocketpod_fire.ogg'), 5.5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,'sound/effects/gauimpact.ogg'), 5.5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,'sound/effects/gauimpact.ogg'), 5.5 SECONDS)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,"explosion"), 6.5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,'sound/effects/gauimpact.ogg'), 6.5 SECONDS)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,'sound/effects/rocketpod_fire.ogg'), 7.5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,'sound/effects/gauimpact.ogg'), 7.5 SECONDS)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,"explosion"), 8.5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,'sound/effects/gauimpact.ogg'), 8.5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,'sound/effects/gauimpact.ogg'), 8.5 SECONDS)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,"bigboom"), 9 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,'sound/effects/gauimpact.ogg'), 9 SECONDS)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,'sound/effects/rocketpod_fire.ogg'), 9.5 SECONDS)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,'sound/effects/gauimpact.ogg'), 10 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,"explosion"), 10 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,'sound/effects/gauimpact.ogg'), 10.5 SECONDS)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,"explosion"), 11 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client,'sound/effects/gauimpact.ogg'), 11 SECONDS)
	victim.emote("pain")
