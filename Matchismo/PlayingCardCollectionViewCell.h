//
//  PlayingCardCollectionViewCell.h
//  Matchismo
//
//  Created by Henok T on 9/6/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayingCardView.h"

@interface PlayingCardCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;

@end
