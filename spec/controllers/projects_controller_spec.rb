require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  describe "projects#index action" do
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "projects#new action" do
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

  describe "projects#create action" do
    it "should require users to be logged in" do
      post :create, params: { 
        project: { 
          name: 'NewProject',
          description: 'NewProject Description'
        }
      } 
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully create a new project in our database" do
      user = FactoryBot.create(:user)
      sign_in user

      post :create, params: { 
        project: { 
          name: 'NewProject',
          description: 'NewProject Description'
        }
      } 
      expect(response).to redirect_to root_path

      project = Project.last
      expect(project.name).to eq("NewProject")
      expect(project.description).to eq("NewProject Description")
      expect(project.user).to eq(user)
    end

    it "should properly deal with validation errors" do
      user = FactoryBot.create(:user)
      sign_in user

      project_count = Project.count
      post :create, params: { 
        project: { 
          name: '',
          description: 'Name is blank'
        }
      }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(project_count).to eq Project.count
    end
  end
end
