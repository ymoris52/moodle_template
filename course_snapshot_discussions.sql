SELECT
	forum.id,
	forum_discussions.id,
	forum_discussions.name,
	_user.username,
	forum_discussions.groupid
FROM
	{{ db_prefix }}forum forum,
	{{ db_prefix }}forum_discussions forum_discussions,
	{{ db_prefix }}user _user
WHERE
	forum.course = %s
	AND forum.id = forum_discussions.forum
	AND forum_discussions.userid = _user.id
ORDER BY
	forum.id,
	forum_discussions.id
