//
//  PubmedBaseCell.h
//  medsolutions
//
//  Created by Eugene Matveev on 25.08.15.
//  Copyright (c) 2015 viktorten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CEReactiveView.h"
#import "CDCellSizerProtocol.h"

#define CELL_SELECTION_COLOR [UIColor colorWithHexString:@"F20E57A3"]
#define CELL_GRAY_COLOR [UIColor colorWithHexString:@"8020242a"]
#define CELL_TEXT_COLOR [UIColor colorWithHue:0.57 saturation:0.21 brightness:0.34 alpha:1.0]

#define CELL_CURRENT_EVENT_COLOR_DARK [UIColor colorWithHue:0.0 saturation:0.3 brightness:0.9 alpha:1.0]
#define CELL_CURRENT_EVENT_COLOR_LIGHT [UIColor colorWithHue:0.0 saturation:0.04 brightness:1.0 alpha:1.0]

@interface BaseCell : UITableViewCell<CEReactiveView, CDCellSizerProtocol>

- (void)initialize;

@end
