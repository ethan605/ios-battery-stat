//
//  ViewController.h
//  battery-stat
//
//  Created by Ethan Nguyễn on 10/21/12.
//  Copyright (c) 2012 Vinova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IOPowerSources.h"
#import "IOPSKeys.h"

@interface ViewController : UIViewController {
    IBOutlet UILabel *lblBatteryLevel;
    NSString *powerSourceError;
}

@end
