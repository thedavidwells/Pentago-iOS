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

typedef NS_ENUM(int, rotations){
    original,
    rotatedLeft,
    rotatedRight,
    flipped
};

@property (nonatomic) BOOL playerDidRotate;
@property (nonatomic) NSMutableArray *gameBoard;
@property (nonatomic) int currentPlayer;
@property (nonatomic) NSMutableArray *masterArray;
@property(nonatomic) NSMutableArray *subArray0;
@property(nonatomic) NSMutableArray *subArray1;
@property(nonatomic) NSMutableArray *subArray2;
@property(nonatomic) NSMutableArray *subArray3;

+(PentagoBrain *) sharedInstance;

-(NSMutableArray *)rotateLeft: (NSMutableArray *)subArray inSubView:(int)subView;
-(NSMutableArray *)rotateRight: (NSMutableArray *)subArray inSubView:(int)subView;
-(NSMutableArray *)updateThisArray: (int)subSquare;
-(void)checkForWinner;
-(void)switchPlayers;
-(void)createGridArray: (UIView *)view;
-(void)updateSubArray: (NSMutableArray *)subArray from:(int)subSquare;
-(void)setSubArrays: (NSMutableArray *)subArray from:(int)subSquare;
-(BOOL)checkPlayerRotation: (BOOL)isRotated;

@end
