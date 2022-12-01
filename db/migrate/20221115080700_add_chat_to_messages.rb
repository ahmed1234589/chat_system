class AddChatToMessages < ActiveRecord::Migration[7.0]
  def change
    add_reference :messages, :chat
  end
end
