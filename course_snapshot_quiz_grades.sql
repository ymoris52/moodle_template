SELECT
	quiz_grades.id,
	quiz_grades.quiz,
	_user.username,
	quiz_grades.grade,
	quiz_grades.timemodified
FROM
	{{ db_prefix }}quiz_grades quiz_grades,
	{{ db_prefix }}user _user
WHERE
	quiz_grades.quiz IN (
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
	AND quiz_grades.userid = _user.id
ORDER BY
	quiz_grades.id
