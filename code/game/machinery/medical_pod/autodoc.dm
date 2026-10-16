//Autodoc
/obj/structure/machinery/medical_pod/autodoc
	name = "\improper 自动手术舱急救系统"
	desc = "一台只需少量人工干预即可执行手术的先进设备。界面相当复杂，本应只有受过训练的医生才能使用，好在还有显眼的“自动模式”开关和“开始”按钮，看上去足够简单。"
	icon_state = "autodoc_open"

	entry_timer = 2 SECONDS
	skilllock = SKILL_SURGERY_NOVICE

	var/list/surgery_todo_list = list() //a list of surgeries to do.
	var/surgery = 0 //Are we operating or no? 0 for no, 1 for yes
	var/surgery_mod = 1 //What multiple to increase the surgery timer? This is used for any non-WO maps or events that are done.
	var/obj/item/reagent_container/blood/OMinus/blood_pack = new()
	var/filtering = 0
	var/blood_transfer = 0
	var/heal_brute = 0
	var/heal_burn = 0
	var/heal_toxin = 0
	var/automatic_mode = null

	var/obj/structure/machinery/autodoc_console/connected

	//It uses power
	use_power = USE_POWER_IDLE
	idle_power_usage = 15
	active_power_usage = 450 //Capable of doing various activities

	var/stored_metal = 125 // starts with 125 metal loaded
	var/max_metal = 500

/obj/structure/machinery/medical_pod/autodoc/update_icon()
	if(occupant)
		if(surgery)
			icon_state = "autodoc_operate"
		else
			icon_state = "autodoc_closed"
	else
		icon_state = "autodoc_open"

/obj/structure/machinery/medical_pod/autodoc/get_examine_text(mob/user)
	. = ..()
	if(ishuman(user))
		. += SPAN_NOTICE("它储有 [stored_metal] 单位金属，可用于置换肢体。")

/obj/structure/machinery/medical_pod/autodoc/Initialize()
	. = ..()
	connect_autodoc_console()
	flags_atom |= USES_HEARING

// --- MEDICAL POD PROC OVERRIDES --- \\

/obj/structure/machinery/medical_pod/autodoc/go_in(mob/M)
	. = ..()
	start_processing()
	if(connected)
		connected.start_processing()

/obj/structure/machinery/medical_pod/autodoc/go_out()
	. = ..()
	surgery_todo_list = list()
	stop_processing()
	if(connected)
		connected.stop_processing()
		connected.process() // one last update

/obj/structure/machinery/medical_pod/autodoc/extra_eject_checks()
	if(usr == occupant)
		if(surgery)
			to_chat(usr, SPAN_WARNING("这东西正在给你做手术，你根本出不去！"))
			return FALSE
		else
			visible_message("[usr]启动内部解锁装置，从[src]里爬了出来。")
			return TRUE
	if(surgery)
		visible_message("[icon2html(src, viewers(src))] <b>[src]</b>因[usr]中止正在进行的手术而发生故障。")
		occupant.take_limb_damage(rand(30,50),rand(30,50))
		surgery = FALSE
		// message_admins for now, may change to message_admins later
		message_admins("[key_name(usr)] ejected [key_name(occupant)] from the autodoc during surgery causing damage.")
		return TRUE
	return TRUE


/obj/structure/machinery/medical_pod/autodoc/proc/connect_autodoc_console()
	if(connected)
		return
	if(dir == EAST || dir == SOUTH)
		connected = locate(/obj/structure/machinery/autodoc_console,get_step(src, EAST))
	if(dir == WEST || dir == NORTH)
		connected = locate(/obj/structure/machinery/autodoc_console,get_step(src, WEST))
	if(connected)
		connected.connected = src

/obj/structure/machinery/medical_pod/autodoc/Destroy()
	if(occupant)
		occupant.forceMove(loc)
		occupant = null
		stop_processing()
		if(connected)
			connected.stop_processing()
	if(connected)
		connected.connected = null
		QDEL_NULL(connected)
	. = ..()



/obj/structure/machinery/medical_pod/autodoc/power_change(area/master_area = null)
	..()
	if(stat & NOPOWER)
		visible_message("[src]启动紧急安全程序，将患者移出。")
		surgery = 0
		go_out()
		return

