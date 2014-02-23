//  PENTAGO
//  PROJECT 3
//  CS470 - Spring 2014
//
//  CREATED BY DAVID WELLS
//  Copyright (c) 2014 David Wells. All rights reserved.
//  All code not provided by Professor Kooshesh is the sole work of David Wells for CS470 at Sonoma State University.

#import "PentagoBrain.h"

@implementation PentagoBrain





+(PentagoBrain *) sharedInstance
{
    static PentagoBrain *sharedObject = nil;
    
    if( sharedObject == nil )
        sharedObject = [[PentagoBrain alloc] init];
    return sharedObject;
}


-(void)createGridArray: (UIView *)view {
    
    if (self.gameBoard == Nil) {
        self.gameBoard = [[NSMutableArray alloc] init];
    }
    [self.gameBoard addObject:view];
    NSLog(@"added object to grid array...");
}

-(void)initPlayers
{
    self.currentPlayer = player1;
    
    NSLog(@"Current Player: %d", self.currentPlayer);
}

-(void)switchPlayers
{
    if (self.currentPlayer == player1) {
        self.currentPlayer = player2;
    }
    else if (self.currentPlayer == player2){
        self.currentPlayer = player1;
    }
}


@end
