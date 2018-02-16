//
//  AMEmmiterLayer.m
//  Testing
//
//  Created by Admin on 05.01.18.
//  Copyright © 2018 Anna Miksiuk. All rights reserved.
//

#import "AMEmmiterLayer.h"
#import "Global.h"
#import <UIKit/UIKit.h>

@implementation AMEmitterLayer

- (instancetype)initWithCellsImages:(NSArray*)images {
    
    self = [super init];
    if (self) {
        
        self.emitterShape = kCAEmitterLayerLine;
        self.emitterCells = [self generateEmitterCellsWithImages:images];
        
    }
    return self;
    
}

- (NSArray<CAEmitterCell*>*) generateEmitterCellsWithImages:(NSArray*)images {
    
    NSMutableArray* cells = [NSMutableArray array];
    
    NSInteger countImages = [images count];
    
    for (NSInteger index = 0; index < countImages; index++) {
        
        UIImage* image = [images objectAtIndex:index];
        CAEmitterCell* cell = [self generateEmitterCellWithImage:image];
        
        [cells addObject:cell];
    }

    return cells;
    
}

- (CAEmitterCell*) generateEmitterCellWithImage:(UIImage*)image {
    
    CAEmitterCell* cell = [CAEmitterCell emitterCell];
    cell.contents = (id)image.CGImage;
    cell.birthRate = 1;
    cell.lifetime = 50;
    cell.velocity = 40;
    cell.emissionLongitude = M_PI;
    cell.emissionRange = M_PI_4;
    cell.scale = iPad ? 0.6f : 0.4f;
    cell.scaleRange = 0.2f;
    
    return cell;
}

@end
