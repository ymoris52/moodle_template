SELECT
	id
FROM
	{{ db_prefix }}course
WHERE
	category = %s
