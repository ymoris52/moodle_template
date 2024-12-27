WITH course_student_username AS (
	SELECT
		_user.username
	FROM
		{{ db_prefix }}user _user,
		{{ db_prefix }}context context,
		{{ db_prefix }}role role,
		{{ db_prefix }}role_assignments role_assignments
	WHERE
		context.contextlevel = 50
		AND context.instanceid = %s
		AND role.shortname = 'student'
		AND role.id = role_assignments.roleid
		AND role_assignments.contextid = context.id
		AND _user.id = role_assignments.userid
)
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
	logstore_standard_log.courseid = %s
	AND (
		logstore_standard_log.eventname IN ( {{ extcond_none | join(', ') }} )
		OR (
			user1.username IN (
				SELECT
					username
				FROM
					course_student_username
			)
			AND logstore_standard_log.eventname IN ( {{ extcond_username | join(', ') }} )
		)
		OR (
			user2.username IN (
				SELECT
					username
				FROM
					course_student_username
			)
			AND logstore_standard_log.eventname IN ( {{ extcond_relatedusername | join(', ') }} )
		)
	)
	AND logstore_standard_log.timecreated BETWEEN [EVENTLOG_FROM] AND [EVENTLOG_TO]
ORDER BY
	logstore_standard_log.id
