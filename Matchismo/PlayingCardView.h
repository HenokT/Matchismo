//
//  PlayingCardView.h
//  Matchismo
//
//  Created by Henok T on 9/3/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic)  NSUInteger rank;
@property (strong, nonatomic) NSString *suit;
@property (nonatomic) BOOL faceUp;

-(void) pinch:(UIPinchGestureRecognizer *)gesture;

@end
