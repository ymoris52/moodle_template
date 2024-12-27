SELECT
	course_modules.id,
	course_modules.instance,
	context.id,
	course_sections.section,
	url.name,
	url.externalurl
FROM
	{{ db_prefix }}course_modules course_modules,
	{{ db_prefix }}context context,
	{{ db_prefix }}course_sections course_sections,
	{{ db_prefix }}url url,
	{{ db_prefix }}modules modules
WHERE
	course_modules.course = %s
	AND course_modules.id = context.instanceid
	AND course_modules.instance = url.id
	AND context.contextlevel = 70
	AND course_modules.section = course_sections.id
	AND course_modules.module = modules.id
	AND modules.name = 'url'
ORDER BY
	course_sections.section,
	url.name
