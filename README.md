nq --- a simpler find
=====================

Find all files with `foo` in their names:

    nq foo

Find all files with extension `.py`:

    nq .py

Find all images:

    nq .png .jpg .gif

Find all images that have `cat` or `dog` somewhere in their names:

    nq cat dog .png .jpg .gif

More features to come.

All searches start from the current directory.
Search is case-insensitive unless there is at least
one upper-case letter in the pattern.

Installation
------------
    cd ~/bin
    ln -s /path/to/nq.sh nq

Author
------
Roberto Bonvallet <rbonvall@gmail.com>
