require_relative '../common/base_page'
require_relative 'sections'

module Balance

  class RandListUpload < Common::BasePage

    section :main_nav, MainNav, '#mainnav'
    section :sub_nav, SubNav, '#subnav'


    element :name, '#randomization_list_name' #text field
    element :block_size, '#randomization_list_acceptable_block_sizes' #text field
    element :header_row_num, '#randomization_list_header_row_number' #text field
    element :upload_file, '#randomization_list_randomization_list_file_attributes_list' #browse file field
    element :next_btn, '#update' #button


    # Uploads a rand list
    # @param list_name [string] name of the rand list
    # @param list_block_size [string] size of the blocks in the rand list
    # @param header [string] the row number of the header
    # @param file_path [string] the file path of the rand list
    def upload_rand_list(list_name,list_block_size,header,file_path)
      name.set list_name
      block_size.set list_block_size
      header_row_num.set header
      attach_file(upload_file, File.expand_path(file_path))
      sleep 2
      next_btn.click
    end
  end
end