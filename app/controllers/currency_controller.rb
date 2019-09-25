class CurrencyController < ApplicationController
  http_basic_authenticate_with name: 'admin', password: 'admin', except: :index

  def index
  end

  def new

  end

  def create

  end
end
