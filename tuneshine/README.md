Makes shairport status available at localhost:8000 for Tuneshine Pi Nano relay

# How it works
Shairport updates contents of /var/shairport-status when active/inactive
(https://github.com/mikebrady/shairport-sync/blob/master/ADVANCED%20TOPICS/Events.md)

~Python~ Node Webserver serves file content in /var/shairport-status

# Install
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt install -y nodejs
