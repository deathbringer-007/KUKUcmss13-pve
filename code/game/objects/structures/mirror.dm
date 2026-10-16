
/obj/structure/mirror
	name = "镜子"
	desc = "魔镜魔镜告诉我，谁才是最能打的那一个？"
	icon = 'icons/obj/structures/props/watercloset.dmi'
	icon_state = "mirror"
	density = FALSE
	anchored = TRUE
	var/shattered = 0

/obj/structure/mirror/attack_hand(mob/user as mob)

	if(shattered) return

	if(ishuman(user))
		var/mob/living/carbon/human/H = user

		if(H.a_intent == INTENT_HARM)
			var/obj/limb/hand_target = H.get_limb(H.hand ? "l_hand" : "r_hand")
			if(shattered)
				playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 25, 1)
				user.visible_message(SPAN_DANGER("[user]一拳打向[src]，但镜子早已破碎！"), SPAN_DANGER("你一拳打向[src]，但镜子早已破碎！"))
				hand_target.take_damage(5)
				return
			if(prob(30) || H.species.can_shred(H))
				user.visible_message(SPAN_DANGER("[user]一拳打碎了[src]！"), SPAN_DANGER("你一拳打碎了[src]！"))
				shatter(user)
			else
				user.visible_message(SPAN_DANGER("[user]一拳打向[src]，拳头却被弹了回来！"), SPAN_DANGER("你一拳打向[src]，拳头却被弹了回来！"))
				hand_target.take_damage(5)
				playsound(loc, 'sound/effects/glassbash.ogg', 25, 1)
			return

		var/userloc = H.loc

		//see code/modules/mob/new_player/preferences.dm at approx line 545 for comments!
		//this is largely copypasted from there.

		//handle facial hair (if necessary)
		if(H.gender == MALE)
			var/list/species_facial_hair = list()
			if(H.species)
				for(var/i in GLOB.facial_hair_styles_list)
					var/datum/sprite_accessory/facial_hair/tmp_facial = GLOB.facial_hair_styles_list[i]
					if(H.species.name in tmp_facial.species_allowed)
						if(tmp_facial.selectable)
							species_facial_hair += i
			else
				species_facial_hair = GLOB.facial_hair_styles_list

			var/new_style = input(user, "选择胡须样式", "仪容整理")  as null|anything in species_facial_hair
			if(userloc != H.loc) return //no tele-grooming
			if(new_style)
				H.f_style = new_style

		//handle normal hair
		var/list/species_hair = list()
		if(H.species)
			for(var/i in GLOB.hair_styles_list)
				var/datum/sprite_accessory/hair/tmp_hair = GLOB.hair_styles_list[i]
				if(H.species.name in tmp_hair.species_allowed)
					if(tmp_hair.selectable)
						species_hair += i
		else
			species_hair = GLOB.hair_styles_list

		var/new_style = input(user, "选择发型", "仪容整理")  as null|anything in species_hair
		if(userloc != H.loc) return //no tele-grooming
		if(new_style)
			H.h_style = new_style

		H.update_hair()


/obj/structure/mirror/proc/shatter(mob/living/carbon/human/user, grabbed = FALSE)
	shattered = TRUE
	icon_state = "mirror_broke"
	playsound(src, "shatter", 70, 1)
	desc = "糟糕，要倒霉七年了！"
	var/obj/item/shard/mirror_shard = new(loc)
	if(!user)
		return
	var/obj/limb/shard_target
	if(grabbed)
		shard_target = user.get_limb("head")
	else
		shard_target = user.get_limb(user.hand ? "l_hand" : "r_hand")
	shard_target.embed(mirror_shard)
	shard_target.take_damage(15)


/obj/structure/mirror/bullet_act(obj/projectile/Proj)
	if(prob(Proj.damage * 2))
		if(!shattered)
			shatter()
		else
			playsound(src, 'sound/effects/hit_on_shattered_glass.ogg', 25, 1)
	..()
	return 1


/obj/structure/mirror/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/grab))
		if(user.grab_level < GRAB_AGGRESSIVE)
			to_chat(user, SPAN_WARNING("你需要抓得更牢才能这样做！"))
			return
		var/obj/item/grab/target_grab = I
		var/mob/living/carbon/human/target = target_grab.grabbed_thing
		var/obj/limb/head_target = target.get_limb("head")
		if(shattered)
			user.visible_message(SPAN_WARNING("[user]抓着[target]的头撞向[src]，但[src]早已破碎！"), SPAN_WARNING("你抓着[target]的头撞向[src]，但[src]早已破碎！"))
			head_target.take_damage(5)
			playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 25, 1)
			return
		if(prob(30))
			user.visible_message(SPAN_WARNING("[user]抓着[target]的头猛撞[src]，将[src]撞碎！"), SPAN_WARNING("你用[target]的头撞碎了[src]，[src]碎裂开来！"))
			shatter(target, TRUE)
			return
		user.visible_message(SPAN_WARNING("[user]抓着[target]的头撞向[src]！"), SPAN_WARNING("你抓着[target]的头撞向[src]！"))
		head_target.take_damage(5)
		playsound(loc, 'sound/effects/Glasshit.ogg', 25, 1)
		return
	if(shattered)
		playsound(loc, 'sound/effects/hit_on_shattered_glass.ogg', 25, 1)
		user.visible_message(SPAN_WARNING("[user]用[I]击打[src]，但镜子早已破碎！"), SPAN_WARNING("你用[I]击打[src]，但镜子早已破碎！"))
		return
	if(prob(I.force * I.demolition_mod * 2))
		user.visible_message(SPAN_WARNING("[user]用[I]砸碎了[src]！"), SPAN_WARNING("你用[I]砸碎了[src]！"))
		shatter()
	else
		user.visible_message(SPAN_WARNING("[user]用[I]击打[src]！"), SPAN_WARNING("你用[I]击打[src]！"))
		playsound(src.loc, 'sound/effects/Glasshit.ogg', 25, 1)

/obj/structure/mirror/attack_animal(mob/user as mob)
	if(!isanimal(user)) return
	var/mob/living/simple_animal/M = user
	if(M.melee_damage_upper <= 0) return
	if(shattered)
		playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 25, 1)
		return
	user.visible_message(SPAN_DANGER("[user]砸碎了[src]！"))
	shatter()
