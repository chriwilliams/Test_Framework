def send_mail(title, contents, mail)
  if mail.logged_in?
    mail.deliver do
      to $config['utils']['gmail']['gmail_user_addr']
      subject title
      html_part do
        content_type 'text/html; charset=UTF-8'
        body contents
      end
      delivery_method :smtp, {address: 'smtp.lab1.hdc.mdsol.com', port: 80} if `hostname` =~ /hdc505lb/
    end
  end
end
