//
//  AMInfoManager.h
//  SOL&fa
//
//  Created by Anna Miksiuk on 15.02.2018.
//  Copyright © 2018 Anna Miksiuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMInfoManager : NSObject

@property (assign, nonatomic) NSTimeInterval lastTime;
@property (assign, nonatomic) NSInteger lastScore;
@property (assign, nonatomic) BOOL sound;

+ (AMInfoManager*) sharedManager;

- (void) saveInfo;
- (void) loadInfo;

- (NSTimeInterval) valueBestTime;
- (NSInteger) valueBestScore;

@end
