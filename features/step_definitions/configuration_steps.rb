require 'yaml'

MAIN_CFG = './main_cfg.yml'
CFG1 = './test_cfg1.yml'
CFG2 = './test_cfg2.yml'
CFG3 = './test_cfg3.yml'

MAIN_ITEM_A = 'main_item_a'; MAIN_ITEM_A_VALUE = 'main_item_a_value'
MAIN_ITEM_B = 'main_item_b'; MAIN_ITEM_B_VALUE = 'main_item_b_value'
MAIN_ITEM_C = 'main_item_c'; MAIN_ITEM_C_VALUE = 'main_item_c_value'

CFG1_ITEM_A = 'cfg1_item_a'; CFG1_ITEM_A_VALUE = 'cgf1_item_a_value'
CFG1_ITEM_B = 'cfg1_item_b'; CFG1_ITEM_B_VALUE = 'cgf1_item_b_value'
CFG1_ITEM_C = 'cfg1_item_c'; CFG1_ITEM_C_VALUE = 'cgf1_item_c_value'

CFG2_ITEM_A = 'cfg2_item_a'; CFG2_ITEM_A_VALUE = 'cgf2_item_a_value'
CFG2_ITEM_B = 'cfg2_item_b'; CFG2_ITEM_B_VALUE = 'cgf2_item_b_value'
CFG2_ITEM_C = 'cfg2_item_c'; CFG2_ITEM_C_VALUE = 'cgf2_item_c_value'

CFG3_ITEM_A = 'cfg3_item_a'; CFG3_ITEM_A_VALUE = 'cgf3_item_a_value'
CFG3_ITEM_B = 'cfg3_item_b'; CFG3_ITEM_B_VALUE = 'cgf3_item_b_value'
CFG3_ITEM_C = 'cfg3_item_c'; CFG3_ITEM_C_VALUE = 'cgf_item_c_value'

def write_cfg_file(fname, table)
  cfg = ( fname =~ /^main/ ) ? { 'modules' => {} } : {}
  ref = cfg['modules'] || cfg
  table.each do |r|
    ref[r['item'] ? r['item'] : r.keys[0]] = r['value'] ? r['value'] : r.values[0]
  end
  File.open(fname, File::CREAT|File::TRUNC|File::RDWR, 0644) { |f| f.write cfg.to_yaml }
end

Given /^I have a "([^"]+)" configuration file with the following values:$/ do |fname, table|
  write_cfg_file(fname, table.hashes)
  @config_file = fname
end

When /^I initialize the Utils::Configuration module using the "([^"]+)" configuration file$/ do |fname|
  @config = MediTAF::Utils::Configuration.new(fname)
end

Then /^I verify that I have access to the configuration items$/ do |table|
  step %Q{I Print content "VERIFIED: I can access the configuration items" to shamus output}
  unless table.column_names.include?('item1')
    table.hashes.each do |h|
      expect(@config[h['item']]).to eq h['value']
      step %Q{I Print content "#{h['item']} => #{h['value']}" to shamus output}
    end
  else
    step %Q{I should have access to all items in the collections}
  end
end

def build_cfgs(table)
  cfgs = {}
  files = table.hashes.map { |r| r['file'] if r['file'] != '' }.delete_if { |f| f.nil? }
  files.each do |f|
    table.hashes.inject([f, nil]) do |data, r|
      if r['file'] != ""
        f = r['file']
        cfgs[f] = [ ['item', 'value'] ]
      end
      cfgs[f] << [ r['item'] , r['value'] ]
      f
    end
  end
  cfgs
end

Given /^I have the following configuration files$/ do |table|
  unless table.column_names.include?('item1')
    build_cfgs(table).each_pair do |f, t|
      step %Q{I have a "#{f}" configuration file with the following values:}, table(t)
    end
  else
    step %Q{I have other configuration files which contain internal collections}
  end
end

