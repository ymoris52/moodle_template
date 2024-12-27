SELECT
	course_modules_completion.coursemoduleid,
	_user.username,
	course_modules_completion.completionstate,
	course_modules_completion.timemodified
FROM
	{{ db_prefix }}course_modules_completion course_modules_completion,
	{{ db_prefix }}user _user
WHERE
	course_modules_completion.coursemoduleid IN (
		SELECT
			id
		FROM
			{{ db_prefix }}course_modules
		WHERE
			course = %s
	)
	AND course_modules_completion.userid = _user.id
ORDER BY
	course_modules_completion.coursemoduleid,
	course_modules_completion.timemodified
