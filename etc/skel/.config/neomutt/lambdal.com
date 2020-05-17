# vim: syntax=muttrc
unmailboxes *
set imap_check_subscribed = "yes"
set folder="~/.mail/lambda"

set from='jeremy@lambdal.com'
set hostname="lambdal.com"
set realname="Jeremy"

set sendmail="msmtp-enqueue.sh -a lambdal.com"

unset record
unset trash
set postponed=+Drafts
set spoolfile=+Inbox

mailboxes "+All Mail" +Drafts +Important +Inbox "+Sent Mail" +Spam +Starred +Trash
