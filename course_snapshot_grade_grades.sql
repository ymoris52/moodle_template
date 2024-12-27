SELECT
	grade_grades.itemid,
	_user.username,
	grade_grades.rawgrade,
	grade_grades.rawgrademax,
	grade_grades.rawgrademin,
	grade_grades.finalgrade,
	grade_grades.timecreated,
	grade_grades.timemodified
FROM
	{{ db_prefix }}grade_grades grade_grades,
	{{ db_prefix }}user _user
WHERE
	grade_grades.itemid IN (
		SELECT
			id
		FROM
			{{ db_prefix }}grade_items
		WHERE
			courseid = %s
	)
	AND grade_grades.userid = _user.id
ORDER BY
	grade_grades.itemid,
	grade_grades.timemodified
