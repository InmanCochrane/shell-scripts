# shell-scripts
Personal shell scripts, here to share with colleagues and others.

## Suggested setup
1. Clone as a sibling to your shell profile (`.bash-profile`, `.zshrc`, etc.).
2. Modify your shell profile to import/source all SH files within the shell-scripts directory. My instruction to do so looks like this:
```bash
# Import custom shell functions
customShellFunctionsDir="./shell-scripts"
if [ -d $customShellFunctionsDir ]; then
    for f in $customShellFunctionsDir/*.sh; do
        source $f
    done
else
    print "$customShellFunctionsDir not found."
fi
```

