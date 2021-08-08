#!/usr/bin/env ruby

# Blog Poster aims to make social and even regular blog posts
# easy to create. Just entering a URL will help you generate a full
# blog post that includes a file with title, body text and link
# that can be uploaded to the flat-file blogging system of
# your choice.
#
# This script is meant to send posts via FTP to a web server
# for use in an Ode blog, but it can probably be easily modified
# to create posts for other flat-file dynamic systems, such as
# Ode's ancestor Bloxsom.

# It could even be hacked to work with static-blogging systems
# such as Hugo or Jekyll, where you might want to do a straight
# file transfer to your local Documents directory and then trigger
# a build of your site.
#
# Automatic posting to Hugo blogs is on the roadmap.
#
# The other purpose of this script is to send your entry to 
# social-media services Twitter and Mastodon.
#
# For Twitter, you need to open a developer account. The README
# goes over the procedure.
#
# For Mastodon, you need to get an access token for your
# account on your instance. It's marginally easier to do this
# than it is to get "permission" from Twitter, though both are
# very much doable.
#
# This script is written in the Ruby programming language.
# Aside from a few Ruby gems and their dependencies, you will
# need development tools to build the mastodon-api gem
# in Linux. See the README for details.
#
# The README doesn't have the Mastodon access token info yet,
# but it will soon.
# 
# More information on Ode: http://ode.io
#
# Mastodon: https://joinmastodon.org/
#
# The Twitter Developer site: https://developer.twitter.com
#
# The author of this program is Steven Rosenberg (stevenhrosenberg@gmail.com).
#
# It is made available under [the MIT License](https://github.com/passthejoe/blogPoster/blob/master/README.md).
#
# Note the required gems for this program.
#
# The ones you'll have to install are:
#
# nokogiri
# net-sftp
# twitter
# net-ping
#
# and if you are running Windows:
# win32-security
#

require "nokogiri"
require "open-uri"
require "date"
require "net/sftp"
require "fileutils"
require "twitter"
require "http"
require "net/ping"


def check_for_config
    if !File.file?('blogPoster_configuration.rb')
    FileUtils.cp 'blogPoster_configuration_example.rb', 'blogPoster_configuration.rb'
    puts "\n\nEither this is your first time running blogPoster, or the configuration file is missing.\n"
    puts "\nBefore you proceed, quit this program, open blogPoster_configuration.rb in a text editor and fill in your information.\n"
    puts "\nSelect \'q\' to quit.\n"
    else
    require_relative "blogPoster_configuration.rb"
    end
end

check_for_config


# Create the archive directory if it doesn't already exist

def check_for_archive
  Dir.mkdir('archive') if !Dir.exist?('archive')
end

check_for_archive
  

# Load in keys/tokens for Twitter API

def load_twitter_keys
    @client = Twitter::REST::Client.new do |config|
    config.consumer_key        = @twitter_consumer_key
    config.consumer_secret     = @twitter_consumer_secret
    config.access_token        = @twitter_access_token
    config.access_token_secret = @twitter_access_token_secret
    end
end

load_twitter_keys

def which_ruby
	puts "\nYou are running Ruby #{RUBY_VERSION}"
end

def ruby_number
	@our_ruby_number = RUBY_VERSION.to_f
end

# Display the menu, ask for user input and then execute based on
# that input


# Check for a live internet connection with net/ping
# This method prevents the script from crashing if there is
# no internet connection when uploading the post to a blog
# or other web site.

def are_we_connected?(host)
	check = Net::Ping::External.new(host)
	check.ping?
end

# Checking here for a connection -- might as well do that.

def is_computer_connected?
	connected = are_we_connected?(@host_to_ping)
	
	case connected
	when true
		puts "\nThis computer is connected to the internet"
	else
		puts "\nThis computer is NOT connected to the internet"
	end
end

def welcome
	puts "\nWelcome to blogPoster, the command-line program \nthat posts to \
your microblog, Twitter and Mastodon."
end

# Welcome messages

welcome

is_computer_connected?

which_ruby

ruby_number

def runmenu

# The menu is an array of strings with the first and last entries left "blank"
# to provide spacing

