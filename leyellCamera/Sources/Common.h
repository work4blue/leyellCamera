//
//  Common.h
//  bwRange
//
//  Created by  Andrew Huang on 14-6-3.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#ifndef bwRange_Common_h
#define bwRange_Common_h

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define SCREEN_IS_RETIAN4 ([[UIScreen mainScreen] bounds].size.height == 568)


#define BLACK_BACKGROUD RGBCOLOR(0xdf,0xdf,0xdf)

#define NORMAL_BACKGROUD RGBCOLOR(0xe7,0x78,0x17)  // 231,120,23 <color name="main_color">#e77817</color>

#define SPLASH_BACKGROUD  RGBCOLOR(0xf5,0x66,0x00)  //245,102,00  f56600

#define VIEW_ADD_STYLE1(view) [Utils addViewRound:view color:NORMAL_BACKGROUD]

#define VIEW_ADD_STYLE2(view) [Utils addViewRound:view]



#endif
