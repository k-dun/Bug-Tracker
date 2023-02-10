#!/usr/bin/env ruby

require 'csv'

@issue = Hash.new
@all_issues = []
@bug_tracker_version = "1.0"
@existing_ids = []

# USER INTERFACE METHODS

# Main interactive menu to help navigate and interact with the bug tracker.
def interactive_menu
  print_header()
  loop do
    load_all_issues()
    print_menu()
    menu_options(STDIN.gets.chomp)
  end
end

# Print application's header.
def print_header
  puts "-------------"
  puts "Welcome to Bug Tracker #{@bug_tracker_version}! (author: KDUN)"
  puts "-------------"
end

# Print menu options.
def print_menu
  puts "1. Create an issue."
  puts "2. Print all issues."
  puts "3. Print all active issues."
  puts "4. Filter by status."
  puts "5. Filter by priority."
  puts "6. Update status of an issue."
  puts "7. Update priority of an issue."
  puts "8. Exit."
end

# Select menu option.
def menu_options(menu_choice)
  case menu_choice
  when "1"
    create_issue()
  when "2"
    print_all_issues()
  when "3"
    print_all_active_issues()
  when "4"
    filter_by_status()
  when "5"
    filter_by_priority()
  when "6"
    update_status()
  when "7"
    update_priority()
  when "8"
    puts "Quitting Bug Tracker #{@bug_tracker_version} ..."
    exit
  else
    puts "Wrong input. Try again!"
  end
end

# CREATE, READ, UPDATE, DELETE METHODS

# Create an issue (bug). Includes an ID, title, description, priority, status, time.
def create_issue
  while true do
    puts "Submit information about the issue below.. "
    puts "-------------"
    print "Title: "
    title = STDIN.gets.chomp

    title = "(Missing title)" if title == ""

    print "Description: "
    description = STDIN.gets.chomp

    description = "(Missing description)" if description == ""

    priority = ""

    until ("1".."5").include?(priority) do
      print "Priority (1-5): "
      priority = STDIN.gets.chomp
    end

    puts "-------------"
    print "Submit issue? (y/n) : "
    submit = STDIN.gets.chomp.downcase

    if submit == "y"
      while true do
        id = rand(1000..9999).to_s
        if @existing_ids.include?(id)
          next
        else
          @existing_ids << id
          break
        end
      end

      status = "OPEN"
      time = Time.now.to_s[0..-7]

      @issue = { id: id, title: title, description: description, priority: priority, status: status, time: time }
      save_issue()
      break
    elsif submit == "n"
      print "Do you want to try again? (y/n) : "
      submit = STDIN.gets.chomp

      submit == "y" ? next : break
    else
      puts "Wrong input. Try again!"
      next
    end
  end
end

# SAVE METHODS

# Save issue to the issues.csv file.
def save_issue
  CSV.open("issues.csv", "a") do |csv|
    csv << [@issue[:id], @issue[:title], @issue[:description], @issue[:priority], @issue[:status], @issue[:time]]
  end
end

# PRINT METHODS

# Print all issues (main method).
def print_all_issues
  if File.empty?("issues.csv")
    puts "There are currently no issues tracked!"
  else
    print_all_issues_header()
    print_issues()
  end
end

# Print all active issues. (exclude those with 'FIXED' status)
def print_all_active_issues
  print_all_active_issues_header()
  @all_issues.each do |issue|
    if issue[:status] != "FIXED"
      puts ""
      puts "ID: #{issue[:id]} | Title: #{issue[:title]}"
      puts "Description: #{issue[:description]}"
      puts "Priority level: #{issue[:priority]}"
      puts "Status: #{issue[:status]}"
      puts "Time: #{issue[:time]}"
      puts ""
    end
  end
end

# Print header for all the issues.
def print_all_issues_header
  puts "-------------"
  puts "Here are all the issues: "
end

# Print header for all active issues.
def print_all_active_issues_header
  puts "-------------"
  puts "Here are all the issues: "
end

