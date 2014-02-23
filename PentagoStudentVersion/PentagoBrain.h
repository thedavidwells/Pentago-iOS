//  PENTAGO
//  PROJECT 3
//  CS470 - Spring 2014
//
//  CREATED BY DAVID WELLS
//  Copyright (c) 2014 David Wells. All rights reserved.
//  All code not provided by Professor Kooshesh is the sole work of David Wells for CS470 at Sonoma State University.

#import <Foundation/Foundation.h>

@interface PentagoBrain : NSObject

typedef NS_ENUM(int, player){
    player1,
    player2
};

@property (nonatomic) NSMutableArray *gameBoard;
@property (nonatomic) int currentPlayer;

-(void)switchPlayers;
-(void)createGridArray: (UIView *)view;
+(PentagoBrain *) sharedInstance;

@end
