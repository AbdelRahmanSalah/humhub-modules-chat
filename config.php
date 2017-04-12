<?php

use humhub\modules\user\models\User;
use humhub\widgets\TopMenu;
use humhub\widgets\NotificationArea;
use humhub\modules\user\widgets\ProfileHeaderControls;

return [
    'id' => 'chat',
    'class' => 'humhub\modules\chat\Module',
    'namespace' => 'humhub\modules\chat',
    'urlManagerRules' => [
        'chat/<controller:[\w-]+>' => 'chat/<controller>',
        'GET chat/<controller:[\w-]+>/get-rooms' => 'chat/<controller>/get-rooms',
        'chat/<controller:[\w-]+>/<url:[a-zA-Z0-9-]+>' => 'chat/<controller>',
        'chat/<controller:[\w-]+>/u/<url:[a-zA-Z0-9-]+>' => 'chat/<controller>',
    ],
    'events' => [
        ['class' => TopMenu::className(), 'event' => TopMenu::EVENT_INIT, 'callback' => ['humhub\modules\chat\Events', 'onTopMenuInit']],
        ['class' => NotificationArea::className(), 'event' => NotificationArea::EVENT_INIT, 'callback' => ['humhub\modules\chat\Events', 'onNotificationAddonInit']],
    ],
];
?>