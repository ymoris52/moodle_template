# Moodleの学習履歴データ用Jinja2テンプレート

## 概要

Moodleのデータベース（PostgreSQL）から、学習履歴データとその利用に必要なデータを取得するための、Jinja2テンプレートです。
特定のMoodleインスタンス（以下、本システム）を対象に作りましたが、本システム以外でも使えます。

- 本システムで使っている機能だけを対象にします。例えば、H5P（`mod_h5pactivity`）やIMSコンテンツパッケージ（`mod_imscp`）は使っていないので、対象外です。
- 本システムでは、学生であるかを判定するには、ロールに加えて`user.username`がある規則を満たしているかを調べる必要があります。`user.username`の条件は、SQLから削除して掲載します。
- 追加プラグインに関連するテンプレートや、SQLの記述は削除して掲載します。
- テンプレートに応じて、コースカテゴリID、コースID、集計開始日時と集計終了日時（Unix time）などを指定して、データを取得します。
- `user.id`ではなく`user.username`をユーザ（学生）の識別子とします。テンプレート中の変数`db_prefix`は、Moodleのテーブル接頭辞（`$CFG->prefix`）です。
- 設計時のMoodleのバージョンは、4.1です。

| データの種類 | 説明 |
| --- | --- |
| マスタ | （本システムにおいては）原則として開講中に変化しない情報です。 |
| スナップショット | データを取得した時点でのコース内の状態です。 |
| イベントログ | ログストアマネージャ（`tool_log`）が検出して、`logstore_standard_log`テーブルに記録されるイベントのログです。 |

## サイトのマスタ

### コース

[site_master_courses.sql](site_master_courses.sql)

データ項目：
1. コースID
2. コンテキストID
3. コース名

### 履修学生

[site_master_students.sql](site_master_students.sql)

データ項目：
1. ユーザ名
2. コースID

## サイトのイベントログ

### イベントログ

[site_eventlog.sql](site_eventlog.sql)

データ項目：
1. イベント名
2. ユーザ名
3. 関連ユーザ名
4. コンテキストID
5. 日時
6. other

ログインとログアウトのログです。

## コースのマスタ

### 履修学生

[course_master_students.sql](course_master_students.sql)

データ項目
1. ユーザ名

### セクション

[course_master_sections.sql](course_master_sections.sql)

データ項目：
1. セクション番号
2. セクション名
3. シーケンス

### 課題

[course_master_assigns.sql](course_master_assigns.sql)

データ項目：
1. コースモジュールID
2. 課題ID
3. コンテキストID
4. セクション番号
5. 課題名
6. 終了日時
7. 最大評点

### フォーラム

[course_master_forums.sql](course_master_forums.sql)

データ項目：
1. コースモジュールID
2. フォーラムID
3. コンテキストID
4. セクション番号
5. フォーラム名
6. フォーラムタイプ

### 小テスト

[course_master_quizzes.sql](course_master_quizzes.sql)

データ項目：
1. コースモジュールID
2. 小テストID
3. コンテキストID
4. セクション番号
5. 小テスト名
6. 終了日時
7. 受験可能回数
8. 評定方法
9. 最大評点
10. 問題シャッフル

### 小テストスロット

[course_master_quiz_slots.sql](course_master_quiz_slots.sql)

データ項目：
1. スロットID
2. スロット番号
3. 小テストID
4. ページ
5. 最大評点

### 問題

[course_master_questions.sql](course_master_questions.sql)

データ項目：
1. 問題ID
2. 親問題ID
3. 問題名
4. 問題テキスト
5. 全般に対するフィードバック
6. 問題タイプ

### ミッシングワード選択問題の選択肢

[course_master_question_answers_gapselect.sql](course_master_question_answers_gapselect.sql)

データ項目：
1. 選択肢ID
2. 問題ID
3. 答えテキスト
4. グループ

### 組み合わせ問題の下位問題

[course_master_qtype_match_subquestions.sql](course_master_qtype_match_subquestions.sql)

データ項目：
1. 下位問題ID
2. 問題ID
3. 問題テキスト
4. 答えテキスト

### 多肢選択問題の選択肢 ／ ○/×問題の選択肢

[course_master_question_answers_multichoice_truefalse.sql](course_master_question_answers_multichoice_truefalse.sql)

データ項目：
1. 選択肢ID
2. 問題ID
3. 選択肢テキスト
4. 評点
5. フィードバック

### 記述問題の答え

[course_master_question_answers_shortanswer.sql](course_master_question_answers_shortanswer.sql)

データ項目：
1. 答えID
2. 問題ID
3. 答えテキスト
4. 評点
5. フィードバック

### ワークショップ

