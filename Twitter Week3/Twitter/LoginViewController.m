//
//  LoginViewController.m
//  Twitter
//
//  Created by Sneha  Datla on 10/4/14.
//  Copyright (c) 2014 Sneha  Datla. All rights reserved.
//

#import "TwitterClient.h"
#import "LoginViewController.h"
#import "TweetsViewController.h"
#import "TweetsTableView.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
- (IBAction)onLogin:(id)sender {
    [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error){
        if(user != nil){
            //MOdally present tweets view
            NSLog(@"Welcome to %@", user.name);
            [self.navigationController pushViewController:[[TweetsViewController alloc] init] animated:YES];
            
        }
        else{
            //Present error view
        }
    }];
}

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
    // Do any additional setup after loading the view from its nib.
    
    UIColor *blue = [UIColor colorWithRed:102.0/255 green:178.0/255 blue:255.0/255 alpha:1.00];
    self.navigationController.navigationBar.barTintColor = blue;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.title = @"Sign In";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
