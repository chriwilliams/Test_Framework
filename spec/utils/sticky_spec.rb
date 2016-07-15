require_relative '../spec_helper'

describe MediTAF::Utils::Sticky do
  before (:all) do
    $config = MediTAF::Utils::Configuration.new
  end

  subject { MediTAF::Utils::Sticky.new('default_value') }

  context '#[]' do
    before (:each) { subject['test_key'] = 'test_value' }

    it 'should get the value for the stored key' do
      expect(subject['test_key']).to eq 'test_value'
    end

    it 'should raise an error for an unknown key' do
      expect { subject['unkown_key'] }.to raise_error MediTAF::Utils::StickyKeyNotFound
    end

    context "#get_value" do

      context 'should return a string with the value of the known key' do
        it 'of one occurrence' do
          expect(subject.get_value 'test_key').to eq 'test_value'
        end

        it 'of two occurrences' do
          expect(subject.get_value 'test_key test_key').to eq 'test_value test_value'
        end
      end

      it 'should return a string with the values of the known keys' do
        sticky = MediTAF::Utils::Sticky.new
        sticky['test_key_1'] = 'test_value_1'
        sticky['test_key_2'] = 'test_value_2'
        expect(sticky.get_value 'test_key_1 test_key_2').to eq 'test_value_1 test_value_2'
      end

      it 'should raise an error on an unknown key' do
        sticky = MediTAF::Utils::Sticky.new
        sticky['test_key_1'] = 'test_value_1'
        expect { sticky.get_value 'test_key_1 test_key_2' }.to raise_error MediTAF::Utils::StickyKeyNotFound
      end
    end
  end

  context "#set_value" do
    it 'should store a new key value pair' do
      subject.set_value 'test_key', 'test_value'
      expect(subject['test_key']).to eq 'test_value'
    end
  end

end