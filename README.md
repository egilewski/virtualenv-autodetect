virtualenv-autodetect
=====================

Makes you forget that you have virtualenv's (if you use cd). Works in Zsh and Bash.

Installation
------------

Add this line to your .zshenv, .bashrc or .bash-profile:

```source /path/to/virtualenv-autodetect.sh```

Notes
-----

Virtualenv will be activated automatically when you enter the
directory or it's descendant of any depth.

Active virtualenv will be replaced with deeper one on changing dir to it.

Virtualenv will be deactivated automatically upon changing dir to one
that has no parent virtualenv.

Virtualenv directory is detected automatically by bin/activate inside it.

Venv prefix won't be shown as it's not needed any more (for me at least).

Works in Zsh and Bash.

Inspired and faintly based on https://gist.github.com/2211471
