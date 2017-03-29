<?php 

namespace humhub\modules\chat\controllers;

use humhub\components\Controller;
use humhub\modules\chat\models\ChatRoom;
use humhub\modules\chat\models\UserChatRoom;

class IndexController extends Controller
{
    public function behaviors()
    {
        return [
            'acl' => [
                'class' => \humhub\components\behaviors\AccessControl::className(),
            ]
        ];
    }

    public function actionGetMessages()
    {
        Yii::$app->response->format = 'json';

        $query = UserChatRoom::find();
        $query->join(ChatRoom);
        $query->where([UserChatRoom::tableName() . '.user_id' => Yii::$app->user->id]);
        $query->orderBy(ChatRoom::tableName() . '.updated_at DESC');

        $countQuery = clone $query;
        $roomCount = $countQuery->count();
        $pagination = new \yii\data\Pagination(['totalCount' => $roomCount, 'pageSize' => 25]);
        $query->offset($pagination->offset)->limit($pagination->limit);
        $userRooms = $query->all();
        $Rooms = [];
        $results = [];
        foreach ($userRooms as $userRoom) {
            $chatRoom = $userRoom->chatRoom;
            $lastEntry = $chatRoom->getLastEntry();
            $lastEntryUser = $lastEntry->user;
            $results []= 
                array_merge(ArrayHelper::toArray($chatRoom)
                                , ["lastEntry" => array_merge(ArrayHelper::toArray($lastEntry) , ["user" => [
                            "name" => $lastEntryUser->displayName
                        ,   "profileImg" => $lastEntryUser->getProfileImage()->getUrl()
                        ,   "profileLink" => $lastEntryUser->url
                    ]])]
                )
            ; 
        }
        return $results;
    } 

}

?>
