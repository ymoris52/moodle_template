SELECT
	id,
	question,
	answer,
	fraction,
	feedback
FROM
	{{ db_prefix }}question_answers
WHERE
	question IN (
		SELECT
			question.id
		FROM
			{{ db_prefix }}question question,
			{{ db_prefix }}question_versions question_versions,
			{{ db_prefix }}question_bank_entries question_bank_entries,
			{{ db_prefix }}question_references question_references,
			{{ db_prefix }}quiz_slots quiz_slots
		WHERE
			question.id = question_versions.questionid
			AND question_versions.questionbankentryid = question_bank_entries.id
			AND question_bank_entries.id = question_references.questionbankentryid
			AND question_references.component = 'mod_quiz'
			AND question_references.questionarea = 'slot'
			AND question_references.itemid = quiz_slots.id
			AND quiz_slots.quizid IN (
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
			AND question.qtype = 'shortanswer'
	)
