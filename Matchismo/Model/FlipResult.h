//
//  FlipResult.h
//  Matchismo
//
//  Created by Henok T on 8/25/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlipResult : NSObject
@property (strong, nonatomic, readonly) NSArray * cards;
@property (nonatomic, readonly) int points;

//designated initializer
-(id)initWithCards:(NSArray *) cards AndPoints: (int) flipScore;
@end
