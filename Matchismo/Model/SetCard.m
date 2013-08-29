//
//  SetCard.m
//  Matchismo
//
//  Created by Henok T on 8/25/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

+(NSArray *) validNumbers
{
    return @[@(1), @(2), @(3)];
}

+(NSArray *) validSymbols
{
    return @[@"▲", @"●", @"■"];
}

+(NSArray *) validShadings
{
    return @[@"solid", @"striped", @"open"];
}

+(NSArray *) validColors
{
    return @[@"red", @"green", @"purple"];
}


-(int)match:(NSArray *)otherCards
{
    int score = 0;
    if(otherCards.count == 2){
        SetCard *otherCard1=otherCards[0];
        SetCard *otherCard2=otherCards[1];
        BOOL numbersOk = (self.number == otherCard1.number && self.number == otherCard2.number) || (self.number != otherCard1.number && self.number != otherCard2.number);
        BOOL symbolsOk = ([self.symbol isEqualToString:otherCard1.symbol] && [self.symbol isEqualToString:otherCard2.symbol]) ||(![self.symbol isEqualToString:otherCard1.symbol] && ![self.symbol isEqualToString:otherCard2.symbol]);
        
        BOOL shadingsOk = ([self.shading isEqualToString:otherCard1.shading] && [self.shading isEqualToString:otherCard2.shading]) ||(![self.shading isEqualToString:otherCard1.shading] && ![self.shading isEqualToString:otherCard2.shading]);
        
        BOOL colorsOk =([self.color isEqualToString:otherCard1.color] && [self.color isEqualToString:otherCard2.color]) ||(![self.color isEqualToString:otherCard1.color] && ![self.color isEqualToString:otherCard2.color]);
        if(numbersOk && symbolsOk && shadingsOk && colorsOk){
            score = 4;
        }
    }
    return score;
}

-(NSString *)contents
{
    return [NSString stringWithFormat:@"%d %@ %@ %@", self.number, self.color , self.shading, self.symbol];
}

-(void)setNumber:(NSUInteger)number
{
    if([[self.class validNumbers] containsObject:@(number)]){
        _number = number;
    }
}

-(void)setSymbol:(NSString *)symbol
{
    if ([[[self class] validSymbols] containsObject:symbol]) {
        _symbol = symbol;
    }
}

-(void)setShading:(NSString *)shading
{
    if ([[[self class] validShadings] containsObject:shading]) {
        _shading = shading;
    }
}

-(void)setColor:(NSString *)color
{
    if ([[[self class] validColors] containsObject:color]) {
        _color = color;
    }
}
@end
