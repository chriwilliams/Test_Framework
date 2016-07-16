require_relative '../common/base_page'
require_relative 'sections'

module Rave
  class Matrices < Common::BasePage

    section :header, Header, 'td[class^="HeaderIconBar"]'
    section :navigation_tabs, NavigationTabs, 'table[id$="PgHeader_TabTable"]'

    element :add_new_matrix, 'a[id$="InsertForm"]'
    element :new_matrix_name, 'input[id$="Name"]'
    element :new_matrix_oid, 'input[id$="OID"]'
    element :allow_add_checkbox, 'input[id$="AllowAddCheckBox"]'
    element :matrix_creation_failure_message, 'span[id$="Content_MsgLabel"]'


    # adds a matrix to a draft given its parameter
    # @param name [String] name of the Matrix
    # @param oid [String] oid for the Matrix; usually a unique string
    def add_matrix(name, oid, allow_add = false)
      wait_for_add_new_matrix
      add_new_matrix.click
      new_matrix_name.set name
      new_matrix_oid.set oid unless oid.nil?
      allow_add_checkbox.set true if allow_add = true
      page.find_link('Update').click
      sleep 1
    end

  end
end
