GLOBAL_REFERENCE_LIST_INDEXED(adminreplies, /datum/autoreply/admin, title)

/datum/autoreply
	/// What shows up in the list of replies, and the big red header on the reply itself.
	var/title = "Blank"
	var/localized_title
	/// The detailed message in the auto reply.
	var/message = "Lorem ipsum dolor sit amit."
	/// If the autoreply will automatically close the ahelp or not.
	var/closer = TRUE

/// Admin Replies
/datum/autoreply/admin/handled
	title = "Being Handled"
	localized_title = "正在处理"
	message = "工作人员已了解此问题，正在处理中。"
	closer = FALSE

/datum/autoreply/admin/icissue
	title = "IC Issue"
	localized_title = "角色内问题"
	message = "管理员已认定你反映的是角色内问题，目前无需管理员介入。如需进一步解决，请通过符合角色扮演的方式处理。"

/datum/autoreply/admin/bug
	title = "Bug Report"
	localized_title = "错误报告"

ON_CONFIG_LOAD(/datum/autoreply/admin/bug)
	message = "请通过我们的<a href='[CONFIG_GET(string/githuburl)]'>GitHub</a>报告所有程序错误。管理员通常无法在回合中修复这些问题；只有严重影响当前回合的错误或可被利用的漏洞才应向管理员求助。"

/datum/autoreply/admin/marine
	title = "Marine Guide"
	localized_title = "陆战队指南"

ON_CONFIG_LOAD(/datum/autoreply/admin/marine)
	message = "你的问题可参考<a href='[CONFIG_GET(string/wikiarticleurl)]/[URL_WIKI_MARINE_QUICKSTART]'>陆战队快速入门指南</a>。如果仍有不清楚的地方或其他问题，请重新向导师或管理员求助。"

/datum/autoreply/admin/xeno
	title = "Xeno Guide"
	localized_title = "异形指南"

ON_CONFIG_LOAD(/datum/autoreply/admin/xeno)
	message = "你的问题可参考<a href='[CONFIG_GET(string/wikiarticleurl)]/[URL_WIKI_XENO_QUICKSTART]'>异形快速入门指南</a>。如果仍有不清楚的地方或其他问题，请重新向导师或管理员求助。"

/datum/autoreply/admin/changelog
	title = "Changelog"
	localized_title = "更新日志"
	message = "你可以在更新日志中找到问题的答案。点击屏幕右上角的更新日志按钮即可在游戏内查看；也可以前往CM-SS13的Discord服务器，在cm-changelog频道查找已合并改动的链接。"

/datum/autoreply/admin/intended
	title = "Intended"
	localized_title = "预期机制"
	message = "这是设计预期的机制，因此无需管理员介入。"

/datum/autoreply/admin/event
	title = "Event"
	localized_title = "活动"
	message = "当前正在进行特殊活动，许多内容可能有所改动或不同。不过，除非工作人员明确另有说明，常规规则仍然适用。"

/datum/autoreply/admin/whitelist
	title = "Whitelist Issue"
	localized_title = "白名单问题"

ON_CONFIG_LOAD(/datum/autoreply/admin/whitelist)
	message = "工作人员无法在游戏中处理大多数白名单规则违规问题，请<a href='[CONFIG_GET(string/playerreport)]'>在论坛提交玩家举报</a>。"
