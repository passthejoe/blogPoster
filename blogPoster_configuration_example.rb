
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

# FTP account and server information

@your_ftp_domain            = "ftp.YOUR_DOMAIN_HERE.com"
@your_ftp_mode_passive      = true
@your_ftp_login_name        = "your_FTP_server_login_name"
@your_ftp_password          = "your_FTP_server_password"

@your_ftp_social_directory  = "/here/is/the/path/to/the/directory/where/your/social/posts/live"
@your_ftp_other_directory   = "/here/is/the/path/to/another/directory/on/your/server/totally/optional"

@ping_needed                = true
@your_website_to_ping = "http://myblog.com/requires/calling/a/special/url/to/rebuild/the/index"
