require_relative '../common/base_page'
require_relative 'sections'

module ValidationPortal
  class NewProject < Common::BasePage

    section :header, Header, '#header'
    section :navigation, Navigation, '#navigation'

    element :display_name, 'input[id=project_display_name]'
    element :identifier, 'input[id=project_identifier]'
    element :git_repo, 'input[id=project_github_repo]'
    element :proj_type_product, 'input[id=project_project_type_productmodule]'
    element :proj_type_service, 'input[id=project_project_type_service]'
    element :proj_type_third, 'input[id=project_project_type_3rd_party_product]'
    element :is_visible, 'input[id=project_externally_visible]'
    element :create, 'input[type=submit]'
    element :cancel, 'a[href=/projects]'

    set_url_matcher' /projects/new/'

    # sets the display name
    # @param name [string] the name of the project
    def display_name_set(name)
      display_name.set(name)
    end

    # sets the unique identifier
    # @param id [string] the identifier for the project
    def identifier_set(id)
      identifier.set(id)
    end

    # sets the GitHub repository value
    # @param value [string] the location of the project in GitHub
    def github_repository_set(value)
      git_repo.set(value)
    end

    # sets the type for the project
    # @param type [string] the project type
    def project_type_select(type)
      case type.to_s.downcase
        when 'product/module'
          proj_type_product.set true
        when 'service'
          proj_type_service.set true
        when '3rd part product'
          proj_type_third.set true
        else
          raise "Project Type #{type} not supported"
      end
    end

    # set the checkbox for externally visible
    # @param value [string] true or false on whether or not the project is externally visible to the Auditor role
    def externally_visible_set(value = 'true')
      if value.to_s.downcase == 'true'
        check('')
      else
        uncheck('')
      end
    end

    # clicks the create button
    def project_create
      create.click
    end

    # clicks the cancel button
    def project_cancel
      cancel.click
    end

  end
end
