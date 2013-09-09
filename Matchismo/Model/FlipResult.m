//
//  FlipResult.m
//  Matchismo
//
//  Created by Henok T on 8/25/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "FlipResult.h"

@implementation FlipResult

//designated initializer
-(id)initWithCardsInvolved:(NSArray *) cardsInvolved forPoints: (int) points
{
    self=[super init];
    if(self){
        _cardsInvolved=[cardsInvolved copy];
        _points=points;
    }
    return self;
}
@end

