//
//  Constants.h
//
//


#ifndef ____Constants_h
#define ____Constants_h

#ifdef DEBUG

#import "UIColor+Custom.h"
#import "UIFont+Custom.h"
#import "NetworkInterface.h"

#else

#endif


/* Core data entity properties */

#define CD_IMAGE @"imageLink"
#define CD_DATE @"itemDate"
#define CD_ID @"itemId"
#define CD_SORT @"itemSortOrder"
#define CD_FULL_TEXT @"itemText"
#define CD_TITLE @"itemTitle"
#define CD_ENTITY_NAME @"Item"
#define NO_IMAGE @"http://ayudahost.com/wp-content/themes/ayudahost/images/default-thumbnail.jpg"
#define CHANGE_INTERVAL 5


#endif
