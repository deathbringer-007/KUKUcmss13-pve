/*
 * Construction Node
 */

/obj/effect/alien/resin/construction
	name = "建造节点"
	desc = "一团奇怪的蠕动肉块，似乎在标记什么。"
	icon = 'icons/mob/xenos/weeds.dmi'
	icon_state = "constructionnode"
	density = FALSE
	anchored = TRUE
	health = 200
	block_range = 1

	var/datum/construction_template/xenomorph/template //What we're building
	var/datum/hive_status/linked_hive //Who gets what we build

/obj/effect/alien/resin/construction/Initialize(mapload, hive_ref)
	. = ..()
	linked_hive = hive_ref
	if (linked_hive?.color)
		color = linked_hive.color

/obj/effect/alien/resin/construction/Destroy()
	if(template && linked_hive && (template.plasma_stored < template.plasma_required))
		linked_hive.remove_construction(src)
	template = null
	linked_hive = null
	return ..()

/obj/effect/alien/resin/construction/update_icon()
	..()
	overlays.Cut()
	if(template)
		var/image/I = template.get_structure_image()
		I.alpha = 122
		I.pixel_x = template.pixel_x
		I.pixel_y = template.pixel_y
		overlays += I

/obj/effect/alien/resin/construction/get_examine_text(mob/user)
	. = ..()
	if((isxeno(user) || isobserver(user)) && linked_hive)
		var/message = "这里已规划建造[localized_player_label(template.name)]，还需要[template.plasma_required - template.plasma_stored]点等离子体。"
		. += message

/obj/effect/alien/resin/construction/attack_alien(mob/living/carbon/xenomorph/M)
	if(!linked_hive || (linked_hive && (M.hivenumber != linked_hive.hivenumber)) || (M.a_intent == INTENT_HARM && M.can_destroy_special()))
		return ..()
	if(!template)
		to_chat(M, SPAN_XENOWARNING("这里没有建造模板！"))
	else
		template.add_crystal(M) //This proc handles attack delay itself.
	return XENO_NO_DELAY_ACTION

/obj/effect/alien/resin/construction/proc/set_template(datum/construction_template/xenomorph/new_template)
	if(!istype(new_template) || !linked_hive)
		return
	template = new_template
	template.owner = src
	template.build_loc = get_turf(src)
	template.hive_ref = linked_hive
	template.on_template_creation()
	update_icon()
