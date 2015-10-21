require 'sinatra'
require 'sinatra/reloader'
require 'rspec'
require './spec/tests'
require 'yaml/store'
require 'pry'

require_relative('lib/todo.rb')
require_relative('lib/todo_list.rb')

todo_list = TodoList.new("Josh")
todo_list.add_task(Task.new("Get the milk"))
todo_list.save

# routes
get "/tasks" do
	@tasks = todo_list.tasks
	erb :task_index
end

get "/new_task" do
	erb :new_task
end

post "/create_task" do
	new_task = Task.new(params[:task])
	todo_list.add_task(new_task)
	todo_list.save
	redirect to("/tasks")
end

get "/complete_task/:id" do
	task = todo_list.find_task_by_id(params[:id].to_i)
	task.complete!
	todo_list.save
	redirect to("/tasks")
end

get "/delete_task/:id" do
	task = todo_list.delete_task(params[:id].to_i)
	todo_list.save
	redirect to("/tasks")
end


