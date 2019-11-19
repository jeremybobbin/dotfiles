set folder="~/.mail/lambda"

set from='jeremy@lambdal.com'
set hostname="lambdal.com"
set realname="Jeremy"

set sendmail="msmtp-enqueue.sh -a lambdal.com"

unset record
unset trash
set spoolfile=+Inbox
set postponed=+Drafts

mailboxes +Inbox +Drafts "+Sent Mail" +Spam +Trash
