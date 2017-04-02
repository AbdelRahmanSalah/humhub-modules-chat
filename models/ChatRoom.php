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

    public function rules()
    {
        return [
            [['created_by', 'updated_by'], 'integer'],
            [['title'], 'string', 'max' => 255],
            [['created_at', 'updated_at', 'guid'], 'safe'],
        ];
    }

    public function beforeSave($insert)
    {
        if($insert) {
            $this->guid = \humhub\libs\UUID::v4();
        }

        return parent::beforeSave($insert);
    }

}
?>