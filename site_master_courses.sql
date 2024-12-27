SELECT
	course.id,
	context.id,
	course.fullname
FROM
	{{ db_prefix }}course course,
	{{ db_prefix }}context context
WHERE
	context.contextlevel = 50
	AND course.id = context.instanceid
	AND course.category = %s
ORDER BY
	course.sortorder
