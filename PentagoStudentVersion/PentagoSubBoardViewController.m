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

@property(nonatomic) player player;
@property(nonatomic) rotations currentRotation;


@property(nonatomic) bool collision;

@property(nonatomic) UIView *tapLocations;

@property (nonatomic, strong) PentagoBrain *pBrain;
@property(nonatomic) PentagoViewController *pView;
@property (nonatomic, strong) UIImageView *gridImageView;
@property (nonatomic) UIView *gridView;
@property (nonatomic) CALayer *ballLayer;

@property (nonatomic, strong) UITapGestureRecognizer *tapGest;

@property (nonatomic) NSNumber *blank;

@property (nonatomic) UISwipeGestureRecognizer *rightSwipe;
@property (nonatomic) UISwipeGestureRecognizer *leftSwipe;

-(void) didTapTheView: (UITapGestureRecognizer *) tapObject;

@property(nonatomic) int rotations;

@end




@implementation PentagoSubBoardViewController





- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpGridView];
    //[self setUpTapView];
    [self initPositionArray];
    
    [self.pBrain createGridArray:self.view];
    [self.pBrain setSubArrays:self.positionArray from:subsquareNumber];
    
}


-(void)setUpTapView
{
    
    self.tapLocations = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 145, 145)];
    [self.tapLocations setBackgroundColor: [UIColor clearColor]];
    self.tapLocations.frame = CGRectMake(0, 0, 145, 145);
    //self.tapLocations.affineTransform = CGAffineTransformMakeRotation(0.0);
    [self.view addSubview:self.tapLocations];
    
}


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


-(void)initPositionArray
{
    if (self.positionArray == nil) {
        self.positionArray = [[NSMutableArray alloc] initWithCapacity:9];
    }
    
    self.blank = [NSNumber numberWithInt:-1];

    
    for (int i = 0; i < 9; i++) {
        [self.positionArray  addObject:self.blank];
        //NSLog(@"Object initialized to array: %@", self.blank);
    }
    
}


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

-(UISwipeGestureRecognizer *) rightSwipe
{

    if( !_rightSwipe ) {
        _rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeRight:)];
        [_rightSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
    }
    return _rightSwipe;
}

-(UISwipeGestureRecognizer *) leftSwipe
{

    if( !_leftSwipe ) {
        _leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeLeft:)];
        [_leftSwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    }
    return _leftSwipe;
}


-(PentagoBrain *) pBrain
{
    if( ! _pBrain )
        _pBrain = [PentagoBrain sharedInstance];
    return _pBrain;
}

-(UIImageView *) gridImageView
{
    if( ! _gridImageView ) {
        _gridImageView = [[UIImageView alloc] initWithFrame: CGRectZero];
    }
    return _gridImageView;
}

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


-(void) didTapTheView: (UITapGestureRecognizer *) tapObject
{

    // p is the location of the tap in the coordinate system of this view-controller's view (not the view of the
    // the view-controller that includes the su0bboards.)
    
    CGPoint p = [tapObject locationInView:self.view];
    
    CGPoint original = p;
    
    int squareWidth = widthOfSubsquare / 3;
    
    NSLog(@"TAP LOCATION: %d , %d", (int) (p.x / squareWidth), (int) (p.y / squareWidth));
    
    p = [self compensateForRotation:p withSquareWidth:squareWidth];
    
    

    // The board is divided into nine equally sized squares and thus width = height.
    UIImageView *iView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"donut_chocolate.png"]];
    iView.frame = CGRectMake((int) (p.x / squareWidth) * squareWidth,
                             (int) (p.y / squareWidth) * squareWidth,
                             squareWidth,
                             squareWidth);
    
    
    // Switch players
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
        [PentagoViewController changeGameStateLabel];
    }
    else{
        return;
    }
    self.collision = false;
    [self updateTempArray];

}



