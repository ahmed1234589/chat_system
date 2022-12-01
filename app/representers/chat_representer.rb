class  ChatRepresenter
  def initialize(chats)
    @chats = chats
  end


  def as_json_arr
    chats.map do |chat|
      {
        number: chat.number,
        message_count: chat.message_count,
        token: Application.find_by(id: chat.application_id).token
      }
    end
  end

  def as_json
    {
      number: chats.number,
      message_count: chats.message_count,
      token: Application.find_by(id: chats.application_id).token
    }
  end

  private

  attr_reader :chats
end
