//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Buta on 8/16/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "FlipResult.h"
@interface CardGameViewController : UIViewController

@property (nonatomic, readonly) NSUInteger numberOfCardsToMatch; //abstract
@property (nonatomic, readonly) int matchBonus; //abstract
@property (nonatomic, readonly) int mismatchPenality; //abstract

-(Deck *) createDeck; //abstract
-(void) updateCardButton:(UIButton *) cardButton withCard:(Card *) card; //abstract
- (NSAttributedString *) attributedDescriptionOfFlipResult:(FlipResult *) flipResult; 
@end
