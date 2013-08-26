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

typedef enum {
    TwoCardMatchMode=0,
    ThreeCardMatchMode=1
} PlayMode;

- (id) initWithCardCount:(NSUInteger) cardCount
               usingDeck:(Deck *) deck;
- (void) flipCardAtIndex:(NSUInteger) index;
- (Card *) cardAtIndex:(NSUInteger) index;

@property (nonatomic, readonly) int score;
@property (nonatomic) PlayMode playMode;
@property (strong, nonatomic, readonly) NSMutableArray *flipResults;

@end
