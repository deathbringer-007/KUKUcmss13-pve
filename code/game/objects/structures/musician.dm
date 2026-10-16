//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/datum/song
	var/name = "无题"
	var/list/lines = new()
	var/tempo = 5

/obj/structure/device/broken_piano
	name = "损坏的古董钢琴"
	icon = 'icons/obj/structures/props/musician.dmi'
	desc = "真可惜。这架钢琴看来再也弹不响了。永远不会。问都别问。"
	icon_state = "pianobroken"
	anchored = TRUE
	density = TRUE
	unslashable = TRUE

/obj/structure/device/broken_moog
	name = "损坏的古董合成器"
	icon = 'icons/obj/structures/props/musician.dmi'
	desc = "这台太空穆格合成器是古董，可惜被砸烂了。看来有人不喜欢它新潮火热的曲调。"
	icon_state = "minimoogbroken"
	anchored = TRUE
	density = TRUE
	unslashable = TRUE
