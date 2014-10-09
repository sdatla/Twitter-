//
//  NewTweetViewController.h
//  Twitter
//
//  Created by Sneha  Datla on 10/7/14.
//  Copyright (c) 2014 Sneha  Datla. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewTweetViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *userhandle;
@property (weak, nonatomic) IBOutlet UITextField *tweetInputText;
@property (weak, nonatomic) IBOutlet UITextView *tweet;
@property (strong, nonatomic) UIViewController *callbackVC;
@property (assign, nonatomic) SEL *callbackMethodForAddTweet;
-(void)setCallback:(UIViewController *)vc selector:(SEL)selector;
@end
