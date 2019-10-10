set folder = imaps://imap.gmail.com/
set ssl_starttls = yes

set from='jeremy@lambdal.com'
set hostname="lambdal.com"
set realname="Jeremy"

set imap_user='jeremy@lambdal.com'
set imap_pass=$my_pass

set smtp_authenticators = "login"
set smtp_url = "smtps://jeremy@lambdal.com@smtp.gmail.com:465"
set smtp_pass=$my_pass

set spoolfile=+INBOX
set postponed = +[Gmail]/Drafts
mailboxes +Inbox +[Gmail]/Drafts "+[Gmail]/Sent Mail"
