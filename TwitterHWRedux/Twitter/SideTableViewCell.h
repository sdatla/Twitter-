//
//  SideTableViewCell.h
//  Twitter
//
//  Created by Sneha  Datla on 10/14/14.
//  Copyright (c) 2014 Sneha  Datla. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SideTableViewCellDelegate <NSObject>


@end

@interface SideTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *linkName;
@property (nonatomic, weak) id <SideTableViewCellDelegate> delegate;

@end
