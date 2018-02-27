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
@property (strong, nonatomic) UIView* statusBar;

@property (strong, nonatomic) NSMutableArray<UIImageView*>* logoParts;


@end

@implementation AMLaunchViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([self.statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        
        self.statusBar.backgroundColor = BASE_PALETTE_COLOR5;
        self.statusBar.alpha = 0.f;

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
    
    NSInteger countPartForWidth = 10;
    NSInteger countPartForHeight = 10;
    
    UIImage* logo = [UIImage imageNamed:@"Logo"];
    
    NSArray* array = [self cutImage:logo
              countPartHorizontally:countPartForWidth
                countPartVertically:countPartForHeight];
    
    CGRect frameLogo = CGRectMake(CGRectGetWidth(self.view.frame) / 2 - 160, CGRectGetHeight(self.view.frame) / 2 - 160, 320, 320);
    
    CGFloat stepHor = frameLogo.size.width / countPartForWidth;
    CGFloat stepVert = frameLogo.size.height / countPartForHeight;
    
    CGFloat startX = frameLogo.origin.x;
    CGFloat startY = frameLogo.origin.y;
    
    NSInteger count = 0;
    
    NSMutableArray* logoParts = [NSMutableArray array];
    
    for (NSInteger x = startX + stepHor / 2; x < startX + frameLogo.size.width; x += stepHor) {
        
        for (NSInteger y = startY + stepVert / 2; y < startY + frameLogo.size.height; y += stepVert) {
            
            UIImageView* im = [[UIImageView alloc] initWithImage:[array objectAtIndex:count]];
            im.frame = CGRectMake(0, 0, stepHor, stepVert);
            im.center = CGPointMake(x, y);
            im.autoresizingMask =   UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |
                                    UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
                                    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [logoParts addObject:im];
            [self.view addSubview:im];
            count++;
            
        }
        
    }
    
    self.logoParts = logoParts;
    
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(self.statusBar) weakStatusBar = self.statusBar;
    
    [UIView animateWithDuration:3.f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         for (UIImageView* logoPart in weakSelf.logoParts) {
                             
                             NSInteger signX = arc4random_uniform(2);
                             NSInteger signY = arc4random_uniform(2);
                             CGFloat translX = arc4random_uniform(10) / 10.f;
                             CGFloat translY = arc4random_uniform(10) / 10.f;
                             
                             CGFloat width = CGRectGetWidth(weakSelf.view.frame);
                             CGFloat height = CGRectGetHeight(weakSelf.view.frame);
                             
                             translX *= width;
                             translX += width;
                             translX *= signX ? 1 : -1;
                             
                             translY *= height;
                             translY += height;
                             translY *= signY ? 1 : -1;
                             
                             CGAffineTransform rotateTransform = CGAffineTransformMakeRotation(arc4random_uniform(310) / 100.f);
                             CGAffineTransform translationTransform = CGAffineTransformMakeTranslation(translX, translY);
                             logoPart.transform = CGAffineTransformConcat(rotateTransform, translationTransform);
                             
                         }
                     }
                     completion:nil];
    
    [UIView animateWithDuration:1.7f
                     animations:^{
                         
                         weakStatusBar.alpha = 1.f;
                         weakSelf.effectView.alpha = 1.f;
                         
                     } completion:^(BOOL finished) {
                         
                         [weakSelf presentViewController:weakSelf.mainController animated:NO completion:nil];
                         
                     }];
}

#pragma mark - Own methods

- (NSArray<UIImage*>*) cutImage:(UIImage*)image countPartHorizontally:(NSInteger)countHor countPartVertically:(NSInteger)countVert {
    
    CGFloat scale = image.scale;
    CGSize sizeImage = image.size;
    CGFloat stepHor = sizeImage.width / countHor;
    CGFloat stepVert = sizeImage.height / countVert;
    NSMutableArray* images = [NSMutableArray array];
    
    for (NSInteger x = 0; x < countHor; x++) {
        
        for (NSInteger y = 0; y < countVert; y++) {
            
            CGRect cutRect = CGRectMake(x * stepHor * scale, y * stepVert * scale, stepHor * scale, stepVert * scale);
            CGImageRef part = CGImageCreateWithImageInRect([image CGImage], cutRect);
            UIImage* partImage = [UIImage imageWithCGImage:part];
            CGImageRelease(part);
            [images addObject:partImage];
        }
        
    }
    return images;
}

@end
