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
-(id)initWithCards:(NSArray *) cards AndPoints: (int) flipScore
{
    self=[super init];
    if(self){
        _cards=[cards copy];
        _points=flipScore;
    }
    return self;
}
@end

