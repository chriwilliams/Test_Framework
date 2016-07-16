require_relative '../common/base_page'
require_relative 'sections'

module Balance

  class Arms < Common::BasePage

    section :main_nav, MainNav, '#mainnav'
    section :sub_nav, SubNav, '#subnav'

    element :name, '#regime_name' #text field
    element :ratio, '#regime_ratio' #text field
    element :code, '#regime_code' #text field
    element :save, '#update' #button
    element :cancel, 'img[alt="Cancel"]' #button
    element :delete, '.center-buttons .button:nth-child(3)' #button

    element :modal_delete_arm, "#modal button[data-method='delete']" #button
    element :modal_cancel, '#modal a.negative' #button

    # Inputs arm fields and saves the page
    # @param arm_name [string] name of the arm
    # @param arm_ratio [string] ratio of the arm
    # @param arm_code [string] code of the arm, only applies to PB arms
    def add_arm(arm_name,arm_ratio,arm_code=nil)
      name.set arm_name
      ratio.set arm_ratio
      code.set arm_code if arm_code != nil
      save.click
    end

    # Deletes an arm and confirms delete arm in modal
    def delete_arm()
      delete.click
      modal_delete_arm.click
    end

  end

end