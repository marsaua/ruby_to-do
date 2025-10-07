class WelcomeController < ApplicationController
    def index
        if current_user
            @todos = current_user.todos.order(created_at: :desc)
        else
            @todos = []
        end
    end
end
