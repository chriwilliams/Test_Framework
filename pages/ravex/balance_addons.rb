require_relative 'edc'
require_relative 'sections'

module Ravex
  class BalanceAddons < Edc

    section :pagination, Pagination, 'div[class="paginate clearfix"]'

    attr_reader :balance_addons

    # Replace items
    # @param label [string] the field name
    # @param items [string] the items to replace. 'all' for all items
    # @param unn_count [integer] the unnumbered item count to replace
    def replace_items(label, items, unn_count = nil)
      field_detect(label)
      # open the replace item inline modal
      @field.find('a.pointer-cursor').click

      sleep(2)

      replace_modal = @field.find('.replacekit-modal')

      # find and select items
      kits = replace_modal.all("[ng-class*='kit']")
      checkboxes = replace_modal.all("input[type='checkbox']")
      unnumbered = replace_modal.all("input[type='number']")

      if items == 'all'
        checkboxes.each do |x|
          x.click
        end
      else
        items.split(',').each do |item|
          index = get_element_index(kits, item)
          checkboxes[index].click
          unnumbered[index].set unn_count unless unn_count == nil
        end
      end

      # click replace
      replace_btn = replace_modal.find('.btn-primary')
      replace_btn.click
      # Wait for replacement (try to update this in the future without hard wait)
      sleep(5)
      success_message = replace_modal.find('.input-validation-success')
      if success_message.text != 'Kits Replaced. Dispense the kits below'
        raise "Replace #{items} items for field #{label} failed"
      end

      # Click complete button to close modal
      replace_modal.find('.btn-default').click
    end

  end

end

