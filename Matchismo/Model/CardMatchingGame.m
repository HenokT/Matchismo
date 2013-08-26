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
@property (nonatomic, readwrite) int score;
@property (strong, nonatomic, readwrite) NSMutableArray *flipResults;
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


-(id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck
{
    self=[super init];
    
    if(self){
        for (int i=0; i < cardCount; i++) {
            Card * card=[deck drawRandomCard];
            if(card){
                //self.cards[i]=card;
                [self.cards addObject:card];
            }
            else{
                self=nil;
                break;
            }
        }
    }
    self.playMode = TwoCardMatchMode;
    return self;
}


-(Card *)cardAtIndex:(NSUInteger)index
{
    return index < [self.cards count] ? self.cards[index] : nil;
}

#define MATCH_BONUS 4;
#define MISMATCH_PENALTY 2;
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
            if((self.playMode==TwoCardMatchMode && potentialMatches.count > 0) || (self.playMode==ThreeCardMatchMode && potentialMatches.count > 1)){
                int matchScore=[card match:potentialMatches];
                if(matchScore){
                    int points=matchScore * MATCH_BONUS;
                    self.score += points;
                    card.unblayable = YES;
                    for(Card *otherCard in potentialMatches){                       
                        otherCard.unblayable = YES;
                    }
                    flipResult=[[FlipResult alloc] initWithCards:[@[card] arrayByAddingObjectsFromArray: potentialMatches] AndPoints:points];
                }
                else{
                    int points= - MISMATCH_PENALTY;
                    self.score += points;
                    for(Card *otherCard in potentialMatches){
                        otherCard.faceUp = NO;
                    }
                    flipResult=[[FlipResult alloc] initWithCards:[@[card] arrayByAddingObjectsFromArray:potentialMatches] AndPoints:points];
                }
            }
            if(!flipResult) flipResult=[[FlipResult alloc] initWithCards:@[card] AndPoints:0];
            [self.flipResults addObject:flipResult];
            self.score -= FLIP_COST;
        }
        card.faceUp=!card.isFaceUp;
    }
}

@end
