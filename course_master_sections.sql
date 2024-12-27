SELECT
	section,
	name,
	sequence
FROM
	{{ db_prefix }}course_sections
WHERE
	course = %s
ORDER BY
	section
