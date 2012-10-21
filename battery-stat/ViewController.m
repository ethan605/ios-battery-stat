//
//  ViewController.m
//  battery-stat
//
//  Created by Ethan Nguyễn on 10/21/12.
//  Copyright (c) 2012 Vinova. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

- (void)updateBatteryLevel;
- (double)batteryLevel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateBatteryLevel];
}

- (void)viewDidUnload {
    lblBatteryLevel = nil;
    powerSourceError = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||
            interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (void)updateBatteryLevel {
    if ([self batteryLevel] != -1.0f)
        lblBatteryLevel.text = [NSString stringWithFormat:@"%d%%", (NSInteger)[self batteryLevel]];
    else {
        lblBatteryLevel.text = @"N/A";
        UIAlertView *errorAlert =
        [[UIAlertView alloc] initWithTitle:@"Error"
                                   message:powerSourceError
                                  delegate:nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        
        [errorAlert show];
    }
}

- (double)batteryLevel {
    CFTypeRef blob = IOPSCopyPowerSourcesInfo();
    CFArrayRef sources = IOPSCopyPowerSourcesList(blob);
    
    CFDictionaryRef pSource = NULL;
    const void *psValue;
    
    int numOfSources = CFArrayGetCount(sources);
    if (numOfSources == 0) {
        powerSourceError = @"No power source found";
        return -1.0f;
    }
    
    for (int i = 0 ; i < numOfSources ; i++)
    {
        pSource = IOPSGetPowerSourceDescription(blob, CFArrayGetValueAtIndex(sources, i));
        if (!pSource) {
            powerSourceError = @"Can't get power source description";
            return -1.0f;
        }
        psValue = (CFStringRef)CFDictionaryGetValue(pSource, CFSTR(kIOPSNameKey));
        
        int curCapacity = 0;
        int maxCapacity = 0;
        double percent;
        
        psValue = CFDictionaryGetValue(pSource, CFSTR(kIOPSCurrentCapacityKey));
        CFNumberGetValue((CFNumberRef)psValue, kCFNumberSInt32Type, &curCapacity);
        
        psValue = CFDictionaryGetValue(pSource, CFSTR(kIOPSMaxCapacityKey));
        CFNumberGetValue((CFNumberRef)psValue, kCFNumberSInt32Type, &maxCapacity);
        
        percent = ((double)curCapacity/(double)maxCapacity * 100.0f);
        
        return percent; 
    }
    return -1.0f;
}

- (IBAction)btnUpdatePressed:(UIButton *)sender {
    [self updateBatteryLevel];
}

@end