# Print all issues.
def print_issues
  @all_issues.each do |issue|
    puts ""
    puts "ID: #{issue[:id]} | Title: #{issue[:title]}"
    puts "Description: #{issue[:description]}"
    puts "Priority level: #{issue[:priority]}"
    puts "Status: #{issue[:status]}"
    puts "Time: #{issue[:time]}"
    puts ""
  end
end

# Print snippets of the issues.
def print_snippets
  @all_issues.each do |issue|
    puts "#{issue[:id]} | #{issue[:title]} | Priority: #{issue[:priority]} | Status: #{issue[:status]}"
  end
end

# LOAD METHODS

# Pre-load all issues from a file
def load_all_issues
  load_issues() if File.exist?("issues.csv")
end

# Load all issues
def load_issues
  @all_issues = []

  CSV.foreach("issues.csv", "r") do |line|
    @all_issues << { id: line[0], title: line[1], description: line[2], priority: line[3], status: line[4], time: line[5] }
  end
end

# UPDATE METHODS

# Update issue status.
def update_status
  issue_status = ["OPEN", "IN PROGRESS", "FIXED"]
  puts "Choose the ID of the issue you want to update the status of: "
  print_snippets()
  issue_id = STDIN.gets.chomp

  issue_index = load_issue_by_id(issue_id)

  puts "What would you like to change it to: "
  puts issue_status.join(" / ")
  new_status = STDIN.gets.chomp

  @all_issues[issue_index][:status] = new_status

  CSV.open("issues.csv", "w") do |csv|
    @all_issues.each do |issue|
      csv << [issue[:id], issue[:title], issue[:description], issue[:priority], issue[:status], issue[:time]]
    end
  end

  puts "The status of issue ID: #{issue_id}, has been changed to #{new_status}."
end

# Update issue priority.
def update_priority
  issue_priority = ("1".."5").to_a
  puts "Choose the ID of the issue you want to update the priority of: "
  print_snippets()
  issue_id = STDIN.gets.chomp

  issue_index = load_issue_by_id(issue_id)

  puts "What would you like to change it to: "
  puts issue_priority.join(" / ")
  new_priority = STDIN.gets.chomp

  @all_issues[issue_index][:priority] = new_priority

  CSV.open("issues.csv", "w") do |csv|
    @all_issues.each do |issue|
      csv << [issue[:id], issue[:title], issue[:description], issue[:priority], issue[:status], issue[:time]]
    end
  end

  puts "The priority of issue ID: #{issue_id}, has been changed to #{new_priority}."
end

# FILTERING METHODS

# Filter by status.
def filter_by_status
  puts "Print only issues with desired status."
  print "Choose status (OPEN / IN PROGRESS / FIXED): "
  status = STDIN.gets.chomp

  @all_issues.each do |issue|
    if issue[:status] == status
      puts ""
      puts "ID: #{issue[:id]} | Title: #{issue[:title]}"
      puts "Description: #{issue[:description]}"
      puts "Priority level: #{issue[:priority]}"
      puts "Status: #{issue[:status]}"
      puts "Time: #{issue[:time]}"
      puts ""
    end
  end

  puts "Above are all the issues with the '#{status}' status."
end

# Filter by priority.
def filter_by_priority
  puts "Print only issues with desired priority."
  print "Choose status (1-5): "
  priority = STDIN.gets.chomp

  @all_issues.each do |issue|
    if issue[:priority] == priority
      puts ""
      puts "ID: #{issue[:id]} | Title: #{issue[:title]}"
      puts "Description: #{issue[:description]}"
      puts "Priority level: #{issue[:priority]}"
      puts "Status: #{issue[:status]}"
      puts "Time: #{issue[:time]}"
      puts ""
    end
  end

  puts "Above are all the issues with the '#{priority}' priority."
end

def load_issue_by_id(issue_id)
  @all_issues.each_with_index do |issue, index|
    return index if issue[:id] == issue_id
  end
end

# MAIN 

interactive_menu()