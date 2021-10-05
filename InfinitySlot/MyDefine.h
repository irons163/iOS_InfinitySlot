//
//  MyDefine.h
//  Try_Laba_For_Cat
//
//  Created by irons on 2015/5/18.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#ifndef Try_Laba_For_Cat_MyDefine_h
#define Try_Laba_For_Cat_MyDefine_h

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#endif
