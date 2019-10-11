set folder="~/.mail/lambda"

set from='jeremy@lambdal.com'
set hostname="lambdal.com"
set realname="Jeremy"

set sendmail="/usr/bin/msmtp -a lambdal.com"

set spoolfile=+Inbox
set postponed=+Drafts
set trash=+Trash

mailboxes +Inbox "+All Mail" +Drafts +Important "+Sent Mail" +Spam +Starred +Trash
