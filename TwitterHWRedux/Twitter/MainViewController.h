//
//  MainViewController.h
//  Twitter
//
//  Created by Sneha  Datla on 10/14/14.
//  Copyright (c) 2014 Sneha  Datla. All rights reserved.
//

#import "TweetsViewController.h"
#import "MentionsViewController.h"
#import "ProfileViewController.h"

#import <UIKit/UIKit.h>

@protocol MainViewControllerDelegate <NSObject>


@end

@interface MainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ProfileViewControllerDelegate,  MentionsViewControllerDelegate, TweetsViewControllerDelegate>

@property (nonatomic, weak) id <MainViewControllerDelegate> delegate;
@end
