//
//  TwitterClient.m
//  Twitter
//
//  Created by Sneha  Datla on 10/4/14.
//  Copyright (c) 2014 Sneha  Datla. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

NSString * const kTwitterConsumerKey = @"uvyRZdxT9Qyw9JsK61cTbs0Fn";
NSString * const kTwitterConsumerSecret = @"5wi9hrbU9wrULarZQi3VeJSySAmg556DOVLWCQlKebxpmKBmV7";
NSString * const kTwitterBaseUrl = @"https://api.twitter.com";

@interface TwitterClient()
@property (nonatomic, strong) void (^loginCompletion)(User *user, NSError *error);
@end
@implementation TwitterClient

+(TwitterClient *)sharedInstance
{
    static TwitterClient *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    if(instance == nil)
    {
        instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
    }
    });
    return instance;
}

-(void)loginWithCompletion:(void (^)(User *user, NSError *error))completion{
    
    self.loginCompletion = completion;
    
    
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"cptwitterdemo://oauth"] scope:nil success:^(BDBOAuthToken *requestToken) {
        NSLog(@"got the request token!");
        
        NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        [[UIApplication sharedApplication] openURL:authURL];
    } failure:^(NSError *error) {
        NSLog(@"failed to get the request token!");
        self.loginCompletion(nil, error);
    }];

    
}

-(void)openURL:(NSURL *)url{
    
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuthToken tokenWithQueryString:url.query] success:^(BDBOAuthToken *accessToken) {
        NSLog(@"got the access token");
        [self.requestSerializer saveAccessToken:accessToken];
        
        [self GET:@"1.1/account/verify_credentials.json"parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //NSLog(@"Current user: %@", responseObject);
            User *user = [[User alloc] initWithDictionary:responseObject];
            [User setCurrentUser:user];
            NSLog(@"Current user: %@", user.name);
            self.loginCompletion(user, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            // NSLog(@"failed to get current user");
            self.loginCompletion(nil, error);
        }];
        

    } failure:^(NSError *error) {
        NSLog(@"failed to get the access token");
        self.loginCompletion(nil, error);
    }];

}
- (void)userTimelineWithParams:(NSDictionary *)params user:(User *)user completion:(void (^)(NSArray *tweets, NSError *error))completion {
    User *mainUser = [User currentUser];
    NSString *getUrl = [NSString stringWithFormat:@"1.1/statuses/user_timeline.json?screen_name=%@", mainUser.screenname];
   
    [self GET:getUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        NSLog(@"%@", [responseObject objectAtIndex:0]);
        completion(tweets, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

-(void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion{
    [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        NSLog(@"Got the tweets");
        completion(tweets, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error getting the tweets");
        NSLog(@"error: %@",  operation.responseString);
        completion(nil, error);
    }];
}


-(void)mentionsTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion{
    [self GET:@"1.1/statuses/mentions_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        NSLog(@"Got the tweets");
        completion(tweets, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error getting the tweets");
        NSLog(@"error: %@",  operation.responseString);
        completion(nil, error);
    }];
}





-(void)doFavorite:(Tweet *)updateTweet{
    
   // updateTweet.numFavorites++;
    [self POST:@"1.1/favorites/create.json" parameters:@{@"id":updateTweet.tweetid} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Favorited");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error favoriting %@", operation.error);
        
    }];
}


-(void)doRetweet:(NSString *)tweetId{
    NSString *postData = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweetId];
    [self POST:postData parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"retweeted");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error retweeting");
        
    }];
}

-(void)addReplyToTweet:(Tweet *)updateTweet text:(NSString *)text{
    
    NSString *str = [NSString stringWithFormat:@"@%@ %@", updateTweet.author.screenname, text];
    
    [self POST:@"1.1/statuses/update.json" parameters:@{@"status":str, @"in_reply_to_status_id": updateTweet.tweetid} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Replied to tweet");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error replying to tweet %@", operation.error);
        
    }];
}

-(void)addTweetToTimeline:(NSString *)updateTweet{
    [self POST:@"1.1/statuses/update.json" parameters:@{@"status" : updateTweet} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Added tweet");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error adding tweet");
        
    }];
}




@end











