class UserNotifierMailer < ApplicationMailer
  require 'sendgrid-ruby'
  include SendGrid

  def welcome_email(user)
    @organization = Organization.first
    @user = user
    from = Email.new(email: 'somosmas.notificaciones@gmail.com')
    to = Email.new(email: @user.email)
    subject = 'Te damos la bienvenida!'
    template = render :welcome_email
    content = Content.new(type: 'text/html', value: template)
    mail = Mail.new(from, subject, to, content)
    send_email(mail)
  end

  def new_contact(user)
    @user = user
    from = Email.new(email: 'somosmas.notificaciones@gmail.com')
    to = Email.new(email: @user.email)
    subject = 'Muchas gracias por registrar su contacto'
    template = render :new_contact
    content = Content.new(type: 'text/html', value: template)
    mail = Mail.new(from, subject, to, content)
    send_email(mail)
  end

  def send_email(mail)
    api_key = Rails.application.credentials.sendgrid_api_key
    sg = SendGrid::API.new(api_key: api_key)
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    puts response.status_code
    puts response.body
    puts response.headers
  end
end
