SELECT
	grade_grades_history.itemid,
	grade_grades_history.action,
	grade_grades_history.source,
	_user.username,
	grade_grades_history.rawgrade,
	grade_grades_history.rawgrademax,
	grade_grades_history.rawgrademin,
	grade_grades_history.finalgrade,
	grade_grades_history.timemodified
FROM
	{{ db_prefix }}grade_grades_history grade_grades_history,
	{{ db_prefix }}user _user
WHERE
	grade_grades_history.itemid IN (
		SELECT
			id
		FROM
			{{ db_prefix }}grade_items
		WHERE
			courseid = %s
	)
	AND grade_grades_history.userid = _user.id
ORDER BY
	grade_grades_history.itemid,
	grade_grades_history.timemodified
