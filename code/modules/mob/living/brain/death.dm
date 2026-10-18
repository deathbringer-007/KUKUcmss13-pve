/mob/living/brain/death(cause, gibbed)
	if(!gibbed && istype(container, /obj/item/device/mmi)) //If not gibbed but in a container.
		container.icon_state = "mmi_dead"
	return ..(cause, gibbed, "在MMI生命信号归零时发出尖锐的哔声！")

/mob/living/brain/gib(datum/cause_data/cause = create_cause_data("gibbing", src))
	if(istype(container, /obj/item/device/mmi))
		qdel(container)//Gets rid of the MMI if there is one
	if(loc)
		if(istype(loc,/obj/item/organ/brain))
			qdel(loc)//Gets rid of the brain item
	..(cause)
