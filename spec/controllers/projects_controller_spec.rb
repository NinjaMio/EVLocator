require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do

  describe "projects#destroy action" do
    it "shouldn't allow users who didn't create the project to destroy it" do
      project = FactoryBot.create(:project)
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy, params: { id: project.id }
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unauthenticated users destroy a project" do
      project = FactoryBot.create(:project)
      delete :destroy, params: { id: project.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "should allow a user to destroy projects" do
      project = FactoryBot.create(:project)
      sign_in project.user
      delete :destroy, params: { id: project.id }
      expect(response).to redirect_to root_path
      project = Project.find_by_id(project.id)
      expect(project).to eq nil
    end

    it "should return a 404 message if we cannot find a project with the id that is specified" do
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy, params: { id: 'SPACEDUCK' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "projects#update action" do

    it "shouldn't let users who didn't create the project update it" do
      project = FactoryBot.create(:project)
      user = FactoryBot.create(:user)
      sign_in user
      patch :update, params: { id: project.id, project: { name: 'wahoo' } }
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unauthenticated users update a project" do
      project = FactoryBot.create(:project)
      patch :update, params: { id: project.id, project: { name: "Hello" } }
      expect(response).to redirect_to new_user_session_path
    end

    it "should allow users to successfully update projects" do
      project = FactoryBot.create(:project, name: "Initial Value")
      sign_in project.user
      patch :update, params: { id: project.id, project: { name: 'Changed' } }
      expect(response).to redirect_to root_path
      project.reload
      expect(project.name).to eq "Changed"
    end

    it "should have http 404 error if the project cannot be found" do
      user = FactoryBot.create(:user)
      sign_in user
      patch :update, params: { id: "YOLOSWAG", project: { name: 'Changed' } }
      expect(response).to have_http_status(:not_found)
    end

    it "should render the edit form with an http status of unprocessable_entity" do
      project = FactoryBot.create(:project, name: "Initial Value")
      sign_in project.user
      patch :update, params: { id: project.id, project: { name: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      project.reload
      expect(project.name).to eq "Initial Value"
    end
  end

  describe "projects#edit action" do
    it "shouldn't let a user who did not create the project edit a project" do
      project = FactoryBot.create(:project)
      user = FactoryBot.create(:user)
      sign_in user
      get :edit, params: { id: project.id }
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unauthenticated users edit a project" do
      project = FactoryBot.create(:project)
      get :edit, params: { id: project.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show the edit form if the project is found" do
      project = FactoryBot.create(:project)
      sign_in project.user
      get :edit, params: { id: project.id }
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error name if the project is not found" do
      user = FactoryBot.create(:user)
      sign_in user
      get :edit, params: { id: 'SWAG' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "projects#show action" do
    it "should successfully show the page if the project is found" do
      project = FactoryBot.create(:project)
      get :show, params: { id: project.id }
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error if the project is not found" do
      get :show, params: { id: 'TACOCAT' }
      expect(response).to have_http_status(:not_found)
    end
  end

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
      post :create, params: { project: { name: "Hello" } }
      expect(response).to redirect_to new_user_session_path
    end
    
    it "should successfully create a new project in our database" do
      user = FactoryBot.create(:user)
      sign_in user
        post :create, params: {
          project: {
            name: 'Hello!',
            picture: fixture_file_upload("/picture.png", 'image/png')
          }
        }
      expect(response).to redirect_to root_path

      project = Project.last
      expect(project.name).to eq("Hello!")
      expect(project.user).to eq(user)
    end

    it "should properly deal with validation errors" do
      user = FactoryBot.create(:user)
      sign_in user

      project_count = Project.count
      post :create, params: { project: { name: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(project_count).to eq Project.count
    end
  end
end