-(CGPoint)compensateForRotation: (CGPoint) point withSquareWidth: (int) squareWidth
{
    // row or column
    int zero = 25;
    int one = 75;
    int two = 140;
    
    //  Adjust for rotation
    if (self.rotations == 1 || self.rotations == -3) {
        NSLog(@"adjusting for rotation...... rotation = %d", self.rotations);
        CGPoint temp = point;

        // col 1
        if (temp.x < 49) {
            NSLog(@"%f, %f", temp.x, temp.y);
            
            if (temp.y < 49) {
                point.x = point.x;
                point.y = 145 - temp.y;
            }
            else if(temp.y < 96){
                point.x = 75;
                point.y = 140;
                NSLog(@"%f, %f", point.x, point.y);
            }
            else if(temp.y < 145){
                point.x = 140;
                point.y = 140;
                NSLog(@"%f, %f", point.x, point.y);
            }
            return  point;
        }
        
        // col 2
        else if (temp.x < 96) {
            NSLog(@"%f, %f", temp.x, temp.y);
            
            if (temp.y < 49) {
                point.x = zero;
                point.y = one;
            }
            else if(temp.y < 96){
                point.x = one;
                point.y = one;
                NSLog(@"%f, %f", point.x, point.y);
            }
            else if(temp.y < 145){
                point.x = two;
                point.y = one;
                NSLog(@"%f, %f", point.x, point.y);
            }
            return point;
        }
        
        // col 3
        else if (temp.x < 145) {
            NSLog(@"%f, %f", temp.x, temp.y);
            
            if (temp.y < 49) {
                point.x = zero;
                point.y = zero;
            }
            else if(temp.y < 96){
                point.x = one;
                point.y = zero;
                NSLog(@"%f, %f", point.x, point.y);
            }
            else if(temp.y < 145){
                point.x = two;
                point.y = zero;
                NSLog(@"%f, %f", point.x, point.y);
            }
            return point;
        }
    }
    
        //  Adjust for rotation
        else if (self.rotations == 2 || self.rotations == -2) {
            NSLog(@"adjusting for rotation...... rotation = %d", self.rotations);
            CGPoint temp = point;
            
            // col 1
            if (temp.x < 49) {
                NSLog(@"%f, %f", temp.x, temp.y);
                
                if (temp.y < 49) {
                    point.x = two;
                    point.y = two;
                }
                else if(temp.y < 96){
                    point.x = two;
                    point.y = one;
                    NSLog(@"%f, %f", point.x, point.y);
                }
                else if(temp.y < 145){
                    point.x = two;
                    point.y = zero;
                    NSLog(@"%f, %f", point.x, point.y);
                }
                return  point;
            }
            
            // col 2
            else if (temp.x < 96) {
                NSLog(@"%f, %f", temp.x, temp.y);
                
                if (temp.y < 49) {
                    point.x = one;
                    point.y = two;
                }
                else if(temp.y < 96){
                    point.x = one;
                    point.y = one;
                    NSLog(@"%f, %f", point.x, point.y);
                }
                else if(temp.y < 145){
                    point.x = one;
                    point.y = zero;
                    NSLog(@"%f, %f", point.x, point.y);
                }
                return point;
            }
            
            // col 3
            else if (temp.x < 145) {
                NSLog(@"%f, %f", temp.x, temp.y);
                
                if (temp.y < 49) {
                    point.x = zero;
                    point.y = two;
                }
                else if(temp.y < 96){
                    point.x = zero;
                    point.y = one;
                    NSLog(@"%f, %f", point.x, point.y);
                }
                else if(temp.y < 145){
                    point.x = zero;
                    point.y = zero;
                    NSLog(@"%f, %f", point.x, point.y);
                }
                return point;
            }
        }

        
            //  Adjust for rotation
            else if (self.rotations == 3 || self.rotations == -1) {
                NSLog(@"adjusting for rotation...... rotation = %d", self.rotations);
                CGPoint temp = point;
                
                // col 1
                if (temp.x < 49) {
                    NSLog(@"%f, %f", temp.x, temp.y);
                    
                    if (temp.y < 49) {
                        point.x = two;
                        point.y = zero;
                    }
                    else if(temp.y < 96){
                        point.x = one;
                        point.y = zero;
                        NSLog(@"%f, %f", point.x, point.y);
                    }
                    else if(temp.y < 145){
                        point.x = zero;
                        point.y = zero;
                        NSLog(@"%f, %f", point.x, point.y);
                    }
                    return  point;
                }
                
                // col 2
                else if (temp.x < 96) {
                    NSLog(@"%f, %f", temp.x, temp.y);
                    
                    if (temp.y < 49) {
                        point.x = two;
                        point.y = one;
                    }
                    else if(temp.y < 96){
                        point.x = one;
                        point.y = one;
                        NSLog(@"%f, %f", point.x, point.y);
                    }
                    else if(temp.y < 145){
                        point.x = zero;
                        point.y = one;
                        NSLog(@"%f, %f", point.x, point.y);
                    }
                    return point;
                }
                
                // col 3
                else if (temp.x < 145) {
                    NSLog(@"%f, %f", temp.x, temp.y);
                    
                    if (temp.y < 49) {
                        point.x = two;
                        point.y = two;
                    }
                    else if(temp.y < 96){
                        point.x = one;
                        point.y = two;
                        NSLog(@"%f, %f", point.x, point.y);
                    }
                    else if(temp.y < 145){
                        point.x = zero;
                        point.y = two;
                        NSLog(@"%f, %f", point.x, point.y);
                    }
                    return point;
                }
            }
    return point;
}

