//  PENTAGO
//  PROJECT 3
//  CS470 - Spring 2014
//
//  CREATED BY DAVID WELLS
//  Copyright (c) 2014 David Wells. All rights reserved.
//  All code not provided by Professor Kooshesh is the sole work of David Wells for CS470 at Sonoma State University.

#import "PentagoBrain.h"
#import "PentagoViewController.h"



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


-(void)initSubArrays{
    
    if( self.subArray0 == nil )
        self.subArray0 = [[NSMutableArray alloc] init];
    
    if( self.subArray1 == nil )
        self.subArray1 = [[NSMutableArray alloc] init];
    
    if( self.subArray2 == nil )
        self.subArray2 = [[NSMutableArray alloc] init];
    
    if( self.subArray3 == nil )
        self.subArray3 = [[NSMutableArray alloc] init];
    
    
}


-(void)sendSubViews: (NSMutableArray *)subViewArray
{
    self.subViews = subViewArray;
    self.view1 = self.subViews[0];
    self.view2 = self.subViews[1];
    self.view3 = self.subViews[2];
    self.view4 = self.subViews[3];
    
    NSLog(@"GOT %d Subviews in model", [self.subViews count]);
    
}

-(void)updateSubArray: (NSMutableArray *)subArray from:(int)subSquare
{
    if ( subSquare == 0 ) {
        NSLog(@"Updating array %d ", subSquare);
        [self.subArray0 setArray:subArray];
        NSIndexSet *mySet = [[NSIndexSet alloc]initWithIndexesInRange:NSMakeRange(0,9)];
        [self.masterArray replaceObjectsAtIndexes:mySet withObjects:self.subArray0];
    }
    else if ( subSquare == 1 ){
        NSLog(@"Updating array %d ", subSquare);
        [self.subArray1 setArray:subArray];
        NSIndexSet *mySet = [[NSIndexSet alloc]initWithIndexesInRange:NSMakeRange(9,9)];
        [self.masterArray replaceObjectsAtIndexes:mySet withObjects:self.subArray1];
    }
    else if (subSquare == 2 ){
        NSLog(@"Updating array %d ", subSquare);
        [self.subArray2 setArray:subArray];
        NSIndexSet *mySet = [[NSIndexSet alloc]initWithIndexesInRange:NSMakeRange(18,9)];
        [self.masterArray replaceObjectsAtIndexes:mySet withObjects:self.subArray2];
    }
    else if (subSquare == 3 ){
        NSLog(@"Updating array %d ", subSquare);
        [self.subArray3 setArray:subArray];
        NSIndexSet *mySet = [[NSIndexSet alloc]initWithIndexesInRange:NSMakeRange(27,9)];
        [self.masterArray replaceObjectsAtIndexes:mySet withObjects:self.subArray3];
    }
}

-(void)setSubArrays: (NSMutableArray *)subArray from:(int)subSquare
{
    [self initSubArrays];
    [self buildMasterArray];
    
    if ( subSquare == 0 ) {
        NSLog(@"Updating array %d ", subSquare);
        [self.subArray0 setArray:subArray];
        [self.masterArray addObjectsFromArray:self.subArray0];
    }
    else if ( subSquare == 1 ){
        NSLog(@"Updating array %d ", subSquare);
        [self.subArray1 setArray:subArray];
        [self.masterArray addObjectsFromArray:self.subArray1];
    }
    else if (subSquare == 2 ){
        NSLog(@"Updating array %d ", subSquare);
        [self.subArray2 setArray:subArray];
        [self.masterArray addObjectsFromArray:self.subArray2];
    }
    else if (subSquare == 3 ){
        NSLog(@"Updating array %d ", subSquare);
        [self.subArray3 setArray:subArray];
        [self.masterArray addObjectsFromArray:self.subArray3];
    }
}



-(void)buildMasterArray
{
    if (self.masterArray == Nil) {
        self.masterArray = [[NSMutableArray alloc] init];
    }
    NSLog(@"*******Items in the master array: %d ******", [self.masterArray count]);
    
    for (int i = 0; i < [self.masterArray count]; i++) {
        NSLog(@"Items in master array: %@", [self.masterArray objectAtIndex:i ]);
    }
}



-(void)checkForWinner
{
    
    
    
    
    
    
}







@end
