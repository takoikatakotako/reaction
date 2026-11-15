package service

import (
	"encoding/json"
	"github.com/takoikatakotako/reaction/infrastructure"
	"github.com/takoikatakotako/reaction/infrastructure/database"
	"github.com/takoikatakotako/reaction/infrastructure/file"
)

type Export struct {
	AWS                infrastructure.AWS
	ResourceBucketName string
	ResourceBaseURL    string
	DistributionID     string
}

func (e *Export) ExportReactionsToS3() error {
	reactions, err := e.AWS.GetReactions()
	if err != nil {
		return err
	}

	// Convert to file.Reaction for export
	fileReactions := make([]file.Reaction, 0, len(reactions))
	for _, reaction := range reactions {
		fileReaction := convertToFileReaction(reaction, e.ResourceBaseURL)
		fileReactions = append(fileReactions, fileReaction)
	}

	// データベースで既にソート済み

	// Export reactions list
	fileReactionsWrapper := file.Reactions{Reactions: fileReactions}
	bytes, err := json.Marshal(fileReactionsWrapper)
	if err != nil {
		return err
	}

	objectKey := "resource/reaction/list.json"
	err = e.AWS.PutObject(e.ResourceBucketName, objectKey, bytes, "application/json")
	if err != nil {
		return err
	}

	// Export individual reaction files
	for _, fileReaction := range fileReactions {
		reactionBytes, err := json.Marshal(fileReaction)
		if err != nil {
			return err
		}

		individualKey := "resource/reaction/" + fileReaction.ID + "/reaction.json"
		err = e.AWS.PutObject(e.ResourceBucketName, individualKey, reactionBytes, "application/json")
		if err != nil {
			return err
		}
	}

	// S3エクスポート後、CloudFront distributionのキャッシュを無効化
	paths := []string{"/resource/reaction/*"}
	err = e.AWS.CreateInvalidation(e.DistributionID, paths)
	if err != nil {
		return err
	}
	return nil
}

func (e *Export) ExportQuestionsToS3() error {
	questions, err := e.AWS.GetQuestions()
	if err != nil {
		return err
	}

	fileQuestions := make([]file.Question, 0, len(questions))
	for _, question := range questions {
		fileQuestion := convertToFileQuestion(question, e.ResourceBaseURL)
		fileQuestions = append(fileQuestions, fileQuestion)
	}

	// Export questions list
	fileQuestionsWrapper := file.Questions{Questions: fileQuestions}
	bytes, err := json.Marshal(fileQuestionsWrapper)
	if err != nil {
		return err
	}

	objectKey := "resource/question/list.json"
	err = e.AWS.PutObject(e.ResourceBucketName, objectKey, bytes, "application/json")
	if err != nil {
		return err
	}

	// Export individual question files
	for _, fileQuestion := range fileQuestions {
		questionBytes, err := json.Marshal(fileQuestion)
		if err != nil {
			return err
		}

		individualKey := "resource/question/" + fileQuestion.ID + "/question.json"
		err = e.AWS.PutObject(e.ResourceBucketName, individualKey, questionBytes, "application/json")
		if err != nil {
			return err
		}
	}

	// CloudFrontキャッシュ無効化
	paths := []string{"/resource/question/*"}
	err = e.AWS.CreateInvalidation(e.DistributionID, paths)
	if err != nil {
		return err
	}
	return nil
}

func (e *Export) ExportNoticesToS3() error {
	notices, err := e.AWS.GetNotices()
	if err != nil {
		return err
	}

	// お知らせは件数が少なく個別取得の用途も無いため一覧のみ出力する
	for objectKey, fileNotices := range buildNoticeFiles(notices) {
		bytes, err := json.Marshal(file.Notices{Notices: fileNotices})
		if err != nil {
			return err
		}
		if err := e.AWS.PutObject(e.ResourceBucketName, objectKey, bytes, "application/json"); err != nil {
			return err
		}
	}

	// CloudFrontキャッシュ無効化
	paths := []string{"/resource/notice/*"}
	return e.AWS.CreateInvalidation(e.DistributionID, paths)
}

// 配信するお知らせファイルを object key ごとに組み立てる。並び順は notices のまま。
//
//   - ios.json / android.json: その OS が対象のお知らせ。言語の絞り込みはアプリ側で行う
//   - list.json: 対象言語を知らない旧 iOS アプリ向けの互換ファイル。
//     旧アプリは片方の言語しか無いお知らせを空タイトルで表示してしまうため、
//     iOS 向けかつ全言語が対象のものだけを載せる
func buildNoticeFiles(notices []database.Notice) map[string][]file.Notice {
	files := map[string][]file.Notice{
		"resource/notice/ios.json":     {},
		"resource/notice/android.json": {},
		"resource/notice/list.json":    {},
	}

	for _, notice := range notices {
		fileNotice := convertToFileNotice(notice)
		if notice.IsTargetPlatform(database.NoticePlatformIOS) {
			files["resource/notice/ios.json"] = append(files["resource/notice/ios.json"], fileNotice)
		}
		if notice.IsTargetPlatform(database.NoticePlatformAndroid) {
			files["resource/notice/android.json"] = append(files["resource/notice/android.json"], fileNotice)
		}
		if notice.IsTargetPlatform(database.NoticePlatformIOS) && isAllNoticeLanguages(notice) {
			files["resource/notice/list.json"] = append(files["resource/notice/list.json"], fileNotice)
		}
	}
	return files
}

func isAllNoticeLanguages(notice database.Notice) bool {
	for _, language := range database.AllNoticeLanguages {
		if !notice.IsTargetLanguage(language) {
			return false
		}
	}
	return true
}
