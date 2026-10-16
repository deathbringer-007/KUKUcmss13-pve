//Special Strata (Carp Lake) Weedable Jungle/Grass turfs.//

/turf/open/gm/grass/weedable/ //inherit from general turfs

/turf/open/gm/grass/weedable/is_weedable()
	return FULLY_WEEDABLE

//just in case

/turf/open/gm/grass/grass1/weedable //inherit from general turfs

/turf/open/gm/grass/grass1/weedable/is_weedable()
	return FULLY_WEEDABLE

/turf/open/gm/dirtgrassborder/weedable

/turf/open/gm/dirtgrassborder/weedable/is_weedable() //Gotta have our sexy grass borders be weedable.
	return FULLY_WEEDABLE

/turf/open/gm/dirtgrassborder/weedable/grass1
	icon_state = "grass1"

/turf/closed/gm/dense/weedable

/turf/closed/gm/dense/weedable/is_weedable() //Weed-able jungle walls. Notably crushers can slam through this, so that might cause overlay issues. 3 months later, yeah it causes overlay issues, so return FALSE!
	return NOT_WEEDABLE

/turf/open/floor/strata //Instance me!
	icon = 'icons/turf/floors/strata_floor.dmi'
	icon_state = "floor"

/turf/open/floor/strata/grey_multi_tiles
	color = "#5e5d5d"
	icon_state = "multi_tiles"

/turf/open/floor/strata/grey_multi_tiles/southwest
	dir = SOUTHWEST

/turf/open/floor/strata/faux_wood
	desc = "仿木地板，通过了耐火认证。因为所谓的“消防安全”，只好勉强用它代替实木。谁知道那是什么意思。"
	icon = 'icons/turf/floors/floors.dmi'
	icon_state = "wood"

/turf/open/floor/strata/faux_metal
	desc = "这块金属地板被涂装成了木地板的样子。可惜木材不适合高压室内环境。木头可是严重的火灾隐患，你知道吧。"
	icon = 'icons/turf/floors/floors.dmi'
	icon_state = "wood"

/turf/open/floor/strata/multi_tiles
	icon_state = "multi_tiles"

/turf/open/floor/strata/multi_tiles/southwest
	dir = SOUTHWEST

/turf/open/floor/strata/white_cyan3
	icon_state = "white_cyan3"

/turf/open/floor/strata/white_cyan3/southwest
	dir = SOUTHWEST

/turf/open/floor/strata/blue4
	icon_state = "blue4"

/turf/open/floor/strata/blue4/north
	dir = NORTH

/turf/open/floor/strata/red3
	icon_state = "red3"

/turf/open/floor/strata/red3/north
	dir = NORTH

/turf/open/floor/strata/white_cyan3/north
	dir = NORTH

/turf/open/floor/strata/white_cyan4
	icon_state = "white_cyan4"

/turf/open/floor/strata/white_cyan4/north
	dir = NORTH

/turf/open/floor/strata/red3/south
	dir = SOUTH

/turf/open/floor/strata/white_cyan3/south
	dir = SOUTH

/turf/open/floor/strata/white_cyan4/south
	dir = SOUTH

/turf/open/floor/strata/blue3
	icon_state = "blue3"

/turf/open/floor/strata/blue3/east
	dir = EAST

/turf/open/floor/strata/cyan1
	icon_state = "cyan1"

/turf/open/floor/strata/cyan1/east
	dir = EAST

/turf/open/floor/strata/cyan2
	icon_state = "cyan2"

/turf/open/floor/strata/cyan2/east
	dir = EAST

/turf/open/floor/strata/cyan3
	icon_state = "cyan3"

/turf/open/floor/strata/cyan3/east
	dir = EAST

/turf/open/floor/strata/cyan4
	icon_state = "cyan4"

/turf/open/floor/strata/cyan4/east
	dir = EAST

/turf/open/floor/strata/floor3
	icon_state = "floor3"

