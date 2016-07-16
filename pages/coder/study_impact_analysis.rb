require_relative '../common/base_page'
require_relative 'sections'

module Coder
  class StudyImpactAnalysis < Common::BasePage
    section :header, Header, 'div.master-header'
    section :footer, Footer, '#masterfooter'
    section :navigation, Navigation, '#navbar'

    element :select_study, 'select[id$="controlACG_ddlStudy"]'
    element :select_dictionary, 'select[id$="controlACG_ddlDictionary"]'
    element :from_dict_version, 'select[id$="controlACG_ddlFromVersion"]'
    element :from_synonym_list, 'select[id$="controlACG_ddlFromSynonymList"]'
    element :to_dict_version, 'select[id$="controlACG_ddlToVersion"]'
    element :to_synonym_list, 'select[id$="ddlToSynonymList"]'
    element :generate_report, 'a[id$="Content_btnSearch"]'
    element :export_report, 'a[id$="btnExportStudyReport"]'
    element :migrate_study, 'a[class*="clBtn clBtnBgPos clBtnIcon"]'
    element :accept_migrate_study, 'a[id*="pcMigrationWarning_MigrateOK"]'
    element :migration_success_message, 'span[class*="HeaderSpan"]'


    # this will select the appropriate options for a study migration and hit the generat report button
    # @param study [String] study we are going to perform a migration on
    # @param dictionary [String] dictionary to perform a migration on
    # @param from_version [Numeric] dictionary version migrating from
    # @param from_syn_list [String] synonym list migrating from
    # @param to_version [String] dictionary version migrating to
    # @param to_syn_list [String] synonym list migrating to
    def study_migration_selections(study, dictionary, from_version, from_syn_list, to_version, to_syn_list)
      select_study.select study
      select_dictionary.select dictionary
      from_dict_version.select from_version
      from_synonym_list.select from_syn_list
      to_dict_version.select to_version
      to_synonym_list.select to_syn_list
      generate_report.click
    end

    # this method will perform the study migration
    def perform_study_migration
      wait_for_export_report
      migrate_study.click
      wait_for_accept_migrate_study
      accept_migrate_study.click
      wait_for_migration_success_message
    end

  end
end

