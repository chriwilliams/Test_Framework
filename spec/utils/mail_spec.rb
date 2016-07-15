require_relative '../spec_helper'

describe FirstFramework::Utils::Email::Mail do

  context "single email with url" do
    before (:all) do
      $config = FirstFramework::Utils::Configuration.new
      @mail = FirstFramework::Utils::Email::Mail.new($config['utils']['gmail']['gmail_user_addr'], $config['utils']['gmail']['gmail_user_password'])
      @mail.send_mail $config['utils']['gmail']['gmail_user_addr'], "You have been invited to join iMedidata", File.open(Dir.glob(File.join("**", "mail_invite_body.html")).first, 'rb').read
      sleep 15
      @invite = @mail.find_email($config['utils']['gmail']['gmail_user_addr'], 'You have been invited to join iMedidata')
    end

    after (:all) do
      @mail.delete $config['utils']['gmail']['gmail_user_addr'], 'You have been invited to join iMedidata'
      @mail.logout
    end

    it 'should find an invite email' do
      expect(@invite).to be_a FirstFramework::Utils::Email::Message
    end

    it 'should get the invitation' do
      expect(@invite.body).to be_a String
    end

    it 'should get the URL in the invitation' do
      expect { @invite.url }.not_to raise_error
    end

    it 'should raise an error when the invite email is not found' do
      @mail.delete $config['utils']['gmail']['gmail_user_addr'], 'You have been invited to join iMedidata'
      expect { @mail.find_email($config['utils']['gmail']['gmail_user_addr']).email }.to raise_error FirstFramework::Utils::Email::InviteEmailNotFoundError
    end

    it 'should raise an error when the subject is nil on delete' do
      expect { @mail.delete $config['utils']['gmail']['gmail_user_addr'] }.to raise_error FirstFramework::Utils::Email::SubjectNil
    end
  end

  context "multiple emails" do
    before (:each) do
      $config = FirstFramework::Utils::Configuration.new
      @email_addr = $config['utils']['gmail']['gmail_user_addr']
      @mail = FirstFramework::Utils::Email::Mail.new(@email_addr, $config['utils']['gmail']['gmail_user_password'])
    end

    after (:each) do
      @mail.logout
    end

    it 'should raise an error when the URL is not found' do
      @mail.send_mail $config['utils']['gmail']['gmail_user_addr'], "mail with invite missing", File.open(Dir.glob(File.join("**", "mail_noinvite_body.html")).first, 'rb').read
      sleep 15
      @noinvite = @mail.find_email($config['utils']['gmail']['gmail_user_addr'], 'mail with invite missing')
      @mail.delete @email_addr, "mail with invite missing"
      expect { @noinvite.url }.to raise_error FirstFramework::Utils::Email::URLNotFoundError
    end

    it 'should return older email from the sender when newest is set to false' do
      @mail.send_mail $config['utils']['gmail']['gmail_user_addr'], "old invite email for old", File.open(Dir.glob(File.join("**", "mail_invite_body.html")).first, 'rb').read
      sleep 5
      @mail.send_mail $config['utils']['gmail']['gmail_user_addr'], "new invite email for old", File.open(Dir.glob(File.join("**", "mail_invite_body.html")).first, 'rb').read
      sleep 15
      @older_invite = @mail.find_email(@email_addr, nil, false)
      sub = @older_invite.subject
      @mail.delete @email_addr, "old invite email for old"
      @mail.delete @email_addr, "new invite email for old"
      expect(sub).to eq("old invite email for old")
    end

    it 'should return newer email from the sender by default' do
      @mail.send_mail $config['utils']['gmail']['gmail_user_addr'], "old invite email for new", File.open(Dir.glob(File.join("**", "mail_invite_body.html")).first, 'rb').read
      sleep 5
      @mail.send_mail $config['utils']['gmail']['gmail_user_addr'], "new invite email for new", File.open(Dir.glob(File.join("**", "mail_invite_body.html")).first, 'rb').read
      sleep 15
      @newer_invite = @mail.find_email(@email_addr)
      sub = @newer_invite.subject
      @mail.delete @email_addr, "old invite email for new"
      @mail.delete @email_addr, "new invite email for new"
      expect(sub).to eq("new invite email for new")
    end
  end

  context "A specific email recipient in an email thread" do

    before (:all) do
      $config = FirstFramework::Utils::Configuration.new
      $faker = FirstFramework::Utils::FirstFrameworkFaker

      @number1 = $faker.number.number(10)
      @number2 = $faker.number.number(10)
      @number3 = $faker.number.number(10)
      @number4 = $faker.number.number(10)

      @mail = FirstFramework::Utils::Email::Mail.new($config['utils']['gmail']['gmail_user_addr'], $config['utils']['gmail']['gmail_user_password'])
      @mail.send_mail 'jenkins_ci+' + @number1 + '@mdsol.com', "You have been invited to join iMedidata", File.open(Dir.glob(File.join("**", "mail_invite_body.html")).first, 'rb').read
      sleep 5
      @mail.send_mail 'jenkins_ci+' + @number2 + '@mdsol.com', "You have been invited to join iMedidata", File.open(Dir.glob(File.join("**", "mail_invite_body.html")).first, 'rb').read
      sleep 5
      @mail.send_mail 'jenkins_ci+' + @number3 + '@mdsol.com', "You have been invited to join iMedidata", File.open(Dir.glob(File.join("**", "mail_invite_body.html")).first, 'rb').read
      sleep 5
      @mail.send_mail 'jenkins_ci+' + @number4 + '@mdsol.com', "You have been invited to join iMedidata", File.open(Dir.glob(File.join("**", "mail_invite_body.html")).first, 'rb').read
      sleep 20
    end

    after (:all) do
      @mail.delete $config['utils']['gmail']['gmail_user_addr'], 'You have been invited to join iMedidata'
      @mail.logout
    end

    it 'should find an email sent to a particular email address from multiple emails in a thread' do
      @findParticularUser = @mail.find_email($config['utils']['gmail']['gmail_user_addr'], 'You have been invited to join iMedidata',true, Time.now,'jenkins_ci+' + @number2 + '@mdsol.com')
      expect(@findParticularUser).to be_a FirstFramework::Utils::Email::Message
      @mail.delete @email_addr, "You have been invited to join iMedidata"
    end

    it 'should find an email sent to a particular email address' do
      @inviteParticularUser = @mail.find_email($config['utils']['gmail']['gmail_user_addr'], 'You have been invited to join iMedidata',true, Time.now,'jenkins_ci+' + @number4 + '@mdsol.com')
      expect(@inviteParticularUser).to be_a FirstFramework::Utils::Email::Message
    end
  end
end
