class Contact < MailForm::Base
  attribute :name,      validate: true
  attribute :email,     validate: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :phone,     validate: true
  attribute :message
  attribute :nickname,  captcha: true

  def headers
    {
      :subject => "upSpace Message",
      :to => "hello@upspace.ca",
      :from => %("#{name}" <#{email}>)
    }
  end
end
