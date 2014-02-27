//  PENTAGO
//  PROJECT 3
//  CS470 - Spring 2014
//
//  CREATED BY DAVID WELLS
//  Copyright (c) 2014 David Wells. All rights reserved.
//  All code not provided by Professor Kooshesh is the sole work of David Wells for CS470 at Sonoma State University.

#import "PentagoSubBoardViewController.h"
#import "PentagoBrain.h"
#import "PentagoViewController.h"

const int BORDER_WIDTH = 10;
const int TOP_MARGIN = 50;

@interface PentagoSubBoardViewController () {
    int subsquareNumber;
    int widthOfSubsquare;
    
    CGRect _gridFrame;
}

@property (nonatomic) player player;
@property (nonatomic) rotations currentRotation;
@property (nonatomic) bool collision;
@property (nonatomic) UIView *tapLocations;
@property (nonatomic, strong) PentagoBrain *pBrain;
@property (nonatomic) PentagoViewController *pView;
@property (nonatomic, strong) UIImageView *gridImageView;
@property (nonatomic) UIView *gridView;
@property (nonatomic) CALayer *ballLayer;
@property (nonatomic, strong) UITapGestureRecognizer *tapGest;
@property (nonatomic) NSNumber *blank;
@property (nonatomic) UISwipeGestureRecognizer *rightSwipe;
@property (nonatomic) UISwipeGestureRecognizer *leftSwipe;
@property (nonatomic) int rotations;
@property (nonatomic) BOOL playerDidRotate;

-(void) didTapTheView: (UITapGestureRecognizer *) tapObject;

@end




@implementation PentagoSubBoardViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpGridView];
    [self initPositionArray];
    [self.pBrain createGridArray:self.view];
    [self.pBrain setSubArrays:self.positionArray from:subsquareNumber];
    
}



//  Set up Grid View
//  Just made a method for this code to keep view Did Load simpler
//  This is code by Dr. Kooshesh posted for the CS470 class.
-(void)setUpGridView
{
    self.rotations = 0;
    
    _gridFrame = CGRectMake(0, 0, widthOfSubsquare, widthOfSubsquare);
    self.gridView = [[UIView alloc] initWithFrame: _gridFrame];
    [self.gridView addGestureRecognizer:self.rightSwipe];
    [self.gridView addGestureRecognizer:self.leftSwipe];
    [self.view addSubview: self.gridView];
    
    self.gridImageView.frame = CGRectMake(0, 0, 145, 145);
    
    UIImage *image = [UIImage imageNamed:@"grid.png"];
    [self.gridImageView setImage:image];
    [self.gridView addSubview:self.gridImageView];
    [self.gridView addGestureRecognizer: self.tapGest];
    [self.gridView setBackgroundColor:[UIColor blackColor]];
    
    [self.view setTag:subsquareNumber];
    
    CGRect viewFrame = CGRectMake( (BORDER_WIDTH + widthOfSubsquare) * (subsquareNumber % 2) + BORDER_WIDTH,
                                  (BORDER_WIDTH + widthOfSubsquare) * (subsquareNumber / 2) + BORDER_WIDTH + TOP_MARGIN,
                                  widthOfSubsquare, widthOfSubsquare);
    self.view.frame = viewFrame;
    
}



//  Init Position Array
//  Initialize a temporary array to keep track of positions in the subview
//  before sending them to the brain (model).
-(void)initPositionArray
{
    if (self.positionArray == nil) {
        self.positionArray = [[NSMutableArray alloc] initWithCapacity:9];
    }
    self.blank = [NSNumber numberWithInt:-1];
    for (int i = 0; i < 9; i++) {
        [self.positionArray  addObject:self.blank];
    }
}



//  Tap Gest
//  Initialize the tap gestrue recognizer
-(UITapGestureRecognizer *) tapGest
{
    if( ! _tapGest ) {
        _tapGest = [[UITapGestureRecognizer alloc]
                    initWithTarget:self action:@selector(didTapTheView:)];
        
        [_tapGest setNumberOfTapsRequired:1];
        [_tapGest setNumberOfTouchesRequired:1];
    }
    return _tapGest;
}



//  Right Swipe
//  Initialize the right swipe gestrue recognizer
-(UISwipeGestureRecognizer *) rightSwipe
{

    if( !_rightSwipe ) {
        _rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeRight:)];
        [_rightSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
    }
    return _rightSwipe;
}



