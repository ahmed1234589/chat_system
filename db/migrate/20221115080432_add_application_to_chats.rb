class AddApplicationToChats < ActiveRecord::Migration[7.0]
  def change
    add_reference :chats, :application
  end
end
