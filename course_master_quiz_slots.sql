WITH
	question_versions_max AS (
		SELECT
			questionbankentryid,
			MAX(version) AS version
		FROM
			{{ db_prefix }}question_versions
		WHERE
			status = 'ready'
		GROUP BY
			questionbankentryid
	),
	question_references_2 AS (
		SELECT
			question_references.itemid,
			question_references.questionbankentryid,
			CASE
				WHEN question_references.version IS NULL THEN question_versions_max.version
				ELSE question_references.version
			END AS version
		FROM
			{{ db_prefix }}question_references question_references,
			question_versions_max
		WHERE
			question_references.questionbankentryid = question_versions_max.questionbankentryid
			AND question_references.component = 'mod_quiz'
			AND question_references.questionarea = 'slot'
	)
SELECT
	quiz_slots.id,
	quiz_slots.slot,
	quiz_slots.quizid,
	quiz_slots.page,
	quiz_slots.maxmark,
	question.id
FROM
	{{ db_prefix }}quiz_slots quiz_slots,
	question_references_2,
	{{ db_prefix }}question_versions question_versions,
	{{ db_prefix }}question question
WHERE
	quiz_slots.quizid IN (
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
	AND quiz_slots.id = question_references_2.itemid
	AND question_references_2.questionbankentryid = question_versions.questionbankentryid
	AND question_references_2.version = question_versions.version
	AND question_versions.questionid = question.id
ORDER BY
	quiz_slots.quizid,
	quiz_slots.slot
