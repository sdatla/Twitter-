//
//  MainViewController.m
//  Twitter
//
//  Created by Sneha  Datla on 10/14/14.
//  Copyright (c) 2014 Sneha  Datla. All rights reserved.
//


#import "UIImageView+AFNetworking.h"
#import "MainViewController.h"
#import "SideTableViewCell.h"
#import "User.h"

@interface MainViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *sidebarProfileImage;
@property (strong, nonatomic) IBOutlet UILabel *sideBarProfileName;
@property (strong, nonatomic) IBOutlet UILabel *sideBarProfileHandle;
@property (strong, nonatomic) IBOutlet UITableView *sideTableView;
@property (strong, nonatomic) NSArray *sideLinks;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *centerXConstraint;
- (IBAction)didSwipeRight:(UISwipeGestureRecognizer *)sender;
- (IBAction)didSwipeLeft:(UISwipeGestureRecognizer *)sender;
@property (strong, nonatomic) IBOutlet UIView *containerView;


@property (strong, nonatomic) UIViewController *homeTimelineViewController;
@property (strong, nonatomic) UIViewController *profileViewController;
@property (strong, nonatomic) UIViewController *mentionsViewController;

@property (strong, nonatomic) UIViewController *topVC;


@end

@implementation MainViewController

-(id)init{
    self = [super init];
    if(self){
        
        TweetsViewController *tvc = [[TweetsViewController alloc] init];
        UINavigationController *tnvc = [[UINavigationController alloc] initWithRootViewController:tvc];
        tvc.delegate = self;
        
        ProfileViewController *pvc = [[ProfileViewController alloc] init];
        UINavigationController *pnvc = [[UINavigationController alloc] initWithRootViewController:pvc];
        pvc.delegate = self;
        
        MentionsViewController *mvc = [[MentionsViewController alloc] init];
        UINavigationController *mnvc = [[UINavigationController alloc] initWithRootViewController:mvc];
        mvc.delegate = self;
        
        self.homeTimelineViewController = tnvc;
        self.profileViewController = pnvc;
        self.mentionsViewController = mnvc;
        
        
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    self.topVC = self.profileViewController;
    self.topVC.view.frame = self.containerView.bounds;
    [self.containerView addSubview:self.topVC.view];
    
    self.centerXConstraint.constant = 0;
    self.sideLinks = @[ @"Profile", @"Timeline", @"Mentions", @"Sign Out"];
    self.sideTableView.rowHeight = 40;
    
    self.sideTableView.delegate = self;
    self.sideTableView.dataSource = self;
    
    UINib *sideTableNib = [UINib nibWithNibName:@"SideTableViewCell" bundle:nil];
    [self.sideTableView registerNib:sideTableNib forCellReuseIdentifier:@"SideTableViewCell"];
    
    self.sideTableView.backgroundColor = [UIColor grayColor];
    
    User *user = [User currentUser];
    
    NSString *ImageURL = user.profileImageURL;
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
    
    self.sidebarProfileImage.layer.cornerRadius = 5.0;
    [self.sidebarProfileImage setClipsToBounds:YES];
    self.sidebarProfileImage.image = [UIImage imageWithData:imageData];
    
    
    self.sideBarProfileName.text = user.name;

    NSString *handle = [NSString stringWithFormat:@"@%@", user.screenname];
    
    self.sideBarProfileHandle.text = handle;

    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sideLinks.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"Selected row %ld", (long)indexPath.row);
    
    if(indexPath.row == 0){
        self.topVC = self.profileViewController;

        
        [UIView animateWithDuration:0.5 animations:^{
            self.containerView.frame = CGRectOffset(self.containerView.frame, -220.0, 0.0);
        }];
        [self addChildViewController:self.topVC];
        self.topVC.view.frame = self.containerView.bounds;
        [self.containerView addSubview:self.topVC.view];

    }
    if(indexPath.row == 1){
        self.topVC = self.homeTimelineViewController;

        
        [UIView animateWithDuration:0.5 animations:^{
            self.containerView.frame = CGRectOffset(self.containerView.frame, -220.0, 0.0);
        }];

        [self addChildViewController:self.topVC];
        self.topVC.view.frame = self.containerView.bounds;
        [self.containerView addSubview:self.topVC.view];

    }
    if(indexPath.row == 2){
        
        self.topVC = self.mentionsViewController;
        
        [UIView animateWithDuration:0.5 animations:^{
            self.containerView.frame = CGRectOffset(self.containerView.frame, -220.0, 0.0);
        }];
        [self addChildViewController:self.topVC];
        self.topVC.view.frame = self.containerView.bounds;
        [self.containerView addSubview:self.topVC.view];

    }
    if(indexPath.row == 3)
    {
        NSLog(@"Logging out");
        [User logout];
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"SideTableViewCell";
    SideTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.linkName.text = self.sideLinks[indexPath.row];
    
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)didSwipeRight:(UISwipeGestureRecognizer *)sender {
    if(sender.state == UIGestureRecognizerStateEnded){

    [UIView animateWithDuration:0.5 animations:^{
        self.containerView.frame = CGRectOffset(self.containerView.frame, 220.0, 0.0);
    }];
    }
    
}

- (IBAction)didSwipeLeft:(UISwipeGestureRecognizer *)sender {
    if(sender.state == UIGestureRecognizerStateEnded){
        [UIView animateWithDuration:0.5 animations:^{
            self.containerView.frame = CGRectOffset(self.containerView.frame, -220.0, 0.0);
        }];
    }
}
@end
