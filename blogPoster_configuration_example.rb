# Configuration for blogPoster

# Pick a text editor to edit title and text of your posts:
# The default is vim for console vim. You can change the value
# of this variable to the executable for any editor
# you wish to use. It might work, it might not.
# 
# For Windows, notepad is a good choice, though I prefer
# vim even in that environment. Gvim also works.
# Check the README for tips on which editors work
# in the various environments you can use
# to run this program.

# I tend to use Vim/Vi, and I've found that while "vim"
# works on some Linux and even Windows systems (with Vim
# installed), my new iMac running Debian 10 wanted "vi"
# instead. Otherwise, it didn't work. Experiment until you
# find what does work.

# Examples:

# @your_text_editor = "vim"
# @your_text_editor = "vi"
# @your_text_editor = "vim"
# @your_text_editor = "gvim"
# @your_text_editor = "nano"
# @your_text_editor = "joe"
# @your_text_editor = "notepad"
# @your_text_editor = "notepad++"


@your_text_editor = "vim"

# Maximum length of file names for blog uploads:
# This is both to keep Ruby from crashing
# and to keep file names at a reasonable length.

@max_file_name_length = 100

# Twitter API

@twitter_consumer_key        = "this_is_a_pretty_long_string_of_characters_for_the_Twitter_API"
@twitter_consumer_secret     = "this_is_an_even_longer_string_of_characters_for_the_Twitter_API"
@twitter_access_token        = "this_is_yet_another_long_string_of_characters_for_the_Twitter_API"
@twitter_access_token_secret = "just_another_long_string_of_characters_for_the_Twitter_API"
@twitter_max_length          = 280

# Mastodon API

@mastodon_base_url			= "http://your.website.com"
@mastdodon_bearer_token		= "a_long_string_of_characters" 

# FTP account and server information

@your_ftp_domain            = "ftp.YOUR_DOMAIN_HERE.com"
@your_ftp_login_name        = "your_FTP_server_login_name"
@your_ftp_password          = "your_FTP_server_password"

@your_ftp_social_directory  = "/here/is/the/path/to/the/directory/where/your/social/posts/live"
@your_ftp_other_directory   = "/here/is/the/path/to/another/directory/on/your/server/totally/optional"

# Set @ping_needed = true if you need to ping a certain URL to "build" your site
# (or its index) after an entry is uploaded. Otherwise set it to false.
# If @ping_needed = true, set @your_website_to_ping = "http://the_actual_url_you_need_to_make_it_happen.
#
# For an Ode site using the Indexette add-in, you would have:
#
# @ping_needed				= true
# @your_website_to_ping = 	"http://your_url.com?reindex=y"
#
@ping_needed                = true

# Change this to the URL that pings your particular web site
@your_website_to_ping 		= "http://myblog.com/requires/calling/a/special/url/to/rebuild/the/index"

# Host to ping -- checking for a live Internet connection
#
# You don't have to change this parameter unless you want to.
# The script pings a known server to check for a live Internet connection, and
# a great "candidate" for this is a big-time DNS server like Cloudflare's 1.1.1.1
#
# Use a well-known server, or one well-known to you. Other candidates include:
# Google's DNS: 8.8.8.8 or 8.8.4.4
# The IP of your own server
@host_to_ping				= "1.1.1.1" 
