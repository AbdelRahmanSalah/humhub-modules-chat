<?php

namespace humhub\modules\chat\models;

use Yii;
use humhub\components\ActiveRecord;

class UserChatRoom extends ActiveRecord
{
    public static function tableName()
    {
        return "user_chat_room";
    }

    public function getChatRoom()
    {
        return $this->hasOne(ChatRoom::className(), ['id' => 'chat_room_id']);
    }

    public function getUser()
    {
        return $this->hasOne(User::className(), ['id' => 'user_id']);
    }
}
?>