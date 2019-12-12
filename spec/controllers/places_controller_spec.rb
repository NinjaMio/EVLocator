require 'rails_helper'

RSpec.describe PlacesController, type: :controller do

  describe "places#new action" do
    it "should require users to be logged in" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show the new form" do
      user = FactoryBot.create(:user)
      sign_in user

      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "places#create action" do
    it "should require users to be logged in" do
      post :create, params: { place: { placename: "Hello" } }
      expect(response).to redirect_to new_user_session_path
    end
    
    it "should successfully create a new place in our database" do
      user = FactoryBot.create(:user)
      sign_in user
        post :create, params: {
          place: {
            placename: 'Hello!',
            address: 'Address'
          }
        }
      expect(response).to redirect_to administration_path

      place = Place.last
      expect(place.placename).to eq("Hello!")
      expect(place.address).to eq("Address")
      expect(place.user).to eq(user)
    end

    it "should properly deal with placename validation errors" do
      user = FactoryBot.create(:user)
      sign_in user

      place_count = Place.count
      post :create, params: { place: { placename: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(place_count).to eq Place.count
    end

    it "should properly deal with address validation errors" do
      user = FactoryBot.create(:user)
      sign_in user

      place_count = Place.count
      post :create, params: { place: { address: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(place_count).to eq Place.count
    end
  end

end
