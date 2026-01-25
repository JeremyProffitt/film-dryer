# Git Push Workflow

Execute the following workflow to commit, push, and validate the release.

## Step 1: Commit All Changes

1. Run `git status` to see all changes
2. Stage all modified and new files
3. Create a commit with a descriptive message summarizing the changes
4. Follow standard commit message conventions

## Step 2: Push to GitHub

1. Push the commit(s) to the remote repository
2. Note the commit SHA for reference

## Step 3: Validate Pipeline

1. Check the GitHub Actions pipeline status using `gh run list --limit 1`
2. Watch the pipeline using `gh run watch` and wait for it to complete
3. **If pipeline succeeds**: Proceed to Step 4
4. **If pipeline fails**:
   - Analyze the failure logs using `gh run view <run-id> --log-failed`
   - Identify and fix the issue
   - Commit the fix
   - Push again
   - Repeat until pipeline succeeds

## Step 4: Validate Release Links

After a successful pipeline run, verify that all links in markdown files point to valid release assets:

1. **Get the repository path** from the git remote URL using `git remote get-url origin`
2. **List the release assets** using `gh release view --json assets -q '.assets[].name'`
3. **Check each link** in `README.md` and design `.md` files that references:
   - `https://github.com/<owner>/<repo>/releases/latest/download/<file>`
4. **Verify expected assets exist** for each `.scad` file:
   - `<name>.stl` - The generated STL file
   - `<name>_front.png` - Front view render
   - `<name>_rear.png` - Rear view render
5. **If links are invalid** (asset doesn't exist or wrong owner/repo path):
   - Update the markdown files with correct links
   - Commit the fix
   - Push to GitHub
   - Re-validate the pipeline completes successfully
   - Re-validate the links are correct

## Quick Reference Commands

```bash
# Check pipeline status
gh run list --limit 5

# Watch the latest run
gh run watch

# View failed logs
gh run view <run-id> --log-failed

# List release assets
gh release view --json assets -q '.assets[].name'

# Get repo URL
git remote get-url origin
```
