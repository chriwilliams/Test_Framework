require_relative '../common/base_page'
require_relative 'sections'

module Balance

  class ByItems < Common::BasePage

    section :main_nav, MainNav, '#mainnav'
    section :sub_nav, SubNav, '#subnav'
    section :expiry_date, Calendar, 'body'

    element :download_inventory_button, '#download_button' #button
    element :search_selector, '#search_selector' #dropdown
    element :search_by_item_number, '#search_by_item_number' #text field
    element :waste_items, '#waste_items_button' #button
    element :quarantine_items, '#quarantine_items_button' #button
    element :depot_fat_header, '#depot_selection' #dropdown
    element :fat_headers, '#fatheaders_locations label' #fat headers
    element :fat_header_drop, '#fatheaders_locations select' #fat header dropdown
    element :clear_search, '#clear_search_button' #clear search
    element :by_item_button, '#view_types a.btn:nth-child(2)' #button
    element :site_fat_header, '#site_selection' #dropdown
    element :shipment_fat_header, '#shipment_selection' #dropdown
    elements :skinny_headers, '#statusbar label' #collection headers
    element :search_button, '#add_search_by_button' #button
    element :clear_search, '#clear_search_button' #button
    element :lot_search, '#search_by_lot' #dropdown
    element :article_type_search, '#search_by_article_type' #button
    element :sequence_start, '#search_by_sequence_number_start' #text field
    element :sequence_end, '#search_by_sequence_number_end' #text field
    element :toggle_all, '#toggle_all' #checkbox
    element :waste, '#waste_items_button' #button
    element :waste_reason_field,  '#audit_reason' #text field
    element :waste_reason_button, '#waste_items_button' #button
    elements :headers_all, '#fatheaders_locations select' #collection headers
    element :quarantine_button, '#quarantine_items_button' #button
    element :quarantine_reason_field, '#quarantine_audit_reason'#text field
    element :create_quarantine_button, '#create_quarantine' #button
    elements :item_number_column, '#manage_attributes td a' #collections column
    elements :checkbox_selector, '#inventory_item_list td:nth-child(1) input' #collections checkbox


    #This method selects a specific status skinny header
    #@param sh_name[string] name of the specified skinny header status
    def skinny_header_selection(sh_name)
     index = get_element_index(skinny_headers, sh_name)
     skinny_headers[index].click
    end

    #This method does a search by Item Number
    #@param item_name[string] name of the item(s)
    def search_by_item(item_name)
      search_selector.select("Item Number")
      search_by_item_number.click
      search_by_item_number.set item_name
      sleep 1
      search_button.click
    end

    #This method does a search by Lot
    #@param lot_name[string] name of the lot
    def search_by_lot(lot_name)
      search_selector.select("Lot")
      lot_search.select(lot_name)
      search_button.click
    end

    #This method does a search by article type
    #@param at_name[string] name of the article types
    def search_by_article_type(at_name)
      search_selector.select("Article Type")
      article_type_search.select(at_name)
      search_button.click
    end

    #This method does a search by sequence
    #@param sq_start[string] number of the starting sequence
    #@param sq_end[string] name of the ending sequence
    def search_by_sequence(sq_start,sq_end)
      search_selector.select("Sequence Range")
      sequence_start.set(sq_start)
      sequence_end.set(sq_end)
      sleep 1
      search_button.click
    end

    #This method wastes items
    #@param reason_text_w[string] text to fill in the reason field
    def waste_item(reason_text_w)
      toggle_all.click
      waste.click
      waste_reason_field.set(reason_text_w)
      waste_reason_button.click
    end

    #This method quarantines items
    #@param reason_text_q[string] text to fill in the reason field
    def quarantine_item(reason_text_q)
      toggle_all.click
      quarantine_button.click
      quarantine_reason_field.set(reason_text_q)
      create_quarantine.click
    end

    # Search by expiry date
    # @param start_date [string] the start date to search. format: MMM DD YYYY
    # @param end_date [string] the end date to search. format: MMM DD YYYY
    def search_by_expiry(start_date, end_date)
      search_selector.select("Expiry Date")
      expiry_date.select_date(start_date, 0)
      expiry_date.select_date(end_date, 1)
      search_button.click
    end
  end
end
