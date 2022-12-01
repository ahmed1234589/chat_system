module Api
  module V1
    class ChatsController < ApplicationController
      def index
        chats = Chat.all
        render json: ChatRepresenter.new(chats).as_json_arr
      end

      def show
        app = Application.find_by(token: params[:id])
        if app
          chats = Chat.all.where application_id: app[:id]
          if chats.count > 0
            render json: ChatRepresenter.new(chats).as_json_arr, status: :found
          else
            render json: "No chats found for app token #{params[:id]}" ,status: :not_found
          end
        else
          render json: "wrong token : #{params[:id]}"
        end

      end

      def create
        app = Application.find_by_token(params[:token])
        if app
          # only one user shall be allowed to add chats to the application at a time.
          ActiveRecord::Base.transaction do
            app.lock!
            chats = Chat.all.where application_id: app[:id]
            if chats.count > 0
              chat = Chat.new(number: (1+chats.last[:number]) , application: app)
            else
              chat = Chat.new(number: 1 , application: app)
            end
            chat.message_count = 0

            if chat.save
              app.update(chat_count: (chats.count))
              app.save!
              render json: ChatRepresenter.new(chat).as_json, status: :created
            else
              render json: chat.errors, status: :unprocessable_entity
            end
          end
        else
          render json: "wrong token : #{params[:id]}"
        end

      end

      # no need to create an update endpoint as no parameter needs to be updated or assigned by the user
      # we have only the application_chat counter and the application's token reference.

    end
  end
end
