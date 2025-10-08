class TodosController < ApplicationController
    allow_unauthenticated_access only: %i[index show]
    before_action :set_todo, only: %i[show edit update destroy]

    def index
      @todos = current_user.todos.order(created_at: :desc)
    end

    def show; end

    def new
        @todo = Todo.new
    end

    def create
      @todo = current_user.todos.build(todo_params)
      if @todo.save
        redirect_to root_path, notice: "Todo was successfully created.", status: :see_other
      else
        redirect_to root_path, alert: "Failed to create todo: #{@todo.errors.full_messages.to_sentence}", status: :see_other
      end
    end

    def edit; end

    def update
        if @todo.update(todo_params)
            redirect_to root_path, notice: "Todo was successfully updated.", status: :see_other
        else
            redirect_to root_path, alert: "Failed to update todo: #{@todo.errors.full_messages.to_sentence}", status: :see_other
        end
    end

    def destroy
      @todo.destroy
      redirect_to root_path, notice: "Todo was successfully deleted.", status: :see_other
    end

    private
    def set_todo
        @todo = current_user.todos.find(params[:id])
    end
    def todo_params
      params.require(:todo).permit(:title)
    end
end
