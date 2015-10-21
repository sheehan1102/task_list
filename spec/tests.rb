RSpec.describe "Todo List" do
	before :each do
		@task = Task.new("Get the milk")
		@todo = TodoList.new("Josh")
	end
	
	it "makes sure a new task is not complete" do
		expect(@task.complete?).to be false
	end

	it "makes sure a complete task is complete" do
		@task.complete!
		expect(@task.complete?).to be true
	end

	it "makes a complete task incomplete" do
		@task.complete!
		@task.make_incomplete!
		expect(@task.complete?).to be false
	end

	it "makes sure there is a timestamp" do
		expect(@task.created_at).to be_truthy
	end

	it "updates the task content" do
		@task.update_content!("Walk the dog")
		expect(@task.content).to eq("Walk the dog")
	end

	it "expects updated_at" do
		@task.update_content!("Eat the fish")
		expect(@task.content).to be_truthy
	end

	it "updates the todo list" do
		@todo.add_task(@task)
		expect(@todo.tasks.select { @task }).to be_truthy
	end

	it "deletes a task by id" do
		@todo.add_task(@task)
		@todo.delete_task(@task.id)
		array = @todo.tasks.select { @task }
		expect(array.size).to eq(0)
	end

	it "finds a task by id in todo list" do
		@todo.add_task(@task)
		found_tasks = @todo.find_task_by_id(@task.id)
		expect(found_tasks.first.id).to eq(@task.id)
	end

	it "returns nil if there is no task" do
		@todo.add_task(@task)
		found_tasks = @todo.find_task_by_id(@task.id)
		expect(@todo.find_task_by_id(0)).to eq(nil)
	end

	it "sorts the tasks by created_at" do
		task2 = Task.new("Get some stuff later.")
		task2.instance_variable_set(:@created_at, Time.now + 70000)
		@todo.add_task(task2)
		@todo.add_task(@task)
		sorted_array = @todo.sort_by_created
		expect(sorted_array.first.created_at).to be < sorted_array.last.created_at
	end

	it "sorts the tasks by created_at, descending" do
		task2 = Task.new("Get some stuff later.")
		task2.instance_variable_set(:@created_at, Time.now + 70000)
		@todo.add_task(@task)
		@todo.add_task(task2)
		sorted_array = @todo.sort_by_created('DESC')
		expect(sorted_array.first.created_at).to be > sorted_array.last.created_at
	end

	it "tells is if a todo list has a user" do
		expect(@todo.user).to be_truthy
	end

	it "save and get info" do
		@todo.add_task(@task)
		@todo.add_task(Task.new("This should come back"))
		@todo.save
		new_list = TodoList.new("Josh").load_tasks
		expect(new_list.size).to eq(2)
	end
end







