#  suser

The quick tool to run tools as the current console user.

Don't you hate it when you have to use Python to hit PyObjC to use ObjC just to add the current console user to your shell script? 

## Well... cry no more! suser will help.

suser takes a command and arguments as it's argument and then will run that command as the current console user without you having to futz with finding that out. If suser is not running as root, it won't do anything, and if the current user is has a uid of less than 500, it won't do any thing either. That is unless you tell it to ignore those things.

So doing this as the root user:

`suser touch /tmp/test`

will touch the file `/tmp/test` as the currently signed in console user. This is ideal when you need to run scripts from a root process as the user, like in many self service environments.

## suser options

* -h prints a help statement
* -i ignore if current console user is < uid 500
* -s do not print anything to standard out
* -r ignore if the executing user is root or not
