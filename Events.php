<?php

namespace humhub\modules\chat;

use Yii;
use yii\helpers\Url;
// use humhub\modules\mail\widgets\NewMessageButton;
use humhub\modules\chat\widgets\Notifications;

class Events extends \yii\base\Object
{
    /**
     * On build of the TopMenu, check if module is enabled
     * When enabled add a menu item
     *
     * @param type $event
     */
    public static function onTopMenuInit($event)
    {
        if (Yii::$app->user->isGuest) {
            return;
        }

        $event->sender->addItem(array(
            'label' => Yii::t('ChatModule.base', 'Chat'),
            'url' => Url::to(['/chat/chat/index']),
            'icon' => '<i class="fa fa-weixin"></i>',
            'isActive' => (Yii::$app->controller->module && Yii::$app->controller->module->id == 'chat'),
            'sortOrder' => 400,
        ));
    }

    public static function onNotificationAddonInit($event)
    {
        if (Yii::$app->user->isGuest) {
            return;
        }
        $event->sender->addWidget(Notifications::className(), array(), array('sortOrder' => 90));
    }

}
