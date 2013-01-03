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

nq calls our beloved find(1) under the hood.
All trailing options are passed verbatim to find:

    nq bieber .mp3 -exec rm '{}' ';'

All searches start from the current directory.
Search is case-insensitive unless there is at least
one upper-case letter in the pattern.

Are you afraid of what nq will do for you?
Do you just want to know what would be executed?
You can ask nq to show you a copy-pasteable version
of the equivalent command line:

    nq -s cat dog .png .jpg .gif

More features to come.

Installation
------------
    cd ~/bin
    ln -s /path/to/nq.sh nq

Author
------
Roberto Bonvallet <rbonvall@gmail.com>
