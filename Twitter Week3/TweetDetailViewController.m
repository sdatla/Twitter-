//
//  TweetDetailViewController.m
//  Twitter
//
//  Created by Sneha  Datla on 10/7/14.
//  Copyright (c) 2014 Sneha  Datla. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "Tweet.h"
#import  "NewTweetViewController.h"

@interface TweetDetailViewController ()

@end

@implementation TweetDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil tweet:(Tweet *)tweetObj
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tweetObj = tweetObj;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor *blue = [UIColor colorWithRed:102.0/255 green:178.0/255 blue:255.0/255 alpha:1.00];
    self.navigationController.navigationBar.barTintColor = blue;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"Tweet";

    // Do any additional setup after loading the view from its nib.
    NSLog(@"this is the author name %@",self.tweetObj.author.name);
    self.userName.text = self.tweetObj.author.name;
    self.tweettext.text = self.tweetObj.text;
    self.timeLabel.text = [Tweet retrivePostTime:self.tweetObj.createdAt];
    NSString *handle = [NSString stringWithFormat:@"@%@", self.tweetObj.author.screenname];
    self.handleLabel.text = handle;
    
    
    NSString *ImageURL = self.tweetObj.author.profileImageURL;
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
    self.profileImage.image = [UIImage imageWithData:imageData];
    
    UIImage *retweetImage = [UIImage imageNamed: @"retweet.png"];
    [self.retweetTop setImage:retweetImage];
    
    UIImage *replyBtnImage = [UIImage imageNamed:@"reply.png"];
    [self.replyButton setImage:replyBtnImage forState:UIControlStateNormal];
    
    UIImage *retweetBtnImage = [UIImage imageNamed:@"retweet.png"];
    [self.retweetButton setImage:retweetBtnImage forState:UIControlStateNormal];
    
    UIImage *favBtnImage = [UIImage imageNamed:@"star.png"];
    [self.favoriteButton setImage:favBtnImage forState:UIControlStateNormal];

    
    UIBarButtonItem *replyButton = [[UIBarButtonItem alloc]
                                  initWithTitle:@"Reply"
                                  style:UIBarButtonItemStyleBordered
                                  target:self
                                  action:@selector(onReply)];
    self.navigationItem.rightBarButtonItem = replyButton;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    
}


-(IBAction)onReply{
    NSLog(@"Replying to tweet");
    [self.navigationController pushViewController:[[NewTweetViewController alloc] init] animated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
