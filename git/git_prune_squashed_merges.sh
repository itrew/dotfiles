#!/usr/bin/bash
#
# This script deletes all local branches that were squashed and merged (such
# as from the GitHub / GitLab web UI).
#
# Modified from https://stackoverflow.com/a/56026209/1354930
# Modified from https://github.com/dougthor42/dotfiles/commit/6b65e53822391e150e6163d1648c8947f6f9bd05
#
# It supports a "dry run" mode with either the '-n' or '--dry-run' arg.
#
# Add as an alias using git config alias.prunesq '!bash ./git_prune_squashed_merges.sh'

DRY_RUN=0 																												# default is not a dry run

# Argument parser
# See https://stackoverflow.com/a/33826763/1354930
while [[ "$#" -gt 0 ]]; 																								# while the number of arguments is greater than 0
do
	case $1 in 																											# switch on the first argument in the list
		-n | --dry-run) 																								# if the argument is either -n or --dry-run
			DRY_RUN=1																									# set DRY_RUN to 1 and shift the arguments
			shift																										# shift to the next argument
			;;
		*)																												# all other arguments
			echo "Unknown parameter passed: $1"																			# output indicating invalid option
			exit 1																										# exit with a status of 1
			;;
	esac
done


echo "Pruning local branches that were squashed and merged onto main..."


if [[ $DRY_RUN -eq 1 ]]																									# if DRY_RUN is set to 1
	then
		echo "DRY RUN - no branches will be deleted.";																	# Log out if this is a dry run or not
fi;


# Prune local branches that we squashed and merged.
git checkout -q main &&																									# checkout the main branch, -q quiets outputs
git for-each-ref refs/heads/ "--format=%(refname:short)" |																# genereates a list of local branches e.g. main, scale-labels
while read BRANCH;																										# process the listed branches 1 by 1, the branch name is read into the variable $BRANCH
	do
		if [[ "$BRANCH" == "main" ]]
			then
				continue;
		fi;
		echo "Checking branch $BRANCH...";

		MERGE_BASE=$(git merge-base main $BRANCH);																		# finds the common ancestor commit between main and the current branch and sets it to $MERGE_BASE
		TREE_OBJECT=$(git rev-parse "$BRANCH^{tree}");																	# gets the git tree object associated with the current branch
		COMMIT_HASH=$(git commit-tree $TREE_OBJECT -p $MERGE_BASE -m _);												# creates a new commit of the branches tree onto the parent being the merge base
		CHECK=$(git cherry main $COMMIT_HASH);																			# determines if there are any commits that are equivalent between main and the new commit

		if [[ "$CHECK" == "-"* ]]
			then
				if [[ $DRY_RUN -eq 1 ]]																					# check if this is a dry run
					then
						echo "$BRANCH is merged into main and can be deleted.";											# if it is a dry run, just output the name of the branch that can be deleted
					else
						echo "$BRANCH is merged into main and will be deleted.";										# if it is not a dry run, output the name of the branch and then force delete the branch
						git branch -D $BRANCH;
				fi;
			else
				echo "$BRANCH has not been merged yet.";
		fi;
done;

echo "Done."