/obj/structure/machinery/medical_pod/autodoc/proc/heal_limb(mob/living/carbon/human/human, brute, burn)
	var/list/obj/limb/parts = human.get_damaged_limbs(brute,burn)
	if(!length(parts)) return
	var/obj/limb/picked = pick(parts)
	if(picked.status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
		picked.heal_damage(brute, burn, TRUE)
		human.pain.apply_pain(-brute, BRUTE)
		human.pain.apply_pain(-burn, BURN)
	else
		human.apply_damage(-brute, BRUTE, picked)
		human.apply_damage(-burn, BURN, picked)

	human.UpdateDamageIcon()
	human.updatehealth()

/obj/structure/machinery/medical_pod/autodoc/process()
	set background = 1

	updateUsrDialog()
	if(occupant)
		if(occupant.stat == DEAD)
			visible_message("[icon2html(src, viewers(src))] <b>[src]</b>播报：患者已死亡。")
			surgery = 0
			go_out()
			return
		if(surgery)
			// keep them alive
			occupant.apply_damage(-1 * REM, TOX) // pretend they get IV dylovene
			occupant.apply_damage(-occupant.getOxyLoss(), OXY) // keep them breathing, pretend they get IV dexplus
			if(filtering)
				var/filtered = 0
				for(var/datum/reagent/x in occupant.reagents.reagent_list)
					occupant.reagents.remove_reagent(x.id, 3) // same as sleeper, may need reducing
					filtered += 3
				if(!filtered)
					filtering = 0
					visible_message("[icon2html(src, viewers(src))] <b>[src]</b>播报：血液过滤完成。")
				else if(prob(10))
					visible_message("[icon2html(src, viewers(src))] <b>[src]</b>的透析模块运转着，发出嗡鸣和液体流动声。")
					to_chat(occupant, SPAN_INFO("你感觉稍微好了一些。"))
			if(blood_transfer)
				if(occupant.blood_volume < BLOOD_VOLUME_NORMAL)
					if(blood_pack.reagents.get_reagent_amount("blood") < 4)
						blood_pack.reagents.add_reagent("blood", 195, list("viruses"=null,"blood_type"="O-","resistances"=null))
						visible_message("[icon2html(src, viewers(src))] <b>[src]</b>播报：血液储备已耗尽，正在更换新容器。")
					occupant.inject_blood(blood_pack, 8) // double iv stand rate
					if(prob(10))
						visible_message("[src]一边输血，一边发出嗡鸣和液体流动声。")
						to_chat(occupant, SPAN_INFO("你的晕厥感稍微减轻了一些。"))
				else
					blood_transfer = 0
					visible_message("[icon2html(src, viewers(src))] <b>[src]</b>播报：输血完成。")
			if(heal_brute)
				if(occupant.getBruteLoss() > 0)
					heal_limb(occupant, 3, 0)
					if(prob(10))
						visible_message("[src]一边缝合伤口，一边发出嗡鸣和咔嗒声。")
						to_chat(occupant, SPAN_INFO("你感觉自己的伤口正在被缝合封闭。"))
				else
					heal_brute = 0
					visible_message("[icon2html(src, viewers(src))] <b>[src]</b>播报：创伤修复手术完成。")
			if(heal_burn)
				if(occupant.getFireLoss() > 0)
					heal_limb(occupant, 0, 3)
					if(prob(10))
						visible_message("[src]一边移植合成皮肤，一边发出嗡鸣和咔嗒声。")
						to_chat(occupant, SPAN_INFO("你感觉烧伤的皮肉正被切除并替换。"))
				else
					heal_burn = 0
					visible_message("[icon2html(src, viewers(src))] <b>[src]</b>播报：皮肤移植完成。")
			if(heal_toxin)
				if(occupant.getToxLoss() > 0)
					occupant.apply_damage(-3, TOX)
					if(prob(10))
						visible_message("[src]一边为患者进行螯合治疗，一边发出嗡鸣和液体流动声。")
						to_chat(occupant, SPAN_INFO("你的不适感稍微减轻了一些。"))
				else
					heal_toxin = 0
					visible_message("[icon2html(src, viewers(src))] <b>[src]</b>播报：毒素清除完成。")


#define LIMB_SURGERY 1
#define ORGAN_SURGERY 2
#define EXTERNAL_SURGERY 3

#define UNNEEDED_DELAY 100 // how long to waste if someone queues an unneeded surgery

/datum/autodoc_surgery
	var/obj/limb/limb_ref = null
	var/datum/internal_organ/organ_ref = null
	var/type_of_surgery = 0 // the above constants
	var/surgery_procedure = "" // text of surgery
	var/unneeded = 0

/proc/create_autodoc_surgery(limb_ref, type_of_surgery, surgery_procedure, unneeded=0, organ_ref=null)
	var/datum/autodoc_surgery/A = new()
	A.type_of_surgery = type_of_surgery
	A.surgery_procedure = surgery_procedure
	A.unneeded = unneeded
	A.limb_ref = limb_ref
	A.organ_ref = organ_ref
	return A

/obj/structure/machinery/medical_pod/autodoc/allow_drop()
	return 0

/proc/generate_autodoc_surgery_list(mob/living/carbon/human/M)
	if(!ishuman(M))
		return list()
	var/surgery_list = list()
	var/known_implants = list(/obj/item/implant/chem, /obj/item/implant/death_alarm, /obj/item/implant/loyalty, /obj/item/implant/tracking, /obj/item/implant/neurostim)

	for(var/obj/limb/L in M.limbs)
		if(L)
			for(var/datum/wound/W in L.wounds)
				if(W.internal)
					surgery_list += create_autodoc_surgery(L,LIMB_SURGERY,"internal")
					break

			var/organdamagesurgery = 0
			for(var/datum/internal_organ/I in L.internal_organs)
				if(I.robotic == ORGAN_ASSISTED||I.robotic == ORGAN_ROBOT)
					// we can't deal with these
					continue
				if(I.damage > 0)
					if(I.name == "eyeballs") // treat eye surgery differently
						continue
					if(organdamagesurgery > 0) continue // avoid duplicates
					surgery_list += create_autodoc_surgery(L,ORGAN_SURGERY,"damage",0,I)
					organdamagesurgery++

			if(istype(L,/obj/limb/chest))
				var/obj/limb/chest/C = L
				if(M.status_flags & XENO_HOST)
					surgery_list += create_autodoc_surgery(C,LIMB_SURGERY,"object")

			if(L.status & LIMB_BROKEN)
				surgery_list += create_autodoc_surgery(L,LIMB_SURGERY,"broken")
			if(L.status & LIMB_DESTROYED)
				if(!(L.parent.status & LIMB_DESTROYED) && L.name != "head")
					surgery_list += create_autodoc_surgery(L,LIMB_SURGERY,"missing")
			if(length(L.implants))
				for(var/I in L.implants)
					if(!is_type_in_list(I,known_implants))
						surgery_list += create_autodoc_surgery(L,LIMB_SURGERY,"object")
			if(M.incision_depths[L.name] != SURGERY_DEPTH_SURFACE)
				surgery_list += create_autodoc_surgery(L,LIMB_SURGERY,"open")
	var/datum/internal_organ/I = M.internal_organs_by_name["eyes"]
	if(I && (M.disabilities & NEARSIGHTED || M.sdisabilities & DISABILITY_BLIND || I.damage > 0))
		surgery_list += create_autodoc_surgery(null,ORGAN_SURGERY,"eyes",0,I)
	if(M.getBruteLoss() > 0)
		surgery_list += create_autodoc_surgery(null,EXTERNAL_SURGERY,"brute")
	if(M.getFireLoss() > 0)
		surgery_list += create_autodoc_surgery(null,EXTERNAL_SURGERY,"burn")
	if(M.getToxLoss() > 0)
		surgery_list += create_autodoc_surgery(null,EXTERNAL_SURGERY,"toxin")
	var/overdoses = 0
	for(var/datum/reagent/x in M.reagents.reagent_list)
		if(istype(x,/datum/reagent/toxin)||M.reagents.get_reagent_amount(x.id) > x.overdose)
			overdoses++
	if(overdoses)
		surgery_list += create_autodoc_surgery(null,EXTERNAL_SURGERY,"dialysis")
	if(M.blood_volume < BLOOD_VOLUME_NORMAL)
		surgery_list += create_autodoc_surgery(null,EXTERNAL_SURGERY,"blood")
	return surgery_list

/obj/structure/machinery/medical_pod/autodoc/proc/surgery_op(mob/living/carbon/M)
	set background = 1

	if(M.stat == DEAD||!ishuman(M))
		visible_message("[src]发出蜂鸣声。")
		src.go_out() //kick them out too.
		return

	var/mob/living/carbon/human/H = M
	var/datum/data/record/N = null
	var/human_ref = WEAKREF(H)
	for(var/datum/data/record/R as anything in GLOB.data_core.medical)
		if (R.fields["ref"] == human_ref)
			N = R
	if(isnull(N))
		visible_message("[src]发出蜂鸣声：未找到患者档案。")
		src.go_out() //kick them out too.
		return

	var/list/surgery_todo_list
	if(automatic_mode)
		surgery_todo_list = N.fields["autodoc_data"]
	else
		surgery_todo_list = N.fields["autodoc_manual"]

	if(!length(surgery_todo_list))
		visible_message("[src]发出蜂鸣声，手术队列为空。")
		return

	visible_message("[icon2html(src, viewers(src))] <b>[src]</b>开始运转，舱门伴随着响亮的咔嗒声锁上了。")
	surgery = 1
	update_icon()

	var/known_implants = list(/obj/item/implant/chem, /obj/item/implant/death_alarm, /obj/item/implant/loyalty, /obj/item/implant/tracking, /obj/item/implant/neurostim)

	for(var/datum/autodoc_surgery/A in surgery_todo_list)
		if(A.type_of_surgery == EXTERNAL_SURGERY)
			switch(A.surgery_procedure)
				if("brute")
					heal_brute = 1
				if("burn")
					heal_burn = 1
				if("toxin")
					heal_toxin = 1
				if("dialysis")
					filtering = 1
				if("blood")
					blood_transfer = 1
			surgery_todo_list -= A

	var/currentsurgery = 1
	while(length(surgery_todo_list) > 0)
		if(!surgery)
			break;
		sleep(-1)
		var/datum/autodoc_surgery/S = surgery_todo_list[currentsurgery]
		if(automatic_mode)
			surgery_mod = 2.5 // automatic mode takes longer
		else
			surgery_mod = 1 // might need tweaking

		switch(S.type_of_surgery)
			if(ORGAN_SURGERY)
				switch(S.surgery_procedure)
					if("damage")
						if(prob(30))
							visible_message("[icon2html(src, viewers(src))] <b>[src]</b>播报：开始修复器官。")
						if(S.unneeded)
							sleep(UNNEEDED_DELAY)
							visible_message("[icon2html(src, viewers(src))] <b>[src]</b>播报：判定无需执行此手术。")
							surgery_todo_list -= S
							continue
						open_incision(H,S.limb_ref)

						if(S.limb_ref.name != "groin")
							open_encased(H,S.limb_ref)

						if(!istype(S.organ_ref,/datum/internal_organ/brain))
							sleep(FIX_ORGAN_MAX_DURATION*surgery_mod)
						else
							if(S.organ_ref.damage > BONECHIPS_MAX_DAMAGE)
								sleep(FIXVEIN_MAX_DURATION*surgery_mod)
							sleep(REMOVE_OBJECT_MAX_DURATION*surgery_mod)
						if(!surgery) break
						if(istype(S.organ_ref,/datum/internal_organ))
							S.organ_ref.rejuvenate()
						else
							visible_message("[icon2html(src, viewers(src))] <b>[src]</b>播报：器官缺失。")

						// close them
						if(S.limb_ref.name != "groin") // TODO: fix brute damage before closing
							close_encased(H,S.limb_ref)
						close_incision(H,S.limb_ref)

					if("eyes")
						if(prob(30))
							visible_message("[icon2html(src, viewers(src))] <b>[src]</b>播报：开始眼部矫正手术。")
						if(S.unneeded)
							sleep(UNNEEDED_DELAY)
							visible_message("[icon2html(src, viewers(src))] <b>[src]</b>播报：判定无需执行此手术。")
							surgery_todo_list -= S
							continue
						if(istype(S.organ_ref,/datum/internal_organ/eyes))
							var/datum/internal_organ/eyes/E = S.organ_ref

							if(E.eye_surgery_stage == 0)
								sleep(SCALPEL_MAX_DURATION)
								if(!surgery) break
								E.eye_surgery_stage = 1
								H.disabilities |= NEARSIGHTED // code\#define\mobs.dm

							if(E.eye_surgery_stage == 1)
								sleep(RETRACTOR_MAX_DURATION)
								if(!surgery) break
								E.eye_surgery_stage = 2

							if(E.eye_surgery_stage == 2)
								sleep(HEMOSTAT_MAX_DURATION)
								if(!surgery) break
								E.eye_surgery_stage = 3

							if(E.eye_surgery_stage == 3)
								sleep(CAUTERY_MAX_DURATION)
								if(!surgery) break
								H.disabilities &= ~NEARSIGHTED
								H.sdisabilities &= ~DISABILITY_BLIND
								E.heal_damage(E.damage)
								E.eye_surgery_stage = 0
					if("larva")
						if(prob(30))
							visible_message("[icon2html(src, viewers(src))] <b>[src]</b>发出提示音：正在移除未知寄生物。")
						if(!locate(/obj/item/alien_embryo) in occupant)
							sleep(UNNEEDED_DELAY)
							visible_message("[icon2html(src, viewers(src))] <b>[src]</b>播报：判定无需执行此手术。")// >:)
							surgery_todo_list -= S
							continue
						sleep(SCALPEL_MAX_DURATION + HEMOSTAT_MAX_DURATION + REMOVE_OBJECT_MAX_DURATION)
						var/obj/item/alien_embryo/alien_larva = locate() in occupant
						var/mob/living/carbon/xenomorph/larva/living_xeno = locate() in occupant
						if(living_xeno)
							living_xeno.forceMove(get_turf(occupant)) //funny stealth larva bursts incoming
							qdel(alien_larva)
						else
							alien_larva.forceMove(get_turf(occupant))
							occupant.status_flags &= ~XENO_HOST


			if(LIMB_SURGERY)
				switch(S.surgery_procedure)
					if("internal")
						if(prob(30))
							visible_message("[icon2html(src, viewers(src))] <b>[src]</b>播报：开始内出血治疗手术。")
						if(S.unneeded)
							sleep(UNNEEDED_DELAY)
							visible_message("[icon2html(src, viewers(src))] <b>[src]</b>播报：判定无需执行此手术。")
							surgery_todo_list -= S
							continue
						open_incision(H,S.limb_ref)
						for(var/datum/wound/W in S.limb_ref.wounds)
							if(!surgery) break
							if(W.internal)
								sleep(FIXVEIN_MIN_DURATION-30)
								S.limb_ref.wounds -= W
								S.limb_ref.remove_all_bleeding(FALSE, TRUE)
								qdel(W)
						if(!surgery) break
						close_incision(H,S.limb_ref)

					if("broken")
						if(prob(30))
							visible_message("[icon2html(src, viewers(src))] <b>[src]</b>播报：开始骨折治疗手术。")
						if(S.unneeded)
							sleep(UNNEEDED_DELAY)
							visible_message("[icon2html(src, viewers(src))] <b>[src]</b>播报：判定无需执行此手术。")
							surgery_todo_list -= S
							continue
						open_incision(H,S.limb_ref)
						sleep(BONEGEL_REPAIR_MAX_DURATION*surgery_mod+20)
						if(S.limb_ref.brute_dam > 20)
							sleep(((S.limb_ref.brute_dam - 20)/2)*surgery_mod)
							if(!surgery) break
							S.limb_ref.heal_damage(S.limb_ref.brute_dam - 20)
						if(!surgery) break
						if(S.limb_ref.status & LIMB_SPLINTED_INDESTRUCTIBLE)
							new /obj/item/stack/medical/splint/nano(loc, 1)
						S.limb_ref.status &= ~(LIMB_SPLINTED|LIMB_SPLINTED_INDESTRUCTIBLE|LIMB_BROKEN)
						S.limb_ref.perma_injury = 0
						H.pain.recalculate_pain()
						close_incision(H,S.limb_ref)

					if("missing")
						if(prob(30))
							visible_message("[icon2html(src, viewers(src))] <b>[src]</b>播报：开始肢体置换。")
						if(S.unneeded)
							sleep(UNNEEDED_DELAY)
							visible_message("[icon2html(src, viewers(src))] <b>[src]</b>播报：判定无需执行此手术。")
							surgery_todo_list -= S
							continue

						sleep(SCALPEL_MAX_DURATION*surgery_mod)
						sleep(RETRACTOR_MAX_DURATION*surgery_mod)
						sleep(CAUTERY_MAX_DURATION*surgery_mod)

						if(stored_metal < LIMB_METAL_AMOUNT)
							visible_message("[icon2html(src, viewers(src))] <b>[src]</b>发出嘶哑的声音：金属储备已耗尽。")
							playsound(src.loc, 'sound/machines/buzz-two.ogg', 15, 1)
							surgery_todo_list -= S
							continue // next surgery

						stored_metal -= LIMB_METAL_AMOUNT

						if(S.limb_ref.parent.status & LIMB_DESTROYED) // there's nothing to attach to
							visible_message("[icon2html(src, viewers(src))] <b>[src]</b>发出嘶哑的声音：肢体接合失败。")
							playsound(src.loc, 'sound/machines/buzz-two.ogg', 15, 1)
							surgery_todo_list -= S
							continue

						if(!surgery) break
						S.limb_ref.setAmputatedTree()

						var/spillover = LIMB_PRINTING_TIME - (CAUTERY_MAX_DURATION+RETRACTOR_MAX_DURATION+SCALPEL_MAX_DURATION)
						if(spillover > 0)
							sleep(spillover*surgery_mod)

						sleep(IMPLANT_MAX_DURATION*surgery_mod)
						if(!surgery) break
						S.limb_ref.robotize()
						H.update_body()
						H.updatehealth()
						H.UpdateDamageIcon()

					if("object")
						if(prob(30)) visible_message("[icon2html(src, viewers(src))] <b>[src]</b>播报：开始移除异物。");
						if(S.unneeded)
							sleep(UNNEEDED_DELAY)
							visible_message("[icon2html(src, viewers(src))] <b>[src]</b>播报：判定无需执行此手术。");
							surgery_todo_list -= S
							continue

						open_incision(H,S.limb_ref)
						if(S.limb_ref.name == "chest" || S.limb_ref.name == "head")
							open_encased(H,S.limb_ref)
						if(length(S.limb_ref.implants))
							for(var/obj/item/I in S.limb_ref.implants)
								if(!surgery) break
								if(!is_type_in_list(I,known_implants))
									sleep(REMOVE_OBJECT_MAX_DURATION*surgery_mod)
									S.limb_ref.implants -= I
									H.embedded_items -= I
									qdel(I)
						var/obj/item/larva_ref = locate(/obj/item/alien_embryo) in H.contents
						if(S.limb_ref.name == "chest" && larva_ref)
							sleep(REMOVE_OBJECT_MAX_DURATION*surgery_mod)
							H.contents -= larva_ref
						qdel(larva_ref)
						if(S.limb_ref.name == "chest" || S.limb_ref.name == "head")
							close_encased(H,S.limb_ref)
						if(!surgery) break
						close_incision(H,S.limb_ref)

					if("open")
						if(prob(30)) visible_message("[icon2html(src, viewers(src))] <b>[src]</b>发出嘶哑的声音：正在闭合手术切口。");
						close_encased(H,S.limb_ref)
						close_incision(H,S.limb_ref)


		if(prob(30)) visible_message("[icon2html(src, viewers(src))] <b>[src]</b>播报：手术完成。");
		surgery_todo_list -= S
		continue

	while(heal_brute||heal_burn||heal_toxin||filtering||blood_transfer)
		if(!surgery) break
		sleep(20)
		if(prob(5)) visible_message("[icon2html(src, viewers(src))] <b>[src]</b>继续工作，发出蜂鸣声。");

	H.pain.recalculate_pain()
	visible_message("[icon2html(src, viewers(src))] <b>[src]</b>已完成指定操作，咔嗒一声打开了舱门。")
	surgery = 0
	go_out()


/obj/structure/machinery/medical_pod/autodoc/proc/open_incision(mob/living/carbon/human/target, obj/limb/L)
	if(target && L && target.incision_depths[L.name] == SURGERY_DEPTH_SURFACE)
		sleep(INCISION_MANAGER_MAX_DURATION*surgery_mod)
		if(!surgery)
			return
		L.createwound(CUT, 1)
		target.incision_depths[L.name] = SURGERY_DEPTH_SHALLOW //Can immediately proceed to other surgery steps
		target.updatehealth()

/obj/structure/machinery/medical_pod/autodoc/proc/close_incision(mob/living/carbon/human/target, obj/limb/L)
	if(target && L && target.incision_depths[L.name] == SURGERY_DEPTH_SHALLOW)
		sleep(CAUTERY_MAX_DURATION*surgery_mod)
		if(!surgery)
			return
		L.reset_limb_surgeries()
		L.remove_all_bleeding(TRUE)
		target.updatehealth()

/obj/structure/machinery/medical_pod/autodoc/proc/open_encased(mob/living/carbon/human/target, obj/limb/L)
	if(target && L && target.incision_depths[L.name] == SURGERY_DEPTH_SHALLOW)
		sleep((CIRCULAR_SAW_MAX_DURATION*surgery_mod) + (RETRACTOR_MAX_DURATION*surgery_mod))
		if(!surgery)
			return
		target.incision_depths[L.name] = SURGERY_DEPTH_DEEP

/obj/structure/machinery/medical_pod/autodoc/proc/close_encased(mob/living/carbon/human/target, obj/limb/L)
	if(target && L && target.incision_depths[L.name] == SURGERY_DEPTH_DEEP)
		sleep((RETRACTOR_MAX_DURATION*surgery_mod) + (BONEGEL_REPAIR_MAX_DURATION*surgery_mod))
		if(!surgery)
			return
		target.incision_depths[L.name] = SURGERY_DEPTH_SHALLOW

#ifdef OBJECTS_PROXY_SPEECH
// Transfers speech to occupant
/obj/structure/machinery/medical_pod/autodoc/hear_talk(mob/living/sourcemob, message, verb, language, italics)
	if(!QDELETED(occupant) && istype(occupant) && occupant.stat != DEAD)
		proxy_object_heard(src, sourcemob, occupant, message, verb, language, italics)
	else
		..(sourcemob, message, verb, language, italics)
#endif // ifdef OBJECTS_PROXY_SPEECH

/////////////////////////////////////////////////////////////

//Auto Doc console that links up to it.
/obj/structure/machinery/autodoc_console
	name = "\improper 自动手术舱医疗系统控制台"
	desc = "用于操作相邻自动手术舱的控制界面，需要接受培训才能正确使用。"
	icon = 'icons/obj/structures/machinery/cryogenics.dmi'
	icon_state = "sleeperconsole"
	var/obj/structure/machinery/medical_pod/autodoc/connected = null
	dir = SOUTH
	anchored = TRUE //About time someone fixed this.
	density = FALSE
	unslashable = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 40
	/// What kind of upgrade do we have in this console? used by research upgrades. 1 is IB. 2 is bone frac. 3 is organ damage. 4 is larva removal
	var/list/upgrades = list()

/obj/structure/machinery/autodoc_console/Initialize()
	. = ..()
	connect_autodoc()

/obj/structure/machinery/autodoc_console/proc/connect_autodoc()
	if(connected)
		return
	if(dir == EAST || dir == SOUTH)
		connected = locate(/obj/structure/machinery/medical_pod/autodoc,get_step(src, WEST))
	if(dir == WEST || dir == NORTH)
		connected = locate(/obj/structure/machinery/medical_pod/autodoc,get_step(src, EAST))
	if(connected)
		connected.connected = src


/obj/structure/machinery/autodoc_console/Destroy()
	if(connected)
		if(connected.occupant)
			connected.go_out()

		connected.connected = null
		qdel(connected)
		connected = null
	. = ..()


/obj/structure/machinery/autodoc_console/power_change(area/master_area = null)
	..()
	if(stat & NOPOWER)
		if(icon_state != "sleeperconsole-p")
			icon_state = "sleeperconsole-p"
		return
	if(icon_state != "sleeperconsole")
		icon_state = "sleeperconsole"

/obj/structure/machinery/autodoc_console/process()
	updateUsrDialog()

/obj/structure/machinery/autodoc_console/attackby(obj/item/with, mob/user)
	if(istype(with, /obj/item/research_upgrades/autodoc))
		var/obj/item/research_upgrades/autodoc/upgrd = with
		if(!upgrd.value)
			to_chat(user, SPAN_NOTICE("[upgrd]中没有数据！"))
			return
		for(var/iter in upgrades)
			if(iter == upgrd.value)
				to_chat(user, SPAN_NOTICE("[src]中已存在此数据！"))
				return
		if(!user.drop_inv_item_to_loc(with, src))
			return
		to_chat(user, SPAN_NOTICE("你将数据载体插入[src]，驱动器随即嗡嗡运转，开始读取数据。"))
		upgrades += upgrd.value

/obj/structure/machinery/autodoc_console/attack_hand(mob/living/user)
	if(..())
		return
	var/dat = ""
	if(!connected || (connected.inoperable()))
		dat += "此控制台未连接自动手术舱，或所连接的自动手术舱无法工作。"
		to_chat(user, "此控制台似乎已断电。")
	else
		var/mob/living/occupant = connected.occupant
		dat += "<B>总体状态：</B><BR>"
		if(occupant)
			var/t1
			switch(occupant.stat)
				if(0) t1 = "清醒"
				if(1) t1 = "<font color='blue'>昏迷</font>"
				if(2) t1 = "<font color='red'><b>死亡</b></font>"
			var/operating
			switch(connected.surgery)
				if(0) operating = "自动手术舱：待机"
				if(1) operating = "自动手术舱：手术中，请勿手动移出患者"
			var/damageOxy = occupant.getOxyLoss() > 50 ? "<b>[occupant.getOxyLoss()]</b>" : occupant.getOxyLoss()
			var/damageTox = occupant.getToxLoss() > 50 ? "<b>[occupant.getToxLoss()]</b>" : occupant.getToxLoss()
			var/damageFire = occupant.getFireLoss() > 50 ? "<b>[occupant.getFireLoss()]</b>" : occupant.getFireLoss()
			var/damageBrute = occupant.getBruteLoss() > 50 ? "<b>[occupant.getBruteLoss()]</b>" : occupant.getBruteLoss()
			dat += "姓名：[occupant.name]<br>"
			dat += "伤害：[SET_CLASS("[damageOxy]", INTERFACE_BLUE)] - [SET_CLASS("[damageTox]", INTERFACE_GREEN)] - [SET_CLASS("[damageFire]", INTERFACE_ORANGE)] - [SET_CLASS("[damageBrute]", INTERFACE_RED)]<br>"
			dat += "患者状态：[t1]。<br>"
			dat += "[operating]<br>"
			if(connected.automatic_mode)
				dat += "<hr><span class='notice'>自动模式</span> | <a href='byond://?src=\ref[src];automatictoggle=1'>手动模式</a>"
			else
				dat += "<hr><a href='byond://?src=\ref[src];automatictoggle=1'>自动模式</a> | <span class='notice'>手动模式</span>"
			dat += "<a href='byond://?src=\ref[src];ejectify=1'>移出患者</a>"
			dat += "<hr><b>手术队列：</b><br>"

			var/list/surgeryqueue = list()
			var/datum/data/record/N = null
			var/occupant_ref = WEAKREF(connected.occupant)
			for(var/datum/data/record/R as anything in GLOB.data_core.medical)
				if (R.fields["ref"] == occupant_ref)
					N = R
			if(isnull(N))
				N = create_medical_record(connected.occupant)
			N.fields["autodoc_data"] = generate_autodoc_surgery_list(connected.occupant)
			var/list/autosurgeries = N.fields["autodoc_data"]
			if(connected.automatic_mode)
				if(autosurgeries.len)
					dat += "<span class='danger'>自动模式已就绪。</span><br>"
				else
					dat += "<span class='danger'>自动模式不可用。</span><br>"
			else
				if(!isnull(N.fields["autodoc_manual"]))
					for(var/datum/autodoc_surgery/A in N.fields["autodoc_manual"])
						switch(A.type_of_surgery)
							if(EXTERNAL_SURGERY)
								switch(A.surgery_procedure)
									if("brute")
										surgeryqueue["brute"] = 1
										dat += "物理损伤治疗"
									if("burn")
										surgeryqueue["burn"] = 1
										dat += "烧伤治疗"
									if("toxin")
										surgeryqueue["toxin"] = 1
										dat += "血液毒素清除"
									if("dialysis")
										surgeryqueue["dialysis"] = 1
										dat += "透析"
									if("blood")
										surgeryqueue["blood"] = 1
										dat += "紧急输血"
							if(ORGAN_SURGERY)
								switch(A.surgery_procedure)
									if("damage")
										surgeryqueue["organdamage"] = 1
										dat += "器官损伤治疗"
									if("eyes")
										surgeryqueue["eyes"] = 1
										dat += "眼部矫正手术"
									if("larva")
										surgeryqueue["larva"] = 1
										dat += "实验性寄生物移除手术"
							if(LIMB_SURGERY)
								switch(A.surgery_procedure)
									if("internal")
										surgeryqueue["internal"] = 1
										dat += "内出血治疗手术"
									if("broken")
										surgeryqueue["broken"] = 1
										dat += "骨骼修复治疗"
									if("missing")
										surgeryqueue["missing"] = 1
										dat += "肢体置换手术"
									if("object")
										surgeryqueue["object"] = 1
										dat += "异物移除手术"
									if("open")
										surgeryqueue["open"] = 1
										dat += "闭合开放切口"

					dat += "<br>"

			dat += "<hr><a href='byond://?src=\ref[src];surgery=1'>开始手术</a> - <a href='byond://?src=\ref[src];refresh=1'>刷新菜单</a> - <a href='byond://?src=\ref[src];clear=1'>清空队列</a><hr>"
			if(!connected.surgery && skillcheck(user, SKILL_SURGERY, connected.skilllock))
				dat += "<b>创伤手术</b>"
				dat += "<br>"
				if(isnull(surgeryqueue["brute"]))
					dat += "<a href='byond://?src=\ref[src];brute=1'>物理损伤治疗</a><br>"
				if(isnull(surgeryqueue["burn"]))
					dat += "<a href='byond://?src=\ref[src];burn=1'>烧伤治疗</a><br>"
				dat += "<b>骨科手术</b>"
				dat += "<br>"
				if(isnull(surgeryqueue["broken"]))
					dat += "<a href='byond://?src=\ref[src];broken=1'>骨折治疗手术</a><br>"
				if(isnull(surgeryqueue["internal"]))
					dat += "<a href='byond://?src=\ref[src];internal=1'>内出血治疗手术</a><br>"
				if(isnull(surgeryqueue["open"]))
					dat += "<a href='byond://?src=\ref[src];open=1'>闭合开放切口</a><br>"
				if(isnull(surgeryqueue["object"]))
					dat += "<a href='byond://?src=\ref[src];object=1'>异物移除手术</a><br>"
				dat += "<b>器官手术</b>"
				dat += "<br>"
				if(isnull(surgeryqueue["eyes"]))
					dat += "<a href='byond://?src=\ref[src];eyes=1'>眼部矫正手术</a><br>"
				if(isnull(surgeryqueue["organdamage"]))
					dat += "<a href='byond://?src=\ref[src];organdamage=1'>器官损伤治疗</a><br>"
				dat += "<b>血液治疗</b>"
				dat += "<br>"
				if(isnull(surgeryqueue["blood"]))
					dat += "<a href='byond://?src=\ref[src];blood=1'>紧急输血</a><br>"
				if(isnull(surgeryqueue["dialysis"]))
					dat += "<a href='byond://?src=\ref[src];dialysis=1'>透析</a><br>"
				if(isnull(surgeryqueue["toxin"]))
					dat += "<a href='byond://?src=\ref[src];toxin=1'>血液毒素清除</a><br>"
				dat += "<br>"
				if(isnull(surgeryqueue["missing"]))
					dat += "<a href='byond://?src=\ref[src];missing=1'>肢体置换手术</a><hr>"
		else
			dat += "自动手术舱内没有患者。"
	dat += text("<a href='byond://?src=\ref[];mach_close=sleeper'>关闭</a>", user)
	show_browser(user, dat, "自动手术舱医疗系统", "sleeper", width = 300, height = 400)
	onclose(user, "sleeper")

/obj/structure/machinery/autodoc_console/Topic(href, href_list)
	if(..())
		return
	if((usr.contents.Find(src) || ((get_dist(src, usr) <= 1) && istype(src.loc, /turf))))
		usr.set_interaction(src)

		if(connected.occupant && ishuman(connected.occupant))
			// manual surgery handling
			var/datum/data/record/N = null
			var/occupant_ref = WEAKREF(connected.occupant)
			for(var/datum/data/record/R as anything in GLOB.data_core.medical)
				if (R.fields["ref"] == occupant_ref)
					N = R
			if(isnull(N))
				N = create_medical_record(connected.occupant)

			var/needed = 0 // this is to stop someone just choosing everything
			if(href_list["brute"])
				N.fields["autodoc_manual"] += create_autodoc_surgery(null,EXTERNAL_SURGERY,"brute")
				updateUsrDialog()
			if(href_list["burn"])
				N.fields["autodoc_manual"] += create_autodoc_surgery(null,EXTERNAL_SURGERY,"burn")
				updateUsrDialog()
			if(href_list["toxin"])
				N.fields["autodoc_manual"] += create_autodoc_surgery(null,EXTERNAL_SURGERY,"toxin")
				updateUsrDialog()
			if(href_list["dialysis"])
				N.fields["autodoc_manual"] += create_autodoc_surgery(null,EXTERNAL_SURGERY,"dialysis")
				updateUsrDialog()
			if(href_list["blood"])
				N.fields["autodoc_manual"] += create_autodoc_surgery(null,EXTERNAL_SURGERY,"blood")
				updateUsrDialog()
			if(href_list["eyes"])
				N.fields["autodoc_manual"] += create_autodoc_surgery(null,ORGAN_SURGERY,"eyes",0,connected.occupant.internal_organs_by_name["eyes"])
				updateUsrDialog()
			if(href_list["organdamage"])
				for(var/obj/limb/L in connected.occupant.limbs)
					if(L)
						for(var/datum/internal_organ/I in L.internal_organs)
							if(I.robotic == ORGAN_ASSISTED||I.robotic == ORGAN_ROBOT)
								// we can't deal with these
								continue
							if(I.damage > 0)
								N.fields["autodoc_manual"] += create_autodoc_surgery(L,ORGAN_SURGERY,"damage",0,I)
								needed++
				if(!needed)
					N.fields["autodoc_manual"] += create_autodoc_surgery(null,ORGAN_SURGERY,"damage",1)
				updateUsrDialog()
			if(href_list["larva"])
				N.fields["autodoc_manual"] += create_autodoc_surgery("chest",ORGAN_SURGERY,"larva",0)
				updateUsrDialog()
			if(href_list["internal"])
				for(var/obj/limb/L in connected.occupant.limbs)
					if(L)
						for(var/datum/wound/W in L.wounds)
							if(W.internal)
								N.fields["autodoc_manual"] += create_autodoc_surgery(L,LIMB_SURGERY,"internal")
								needed++
								break
				if(!needed)
					N.fields["autodoc_manual"] += create_autodoc_surgery(null,LIMB_SURGERY,"internal",1)
				updateUsrDialog()

			if(href_list["broken"])
				for(var/obj/limb/L in connected.occupant.limbs)
					if(L)
						if(L.status & LIMB_BROKEN)
							N.fields["autodoc_manual"] += create_autodoc_surgery(L,LIMB_SURGERY,"broken")
							needed++
				if(!needed)
					N.fields["autodoc_manual"] += create_autodoc_surgery(null,LIMB_SURGERY,"broken",1)
				updateUsrDialog()

			if(href_list["missing"])
				for(var/obj/limb/L in connected.occupant.limbs)
					if(L)
						if(L.status & LIMB_DESTROYED)
							if(!(L.parent.status & LIMB_DESTROYED) && L.name != "head")
								N.fields["autodoc_manual"] += create_autodoc_surgery(L,LIMB_SURGERY,"missing")
								needed++
				if(!needed)
					N.fields["autodoc_manual"] += create_autodoc_surgery(null,LIMB_SURGERY,"missing",1)
				updateUsrDialog()

			if(href_list["object"])
				var/known_implants = list(/obj/item/implant/chem, /obj/item/implant/death_alarm, /obj/item/implant/loyalty, /obj/item/implant/tracking, /obj/item/implant/neurostim)
				for(var/obj/limb/L in connected.occupant.limbs)
					if(L)
						if(istype(L,/obj/limb/chest))
							var/obj/limb/chest/C = L
							if(connected.occupant.status_flags & XENO_HOST)
								N.fields["autodoc_manual"] += create_autodoc_surgery(C,LIMB_SURGERY,"object")
								needed++
								continue
						if(length(L.implants))
							for(var/I in L.implants)
								if(!is_type_in_list(I,known_implants))
									N.fields["autodoc_manual"] += create_autodoc_surgery(L,LIMB_SURGERY,"object")
									needed++
				if(!needed)
					N.fields["autodoc_manual"] += create_autodoc_surgery(null,LIMB_SURGERY,"object",1)
				updateUsrDialog()

			if(href_list["open"])
				for(var/obj/limb/L in connected.occupant.limbs)
					if(L)
						if(connected.occupant.incision_depths[L.name] != SURGERY_DEPTH_SURFACE)
							N.fields["autodoc_manual"] += create_autodoc_surgery(L,LIMB_SURGERY,"open")
							needed++
				if(href_list["open"])
					N.fields["autodoc_manual"] += create_autodoc_surgery(null,LIMB_SURGERY,"open",1)
				updateUsrDialog()

			// The rest
			if(href_list["clear"])
				N.fields["autodoc_manual"] = list()
				updateUsrDialog()
			if(href_list["automatictoggle"])
				connected.automatic_mode = !connected.automatic_mode
				updateUsrDialog()
		if(href_list["refresh"])
			updateUsrDialog()
		if(href_list["surgery"])
			if(connected.occupant)
				connected.surgery_op(src.connected.occupant)
			updateUsrDialog()
		if(href_list["ejectify"])
			connected.eject()
			updateUsrDialog()
		add_fingerprint(usr)

/obj/structure/machinery/medical_pod/autodoc/unskilled
	name = "高级自动手术舱急救系统"
	desc = "一种加装 AI 诊断单元的自动手术舱型号，价格昂贵得多。它采用更简单的点击式操作界面，无需培训即可使用。常部署在军事前线，供士兵自行使用。"
	skilllock = null
