//
//  Constants.h
//  МЭС
//
//  Created by viktorten on 1/26/14.
//  Copyright (c) 2014 viktorten. All rights reserved.
//


#ifndef ____Constants_h
#define ____Constants_h

#ifdef DEBUG

// #define WEBSITE @"http://medsolutions.ru"

#define WEBSITE @"http://staging.medsolutions.ru"
//#define WEBS_API @"http://staging.medsolutions.ru/api/v3"
//#define WEBS_API @"http://medsolutions.ru/api/v3"


#else

//  #define WEBSITE @"http://medsolutions.ru"

//  #define WEBSITE @"http://staging.medsolutions.ru"
//#define WEBS_API @"http://staging.medsolutions.ru/api/v3"
//#define WEBS_API @"http://medsolutions.ru/api/v3"
#endif


#define NAVBAR_HEIGHT self.navigationController.navigationBar.frame.size.height
#define AdUnitID @"a151fd58ca9034e"

#define COLOR_BG ([UIColor colorWithRed:0.188 green:0.682 blue:0.784 alpha:1.000])
#define COLOR_BG_LIGHT ([UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:243.0/255.0 alpha:1.000])
#define COLOR_TABBAR_BG ([UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:243.0/255.0 alpha:1.000])
#define COLOR_TABBAR_ACTIVE_BG ([UIColor colorWithRed:214.0/255.0 green:214.0/255.0 blue:220.0/255.0 alpha:1.000])




#endif
