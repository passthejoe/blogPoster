## blogPoster

blogPoster aims to make it easy to create social-media-style posts and send those posts to both a social-media service and a personal blog.

This is a *very* personal project that I use just about every day. Right now it's a terminal program that uses Ruby and a few Gems to take URLs and make it quick and easy to create and post a social-media entries based on those URLs.

blogPoster can also create posts "from scratch," meaning you can begin with a title and alert text without a URL. And now you can add any URL you want to any post and even change the URL on a post you're already working on.

The way the app is structured right now, it creates and formats posts for an [Ode](http://ode.io) blog and the [Twitter](http://twitter.com) social-media service.

You've probably heard of Twitter, and you might already use it. That's a good reason to be interested in this project. But I could code this app to post to any other service that has an API I can figure out. Right now I use Twitter and don't envision adding any other services, but I *could*.

I'm pretty sure you haven't heard of Ode, the Rob Reed-coded, Perl-based blogging software that is inspired by [Bloxsom](http://blosxom.sourceforge.net/) ([see a little more on Wikipedia](https://en.wikipedia.org/wiki/Blosxom)).

I have been using Ode as my personal blogging system for many years now, and I'm hopeful that Rob will release a new version soon. He says he wants [to change the name of the project to Ebeling](https://ode.io/news/about_ode/ode-is-becoming-ebeling.html).

Ode is well-suited to a project like a personal microblog because its easy to modify the *themes* to show just the post body, though I don't think that's strictly necessary for a microblog site using a traditional blog CMS like WordPress.

Future development plans include adding the option to post to static sites generated by programs like [Hugo](https://gohugo.io/) and [Jekyll](https://jekyllrb.com/).

But right now I use Ode, and that's what the script works with.

In case you're wondering where the idea of a *microblog* comes from, aside from the fact that your Twitter feed is sort of, kind of, already a microblog, I found inspiration for this project in two microblogging pioneers:

* **Dave Winer**, whose [Scripting News](http://scripting.com) is one of the best personal microblogs out there: [Dave](https://en.wikipedia.org/wiki/Dave_Winer) is an inspiration to me both as a writer and a programmer.

* **Manton Reece**, the creator of [Micro.blog](https://micro.blog): I really like [his writing](https://micro.blog/manton), and even though I had a hard time wrapping my head around what Micro.blog was actually going to become while Manton was planning it, the idea was intriguing. When it turned out that Micro.blog was a hosted and subscriber-based service and that apps for it would only be created for Apple devices, what Manton created gave me the push I needed to figure out how to do this on my own.

### What do you need to have in place to run blogPoster?

At this point, blogPoster isn't a complete, stand-alone system. It's a Ruby script and a few extra files.

To run the script, you need the Ruby programming language, a compatible text editor and a few Gems.

Aside from a text editor, you need to have the following Ruby Gems installed:

* `Nokogiri`
* `Twitter`
* `net-sftp`

The `Nokogiri` and `net-sftp` gems are available as a package in most Linux distributions, which works great if you are using your distribution's Ruby implementation.

Some Linux distributions have packaged a Twitter gem, but not Fedora, where Ruby's `gem` command can be used to add it.

**Note on Ruby Gems:** In response to a tweet about using Linux distribution packages to install Ruby Gems, a couple of developers replied to say that they don't recommend using distribution-packaged Gems, or even distribution-packaged Ruby. But they definitely urged use of Gems via Ruby's `gem install` program. I don't know where I come down on this, though Windows and MacOS don't generally allow users to install software via repository in the same way that Linux and BSD systems usually do. For Windows and Mac, you can add these gems with `gem install nokogiri`, etc. If you don't want to rely on Linux packages for your Ruby gems, you can use `gem install` for everything.

**Which version of Ruby?** As of March 1, 2020, blogPoster — with the proper Ruby Gems installed — runs on Ruby 2.5 and 2.6 in Linux and Windows.

I have tested the script *extensively* on Linux and Windows systems, and it works pretty much the same on both. I imagine the results would be the same on macOS, but it wouldn't hurt me to do some tests (and I will).

The biggest variable is your choice of text editor, which the script uses to edit posts. I used the coding and testing of this script as an "excuse" to learn [Vim](https://www.vim.org), and I am glad I did. But the script works very well with other editors. It is *very* compatible with `Notepad` in Windows, though not as compatible with `Notepad++` as I'd like it to be. I haven't tried a lot of other editors with Linux, but that is something I will do in the future, and I will report the results in this file. I use `vim` in both Windows and Linux, which makes things simple for me. But I understand if you want to use something else.

BlogPoster works with [JRuby](https://www.jruby.org). I tried version 9.2.7.0 in Windows, using `jruby -S gem install` to bring in the `nokogiri` and `Twitter` gems, and the script worked as expected. However, the Ruby `system` command that I use to bring in a text editor doesn't work with as many editors in JRuby as it does in MRuby (aka "normal" Ruby). With JRuby in Windows, console Vim did not work, but I did have success with `GVim` (aka GUI Vim) and `Notepad` (Windows Notepad, not Notepad++). While one of my goals in writing this script and using it was to learn Vim by editing dozens of short text files per day as I edited tweets/posts, you might not have that same goal. And in Windows, as I say above, Notepad (using `notepad` in the configuration) seems to be a VERY reliable editor to use with this script.

**You really don't have to use a text editor with the script if you don't want to.** You can do everything in the console (i.e. at the command line), though bringing in a text editor makes it much easier to craft your posts.


### Do you need a stand-alone blogging system to use blogPoster?

**No.** You can use blogPoster just for posting to Twitter, or just for posting to your blog/microblog. It's flexible that way.

While the blog-posting portion of blogPoster in its default configuration is so [Ode](http://ode.io)-specific, you can and should modify it for your file-based blogging system.


### Uploading to a blog or site via FTP

What you need:

* A blog/website that uses "flat" text files
* Acccess to that blog/website via SFTP (usually with a login and password, though I'm pretty sure a public/private key login will also work; I definitely need to test that and add a key option to the SFTP credentials)

As of March 1, 2020, the script uses SFTP — via the `net-sftp` Ruby gem — to transfer files to static sites. I formerly used FTP, and aside from being more secure, the SFTP gem requires about one-third the code of the `net-ftp` library.

To use this app for posting to your blog, you'll need to enter your FTP login and password in the configuration file `blogPoster_configuration.rb`, which is created when you run the `blogPoster.rb` script for the first time.

The `blogPoster_configuration.rb` file also requires you to enter the path to at least one directory on your server where you want your static text files to go.

That same configuration file also lets you select your file suffix. I use `.txt`, but you can set this to whatever your blog or site requires.

### Posting to Twitter

Before you use the app to post to Twitter, you need to get access to the Twitter API via a [a Twitter Development Account](https://developer.twitter.com/en/docs/basics/developer-portal/overview), which is harder to get than it used to be.

When you fill out Twitter's online form to "register" your instance of blogPoster, you basically need to tell them you are using a Ruby script to post tweets from your desktop, and then they should say "OK," and give you the keys/tokens you need to enter in `blogPoster_configuration.rb` to make the app work with Twitter.

The first time I requested access to the Twitter API, it all went smoothly. All I had to do was tell them what my app was going to do. I had to do this a second time due to changes Twitter made in their API agreement. This time they came back with further questions, and I just restated what I said before. That worked.

**Aside:** I would like to turn this into a graphical app that allows users to log in using their Twitter credentials and not require them to get API access, but that's a project for the future.

### Note to developers

If you are running blogPoster and also trying to hack on it using `git`, you might need to make one change in your `.gitignore` file: My blog files end with the suffix `.txt`, and if yours end with another suffix, say `.md` or `.html`, you will need to replace `*.txt` with an appropriate entry so `git` won't commit your entries.