//  Left Swipe
//  Initialize the left swipe gestrue recognizer
-(UISwipeGestureRecognizer *) leftSwipe
{

    if( !_leftSwipe ) {
        _leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeLeft:)];
        [_leftSwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    }
    return _leftSwipe;
}



//  P Brain
//  Initialize the shared instance of model, pBrain
-(PentagoBrain *) pBrain
{
    if( ! _pBrain )
        _pBrain = [PentagoBrain sharedInstance];
    return _pBrain;
}



//  Grid Image View
//  Initialize the UI Image View for the grid
-(UIImageView *) gridImageView
{
    if( ! _gridImageView ) {
        _gridImageView = [[UIImageView alloc] initWithFrame: CGRectZero];
    }
    return _gridImageView;
}



//  Init with Subsquare
//  Initializer method for creating subview, and setting subSquare number
//  to be able to identify each subview.  Code provided by Kooshesh.
-(id) initWithSubsquare: (int) position
{
    // 0 1
    // 2 3
    if( (self = [super init]) == nil )
        return nil;
    subsquareNumber = position;

    // appFrame is the frame of the entire screen so that appFrame.size.width
    // and appFrame.size.height contain the width and the height of the screen, respectively.
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    widthOfSubsquare = ( appFrame.size.width - 3 * BORDER_WIDTH ) / 2;
    
    return self;
}



//  Did Tap The View
//  Code that responds when a tap gesture is recognized.
//  Part of the code was provided by Kooshesh.
//  Handles capturing of tap point, determining where to place the image on the
//  board, where to place the value in the array, and also when a tap is detected
//  it will alternate players turns and game piece.
//  In an update I might consider refactoring this method, but for now it works.
-(void) didTapTheView: (UITapGestureRecognizer *) tapObject
{

    // p is the location of the tap in the coordinate system of this view-controller's view (not the view of the
    // the view-controller that includes the subboards.)
    
    CGPoint p = [tapObject locationInView:self.view];
    CGPoint original = p;
    
    int squareWidth = widthOfSubsquare / 3;
    //  NSLog(@"TAP LOCATION: %d , %d", (int) (p.x / squareWidth), (int) (p.y / squareWidth));
    p = [self compensateForRotation:p withSquareWidth:squareWidth];
    
    // The board is divided into nine equally sized squares and thus width = height.
    UIImageView *iView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"donut_chocolate.png"]];
    iView.frame = CGRectMake((int) (p.x / squareWidth) * squareWidth,
                             (int) (p.y / squareWidth) * squareWidth,
                             squareWidth,
                             squareWidth);
    // Switch players game piece
    if (self.pBrain.currentPlayer == player1) {
        iView.image = [UIImage imageNamed:@"donut_strawberry.png"];
        NSLog(@"Player 1's turn");
    }
    else if (self.pBrain.currentPlayer == player2){
        iView.image = [UIImage imageNamed:@"donut_chocolate.png"];
        NSLog(@"Player 2's turn");
    }
    
    self.collision = false;
    [self determineArrayPosition:original];
        if (self.collision == false) {
        
        self.ballLayer = [CALayer layer];
        [self.ballLayer addSublayer: iView.layer];
        self.ballLayer.frame = CGRectMake(0, 0, widthOfSubsquare, widthOfSubsquare);
        //self.ballLayer.affineTransform = CGAffineTransformMakeRotation(0.0);
        [self.gridView.layer addSublayer:self.ballLayer];
        
        [self.pBrain switchPlayers];
        self.playerDidRotate = [self.pBrain checkPlayerRotation:FALSE];
        [PentagoViewController changeGameStateLabel];
    }
    else{
        return;
    }
    self.collision = false;
    [self updateTempArray];

}




