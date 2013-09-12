//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Henok T on 8/31/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCardCollectionViewCell.h"
#import "PlayingCard.h"

@interface PlayingCardGameViewController ()
@end

@implementation PlayingCardGameViewController

-(NSUInteger)startingCardCount
{
    return 22;
}

-(Deck *) createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (NSUInteger)numberOfCardsToMatch
{
    return 2;
}


-(int)matchBonus
{
    return 4;
}

-(int)mismatchPenality
{
    return 2;
}


- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card alwaysFaceUp:(BOOL)alwaysFaceUp
{
    if([cell isKindOfClass:[PlayingCardCollectionViewCell class]] && [card isKindOfClass:[PlayingCard class]]){
        PlayingCardView *playingCardView = ((PlayingCardCollectionViewCell *) cell).playingCardView;
        PlayingCard *playingCard=(PlayingCard *) card;
        playingCardView.rank = playingCard.rank;
        playingCardView.suit = playingCard.suit;
        //playingCardView.alpha = playingCard.isUnplayable ? 0.3 : 1.0;
        playingCardView.faceUp = alwaysFaceUp || playingCard.faceUp;

    }
}


@end
