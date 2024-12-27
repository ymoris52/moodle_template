SELECT
	id,
	itemname,
	itemtype,
	itemmodule,
	iteminstance,
	idnumber,
	grademax,
	grademin
FROM
	{{ db_prefix }}grade_items
WHERE
	courseid = %s
ORDER BY
	sortorder
