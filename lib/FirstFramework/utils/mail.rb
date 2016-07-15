require 'gmail'
require 'FirstFramework/utils/exceptions'

module FirstFramework
  module Utils
    module Email
      class Mail < Gmail::Client::Base

        attr_reader :gmail

        def initialize(username, options = {})
          @gmail = Gmail.new(username, options)
        end

        # finds the unread invite email from iMedidata
        # @param from [String] the from email address.
        # @param subject [String] the subject of the email.
        # @param newest [Boolean] the subject of the email.
        # @param date [String] the date of the email. Defaults to today's date.
        # @param to [String] the recepient email address.
        def find_email(from, subject=nil, newest=true, date=Time.now, to=nil)
          email_options={}
          email_options[:from]= "#{from}" if from
          email_options[:to]= "#{to}" if to
          email_options[:on]= Date.parse("#{date}") if date
          Message.new do

            @gmail.inbox.find(:unread,email_options).each do |email|
              subject.nil? || email.message.subject == subject
            end.send(newest ? :last : :first)

          end
        end

        # finds and deletes the email
        # @param from [String] the from email address.
        # @param subject [String] the subject of the email.
        # @param date [String] the date of the email. Defaults to today's date.
        def delete(from, subject=nil, date=Time.now)
          raise SubjectNil if subject.nil?
          @gmail.inbox.find(:all, on: Date.parse("#{date}"), from: "#{from}", subject: subject).each do |email|
            email.delete!
          end
        end

        # logs out of Mail
        def logout
          @gmail.logout
        end

        # whether or not you are logged in
        def logged_in?
          @gmail.logged_in?
        end

        # sends mail using configured email address
        # @param addr [String] the address to send to
        # @param title [String] the subject of the email
        # @param contents [String] the glob of the email
        def send_mail(addr, title, contents)
          if logged_in?
            @gmail.deliver do
              to addr
              subject title
              html_part do
                content_type 'text/html; charset=UTF-8'
                body contents
              end
              delivery_method :smtp, {address: 'smtp.lab1.hdc.mdsol.com', port: 80} if `hostname` =~ /hdc505lb/
            end
          end
        end

      end

      class Message
        attr_reader :email, :url, :body

        def initialize()
          if block_given?
            @email = yield
            raise InviteEmailNotFoundError, 'Invitation email was not found' if @email.nil?
            @body = @email.html_part.body.dup
          end
          self
        end

        def email
          @email
        end

        def subject
          @email.message.subject
        end

        def body
          raise InviteBodyNotFoundError, 'Invitation body was not found' if @body.nil?
          @body.decoded
        end

        def url
          body.scan(/https?:\/\/\S+imedidata\.\S+\/users\S+\/activation/).first.delete("'")
        rescue => e
          raise URLNotFoundError, "URL is missing or does not contain a valid invite link. Inner Exception: #{e.to_s}"
        end
      end

      class InviteEmailNotFoundError < FirstFramework::Utils::Exceptions::FirstFrameworkException;
      end
      class InviteBodyNotFoundError < FirstFramework::Utils::Exceptions::FirstFrameworkException;
      end
      class URLNotFoundError < FirstFramework::Utils::Exceptions::FirstFrameworkException;
      end
      class SubjectNil < FirstFramework::Utils::Exceptions::FirstFrameworkException;
      end
    end
  end
end
