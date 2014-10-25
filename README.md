community-chatter-privacy
=========================

Keep users posts in a partner community from being a conduit where partners can see each other and have discussions.

##Scenario

1. You have a community for partners
2. You don't want partners to talk to each other in the community.
3. So you've enabled private sharing model on records and on users (they can't see each other)
4. Partners do have visibility to the internal users they interact with.
5. Internal user posts something in his/her own feed.
6. All partners can see it, comment on it, and then see each other's discussions
7. You could train internal users not to do this, but you're worried that there'll still be mistakes made.

##Solution
Trigger that intercepts a chatter post, checks the user, context, and network scope, and if necessary, blocks the post.

