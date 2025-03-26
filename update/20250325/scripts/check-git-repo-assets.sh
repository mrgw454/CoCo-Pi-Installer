#!/bin/bash

# In order to download assets from private repositories and avoid rate limit issues (60 requests per hour is the default for unauthenticated users), dra must make authenticated requests to GitHub.
# https://github.com/settings/tokens
# export GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# run it like this
# check-git-repo-assets.sh

shopt -s globstar
shopt -s extglob
shopt -s nocasematch

currentDIR=$PWD
currentTIMESTAMP=$(date +%Y-%m-%d_%H.%M.%S)

clear

for d in *; do

	if [ -d "$d" ]; then

		avoid_pattern="*-202?-??-??_??.??.??"
		if [[ "$d" != $avoid_pattern ]]; then

			cd "$d"

			# if .git folder exists, get repo info
			if [ -d ".git" ]; then

				remote_url=$(git config --get remote.origin.url)

				if [[ $remote_url =~ ://([^/]+)/([^/]+)/([^/]+)(\.git)?$ ]]; then
					owner="${BASH_REMATCH[2]}"
					repo_name_tmp="${BASH_REMATCH[3]}"
					repo_name="${repo_name_tmp::-4}"
					echo "$remote_url"
					#echo "Owner: $owner"
					#echo "Repository: $repo_name"

					dra download "$owner/$repo_name"
					echo
					echo

				else
					echo "Could not extract owner and repository name from URL."
					echo
				fi

			fi

		fi

		cd $currentDIR

	fi

done

shopt -u nocaseglob
shopt -u globstar
shopt -u nocasematch

echo
echo Done!
echo