//  Compensate for Rotation
//  This handles the fact that the view's coordinates (where the tap point is captured)
//  stays the same, while the gridView rotates and those coordinates change.
//  There needed to be a mapping from the views normal coordinate system to the
//  rotated coordinate system of the gridView so that the game piece could be placed at
//  the correct location.
-(CGPoint)compensateForRotation: (CGPoint) point withSquareWidth: (int) squareWidth
{
    // row or column
    int zero = 25;
    int one = 75;
    int two = 140;
    
    //  Adjust for rotation
    if (self.rotations == 1 || self.rotations == -3) {
        CGPoint temp = point;

        // col 1
        if (temp.x < 49) {
            if (temp.y < 49) {
                point.x = point.x;
                point.y = 145 - temp.y;
            }
            else if(temp.y < 96){
                point.x = 75;
                point.y = 140;
            }
            else if(temp.y < 145){
                point.x = 140;
                point.y = 140;
            }
            return  point;
        }
        
        // col 2
        else if (temp.x < 96) {
            if (temp.y < 49) {
                point.x = zero;
                point.y = one;
            }
            else if(temp.y < 96){
                point.x = one;
                point.y = one;
            }
            else if(temp.y < 145){
                point.x = two;
                point.y = one;
            }
            return point;
        }
        
        // col 3
        else if (temp.x < 145) {
            if (temp.y < 49) {
                point.x = zero;
                point.y = zero;
            }
            else if(temp.y < 96){
                point.x = one;
                point.y = zero;
            }
            else if(temp.y < 145){
                point.x = two;
                point.y = zero;
            }
            return point;
        }
    }
    
        //  Adjust for rotation
        else if (self.rotations == 2 || self.rotations == -2) {
            CGPoint temp = point;
            
            // col 1
            if (temp.x < 49) {
                if (temp.y < 49) {
                    point.x = two;
                    point.y = two;
                }
                else if(temp.y < 96){
                    point.x = two;
                    point.y = one;
                }
                else if(temp.y < 145){
                    point.x = two;
                    point.y = zero;
                }
                return  point;
            }
            
            // col 2
            else if (temp.x < 96) {
                if (temp.y < 49) {
                    point.x = one;
                    point.y = two;
                }
                else if(temp.y < 96){
                    point.x = one;
                    point.y = one;
                }
                else if(temp.y < 145){
                    point.x = one;
                    point.y = zero;
                }
                return point;
            }
            
            // col 3
            else if (temp.x < 145) {
                if (temp.y < 49) {
                    point.x = zero;
                    point.y = two;
                }
                else if(temp.y < 96){
                    point.x = zero;
                    point.y = one;
                }
                else if(temp.y < 145){
                    point.x = zero;
                    point.y = zero;
                }
                return point;
            }
        }

        
            //  Adjust for rotation
            else if (self.rotations == 3 || self.rotations == -1) {
                CGPoint temp = point;
                
                // col 1
                if (temp.x < 49) {
                    if (temp.y < 49) {
                        point.x = two;
                        point.y = zero;
                    }
                    else if(temp.y < 96){
                        point.x = one;
                        point.y = zero;
                    }
                    else if(temp.y < 145){
                        point.x = zero;
                        point.y = zero;
                    }
                    return  point;
                }
                
                // col 2
                else if (temp.x < 96) {
                    if (temp.y < 49) {
                        point.x = two;
                        point.y = one;
                    }
                    else if(temp.y < 96){
                        point.x = one;
                        point.y = one;
                    }
                    else if(temp.y < 145){
                        point.x = zero;
                        point.y = one;
                    }
                    return point;
                }
                
                // col 3
                else if (temp.x < 145) {
                    if (temp.y < 49) {
                        point.x = two;
                        point.y = two;
                    }
                    else if(temp.y < 96){
                        point.x = one;
                        point.y = two;
                    }
                    else if(temp.y < 145){
                        point.x = zero;
                        point.y = two;
                    }
                    return point;
                }
            }
    return point;
}




//  Determine Array Position
//  This method uses the true coordinates of the view to determine where to
//  put the players value in the array.
-(void)determineArrayPosition: (CGPoint)point
{
    NSNumber *currentPlayer = [NSNumber numberWithInt:self.pBrain.currentPlayer];
    [self updateTempArray];

    // Column 1
    if (point.x < 49) {
        if ( point.y < 49) {
            if ([self.positionArray objectAtIndex:0] ==  self.blank) {
                [self.positionArray replaceObjectAtIndex:0 withObject:currentPlayer];
            }
            else{
                self.collision = true;
            }
        }
        else if ( point.y < 96) {
            if ([self.positionArray objectAtIndex:3] ==  self.blank) {
                [self.positionArray replaceObjectAtIndex:3 withObject:currentPlayer];
            }
            else{
                self.collision = true;
            }
        }
        else if ( point.y < 145) {
            if ([self.positionArray objectAtIndex:6] ==  self.blank) {
                [self.positionArray replaceObjectAtIndex:6 withObject:currentPlayer];
            }
            else{
                self.collision = true;
            }
        }
    }
    
    // Column 2
    else if (point.x < 96){
        if ( point.y < 49) {
            if ([self.positionArray objectAtIndex:1] ==  self.blank) {
                [self.positionArray replaceObjectAtIndex:1 withObject:currentPlayer];
            }
            else{
                self.collision = true;
            }
        }
        else if ( point.y < 96) {
            if ([self.positionArray objectAtIndex:4] ==  self.blank) {
                [self.positionArray replaceObjectAtIndex:4 withObject:currentPlayer];
            }
            else{
                self.collision = true;
            }
        }
        else if ( point.y < 145) {
            if ([self.positionArray objectAtIndex:7] ==  self.blank) {
                [self.positionArray replaceObjectAtIndex:7 withObject:currentPlayer];
            }
            else{
                self.collision = true;
            }
        }
    }
    
    // Column 3
    else if (point.x < 145){
        if ( point.y < 49) {
            if ([self.positionArray objectAtIndex:2] ==  self.blank) {
                [self.positionArray replaceObjectAtIndex:2 withObject:currentPlayer];
            }
            else{
                self.collision = true;
            }
        }
        else if ( point.y < 96) {
            if ([self.positionArray objectAtIndex:5] ==  self.blank) {
                [self.positionArray replaceObjectAtIndex:5 withObject:currentPlayer];
            }
            else{
                self.collision = true;
            }
        }
        else if ( point.y < 145) {
            if ([self.positionArray objectAtIndex:8] ==  self.blank) {
                [self.positionArray replaceObjectAtIndex:8 withObject:currentPlayer];
            }
            else{
                self.collision = true;
            }
        }
    }
    
    [self.pBrain updateSubArray:self.positionArray from:subsquareNumber];
    [self.pBrain checkForWinner];
    //[self updateTempArray];
}




