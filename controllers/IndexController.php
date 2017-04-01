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

    public function actionGetRooms()
    {
        Yii::$app->response->format = 'json';

        $offset = (int) Yii::$app->response->get('offset', 0);
        $query = UserChatRoom::find();
        $query->join(ChatRoom);
        $query->where([UserChatRoom::tableName() . '.user_id' => Yii::$app->user->id]);
        $query->orderBy(ChatRoom::tableName() . '.updated_at DESC');
        
        if($offset > 0)
            $query->offset($offset)->limit(20);
        else 
            $query->limit(20);

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
