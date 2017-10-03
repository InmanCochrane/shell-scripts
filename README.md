# shell-scripts
Personal shell scripts, here to share with colleagues and others.

## Suggested Setup
1. Clone as a sibling to your shell profile (`.bash-profile`, `.zshrc`, etc.).
* Alternatively, you could save it wherever you'd like and modify the specified path in the snippet below (or in your own snippet).
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

