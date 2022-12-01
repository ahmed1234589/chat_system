class  MessageRepresenter
  def initialize(messages)
    @messages = messages
  end

  def as_json_arr
    messages.map do |message|
      {
        number: message.number,
        body: message.body,
        chat_no: Chat.find_by(id: message.chat_id).number,
        token: Application.find_by(id: Chat.find_by(id: message.chat_id).application_id).token
      }
    end
  end

  def as_json
    {
      number: messages.number,
      body: messages.body,
      chat_no: Chat.find_by(id: messages.chat_id).number,
      token: Application.find_by(id: Chat.find_by(id: messages.chat_id).application_id).token
    }
  end

  private

  attr_reader :messages

end

