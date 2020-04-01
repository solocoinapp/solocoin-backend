class ApplicationMailer < ActionMailer::Base
  default from: 'CoronaGo <admin@coronago.co>', reply_to: 'admin@coronago.co'
  layout 'mailer'
end
