//
//  NewTweetViewController.m
//  Twitter
//
//  Created by Sneha  Datla on 10/7/14.
//  Copyright (c) 2014 Sneha  Datla. All rights reserved.
//

#import "NewTweetViewController.h"
#import "User.h"
#import "TwitterClient.h"
@interface NewTweetViewController ()

@end

@implementation NewTweetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];


    
    UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"Tweet"
                                    style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(onTweet)];
    self.navigationItem.rightBarButtonItem = tweetButton;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"Cancel"
                                    style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(onCancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    self.tweetInputText.delegate = self;
    
    User *user = [User currentUser];
    
    NSString *ImageURL = user.profileImageURL;
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
    self.userImage.image = [UIImage imageWithData:imageData];
    
    self.username.text = user.name;
    NSString *handle = [NSString stringWithFormat:@"@%@", user.screenname];
    
    self.userhandle.text = handle;
    // Do any additional setup after loading the view from its nib.
    
    
}

-(IBAction)onTweet{
    NSLog(@"Going to tweet");
    [[TwitterClient sharedInstance] addTweetToTimeline:self.tweet.text];
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
-(IBAction)onCancel{
    NSLog(@"Going to cancel tweet");
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setCallback:(UIViewController *)vc selector:(SEL)selector {
    self.callbackVC = vc;
   // self.callbackMethodForAddTweet = selector;
    
}


@end
