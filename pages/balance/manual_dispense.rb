require_relative '../common/base_page'
require_relative 'sections'

module Balance

  class ManualDispense < Common::BasePage

    section :main_nav, MainNav, '#mainnav'
    section :sub_nav, SubNav, '#subnav'

    element :visit_name, '#subject_subject_visit_visit_id' #field
    element :article_type, '#manual_dispensation_article_type' #field
    element :reason, '#subject_inventory_items_audit_reason' #field
    element :man_dispense_table, '#inventory_items' #table
    elements :radio_button, '#inventory_items input' #radiobutton
    elements :item_number, '#inventory_items td:nth-child(3)' #field
    element :confirm, '#confirm_dispense' #button
    element :dispense, '#dispense' #button
    elements :quantity_to_dispense, '#unnumbered_inventory_items td:nth-child(4) input' #field

#This method manually dispenses items to a subject
#@param item_name[string] name of the specified item that is going to be dispensed.
    def manual_dispense_item(item_name, count = nil)
      index = get_element_index(item_number, item_name)
      radio_button[index].set(true)
      quantity_to_dispense[index].set count unless count == nil
      confirm.click
      dispense.click
    end
  end
end
