require_relative '../common/base_section'

module ValidationPortal
  class Header < Common::BaseSection

    element :logout_link, '#logout'
    element :user_name, '#user.btn-group a[data-toggle="dropdown"]'

    # Clicks the logout link
    def logout
      user_name.click
      logout_link.click
    end

  end

  class Navigation < Common::BaseSection

    elements :all_tabs, 'a'

    # Go to Validation Portal Home Page
    def go_home
      link = all_tabs.detect {|item| item.text.include? 'Validation Portal'}
      link.click if link
    end

    # Go to iMedidata Home Page
    def go_to_imedidata
      link = all_tabs.detect {|item| item.text.include? 'Home'}
      link.click if link
    end

  end
end
