#!/bin/bash

# Set your new GitHub repository URL
REMOTE_URL="https://github.com/clinty369/pwa-ecom-ui-template-develop.git"

# Start and end dates for your commit range
START_DATE="2020-05-01"
END_DATE="2021-05-01"

# Initialize Git repository
git init
git remote add origin "$REMOTE_URL"
git branch -M main

# Get all files (excluding .git directory)
FILES=($(find . -type f ! -path "./.git/*"))
TOTAL_FILES=${#FILES[@]}
INDEX=0

# Start committing files in a random order with random dates
CURRENT_DATE="$START_DATE"
while [[ "$CURRENT_DATE" < "$END_DATE" && $INDEX -lt $TOTAL_FILES ]]; do
  # Randomly decide whether to commit or not (up to 3 commits per day)
  COMMITS=$(( (RANDOM % 3) + 1 ))  # 1 to 3 commits
  # Randomly skip some days (set 0 to skip)
  SKIP_DAY=$(( RANDOM % 3 ))  # 0 to 2

  if [[ $SKIP_DAY -eq 0 ]]; then
    echo "Skipping commits on $CURRENT_DATE"
  else
    # Commit the selected number of files
    for ((i = 1; i <= COMMITS && INDEX < TOTAL_FILES; i++)); do
      FILE="${FILES[$INDEX]}"
      CLEAN_NAME="${FILE#./}"

      # Set the commit date
      export GIT_AUTHOR_DATE="$CURRENT_DATE 12:0$i:00"
      export GIT_COMMITTER_DATE="$CURRENT_DATE 12:0$i:00"

      echo "Committing '$CLEAN_NAME' on $CURRENT_DATE"
      git add "$FILE"
      git commit -m "$CLEAN_NAME"
      ((INDEX++))
    done
  fi

  # Move to the next date
  CURRENT_DATE=$(date -I -d "$CURRENT_DATE + 1 day")
done

# Push the commits to the GitHub repository
git push -u origin main
