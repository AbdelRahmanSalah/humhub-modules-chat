<?php

namespace humhub\modules\chat\models;

use Yii;
use humhub\components\ActiveRecord;

class ChatRoom extends ActiveRecord
{
    public static function tableName()
    {
        return "chat_room";
    }

}
?>