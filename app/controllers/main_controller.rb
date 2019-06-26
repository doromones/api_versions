class MainController < ApplicationController

  api_version '1.0' do
    api_method :index do
      render plain: "version index 1.0 # #{collection}"
    end

    api_method :collection do
      'collection for 1.0'
    end
  end

  api_version '1.0.1' do
    api_method :index, from: '1.0'

    api_method :collection do
      'collection for 1.0.1'
    end
  end

  api_version '1.1' do
    api_method :index, from: '1.0'

    api_method :collection, from: '1.0.1'
  end

  api_version '1.2' do
    api_method :index do
      render plain: "version index 1.2 # #{collection}"
    end

    api_method :collection, from: '1.0'
  end
end
