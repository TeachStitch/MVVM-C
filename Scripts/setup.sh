#!/bin/bash

# Add Homebrew bin directory to PATH
export PATH="$PATH:/opt/homebrew/bin"

# Prompt for project name and deployment target
echo 'Enter project name:'
read project_name
echo 'Enter deployment target (e.g., 15.0):'
read deployment_target

# Validate deployment target (you can add more validation as needed)
if ! [[ $deployment_target =~ ^[0-9]+\.[0-9]+$ ]]; then
  echo "Invalid deployment target format. Please enter a valid version number (e.g., 15.0)."
  exit 1
fi

# Clone the Git repository
git clone https://github.com/TeachStitch/MVVM-C ./$project_name

# Replace placeholders in project.yml
sed -i -e 's#\$PROJECT_NAME\$#'"$project_name"'#g' $project_name/project.yml
sed -i -e 's#\$DEPLOYMENT_TARGET\$#'"$deployment_target"'#g' $project_name/project.yml

# Remove backup files created by sed
rm $project_name/project.yml-e

# Remove Git-related information
rm -rf $project_name/.git

# Change directory to the project
cd ./$project_name

# Generate Xcode project files
xcodegen generate

# Script completed successfully
echo "Project setup is complete. You can now work on your project in the '$project_name' directory."
