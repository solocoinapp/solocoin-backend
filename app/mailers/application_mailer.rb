class ApplicationMailer < ActionMailer::Base
  default from: 'SoloCoin <admin@solocoin.app>', reply_to: 'admin@solocoin.app'
  layout 'mailer'
end
