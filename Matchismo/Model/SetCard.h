//
//  SetCard.h
//  Matchismo
//
//  Created by Henok T on 8/25/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card
@property (nonatomic) NSUInteger number;
@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSString *shading;
@property (strong, nonatomic) NSString *color;

+(NSArray *) validNumbers;
+(NSArray *) validSymbols;
+(NSArray *) validShadings;
+(NSArray *) validColors;
@end
