set folder = imaps://imap.gmail.com/
set ssl_starttls = yes

set from='jeremy@lambdal.com'
set hostname="lambdal.com"
set realname="Jeremy"

set imap_user='jeremy@lambdal.com'
set imap_pass=$my_pass

set sendmail="/usr/bin/msmtp -a lambdal.com"

set spoolfile=+INBOX
set postponed = +[Gmail]/Drafts
mailboxes +Inbox +[Gmail]/Drafts "+[Gmail]/Sent Mail"
