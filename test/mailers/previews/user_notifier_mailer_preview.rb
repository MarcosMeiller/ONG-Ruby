# Preview all emails at http://localhost:3000/rails/mailers/user_notifier_mailer
class UserNotifierMailerPreview < ActionMailer::Preview
    def welcome_email 
        UserNotifierMailer.welcome_email(User.first)
    end
end
