#!/usr/bin/env ruby

# Blog Poster aims to make social and even regular blog posts
# easy to create. Just entering a URL will help yuou generate a full
# blog post that includes a file with title, body text and link
# that can be uploaded to the flat-file blogging system of
# your choice
#
# This script is meant to send posts via FTP to a web server
# for use in an Ode blog, but it can probably be easily modified
# to create posts for other flat-file dynamic systems, such as
# Ode's ancestor Bloxsom. It could even be hacked
# to work with static-blogging systems such as Hugo or Jekyll,
# where you might want to do a straight file transfer to your
# local Documents directory and then trigger a build of your site.
#
# The other purpose of this script is to send your entry to a
# social-media service such as Twitter. That is what the script does
# at this point. You need to open a developer account with Twitter
# to get access to the service's API. The README for this program
# has more information on how to do that.

# 
# More information on Ode: http://ode.io
#
# 
# The author of this program is Steven Rosenberg (stevenhrosenberg@gmail.com).
# It is made available under the MIT License.

require "nokogiri"
require "open-uri"
require "date"
require "net/ftp"
require "fileutils"
require "twitter"

def check_for_config
    if !File.file?('blogPoster_configuration.rb')
    FileUtils.cp 'blogPoster_configuration_example.rb', 'blogPoster_config.rb'
    puts "Either this is your first time running blogPoster, or the configuration file is missing. Before you proceed, open blogPoster_configuration.rb in a text editor and fill in your information.\n
    Select \'q\' to quit.\n"
    
    else
    require_relative "blogPoster_configuration.rb"
    
    end
end

check_for_config


# Create the archive directory if it doesn't already exist

def check_for_archive
  Dir.mkdir('archive') if !Dir.exists?('archive')
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

# Display the menu, ask for user input and then execute based on
# that input

def runmenu

# The menu is an array with the first and last entries left "blank"
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
        "u - send to Twitter",
        "r - raw post (no link)",
        "l - list unarchived posts",
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
                targetPage = Nokogiri::HTML(open(@yourURL)) 
                @yourTitle = targetPage.css("title")[0].text.chomp
            rescue
                puts "Your URL didn't work\n"
            else
                @yourText = @yourTitle
                # To name your post file, use the Date module
                # to get the year in four digits, and the month
                # and day in two digits -- all as strings
                # using strftime
                ourYear = Date.today.strftime("%Y")
                ourMonth = Date.today.strftime("%m")
                ourDate = Date.today.strftime("%d")
                # Crunching the Web page title into the 2nd half of our file name
                # Make it all lower case
                yourFileExtension = @yourTitle.downcase
                # Substitute underscores for spaces
                yourFileExtension.gsub!(/\s/, "_")
                # Remove all punctuation characters with \p{P}
                # Remove all Math symbols, currency signs, dingbats, etc. with \p{S}
                # Replace all with underscores
                yourFileExtension.gsub!(/[\p{P}\p{S}]/, "_")
                # Remove doubled underscores
                #yourFileExtension.gsub!("_{2}", "_")
                # This used to have "" sted "_" -- 2017_1222
                #yourFileExtension.gsub!(/__/, "_")
                #yourFileExtension.gsub!(/__/, "_")
                # Get rid of doubled underscores
                yourFileExtension.gsub!(/_+/, "_")
                # Get rid of leading and trailing underscores
                yourFileExtension.gsub!(/^_|_$/, "")
                # Get rid of blank spaces -- added 2/5/18
                # note: could also get rid of doubled spaces earlier
                #yourFileExtension.gsub!(" ", "")
                
                @yourFileName = "#{ourYear}" + "_" + "#{ourMonth}" + "#{ourDate}" + "_#{yourFileExtension}.txt"
                #if (urlBool = true)
                #      $yourText = "#{$yourTitle} <#{$yourURL}>"
                # else
                #     $yourText = "#{$yourTitle}"
                #  end
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
            @urlBool = false
            @socialDirectory = false
            puts "Social directory?"
            socialChoice = gets.chomp
            if socialChoice == "y"
                @socialDirectory = true
            #elsif socialChoice == "n"
             #   $socialDirectory = false
            end
            puts "Enter your title:"
            @yourTitle = gets.chomp
            puts "Enter your text:"
            @yourText = gets.chomp
            
            # To name your post file, use the Date module
            # to get the year in four digits, and the month
            # and day in two digits -- all as strings
            # using strftime
            ourYear = Date.today.strftime("%Y")
            ourMonth = Date.today.strftime("%m")
            ourDate = Date.today.strftime("%d")
            
            yourFileExtension = @yourTitle.downcase
            # Substitute underscores for spaces
            yourFileExtension.gsub!(/\s/, "_")
            # Remove all punctuation characters with \p{P}
            # Remove all Math symbols, currency signs, dingbats, etc. with \p{S}
            # Replace all with underscores
            yourFileExtension.gsub!(/[\p{P}\p{S}]/, "_")
            # Remove doubled underscores
            # yourFileExtension.gsub!("_{2}", "_")
            yourFileExtension.gsub!(/__/, "")
            puts yourFileExtension
            @yourFileName = "#{ourYear}" + "_" + "#{ourMonth}" + "#{ourDate}" + "_#{yourFileExtension}.txt"
            puts yourFileExtension
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
            puts "I am sending your file where it's supposed to go"
            
            yourFtpUpload = Net::FTP.new(@your_ftp_domain)
            yourFtpUpload.passive = @your_ftp_mode_passive
            yourFtpUpload.login(user = @your_ftp_login_name, password = @your_ftp_password)
            if @socialDirectory == true
                yourFtpUpload.chdir(@your_ftp_social_directory)
            else
                yourFtpUpload.chdir(@your_ftp_other_directory)
            end
            
            yourFtpUpload.puttextfile(@yourFileName)
            yourFtpUpload.close
            if @socialDirectory == true
                puts "Uploading to the social directory"
            else
                puts "Uploading to non-social directory"
            end
        
            puts "Your file should now be on the server"
            
            # If @ping_needed = true, ping the blog so the entry publishes

            if @ping_needed
                yourWebSiteToPing = @your_website_to_ping
            
                puts "Plus I will ping the blog so this new entry publishes"
                puts "Pinging now ..."
                ping_it = open(yourWebSiteToPing).read
                puts "Pinged ... should be ready"
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
        
            
        elsif yourTask == 'q'
            puts "Goodbye ..."
            exit
    
        else
            puts "Your choice isn't in the list above, so enter it again"
            runmenu
    end
end

# Run the method the first time the program is executed
runmenu
