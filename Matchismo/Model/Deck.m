//
//  Deck.m
//  Matchismo
//
//  Created by Buta on 8/16/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "Deck.h"

@interface Deck ()
@property (strong,nonatomic) NSMutableArray *cards;//array of Cards
@end

@implementation Deck

-(NSMutableArray *)cards
{
    if(!_cards) _cards=[[NSMutableArray alloc] init];
    return _cards;
}

-(void)addCard:(Card *)card atTop:(BOOL)atTop
{
    if (card) {
        if (atTop) {
            [self.cards insertObject:card atIndex:0];
        } else {
            [self.cards addObject:card];
        }
    }
}

-(Card *)drawRandomCard
{
    Card *randomCard=nil;
    if(self.cards.count){
        unsigned index=arc4random() % self.cards.count;
        randomCard=self.cards[index];
        [self.cards removeObjectAtIndex:index];        
    }
    return randomCard;
}

@end