-(void)determineArrayPosition: (CGPoint)point
{
    NSNumber *currentPlayer = [NSNumber numberWithInt:self.pBrain.currentPlayer];
    
    [self updateTempArray];

    
    // Column 1
    if (point.x < 49) {
        if ( point.y < 49) {
            NSLog(@"array index 0");
            
            if ([self.positionArray objectAtIndex:0] ==  self.blank) {
                NSLog(@"Blank, replacing");
                [self.positionArray replaceObjectAtIndex:0 withObject:currentPlayer];
            }
            else{
                NSLog(@"NOT BLANK");
                NSLog(@"Object: %@", [self.positionArray objectAtIndex:0]);
                self.collision = true;
            }
            
        }
        else if ( point.y < 96) {
            NSLog(@"array index 3");
            
            if ([self.positionArray objectAtIndex:3] ==  self.blank) {
                NSLog(@"Blank, replacing");
                [self.positionArray replaceObjectAtIndex:3 withObject:currentPlayer];
            }
            else{
                NSLog(@"NOT BLANK");
                NSLog(@"Object: %@", [self.positionArray objectAtIndex:3]);
                self.collision = true;
            }

            
            
        }
        else if ( point.y < 145) {
            
            
            NSLog(@"array index 6");
            
            if ([self.positionArray objectAtIndex:6] ==  self.blank) {
                NSLog(@"Blank, replacing");
                [self.positionArray replaceObjectAtIndex:6 withObject:currentPlayer];
            }
            else{
                NSLog(@"NOT BLANK");
                NSLog(@"Object: %@", [self.positionArray objectAtIndex:0]);
                self.collision = true;
            }

        }
        
        
    }
    
    // Column 2
    else if (point.x < 96){
        if ( point.y < 49) {
            NSLog(@"array index 1");
            if ([self.positionArray objectAtIndex:1] ==  self.blank) {
                NSLog(@"Blank, replacing");
                [self.positionArray replaceObjectAtIndex:1 withObject:currentPlayer];
            }
            else{
                NSLog(@"NOT BLANK");
                NSLog(@"Object: %@", [self.positionArray objectAtIndex:1]);
                self.collision = true;
            }
        }
        else if ( point.y < 96) {
            NSLog(@"array index 4");
            if ([self.positionArray objectAtIndex:4] ==  self.blank) {
                NSLog(@"Blank, replacing");
                [self.positionArray replaceObjectAtIndex:4 withObject:currentPlayer];
            }
            else{
                NSLog(@"NOT BLANK");
                NSLog(@"Object: %@", [self.positionArray objectAtIndex:4]);
                self.collision = true;
            }
        }
        else if ( point.y < 145) {
            NSLog(@"array index 7");
            if ([self.positionArray objectAtIndex:7] ==  self.blank) {
                NSLog(@"Blank, replacing");
                [self.positionArray replaceObjectAtIndex:7 withObject:currentPlayer];
            }
            else{
                NSLog(@"NOT BLANK");
                NSLog(@"Object: %@", [self.positionArray objectAtIndex:7]);
                self.collision = true;
            }
        }
    }
    
    // Column 3
    else if (point.x < 145){
        if ( point.y < 49) {
            NSLog(@"array index 2");
            if ([self.positionArray objectAtIndex:2] ==  self.blank) {
                NSLog(@"Blank, replacing");
                [self.positionArray replaceObjectAtIndex:2 withObject:currentPlayer];
            }
            else{
                NSLog(@"NOT BLANK");
                NSLog(@"Object: %@", [self.positionArray objectAtIndex:2]);
                self.collision = true;
            }
        }
        else if ( point.y < 96) {
            NSLog(@"array index 5");
            if ([self.positionArray objectAtIndex:5] ==  self.blank) {
                NSLog(@"Blank, replacing");
                [self.positionArray replaceObjectAtIndex:5 withObject:currentPlayer];
            }
            else{
                NSLog(@"NOT BLANK");
                NSLog(@"Object: %@", [self.positionArray objectAtIndex:5]);
                self.collision = true;
            }
        }
        else if ( point.y < 145) {
            NSLog(@"array index 8");
            if ([self.positionArray objectAtIndex:8] ==  self.blank) {
                NSLog(@"Blank, replacing");
                [self.positionArray replaceObjectAtIndex:8 withObject:currentPlayer];
            }
            else{
                NSLog(@"NOT BLANK");
                NSLog(@"Object: %@", [self.positionArray objectAtIndex:8]);
                self.collision = true;
            }
        }
    }
    
    [self.pBrain updateSubArray:self.positionArray from:subsquareNumber];
    // NSLog(@"UPDATE SHOULD HAVE OCCURED");
    [self.pBrain buildMasterArray];
    [self.pBrain checkForWinner];
    //[self updateTempArray];
}


