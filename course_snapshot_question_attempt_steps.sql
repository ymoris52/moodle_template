SELECT
	questionattemptid,
	sequencenumber,
	state,
	fraction,
	timecreated
FROM
	{{ db_prefix }}question_attempt_steps
WHERE
	questionattemptid IN (
		SELECT
			id
		FROM
			{{ db_prefix }}question_attempts
		WHERE
			questionusageid IN (
				SELECT
					uniqueid
				FROM
					{{ db_prefix }}quiz_attempts
				WHERE
					preview = 0
					AND quiz IN (
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
			)
	)
ORDER BY
	questionattemptid,
	sequencenumber
