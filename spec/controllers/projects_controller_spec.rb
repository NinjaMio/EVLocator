require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  describe "projects#index action" do
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "projects#new action" do
    it "should successfully show the new form" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "projects#create action" do
    it "should successfully create a new project in our database" do
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
    end
  end
end
