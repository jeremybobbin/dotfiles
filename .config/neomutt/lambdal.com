set imap_user='jeremy@lambdal.com'
set imap_pass=$my_pass
set smtp_pass=$my_pass
set folder = imaps://imap.gmail.com/
set header_cache = "~/.mutt/cache/headers"
set message_cachedir = "~/.mutt/cache/bodies"
set certificate_file = "~/.mutt/certificates"
set smtp_url = "smtps://jeremy@lambdal.com@smtp.gmail.com:465"
set ssl_starttls = yes
set smtp_authenticators = "login"
set move = no
set imap_keepalive = 900

set smtp_pass=$my_pass



set from='jeremy@lambdal.com'
set hostname="lambdal.com"
set realname='Jeremy Bobbin'

set postponed = +[Gmail]/Drafts
mailboxes +Inbox +[Gmail]/Drafts "+[Gmail]/Sent Mail"

set spoolfile=+INBOX
set postponed=+Drafts

