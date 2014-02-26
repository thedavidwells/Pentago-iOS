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




-(void)updateSubArray: (NSMutableArray *)subArray from:(int)subSquare
{
    if ( subSquare == 0 ) {
        NSLog(@"Updating array %d ", subSquare);
        [self.subArray0 setArray:subArray];
        NSIndexSet *mySet = [[NSIndexSet alloc]initWithIndexesInRange:NSMakeRange(0,9)];
        [self.masterArray replaceObjectsAtIndexes:mySet withObjects:self.subArray0];
        [self buildMasterArray];
        
        for (int i = 0; i < [self.subArray0 count]; i++) {
            //NSLog(@"Sub array in MODEL: %@", [self.subArray0 objectAtIndex:i ]);
        }
        
    }
    else if ( subSquare == 1 ){
        NSLog(@"Updating array %d ", subSquare);
        [self.subArray1 setArray:subArray];
        NSIndexSet *mySet = [[NSIndexSet alloc]initWithIndexesInRange:NSMakeRange(9,9)];
        [self.masterArray replaceObjectsAtIndexes:mySet withObjects:self.subArray1];
        [self buildMasterArray];
    }
    else if (subSquare == 2 ){
        NSLog(@"Updating array %d ", subSquare);
        [self.subArray2 setArray:subArray];
        NSIndexSet *mySet = [[NSIndexSet alloc]initWithIndexesInRange:NSMakeRange(18,9)];
        [self.masterArray replaceObjectsAtIndexes:mySet withObjects:self.subArray2];
        [self buildMasterArray];
    }
    else if (subSquare == 3 ){
        NSLog(@"Updating array %d ", subSquare);
        [self.subArray3 setArray:subArray];
        NSIndexSet *mySet = [[NSIndexSet alloc]initWithIndexesInRange:NSMakeRange(27,9)];
        [self.masterArray replaceObjectsAtIndexes:mySet withObjects:self.subArray3];
        [self buildMasterArray];
    }
}

-(void)setSubArrays: (NSMutableArray *)subArray from:(int)subSquare
{
    [self initSubArrays];
    [self buildMasterArray];
    
    if ( subSquare == 0 ) {
        NSLog(@"Setting array %d ", subSquare);
        [self.subArray0 setArray:subArray];
        [self.masterArray addObjectsFromArray:self.subArray0];
        [self buildMasterArray];
    }
    else if ( subSquare == 1 ){
        NSLog(@"Setting array %d ", subSquare);
        [self.subArray1 setArray:subArray];
        [self.masterArray addObjectsFromArray:self.subArray1];
        [self buildMasterArray];
    }
    else if (subSquare == 2 ){
        NSLog(@"Setting array %d ", subSquare);
        [self.subArray2 setArray:subArray];
        [self.masterArray addObjectsFromArray:self.subArray2];
        [self buildMasterArray];
    }
    else if (subSquare == 3 ){
        NSLog(@"Setting array %d ", subSquare);
        [self.subArray3 setArray:subArray];
        [self.masterArray addObjectsFromArray:self.subArray3];
        [self buildMasterArray];
    }
}



-(void)buildMasterArray
{
    if (self.masterArray == Nil) {
        self.masterArray = [[NSMutableArray alloc] init];
    }
    //NSLog(@"*******Items in the master array: %lu ******", (unsigned long)[self.masterArray count]);
    
    for (int i = 0; i < [self.masterArray count]; i++) {
        //NSLog(@"Items in master array: %@", [self.masterArray objectAtIndex:i ]);
    }
     
}



