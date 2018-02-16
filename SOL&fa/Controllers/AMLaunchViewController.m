//
//  AMLaunchViewController.m
//  SOL&fa
//
//  Created by Anna Miksiuk on 13.02.2018.
//  Copyright © 2018 Anna Miksiuk. All rights reserved.
//

#import "AMLaunchViewController.h"
#import "AMMainViewController.h"
#import "Global.h"

@interface AMLaunchViewController ()

@property (strong, nonatomic) AMMainViewController* mainController;
@property (strong, nonatomic) UIVisualEffectView* effectView;

@end

@implementation AMLaunchViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIView* statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        
        statusBar.backgroundColor = BASE_PALETTE_COLOR5;
        statusBar.alpha = 0.f;

    }
    
    AMMainViewController* mainController = [[AMMainViewController alloc] init];
    self.mainController = mainController;
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView setFrame:self.view.frame];
    imageView.autoresizingMask =    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |
                                    UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
                                    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:imageView];
    
    CGFloat side = MAX(CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    CGRect frameEffect = self.view.bounds;
    frameEffect.size.width = side;
    frameEffect.size.height = side;
    UIBlurEffect* blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView* visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = frameEffect;
    visualEffectView.alpha = 0.1f;
    [self.view addSubview:visualEffectView];
    
    self.effectView = visualEffectView;
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(statusBar) weakStatusBar = statusBar;
    
    [UIView animateWithDuration:0.7f
                     animations:^{
                         
                         weakStatusBar.alpha = 1.f;
                         weakSelf.effectView.alpha = 1.f;
                         
                     } completion:^(BOOL finished) {
                         
                         [weakSelf presentViewController:weakSelf.mainController animated:NO completion:nil];
                         
                     }];
    
}


@end
