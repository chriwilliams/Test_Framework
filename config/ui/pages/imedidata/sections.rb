require_relative '../common/base_section'

module Imedidata
  class Header < Common::BaseSection

    element :logout_link, '#logout'
    element :user_name, '#user.btn-group a[data-toggle="dropdown"]'

    def logout
      user_name.click
      logout_link.click
    end

    def go_home
      link = find(:css, 'a[class="home"]')
      link.click
    end

  end
end