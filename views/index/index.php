<?php

use yii\helpers\Html;
use yii\helpers\Url;
use humhub\modules\chat\Assets;

Assets::register($this);
?>
<div class="container" id="messagesContainer">
    
</div>
<script>
$(document).ready(function () {

    var app = Elm.Main.embed(document.getElementById('messagesContainer'));
    
    var user = {
        name: "<?= Yii::$app->user->getIdentity()->displayName ?>",
        profileImg: "<?= Yii::$app->user->getIdentity()->getProfileImage()->getUrl() ?>",
        profileLink: "<?= Yii::$app->user->getIdentity()->url ?>",
    }
    var pubnub = new PubNub({
        subscribeKey: "sub-c-5fe73656-0f89-11e7-9faf-0619f8945a4f",
        publishKey: "pub-c-e870a40c-1e51-490d-b82a-8a2821a445f1",
    })

    var pubNubConfig = {
        channel : "user." +  "<?= Yii::$app->user->guid ?>",
    }
    // var messageEntry =  
    // {
    //     entryGuid : Uuid
    // ,   message : "hello world Testinginging"
    // ,   chatRoomGuid : Uuid
    // ,   sender :  {"name":"abdo salah","profileImg":"/img/default_user.jpg","profileLink":"/index.php?r=user%2Fprofile&uguid=2205359c-7fdc-4ea3-a724-539b8f284c8b"}
    // }
    
   
    
    
    app.ports.sendChatMessage.subscribe(function(message) {
        
        var publishConfig = {
            channel : pubNubConfig['channel'],
            message : message,
            storeInHistory: true
        }
        console.log(publishConfig)
        // pubnub.publish(publishConfig, function(status, response) {
        //     console.log("publish");
        //     console.log(status, response);
        // })
    })

    app.ports.fetchRoomEntryList.subscribe(function(roomGuid) {
        
        console.log(roomGuid)

        pubnub.history(
        {
            channel: pubNubConfig['channel'],
            count: 50, // how many items to fetch
        },
        function (status, response) {
            // app.ports.newChatEntries.send(response);            
            console.log("status", response)
        });
    })

    pubnub.subscribe({
        channels: ['conversation'] 
    });

    pubnub.addListener({
    
        message: function(m) {
            var channelName = m.channel; // The channel for which the message belongs
            var msg = m.message; // The Payload
            console.log("listen", msg)
            app.ports.newChatEntry.send(msg);
        },
        presence: function(p) {
            console.log("presence", p)           
        },
        status: function(s) {
            // handle status
            console.log("status", s)
        }
    })
})
</script>