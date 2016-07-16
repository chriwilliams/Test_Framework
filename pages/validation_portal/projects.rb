require_relative '../common/base_page'
require_relative 'sections'

module ValidationPortal
  class Projects < Common::BasePage

    section :header, Header, '#header'
    section :navigation, Navigation, '#navigation'

    element :search_field, 'input#search_by'
    elements :projects, 'div[id=projects] > table[id=project-list] > tbody > tr[class=table-link-row]'
    element :app_name, 'div[class=page-header-text]'
    element :new_project, 'a#create_project'
    element :search_button, 'button[id=search-list-submit]'
    element :favorite_panel, '#favourites'

    set_url_matcher /validationportal./

    attr_reader :project

    # selects a release version for the specific project
    # @param project [string] the project name
    # @param version [string] the version to select
    def rel_version_select(project, version)
      project_find(project)
      release = @project.all('a[class=released-link]', text: "#{version}").first
      release.click
    end

    # selects a version in development for the specific project
    # @param project [string] the project name
    # @param version [string] the version to select
    def dev_version_select(project, version)
      project_find(project)
      dev = @project.all('a[class=unreleased-link]', text: "#{version}").first
      dev.click
    end

    # selects a project
    # @param project [string] the project name
    def project_open(project)
      project_find(project)
      name = @project.all('a[class=table-link]', text: "#{project}").first
      name.click
    end

    # clicks the new product/service button
    def project_new
      new_project.click
    end

    # searches for the project
    # @param name [string] the name of the project
    def project_search(name)
      search_field.set name
      search_button.click
    end

    # gets a list of projects in the projects table
    # @param project [string] the project name
    # @return [array] projects found in the projects table
    def project_get(project)
      project_find(project)
      projects = @project.all('a[class=table-link]') if @project

      project_names = []
      if projects
        projects.each do |proj|
          project_names << proj.text
        end
      else
        project_names = nil
      end
      project_names
    end

    protected

    # finds project on a Validation Portal Home page.
    # @param label [string] the project name
    def project_find(label)
      @project = projects.find { |item| item.text.include? label }
    end

  end
end
