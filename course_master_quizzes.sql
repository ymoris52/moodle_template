SELECT
	quizml.*,
	quiz_sections.shufflequestions
FROM
	(
		SELECT
			course_modules.id,
			course_modules.instance AS quizid,
			context.id,
			course_sections.section,
			quiz.name,
			quiz.timeclose,
			quiz.attempts,
			quiz.grademethod,
			quiz.grade
		FROM
			{{ db_prefix }}course_modules course_modules,
			{{ db_prefix }}context context,
			{{ db_prefix }}course_sections course_sections,
			{{ db_prefix }}quiz quiz,
			{{ db_prefix }}modules modules
		WHERE
			course_modules.course = %s
			AND course_modules.id = context.instanceid
			AND course_modules.instance = quiz.id
			AND context.contextlevel = 70
			AND course_modules.section = course_sections.id
			AND course_modules.module = modules.id
			AND modules.name = 'quiz'
	) AS quizml
	LEFT OUTER JOIN {{ db_prefix }}quiz_sections quiz_sections
		ON quizml.quizid = quiz_sections.quizid
ORDER BY
	quizml.section,
	quizml.name
