SELECT
	_user.username
FROM
	{{ db_prefix }}user _user,
	{{ db_prefix }}context context,
	{{ db_prefix }}role role,
	{{ db_prefix }}role_assignments role_assignments
WHERE
	context.contextlevel = 50
	AND context.instanceid = %s
	AND role.shortname = 'student'
	AND role.id = role_assignments.roleid
	AND role_assignments.contextid = context.id
	AND _user.id = role_assignments.userid
