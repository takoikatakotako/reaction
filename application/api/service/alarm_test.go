package service

import (
	"github.com/google/uuid"
	"github.com/stretchr/testify/assert"
	"github.com/takoikatakotako/reaction/api/service/input"
	"github.com/takoikatakotako/reaction/infrastructure"
	"testing"
)

func TestAlarmService_AddAlarm(t *testing.T) {
	// AWS Repository
	repo := infrastructure.AWS{Profile: "local"}

	// Service
	userService := User{AWS: repo}
	alarmService := Alarm{AWS: repo}
	pushTokenService := PushToken{AWS: repo}

	// ユーザー作成
	userID := uuid.New().String()
	authToken := uuid.New().String()
	const ipAddress = "127.0.0.1"
	const platform = "iOS"
	_, err := userService.Signup(userID, authToken, platform, ipAddress)
	if err != nil {
		t.Errorf("unexpected error: %v", err)
	}

	// PlatformEndpointを追加
	voIPPushToken := uuid.New().String()
	err = pushTokenService.AddIOSVoipPushToken(userID, authToken, voIPPushToken)
	if err != nil {
		t.Errorf("unexpected error: %v", err)
	}

	// アラーム作成
	alarmID := uuid.New().String()
	const alarmType = "IOS_VOIP_PUSH_NOTIFICATION"
	const alarmEnable = true
	var alarmName = "Alarm Name"
	const alarmHour = 23
	const alarmMinute = 48
	const alarmTimeDifference = float32(9.0)
	const charaID = "charaID"
	const charaName = "charaName"
	const voiceFileURL = "voiceFileURL"
	const sunday = true
	const monday = false
	const tuesday = true
	const wednesday = false
	const thursday = true
	const friday = true
	const saturday = false

	alarm := input.Alarm{
		AlarmID:        alarmID,
		UserID:         userID,
		Type:           alarmType,
		Enable:         alarmEnable,
		Name:           alarmName,
		Hour:           alarmHour,
		Minute:         alarmMinute,
		TimeDifference: alarmTimeDifference,

		// Chara Info
		CharaID:       charaID,
		CharaName:     charaName,
		VoiceFileName: voiceFileURL,

		// Weekday
		Sunday:    sunday,
		Monday:    monday,
		Tuesday:   tuesday,
		Wednesday: wednesday,
		Thursday:  thursday,
		Friday:    friday,
		Saturday:  saturday,
	}

	addAlarmInput := input.AddAlarm{
		UserID:    userID,
		AuthToken: authToken,
		Alarm:     alarm,
	}

	err = alarmService.AddAlarm(addAlarmInput)
	if err != nil {
		t.Errorf("unexpected error: %v", err)
	}

	// アラームを取得
	getAlarmsOutput, err := alarmService.GetAlarms(userID, authToken)
	if err != nil {
		t.Errorf("unexpected error: %v", err)
	}
	getAlarmList := getAlarmsOutput.Alarms

	// Assert
	assert.Equal(t, 1, len(getAlarmList))
	getAlarm := getAlarmList[0]
	assert.Equal(t, getAlarm.AlarmID, alarmID)
	assert.Equal(t, getAlarm.UserID, userID)
	assert.Equal(t, getAlarm.Type, alarmType)
	assert.Equal(t, getAlarm.Enable, alarmEnable)
	assert.Equal(t, getAlarm.Name, alarmName)
	assert.Equal(t, getAlarm.Hour, alarmHour)
	assert.Equal(t, getAlarm.Minute, alarmMinute)
	assert.Equal(t, getAlarm.TimeDifference, alarmTimeDifference)
	assert.Equal(t, getAlarm.CharaID, charaID)
	assert.Equal(t, getAlarm.CharaName, charaName)
	assert.Equal(t, getAlarm.VoiceFileName, voiceFileURL)
	assert.Equal(t, getAlarm.Sunday, sunday)
	assert.Equal(t, getAlarm.Monday, monday)
	assert.Equal(t, getAlarm.Tuesday, tuesday)
	assert.Equal(t, getAlarm.Wednesday, wednesday)
	assert.Equal(t, getAlarm.Thursday, thursday)
	assert.Equal(t, getAlarm.Friday, friday)
	assert.Equal(t, getAlarm.Saturday, saturday)

	// アラーム編集
	alarmName = "New Alarm Name"
	alarm.Name = alarmName

	editAlarmInput := input.EditAlarm{
		UserID:    userID,
		AuthToken: authToken,
		Alarm:     alarm,
	}

	err = alarmService.EditAlarm(editAlarmInput)
	if err != nil {
		t.Errorf("unexpected error: %v", err)
	}

	// アラームを取得
	getAlarmsOutput, err = alarmService.GetAlarms(userID, authToken)
	if err != nil {
		t.Errorf("unexpected error: %v", err)
	}
	updatedAlarmList := getAlarmsOutput.Alarms

	// Assert
	assert.Equal(t, 1, len(updatedAlarmList))
	updatedAlarm := updatedAlarmList[0]
	assert.Equal(t, updatedAlarm.AlarmID, alarmID)
	assert.Equal(t, updatedAlarm.UserID, userID)
	assert.Equal(t, updatedAlarm.Type, alarmType)
	assert.Equal(t, updatedAlarm.Enable, alarmEnable)
	assert.Equal(t, updatedAlarm.Name, alarmName)
	assert.Equal(t, updatedAlarm.Hour, alarmHour)
	assert.Equal(t, updatedAlarm.TimeDifference, alarmTimeDifference)
	assert.Equal(t, updatedAlarm.Minute, alarmMinute)
	assert.Equal(t, updatedAlarm.CharaID, charaID)
	assert.Equal(t, updatedAlarm.CharaName, charaName)
	assert.Equal(t, updatedAlarm.VoiceFileName, voiceFileURL)
	assert.Equal(t, updatedAlarm.Sunday, sunday)
	assert.Equal(t, updatedAlarm.Monday, monday)
	assert.Equal(t, updatedAlarm.Tuesday, tuesday)
	assert.Equal(t, updatedAlarm.Wednesday, wednesday)
	assert.Equal(t, updatedAlarm.Thursday, thursday)
	assert.Equal(t, updatedAlarm.Friday, friday)
	assert.Equal(t, updatedAlarm.Saturday, saturday)

	// アラームを削除
	err = alarmService.DeleteAlarm(userID, authToken, getAlarm.AlarmID)
	if err != nil {
		t.Errorf("unexpected error: %v", err)
	}

	// アラームを取得
	getAlarmsOutput, err = alarmService.GetAlarms(userID, authToken)
	if err != nil {
		t.Errorf("unexpected error: %v", err)
	}

	// Assert
	assert.Equal(t, 0, len(getAlarmsOutput.Alarms))
}

func TestAlarmService_AddAlarmAndGetAlarm(t *testing.T) {

}
