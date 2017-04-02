<?php 

namespace humhub\modules\chat\controllers;

use Yii;
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

    public function actionIndex()
    {
        return $this->render('index', []);
    }

    public function actionGetRooms()
    {
        Yii::$app->response->format = 'json';

        $offset = (int) Yii::$app->request->get('offset', 0);
        
        $query = UserChatRoom::find();
        $query->leftJoin('chat_room', 'chat_room_id = chat_room.id');
        $query->where(["user_chat_room.user_id" => Yii::$app->user->id]);
        $query->orderBy('chat_room.updated_at DESC');
        
        if($offset > 0)
            $query->offset($offset)->limit(20);
        else 
            $query->limit(20);

        $userRooms = $query->all();
        $Rooms = [];
        $results = [];
        foreach ($userRooms as $userRoom) {
            $chatRoom = $userRoom->chatRoom;
            $results []= ArrayHelper::toArray($chatRoom);
        }
        return $results;
    }

    public function actionCreateChatRoom()
    {
        Yii::$app->response->format = 'json';

        $title = Yii::$app->request->get("title", null);
        $userGuids = Yii::$app->request->get("userGuids", null);
        if($userGuids == null)
            return [
                "error" => true
            ,   "result" => "Sorry, You cann't create empty chat room"
            ];
        $chatRoom = new ChatRoom();
        $chatRoom->title = $title;
        if($chatRoom->validate() && $chatRoom->save()) {

        } else {
            return [
                "error" => true
            ,   "result" => $chatRoom->errors    
            ];
        }
    } 

}

?>
