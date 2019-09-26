class CurrencyController < ApplicationController
  http_basic_authenticate_with name: 'admin', password: 'admin', except: :index

  # GET /
  def index
    @currency = Currency.actual_rate
  end

  # GET /admin
  def new
    @currency = Currency.new(is_forced: true)
    @previous_currency = Currency.forced.last
  end

  # POST /admin
  def create
    @currency = Currency.create_forced(currency_params)
    if @currency.valid?
      redirect_to root_path, notice: 'Forced rate created'
    else
      flash[:alert] = @currency.errors.full_messages.to_sentence
      render :new, status: 400
    end
  end

  private

  def currency_params
    defaults = { is_forced: true }
    params.require(:currency)
          .permit(:is_forced, :is_forced_by, :rate)
          .reverse_merge(defaults)
  end
end