[course_master_workshops.sql](course_master_workshops.sql)

データ項目：
1. コースモジュールID
2. ワークショップID
3. コンテキストID
4. セクション番号
5. ワークショップ名
6. 評定方法
7. 提出に対する評点
8. 評価に対する評点
9. 提出開始日時
10. 提出終了日時
11. 評価開始日時
12. 評価期限

### ブック ／ フィードバック ／ フォルダ ／ ページ ／ SCORM

[course_master_books_feedbacks_folders_pages_scorms.sql](course_master_books_feedbacks_folders_pages_scorms.sql)

データ項目：
1. コースモジュールID
2. ブックID ／ フィードバックID ／ フォルダID ／ ページID ／ SCORM ID
3. コンテキストID
4. セクション番号
5. 名称

変数`module_name`の値を、それぞれ“`book`”、“`feedback`”、“`folder`”、“`page`”、“`scorm`”にします。

### フォルダ内ファイル

[course_master_folder_files.sql](course_master_folder_files.sql)

データ項目：
1. ファイルID
2. コンテキストID
3. ファイルパス
4. ファイル名
5. メディアタイプ

### URL

[course_master_urls.sql](course_master_urls.sql)

データ項目：
1. コースモジュールID
2. URL ID
3. コンテキストID
4. セクション番号
5. 名称
6. 外部URL

### リソース

[course_master_resources.sql](course_master_resources.sql)

データ項目：
1. コースモジュールID
2. リソース ID
3. コンテキストID
4. セクション番号
5. 名称
6. ファイル名
7. メディアタイプ

### 評定項目

[course_master_grade_items.sql](course_master_grade_items.sql)

データ項目：
1. 評定項目ID
2. 項目名
3. 項目タイプ
4. 項目モジュール
5. 項目インスタンス
6. IDナンバー
7. 最大評点
8. 最小評点

## コースのスナップショット

### ディスカッション

[course_snapshot_discussions.sql](course_snapshot_discussions.sql)

データ項目：
1. フォーラムID
2. ディスカッションID
3. 件名
4. ユーザ名
5. グループID

### ポスト

[course_snapshot_discussion_posts.sql](course_snapshot_discussion_posts.sql)

データ項目：
1. ディスカッションID
2. ポストID
3. 親ポストID
4. ユーザ名
5. 作成日時
6. 更新日時
7. 件名
8. メッセージ

### 小テスト受験

[course_snapshot_quiz_attempts.sql](course_snapshot_quiz_attempts.sql)

データ項目：
1. 小テスト受験ID
2. 小テストID
3. ユーザ名
4. 受験回
5. レイアウト
6. 現在のページ
7. 状態
8. 開始日時
9. 完了日時
10. 更新日時
11. 評点

### 小テスト評定

[course_snapshot_quiz_grades.sql](course_snapshot_quiz_grades.sql)

データ項目：
1. 小テスト評定ID
2. 小テストID
3. ユーザ名
4. 評点
5. 更新日時

### 問題解答

[course_snapshot_question_attempts.sql](course_snapshot_question_attempts.sql)

データ項目：
1. 問題解答ID
2. 小テスト受験ID
3. スロット
4. 問題ID
5. フラグ
6. 問題テキストサマリ
7. 正答
8. 解答サマリ
9. 更新日時

### 問題解答履歴

[course_snapshot_question_attempt_steps.sql](course_snapshot_question_attempt_steps.sql)

データ項目：
1. 問題解答ID
2. ステップ
3. 状態
4. 評点
5. 日時

### 評定

[course_snapshot_grade_grades.sql](course_snapshot_grade_grades.sql)

データ項目：
1. 評定項目ID
2. ユーザ名
3. 評点
4. 最大評点
5. 最小評点
6. 最終評点
7. 作成日時
8. 更新日時

### 評定履歴

[course_snapshot_grade_grades_history.sql](course_snapshot_grade_grades_history.sql)

データ項目：
1. 評定項目ID
2. アクション
3. ソース
4. ユーザ名
5. 評点
6. 最大評点
7. 最小評点
8. 最終評点
9. 日時

### 活動完了

[course_snapshot_course_modules_completion.sql](course_snapshot_course_modules_completion.sql)

データ項目：
1. コースモジュールID
2. ユーザ名
3. 完了状態
4. 日時

## コースのイベントログ

### イベントログ

[course_eventlog.sql](course_eventlog.sql)

データ項目：
1. イベント名
2. ユーザ名
3. 関連ユーザ名
4. コンテキストID
5. 日時
6. other

変数`extcond_none`、`extcond_username`、`extcond_relatedusername`は、取得するイベント名のiterableです。

