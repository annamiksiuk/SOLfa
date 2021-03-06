//
//  AMSheetButton.m
//  Testing
//
//  Created by Admin on 15.01.18.
//  Copyright © 2018 Anna Miksiuk. All rights reserved.
//

#import "AMSheetButton.h"
#import "Global.h"

@implementation AMSheetButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.cornerRadius = 20;
        self.clipsToBounds = YES;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 5.5;
        self.layer.shadowRadius = 5;
        self.layer.shadowOffset = CGSizeMake(0, 2.0f);
        self.layer.masksToBounds = NO;
        [self setTitleColor:BASE_PALETTE_COLOR5 forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont fontWithName:BASE_FONT_NAME size:BASE_FONT_SIZE];
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
    }
    return self;
}

@end
