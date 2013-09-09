//
//  PlayingCard.m
//  Matchismo
//
//  Created by Buta on 8/16/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "PlayingCard.h"

@interface PlayingCard ()

@end

@implementation PlayingCard

@synthesize suit = _suit;

+(NSArray *) rankStrings
{
    return @[@"?", @"A", @"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+(NSUInteger)maxRank
{
    return [self rankStrings].count-1;
}

+(NSArray *) validSuits
{
    return @[@"♥",@"♦",@"♠",@"♣"];
}

-(int)match:(NSArray *)otherCards
{
    int score=0;
    
    for(Card *otherCard in otherCards){
        if([otherCard isKindOfClass:[self class]]){
            PlayingCard * otherPlayingCard=(PlayingCard *) otherCard;
            if([otherPlayingCard.suit isEqualToString:self.suit]){
                score += 1;
            }
            else if(otherPlayingCard.rank == self.rank){
                score += 4;
            }
        }
    }
    return score;
}

-(NSString *)contents
{
    return [[PlayingCard rankStrings][self.rank] stringByAppendingString:self.suit];
}

-(NSString *)suit
{
    return _suit ? _suit : @"?";
}

-(void)setSuit:(NSString *)suit
{
    if([[PlayingCard validSuits] containsObject:suit]){
        _suit=suit;
    }
}

-(void)setRank:(NSUInteger)rank
{
    if(rank <= [PlayingCard maxRank]){
        _rank = rank;
    }
}

//Implement isEqual

@end