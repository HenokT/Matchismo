//
//  Card.m
//  Matchismo
//
//  Created by Buta on 8/16/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "Card.h"

@implementation Card

-(int) match:(NSArray *)otherCards
{
    int score=0;

    for(Card * otherCard in otherCards){
        if([otherCard.contents isEqualToString:self.contents]){
            score=1;
        }
    }
    
    return score;
}

-(NSString *)description
{
    return self.contents;
}

@end