| 変数 | 説明 |
| --- | --- |
| `extcond_none` | 追加の条件なしでログを取得するイベント名。 |
| `extcond_username` | `logstore_standard_log.userid`が履修学生である場合にログを取得するイベント名。 |
| `extcond_relatedusername` | `logstore_standard_log.relateduserid`が履修学生である場合にログを取得するイベント名。 |

Psycopg 3を使う場合の、`template.render()`の引数の例は、以下の通りです。

```
{
	'db_prefix': 'mdl_',
	'extcond_none': map(lambda x: psycopg.sql.Literal(x).as_string(), (
		r'\mod_forum\event\post_created',
		r'\mod_forum\event\post_deleted',
		r'\mod_forum\event\post_updated',
		r'\mod_workshop\event\phase_switched'
	)),
	'extcond_username': map(lambda x: psycopg.sql.Literal(x).as_string(), (
		r'\assignsubmission_file\event\assessable_uploaded',
		r'\assignsubmission_file\event\submission_created',
		r'\assignsubmission_file\event\submission_updated',
		r'\assignsubmission_onlinetext\event\assessable_uploaded',
		r'\assignsubmission_onlinetext\event\submission_created',
		r'\assignsubmission_onlinetext\event\submission_updated',
		r'\booktool_print\event\book_printed',
		r'\booktool_print\event\chapter_printed',
		r'\core\event\course_module_completion_updated',
		r'\core\event\course_resources_list_viewed',
		r'\core\event\course_viewed',
		r'\gradereport_user\event\grade_report_viewed',
		r'\mod_assign\event\assessable_submitted',
		r'\mod_assign\event\course_module_instance_list_viewed',
		r'\mod_assign\event\submission_form_viewed',
		r'\mod_assign\event\submission_status_viewed',
		r'\mod_book\event\chapter_viewed',
		r'\mod_book\event\course_module_instance_list_viewed',
		r'\mod_book\event\course_module_viewed',
		r'\mod_feedback\event\course_module_instance_list_viewed',
		r'\mod_feedback\event\course_module_viewed',
		r'\mod_feedback\event\response_submitted',
		r'\mod_folder\event\all_files_downloaded',
		r'\mod_folder\event\course_module_instance_list_viewed',
		r'\mod_folder\event\course_module_viewed',
		r'\mod_forum\event\assessable_uploaded',
		r'\mod_forum\event\course_module_instance_list_viewed',
		r'\mod_forum\event\course_module_viewed',
		r'\mod_forum\event\discussion_created',
		r'\mod_forum\event\discussion_deleted',
		r'\mod_forum\event\discussion_subscription_created',
		r'\mod_forum\event\discussion_subscription_deleted',
		r'\mod_forum\event\discussion_viewed',
		r'\mod_forum\event\subscription_created',
		r'\mod_forum\event\subscription_deleted',
		r'\mod_page\event\course_module_instance_list_viewed',
		r'\mod_page\event\course_module_viewed',
		r'\mod_quiz\event\attempt_reviewed',
		r'\mod_quiz\event\attempt_started',
		r'\mod_quiz\event\attempt_submitted',
		r'\mod_quiz\event\attempt_summary_viewed',
		r'\mod_quiz\event\attempt_viewed',
		r'\mod_quiz\event\course_module_instance_list_viewed',
		r'\mod_quiz\event\course_module_viewed',
		r'\mod_resource\event\course_module_instance_list_viewed',
		r'\mod_resource\event\course_module_viewed',
		r'\mod_scorm\event\course_module_instance_list_viewed',
		r'\mod_scorm\event\course_module_viewed',
		r'\mod_scorm\event\sco_launched',
		r'\mod_url\event\course_module_instance_list_viewed',
		r'\mod_url\event\course_module_viewed',
		r'\mod_workshop\event\assessable_uploaded',
		r'\mod_workshop\event\course_module_instance_list_viewed',
		r'\mod_workshop\event\course_module_viewed',
		r'\mod_workshop\event\submission_assessed',
		r'\mod_workshop\event\submission_created',
		r'\mod_workshop\event\submission_deleted',
		r'\mod_workshop\event\submission_reassessed',
		r'\mod_workshop\event\submission_updated',
		r'\mod_workshop\event\submission_viewed'
	)),
	'extcond_relatedusername': map(lambda x: psycopg.sql.Literal(x).as_string(), (
		r'\core\event\user_graded',
		r'\mod_assign\event\submission_graded',
		r'\mod_assign\event\workflow_state_updated',
		r'\mod_workshop\event\assessment_evaluated'
	))
}
```

## その他

### コースID

[category_id_to_course_ids.sql](category_id_to_course_ids.sql)

データ項目：
1. コースID

コースカテゴリ内のコースの、コースIDです。
