/obj/structure/bed/sofa
	name = "沙发"
	desc = "完全符合太空宜家的理念。"
	icon = 'icons/obj/structures/props/sofas.dmi'
	icon_state = "sofa" //use child icons
	anchored = TRUE //can't rotate sofas
	can_buckle = FALSE //Icons aren't setup for this to look right, so just disable it for now. Maybe when we fix the icons y'know?

//South facing couches. To-do, replicate NicBoone icons and make north facing icons. Non-double vertical couches.

/obj/structure/bed/sofa/pews
	name = "教堂长椅"
	desc = "闻起来有股雪松木的味道。"
	icon_state = "pews"

/obj/structure/bed/sofa/pews/flipped
	icon_state = "pews_f"
/obj/structure/bed/sofa/south/grey //center
	name = "长沙发"
	icon_state = "couch_hori2"

/obj/structure/bed/sofa/south/grey/left //left
	name = "长沙发端座"
	icon_state = "couch_hori1"

/obj/structure/bed/sofa/south/grey/right //right
	name = "长沙发端座"
	icon_state = "couch_hori3"

/obj/structure/bed/sofa/south/white //center
	name = "长沙发"
	icon_state = "bench_hor2"

/obj/structure/bed/sofa/south/white/left //left
	name = "长沙发端座"
	icon_state = "bench_hor1"

/obj/structure/bed/sofa/south/white/right //right
	name = "长沙发端座"
	icon_state = "bench_hor3"

//Vertical double sided couches. Think airport lounge.

/obj/structure/bed/sofa/vert/grey //center
	name = "长沙发"
	icon_state = "couch_vet2"

/obj/structure/bed/sofa/vert/grey/bot //bottom
	name = "长沙发端座"
	icon_state = "couch_vet1"

/obj/structure/bed/sofa/vert/grey/top //top
	name = "长沙发端座"
	icon_state = "couch_vet3"

/obj/structure/bed/sofa/vert/white //center
	name = "长沙发"
	icon_state = "bench_vet2"

/obj/structure/bed/sofa/vert/white/bot //bottom
	name = "长沙发端座"
	icon_state = "bench_vet1"

/obj/structure/bed/sofa/vert/white/top //top
	name = "长沙发端座"
	icon_state = "bench_vet3"
