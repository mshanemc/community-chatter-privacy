/*
Copyright (c) 2014, Salesforce.com, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
Neither the name of Salesforce.com nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

trigger CommunityChatterPrivacy on FeedItem (before insert) {
	
	user u = new user();

	//loop through all the posts, just in case we're bulkifying
	for (feeditem f: trigger.new){ 

		//some debugging, just in case you need to check things.
		//system.debug('InsertedById: ' + f.InsertedById );
		//system.debug('ParentId: ' + f.ParentId );
		//system.debug('visibility: ' + f.Visibility );
		//system.debug('network scope ' + f.NetworkScope );
		//system.debug('object type: ' + f.ParentId.getSObjectType().getDescribe().getName());

		//first, if we're not in a community, then move on quickly.
		if (f.NetworkScope == null) {
			continue;
		}

		//what type of parent does the post have?
		if ( f.ParentId.getSObjectType().getDescribe().getName() == 'User'){
			//if it's a user, then this is a wall post.  We need to get that user
			u = [select id, usertype from user where id =: f.ParentId];
			//if it's not an internal user, move on
			if ( u.usertype != 'Standard'){  
				continue;
			} else {
				//looks we have an interal user, posting to a community, in the feed.  Disallow!
				system.debug('change required');
				//for internationalization reasons, this message could be a Custom Label.
				f.addError('You can chatter in a group or on a record for this community, but chatter on the feed is not allowed.  To post to your Chatter feed, please post outside this community');
			}
		} else {
			//Otherwise, it's not a user and we just exit.
			continue;
		}

	
	}

}