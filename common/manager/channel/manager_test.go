package channel_test

import (
	"github.com/stretchr/testify/assert"
	"gitlab.com/epicglue/epicglue/app/manager/channel"
	"gitlab.com/epicglue/epicglue/app/model"
	r "gopkg.in/dancannon/gorethink.v2"
	"testing"
	"time"
)

func TestManager_Get(t *testing.T) {
	now := time.Now()
	user := model.User{
		ID:        1,
		CreatedAt: time.Now(),
	}

	mock := r.NewMock()
	mock.On(r.Table("channel").Get(int64(1))).Return([]interface{}{
		map[string]interface{}{
			"id":          1,
			"cmd":         "reddit --first 10 --sub images",
			"group_name":  "reddit",
			"is_active":   true,
			"is_hidden":   false,
			"min_refresh": 200,
			"description": "some desc",
			"created_at":  now,
			"updated_at":  now,
		},
	}, nil)
	mock.On(r.Table("channel").Get(int64(2))).Return([]interface{}{
		map[string]interface{}{
			"id":         2,
			"cmd":        "reddit --first 10 --sub images",
			"group_name": "reddit",
			"is_active":  false,
			"is_hidden":  true,
			"created_at": now,
		},
	}, nil)
	mock.On(r.Table("channel").Get(int64(3))).Return(nil, nil)

	ch, err := channel.NewChannelManager(mock, &user)
	if err != nil {
		t.Fatal(err)
	}

	item, err := ch.Get(1)
	if err != nil {
		t.Fatal(err)
	}

	assert.EqualValues(t, 1, item.ID)
	assert.Equal(t, "reddit --first 10 --sub images", item.Cmd)
	assert.Equal(t, "reddit", item.GroupName)
	assert.Equal(t, "some desc", *item.Description)
	assert.True(t, item.IsActive)
	assert.False(t, item.IsHidden)
	assert.Equal(t, now, item.CreatedAt)
	assert.Equal(t, now, *item.UpdatedAt)

	item, err = ch.Get(2)
	if err != nil {
		t.Fatal(err)
	}

	assert.EqualValues(t, 2, item.ID)
	assert.Equal(t, "reddit --first 10 --sub images", item.Cmd)
	assert.Equal(t, "reddit", item.GroupName)
	assert.False(t, item.IsActive)
	assert.True(t, item.IsHidden)
	assert.Nil(t, item.Description)
	assert.Nil(t, item.UpdatedAt)

	item, err = ch.Get(3)
	if err != nil {
		t.Fatal(err)
	}

	assert.Nil(t, item)
}

func TestManager_All(t *testing.T) {
	//now := time.Now()
	//user := model.User{
	//    ID:        1,
	//    CreatedAt: time.Now(),
	//}
	//
	//mock := r.NewMock()
	//mock.On(r.Table("channel").Get(int64(1))).Return([]interface{}{
	//    map[string]interface{}{
	//        "id":          1,
	//        "cmd":         "reddit --first 10 --sub images",
	//        "group_name":  "reddit",
	//        "is_active":   true,
	//        "is_hidden":   false,
	//        "min_refresh": 200,
	//        "description": "some desc",
	//        "created_at":  now,
	//        "updated_at":  now,
	//    },
	//}, nil)
	//mock.On(r.Table("channel").Get(int64(2))).Return([]interface{}{
	//    map[string]interface{}{
	//        "id":         2,
	//        "cmd":        "reddit --first 10 --sub images",
	//        "group_name": "reddit",
	//        "is_active":  false,
	//        "is_hidden":  true,
	//        "created_at": now,
	//    },
	//}, nil)
	//mock.On(r.Table("channel").Get(int64(3))).Return(nil, nil)
	//
	//ch, err := channel.NewChannelManager(mock, &user)
	//if err != nil {
	//    t.Fatal(err)
	//}
	//
	//item, err := ch.Get(1)
	//if err != nil {
	//    t.Fatal(err)
	//}
	//
	//assert.EqualValues(t, 1, item.ID)
	//assert.Equal(t, "reddit --first 10 --sub images", item.Cmd)
	//assert.Equal(t, "reddit", item.GroupName)
	//assert.Equal(t, "some desc", *item.Description)
	//assert.True(t, item.IsActive)
	//assert.False(t, item.IsHidden)
	//assert.Equal(t, now, item.CreatedAt)
	//assert.Equal(t, now, *item.UpdatedAt)
	//
	//item, err = ch.Get(2)
	//if err != nil {
	//    t.Fatal(err)
	//}
	//
	//assert.EqualValues(t, 2, item.ID)
	//assert.Equal(t, "reddit --first 10 --sub images", item.Cmd)
	//assert.Equal(t, "reddit", item.GroupName)
	//assert.False(t, item.IsActive)
	//assert.True(t, item.IsHidden)
	//assert.Nil(t, item.Description)
	//assert.Nil(t, item.UpdatedAt)
	//
	//item, err = ch.Get(3)
	//if err != nil {
	//    t.Fatal(err)
	//}
	//
	//assert.Nil(t, item)
}

