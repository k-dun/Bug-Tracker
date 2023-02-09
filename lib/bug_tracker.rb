#!/usr/bin/env ruby

require 'csv'

@issue = Hash.new
@all_issues = []
@bug_tracker_version = "1.0"

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
  puts "3. Filter and print issues."
  puts "4. Update status of an issue."
  puts "5. Delete an issue."
  puts "6. Generate a report."
  puts "7. Print recent report."
  puts "8. View commits and updates of Bug Tracker 1.0."
  puts "9. Exit."
end

# Select menu option.
def menu_options(menu_choice)
  case menu_choice
  when "1"
    create_issue()
  when "2"
    print_all_issues()
  when "3"
    filter_issues()
  when "4"
    update_status()
  when "5"
    delete_issue()
  when "6"
    generate_report()
  when "7"
    print_report()
  when "8"
    bug_tracker_updates()
  when "9"
    puts "Quitting Bug Tracker #{@bug_tracker_version} ..."
    exit
  else
    puts "Wrong input. Try again!"
  end
end

# CREATE, READ, UPDATE, DELETE METHODS

# Create an issue (bug). Includes a title, description, priority, status.
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
      id = rand(1000..9999).to_s
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
  CSV.open("issues.csv", "a+") do |csv|
    csv << [@issue[:id], @issue[:title], @issue[:description], @issue[:priority], @issue[:status], @issue[:time]]
  end

  puts "Issue saved to issues.csv file!"
  puts ""
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

# Print header for all the issues.
def print_all_issues_header
  puts "-------------"
  puts "Here are all current issues: "
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

# LOAD METHODS

# Pre-load all issues from a file
def load_all_issues
  load_issues() if File.exist?("issues.csv")
end

# Load all issues
def load_issues
  @all_issues = []

  CSV.foreach("issues.csv") do |line|
    @all_issues << { id: line[0], title: line[1], description: line[2], priority: line[3], status: line[4], time: line[5] }
  end
end

# UPDATE METHODS

# Update issue status.
def update_status
  issue_status = ["OPEN", "IN PROGRESS", "FIXED"]
  puts "Choose the ID of the issue you want to update the status of: "
  filter_by_title()
  issue_id = STDIN.gets.chomp

  issue_index = load_specific_issue(issue_id)

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

# DELETE METHODS

# Delete issue record.
def delete_issue

end

# FILTERING METHODS

# Filter by title.
def filter_by_title
  @all_issues.each do |issue|
    puts "#{issue[:id]} | #{issue[:title]} | Status: #{issue[:status]}"
  end
end

# Filter by priority.
def filter_by_priority

end

# Filter by status.
def filter_by_status

end

def load_specific_issue(issue_id)
  @all_issues.each_with_index do |issue, index|
    return index if issue[:id] == issue_id
  end
end

def change_issue_status

end

# REPORT METHODS

# Generate report to a file.
def generate_report

end

# Print report from a file.
def print_report

end

# Print history of updates to the Bug Tracker 
def bug_tracker_updates

end

# MAIN 

interactive_menu()