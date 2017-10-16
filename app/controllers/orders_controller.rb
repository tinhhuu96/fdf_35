class OrdersController < ApplicationController
  before_action :logged_in_user, only: :new

  def new
    @oder = Order.new
    @cart = current_cart
    @total = @cart.total_price
    @user = session[:user_id]
  end

  def create
    @oder = Order.new order_params
    if @oder.save
      @item = current_cart.line_items
      create_order
      destroy_session session[:cart_id]
      session[:cart_id] = nil
      redirect_to root_url
    else
      render :new
    end
  end

  def order_params
    params.require(:order).permit(:total_amount, :user_id, :phone, :address, :status)
  end

  private

  def create_order
    ActiveRecord::Base.transaction do
      @item.each do |cate|
        OrderDetail.create!(order_id: @oder.id, product_id: cate.product_id, quanlity: cate.quantity)
      end
    end
    flash[:success] = t "orders_controller.create"
  rescue
    flash[:error] = t "orders_controller.errror"
  end
end