/turf/open/floor/strata/floor3/east
	dir = EAST

/turf/open/floor/strata/orange_edge
	icon_state = "orange_edge"

/turf/open/floor/strata/orange_edge/east
	dir = EAST

/turf/open/floor/strata/red3/east
	dir = EAST

/turf/open/floor/strata/white_cyan1
	icon_state = "white_cyan1"

/turf/open/floor/strata/white_cyan1/east
	dir = EAST

/turf/open/floor/strata/white_cyan3/east
	dir = EAST

/turf/open/floor/strata/white_cyan4/east
	dir = EAST

/turf/open/floor/strata/white_cyan3/northeast
	dir = NORTHEAST

/turf/open/floor/strata/multi_tiles/southeast
	dir = SOUTHEAST

/turf/open/floor/strata/white_cyan3/southeast
	dir = SOUTHEAST

/turf/open/floor/strata/blue3/west
	dir = WEST

/turf/open/floor/strata/cyan3/west
	dir = WEST

/turf/open/floor/strata/multi_tiles/west
	dir = WEST

/turf/open/floor/strata/orange_edge/west
	dir = WEST

/turf/open/floor/strata/red3/west
	dir = WEST

/turf/open/floor/strata/white_cyan2
	icon_state = "white_cyan2"

/turf/open/floor/strata/white_cyan2/west
	dir = WEST

/turf/open/floor/strata/white_cyan3/west
	dir = WEST

/turf/open/floor/strata/white_cyan4/west
	dir = WEST

/turf/open/floor/strata/white_cyan3/northwest
	dir = NORTHWEST

/turf/open/floor/strata/blue1
	icon_state = "blue1"

/turf/open/floor/strata/blue3/north
	dir = NORTH

/turf/open/floor/strata/damaged3
	icon_state = "damaged3"

/turf/open/floor/strata/fake_wood
	icon_state = "fake_wood"

/turf/open/floor/strata/floor2
	icon_state = "floor2"

/turf/open/floor/strata/floorscorched1
	icon_state = "floorscorched1"

/turf/open/floor/strata/floorscorched2
	icon_state = "floorscorched2"

/turf/open/floor/strata/green1
	icon_state = "green1"

/turf/open/floor/strata/green3
	icon_state = "green3"

/turf/open/floor/strata/green3/north
	dir = NORTH

/turf/open/floor/strata/green3/east
	dir = EAST

/turf/open/floor/strata/green3/northeast
	dir = NORTHEAST

/turf/open/floor/strata/green3/west
	dir = WEST

/turf/open/floor/strata/green3/northwest
	dir = NORTHWEST

/turf/open/floor/strata/green4
	icon_state = "green4"

/turf/open/floor/strata/green4/north
	dir = NORTH

/turf/open/floor/strata/green4/east
	dir = EAST

/turf/open/floor/strata/green4/west
	dir = WEST

/turf/open/floor/strata/orange_cover
	icon_state = "orange_cover"

/turf/open/floor/strata/orange_icorner
	icon_state = "orange_icorner"

/turf/open/floor/strata/orange_icorner/north
	dir = NORTH

/turf/open/floor/strata/orange_icorner/west
	dir = WEST

/turf/open/floor/strata/orange_tile
	icon_state = "orange_tile"

/turf/open/floor/strata/purp1
	icon_state = "purp1"

/turf/open/floor/strata/purp2
	icon_state = "purp2"

/turf/open/floor/strata/purp3
	icon_state = "purp3"

/turf/open/floor/strata/purp3/east
	dir = EAST

/turf/open/floor/strata/red1
	icon_state = "red1"

/turf/open/floor/strata/red2
	icon_state = "red2"

/turf/open/floor/strata/red4
	icon_state = "red4"

/turf/open/floor/strata/red4/north
	dir = NORTH

/turf/open/floor/strata/red4/east
	dir = EAST

/turf/open/floor/strata/red4/west
	dir = WEST
