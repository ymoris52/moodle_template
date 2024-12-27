SELECT
	course_modules.id,
	course_modules.instance,
	context.id,
	course_sections.section,
	assign.name,
	assign.duedate,
	assign.grade
FROM
	{{ db_prefix }}course_modules course_modules,
	{{ db_prefix }}context context,
	{{ db_prefix }}course_sections course_sections,
	{{ db_prefix }}assign assign,
	{{ db_prefix }}modules modules
WHERE
	course_modules.course = %s
	AND course_modules.id = context.instanceid
	AND course_modules.instance = assign.id
	AND context.contextlevel = 70
	AND course_modules.section = course_sections.id
	AND course_modules.module = modules.id
	AND modules.name = 'assign'
ORDER BY
	course_sections.section,
	assign.name
