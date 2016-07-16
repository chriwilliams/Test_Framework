require_relative '../spec_helper'

describe MediTAF::Utils::MediTAFFaker do

  context 'Address' do
    before (:all) do
      @AddressSpec = MediTAF::Utils::MediTAFFaker
    end

    #Verifying each generated string is not empty

    it "should verify the generated Address 'city' string is not an empty string." do
      expect(@AddressSpec.address.city).not_to eq(nil)
    end

    it "should verify the generated Address 'street name' string is not an empty string." do
      expect(@AddressSpec.address.street_name).not_to eq(nil)
    end

    it "should verify the generated Address 'street address' string is not an empty string." do
      expect(@AddressSpec.address.street_address).not_to eq(nil)
    end

    it "should verify the generated Address 'secondary address' string is not an empty string." do
      expect(@AddressSpec.address.secondary_address).not_to eq(nil)
    end

    it "should verify the generated Address 'building number' string is not an empty string." do
      expect(@AddressSpec.address.building_number).not_to eq(nil)
    end

    it "should verify the generated address 'zip code' string is not an empty string." do
      expect(@AddressSpec.address.zip_code).not_to eq(nil)
    end

    it "should verify the generated Address 'zip' string is not an empty string." do
      expect(@AddressSpec.address.zip).not_to eq(nil)
    end

    it "should verify the generated Address 'post code' string is not an empty string." do
      expect(@AddressSpec.address.postcode).not_to eq(nil)
    end

    it "should verify the generated Address 'time zone' string is not an empty string." do
      expect(@AddressSpec.address.time_zone).not_to eq(nil)
    end

    it "should verify the generated Address 'Street Suffix' string is not an empty string." do
      expect(@AddressSpec.address.street_suffix).not_to eq(nil)
    end

    it "should verify the generated Address 'City Suffix' string is not an empty string." do
      expect(@AddressSpec.address.city_suffix).not_to eq(nil)
    end

    it "should verify the generated Address 'City Prefix' string is not an empty string." do
      expect(@AddressSpec.address.city_prefix).not_to eq(nil)
    end

    it "should verify the generated Address 'state abbr' string is not an empty string." do
      expect(@AddressSpec.address.state_abbr).not_to eq(nil)
    end

    it "should verify the generated Address 'state' string is not an empty string." do
      expect(@AddressSpec.address.state).not_to eq(nil)
    end

    it "should verify the generated Address 'country' string is not an empty string." do
      expect(@AddressSpec.address.country).not_to eq(nil)
    end

    it "should verify the generated Address 'latitude' string is not an empty string." do
      expect(@AddressSpec.address.latitude).not_to eq(nil)
    end

    it "should verify the generated Address 'longitude' string is not an empty string." do
      expect(@AddressSpec.address.longitude).not_to eq(nil)
    end
  end

  context 'Code' do
    before (:all) do
      @CodeSpec = MediTAF::Utils::MediTAFFaker
    end

    #Verifying the codes generated are not empty strings
    it "should verify the generated isbn string is not an empty string." do
      expect(@CodeSpec.code.isbn).not_to eq(nil)
    end

    it "should verify the generated isbn string with length 13 is not an empty string." do
      expect(@CodeSpec.code.isbn(13)).not_to eq(nil)
    end

    # Verifying the data output has the proper format
    it "should verify the generated isbn string is properly formatted." do
      expect(@CodeSpec.code.isbn).to match(/\d{9}-[X0-9]/)
    end


    it "should verify the generated isbn string with length 13 is properly formatted." do
      expect(@CodeSpec.code.isbn(13)).to match(/\d{12}-\d{1}/)
    end
  end

  context 'Name' do
    before (:all) do
      @NameSpec = MediTAF::Utils::MediTAFFaker
    end


    #Verifying each generated string is not empty

    it "should verify the generated generated Name 'name' string is not an empty string." do
      expect(@NameSpec.name.name).not_to eq(nil)
    end

    it "should verify the generated generated Name 'first name' string is not an empty string." do
      expect(@NameSpec.name.first_name).not_to eq(nil)
    end

    it "should verify the generated generated Name 'last name' string is not an empty string." do
      expect(@NameSpec.name.last_name).not_to eq(nil)
    end

    it "should verify the generated generated Name 'prefix' string is not an empty string." do
      expect(@NameSpec.name.prefix).not_to eq(nil)
    end

    it "should verify the generated generated Name 'suffix' string is not an empty string." do
      expect(@NameSpec.name.suffix).not_to eq(nil)
    end

    it "should verify the generated generated Name 'title' string is not an empty string." do
      expect(@NameSpec.name.title).not_to eq(nil)
    end
  end

  context 'Number' do
    before (:all) do
      @NumberSpec = MediTAF::Utils::MediTAFFaker
    end

    #Verifying each generated string is not empty

    it "should verify the generated number string with 4 specified digits is not an empty string." do
      expect(@NumberSpec.number.number(4)).not_to eq(nil)
    end

    it "should verify the generated number string with 10 specified digits is not an empty string." do
      expect(@NumberSpec.number.number(10)).not_to eq(nil)
    end

    it "should verify the generated number string with no specified digits is not an empty string." do
      expect(@NumberSpec.number.digit).not_to eq(nil)
    end
  end

  context 'Random' do
    before (:all) do
      @RandomSpec = MediTAF::Utils::MediTAFFaker
    end

    it "should verify the generated prime number is not an empty string." do
      expect(@RandomSpec.random).not_to eq(nil)
    end

    it "should verify the generated prime number is greater than 999." do
      expect(@RandomSpec.random.to_i).to be > 999
    end

    it "should verify the generated prime number is less than 10000." do
      expect(@RandomSpec.random.to_i).to be < 10000
    end
  end

  context 'Faker' do
    before (:all) do
      @faker = MediTAF::Utils::MediTAFFaker
    end

    #Verifying each generated string is not empty
    it "should a string with a random number" do
      expect(@faker.stringify('joe', @faker.random)).not_to eq(nil)
    end

    #Verifying each generated string is not empty
    it "should a string with a random number and the short timespan" do
      expect(@faker.stringify('joe', @faker.random, @faker.timestamp_short)).not_to eq(nil)
    end

    ##Verifying each generated string is not empty
    it "should a string with a random number and the short timespan with city" do
      expect(@faker.stringify('joe', @faker.random, @faker.timestamp_short, @faker.address.city)).not_to eq(nil)
    end

    #Verifying each generated string is not empty
    it "should a string with a random number and the short timespan with name" do
      expect(@faker.stringify('joe', @faker.random, @faker.timestamp_short, @faker.name.name)).not_to eq(nil)
    end
  end

  context 'Timestamp' do
    before (:all) do
      @TimeSpanSpec = MediTAF::Utils::MediTAFFaker
    end

    # Verifying that string output is not empty

    it "should verify the generated timestamp based on the default format is not empty." do
      expect(@TimeSpanSpec.timestamp).not_to eq(nil)
    end

    it "should verify the generated date format based on the Medidata format is not empty." do
      expect(@TimeSpanSpec.medidata_date_format).not_to eq(nil)
    end

    it "should verify the generated timestamp based on the long date format (no YEAR) is not empty." do
      expect(@TimeSpanSpec.timestamp_long).not_to eq(nil)
    end

    it "should verify the generated timestamp based on the date format as (minutes, seconds, micro seconds) is not empty." do
      expect(@TimeSpanSpec.timestamp_short).not_to eq(nil)
    end

    it "should verify the generated timestamp based on the complete date time format is not empty." do
      expect(@TimeSpanSpec.timestamp_complete).not_to eq(nil)
    end

    # Verifying the dates are as expected

    it "should verify the generated timestamp based on the default format corresponds to today's date." do
      expect(DateTime.parse(@TimeSpanSpec.timestamp).strftime("%Y%m%d")).to eq(DateTime.now.strftime("%Y%m%d"))
    end

    it "should verify the generated date format based on the Medidata format corresponds to today's date." do
      expect(DateTime.parse(@TimeSpanSpec.medidata_date_format).strftime("%Y%m%d")).to eq(DateTime.now.strftime("%Y%m%d"))
    end
  end

  context 'UID' do
    before (:all) do
      @UIDSpec = MediTAF::Utils::MediTAFFaker
    end

    it "should verify the generated uid string is not an empty string." do
      expect(@UIDSpec.uid).not_to eq(nil)
    end

    it "should verify the generated uid MD5 string is not an empty string." do
      expect(@UIDSpec.uid_md5).not_to eq(nil)
    end

    it "should verify the generated uid MD5 string with dashes is not an empty string." do
      expect(@UIDSpec.uid_md5(false)).not_to eq(nil)
    end

    it "should verify the generated uid SHA1 string is not an empty string." do
      expect(@UIDSpec.uid_sha1).not_to eq(nil)
    end

    it "should verify the generated uid SHA1 string with dashes is not an empty string." do
      expect(@UIDSpec.uid_sha1(false)).not_to eq(nil)
    end

    it "should verify the generated uid string has a length of 32." do
      expect(@UIDSpec.uid.length).to be == 32
    end

    it "should verify the generated string is properly formatted." do
      expect(@UIDSpec.uid).to match (/[a-f0-9]{32}/)
    end

    it "should verify the generated uid MD5 string is properly formatted." do
      expect(@UIDSpec.uid_md5).to match(/[a-f0-9]{32}/)
    end

    it "should verify the generated uid MD5 string with dashes is properly formatted." do
      expect(@UIDSpec.uid_md5(false)).to match(/[a-f0-9]{8}-([a-f0-9]{4}-){3}[a-f0-9]{12}/)
    end

    it "should verify the generated uid SHA1 string is properly formatted." do
      expect(@UIDSpec.uid_sha1).to match(/[a-f0-9]{40}/)
    end

    it "should verify the generated uid SHA1 string with dashes is properly formatted." do
      expect(@UIDSpec.uid_sha1(false)).to match(/[a-f0-9]{12}-([a-f0-9]{4}-){4}[a-f0-9]{12}/)
    end
  end
end