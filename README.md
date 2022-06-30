# blogPoster

### What is blogPoster?

blogPoster aims to make it easy to create social-media-style posts and send those posts to both a social-media service and a personal blog.

This is a *very* personal project that I use just about every day. Right now it's a terminal program that uses Ruby and a few gems to take URLs and make quick and easy social-media entries based on them.

blogPoster can also create posts "from scratch," meaning you can begin by inputting a title and text without a URL. You can add any URL you want to any post and even change the URL on the post you're already working on.

The way the app is structured right now, it creates and formats posts for an [Ode](http://ode.io) blog and the [Twitter](http://twitter.com) and [Mastodon](https://joinmastodon.org/) social-media services. 

**Update on 8/8/21:** Mastodon posting has been fixed. The code is much simpler, and I am no longer using the mastodon-api gem. Instead, posting is done with the http gem. Thanks to [this Python-focused article](https://dev.to/bitsrfr/getting-started-with-the-mastodon-api-41jj) for the idea. All I did was "translate" from Python to Ruby.

I'm pretty sure you haven't heard of [Ode](http://ode.io), the Rob Reed-coded, Perl-based blogging software that is inspired by [Bloxsom](http://blosxom.sourceforge.net/) ([see a little more on Wikipedia](https://en.wikipedia.org/wiki/Blosxom)).

I used Ode as my personal blogging system for many years (that site is archived [here](https://stevenrosenberg.nfshost.com/blog/) now), and right now Ode is running [my microblog](http://updates.passthejoe.net).

Ode is well-suited to a project like a personal microblog because it's easy to modify the *themes* to show just the post body, though I don't think that's strictly necessary for a microblog site using a traditional blog CMS like WordPress.

My development roadmap includes modifying this script to create entries for popular static-site generators like [Hugo](https://gohugo.io/) and [Jekyll](https://jekyllrb.com/). This and other development goals are laid out on the project's [issues page](https://github.com/passthejoe/blogPoster/issues) in GitHub.

Adding to the targeted blogging systems should really make this script valuable beyond the extremely small Ode community.

In case you're wondering where the idea of a *microblog* comes from, aside from the fact that your Twitter feed is sort of, kind of, already a microblog, I found inspiration for this project in two microblogging pioneers:

* **Dave Winer**, whose [Scripting News](http://scripting.com) is one of the best personal microblogs out there: [Dave](https://en.wikipedia.org/wiki/Dave_Winer) is an inspiration to me both as a writer and a programmer.

* **Manton Reece**, the creator of [Micro.blog](https://micro.blog): I really like [his writing](https://micro.blog/manton), and even though I had a hard time wrapping my head around what Micro.blog was actually going to become while Manton was planning it, the idea was intriguing. When it turned out that Micro.blog was a hosted subscription service and that apps for it would only be created for Apple devices, what Manton created gave me the push I needed to figure out how to do this on my own.

#### Update on Aug. 9, 2021

* There is now an [official release](https://github.com/passthejoe/blogPoster/releases) of blogPoster. [Version 1](https://github.com/passthejoe/blogPoster/releases/tag/v1.0) is available for download.

### This project is for learning

I came up with this project to solve a problem. But another key purpose is to give me a reason to learn more programming and development skills. This is how I figure out Ruby, git and GitHub. What started as a purely imperative-style script is slowly incorporating Ruby modules and — hopefully in the near-future — classes.

### What do you need to have in place to run blogPoster?

At this point, blogPoster isn't a complete, stand-alone system. It's a Ruby script and a few extra files.

To run the script, you need the Ruby programming language, a compatible text editor and a few Ruby gems.

Install the following Ruby gems:

* `Nokogiri`
* `Twitter`
* `net-sftp`
* `net-ping`
* `http`

And if you are running this program on Windows, install this one too:

* `win32-security` (Without this gem, `net-ping` won't run on Windows systems)

**Tips from the Nokogiri project on installing the gem:** They [offer instructions](https://nokogiri.org/tutorials/installing_nokogiri.html) for Linux, MacOS, Windows, FreeBSD and OpenBSD. 

And as I say above, on Windows computers, you'll have to add the `win32-security` gem. Using `gem install` to add `net-ping` doesn't "require" `win32-security`, but without it the script will crash.

**Note on Ruby Gems:** In response to a tweet about using Linux distribution packages to install Ruby gems, a couple of developers replied to say that they don't recommend using distribution-packaged gems, or even distribution-packaged Ruby. (Many favor the use of [RVM](https://rvm.io/), which is something I'm open to trying but haven't yet. But they definitely are in favor of getting gems via Ruby's `gem install` program. This README formerly contained a great deal of information on installing Ruby gems via Linux package managers, but now I'm using `gem install` for everything, so the documentation now reflects that.

**Which version of Ruby?** As of Jan. 7, 2021, blogPoster — with the proper Ruby gems installed — runs on Ruby 2.5, 2.6 and 2.7 and 3.0 in Linux and 2.5, 2.6, 2.7 and 3.0 in Windows.

I have tested the script *extensively* on Linux and Windows systems, and it works pretty much the same on both. I have done some tests in MacOS, but I need to revisit them.

### Tips for Fedora Linux users

**Update on 4/16/2022:** To run **blogPoster** on Fedora Linux (last tested on F36 Silverblue), add the Ruby programming language, packages for the gems that are in the distribution, and a few development packages so you can build the Twitter gem when you install it with `gem install`:

	$ sudo dnf install ruby ruby-devel gcc ruby-gem-nokigiri rubygem-net-sftp

Then use `gem install` to add the gems you can't get in Fedora:

	$ gem install net-ping twitter
 
**Why does blogPoster use an external text editor, and which one should I choose?**

The biggest variable is your choice of text editor, which the script uses to edit posts. I used the coding and testing of this script as an "excuse" to learn [Vim](https://www.vim.org), and I am glad I did. But the script works very well with other editors. It is *very* compatible with `Notepad` in Windows, though not as compatible with `Notepad++` as I'd like it to be.

I haven't tried a lot of other editors with Linux, but that is something I will do in the future, and I will report the results in this file. I use `vim` in both Windows and Linux, which makes things simple for me. But I understand if you want to use something else.

On some systems, `vim` does the trick. On others, you need to set this editor as `vi`.

As I say below, setting Vim as your preferred blogPoster text editor is a great way to learn Vim. It worked for me.

**What about JRuby (and compatible text editors)?** BlogPoster works with [JRuby](https://www.jruby.org). I tried version 9.2.7.0 in Windows, using `jruby -S gem install` to bring in the `nokogiri` and `Twitter` gems, and the script worked as expected. However, the Ruby `system` command that I use to bring in a text editor doesn't work with as many editors in JRuby as it does in MRuby (aka "normal" Ruby). With JRuby in Windows, console Vim did not work, but I did have success with `GVim` (aka GUI Vim) and `Notepad` (Windows Notepad, not Notepad++). While one of my goals in writing this script and using it was to learn Vim by editing dozens of short text files per day as I edited tweets/posts, you might not have that same goal. And in Windows, as I say above, Notepad (using `notepad` in the configuration) seems to be a VERY reliable editor to use with this script.

**You really don't have to use a text editor with the script if you don't want to.** You can do everything in the console (i.e. at the command line), though bringing in a text editor makes it much easier to craft your posts.

### Do you need a stand-alone blogging system to use blogPoster?

**No.** You can use blogPoster just for posting to Twitter or Mastodon, or just for posting to your blog/microblog. It's flexible that way.

While the blog-posting portion of blogPoster in its default configuration is very much [Ode](http://ode.io)-specific, you can and should modify it for your file-based blogging system. As I say above, this is on my roadmap for the project.

### Uploading to a blog or site via secure FTP

What you need:

* A blog/website that uses "flat" text files
* Acccess to that blog/website via SFTP (usually with a login and password, though I'm pretty sure a public/private key login will also work; I definitely need to test that and add a key option to the SFTP credentials)

As of March 1, 2020, the script uses SFTP — via the `net-sftp` Ruby gem — to transfer files to static sites. I formerly used FTP, and aside from being more secure, the SFTP gem requires about one-third the code of the `net-ftp` library.

To use this app for posting to your blog, you'll need to enter your FTP login and password in the configuration file `blogPoster_configuration.rb`, which is created when you run the `blogPoster.rb` script for the first time and a copy of `blogPoster_configuration_example.rb` is used for this purpose.

The `blogPoster_configuration.rb` file also requires you to enter the path to at least one directory on your server where you want your static text files to go.

That same configuration file also lets you select your file suffix. I use `.txt`, but you can set this to whatever your blog or site requires.

### Posting to Twitter

Before you use the app to post to Twitter, you need to get access to the Twitter API via a [a Twitter Development Account](https://developer.twitter.com/en/docs/basics/developer-portal/overview), which is harder to get than it used to be but not at all impossible.

When you fill out Twitter's online form to "register" your instance of blogPoster, you basically need to tell them you are using a Ruby script to post tweets from your desktop. Once they review your request, they should say "OK," and give you the keys/tokens you need to enter in `blogPoster_configuration.rb` to make the app work with Twitter.

The first time I requested access to the Twitter API, it all went smoothly. All I had to do was tell them what my app was going to do. I had to do this a second time due to changes Twitter made in their API agreement. This time they came back with further questions, and I just restated what I said before. It was the coding equivalent of _"These are not the 'droids you're looking for."_ And it worked.

**Aside:** I would like to turn this into a graphical app that allows users to log in using their Twitter credentials and not require them to get API access, but that's a project for the future.

### Posting to a Mastodon instance

Documentation for posting to Mastodon will go here at some time in the near future.

### Note to developers

If you are running blogPoster and also trying to hack on it using `git`, you might need to make one change in your `.gitignore` file: My blog files end with the suffix `.txt`, and if yours end with another suffix, say `.md` or `.html`, you will need to replace `*.txt` with an appropriate entry so `git` won't commit your entries.

**This will change:** In the near future, this shouldn't be a problem because I'm very strongly considering doing away with the post-file archive. The script doesn't make use of the archived files, and if you successfully use blogPoster to create and post an entry, you should have the actual files on your targeted microblog as an archive. This move will eliminate a few entries in `.gitignore`, reduce the size of the menu by two items (`l` to list the current files and `x` to archive them in a directory) and reduce clutter overall. It's a move in the direction of simplicity.