-(NSMutableArray *)rotateLeft: (NSMutableArray *)subArray inSubView:(int)subView
{
    
    NSMutableArray *rotated = [[NSMutableArray alloc] initWithCapacity:9];
    
    if (subView == 0) {
        [rotated addObject:[self.subArray0 objectAtIndex:2]];
        [rotated addObject:[self.subArray0 objectAtIndex:5]];
        [rotated addObject:[self.subArray0 objectAtIndex:8]];
        [rotated addObject:[self.subArray0 objectAtIndex:1]];
        [rotated addObject:[self.subArray0 objectAtIndex:4]];
        [rotated addObject:[self.subArray0 objectAtIndex:7]];
        [rotated addObject:[self.subArray0 objectAtIndex:0]];
        [rotated addObject:[self.subArray0 objectAtIndex:3]];
        [rotated addObject:[self.subArray0 objectAtIndex:6]];
    }
    else if (subView == 1) {
        [rotated addObject:[self.subArray1 objectAtIndex:2]];
        [rotated addObject:[self.subArray1 objectAtIndex:5]];
        [rotated addObject:[self.subArray1 objectAtIndex:8]];
        [rotated addObject:[self.subArray1 objectAtIndex:1]];
        [rotated addObject:[self.subArray1 objectAtIndex:4]];
        [rotated addObject:[self.subArray1 objectAtIndex:7]];
        [rotated addObject:[self.subArray1 objectAtIndex:0]];
        [rotated addObject:[self.subArray1 objectAtIndex:3]];
        [rotated addObject:[self.subArray1 objectAtIndex:6]];
    }
    else if (subView == 2) {
        [rotated addObject:[self.subArray2 objectAtIndex:2]];
        [rotated addObject:[self.subArray2 objectAtIndex:5]];
        [rotated addObject:[self.subArray2 objectAtIndex:8]];
        [rotated addObject:[self.subArray2 objectAtIndex:1]];
        [rotated addObject:[self.subArray2 objectAtIndex:4]];
        [rotated addObject:[self.subArray2 objectAtIndex:7]];
        [rotated addObject:[self.subArray2 objectAtIndex:0]];
        [rotated addObject:[self.subArray2 objectAtIndex:3]];
        [rotated addObject:[self.subArray2 objectAtIndex:6]];
    }
    else if (subView == 3) {
        [rotated addObject:[self.subArray3 objectAtIndex:2]];
        [rotated addObject:[self.subArray3 objectAtIndex:5]];
        [rotated addObject:[self.subArray3 objectAtIndex:8]];
        [rotated addObject:[self.subArray3 objectAtIndex:1]];
        [rotated addObject:[self.subArray3 objectAtIndex:4]];
        [rotated addObject:[self.subArray3 objectAtIndex:7]];
        [rotated addObject:[self.subArray3 objectAtIndex:0]];
        [rotated addObject:[self.subArray3 objectAtIndex:3]];
        [rotated addObject:[self.subArray3 objectAtIndex:6]];
    }
    
    /*
    
    [rotated addObject:[subArray objectAtIndex:2]];
    [rotated addObject:[subArray objectAtIndex:5]];
    [rotated addObject:[subArray objectAtIndex:8]];
    [rotated addObject:[subArray objectAtIndex:1]];
    [rotated addObject:[subArray objectAtIndex:4]];
    [rotated addObject:[subArray objectAtIndex:7]];
    [rotated addObject:[subArray objectAtIndex:0]];
    [rotated addObject:[subArray objectAtIndex:3]];
    [rotated addObject:[subArray objectAtIndex:6]];
     
    if (subView == 0) {
        [self.subArray0 setArray:rotated];
    }
    else if (subView == 1) {
        [self.subArray1 setArray:rotated];
    }
    else if (subView == 2) {
        [self.subArray2 setArray:rotated];
    }
    else if (subView == 3) {
        [self.subArray3 setArray:rotated];
    }
    */
    return rotated;
}




