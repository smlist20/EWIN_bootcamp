#! /usr/bin/env python3
#! python3
# searchIt.py - Launches a Google search using the terms from the
# command line or clipboard.

import webbrowser, sys, pyperclip
if len(sys.argv) > 1:
    # Get address from command line.
    address = '+'.join(sys.argv[1:])
else:
    # Get address from clipboard.
    address = pyperclip.paste().replace(' ', '+')
webbrowser.open('https://www.google.com/#q=' + address)