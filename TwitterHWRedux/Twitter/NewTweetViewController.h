//
//  NewTweetViewController.h
//  Twitter
//
//  Created by Sneha  Datla on 10/7/14.
//  Copyright (c) 2014 Sneha  Datla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@protocol NewTweetViewControllerDelegate <NSObject>


@end

@interface NewTweetViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *userhandle;

@property (weak, nonatomic) IBOutlet UITextView *tweet;
@property (strong, nonatomic) UIViewController *callbackVC;
@property (strong, nonatomic) NSString *methodName;
@property (assign, nonatomic) SEL *callbackMethodForAddTweet;
-(void)setCallback:(UIViewController *)vc;
-(void)setCallback:(UIViewController *)vc tweet:(Tweet *)tweet;
@property (strong, nonatomic) Tweet *tweetObj;
@property (strong, nonatomic) UIViewController *popToThisController;

@property (nonatomic, weak) id <NewTweetViewControllerDelegate> delegate;
@end
