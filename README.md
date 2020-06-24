## blogPoster

#### News on June 24, 2020

I figured out the conflict between two Ruby gems, `mastodon-api` and `twitter` that made the script crash in some instances. Both gems have the `http` gem as a dependency, but the newer version that `twitter 7.0.0` requires is too "new" for `mastodon-api`. Until `mastodon-api` requires the same version of `http`, when installing the `twitter` gem, please specify `twitter 6.2.0`.

That is generally done like this (add `sudo` where appropriate):

	$ gem install twitter -v 6.2.0
	
More instructions on gem installation have been added to this README below.

#### News on June 21, 2020

* The move from `master` to `main` didn't go as smoothly as I would have liked. The problems grew from my git setup that pushed to two separate remote repositories. I am re-configuring to push to a single repo. This project is staying on GitHub. My [Zen of Debian](https://codeberg.org/passthejoe/zen-of-debian) project is still on both sites but will probably land on Codeberg.

I made the mistake of using Stack Overflow posts and random blog entries that had me changing my `.git/config` file in order to push to two remote repositories with a single `git push origin master`. I seemed to have it working OK for awhile, but the `master-to-main` switch wasn't kind to that jury-rigged setup.

My biggest error is getting my `.git/config` commands mixed up between this repo and Zen of Debian. Hilarity (and the completely wrong files) ensued. I killed the Codeberg repo for blogPoster as a result.

I think (or _hope_ at any rate) there is a better way to maintain two separate remotes with one mirroring the other that doesn't involve pushing to two at once.

#### News on June 15, 2020

