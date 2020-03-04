#!/bin/bash

process_git_folder()
{
	# Fetch new status
	git -C $1 fetch 1>/dev/null 2>/dev/null 
	# grep for ahead/behind status
	statusmsg=$(git -C $dir status -sb | grep -oE "((ahead|behind) [0-9]+(, )?){0,2}")
	# Replace "ahead" and "behind" to + and -
	statusmsg=$(echo $statusmsg | sed 's/ahead /+/g; s/behind /-/g; s/ //g')
	# Print the dir
	echo -e "[$statusmsg] \e[01m\e[34m$dir\e[0m"
}

dirs=$(ls -Al | grep "^d" | awk '{print $9}')


for dir in $dirs; do
	# Only look in folders with a .git folder.
	if [ ! -z $dir/.git ]; then
		process_git_folder $dir &
	fi
done

# Wait for all subprocesses to finish. 
wait
