require 'rails_helper'

RSpec.describe MainController, type: :controller do

  describe 'GET index' do
    it do
      expect { get :index }.to raise_error(NotImplementedError)
    end
  end

  describe 'GET index bad version' do
    it do
      expect { get :index, params: { api_version: 'BAD' } }.to raise_error(NotImplementedError)
    end
  end

  describe 'GET index 1.0' do
    it do
      get :index, params: { api_version: '1.0' }
      expect(response).to have_http_status 200
      expect(response.body).to eq 'version index 1.0 # collection for 1.0'
    end
  end

  describe 'GET index 1.0.1' do
    it do
      get :index, params: { api_version: '1.0.1' }
      expect(response).to have_http_status 200
      expect(response.body).to eq 'version index 1.0 # collection for 1.0.1'
    end
  end

  describe 'GET index 1.1' do
    it do
      get :index, params: { api_version: '1.1' }
      expect(response).to have_http_status 200
      expect(response.body).to eq 'version index 1.0 # collection for 1.0.1'
    end
  end

  describe 'GET index 1.2' do
    it do
      get :index, params: { api_version: '1.2' }
      expect(response).to have_http_status 200
      expect(response.body).to eq 'version index 1.2 # collection for 1.0'
    end
  end
end