* I agree with [the movement that says](https://www.zdnet.com/article/github-to-replace-master-with-alternative-term-to-avoid-slavery-references/) the technology terms "master/slave" should go away, and the primary Git repository in this project is now called `main` instead of `master`.

#### News on June 10, 2020

* The `network_ping` feature has landed. Now the script will check for a live internet connection before attempting to upload a file to the blog.

* **Mastodon posting** is now working. Documentation is inline in the script, but it should move to this README soon. I haven't tested whether this works with [Pleroma](https://pleroma.social/), but I will.

* Next on the roadmap: Posting to a **Hugo** blog.

### What is blogPoster?

blogPoster aims to make it easy to create social-media-style posts and send those posts to both a social-media service and a personal blog.

This is a *very* personal project that I use just about every day. Right now it's a terminal program that uses Ruby and a few gems to take URLs and make quick and easy social-media entries based on them.

blogPoster can also create posts "from scratch," meaning you can begin by inputting a title and text without a URL. You can add any URL you want to any post and even change the URL on the post you're already working on.

The way the app is structured right now, it creates and formats posts for an [Ode](http://ode.io) blog and the [Twitter](http://twitter.com) and [Mastodon](https://joinmastodon.org/) social-media services. 

Mastodon posting is new. It works, but I need to add more documentation.

I'm pretty sure you haven't heard of [Ode](http://ode.io), the Rob Reed-coded, Perl-based blogging software that is inspired by [Bloxsom](http://blosxom.sourceforge.net/) ([see a little more on Wikipedia](https://en.wikipedia.org/wiki/Blosxom)).

I have been using Ode as my personal blogging system for many years now, and right now Ode is running [my microblog](http://updates.passthejoe.net).

Ode is well-suited to a project like a personal microblog because it's easy to modify the *themes* to show just the post body, though I don't think that's strictly necessary for a microblog site using a traditional blog CMS like WordPress.

My development roadmap includes modifying this script to create entries for popular static-site generators like [Hugo](https://gohugo.io/) and [Jekyll](https://jekyllrb.com/). This and other development goals are laid out on the project's [issues page](https://github.com/passthejoe/blogPoster/issues) in GitHub.

Adding to the targeted blogging systems should really make this script valuable beyond the extremely small Ode community.

In case you're wondering where the idea of a *microblog* comes from, aside from the fact that your Twitter feed is sort of, kind of, already a microblog, I found inspiration for this project in two microblogging pioneers:

* **Dave Winer**, whose [Scripting News](http://scripting.com) is one of the best personal microblogs out there: [Dave](https://en.wikipedia.org/wiki/Dave_Winer) is an inspiration to me both as a writer and a programmer.

* **Manton Reece**, the creator of [Micro.blog](https://micro.blog): I really like [his writing](https://micro.blog/manton), and even though I had a hard time wrapping my head around what Micro.blog was actually going to become while Manton was planning it, the idea was intriguing. When it turned out that Micro.blog was a hosted subscription service and that apps for it would only be created for Apple devices, what Manton created gave me the push I needed to figure out how to do this on my own.

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
* `mastodon-api`

And if you are running this program on Windows, install this one, too:

* `win32-security` (Without this gem, `net-ping` won't run on Windows systems)

The `Nokogiri` and `net-sftp` gems are available as a package in most Linux distributions, which works great if you are using your distribution's Ruby implementation.

Some Linux distributions have packaged the `Twitter` gem. Debian and Ubuntu offer it. Fedora does not: Use Ruby's `gem` command can be used to add it.

And as I say above, on Windows computers, you'll have to add the `win32-security` gem. Using `gem install` to add `net-ping` doesn't "require" `win32-security`, but without it the script will crash.

* On Debian/Ubuntu Linux systems, in order to successfully install the Mastodon gem with `sudo gem install mastodon-api`, you must first install the proper development tools:

	$ sudo apt install ruby-dev gcc make
then ...
	$ sudo gem install mastodon-api
	
* There is a conflict between the `twitter` and `mastodon-api` Ruby gems. `twitter 7.0.0` and `mastodon-api` use different versions of the `http` gem, and the script crashes when both are installed. The current workaround is to install an older version of the `twitter` gem.

The `twitter` packaged in most Linux distributions is version 6.x, so there is no problem if you use apt to install it in Debian/Ubuntu distros.

But in Windows, `twitter 7.0.0` won't work. Instead install version 6.2.0 like this:

	$ gem install twitter -v 6.2.0

I will keep an eye on this situation, and I need to do a test in Fedora to see if everything works.

**Note on Ruby Gems:** In response to a tweet about using Linux distribution packages to install Ruby gems, a couple of developers replied to say that they don't recommend using distribution-packaged gems, or even distribution-packaged Ruby. (Many favor the use of [RVM](https://rvm.io/), which is something I'm open to trying but haven't yet. But they definitely are in favor of getting gems via Ruby's `gem install` program.

Windows and MacOS don't generally allow users to install software via repository in the same way that Linux and BSD systems usually do. For Windows and Mac, you can add these gems with `gem install nokogiri`, etc.

If you don't want to rely on Linux packages for your Ruby gems, you can use `gem install` for everything.

**Which version of Ruby?** As of March 1, 2020, blogPoster — with the proper Ruby gems installed — runs on Ruby 2.5 and 2.6 in Linux and Windows. It does NOT run in Ruby 2.7 in Windows because all the gems aren't available.

I have tested the script *extensively* on Linux and Windows systems, and it works pretty much the same on both. I have done some tests in MacOS, but I need to revisit them.

### Cheat sheet for installing Ruby gems to run blogPoster

* Note: I could cram more packages on one `apt` line, but I'd rather not for the purposes of this how-to.

* In Debian and Ubuntu, you need some development tools before all the gems will build. Run these commands in your terminal. In Ubuntu, `sudo` is enabled by default. In Debian, it's a good idea to set it up. (If you'd rather not, you can always `su` to root and run the installs that way.)

Run these commands. Again, I could cram them all on one line, but I prefer to run them this way in case there is any trouble along the way:

	$ sudo apt install ruby-dev
	$ sudo apt install gcc
	$ sudo apt install make
	$ sudo apt install ruby-nokogiri
	$ sudo apt install net-sftp
	$ sudo gem install net-ping
	$ sudo gem install mastodon-api
	$ sudo gem install twitter -v 6.2.0


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
