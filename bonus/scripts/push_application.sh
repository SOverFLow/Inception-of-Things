#!/bin/bash
GITLAB_REPO_URL="http://oauth2:$GitLab_ACCESS_TOKEN@localhost:8888/root/myapp.git"
TEMP_DIR=$(mktemp -d)
REPO_NAME=$(basename "$GITLAB_REPO_URL" .git)
SOURCE_DIR="../confs/app/"
COMMIT_MESSAGE="Add confs/app directory"

# Clone the repository
echo "Cloning repository..."
git clone "$GITLAB_REPO_URL" "$TEMP_DIR/$REPO_NAME"

# Check if clone was successful
if [ $? -ne 0 ]; then
  echo "Failed to clone the repository. Please check the URL and access token."
  exit 1
fi

# Copy the ../confs/app directory into the repository
echo "Copying $SOURCE_DIR to the repository..."
cp -r "$SOURCE_DIR" "$TEMP_DIR/$REPO_NAME"

# Move into the cloned repository
cd "$TEMP_DIR/$REPO_NAME"

# Stage the changes
git add -A

# Commit the changes
echo "Committing changes..."
git commit -m "$COMMIT_MESSAGE"

# Push the changes
echo "Pushing changes to the repository..."
git push origin main

# Check if push was successful
if [ $? -eq 0 ]; then
  echo "Changes pushed successfully!"
else
  echo "Failed to push changes. Please check your permissions and network connection."
  exit 1
fi

# Clean up
echo "Cleaning up..."
cd -
rm -rf "$TEMP_DIR"

echo "Done!"