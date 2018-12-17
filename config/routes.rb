Rails.application.routes.draw do
  root to: "tasks#index"
  resouces :tasks
end
