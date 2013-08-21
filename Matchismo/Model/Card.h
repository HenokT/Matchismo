//
//  Card.h
//  Matchismo
//
//  Created by Buta on 8/16/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property(strong,nonatomic) NSString *contents;
@property(nonatomic, getter = isFaceUp ) BOOL faceUp;
@property(nonatomic, getter = isUnplayable) BOOL unblayable;

-(int) match: (NSArray *) otherCards;

@end
