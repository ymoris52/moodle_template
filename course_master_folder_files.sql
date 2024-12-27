SELECT
	id,
	contextid,
	filepath,
	filename,
	mimetype
FROM
	{{ db_prefix }}files
WHERE
	contextid IN (
		SELECT
			context.id
		FROM
			{{ db_prefix }}course_modules course_modules,
			{{ db_prefix }}context context,
			{{ db_prefix }}course_sections course_sections,
			{{ db_prefix }}folder folder,
			{{ db_prefix }}modules modules
		WHERE
			course_modules.course = %s
			AND course_modules.id = context.instanceid
			AND course_modules.instance = folder.id
			AND context.contextlevel = 70
			AND course_modules.section = course_sections.id
			AND course_modules.module = modules.id
			AND modules.name = 'folder'
	)
	AND filename <> '.'
