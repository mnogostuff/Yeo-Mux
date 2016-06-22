# Needs some love...
crontab -l
find /etc/rc.d/ | while read line; do file $line; done | grep "link to" | sed 's/.* to \(.*\)/\1/' | sort -u
echo "... I can't really parse /etc/profile, .bash* into easy readable"