-(void) didSwipeRight: (UISwipeGestureRecognizer *) recongizer
{
    NSLog(@"Did swipe right in the the %ld view", (long)[self.view tag] );
    
    
    
    CGAffineTransform currTransform = self.gridView.layer.affineTransform;
    [UIView animateWithDuration:.15 animations:^ {
        CGAffineTransform newTransform = CGAffineTransformConcat(currTransform, CGAffineTransformMakeRotation(M_PI/2));
        self.gridView.layer.affineTransform = newTransform;
    }];

    [self.view bringSubviewToFront:self.gridView];
    [self.view addGestureRecognizer:self.rightSwipe];
    
    
    [self.positionArray setArray:[self.pBrain rotateRight:self.positionArray inSubView:subsquareNumber]];
    [self.pBrain updateSubArray:self.positionArray from:subsquareNumber];
    
    NSLog(@"*******Items in the SUB array: %lu ******", (unsigned long)[self.positionArray count]);
    
    for (int i = 0; i < [self.positionArray count]; i++) {
        NSLog(@"SUB ARRAY at %d: %@", i, [self.positionArray objectAtIndex:i ]);
    }
    
    self.currentRotation = rotatedRight;
    self.rotations++;
    NSLog(@"ROTATIONS:  %d", self.rotations);
    if (self.rotations == 4 || self.rotations == -4) {
        self.rotations = 0;
    }
    //[self updateTempArray];
}

-(void) didSwipeLeft: (UISwipeGestureRecognizer *) recongizer
{
    NSLog(@"Did swipe left in the the %ld view", (long)[self.view tag] );
    
    
    
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
    NSLog(@"ROTATIONS:  %d", self.rotations);
    if (self.rotations == 4 || self.rotations == -4) {
        self.rotations = 0;
    }
    //[self updateTempArray];
}


-(void)updateTempArray
{
    
    NSIndexSet *mySet = [[NSIndexSet alloc]initWithIndexesInRange:NSMakeRange(0,9)];
    
    [self.positionArray replaceObjectsAtIndexes:mySet withObjects:[self.pBrain updateThisArray:subsquareNumber] ];
    
    
    for (int i = 0; i < [self.positionArray count]; i++) {
        //NSLog(@"Sub array: %@", [self.positionArray objectAtIndex:i ]);
    }
}


