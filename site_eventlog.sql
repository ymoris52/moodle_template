SELECT
	logstore_standard_log.eventname,
	user1.username,
	user2.username,
	logstore_standard_log.contextid,
	logstore_standard_log.timecreated,
	logstore_standard_log.other
FROM
	{{ db_prefix }}logstore_standard_log logstore_standard_log
INNER JOIN {{ db_prefix }}user user1
	ON logstore_standard_log.userid = user1.id
LEFT OUTER JOIN {{ db_prefix }}user user2
	ON logstore_standard_log.relateduserid = user2.id
WHERE
	user1.username IN (
		SELECT DISTINCT
			_user.username
		FROM
			{{ db_prefix }}user _user,
			{{ db_prefix }}course course,
			{{ db_prefix }}context context,
			{{ db_prefix }}role role,
			{{ db_prefix }}role_assignments role_assignments
		WHERE
			context.contextlevel = 50
			AND course.id = context.instanceid
			AND course.category = %s
			AND role.shortname = 'student'
			AND role.id = role_assignments.roleid
			AND role_assignments.contextid = context.id
			AND _user.id = role_assignments.userid
	)
	AND logstore_standard_log.eventname IN (
		'\core\event\user_loggedin',
		'\core\event\user_loggedout'
	)
	AND logstore_standard_log.timecreated BETWEEN %s AND %s
ORDER BY
	logstore_standard_log.id
