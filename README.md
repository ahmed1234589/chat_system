# README


* Description : this code offers REST api for chat system to application , chats related to each application, and messages related to each chat.
    the entities of the project can be created, viewed and edited

* Installation : to get the project working we need to get Ruby (3.1.2) installed , Rails 7, and mysql database installed on you machine, and check the database.yml file to match the configuration for the data base
  - run the following commands from the root directory of the project
    - bundle install
    - rails db:create
    - rails db:migrate
    - rails server
    - last thing, we can test the end point by sending request using Postman

* Request Examples
  * Application
    * get
      * curl --location --request GET 'http://127.0.0.1:3000/api/v1/applications'
      
    * create
      * curl --location --request POST 'http://127.0.0.1:3000/api/v1/applications' ^
        --header 'Content-Type: application/json' ^
        --data-raw '{
        "name": "place your app name"
        }'
      
    * update
      * curl --location --request PUT 'http://127.0.0.1:3000/api/v1/applications/<Place your app token>' ^
        --header 'Content-Type: application/json' ^
        --data-raw '{
        "name": "place you app name"
        }'
      
  * Chat
    * get
      * curl --location --request GET 'http://127.0.0.1:3000/api/v1/chats/'
      
    * get chats for specific application
      * curl --location --request GET 'http://127.0.0.1:3000/api/v1/chats/<place your application token>'
    
    * create chats
      * curl --location --request POST 'http://127.0.0.1:3000/api/v1/chats' ^
        --header 'Content-Type: application/json' ^
        --data-raw '{
        "token": "<place you app token>>"
        }'

  * message
    * get
      * curl --location --request GET 'http://127.0.0.1:3000/api/v1/messages'
    * get messages for specific chat
      * curl --location --request GET 'http://127.0.0.1:3000/api/v1/messages/<place your app token>' ^
        --header 'Content-Type: application/json' ^
        --data-raw '{
        "chat_no": <place the id of the chat specifically created for the app>
        }'
    * create
      * curl --location --request POST 'http://127.0.0.1:3000/api/v1/messages' ^
        --header 'Content-Type: application/json' ^
        --data-raw '{
        "token": "<place your app token>",
        "chat_no": <place the id of the chat specifically created for the app>,
        "message": "<please add the body of the message>"
        }'
    * update
      * curl --location --request PUT 'http://127.0.0.1:3000/api/v1/messages/<place your app token>' ^
        --header 'Content-Type: application/json' ^
        --data-raw '{
        "chat_no" : "<the id of the chat for that specific app>",
        "message_id": "<the id of the message for that specific chat>",
        "body" : "<place the new body of the message>"
        }'