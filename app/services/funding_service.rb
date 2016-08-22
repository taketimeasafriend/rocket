class FundingService
  def initialize(order, user)
    @order = order
    @project = order.project
    @plan = order.plan
    @user = user
  end

  def add!
    @project.fund_progress += @order.total_price
    # @user.orders.where("orders_count = ? AND locked = ?", params[:orders], false)
    if @user.orders.where(project_id: @order.project, aasm_state: "paid").empty?
      @project.backer_quantity += 1
    end
    @project.save

    if @user.orders.where(plan_id: @order.plan, aasm_state: "paid").empty?
      @plan.backer_quantity += 1
      puts "----------------------"
    else
      @p = @user.orders.where(plan_id: @order.plan)
      puts "+++++++++++++++++++++++"
      puts @p.inspect.to_s
    end

    @plan.plan_progress += 1
    @plan.save
  end

  def add_progress!
    add!
    send_notification!
  end

  def send_notification!
    Notification.create(recipient: @project.user, actor: @user, action: "fund", notifiable: @order)
  end
end
