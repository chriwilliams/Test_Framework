require_relative '../common/base_page'
require_relative 'sections'

module Balance

  class Lots < Common::BasePage

    section :main_nav, MainNav, '#mainnav'
    section :sub_nav, SubNav, '#subnav'
    section :date_picker, Calendar, 'body'
    section :lot_list, Table, '#lots_list'

    # lots list page elements
    element :create_lot_btn, '#create_lot_button' #button
    elements :lot_names, '#lots_list td:nth-child(1) a' #collection of cells

    # lots/new elements
    element :lot_id, '#lot_name' #input text field
    element :expiry_date, '#lot_expiry_date' #calendar picker
    element :depot, '#lot_depot_id' #dropdown
    element :pack_run_id, '#lot_packrun'
    element :unnumbered, '#lot_has_unnumbered_items' #checkbox
    element :article_type, '#lot_article_type_id' #dropdown
    element :quantity, '#lot_unnumbered_items_quantity' #input text field

    # lots/edit
    element :add_items, '#add_items_to_lot_button' #button
    element :release, '#release_button' #button
    element :revoke_release, '#revoke_release_lot_button' #button
    element :save, '#save_button'

    # release/revoke modal
    element :release_audit, '#modal #audit_reason' #input text field
    element :modal_revoke_release, '#modal #revoke_release' #button
    element :release_agree, '#modal #agree' #checkbox
    element :confirm_release, '#modal #confirm_release_button' #button

    # create lot modal
    element :yes_add_items, '#add-items' #button
    element :just_create_lot, '.modal-content #add-items + button' #button
    element :unnumbered_create, '#modal-buttons button:nth-child(1)' #button
    element :create_lot_button_modal, '#modal-buttons button.btn-default:nth-child(1)' #button

    # lot add items
    elements :article_checkboxes, '.item_check' #collection checkboxes
    elements :article_names, '#article_types td:nth-child(2)' #collection text fields
    element :item_search, '#search_button' #button
    element :add_items_found, '#add_items_button' #button



    # Selects a lot from the lot list table
    # @param name [string] name of the lot to select
    def select_lot(name)
      index = get_element_index(lot_names, name)
      lot_names[index].click
    end

    # Add items to a Lot
    # @param lot_name [string] the name of the lot
    # @param article_types [string] the article types to search for delimited by ','
    def add_items_to_lot(lot_name, article_types)
      select_lot(lot_name)
      add_items.click
      articles = article_types.split(",")
      # set all to false first
      article_checkboxes.each { |at| at.set(false) }
      # go through each article passed to set checkboxes
      articles.each do |article|
        index = get_element_index(article_names, article)
        article_checkboxes[index].set(true)
      end
      item_search.click
      add_items_found.click
    end

    # Releases the specified lot
    # @param lot_name [string] the name of the lot
    # @param release_signature [string] the signature of the person releasing the lot
    def release_lot(lot_name, release_signature)
      select_lot(lot_name)
      release.click
      release_agree.set(true)
      release_audit.set release_signature
      confirm_release.click
    end

    # Revoke the release of the specified lot
    # @param lot_name [string] the name of the lot
    # @param revoke_reason [string] the reason for revoking the release
    def revoke_release_lot(lot_name, revoke_reason=nil)
      select_lot(lot_name)
      revoke_release.click
      release_audit.set revoke_reason if revoke_reason != nil
      modal_revoke_release.click
    end

    # Creates a lot based on the options passed
    # @param options_table [table] the options to create a lot
    def create_lot(options_table)
      unnumbered_lot = false
      create_lot_btn.click
      options_table.raw.each do |row|
        case row[0].downcase
          when 'lot name'
            lot_id.set row[1]
          when 'expiry date'
            date_picker.select_date(row[1])
          when 'article type'
            unnumbered.set(true)
            article_type.select row[1]
            unnumbered_lot = true
          when 'depot'
            depot.select row[1]
          when 'unnumbered quantity'
            quantity.set row[1]
          when 'pack run id'
            pack_run_id.set row[1]
          else
            raise "Option #{row[0]} is not a valid argument for a lot"
        end
      end
      create_lot_btn.click
      if unnumbered_lot
        create_lot_button_modal.click
      else
        just_create_lot.click
      end

    end

    # Updates fields of an existing lot
    # @param lot_name [string] the name of the lot to update
    # @param options_table [table] the options to update for the lot
    def update_lot_properties(lot_name, options_table)
      select_lot(lot_name)
      options_table.raw.each do |row|
        case row[0].downcase
          when 'lot name'
            lot_id.set row[1]
          when 'expiry date'
            date_picker.select_date(row[1])
          when 'depot'
            depot.select row[1]
          when 'unnumbered quantity'
            quantity.set row[1]
          when 'pack run id'
            pack_run_id.set row[1]
          else
            raise "Option #{row[0]} is not a valid argument for a lot"
        end
      end
    end

  end
end

