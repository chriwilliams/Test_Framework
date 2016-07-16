#Example:
#And I am running the study design wizard having chosen options:
# | Study Design            | Randomization and Supplies Management |
# | Blinding Restrictions   | Yes                                   |
# | Design Setup            | Start from scratch                    |
# | Randomization Type      | Dynamic Allocation                    |
# | Quarantining            | No                                    |
# | Enrollment Caps         | No                                    |

Given /^I am running the study design wizard having chosen options:$/ do |options_table|
  $applications.balance.wizard.select_wizard_options(options_table)
end