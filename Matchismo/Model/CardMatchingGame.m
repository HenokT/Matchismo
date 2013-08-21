//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Buta on 8/17/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "CardMatchingGame.h"
#import "Card.h"

@interface CardMatchingGame  ()

@property (strong, nonatomic) NSMutableArray *cards;
@property (nonatomic, readwrite) int score;
@property (strong, nonatomic, readwrite) NSString * lastFlipResult;
@end

@implementation CardMatchingGame


-(NSMutableArray *)cards
{
    if(!_cards) _cards=[[NSMutableArray alloc] init];
    return _cards;
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
    self.mode = twoCardMatch;
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
            self.lastFlipResult=[@"Flipped up " stringByAppendingString:card.contents];
            for (Card *otherCard in self.cards) {
                if(otherCard.isFaceUp && !otherCard.isUnplayable){
                    int matchScore=[card match:@[otherCard]];
                    if(matchScore){
                        int points=matchScore * MATCH_BONUS;
                        self.score += points;
                        card.unblayable = YES;
                        otherCard.unblayable = YES;
                        self.lastFlipResult = [NSString stringWithFormat:@"Matched %@ & %@ for %d points",card.contents,otherCard.contents,points];
                    }
                    else{
                        int points= - MISMATCH_PENALTY;
                        self.score += points;
                        otherCard.faceUp = NO;
                        self.lastFlipResult =[NSString stringWithFormat:@"%@ and %@ don't match! %d point penalty!", card.contents, otherCard.contents, points];
                    }
                    break;
                }
            }
            self.score -= FLIP_COST;
        }
        card.faceUp=!card.isFaceUp;
    }
}

@end
