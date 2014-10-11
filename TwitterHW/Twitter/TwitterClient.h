//
//  TwitterClient.h
//  Twitter
//
//  Created by Sneha  Datla on 10/4/14.
//  Copyright (c) 2014 Sneha  Datla. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"
#import "Tweet.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+(TwitterClient *)sharedInstance;

-(void)loginWithCompletion:(void (^)(User *user, NSError *error))completion;
-(void)openURL:(NSURL *)url;

-(void)addTweetToTimeline:(NSString *)updateTweet;
-(void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;
-(void)doRetweet:(NSString *)tweetId;
-(void)addReplyToTweet:(Tweet *)updateTweet text:(NSString *)text;
-(void)doFavorite:(Tweet *)updateTweet;
@end
