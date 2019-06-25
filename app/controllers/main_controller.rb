class MainController < ApplicationController

  api_version :base, :index do
    render plain: "base index #{collection}"
  end

  api_version '1.0', :index do
    render plain: "version index 1.0 # #{collection}"
  end

  api_version '1.1', :index do
    render plain: "version index 1.1 # #{collection}"
  end

  api_version :base, :collection do
    'collection for base'
  end

  api_version '1.1', :collection do
    'collection for v1.1'
  end
end
