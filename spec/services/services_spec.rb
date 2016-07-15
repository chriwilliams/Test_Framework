require_relative '../spec_helper'

describe FirstFramework::Services do
  subject (:resources) { FirstFramework::Services.new }

  before (:each) do
    $config = FirstFramework::Utils::Configuration.new
    @config = $config['services']
  end

  after (:each) do
    Euresource.config.send(:reset)
  end

  context "with adapter_home and one adapter" do

    before (:each) do
      @config.send :[]=, 'adapter_home', './spec/services'
      @config.send :[]=, 'adapters', 'mock'
    end

    it 'should load the adapter from a specified location' do
      expect(resources.adapters).to include :mock
    end

    it 'should load the adapter from the environment' do
      @config.send :[]=, 'adapters', 'mock'
      @config.send :[]=, 'adapter_home', nil
      require_relative './mock_adapter'
      expect(resources.adapters).to include :mock
    end

    it 'should configure the stage' do
      expect(resources.stage(:mock)).to be :sandbox
    end

    it 'should contain one adapter' do
      expect(resources.adapters.size).to be 1
    end

    it 'should contain the adapter' do
      expect(resources.adapters).to include :mock
    end

    context 'multiple resources' do
      subject(:countries) { resources.countries(adapter: :mock) }
      subject(:medidations) { resources.medidations(adapter: :mock) }
      subject(:multiple_resources) { countries; medidations; resources }

      it 'should contain the countries resource' do
        expect(multiple_resources.resources).to include :countries
      end

      it 'should contain the medidations resources' do
        expect(multiple_resources.resources).to include :medidations
      end

      it 'countries resource should be a Countries object' do
        expect(multiple_resources.resources[:countries]).to be_an_instance_of FirstFramework::Services::Clients::Countries
      end

      it 'medidations resource should be a Medidations object' do
        expect(multiple_resources.resources[:medidations]).to be_an_instance_of FirstFramework::Services::Clients::Medidations
      end

      it 'should get USA country details' do
        expect(countries.get(:all, {:params => {:search_term => 'USA'}})[0]).to respond_to(:name, :uuid, :country_code)
      end

      it 'should get Medidations details' do
        expect(medidations.get(:all)[0]).to respond_to(:uuid, :status, :job_title_uuid)
      end

      it 'should contain the USA country code' do
        expect(countries.get(:all, {:params => {:search_term => 'USA'}})[0].country_code).to eq 'USA'
      end

      it 'should delete each resource' do
        resources.countries(adapter: :mock)
        resources.medidations(adapter: :mock)
        resources.delete
        expect(resources.resources.size).to equal 0
      end

      it 'should delete a resource' do
        resources.countries(adapter: :mock)
        resources.medidations(adapter: :mock)
        resources.delete :countries
        expect(resources.resources.size).to equal 1
      end
    end
  end

  context "#new when errors" do
    before (:each) do
      @config.send :[]=, 'adapter_home', nil
    end

    it 'should raise an error when the adapter is not camelize-able i.e. a_b_adapter to ABAdapter' do
      @config.send :[]=, 'adapters', 'badname'
      expect { resources }.to raise_error FirstFramework::Services::ResourceAdapterLoadError
    end

    it 'should raise an error when the adapter is missing a required method' do
      require_relative './missing_method_adapter'
      @config.send :[]=, 'adapters', 'missing_method'
      expect { resources }.to raise_error FirstFramework::Services::ResourceAdapterMethodMissing
    end
  end

  context FirstFramework::Services::Clients::EuresourceAdapter do
    before (:each) do
      @config.send :[]=, 'adapter_home', nil
      @config.send :[]=, 'adapters', 'euresource'
    end

    it 'should contain only one adapter from adapters within the gem' do
      expect(resources.adapters.size).to be 1
    end

    it 'should load the euresource adapter from adapters within the gem' do
      expect(resources.adapters).to include :euresource
    end

    context 'it should' do
      it 'be a EuresourceAdapter object' do
        expect(resources.adapters[:euresource]).to be_a FirstFramework::Services::Clients::EuresourceAdapter
      end

      it 'return a kind of Euresource::Base object' do
        expect(resources.countries(adapter: :euresource).superclass).to eq Euresource::Base
      end
    end

    context 'when missing configuration items' do
      it 'should raise an error for missing services configuration item' do
        $config.send :delete, 'services'
        expect { resources }.to raise_error FirstFramework::Services::ServiceConfigurationMissing
      end

      it 'should raise an error for missing euresource configuration item' do
        @config.send :[]=, 'euresource', nil
        expect { resources }.to raise_error FirstFramework::Services::ResourceAdapterConfigurationMissing
      end

      it 'should raise an error for missing mauth_url' do
        @config['euresource'].send :[]=, 'mauth_url', nil
        expect { resources }.to raise_error FirstFramework::Services::ResourceAdapterConfigurationMissing
      end

      it 'should raise 2 errors for missing mauth_url and key_file' do
        @config['euresource'].send :[]=, 'mauth_url', nil
        @config['euresource'].send :[]=, 'key_file', nil
        expect { resources }.to raise_error FirstFramework::Services::ResourceAdapterConfigurationMissing
      end
    end
  end

  context FirstFramework::Services::Clients::MauthAdapter do
    before (:each) do
      @config.send :[]=, 'adapter_home', nil
      @config.send :[]=, 'adapters', 'mauth'
    end

    it 'should contain only one adapter from adapters within the gem' do
      expect(resources.adapters.size).to be 1
    end

    it 'should load only the mauth adapter from adaper within the gem' do
      expect(resources.adapters).to include :mauth
    end

    it 'should be a MauthAdapter object' do
      expect(resources.adapters[:mauth]).to be_an_instance_of FirstFramework::Services::Clients::MauthAdapter
    end

    it 'should return a MauthClient object' do
      expect(resources.imedidata(adapter: :mauth, baseurl: 'https://validation.imedidata.net/api/v2')).to \
        be_an_instance_of FirstFramework::Services::Clients::MauthClient
    end

    it 'should raise an error when the baseurl is missing' do
      expect { resources.imedidata(adapter: :mauth) }.to raise_error FirstFramework::Services::Clients::MauthClientBaseURLMissing
    end

    context 'missing configuration items' do
      it 'should raise an error for missing services configuration item' do
        $config.send(:delete, 'services')
        expect { resources }.to raise_error FirstFramework::Services::ServiceConfigurationMissing
      end

      it 'should raise an error for missing euresource configuration item' do
        @config.send :[]=, 'mauth', nil
        expect { resources }.to raise_error FirstFramework::Services::ResourceAdapterConfigurationMissing
      end

      it 'should raise an error for missing mauth_url' do
        @config['mauth'].send :[]=, 'mauth_url', nil
        expect { resources }.to raise_error FirstFramework::Services::ResourceAdapterConfigurationMissing
      end

      it 'should raise 2 errors for missing mauth_url and key_file' do
        @config['mauth'].send :[]=, 'mauth_url', nil
        @config['mauth'].send :[]=, 'key_file', nil
        expect { resources }.to raise_error FirstFramework::Services::ResourceAdapterConfigurationMissing
      end
    end
  end

  context 'when multiple adapters are configured' do
    before (:each) do
      FirstFramework::Services::Clients.send(:remove_const, :EuresourceAdapter)
      $LOADED_FEATURES.delete_if { |f| f =~ /euresource_adapter\.rb$/ }
      @config.send :[]=, 'adapter_home', nil
      @config.send :[]=, 'adapters', 'euresource, mauth'
    end

    it 'should load the number of adapters' do
      expect(resources.adapters.size).to eq @config['adapters'].split(/ *, */).size
    end

    it 'should load the same adapters' do
      expect(resources.adapters).to include(:euresource, :mauth)
    end
  end

  context 'when an unknown is referenced' do
    it 'should raise an error' do
      expect { resources.unknown(adapter: :unknown) }.to raise_error FirstFramework::Services::ResourceAdapterMissing
    end
  end
end