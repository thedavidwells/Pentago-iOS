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


//  Custom init method to endure my Master Array was initialized with plenty
//  capacity to ensure no array accesses go out of bounds.
//  The Master Array is initialized to -1.
-(id)init{
    self = [super init];
    NSNumber *capacity = @46;
    self.playerDidRotate = false;
    self.masterArray = [[NSMutableArray alloc] initWithCapacity:capacity.intValue];
    
    NSNumber *blank = @-1;
    for (int i = 0; i < capacity.intValue; i++) {
        [self.masterArray setObject:blank atIndexedSubscript:i];
    }
    // NSLog(@"MASTER ARRAY SIZE: %d", [self.masterArray count]);
    return self;
}

//  Check Player Rotation
//  Checks if the board has been rotated.
//  This enforces the limit of 1 rotation per turn (0 rotations is okay).
-(BOOL)checkPlayerRotation: (BOOL)isRotated
{
    if (isRotated) {
        self.playerDidRotate = TRUE;
    }
    else if(!isRotated){
        self.playerDidRotate = FALSE;
    }
    return self.playerDidRotate;
}

-(void)createGridArray: (UIView *)view {
    
    if (self.gameBoard == nil) {
        self.gameBoard = [[NSMutableArray alloc] init];
    }
    [self.gameBoard addObject:view];
}



//  Initialize the Players - which is just a simple enumerated type
//  Player 1 is 0, and Player 2 is 1.
-(void)initPlayers
{
    self.currentPlayer = player1;
    NSLog(@"Current Player: %d", self.currentPlayer);
}



//  Switch players
-(void)switchPlayers
{
    if (self.currentPlayer == player1) {
        self.currentPlayer = player2;
    }
    else if (self.currentPlayer == player2){
        self.currentPlayer = player1;
    }
}

//  Initialize all of the sub arrays here in the model
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


//  Update Sub Arrays
//  When a change is made in the view controller, this method is called.
//  It updates the correct sub array for the corresponding view controller,
//  which is defined by the subSquare number.
//  Then it also updates the proper indices in the Master Array.
-(void)updateSubArray: (NSMutableArray *)subArray from:(int)subSquare
{
    if ( subSquare == 0 ) {
        [self.subArray0 setArray:subArray];
        NSIndexSet *mySet = [[NSIndexSet alloc]initWithIndexesInRange:NSMakeRange(0,9)];
        [self.masterArray replaceObjectsAtIndexes:mySet withObjects:self.subArray0];

    }
    else if ( subSquare == 1 ){
        [self.subArray1 setArray:subArray];
        NSIndexSet *mySet = [[NSIndexSet alloc]initWithIndexesInRange:NSMakeRange(9,9)];
        [self.masterArray replaceObjectsAtIndexes:mySet withObjects:self.subArray1];

    }
    else if (subSquare == 2 ){
        [self.subArray2 setArray:subArray];
        NSIndexSet *mySet = [[NSIndexSet alloc]initWithIndexesInRange:NSMakeRange(18,9)];
        [self.masterArray replaceObjectsAtIndexes:mySet withObjects:self.subArray2];

    }
    else if (subSquare == 3 ){
        [self.subArray3 setArray:subArray];
        NSIndexSet *mySet = [[NSIndexSet alloc]initWithIndexesInRange:NSMakeRange(27,9)];
        [self.masterArray replaceObjectsAtIndexes:mySet withObjects:self.subArray3];

    }
}

//  Set Sub Arrays
//  This method will make sure the sub arrays in the model are initialized,
//  Then it will set the sub arrays to the current/ initial state of the
//  game.  Then it adds the sub arrays to the Master Array.
-(void)setSubArrays: (NSMutableArray *)subArray from:(int)subSquare
{
    [self initSubArrays];

    if ( subSquare == 0 ) {
        NSLog(@"Setting array %d ", subSquare);
        [self.subArray0 setArray:subArray];
        [self.masterArray addObjectsFromArray:self.subArray0];

    }
    else if ( subSquare == 1 ){
        NSLog(@"Setting array %d ", subSquare);
        [self.subArray1 setArray:subArray];
        [self.masterArray addObjectsFromArray:self.subArray1];

    }
    else if (subSquare == 2 ){
        NSLog(@"Setting array %d ", subSquare);
        [self.subArray2 setArray:subArray];
        [self.masterArray addObjectsFromArray:self.subArray2];

    }
    else if (subSquare == 3 ){
        NSLog(@"Setting array %d ", subSquare);
        [self.subArray3 setArray:subArray];
        [self.masterArray addObjectsFromArray:self.subArray3];

    }
}


//  Rotate Left
//  Handles all of the logic when a board is rotated left.  (Left swipe).
//  That basically means array indicies are mapped to new indicies that match
//  what is seen on the screen.
//  There are probably more elegant solutions here, but this way works.
//  A future release could handle optimization.
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
    return rotated;
}



//  Rotate Right
//  Handles all of the logic when a board is rotated right. (Right swipe).
//  That basically means array indicies are mapped to new indicies that match
//  what is seen on the screen.
//  There are probably more elegant solutions here, but this way works.
//  A future release could handle optimization.
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
    return rotated;
}



//  Update This Array
//  Basically allowed me to access the arrays in the model to help
//  keep the temp arrays I held in the view controllers up to date.
//  This could definitely be re-worked, but due to time constraints
//  it's not possible.  Future updates will handle this improvement.
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




//  Reset Game
//  Would like to implement this, time permitting.
-(void)resetGame
{
    
    
}


//  Alert the winner
//  When a win condition is detected in the Check For Winner function below,
//  it calls this method to alert the user who has just won.
-(void)alertTheWinner
{
    
    if (self.currentPlayer == player1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WINNER!"
                                                        message:@"Player 1 has won!"
                                                       delegate:nil
                                              cancelButtonTitle:@"YAY!"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if (self.currentPlayer == player2) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WINNER!"
                                                        message:@"Player 2 has won!"
                                                       delegate:nil
                                              cancelButtonTitle:@"YAY!"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    
}

//  Check for Winner
//
//  Four Cases for a win condition:
//     1. 5 in a row
//     2. 5 in a column
//     3. 5 diagonal to the right
//     4. 5 diagonal to the left
//
//  The method goes through each of these cases to check if a win
//  condition has been met.  If so, it tells the user they won with
//  the above method.
-(void)checkForWinner
{
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
    
    
}  // End check for winner method




@end