-(void)adjustForPartialRotation: (CGPoint)point
{
    NSNumber *currentPlayer = [NSNumber numberWithInt:self.pBrain.currentPlayer];
    
    if (self.rotations == 1 || self.rotations == -3) {
        point.x = 145 - point.x;
        
    }
    else if (self.rotations == 2 || self.rotations == -2){
        point.x = 145 - point.x;
        point.y = 145 - point.y;
    }
    else if (self.rotations == 3 || self.rotations == -1){
        point.y = 145 - point.y;
    }

    
    
    // Column 1
    if (point.x < 49) {
        if ( point.y < 49) {
            NSLog(@"array index 0");
            
            if ([self.positionArray objectAtIndex:0] ==  self.blank) {
                NSLog(@"Blank, replacing");
                [self.positionArray replaceObjectAtIndex:0 withObject:currentPlayer];
            }
            else{
                NSLog(@"NOT BLANK");
                NSLog(@"Object: %@", [self.positionArray objectAtIndex:0]);
                self.collision = true;
            }
            
        }
        else if ( point.y < 96) {
            NSLog(@"array index 3");
            
            if ([self.positionArray objectAtIndex:3] ==  self.blank) {
                NSLog(@"Blank, replacing");
                [self.positionArray replaceObjectAtIndex:3 withObject:currentPlayer];
            }
            else{
                NSLog(@"NOT BLANK");
                NSLog(@"Object: %@", [self.positionArray objectAtIndex:3]);
                self.collision = true;
            }
            
            
            
        }
        else if ( point.y < 145) {
            
            
            NSLog(@"array index 6");
            
            if ([self.positionArray objectAtIndex:6] ==  self.blank) {
                NSLog(@"Blank, replacing");
                [self.positionArray replaceObjectAtIndex:6 withObject:currentPlayer];
            }
            else{
                NSLog(@"NOT BLANK");
                NSLog(@"Object: %@", [self.positionArray objectAtIndex:0]);
                self.collision = true;
            }
            
        }
        
        
    }
    
    // Column 2
    else if (point.x < 96){
        if ( point.y < 49) {
            NSLog(@"array index 1");
            if ([self.positionArray objectAtIndex:1] ==  self.blank) {
                NSLog(@"Blank, replacing");
                [self.positionArray replaceObjectAtIndex:1 withObject:currentPlayer];
            }
            else{
                NSLog(@"NOT BLANK");
                NSLog(@"Object: %@", [self.positionArray objectAtIndex:1]);
                self.collision = true;
            }
        }
        else if ( point.y < 96) {
            NSLog(@"array index 4");
            if ([self.positionArray objectAtIndex:4] ==  self.blank) {
                NSLog(@"Blank, replacing");
                [self.positionArray replaceObjectAtIndex:4 withObject:currentPlayer];
            }
            else{
                NSLog(@"NOT BLANK");
                NSLog(@"Object: %@", [self.positionArray objectAtIndex:4]);
                self.collision = true;
            }
        }
        else if ( point.y < 145) {
            NSLog(@"array index 7");
            if ([self.positionArray objectAtIndex:7] ==  self.blank) {
                NSLog(@"Blank, replacing");
                [self.positionArray replaceObjectAtIndex:7 withObject:currentPlayer];
            }
            else{
                NSLog(@"NOT BLANK");
                NSLog(@"Object: %@", [self.positionArray objectAtIndex:7]);
                self.collision = true;
            }
        }
    }
    
    // Column 3
    else if (point.x < 145){
        if ( point.y < 49) {
            NSLog(@"array index 2");
            if ([self.positionArray objectAtIndex:2] ==  self.blank) {
                NSLog(@"Blank, replacing");
                [self.positionArray replaceObjectAtIndex:2 withObject:currentPlayer];
            }
            else{
                NSLog(@"NOT BLANK");
                NSLog(@"Object: %@", [self.positionArray objectAtIndex:2]);
                self.collision = true;
            }
        }
        else if ( point.y < 96) {
            NSLog(@"array index 5");
            if ([self.positionArray objectAtIndex:5] ==  self.blank) {
                NSLog(@"Blank, replacing");
                [self.positionArray replaceObjectAtIndex:5 withObject:currentPlayer];
            }
            else{
                NSLog(@"NOT BLANK");
                NSLog(@"Object: %@", [self.positionArray objectAtIndex:5]);
                self.collision = true;
            }
        }
        else if ( point.y < 145) {
            NSLog(@"array index 8");
            if ([self.positionArray objectAtIndex:8] ==  self.blank) {
                NSLog(@"Blank, replacing");
                [self.positionArray replaceObjectAtIndex:8 withObject:currentPlayer];
            }
            else{
                NSLog(@"NOT BLANK");
                NSLog(@"Object: %@", [self.positionArray objectAtIndex:8]);
                self.collision = true;
            }
        }
    }

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
