# blogPoster News

#### News on June 24, 2020

I figured out the conflict between two Ruby gems, `mastodon-api` and `twitter` that made the script crash in some instances. Both gems have the `http` gem as a dependency, but the newer version that `twitter 7.0.0` requires is too "new" for `mastodon-api`. Until `mastodon-api` requires the same version of `http`, when installing the `twitter` gem, please specify `twitter 6.2.0`.

That is generally done like this (add `sudo` where appropriate):

	$ gem install twitter -v 6.2.0
	
More instructions on gem installation have been added to the README.

#### News on June 21, 2020

The move from `master` to `main` didn't go as smoothly as I would have liked. The problems grew from my git setup that pushed to two separate remote repositories. I am re-configuring to push to a single repo. This project is staying on GitHub. My [Zen of Debian](https://codeberg.org/passthejoe/zen-of-debian) project is still on both sites but will probably land on Codeberg.

I made the mistake of using Stack Overflow posts and random blog entries that had me changing my `.git/config` file in order to push to two remote repositories with a single `git push origin master`. I seemed to have it working OK for awhile, but the `master-to-main` switch wasn't kind to that jury-rigged setup.

My biggest error is getting my `.git/config` commands mixed up between this repo and Zen of Debian. Hilarity (and the completely wrong files) ensued. I killed the Codeberg repo for blogPoster as a result.

I think (or _hope_ at any rate) there is a better way to maintain two separate remotes with one mirroring the other that doesn't involve pushing to two at once.

#### News on June 15, 2020

I agree with [the movement that says](https://www.zdnet.com/article/github-to-replace-master-with-alternative-term-to-avoid-slavery-references/) the technology terms "master/slave" should go away, and the primary Git repository in this project is now called `main` instead of `master`.

#### News on June 10, 2020

The `network_ping` feature has landed. Now the script will check for a live internet connection before attempting to upload a file to the blog.

**Mastodon posting** is now working. Documentation is inline in the script, but it should move to this README soon. I haven't tested whether this works with [Pleroma](https://pleroma.social/), but I will.

Next on the roadmap: Posting to a **Hugo** blog.
