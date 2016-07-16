require_relative '../common/base_page'
require_relative 'sections'


module Balance

  class Uploads < Common::BasePage

    section :main_nav, MainNav, '#mainnav'
    section :sub_nav, SubNav, '#subnav'
    section :packlist_list, Table, '#packlist_list'

    element :upload_packlist_btn, '#button_upload_packlist' #button

    # elements for uploading a packlist
    element :name, '#packlist_name' #input text field
    element :item_count, '#packlist_inventory_batch_file_attributes_num_items' #input text field
    element :packlist_upload, 'input#packlist_inventory_batch_file_attributes_batch' #file input
    element :continue, '#update' #button
    element :cancel, '#a.negative.button' #button

    # elements for mapping packlist
    element :next, '#next' #button
    element :accept_mapping, '#save' #button

    # elements for checking packlist status
    elements :pl_names, '#packlist_list td:nth-child(1)' #collection text fields
    elements :pl_status, '#packlist_list td:nth-child(5)'  #collection text fields

    # Uploads a pack list
    # @param pl_name [string] name of the packlist
    # @param pl_count [string] the number of items in the packlist
    # @param pl_path [string] the file path of the packlist
    def upload_packlist(pl_name, pl_count, pl_path)
      upload_packlist_btn.click
      name.set pl_name
      item_count.set pl_count
      # this is needed because the file field is hidden in balance
      Capybara.ignore_hidden_elements = false
      attach_file("Packlist File", File.expand_path(pl_path))
      Capybara.ignore_hidden_elements = true
      continue.click
      accept_mapping.click
      sleep 10
      refresh_browser()
    end

    end

  end
