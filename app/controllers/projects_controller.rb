class ProjectsController < ApplicationController

  before_action :validate_search_key , :only => [:search]

  def index
    if params[:category_id]
      @projects = Project.where(category_id: params[:category_id], aasm_state: "online")
    else
      @projects = Project.where(aasm_state: "online")
    end
  end

  def show
    @project = Project.find(params[:id])
    @user = @project.user
    @posts = @project.posts.recent
    @plans = @project.plans
    if @project.is_hidden?
      if !current_user
        redirect_to root_path, alert: "该项目为非公开项目。"
      else
        if current_user.is_admin == true
          flash[:warning] = "当前项目已设置为隐藏。"
        elsif @project.user == current_user
          flash[:warning] = "审核中，当前为预览模式。"
        else
          redirect_to root_path, alert: "该项目为未公开项目。"
        end
      end
    end
  end

  def search
    if @query_string.present?
      search_result = Project.ransack(@search_criteria).result(:distinct => true)
      # binding.pry
      @projects = search_result.paginate(:page => params[:page], :per_page => 20 )
      # set_page_title "搜索 #{@query_string}"
    end
  end

  protected

  def validate_search_key
    @query_string = params[:q].gsub(/\\|\'|\/|\?/, "") if params[:q].present?
    @search_criteria = search_criteria(@query_string)
  end


  def search_criteria(query_string)
    { :name_cont => query_string ,aasm_state_eq: "online"}
  end


end
