<?php

namespace humhub\modules\chat\widgets;

use humhub\components\Widget;

class Notifications extends Widget
{

    /**
     * Creates the Wall Widget
     */
    public function run()
    {
        return $this->render('notifications');
    }

}

?>