SELECT
	forum_discussions.id,
	forum_posts.id,
	forum_posts.parent,
	_user.username,
	forum_posts.created,
	forum_posts.modified,
	forum_posts.subject,
	forum_posts.message
FROM
	{{ db_prefix }}forum_discussions forum_discussions,
	{{ db_prefix }}forum_posts forum_posts,
	{{ db_prefix }}user _user
WHERE
	forum_discussions.course = %s
	AND forum_discussions.id = forum_posts.discussion
	AND forum_posts.userid = _user.id
ORDER BY
	forum_discussions.id,
	forum_posts.id
