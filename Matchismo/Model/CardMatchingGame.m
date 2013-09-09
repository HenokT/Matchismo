//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Buta on 8/17/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "CardMatchingGame.h"
#import "Card.h"
#import "FlipResult.h"

@interface CardMatchingGame  ()

@property (strong, nonatomic) NSMutableArray *cards;
@property (nonatomic) NSUInteger numberOfCardsToMatch;
@property (nonatomic) int matchBonus;
@property (nonatomic) int mismatchPenalty;
@property (nonatomic, readwrite) int score;
@property (strong, nonatomic, readwrite) NSMutableArray *flipResults;
@property (strong, nonatomic) Deck *deck;
@property (nonatomic) BOOL deckEmpty;
@property (nonatomic) NSUInteger numberOfCardsInPlay;

@end

@implementation CardMatchingGame


-(NSMutableArray *)cards
{
    if(!_cards) _cards=[[NSMutableArray alloc] init];
    return _cards;
}

-(NSMutableArray *)flipResults
{
    if(!_flipResults) _flipResults=[[NSMutableArray alloc] init];
    return _flipResults;
}

//designated initiaziser
-(id)initWithCardCount:(NSUInteger)cardCount deck:(Deck *) deck numberOfCardsToMatch:(NSUInteger)numberOfCardsToMatch matchBonus:(int) matchBonus mismatchPenalty:(int) mismatchPenalty
{
    self=[super init];
    
    if(self){
        _numberOfCardsToMatch = numberOfCardsToMatch;
        _matchBonus = matchBonus;
        _mismatchPenalty = mismatchPenalty;
        _deck = deck;
        _deckEmpty = NO;
        for (int i=0; i < cardCount; i++) {
            Card * card=[deck drawRandomCard];
            if(card){
                [self.cards addObject:card];
            }
            else{
                self = nil;
                break;
            }
        }
    }
    return self;
}


-(Card *)cardAtIndex:(NSUInteger)index
{
    return index < [self.cards count] ? self.cards[index] : nil;
}

-(NSUInteger) indexOfCard:(Card *) card 
{
    return [self.cards indexOfObject:card];
}

-(void) removeCards:(NSArray *) cards
{
    [self.cards removeObjectsInArray:cards];
}


-(void) addMoreCardsToPlay:(NSUInteger) cardCount
{
    for (int i = 0; i < cardCount; i++)
    {
        Card * card=[self.deck drawRandomCard];
        if(card){
            [self.cards addObject:card];
        }
        else{
            self.deckEmpty = YES;
        }
    }
}


-(NSUInteger)numberOfCardsInPlay
{
    return self.cards.count;
}


#define FLIP_COST 1;

-(void)flipCardAtIndex:(NSUInteger)index
{
    
    Card *card=[self  cardAtIndex:index];
    if(card && !card.isUnplayable){
        if(!card.isFaceUp){
            FlipResult * flipResult = nil;
            NSMutableArray *potentialMatches=[[NSMutableArray alloc] init];
            for (Card *otherCard in self.cards) {
                if(otherCard.isFaceUp && !otherCard.isUnplayable){
                    [potentialMatches addObject:otherCard];
                }
            }
            if(potentialMatches.count >= self.numberOfCardsToMatch - 1){
                int matchScore=[card match:potentialMatches];
                if(matchScore){
                    int points=matchScore * self.matchBonus;
                    self.score += points;
                    card.unblayable = YES;
                    for(Card *otherCard in potentialMatches){                       
                        otherCard.unblayable = YES;
                    }
                    flipResult=[[FlipResult alloc] initWithCardsInvolved:[@[card] arrayByAddingObjectsFromArray: potentialMatches] forPoints:points];
                }
                else{
                    int points= - self.mismatchPenalty;
                    self.score += points;
                    for(Card *otherCard in potentialMatches){
                        otherCard.faceUp = NO;
                    }
                    flipResult=[[FlipResult alloc] initWithCardsInvolved:[@[card] arrayByAddingObjectsFromArray:potentialMatches] forPoints:points];
                }
            }
            
            if(!flipResult) flipResult=[[FlipResult alloc] initWithCardsInvolved:[@[card] arrayByAddingObjectsFromArray:potentialMatches]forPoints:0];
            [self.flipResults addObject:flipResult];
            
            self.score -= FLIP_COST;
        }
        card.faceUp=!card.isFaceUp;
    }
}

@end
