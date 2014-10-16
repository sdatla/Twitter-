//
//  LoginViewController.h
//  Twitter
//
//  Created by Sneha  Datla on 10/4/14.
//  Copyright (c) 2014 Sneha  Datla. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginViewControllerDelegate <NSObject>


@end

@interface LoginViewController : UIViewController
@property (nonatomic, weak) id <LoginViewControllerDelegate> delegate;
@end
