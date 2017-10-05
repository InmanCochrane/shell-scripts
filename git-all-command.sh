#!/usr/bin/env bash

# Function to execute a given command in all direct subdirectories that are git repositories
git-all-command() {

# Check for help or absent flags
if [[ "$#" -eq 0 ]] || [[ "$1" = "-h" ]] || [[ "$1" = "--help" ]]; then
        # Show help info and return
        echo "Runs a given command on all git repos one level below the current or specified directory."
        echo " "
        echo "options:"
        echo -e "\t-h, --help                      show help"
        echo -e "\t-p <path>                       specify the path from which to look one level below for git repos"
        echo -e "\t-c <git command string>         specify the git command, as a string"
        echo -e "\t-l                              include a list of the found git repos in the continuation prompt"
        echo -e "\t-f                              force command to execute without continuation prompt (ignores -l flag)"
        echo " "
        echo "Example: \`git-all-command -l -c \"git status -s\"\` asks for approval to run \"git status -s\" on the listed git repos"
        return
else
        # Parse args
        pflag=''
        ppath='.' # The target path from which to search
        fflag=''
        cflag=''
        lflag=''
        gitcommand='' # The command to run

        while getopts 'p:fc:l' flag; do
                case "${flag}" in
                        p) pflag='true'
                                # FIXME Handle null OPTARG
                                ppath="${OPTARG}";;
                        f) fflag='true';;
                        c) cflag='true'
                                # FIXME Handle null OPTARG
                                gitcommand="${OPTARG}";;
                        l) lflag='true';;
                        *) error "Unexpected option ${flag}";;
                esac
        done

        # Execute based on args
        if [[ ${gitcommand} = '' ]]; then
                # Return with instruction
                echo "No command given. Use -c <git command string>."
                return
        else
                if ! [[ $fflag = 'true' ]]; then
                        # Show continuation prompt
                        belowDirectoryString="the current directory"
                        if [[ ${ppath} != '.' ]]; then
                                belowDirectoryString=${ppath}
                        fi
                        echo -e "This will run the following command on all git repos one level below" ${belowDirectoryString} ":"
                        echo -e "\t"${gitcommand}
                        if [[ $lflag = 'true' ]]; then
                                # List directories that will be targeted
                                echo " "
                                echo "Those directories are:"
                                gitDirs=($(find ${ppath} -maxdepth 1 -mindepth 1 -type d))
                                for gd in $gitDirs; do
                                        (
                                        if [[ -e $gd/.git ]]; then
                                                echo -e "\t $gd"
                                        fi
                                        )
                                done
                                echo " "
                        fi
                        echo "Continue?"
                        select yn in "Yes" "No"; do
                                case $yn in
                                        No ) return;;
                                        Yes ) break;;
                                esac
                        done
                fi

                directories=($(find ${ppath} -maxdepth 1 -mindepth 1 -type d))
                for d in $directories; do
                        (
                        if [[ -e $d/.git ]]; then
                                echo -e $d
                                cd $d
                                sh -c ${gitcommand}
                                echo
                        fi
                        )
                done
        fi
fi
}