-(NSMutableArray *)rotateRight: (NSMutableArray *)subArray inSubView:(int)subView
{
    NSMutableArray *rotated = [[NSMutableArray alloc] initWithCapacity:9];
    
    
    if (subView == 0) {
        [rotated addObject:[self.subArray0 objectAtIndex:6]];
        [rotated addObject:[self.subArray0 objectAtIndex:3]];
        [rotated addObject:[self.subArray0 objectAtIndex:0]];
        [rotated addObject:[self.subArray0 objectAtIndex:7]];
        [rotated addObject:[self.subArray0 objectAtIndex:4]];
        [rotated addObject:[self.subArray0 objectAtIndex:1]];
        [rotated addObject:[self.subArray0 objectAtIndex:8]];
        [rotated addObject:[self.subArray0 objectAtIndex:5]];
        [rotated addObject:[self.subArray0 objectAtIndex:2]];
    }
    else if (subView == 1) {
        [rotated addObject:[self.subArray1 objectAtIndex:6]];
        [rotated addObject:[self.subArray1 objectAtIndex:3]];
        [rotated addObject:[self.subArray1 objectAtIndex:0]];
        [rotated addObject:[self.subArray1 objectAtIndex:7]];
        [rotated addObject:[self.subArray1 objectAtIndex:4]];
        [rotated addObject:[self.subArray1 objectAtIndex:1]];
        [rotated addObject:[self.subArray1 objectAtIndex:8]];
        [rotated addObject:[self.subArray1 objectAtIndex:5]];
        [rotated addObject:[self.subArray1 objectAtIndex:2]];
    }
    else if (subView == 2) {
        [rotated addObject:[self.subArray2 objectAtIndex:6]];
        [rotated addObject:[self.subArray2 objectAtIndex:3]];
        [rotated addObject:[self.subArray2 objectAtIndex:0]];
        [rotated addObject:[self.subArray2 objectAtIndex:7]];
        [rotated addObject:[self.subArray2 objectAtIndex:4]];
        [rotated addObject:[self.subArray2 objectAtIndex:1]];
        [rotated addObject:[self.subArray2 objectAtIndex:8]];
        [rotated addObject:[self.subArray2 objectAtIndex:5]];
        [rotated addObject:[self.subArray2 objectAtIndex:2]];
    }
    else if (subView == 3) {
        [rotated addObject:[self.subArray3 objectAtIndex:6]];
        [rotated addObject:[self.subArray3 objectAtIndex:3]];
        [rotated addObject:[self.subArray3 objectAtIndex:0]];
        [rotated addObject:[self.subArray3 objectAtIndex:7]];
        [rotated addObject:[self.subArray3 objectAtIndex:4]];
        [rotated addObject:[self.subArray3 objectAtIndex:1]];
        [rotated addObject:[self.subArray3 objectAtIndex:8]];
        [rotated addObject:[self.subArray3 objectAtIndex:5]];
        [rotated addObject:[self.subArray3 objectAtIndex:2]];
    }
    /*
    [rotated addObject:[subArray objectAtIndex:6]];
    [rotated addObject:[subArray objectAtIndex:3]];
    [rotated addObject:[subArray objectAtIndex:0]];
    [rotated addObject:[subArray objectAtIndex:7]];
    [rotated addObject:[subArray objectAtIndex:4]];
    [rotated addObject:[subArray objectAtIndex:1]];
    [rotated addObject:[subArray objectAtIndex:8]];
    [rotated addObject:[subArray objectAtIndex:5]];
    [rotated addObject:[subArray objectAtIndex:2]];
    
    if (subView == 0) {
        [self.subArray0 setArray:rotated];
    }
    else if (subView == 1) {
        [self.subArray1 setArray:rotated];
    }
    else if (subView == 2) {
        [self.subArray2 setArray:rotated];
    }
    else if (subView == 3) {
        [self.subArray3 setArray:rotated];
    }
    */
    NSLog(@"ROTATING RIGHT COMPLETE.");
    return rotated;
}



-(NSMutableArray *)flipRotation: (NSMutableArray *)subArray
{
    NSMutableArray *rotated = [[NSMutableArray alloc] initWithCapacity:9];
    
    [rotated addObject:[subArray objectAtIndex:8]];
    [rotated addObject:[subArray objectAtIndex:7]];
    [rotated addObject:[subArray objectAtIndex:6]];
    [rotated addObject:[subArray objectAtIndex:5]];
    [rotated addObject:[subArray objectAtIndex:4]];
    [rotated addObject:[subArray objectAtIndex:3]];
    [rotated addObject:[subArray objectAtIndex:2]];
    [rotated addObject:[subArray objectAtIndex:1]];
    [rotated addObject:[subArray objectAtIndex:0]];
    
    return rotated;
}




