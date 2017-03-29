<?php

use yii\db\Migration;

class m170329_053705_init_chat_module extends Migration
{
    public function up()
    {
        $this->createTable('chat_room', [
            'id' => 'pk',
            'title' => 'varchar(255) DEFAULT NULL',
            'created_at' => 'datetime NOT NULL',
            'created_by' => 'int(11) NOT NULL',
            'updated_at' => 'datetime NOT NULL',
            'updated_by' => 'int(11) NOT NULL',
        ]);

        $this->createTable('user_chat_room', [
            'id' => 'pk',
            'chat_room_id' => 'int(11) NOT NULL',
            'user_id' => 'int(11) NOT NULL',
            'created_at' => 'datetime NOT NULL',
            'created_by' => 'int(11) NOT NULL',
            'updated_at' => 'datetime NOT NULL',
            'updated_by' => 'int(11) NOT NULL',
        ]);
    }

    public function down()
    {
        echo "m170329_053705_init_chat_module cannot be reverted.\n";

        return false;
    }

    /*
    // Use safeUp/safeDown to run migration code within a transaction
    public function safeUp()
    {
    }

    public function safeDown()
    {
    }
    */
}
