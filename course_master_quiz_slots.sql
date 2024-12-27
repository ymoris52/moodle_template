SELECT
	id,
	slot,
	quizid,
	page,
	maxmark
FROM
	{{ db_prefix }}quiz_slots
WHERE
	quizid IN (
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
ORDER BY
	quizid,
	slot
