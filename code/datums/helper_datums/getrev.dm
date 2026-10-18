GLOBAL_DATUM_INIT(revdata, /datum/getrev, new)

/datum/getrev
	var/commit  // git rev-parse HEAD
	var/date
	var/originmastercommit  // git rev-parse origin/master
	var/list/testmerge = list()

/datum/getrev/New()
	commit = rustg_git_revparse("HEAD")
	if(commit)
		date = rustg_git_commit_date(commit)
	originmastercommit = rustg_git_revparse("origin/master")

/datum/getrev/proc/load_tgs_info()
	testmerge = world.TgsTestMerges()
	var/datum/tgs_revision_information/revinfo = world.TgsRevision()
	if(revinfo)
		commit = revinfo.commit
		originmastercommit = revinfo.origin_commit
		date = revinfo.timestamp || rustg_git_commit_date(commit)

	// goes to DD log and config_error.txt
	log_world(get_log_message())

/datum/getrev/proc/get_log_message()
	var/list/msg = list()
	msg += "当前CMSS13版本：[date]"
	if(originmastercommit)
		msg += "origin/master: [originmastercommit]"

	for(var/line in testmerge)
		var/datum/tgs_revision_information/test_merge/tm = line
		msg += "已试合并PR #[tm.number]，提交：[tm.head_commit]"

	if(commit && commit != originmastercommit)
		msg += "HEAD: [commit]"
	else if(!originmastercommit)
		msg += "无提交信息"

	return msg.Join("\n")

/datum/getrev/proc/GetTestMergeInfo(header = TRUE)
	if(!length(testmerge))
		return ""
	. = header ? "当前已试合并以下拉取请求：<br>" : ""
	for(var/line in testmerge)
		var/datum/tgs_revision_information/test_merge/tm = line
		var/cm = tm.head_commit
		var/details = "：“" + html_encode(tm.title) + "”，作者：" + html_encode(tm.author) + "，提交：" + html_encode(copytext_char(cm, 1, 11))
		if(details && findtext(details, "\[s\]") && (!usr || !usr.client.admin_holder))
			continue
		. += "<a href=\"[CONFIG_GET(string/githuburl)]/pull/[tm.number]\">#[tm.number][details]</a><br>"

/client/verb/showrevinfo()
	set category = "OOC"
	set name = "Show Server Revision"
	set desc = "查看当前服务器的代码版本"

	var/list/msg = list("")
	// Round ID

	msg += "<b>BYOND版本：</b>[world.byond_version].[world.byond_build]"
	if(DM_VERSION != world.byond_version || DM_BUILD != world.byond_build)
		msg += "<b>编译所用BYOND版本：</b>[DM_VERSION].[DM_BUILD]"

	// Revision information
	var/datum/getrev/revdata = GLOB.revdata
	msg += "<b>服务器版本编译日期：</b>[revdata.date]"
	var/pc = revdata.originmastercommit
	if(pc)
		msg += "主分支提交：<a href=\"[CONFIG_GET(string/githuburl)]/commit/[pc]\">[pc]</a>"
	if(length(revdata.testmerge))
		msg += revdata.GetTestMergeInfo()
	if(revdata.commit && revdata.commit != revdata.originmastercommit)
		msg += "本地提交：[revdata.commit]"
	else if(!pc)
		msg += "无提交信息"
	if(world.TgsAvailable())
		var/datum/tgs_version/version = world.TgsVersion()
		msg += "TGS版本：[version.raw_parameter]"
		var/datum/tgs_version/api_version = world.TgsApiVersion()
		msg += "DMAPI版本：[api_version.raw_parameter]"

	// Game mode odds
	to_chat(src, SPAN_INFO(msg.Join("<br>")))
