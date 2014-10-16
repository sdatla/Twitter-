//
//  TweetCell.m
//  Twitter
//
//  Created by Sneha  Datla on 10/7/14.
//  Copyright (c) 2014 Sneha  Datla. All rights reserved.
//

#import "TweetCell.h"
#import "ProfileViewController.h"
#import "TweetsViewController.h"
#import "TwitterClient.h"

@implementation TweetCell

- (void)awakeFromNib
{
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onProfileTapped:(id)sender {
   // NSLog(@"Profile of %@ tapped", self.user.name);
    [self.delegate onProfileTapped:self.user];
    
}


@end
