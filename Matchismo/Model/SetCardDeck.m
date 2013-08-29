//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Henok T on 8/26/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

-(id)init
{
    self=[super init];
    
    if(self){
        for(NSNumber *number in [SetCard validNumbers]){
            for(NSString *symbol in [SetCard validSymbols]){
                for(NSString *shading in [SetCard validShadings]){
                    for (NSString *color in [SetCard validColors]) {
                        SetCard *card = [[SetCard alloc] init];
                        card.number = number.intValue;
                        card.symbol = symbol;
                        card.shading = shading;
                        card.color = color;
                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
    }
    return self;
}
@end
