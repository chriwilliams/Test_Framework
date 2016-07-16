require_relative '../common/base_page'
require_relative 'sections'

module Balance

  class Shipments < Common::BasePage

    section :main_nav, MainNav, '#mainnav'
    section :sub_nav, SubNav, '#subnav'
    section :shipment_list, Table, '#shipment_list'

    # shipment buttons
    element :create_shipment, '#create_shipment_button' #button
    element :run_ship_algo, '#resupply_button' #button


    # search parameters
    element :name, '#with_name'
    element :destination, '#destination' #dropdown
    element :status, '#status' #dropdown
    element :origin, '#origin' #dropdown
    element :quarantine, '#with_quarantine_status' #dropdown
    element :apply, '#apply_button' #button
    element :reset, '#reset_button' #button

    #shipment list table
    elements :shipment_names, '#shipment_list td:nth-child(1) a' #collection links
    elements :shipment_inventory_items, '#shipment_list td:nth-child(8) a' #collection links
    elements :resend_email_links, '#shipment_list td:nth-child(9) a' #collection links
    element :shipment_list_table, '#shipment_list'

    # Shipment - new/create
    element :destination, '#destination_id' #dropdown
    element :origin, '#origin_id' #dropdown
    element :sequence_range_start, '#sequence_range_start' #input text field
    element :sequence_range_end, '#sequence_range_end' #inpud text field
    # numbered
    elements :article_types_numbered, '#numbered_article_types_table td:nth-child(2)' #collection text fields
    elements :lots_numbered, '#numbered_article_types_table td:nth-child(3) select' #collection dropdowns
    elements :quantities_numbered, '#numbered_article_types_table td:nth-child(5) input' #collection input text fields
    # unnumbered
    elements :article_types_unnumbered, '#unnumbered_article_types_table td:nth-child(2)' #collection text fields
    elements :lots_unnumbered, '#unnumbered_article_types_table td:nth-child(3) select' #collection dropdowns
    elements :quantities_unnumbered, '#unnumbered_article_types_table td:nth-child(5) input' #collection input text fields
    # buttons
    element :search, '#search_button' #button
    element :create_new_shipment, '#create_shipment' #button
    element :cancel, '#search_button + .btn' #button
    element :confirm_create, '#modal-buttons button:nth-child(1)' #button

    # Shipment - Existing
    element :save, '#update' #button
    element :resend_email, '#resend_shipment_email' #button
    element :confirm_transit, '#shipment_in_transit_button' #button
    element :confirm_received, '#shipment_received_button' #button
    element :dissolve, '#shipment_dissolved_button' #button
    element :quarantine, '#new_quarantine' #button

    # Shipment - Quarantine
    element :quarantine_reason, '#quarantine_audit_reason' #input text field
    element :create_quarantine, '#create_quarantine' #button

    # confirm page
    element :confirm, '#confirm_button' #button


    # Searches for a shipment
    # @param shipment [string] name of the shipment
    def search_for_shipment(shipment)
      reset.click
      name.set shipment
      apply.click
    end

    # Opens an existing shipment
    # @param shipment [string] name of the shipment
    def open_shipment(shipment)
      search_for_shipment(shipment)
      index = get_element_index(shipment_names, shipment)
      shipment_names[index].click
    end

    # Confirms a shipment Received
    # @param shipment [string] name of the shipment
    def confirm_receieved(shipment)
      open_shipment(shipment)
      confirm_received.click
      confirm.click
    end

    # Waits for a shipment to be generated, given a specific wait time
    # @param shipment [string] name of the shipment
    # @param time_to_wait [int] the amount of seconds to wait for shipment to be generated
    def wait_for_shipment(shipment, time_to_wait=0)
      timer = Time.now + time_to_wait
      shipment_link = nil
      until shipment_link != nil or Time.now > timer
        search_for_shipment(shipment)
        shipment_link = shipment_names.detect { |s| s.text == shipment}
        sleep 1
        refresh_browser()
      end
      raise "Your shipment, #{shipment} was not found in shipment list table" if shipment_link.nil?
    end

    # Creates a shipment manual shipment
    # @param ship_origin [string] the origin of the shipment
    # @param ship_dest [string] the destination of the shipment
    # @param articles_table [table] articles to be included in shipment
    def create_manual_shipment(ship_origin, ship_dest, articles_table)
      create_shipment.click
      destination.select ship_dest
      origin.select ship_origin
      sleep 1
      articles_table.hashes.each do |row|
        # go through all the numbered article types
        article_types_numbered.each_with_index do |at, index|
          quantities_numbered[index].set row["Quantity"] if at.text.include? row["Article Name"]
        end

        #go through all the unnumbered article types
        article_types_unnumbered.each_with_index do |at, index|
          # checking include? here because article name may contain "Open Label" or "Unnumbered"
          quantities_unnumbered[index].set row["Quantity"] if at.text.include? row["Article Name"]
        end
      end

      search.click if !search[:class].include? "disabled"
      sleep 1

      if create_new_shipment[:class].include? "disabled"
        raise "Could not find any article types passed to create shipment. Check your passed values."
      else
        create_new_shipment.click
        sleep 1
        confirm_create.click
      end
    end

    # To quarantine a shipment
    # @param shipment [string] the shipment number
    # @param reason [string] the audit reason for quarantine
    def quarantine_shipment(shipment, reason)
      open_shipment(shipment)
      quarantine.click
      quarantine_reason.set reason
      create_quarantine.click
    end

  end

end