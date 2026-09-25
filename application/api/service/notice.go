package service

import (
	"github.com/google/uuid"
	"github.com/takoikatakotako/reaction/api/service/input"
	"github.com/takoikatakotako/reaction/api/service/output"
	"github.com/takoikatakotako/reaction/infrastructure"
	"github.com/takoikatakotako/reaction/infrastructure/database"
	"log/slog"
	"time"
)

type Notice struct {
	AWS infrastructure.AWS
}

func (n *Notice) GetNotices() ([]output.Notice, error) {
	notices, err := n.AWS.GetNotices()
	if err != nil {
		slog.Error(err.Error())
		return []output.Notice{}, err
	}
	return convertToOutputNotices(notices), nil
}

func (n *Notice) GetNotice(in input.GetNotice) (output.Notice, error) {
	notice, err := n.AWS.GetNotice(in.ID)
	if err != nil {
		return output.Notice{}, err
	}
	return convertToOutputNotice(notice), nil
}

func (n *Notice) AddNotice(in input.AddNotice) error {
	now := time.Now()
	notice := database.Notice{
		ID:            uuid.NewString(),
		EnglishTitle:  in.EnglishTitle,
		JapaneseTitle: in.JapaneseTitle,
		EnglishBody:   in.EnglishBody,
		JapaneseBody:  in.JapaneseBody,
		PublishedAt:   in.PublishedAt,
	}
	notice.SetCreatedAt(now)
	notice.SetUpdatedAt(now)

	return n.AWS.InsertNotice(notice)
}

func (n *Notice) EditNotice(in input.EditNotice) error {
	// 作成日時は元の値を引き継ぐ
	current, err := n.AWS.GetNotice(in.ID)
	if err != nil {
		return err
	}

	notice := database.Notice{
		ID:            in.ID,
		EnglishTitle:  in.EnglishTitle,
		JapaneseTitle: in.JapaneseTitle,
		EnglishBody:   in.EnglishBody,
		JapaneseBody:  in.JapaneseBody,
		PublishedAt:   in.PublishedAt,
		CreatedAt:     current.CreatedAt,
	}
	notice.SetUpdatedAt(time.Now())

	return n.AWS.UpdateNotice(notice)
}

func (n *Notice) DeleteNotice(in input.DeleteNotice) error {
	return n.AWS.DeleteNotice(in.ID)
}
