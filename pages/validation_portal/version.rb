require_relative '../common/base_page'
require_relative 'sections'

module ValidationPortal
  class Version < Common::BasePage

    section :header, Header, '#header'
    section :navigation, Navigation, '#navigation'

    element :version, 'input[id=release_version]'
    element :git_branch, 'input[id=release_git_branch]'
    element :rel_type_release, 'input[id=release_release_type_release]'
    element :rel_type_hotfix, 'input[id=release_release_type_hotfix]'
    element :save, 'input[type=submit]'

    set_url_matcher '\/releases'

    # sets the version of the release
    # @param value [string] the version name or number for the release
    def version_set(value)
      version.set "#{value}"
    end

    # sets the Git branch for the attached GitHub repository
    # @param value [string] the branch name or path
    def github_branch_set(value)
      git_branch.set "#{value}"
    end

    # selects the release type for the release
    # @param type [string] the release type
    def release_type_select(type)
      case type.to_s.downcase
        when 'release'
          rel_type_release.set true
        when 'hotfix'
          rel_type_hotfix.set true
        else
          raise "Release Type #{type} not supported"
      end
    end

    # clicks the save button
    def version_save
      save.click
    end

    # clicks the cancel button
    def version_cancel
      find_link('Cancel').click
    end

  end
end
