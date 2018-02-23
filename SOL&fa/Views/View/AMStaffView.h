//
//  AMStaff.h
//  SOL&fa
//
//  Created by Admin on 20.01.18.
//  Copyright © 2018 Anna Miksiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AMNote;

@interface AMStaffView : UIView

@property (strong, nonatomic) UIColor* rowColor;

- (CGPoint) anchorForPoint:(CGPoint)point;

- (AMNote*) noteForPoint:(CGPoint)point;

@end
