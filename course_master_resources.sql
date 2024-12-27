SELECT
	course_modules.id,
	course_modules.instance,
	context.id,
	course_sections.section,
	resource.name,
	files.filename,
	files.mimetype
FROM
	{{ db_prefix }}course_modules course_modules,
	{{ db_prefix }}context context,
	{{ db_prefix }}course_sections course_sections,
	{{ db_prefix }}resource resource,
	{{ db_prefix }}modules modules,
	{{ db_prefix }}files files
WHERE
	course_modules.course = %s
	AND course_modules.id = context.instanceid
	AND course_modules.instance = resource.id
	AND context.contextlevel = 70
	AND course_modules.section = course_sections.id
	AND course_modules.module = modules.id
	AND modules.name = 'resource'
	AND context.id = files.contextid
	AND files.filename <> '.'
ORDER BY
	course_sections.section,
	resource.name