//func TestDefaultDataManager_Channels(t *testing.T) {
//    //suffix := helpers.RandomString(8)
//    //setup(suffix)
//    //defer tearDown(suffix)
//
//    var (
//        dm       manager.DataManager = manager.NewManagerWithConnectors(DB, nil).Data()
//        channels []model.Channel
//        err      error
//    )
//
//    // Insert some test data
//    u1 := model.User{Username: "test_user"}
//    u2 := model.User{Username: "test_user_2"}
//    DB.Save(&u1).Save(&u2)
//
//    ch1 := model.Channel{Cmd: null.StringFrom("reddit --first 10 --sub images"), GroupName: "reddit", Name: "/r/images", IsActive: true, MinRefresh: 300}
//    ch2 := model.Channel{Cmd: null.StringFrom("reddit --first 10 --sub wtf"), GroupName: "reddit", Name: "/r/wtf", IsActive: true, MinRefresh: 300}
//    ch3 := model.Channel{UserId: null.IntFrom(u1.Id), GroupName: "own", Name: "/r/wtf", IsActive: true, MinRefresh: 300}
//    ch4 := model.Channel{GroupName: "hidden", Name: "hidden channel", IsActive: true, IsHidden: true, MinRefresh: 300}
//    ch5 := model.Channel{UserId: null.IntFrom(u2.Id), GroupName: "not_active", Name: "not active channel", IsActive: false, MinRefresh: 300}
//    DB.Save(&ch1).Save(&ch2).Save(&ch3).Save(&ch4).Save(&ch5)
//
//    // Tests for two users, second should see only public channels
//    channels, err = dm.Channels(&u1)
//    assert.Nil(t, err, err)
//    assert.Len(t, channels, 3)
//    ChannelsAreEqual(t, ch1, channels[0])
//    ChannelsAreEqual(t, ch2, channels[1])
//    ChannelsAreEqual(t, ch3, channels[2])
//
//    channels, err = dm.Channels(&u2)
//    assert.Nil(t, err, err)
//    assert.Len(t, channels, 2)
//    ChannelsAreEqual(t, ch1, channels[0])
//    ChannelsAreEqual(t, ch2, channels[1])
//}
//
//func TestDefaultDataManager_Channel(t *testing.T) {
//    suffix := helpers.RandomString(8)
//    setup(suffix)
//    defer tearDown(suffix)
//
//    var (
//        dm       manager.DataManager = manager.NewManagerWithConnectors(DB, nil).Data()
//        channels []model.Channel
//        err      error
//    )
//
//    // Insert some test data
//    u1 := model.User{Username: "test_user"}
//    DB.Save(&u1)
//
//    ch1 := model.Channel{Cmd: null.StringFrom("reddit --first 10 --sub images"), GroupName: "reddit", Name: "/r/images", IsActive: true, MinRefresh: 300}
//    ch2 := model.Channel{UserId: null.IntFrom(u1.Id), GroupName: "own", Name: "/r/wtf", IsActive: true, MinRefresh: 300}
//    DB.Save(&ch1).Save(&ch2)
//
//    // Test
//    channels, err = dm.Channels(&u1)
//    assert.Nil(t, err, err)
//    assert.Len(t, channels, 2)
//    ChannelsAreEqual(t, ch1, channels[0])
//    ChannelsAreEqual(t, ch2, channels[1])
//
//    getCh1, err := dm.Channel(&u1, ch1.Id)
//    assert.Nil(t, err, err)
//    assert.NotNil(t, getCh1)
//    ChannelsAreEqual(t, ch1, *getCh1)
//}
//
//func TestDefaultDataManager_CreateChannel(t *testing.T) {
//    suffix := helpers.RandomString(8)
//    setup(suffix)
//    defer tearDown(suffix)
//
//    var (
//        dm       manager.DataManager = manager.NewManagerWithConnectors(DB, nil).Data()
//        channel  *model.Channel
//        channels []model.Channel
//        err      error
//    )
//
//    // Insert some test data
//    u1 := model.User{Username: "test_user"}
//    DB.Save(&u1)
//
//    // Test
//    channel, err = dm.CreateChannel(&u1, "group", "name", nil)
//    channels, err = dm.Channels(&u1)
//
//    assert.Nil(t, err, err)
//    assert.Len(t, channels, 1)
//    assert.True(t, channel.UserId.Valid)
//    assert.Equal(t, channel.UserId.Int64, u1.Id)
//    assert.False(t, channel.ServiceProfileId.Valid)
//    assert.Equal(t, "group", channel.GroupName)
//    assert.Equal(t, "name", channel.Name)
//    assert.False(t, channel.Description.Valid)
//    assert.True(t, channel.IsActive)
//    assert.False(t, channel.IsHidden)
//
//    desc := "description"
//    channel, err = dm.CreateChannel(&u1, "group", "name2", &desc)
//    channels, err = dm.Channels(&u1)
//
//    assert.Nil(t, err, err)
//    assert.Len(t, channels, 2)
//    assert.True(t, channel.Description.Valid)
//    assert.Equal(t, "description", channel.Description.String)
//}
//
//func TestDefaultDataManager_UpdateChannel(t *testing.T) {
//    suffix := helpers.RandomString(8)
//    setup(suffix)
//    defer tearDown(suffix)
//
//    var (
//        dm       manager.DataManager = manager.NewManagerWithConnectors(DB, nil).Data()
//        ch1      int64
//        ch2      int64
//        channel  *model.Channel
//        channels []model.Channel
//        err      error
//        desc     string = "description"
//    )
//
//    // Insert some test data
//    u1 := model.User{Username: "test_user"}
//    u2 := model.User{Username: "test_user_2"}
//    DB.Save(&u1).Save(&u2)
//
//    // Validate test data
//    channel, err = dm.CreateChannel(&u1, "group", "name", nil)
//    ch1 = channel.Id
//    assert.Nil(t, err, err)
//    assert.NotNil(t, channel)
//
//    channel, err = dm.CreateChannel(&u2, "group2", "name2", nil)
//    ch2 = channel.Id
//    assert.Nil(t, err, err)
//    assert.NotNil(t, channel)
//
//    channels, err = dm.Channels(&u1)
//    assert.Len(t, channels, 1)
//    channels, err = dm.Channels(&u2)
//    assert.Len(t, channels, 1)
//
//    // Tests
//
//    // Try to update other user's channel
//    channel, err = dm.UpdateChannel(&u2, ch1, "group33", "name33", &desc)
//    assert.NotNil(t, err)
//    assert.Nil(t, channel)
//
//    // Update channel with description and do fresh GET then compare values
//    channel, err = dm.UpdateChannel(&u1, ch1, "group33", "name33", &desc)
//    freshChannel, err2 := dm.Channel(&u1, ch1)
//
//    assert.Nil(t, err, err)
//    assert.Nil(t, err2)
//    assert.Equal(t, "group33", channel.GroupName)
//    assert.Equal(t, "group33", freshChannel.GroupName)
//    assert.Equal(t, "name33", channel.Name)
//    assert.Equal(t, "name33", freshChannel.Name)
//    assert.True(t, channel.Description.Valid)
//    assert.True(t, freshChannel.Description.Valid)
//    assert.Equal(t, desc, channel.Description.String)
//    assert.Equal(t, desc, freshChannel.Description.String)
//
//    // Update channel without description and do fresh GET then compare values
//    channel, err = dm.UpdateChannel(&u2, ch2, "group33", "name33", nil)
//    freshChannel, err2 = dm.Channel(&u2, ch2)
//
//    assert.Nil(t, err, err)
//    assert.Nil(t, err2)
//    assert.Equal(t, "group33", channel.GroupName)
//    assert.Equal(t, "group33", freshChannel.GroupName)
//    assert.Equal(t, "name33", channel.Name)
//    assert.Equal(t, "name33", freshChannel.Name)
//    assert.False(t, channel.Description.Valid)
//    assert.False(t, freshChannel.Description.Valid)
//}
//
//func TestDefaultDataManager_DeleteChannel(t *testing.T) {
//    suffix := helpers.RandomString(8)
//    setup(suffix)
//    defer tearDown(suffix)
//
//    var (
//        dm       manager.DataManager = manager.NewManagerWithConnectors(DB, nil).Data()
//        ch1      int64
//        channel  *model.Channel
//        channels []model.Channel
//        err      error
//    )
//
//    // Insert some test data
//    u1 := model.User{Username: "test_user"}
//    u2 := model.User{Username: "test_user_2"}
//    DB.Save(&u1).Save(&u2)
//
//    // Validate test data
//    channel, err = dm.CreateChannel(&u1, "group", "name", nil)
//    ch1 = channel.Id
//    assert.Nil(t, err, err)
//    assert.NotNil(t, channel)
//
//    channel, err = dm.CreateChannel(&u2, "group2", "name2", nil)
//    assert.Nil(t, err, err)
//    assert.NotNil(t, channel)
//
//    channels, err = dm.Channels(&u1)
//    assert.Len(t, channels, 1)
//    channels, err = dm.Channels(&u2)
//    assert.Len(t, channels, 1)
//
//    // Tests
//
//    // Try to delete other user's channel
//    err = dm.DeleteChannel(&u2, ch1)
//    assert.NotNil(t, err)
//
//    // Try to delete unexisting channel
//    err = dm.DeleteChannel(&u2, 1000)
//    assert.NotNil(t, err)
//
//    // Delete channel and check if it's gone
//    err = dm.DeleteChannel(&u1, ch1)
//    freshChannel, err2 := dm.Channel(&u1, ch1)
//
//    assert.Nil(t, err, err)
//    assert.Nil(t, freshChannel)
//    assert.NotNil(t, err2)
//
//    channels, err = dm.Channels(&u1)
//    assert.Len(t, channels, 0)
//    channels, err = dm.Channels(&u2)
//    assert.Len(t, channels, 1)
//}
