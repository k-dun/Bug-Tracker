#!/usr/bin/env ruby

require 'CSV'

@issues = []
@bug_tracker_version = "1.0"

# USER INTERFACE METHODS

# Main interactive menu to help navigate and interact with the bug tracker.
def interactive_menu
  print_header()
  loop do 
    print_menu()
    menu_options(STDIN.gets.chomp)
  end
end

# Print application's header.
def print_header
  puts "-------------"
  puts "Welcome to Bug Tracker #{@bug_tracker_version}! (author: kdun)"
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

# Create an issue (bug). Includes a title, description, status.
def create_issue

end

# Print all issues.
def print_all_issues

end

# Update issue status.
def update_status

end

# Delete issue record.
def delete_issue

end

# OTHER METHODS

# Filter issues by status.
def filter_issues

end

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

interactive_menu