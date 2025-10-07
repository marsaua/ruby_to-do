class TodosController < ApplicationController
    def index
      @todos = current_user.todos.order(created_at: :desc)
    end
  
    def create
      @todo = current_user.todos.build(todo_params)
      if @todo.save
        redirect_to root_path, notice: "Todo was successfully created.", status: :see_other
      else
        redirect_to root_path, alert: "Failed to create todo: #{@todo.errors.full_messages.to_sentence}", status: :see_other
      end
    end
  
    def destroy
      current_user.todos.find(params[:id]).destroy
      redirect_to root_path, notice: "Todo was successfully deleted.", status: :see_other
    end
  
    private
    def todo_params
      params.require(:todo).permit(:title)
    end
  end
  