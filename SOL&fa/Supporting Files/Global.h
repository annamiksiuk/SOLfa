//
//  Global.h
//  SOL&fa
//
//  Created by Anna Miksiuk on 13.02.2018.
//  Copyright © 2018 Anna Miksiuk. All rights reserved.
//

#ifndef Global_h
#define Global_h

// COLORS

#define colorFromRGB(redValue,greenValue,blueValue) [UIColor colorWithRed:(CGFloat)redValue/255.0f green:(CGFloat)greenValue/255.0f blue:(CGFloat)blueValue/255.0f alpha:1.0f]

// BASE COLOR PALETTE

#define BASE_PALETTE_COLOR1 colorFromRGB(252, 231, 103) //fce766
#define BASE_PALETTE_COLOR2 colorFromRGB(96, 190, 216)  //60bed8
#define BASE_PALETTE_COLOR3 colorFromRGB(235, 114, 145) //eb7291
#define BASE_PALETTE_COLOR4 colorFromRGB(131, 209, 129) //83D181
#define BASE_PALETTE_COLOR5 colorFromRGB(145, 99, 150)  //916396

// DEVICES

#define iPad UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define iPhone UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone

// FONTS

#define BASE_FONT_NAME @"Myanmar Sangam MN"

#define BASE_FONT_SIZE (iPad ? 30.0f : 20.0f)

//  GLOBAL VAR

#define COUNT_QUESTION 10

//  MARGINS FRAMES

#define PERCENT_BOTTOM_AREA (iPad ? 15 : 20)
#define PERCENT_QUESTION_SHEET (iPad ? 80 : 85)
#define PERCENT_QUESTION_VIEW 95

#define HEIGHT_STATUS_BAR 44

#define CORNER_RADIUS (iPad ? 30 : 20)

//   TIMES

#define SECOND_FOR_ANSWER 30
#define BASE_TIME_INTERVAL 0.1f

#endif /* Global_h */
