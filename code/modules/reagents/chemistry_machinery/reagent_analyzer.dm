/obj/structure/machinery/reagent_analyzer
	name = "\improper XRF扫描仪"
	desc = "用高能辐射轰击样本，检测其发出的荧光X射线谱的光谱仪。利用样本的发射光谱，可识别其化学组成。"
	icon = 'icons/obj/structures/machinery/science_machines.dmi'
	icon_state = "reagent_analyzer"
	active_power_usage = 5000 //This is how many watts the big XRF machines usually take

	var/mob/last_used
	var/obj/item/reagent_container/sample = null //Object containing our sample
	var/sample_number = 1 //Just for printing fluff
	var/processing = FALSE
	var/status = 0

/obj/structure/machinery/reagent_analyzer/attackby(obj/item/B, mob/living/user)
	if(processing)
		to_chat(user, SPAN_WARNING("[src]还在处理！"))
		return
	if(!skillcheck(usr, SKILL_RESEARCH, SKILL_RESEARCH_TRAINED))
		to_chat(user, SPAN_WARNING("你完全不知道如何使用它。"))
		return
	if(istype(B, /obj/item/reagent_container/glass/beaker/vial))
		if(sample || status)
			to_chat(user, SPAN_WARNING("[src]里已经装有东西了。"))
			return
		if(user.drop_inv_item_to_loc(B, src))
			sample = B
			icon_state = "reagent_analyzer_sample"
			to_chat(user, SPAN_NOTICE("你放入[B]，开始配置[src]。"))
			updateUsrDialog()
			if(!do_after(user, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
				return
			if(!sample)
				to_chat(user, SPAN_WARNING("别人取走了样本。先商量好再来！"))
				return
			processing = TRUE
			if(sample.reagents.total_volume < 30 || length(sample.reagents.reagent_list) > 1)
				icon_state = "reagent_analyzer_error"
				reagent_process()
			else
				icon_state = "reagent_analyzer_processing"
				reagent_process()
			last_used = user
		return
	else
		to_chat(user, SPAN_WARNING("[src]只接收装在样品瓶中的样本。"))
		return

/obj/structure/machinery/reagent_analyzer/proc/reagent_process()
	status++
	if(status <= 3)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/structure/machinery/reagent_analyzer, reagent_process)), 2 SECONDS)
		return
	playsound(loc, 'sound/machines/fax.ogg', 15, 1)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/structure/machinery/reagent_analyzer, finish_reagent_process)), 4 SECONDS)

/obj/structure/machinery/reagent_analyzer/proc/finish_reagent_process()
	if(!sample || !sample.reagents || sample.reagents.total_volume < 30 || length(sample.reagents.reagent_list) > 1)
		if(!sample || !sample.reagents)
			print_report(0, "样本为空。")
		else if(sample.reagents.total_volume < 30)
			print_report(0, "样本量不足；<BR>\n<I>分析需要30单位样本。</I>")
		else if(length(sample.reagents.reagent_list) > 1)
			print_report(0, "样本受到污染；<BR>\n<I>分析需要纯净样本。</I>")
		else
			print_report(0, "未知。")
		icon_state = "reagent_analyzer_failed"
		playsound(loc, 'sound/machines/buzz-two.ogg', 15, 1)
	else
		icon_state = "reagent_analyzer_finished"
		print_report(1)
		playsound(loc, 'sound/machines/twobeep.ogg', 15, 1)
	sample_number++
	status = 0
	processing = FALSE

/obj/structure/machinery/reagent_analyzer/attack_hand(mob/user as mob)
	if(processing)
		to_chat(user, SPAN_WARNING("[src]还在处理！"))
		return
	if(!sample)
		to_chat(user, SPAN_WARNING("[src]是空的。"))
		return
	to_chat(user, SPAN_NOTICE("你从[src]中取出了[sample]。"))
	user.put_in_active_hand(sample)
	sample = null
	icon_state = "reagent_analyzer"
	return

/obj/structure/machinery/reagent_analyzer/proc/print_report(result, reason)
	var/obj/item/paper/research_report/report = new /obj/item/paper/research_report/(loc)
	if(result)
		var/datum/reagent/S = sample.reagents.reagent_list[1]
		S.print_report(report = report, sample_number = sample_number)
		sample.name = "样品瓶（[S.name]）"
		GLOB.chemical_data.save_document(report, "XRF Scans", "[sample_number] - [report.name]")
		if(S.chemclass < CHEM_CLASS_SPECIAL || (S.chemclass >= CHEM_CLASS_SPECIAL && report.completed))
			GLOB.chemical_data.save_new_properties(S.properties)
		if(S.chemclass >= CHEM_CLASS_SPECIAL && !GLOB.chemical_data.chemical_identified_list[S.id])
			if(last_used)
				last_used.count_niche_stat(STATISTICS_NICHE_CHEMS)
			var/datum/chem_property/P = S.get_property(PROPERTY_DNA_DISINTEGRATING)
			if(P)
				if(GLOB.chemical_data.clearance_level >= S.gen_tier)
					P.trigger()
				else
					return

			GLOB.chemical_data.complete_chemical(S)
	else
		var/datum/asset/asset = get_asset_datum(/datum/asset/simple/paper)
		report.name = "分析错误报告"
		report.info += "<center><img src = [asset.get_url_mappings()["wylogo.png"]]><HR><I><B>维兰德-汤谷官方文件</B><BR>试剂分析报告</I><HR><H2>分析错误</H2></center>"
		report.info += "<B>结果：</B><BR>#[sample_number]号样本分析失败。<BR><BR>\n"
		report.info += "<B>错误原因：</B><BR><I>[reason]</I><BR>\n"
	report.info += "<BR><HR><font size = \"1\"><I>本报告由A-XRF扫描仪自动打印。<BR>[MAIN_SHIP_NAME]，[time2text(world.timeofday, "MM/DD")]/[GLOB.game_year]，[worldtime2text()]</I></font><BR>\n<span class=\"paper_field\"></span>"

/datum/reagent/proc/print_report(turf/loc, obj/item/paper/research_report/report, admin_spawned = FALSE, sample_number = 0)
	if(!report)
		report = new /obj/item/paper/research_report(loc)

	report.name = "[name]分析报告"
	var/datum/asset/asset = get_asset_datum(/datum/asset/simple/paper)
	report.info += "<center><img src = [asset.get_url_mappings()["wylogo.png"]]><HR><I><B>维兰德-汤谷官方文件</B><BR>A-XRF自动分析报告</I><HR><H2>[name]分析报告</H2></center>"
	if(sample_number)
		report.info += "<B>样本分析结果：</B> #[sample_number]<BR>\n"
	report.generate(src, admin_spawned)