menu = ["",
        "a - add a URL",
        "b - new title",
        "c - new text",
        "s - text same as title",
        "t - title same as text",
        "d - URL with post?",
        "e - display file",
        "n - change url",
        "f - save file",
        "g - post file",
        "h - edit title",
        "i - edit text",
        "p - is computer connected?",
        "u - send to Twitter",
        "r - raw post (no link)",
        "l - list unarchived posts",
        "m - send to Mastodon",
        "x - archive posts",
        "q - quit",
        ""
        ]
    
    # Display the menu

    puts menu
    

    
    # Ask user to pick a task
    puts "Choose a task\n\n"
    yourTask = gets.downcase.chomp
    puts "You chose #{yourTask}"
    
        if yourTask == "a"
            # Set booleans for including a URL and social directory
            @urlBool = true
            @socialDirectory = true
            
            # Ask user for a URL
            puts "Enter a URL\n\n"
            @yourURL = gets.chomp
            
            begin
                # Use Nokogiri to open the Web page and get the title
                targetPage = Nokogiri::HTML(URI.open(@yourURL)) 
                @yourTitle = targetPage.css("title")[0].text.chomp
            rescue
                puts "Your URL didn't work\n"
            else
                @yourText = @yourTitle
                
                # To name your post file, use the Date module
                # to get the year in four digits, the month
                # and day in two digits, then use the Time
                # module to get the hours, minutes and seconds
                # -- all as strings using strftime.
                ourYear = Date.today.strftime("%Y")
                ourMonth = Date.today.strftime("%m")
                ourDate = Date.today.strftime("%d")
                ourHour = Time.now.strftime("%H")
                ourMinute = Time.now.strftime("%M")
                ourSecond = Time.now.strftime("%S")
                
                # Crunching the Web page title into the 2nd half of our file name
                
                # Make it all lower case
                fileNameWords = @yourTitle.downcase
                
                # Substitute underscores for spaces
                fileNameWords.gsub!(/\s/, "_")
                
                # Remove all punctuation characters with \p{P}
                # Remove all Math symbols, currency signs, dingbats, etc. with \p{S}
                # Replace all with underscores
                fileNameWords.gsub!(/[\p{P}\p{S}]/, "_")
                
                # Remove doubled underscores
                fileNameWords.gsub!(/_+/, "_")
                
                # Get rid of leading underscore, we will get rid of trailing later
                fileNameWords.gsub!(/^_/, "")
                
                # Create the file name, not including the extension
                @yourFileName = "#{ourYear}" + "_" + "#{ourMonth}" + "#{ourDate}" + "_" + "#{ourHour}" + "#{ourMinute}" + "#{ourSecond}" + "_#{fileNameWords}"
                
                # Trim the full file name, not including the extension,
                # to the length specified by @max_file_name_length
                # in the configuration
                @yourFileName = @yourFileName[0,@max_file_name_length]
                
                # Remove trailing underscores
                @yourFileName.gsub!(/_$/, "")
                
                # Add the file name extension
                @yourFileName = @yourFileName + @file_name_extension
                
                # Print the output to the screen
                puts "\n#{@yourTitle}"
                puts "#{@yourText} <#{@yourURL}>\n\n"
                puts "File name: #{@yourFileName}"
            end
            
            runmenu
            

        elsif yourTask == "b"
            # Ask user for a title
            puts "Enter a title\n\n"
            puts @yourTitle
            @yourTitle = gets.chomp
            puts @yourTitle
            runmenu

        elsif yourTask == "c"
            # Ask user to enter body text
            puts @yourText
            puts "Enter body text\n\n"
            @yourText = gets.chomp
            
            if @urlBool == true
                puts "\n#{@yourTitle}\n\n#{@yourText} <#{@yourURL}>\n"
            else
                puts "\n#{@yourTitle}\n\n#{@yourText}\n"
            end
            
            runmenu
            
        elsif yourTask == "s"
            # Make text the same as title
            puts "Your old title: #{@yourTitle}"
            puts "Your old text: #{@yourText}"
            @yourText = @yourTitle.chomp
            puts "\nYour old title: #{@yourTitle}"
            puts "Your new text: #{@yourText}"
            
            runmenu
            
        elsif yourTask == "t"
            # Make title the same as text
            puts "Your old title: #{@yourTitle}"
            puts "Your old text: #{@yourText}"
            @yourTitle = @yourText
            puts "\nYour new title: #{@yourTitle}"
            puts "Your old text: #{@yourText}"
            
            runmenu

        elsif yourTask == "d"
            # Ask user if they want a URL with the body
            puts "Do you want a URL with this post?"
           urlChoice = gets.chomp
           if urlChoice == "y"
                @urlBool = true
           elsif urlChoice == "n"
                @urlBool = false
           else
                puts "Please pick y or n"
                urlChoice = gets.chomp
            end
            runmenu
        
        elsif yourTask == "r"
            
            # Raw post - no link plus the "now" directory
            
            # Setting boolean variables for presence of a URL
            # and use of an upload directory dedicated to
            # social posts if your blog is set up that way.
            @urlBool = false
            @socialDirectory = false
            puts "Social directory?"
            socialChoice = gets.chomp
            if socialChoice == "y"
                @socialDirectory = true
            end
            
            # Ask user for title and text of the post
            puts "Enter your title:"
            @yourTitle = gets.chomp
            puts "Enter your text:"
            @yourText = gets.chomp
            
             # To name your post file, use the Date module
             # to get the year in four digits, the month
             # and day in two digits, then use the Time
             # module to get time in hours, minutes
             # and seconds -- all as strings
             # using strftime
             ourYear = Date.today.strftime("%Y")
             ourMonth = Date.today.strftime("%m")
             ourDate = Date.today.strftime("%d")
             ourHour = Time.now.strftime("%H")
             ourMinute = Time.now.strftime("%M")
             ourSecond = Time.now.strftime("%S")
            
            # Use the given title to create a file name
            
            # Make it all lower case
            fileNameWords = @yourTitle.downcase
            
            # Substitute underscores for spaces
            fileNameWords.gsub!(/\s/, "_")
            
            # Remove all punctuation characters with \p{P}
            # Remove all Math symbols, currency signs, dingbats, etc. with \p{S}
            # Replace all with underscores
            fileNameWords.gsub!(/[\p{P}\p{S}]/, "_")
            
            # Remove doubled underscores
            fileNameWords.gsub!(/_+/, "_")
            
            # Get rid of leading underscore, we will get rid of trailing later
            fileNameWords.gsub!(/^_/, "")
            
            # Print the output to the screen
            puts fileNameWords
            
            # Create the file name
            @yourFileName = "#{ourYear}" + "_" + "#{ourMonth}" + "#{ourDate}" + "_" + "#{ourHour}" + "#{ourMinute}" + "#{ourSecond}" + "_#{fileNameWords}"
            
             # Trim the full file name, not including the extension,
             # to the length specified by @max_file_name_length
             # in the configuration
             @yourFileName = @yourFileName[0,@max_file_name_length]
            
			 # Remove trailing underscores
			 @yourFileName.gsub!(/_$/, "")
            
			 # Add the file name extension
             @yourFileName = @yourFileName + @file_name_extension
                
             # Print the output to the screen
             puts "\n#{@yourTitle}"
             puts "#{@yourText}\n\n"
             puts "File name: #{@yourFileName}"
			 puts "Social Directory choice = " + socialChoice
             puts "URL Bool = " + @urlBool.to_s
             puts "Social Bool = " + @socialDirectory.to_s
            
             runmenu
    
        elsif yourTask == "e"
            # Display the full post
            puts "Here is your full post:\n\n"
            puts @yourTitle
            if @urlBool == true
                puts "#{@yourText} <#{@yourURL}>"
            else
                puts @yourText
            end
            runmenu
    
        elsif yourTask == "f"
            # Make everything into a file
            puts "I am saving your file so it can be uploaded to your site"
            yourFile = File.new( @yourFileName, "w" )
            yourFile.puts @yourTitle + "\n"
            if @urlBool == true
                yourFile.puts "#{@yourText} <#{@yourURL}>"
            else
                yourFile.puts @yourText
            end
            yourFile.close
            puts "Your file has been saved"
            #
            # This file-rendering routine has been making the
            # files un-deletable by Ruby when those files are
            # created during the same session
            #
            # puts "This is your file:\n\n"
            # File.open( $yourFileName ).each do |line|
            # puts line
            # end
            runmenu
    
        elsif yourTask == "g"
            # send file on its way
			
			# First run the are_we_connected? method to check
			# for a live internet connection
			
			connected = are_we_connected?(@host_to_ping)
			
            # New sftp_upload method uses the Net::SFTP Gem
            
            def sftp_upload
            
				Net::SFTP.start(@your_ftp_domain, @your_ftp_login_name, :password => @your_ftp_password) do |sftp|
				sftp.upload!(@yourFileName, @your_ftp_social_directory + "/" + @yourFileName)
				end
								
			end
			
			# Now do the upload. An 'if/else' block only runs the upload
			# if there is a live internet connection
			
			if connected
			
				sftp_upload
			
				puts "Your file should now be on the server"
			
            
				# If @ping_needed = true, ping the blog so the entry publishes

				if @ping_needed
					yourWebSiteToPing = @your_website_to_ping
            
					puts "Plus I will ping the blog so this new entry publishes"
					puts "Pinging now ..."
					ping_it = URI.open(yourWebSiteToPing).read
					puts "Pinged ... should be ready"
				end
            
            else
            
				puts "You are not connected to the internet"
            
            end

            runmenu
            
        elsif yourTask == 'h'
            # Edit the title
            # Turn the variable into file
            # temp_title_for_editing is the Ruby variable
            # temp_title is the actual file name
            temp_title_for_editing = File.new("temp_title", "w+")
            File.open("temp_title", "a+") { |file| file.write(@yourTitle) }
            temp_title_for_editing.close
            # File.chmod(0666, "temp_title")
            puts "Edit your file in the editor of your choice"
            system(@your_text_editor, 'temp_title')
            temp_title_for_editing = File.open("temp_title", "r")
            @yourTitle = temp_title_for_editing.read
            temp_title_for_editing.close
            puts "Your new title: #{@yourTitle}"
            
            runmenu
            
        elsif yourTask == 'i'
            # Edit the text
            # Turn the variable into file
            temp_text_for_editing = File.new("temp_text", "w+")
            # Write contents of @yourText into the temp_text file
            File.open("temp_text", "a+") { |file| file.write(@yourText) }
            temp_text_for_editing.close
            # Open the file in your text editor
            puts "Edit your file in the editor of your choice"
            system(@your_text_editor, 'temp_text')
            # Put contents of edited temp_text file
            # into temp_text_for_editing variable
            # and then putting that variable's contents into
            # @yourText -- probably could skip a step and write
            # directly to @yourText
            temp_text_for_editing = File.open("temp_text", "r")
            @yourText = temp_text_for_editing.read.chomp
            temp_text_for_editing.close
            puts "Your new text: #{@yourText}"
            
            runmenu
            
        elsif yourTask == 'p'
			is_computer_connected?
			
			runmenu

        elsif yourTask == 'n'
            # Change the URL for the current post
            @urlBool = true
            # Ask user for a URL
            puts "Enter a new URL\n\n"
            @yourURL = gets.chomp

            runmenu

        elsif yourTask == 'x'
            # Archive all the .txt posts
            # (Thanks to https://www.ruby-forum.com/topic/4041707#1055891 for the tip)
            # for :force => true -- http://ruby-doc.org/stdlib-2.2.3/libdoc/fileutils/rdoc/FileUtils.html#method-c-mv
            Dir.glob("*.txt") {|f| FileUtils.move File.expand_path(f), "archive", :force => true }
            puts "Your posts have been archived in the \"archive\" directory"
            # Return to the menu
            runmenu
            
        elsif yourTask == 'l'
            # List "active" files
            active_files = Dir.glob("*.txt")
            puts active_files
            # Return to the menu
            runmenu
            
        elsif yourTask == 'u'
            # Send to Twitter
            puts "Sending this post to Twitter"
            puts "First checking the length ...\nTweets cannot exceed #{@twitter_max_length} characters,\nincluding the URL ...\n"
            checking_length = @yourText + @yourURL if @urlBool
            checking_length = @yourText if !@urlBool
            puts "Your post length is #{checking_length.length} characters"
            length_ok = true if checking_length.length <= @twitter_max_length
        
            begin
                if @urlBool && length_ok
                    puts "Your post is not too long ..."
                    @yourText = @yourText.chomp
                    @client.update("#{@yourText} #{@yourURL}")
                    puts "Post sent to Twitter"
                elsif length_ok
                    puts "Your post is not too long ..."
                    @yourText = @yourText.chomp
                    @client.update("#{@yourText}")
                    puts "Post sent to Twitter"
                else
                    puts "Please shorten your text length to
                    #{@twitter_max_length} characters, including any
                    URL that is included.
                    Click 'i' to edit your text"
                end
            rescue
                puts "\nSomething happened with Twitter"
                puts "Your tweet did not go through"
            else
                puts "Success!"
            end
           
            # Return to the menu
            runmenu
            
        # Mastodon notes: The mastodon/mastodon-api gem and the twitter gem are causing
        # some kind of conflict in Windows. Maybe try a newer Ruby to see if it
        # can be resolved.
        #
        # To install the mastodon-api gem in Debian first you need the ruby-dev package
        # so you can build local gems:
        #
        # $ sudo apt install ruby-dev
        # $ sudo apt gem install mastodon-api
        #
        # In the configuration file, @mastodon_base_url is the URL of your Mastodon instance
        # @mastodon_bearer_token is the token you need to access your Mastodon account
        # on your instance.
        #
        # You can get this token at:
        # Access Token Generator for Mastodon API
        # https://takahashim.github.io/mastodon-access-token/
        # Mastodon URL is your instance's URL
        # Client Name is your app name (e.g. blogPoster)
        # Web site is where you want the client name to link on your live post
        # for Scopes, pick Read Writer
        # The access_token this web site generates is your @mastodon_bearer_token
        #    
        
        elsif yourTask == 'm'
            # Send to Mastodon
            puts "Sending this post to your Mastodon instance"
            puts "First checking the length ...\nToots cannot exceed #{@mastodon_max_length} characters,\nincluding the URL ...\n"
            checking_length = @yourText + @yourURL if @urlBool
            checking_length = @yourText if !@urlBool
            puts "Your post length is #{checking_length.length} characters"
            length_ok = true if checking_length.length <= @mastodon_max_length
        
            begin
                                
                if @urlBool && length_ok
				puts "Your post is not too long ..."
        	        @yourText = @yourText.chomp
	               	mastodon_client = Mastodon::REST::Client.new(base_url: @mastodon_base_url, bearer_token: @mastodon_bearer_token)
			mastodon_client.create_status(@yourText + " " + @yourURL, {:sensitive => false})
			puts "Post sent to Mastodon"
					
                elsif length_ok
                	puts "Your post is not too long ..."
                	@yourText = @yourText.chomp
                	mastodon_client = Mastodon::REST::Client.new(base_url: @mastodon_base_url, bearer_token: @mastodon_bearer_token)
                	mastodon_client.create_status(@yourText, {:sensitive => false})
                    	puts "Post sent to Mastodon"
                
				else
		        puts "Please shorten your text length to
                    	#{@mastodon_max_length} characters, including any
                    	URL that is included.
                    	Click 'i' to edit your text"
                end
		
		rescue
			puts "\nSomething happened with Mastodon"
			puts "Your toot did not go through"
			# ruby_number
            #   if RUBY_VERSION.include? "2.7"
			if @our_ruby_number >= 2.7
               print "\n... unless you are running Ruby 2.7 or later,\nwhich this program says is the case.\n\nFor Mastodon users who are running\nRuby 2.7 or later, check your instance.\nIt is very likely your toot\nhas been posted.\n"
		end
		else
			puts "Success!"
	    end
	       
            # Return to the menu
            runmenu
            
        elsif yourTask == 'q'
            puts "Goodbye ..."
            exit
    
        else
            puts "Your choice isn't in the list above, so enter it again"
            runmenu
		end

end

# Return to the menu
runmenu
