class WelcomeController < ApplicationController
    allow_unauthenticated_access only: :index # або skip_before_action :require_authentication
  
    def index
      if current_user
        @todos = current_user.todos.order(created_at: :desc)
        @todo  = current_user.todos.build 
      else
        @todos = []
        @todo  = Todo.new
      end
    end
  end