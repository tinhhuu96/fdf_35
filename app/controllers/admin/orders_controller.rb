class Admin::OrdersController < ApplicationController
  before_action :load_order, only: %i(edit destroy update show)

  def index
    @orders = Order.sort_by_id
  end

  def show; end

  def destroy
    if @order.destroy
      flash[:success] = t "admin.deleted"
    else
      flash[:warning] = t "admin.notdelete"
    end
    redirect_to admin_orders_path
  end

  def edit; end

  def update
    if @order.update_attributes order_params
      flash[:success] = t "admin.updatesuc"
    else
      flash[:warning] = t "admin.updatefail"
    end
    redirect_to admin_orders_path
  end

  private

  def order_params
    params.require(:order).permit(:status, :phone, :address)
  end

  def load_order

    @order = Order.find_by id: params[:id]
    return if @order
    flash[:warning] = t "users_controller.errorss"
    redirect_to admin_orders_path
  end
end
# @stas[1][1]