//  Did Swipe Right
//  Triggered when a right swipe gesture is recognized.
//  Handles rotation of the gridView.  Also handles calling the method
//  in the model that does the rotation logic.
-(void) didSwipeRight: (UISwipeGestureRecognizer *) recongizer
{
    NSLog(@"Did swipe right in the the %ld view", (long)[self.view tag] );
    if (self.playerDidRotate) {
        return;
    }
    CGAffineTransform currTransform = self.gridView.layer.affineTransform;
    [UIView animateWithDuration:.15 animations:^ {
        CGAffineTransform newTransform = CGAffineTransformConcat(currTransform, CGAffineTransformMakeRotation(M_PI/2));
        self.gridView.layer.affineTransform = newTransform;
    }];

    [self.view bringSubviewToFront:self.gridView];
    [self.view addGestureRecognizer:self.rightSwipe];
    
    [self.positionArray setArray:[self.pBrain rotateRight:self.positionArray inSubView:subsquareNumber]];
    [self.pBrain updateSubArray:self.positionArray from:subsquareNumber];
    
    self.currentRotation = rotatedRight;
    self.rotations++;
    if (self.rotations == 4 || self.rotations == -4) {
        self.rotations = 0;
    }
    self.playerDidRotate = [self.pBrain checkPlayerRotation:TRUE];
    //[self updateTempArray];
}




//  Did Swipe Left
//  Triggered when a left swipe gesture is recognized.
//  Handles rotation of the gridView.  Also handles calling the method
//  in the model that does the rotation logic.
-(void) didSwipeLeft: (UISwipeGestureRecognizer *) recongizer
{
    NSLog(@"Did swipe left in the the %ld view", (long)[self.view tag] );
    if (self.playerDidRotate) {
        return;
    }
    CGAffineTransform currTransform = self.gridView.layer.affineTransform;
    [UIView animateWithDuration:.15 animations:^ {
        CGAffineTransform newTransform = CGAffineTransformConcat(currTransform, CGAffineTransformMakeRotation(M_PI/-2));
        self.gridView.layer.affineTransform = newTransform;
    }];
    
    [self.view bringSubviewToFront:self.gridView];
    [self.view addGestureRecognizer:self.leftSwipe];
    
    
    [self.positionArray setArray:[self.pBrain rotateLeft:self.positionArray inSubView:subsquareNumber]];
    [self.pBrain updateSubArray:self.positionArray from:subsquareNumber];
    
    self.currentRotation = rotatedLeft;
    self.rotations--;

    if (self.rotations == 4 || self.rotations == -4) {
        self.rotations = 0;
    }
    self.playerDidRotate = [self.pBrain checkPlayerRotation:TRUE];
    //[self updateTempArray];
}




//  Update Temp Array
//  Updates the temp array here in the view controller with array from model
//  Used just to keep things current and valid.
-(void)updateTempArray
{
    NSIndexSet *mySet = [[NSIndexSet alloc]initWithIndexesInRange:NSMakeRange(0,9)];
    
    [self.positionArray replaceObjectsAtIndexes:mySet withObjects:[self.pBrain updateThisArray:subsquareNumber] ];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
