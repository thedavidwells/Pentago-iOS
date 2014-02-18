//
//  PentagoBrain.m
//  PentagoStudentVersion
//
//  Created by AAK on 2/17/14.
//  Copyright (c) 2014 Ali Kooshesh. All rights reserved.
//

#import "PentagoBrain.h"

@implementation PentagoBrain

+(PentagoBrain *) sharedInstance
{
    static PentagoBrain *sharedObject = nil;
    
    if( sharedObject == nil )
        sharedObject = [[PentagoBrain alloc] init];
    return sharedObject;
}

@end
