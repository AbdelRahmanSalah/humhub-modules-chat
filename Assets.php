<?php

namespace humhub\modules\chat;

use yii\web\AssetBundle;

class Assets extends AssetBundle
{

    public $css = [
        'mail.css',
    ];
    public $js = [
        'chat.js',
        'pubnub.4.5.0.js'
    ];

    public function init()
    {
        $this->sourcePath = dirname(__FILE__) . '/assets';
        parent::init();
    }

}
