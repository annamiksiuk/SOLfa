//
//  AMStaff.m
//  SOL&fa
//
//  Created by Admin on 20.01.18.
//  Copyright © 2018 Anna Miksiuk. All rights reserved.
//

#import "AMStaffView.h"
#import "AMNote.h"

typedef NS_ENUM(NSInteger, AMStaffExtension) {
    AMStaffExtensionNone,
    AMStaffExtensionUp,
    AMStaffExtensionDown
};

@interface AMStaffView ()

@property (assign, nonatomic) AMStaffExtension extension;

@property (strong, nonatomic) NSMutableArray* rows;

@end

@implementation AMStaffView

#pragma mark - View Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.rowColor = [UIColor blackColor];
        self.rows = [NSMutableArray array];
        self.extension = AMStaffExtensionNone;
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    [self.rows removeAllObjects];
    
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    
    CGFloat heightRow = height / 9;
    CGFloat offsetY = heightRow / 2;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, self.rowColor.CGColor);
    CGContextSetLineWidth(context, 2);
    
    offsetY += 1.5f * heightRow;
    [self.rows addObject:@(offsetY - 0.5f * heightRow)];
    [self.rows addObject:@(offsetY)];
    
    if (self.extension == AMStaffExtensionUp) {
        
        CGContextMoveToPoint(context, width / 2 - width * 0.1f, offsetY);
        CGContextAddLineToPoint(context, width / 2 + width * 0.15f, offsetY);
    }
    
    offsetY += heightRow;
    [self.rows addObject:@(offsetY - 0.5f * heightRow)];
    [self.rows addObject:@(offsetY)];
    
    
    for (NSInteger indexRow = 0; indexRow < 5; indexRow++) {
        
        CGContextMoveToPoint(context, 0, offsetY);
        CGContextAddLineToPoint(context, width, offsetY);
        
        offsetY += heightRow;
        [self.rows addObject:@(offsetY - 0.5f * heightRow)];
        [self.rows addObject:@(offsetY)];
    }
    
    if (self.extension == AMStaffExtensionDown) {
        
        CGContextMoveToPoint(context, width / 2 - width * 0.1f, offsetY);
        CGContextAddLineToPoint(context, width / 2 + width * 0.15f, offsetY);
    }
    
    CGContextStrokePath(context);
    
}

#pragma mark - Own methods

- (CGFloat) offsetYForPoint:(CGPoint)point {
    
    CGFloat minOffset = CGFLOAT_MAX;
    
    CGFloat y = 0;
    
    for (NSNumber* number in self.rows) {
        
        CGFloat offset = abs((int)(point.y - [number floatValue]));
        
        if (offset < minOffset) {
            
            minOffset = offset;
            y = [number floatValue];
            
        }
        
    }
    
    return y;
    
}


- (CGPoint) anchorForPoint:(CGPoint)point {
    
    CGFloat y = [self offsetYForPoint:point];
    
    if (y < [self.rows[2] floatValue]) {
        
        self.extension = AMStaffExtensionUp;
        
    } else if (y > [self.rows[11] floatValue]) {
        
        self.extension = AMStaffExtensionDown;
    } else {
        
        self.extension = AMStaffExtensionNone;
    }
    
    [self setNeedsDisplay];
    
    return CGPointMake(CGRectGetWidth(self.frame) / 2, y);
    
}

- (AMNote*) noteForPoint:(CGPoint)point {
    
    AMNote* note = [[AMNote alloc] init];
    AMNoteOctave octave = AMNoteOctaveFirst;
    NSInteger codeNote = 0;
    
    CGFloat y = [self offsetYForPoint:point];
    
    for (NSInteger index = [self.rows count] - 1; index >= 0; index--) {
        
        if (index == 6) {
            
            octave++;
        }
        
        if (y == [[self.rows objectAtIndex:index] floatValue]) {
            break;
        }
        codeNote++;
        
    }
    
    note.note = codeNote % 7;
    note.octave = octave;
    
    return note;
    
}

@end
