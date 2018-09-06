require 'rubygems'
require 'tlsmail'
#require 'net/smtp'
require 'time'

class Gmailer
    def self.send(sender, password, to, subject, body)
        puts "enter self.send"
        content = <<MSG_END
From: #{SENDER}
To: #{to}
Subject: #{subject}

#{body}
MSG_END
        puts "enable tls"
        Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)
        puts "start message"
        Net::SMTP.start('smtp.gmail.com', 587, 'gmail.com', sender, password, :login) do |smtp|
            puts "send message"
            smtp.send_message(content, SENDER, to)
        end
        puts "end message"
    end
end
