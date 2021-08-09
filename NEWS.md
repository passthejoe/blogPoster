# blogPoster News

#### Aug. 9, 2021

* There is now an [official release](https://github.com/passthejoe/blogPoster/releases) of blogPoster. [Version 1](https://github.com/passthejoe/blogPoster/releases/tag/v1.0) is available for download.

#### Aug. 8, 2021

* Mastodon posting no longer uses the mastodon-api gem. Instead, since it's so relatively easy to post to Mastodon, I'm using the http gem.

* Inspiration/code for the new Mastodon posting method comes from this dev.to article that uses Python: <https://dev.to/bitsrfr/getting-started-with-the-mastodon-api-41jj>. I converted the code to Ruby.

* This change resolves the issues with the mastodon-api gem and a) Ruby versions 2.7 or newer and b) the twitter gem, which has a conflict due to different http versions. All the app needs to do is post, so it's relatively easy to do it without the special gem.

* I am *trying* to figure out how to post to Twitter without the twitter gem, but I haven't been able to figure that one out.

#### July 19, 2020

* I rewrote the method that checks whether a live internet connection is present and added it to the menu. It uses a case (aka switch) statement just because I wanted to try one.

* I updated a laptop from Fedora 30 to 32, and it runs Ruby 2.7. It had a new version of the Twitter gem but still had an older version of the HTTP gem, so it SHOULD be compatible with the mastodon-api gem. I haven't done a Git pull with the latest code, so I haven't tested this yet.

* In Fedora's Ruby 2.7, I am getting a few Ruby warnings about using methods in ways that are deprecated. I'll have to look into this and see what changes I can make.

* The last I looked, it's not possible to run blogPoster on Ruby 2.7 in Windows due to missing gems. It's interesting that it will run in Fedora. I tend to get as many gems from Fedora packages as possible. It sure makes upgrades easier. Already in Fedora I needed to get rid of my local .gems directory to resolve some issues. The Fedora-packaged gems all upgraded with no issues. 

* I added a method that checks the system's version of Ruby and outputs it as part of the welcome messages.

* All welcome messages are now methods.

#### July 8, 2020

I just landed a few new features and bug fixes:

* While there was a file-length limit variable in the configuration file, the code to limit file length was never written. Now it is.

* In order to implement file length, regex to eliminate leading and trailing underscores was broken up and re-implemented.

* Date stamps in file names now include a number representing hours, minutes and seconds of the day. Aside from a visible time stamp, this allows you to create posts based on the same URL without the script generating the same file name and then overwriting the previous post file on the server. Theoretically the same URL can now be posted every second without file names clashing.

All of this code is still in the realm of "testing," and remains in the Development branch in Git. When it appears to be working well, I will move it to Main.

**Still to do on this feature:** A LOT of code is doubled for URL-based and "raw" (not URL-based) posts. Creating methods or classes to modularize and DRY the code.

#### June 24, 2020

I figured out the conflict between two Ruby gems, `mastodon-api` and `twitter` that made the script crash in some instances. Both gems have the `http` gem as a dependency, but the newer version that `twitter 7.0.0` requires is too "new" for `mastodon-api`. Until `mastodon-api` requires the same version of `http`, when installing the `twitter` gem, please specify `twitter 6.2.0`.

That is generally done like this (add `sudo` where appropriate):

	$ gem install twitter -v 6.2.0
	
More instructions on gem installation have been added to the README.

#### June 21, 2020

The move from `master` to `main` didn't go as smoothly as I would have liked. The problems grew from my git setup that pushed to two separate remote repositories. I am re-configuring to push to a single repo. This project is staying on GitHub. My [Zen of Debian](https://codeberg.org/passthejoe/zen-of-debian) project is still on both sites but will probably land on Codeberg.

I made the mistake of using Stack Overflow posts and random blog entries that had me changing my `.git/config` file in order to push to two remote repositories with a single `git push origin master`. I seemed to have it working OK for awhile, but the `master-to-main` switch wasn't kind to that jury-rigged setup.

My biggest error is getting my `.git/config` commands mixed up between this repo and Zen of Debian. Hilarity (and the completely wrong files) ensued. I killed the Codeberg repo for blogPoster as a result.

I think (or _hope_ at any rate) there is a better way to maintain two separate remotes with one mirroring the other that doesn't involve pushing to two at once.

#### June 15, 2020

I agree with [the movement that says](https://www.zdnet.com/article/github-to-replace-master-with-alternative-term-to-avoid-slavery-references/) the technology terms "master/slave" should go away, and the primary Git repository in this project is now called `main` instead of `master`.

#### June 10, 2020

The `network_ping` feature has landed. Now the script will check for a live internet connection before attempting to upload a file to the blog.

**Mastodon posting** is now working. Documentation is inline in the script, but it should move to this README soon. I haven't tested whether this works with [Pleroma](https://pleroma.social/), but I will.

Next on the roadmap: Posting to a **Hugo** blog.