-(NSMutableArray *)updateThisArray: (int)subSquare
{
    if ( subSquare == 0 ) {
        return self.subArray0;
    }
    else if ( subSquare == 1 ){
        return self.subArray1;
    }
    else if (subSquare == 2 ){
        return self.subArray2;
    }
    else if (subSquare == 3 ){
        return self.subArray3;
    }
    return nil;
}





-(void)resetGame
{
    
    
}


-(void)alertTheWinner
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WINNER!"
                                                    message:@"You have won!"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    
}


-(void)checkForWinner
{

/*
    4 Cases for a win condition:
    1. 5 in a row
    2. 5 in a column
    3. 5 diagonal to the right
    4. 5 diagonal to the left
*/
    
    NSNumber *curentPlayer = [NSNumber numberWithInt:self.currentPlayer];
    
    
    // Go through every row:
    
    for (int i = 0; i < 7; i+=3) {
        if ( ([self.masterArray objectAtIndex:i] == curentPlayer &&
            [self.masterArray objectAtIndex:i+1] == curentPlayer &&
            [self.masterArray objectAtIndex:i+2] == curentPlayer &&
            [self.masterArray objectAtIndex:i+9] == curentPlayer &&
            [self.masterArray objectAtIndex:i+10] == curentPlayer)
            ||
            ([self.masterArray objectAtIndex:i+1] == curentPlayer &&
             [self.masterArray objectAtIndex:i+2] == curentPlayer &&
             [self.masterArray objectAtIndex:i+9] == curentPlayer &&
             [self.masterArray objectAtIndex:i+10] == curentPlayer &&
             [self.masterArray objectAtIndex:i+11] == curentPlayer)
            
            
            ) {
            
            NSLog(@"We have a winner!");
            [self alertTheWinner];
        }
    }
    
    for (int i = 18; i < 35; i+=3) {
        if ( ([self.masterArray objectAtIndex:i] == curentPlayer &&
            [self.masterArray objectAtIndex:i+1] == curentPlayer &&
            [self.masterArray objectAtIndex:i+2] == curentPlayer &&
            [self.masterArray objectAtIndex:i+9] == curentPlayer &&
            [self.masterArray objectAtIndex:i+10] == curentPlayer)
            ||
            ([self.masterArray objectAtIndex:i+1] == curentPlayer &&
             [self.masterArray objectAtIndex:i+2] == curentPlayer &&
             [self.masterArray objectAtIndex:i+9] == curentPlayer &&
             [self.masterArray objectAtIndex:i+10] == curentPlayer &&
             [self.masterArray objectAtIndex:i+11] == curentPlayer)
            ) {
            
            NSLog(@"We have a winner!");
            [self alertTheWinner];
        }
    }
    
    
    // Go through every column:
    
    for (int i = 0; i < 3; i++) {
        if ( ([self.masterArray objectAtIndex:i] == curentPlayer &&
            [self.masterArray objectAtIndex:i+3] == curentPlayer &&
            [self.masterArray objectAtIndex:i+6] == curentPlayer &&
            [self.masterArray objectAtIndex:i+18] == curentPlayer &&
            [self.masterArray objectAtIndex:i+21] == curentPlayer)
            ||
             ([self.masterArray objectAtIndex:i+3] == curentPlayer &&
              [self.masterArray objectAtIndex:i+6] == curentPlayer &&
              [self.masterArray objectAtIndex:i+18] == curentPlayer &&
              [self.masterArray objectAtIndex:i+21] == curentPlayer &&
              [self.masterArray objectAtIndex:i+24] == curentPlayer)
            
            ) {
            
            NSLog(@"We have a winner!");
            [self alertTheWinner];
        }
    }
    
    for (int i = 9; i < 12; i++) {
        if ( ([self.masterArray objectAtIndex:i] == curentPlayer &&
              [self.masterArray objectAtIndex:i+3] == curentPlayer &&
              [self.masterArray objectAtIndex:i+6] == curentPlayer &&
              [self.masterArray objectAtIndex:i+18] == curentPlayer &&
              [self.masterArray objectAtIndex:i+21] == curentPlayer)
            ||
            ([self.masterArray objectAtIndex:i+3] == curentPlayer &&
             [self.masterArray objectAtIndex:i+6] == curentPlayer &&
             [self.masterArray objectAtIndex:i+18] == curentPlayer &&
             [self.masterArray objectAtIndex:i+21] == curentPlayer &&
             [self.masterArray objectAtIndex:i+24] == curentPlayer)
            
            ) {
            
            NSLog(@"We have a winner!");
            [self alertTheWinner];
        }
    }
    
    
    
    // Diagonal to the right:
    
    if ( ([self.masterArray objectAtIndex:10] == curentPlayer &&
          [self.masterArray objectAtIndex:12] == curentPlayer &&
          [self.masterArray objectAtIndex:8] == curentPlayer &&
          [self.masterArray objectAtIndex:19] == curentPlayer &&
          [self.masterArray objectAtIndex:21] == curentPlayer)
        ||
        ([self.masterArray objectAtIndex:11] == curentPlayer &&
         [self.masterArray objectAtIndex:13] == curentPlayer &&
         [self.masterArray objectAtIndex:15] == curentPlayer &&
         [self.masterArray objectAtIndex:20] == curentPlayer &&
         [self.masterArray objectAtIndex:22] == curentPlayer)
        ||
        ([self.masterArray objectAtIndex:13] == curentPlayer &&
         [self.masterArray objectAtIndex:15] == curentPlayer &&
         [self.masterArray objectAtIndex:20] == curentPlayer &&
         [self.masterArray objectAtIndex:22] == curentPlayer &&
         [self.masterArray objectAtIndex:24] == curentPlayer)
        ||
        ([self.masterArray objectAtIndex:14] == curentPlayer &&
         [self.masterArray objectAtIndex:16] == curentPlayer &&
         [self.masterArray objectAtIndex:27] == curentPlayer &&
         [self.masterArray objectAtIndex:23] == curentPlayer &&
         [self.masterArray objectAtIndex:25] == curentPlayer)
        
        ){
        
        NSLog(@"We have a winner!");
        [self alertTheWinner];
        
    }
    
    
    
    // Diagonal to the left:
    
    if ( ([self.masterArray objectAtIndex:0] == curentPlayer &&
          [self.masterArray objectAtIndex:4] == curentPlayer &&
          [self.masterArray objectAtIndex:8] == curentPlayer &&
          [self.masterArray objectAtIndex:27] == curentPlayer &&
          [self.masterArray objectAtIndex:31] == curentPlayer)
        ||
        ([self.masterArray objectAtIndex:4] == curentPlayer &&
         [self.masterArray objectAtIndex:8] == curentPlayer &&
         [self.masterArray objectAtIndex:27] == curentPlayer &&
         [self.masterArray objectAtIndex:31] == curentPlayer &&
         [self.masterArray objectAtIndex:35] == curentPlayer)
        ||
        ([self.masterArray objectAtIndex:1] == curentPlayer &&
         [self.masterArray objectAtIndex:5] == curentPlayer &&
         [self.masterArray objectAtIndex:15] == curentPlayer &&
         [self.masterArray objectAtIndex:28] == curentPlayer &&
         [self.masterArray objectAtIndex:32] == curentPlayer)
        ||
        ([self.masterArray objectAtIndex:3] == curentPlayer &&
         [self.masterArray objectAtIndex:7] == curentPlayer &&
         [self.masterArray objectAtIndex:20] == curentPlayer &&
         [self.masterArray objectAtIndex:30] == curentPlayer &&
         [self.masterArray objectAtIndex:34] == curentPlayer)
        
        ){
        
        NSLog(@"We have a winner!");
        [self alertTheWinner];

    }
    
    
    
    
}







@end
