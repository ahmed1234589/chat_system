class  ApplicationRepresenter
  def initialize(applications)
    @applications = applications
  end


  def as_json_arr
    applications.map do |application|
    {
      token: application.token,
      name: application.name,
      chat_count: application.chat_count
    }
    end
  end

  def as_json
    {
      token: applications.token,
      name: applications.name,
      chat_count: applications.chat_count
    }
  end

  private

    attr_reader :applications
end
