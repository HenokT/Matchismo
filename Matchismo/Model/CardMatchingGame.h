//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Buta on 8/17/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"
@interface CardMatchingGame : NSObject

-(id)initWithCardCount:(NSUInteger)cardCount deck:(Deck *) deck numberOfCardsToMatch:(NSUInteger)numberOfCardsToMatch matchBonus:(int) matchBonus mismatchPenalty:(int) mismatchPenalty;
-(void) flipCardAtIndex:(NSUInteger) index;
-(Card *) cardAtIndex:(NSUInteger) index;
-(void) addMoreCardsToPlay:(NSUInteger) cardCount;
-(NSUInteger)numberOfCardsInPlay;
-(NSUInteger) indexOfCard:(Card *) card;
-(void) removeCards:(NSArray *) cards;

@property (nonatomic, readonly) int score;
@property (strong, nonatomic, readonly) NSMutableArray *flipResults;
@property (nonatomic, readonly, getter = isDeckEmpty) BOOL deckEmpty;

@end
