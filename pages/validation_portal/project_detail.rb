require_relative '../common/base_page'
require_relative 'sections'

module ValidationPortal
  class ProjectDetail < Common::BasePage

    section :header, Header, '#header'
    section :navigation, Navigation, '#navigation'

    element :project_name, 'div[class=page-header-text]'
    element :favor_project, 'a#favourite'
    element :unfavor_project, 'a#unfavourite'
    element :dev_projects, 'div[id=unreleased_versions]'
    element :rel_projects, 'div[id=released_versions]'
    element :edit_project, 'a#edit_project'
    element :delete_project, 'a#delete_project'
    element :modal, 'div[class=modal-dialog]'
    element :version_container, 'div[class=container-fluid]'

    # sets the project as a favorite
    def favorite_set
      favor_project.click
    end

    # unsets the project as a favorite
    def unfavorite_set
      unfavor_project.click
    end

    # clicks the new version button
    def version_new
      find_link('New Version').click
    end

    # selects a version form the project detail page
    # @param version [string] the version of the project
    def version_open(version)
      find_link(version).click
    end

    # gets a list of releases on the project detail page
    # @param type [string] the type of releases to get
    # @return [array] projects found in the projects table
    def versions_get(type = nil)

      if type.nil?
        container = version_container.all(:css, 'div[id=released_versions]').first
        releases = rel_projects.all('a[class$=table-link]') if container
      else
        container = version_container.all(:css, 'div[id=unreleased_versions]').first
        releases = dev_projects.all('a[class$=table-link]') if container
      end

      prod_releases = []
      if releases
        releases.each do |proj|
          prod_releases << proj.text
        end
      else
        prod_releases = nil
      end
      prod_releases
    end

    # clicks the Edit button
    def project_edit
      edit_project.click
    end

    # clicks the Delete Project button
    def project_delete
      delete_project.click
      confirm = modal.find('a[data-method=delete]')
      confirm.click
    end

  end
end
