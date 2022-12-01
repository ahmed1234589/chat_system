module Api
  module V1
    class MessagesController < ApplicationController

      def index
        messages = Message.all
        render json: MessageRepresenter.new(messages).as_json_arr
      end

      def show
        #get the app that contains that chat of the message
        app = Application.find_by_token(params[:id])
        if app
          #get the chat of the message
          chats = Chat.where application_id: app[:id]
          current_chat = chats.find_by_number(params[:chat_no])
          if current_chat
            #get the messages of that chat
            messages = Message.where chat_id: current_chat[:id]
            if messages.count > 0
              render json:MessageRepresenter.new(messages).as_json_arr , status: :found
            else
              render json: "No messages found for specified chat", status: :not_found
            end
          else
            render json: "No chat found for specified id", status: :not_found
          end
        else
          render json: "No Application found for specified token", status: :not_found
        end
      end



      def create
        #get the application that contains that chat of the message
        app = Application.find_by_token(params[:token])
        if app
          #get the chat of the message
          chats = Chat.all.where application_id: app[:id]
          current_chat = chats.find_by_number(params[:chat_no])
          if current_chat.nil?
            render json: "chat no is not found for that application" , status: :not_found
          else
            #lock the chat while creating the new message
            ActiveRecord::Base.transaction do
              current_chat.lock!
              messages = Message.all.where chat_id: current_chat[:id]
              if messages.count > 0
                message = Message.new(body: params[:message], number: (1 + messages.last.number), chat: current_chat)
              else
                message = Message.new(body: params[:message], number: 1, chat: current_chat)
              end
              if message.save
                #update the message count in the chat
                current_chat.update(message_count: messages.count)
                current_chat.save!
                render json: MessageRepresenter.new(message).as_json, status: :created
              else
                render json: message.errors, status: :unprocessable_entity
              end
              #end of the lock on the chat
            end
          end
        else
          render json: "No app found for #{params[:token]}", status: :not_found
        end
      end


      def update
        #get the app that contain the chat of the message
        app = Application.find_by_token(params[:id])
        if app
          #get the chat of the message
          chats = Chat.where application_id: app[:id]
          current_chat = chats.find_by_number(params[:chat_no])
          if current_chat.nil?
            render json: "chat no is not found for that application" , status: :not_found
          else
            messages = Message.where chat_id: current_chat[:id]
            message = messages.find_by_number(params[:message_id])

            if message
              #lock the message while editing
              ActiveRecord::Base.transaction do
                message.lock!
                message.update(body: params[:body])
                message.save!
                render json: "message updated successfully." , status: :ok
              end
              #end of the lock
            else
              render json: "message is not found", status: :not_found
            end
          end
        else
          render json: "application is not found", status: :not_found
        end
      end
    end
  end
end