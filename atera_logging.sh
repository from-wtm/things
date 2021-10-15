#!/bin/bash

# Mosyle doesn't run Python from the Custom Commands options; currently just bash and zsh.
# To run Python, or other scripting environments use general format:
#	1. create file on local drive with cat
#	2. modify the permissions on the file so it will run
#	3. run the local script
#	4. delete the local script
# Ensure the scripting environment exists on the endpoint.

# Make a file on the endpoint that is the script.
cat << 'EOF' > "/tmp/script.py"
#!/usr/bin/python
# -*- coding: utf-8 -*-
import json
a_dictionary={'EnableLogging':'1'}

with open("regstore.json", "r+") as file:
    data = json.load(file)
    data.update(a_dictionary)
    file.seek(0)
    json.dump(data, file)
EOF
# Fix permissions for the script.
chmod +x /tmp/script.py
# Run the script.
python /tmp/script.py
# Delete the script so it doesn't linger.
rm -rf /tmp/script.py

launchctl unload /Library/LaunchDaemons/com.atera.ateraagent.plist
sleep 5
launchctl load /Library/LaunchDaemons/com.atera.ateraagent.plist

exit 0