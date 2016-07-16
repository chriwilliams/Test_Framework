require_relative 'draft'

module Rave
  class CrfVersion < Draft

    element :to_study, 'select[id$="Content_StudyDDL"]'
    element :destination, 'select[id$="Content_DestinationLB"]'
    element :push_it, 'input[id$="Content_PushBTN"]'


    # pushes the draft to all or selected sites
    # @param study [String] the study to push to. This can be `prod` or `dev` or `aux`
    # @param sites [String] site(s) or site group(s) you want to push to in colon delimited format.
    # This can be `all` or `site` or `group` followed by site or site group name(s). If `all` is selected, you do not
    # need to enter any site or site group name(s)
    def draft_push_to_sites(study, sites = nil)

      sites_arr = ''
      select(study, :from => to_study[:id])

      if sites.nil?
        s_push_to = 'all'
      else
        sites_arr = sites.chomp.split(':')

        if sites_arr.size > 0
          s_push_to = sites_arr.first
          sites_arr.shift
        else
          s_push_to = sites_arr.first
        end
      end

      case s_push_to
        when 'all'
          choose('_ctl0_Content_AllSitesRB')
        when 'site'
          choose('_ctl0_Content_SelectSitesRB')
          sites_arr.each do |site|
            select(site)
          end
        when 'group'
          choose('_ctl0_Content_SiteGroupRB')
          sites_arr.each do |site|
            select(site)
          end
        else
          raise "Invalid Site selection '#{s_push_to}'"
      end

      push_it.click

    end

  end
end