Given /^I have other configuration files which contain internal collections$/ do
  step %Q{I have a "main_cfg.yml" configuration file with the following values:}, table([
        %w{ item value },
        %w{ config_files test_cfg1.yml },
        %w{ main_item_a main_item_a_value },
        %w{ main_item_b main_item_b_value },
        %w{ main_item_c main_item_c_value }
    ])

  cfg = {
      CFG1_ITEM_A => {
          CFG2_ITEM_A => CFG2_ITEM_A_VALUE,
          CFG2_ITEM_B => CFG2_ITEM_B_VALUE
      },
      CFG1_ITEM_B => CFG1_ITEM_B_VALUE,
      CFG1_ITEM_C => {
          CFG2_ITEM_A => CFG2_ITEM_A_VALUE,
          CFG2_ITEM_B => {
              CFG3_ITEM_A => CFG3_ITEM_A_VALUE
          }
      }
  }
  File.open(CFG1, File::CREAT|File::TRUNC|File::RDWR, 0644) { |f| f.write cfg.to_yaml }
end

Then /^I should have access to all items in the collections$/ do
  expect(@config[CFG1_ITEM_A]).to be_a MediTAF::Utils::Configuration::Settings
  expect(@config[CFG1_ITEM_A]).to include CFG2_ITEM_A
  expect(@config[CFG1_ITEM_A]).to include CFG2_ITEM_B
  expect(@config[CFG1_ITEM_A][CFG2_ITEM_A]).to eq CFG2_ITEM_A_VALUE
  expect(@config[CFG1_ITEM_A][CFG2_ITEM_B]).to eq CFG2_ITEM_B_VALUE
  expect(@config[CFG1_ITEM_B]).to eq CFG1_ITEM_B_VALUE
  expect(@config[CFG1_ITEM_C]).to be_a MediTAF::Utils::Configuration::Settings
  expect(@config[CFG1_ITEM_C]).to include CFG2_ITEM_A
  expect(@config[CFG1_ITEM_C]).to include CFG2_ITEM_B
  expect(@config[CFG1_ITEM_C][CFG2_ITEM_A]).to eq CFG2_ITEM_A_VALUE
  expect(@config[CFG1_ITEM_C][CFG2_ITEM_B]).to be_a MediTAF::Utils::Configuration::Settings
  expect(@config[CFG1_ITEM_C][CFG2_ITEM_B]).to include CFG3_ITEM_A
  expect(@config[CFG1_ITEM_C][CFG2_ITEM_B][CFG3_ITEM_A]).to eq CFG3_ITEM_A_VALUE

  step %Q{I Print content "config_files => test_cfg1.yml" to shamus output}
  step %Q{I Print content "#{MAIN_ITEM_A} => #{MAIN_ITEM_A_VALUE}" to shamus output}
  step %Q{I Print content "#{MAIN_ITEM_B} => #{MAIN_ITEM_B_VALUE}" to shamus output}
  step %Q{I Print content "#{MAIN_ITEM_C} => #{MAIN_ITEM_C_VALUE}" to shamus output}
  step %Q{I Print content "#{CFG1_ITEM_A} => #{CFG2_ITEM_A}" to shamus output}
  step %Q{I Print content "#{CFG1_ITEM_A} => #{CFG2_ITEM_B}" to shamus output}
  step %Q{I Print content "#{CFG1_ITEM_A} => #{CFG2_ITEM_A} => #{CFG2_ITEM_A_VALUE}" to shamus output}
  step %Q{I Print content "#{CFG1_ITEM_A} => #{CFG2_ITEM_B} => #{CFG2_ITEM_B_VALUE}" to shamus output}
  step %Q{I Print content "#{CFG1_ITEM_B} => #{CFG1_ITEM_B_VALUE}" to shamus output}
  step %Q{I Print content "#{CFG1_ITEM_C} => #{CFG2_ITEM_A}" to shamus output}
  step %Q{I Print content "#{CFG1_ITEM_C} => #{CFG2_ITEM_B}" to shamus output}
  step %Q{I Print content "#{CFG1_ITEM_C} => #{CFG2_ITEM_A} => #{CFG2_ITEM_A_VALUE}" to shamus output}
  step %Q{I Print content "#{CFG1_ITEM_C} => #{CFG2_ITEM_B} => #{CFG3_ITEM_A}" to shamus output}
  step %Q{I Print content "#{CFG1_ITEM_C} => #{CFG2_ITEM_B} => #{CFG3_ITEM_A} => #{CFG3_ITEM_A_VALUE}" to shamus output}
end
