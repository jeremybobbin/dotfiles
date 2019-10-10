set folder = "~/.mail/lambda"

set from='jeremy@lambdal.com'
set hostname="lambdal.com"
set realname="Jeremy"

set sendmail="/usr/bin/msmtp -a lambdal.com"

set spoolfile=+Inbox
set postponed = +[Gmail]/Drafts
mailboxes +Inbox +[Gmail]/Drafts "+[Gmail]/Sent Mail"
