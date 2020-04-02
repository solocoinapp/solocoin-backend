require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'reverse geocoding' do
    before do
      stub_request(:get, 'https://nominatim.openstreetmap.org/reverse?accept-language=en&addressdetails=1&format=json&lat=51.509865&lon=-0.118092').to_return(status: 200, body: geo_body.to_json, headers: {})
    end
    let(:geo_body) do
      {
        place_id: 136011490,
        licence: "Data © OpenStreetMap contributors, ODbL 1.0. https://osm.org/copyright",
        osm_type: "way",
        osm_id: 208169532,
        lat: "51.50825655",
        lon: "-0.116585581433896",
        display_name: "Waterloo Bridge, Victoria Embankment, St Clement Danes, Covent Garden, City of Westminster, London, Greater London, England, WC2R 2AB, United Kingdom",
        address: {
          address29: "Waterloo Bridge",
          road: "Victoria Embankment",
          neighbourhood: "St Clement Danes",
          suburb: "Covent Garden",
          city: "London",
          state_district: "Greater London",
          state: "England",
          postcode: "WC2R 2AB",
          country: "United Kingdom",
          country_code: "gb"
        },
        boundingbox: [
          "51.5069257",
          "51.5100829",
          "-0.1183332",
          "-0.1152889"
        ]
      }
    end

    it 'should populate the right country, country_code and city' do
      user = FactoryBot.create(:user, lat: 0.51509865e2, lng: -0.118092e0)
      expect(user.city).to eq('London')
      expect(user.country_code).to eq('gb')
      expect(user.country_name).to eq('United Kingdom')
    end
  end
end
