class TasksController < ApplicationController
  before_action :require_user_logged_in, only: [:show, :new, :edit, ]
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:destroy]
  
  def index
    # @tasks = Task.all
    if logged_in?
      @tasks = current_user.tasks.order(id: :desc)
    end
  end

  def show
  end

  def new
    # @task = Task.new
    if logged_in?
      @task = current_user.tasks.build 
    end
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = 'success!!'
      redirect_to root_url
    else
      @tasks = current_user.tasks.order(id: :desc)
      flash.now[:danger] = "danger!!"
      render new_task_path
    end
    # @task = Task.new(task_params)
    
    # if @task.save
    #   flash[:success] = '正常に投稿されました'
    #   redirect_to @task
    # else
    #   flash.now[:danger] = '投稿に失敗しました'
    #   render :new
    # end
  end

  def edit
  end

  def update
      if @task.update(task_params)
        flash[:success] = '正常に更新されました'
        redirect_to @task
      else
        flash[:danger] = '更新に失敗しました'
        render :edit
      end
  end

  def destroy
    @task.destroy
    flash[:success] = '正常に削除されました'
    redirect_to tasks_url
  end

private

  def set_task
  @task = Task.find(params[:id])
  end
  
#Strong Paramater
  def task_params
  params.require(:task).permit(:content, :status)
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
end