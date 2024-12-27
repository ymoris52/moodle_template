SELECT
	quiz_attempts.uniqueid,
	quiz_attempts.quiz,
	_user.username,
	quiz_attempts.attempt,
	quiz_attempts.layout,
	quiz_attempts.currentpage,
	quiz_attempts.state,
	quiz_attempts.timestart,
	quiz_attempts.timefinish,
	quiz_attempts.timemodified,
	quiz_attempts.sumgrades
FROM
	{{ db_prefix }}quiz_attempts quiz_attempts,
	{{ db_prefix }}user _user
WHERE
	quiz_attempts.preview = 0
	AND quiz_attempts.quiz IN (
		SELECT
			quiz.id
		FROM
			{{ db_prefix }}course_modules course_modules,
			{{ db_prefix }}context context,
			{{ db_prefix }}quiz quiz,
			{{ db_prefix }}modules modules
		WHERE
			course_modules.course = %s
			AND course_modules.id = context.instanceid
			AND course_modules.instance = quiz.id
			AND context.contextlevel = 70
			AND course_modules.module = modules.id
			AND modules.name = 'quiz'
	)
	AND quiz_attempts.userid = _user.id
ORDER BY
	quiz_attempts.uniqueid
