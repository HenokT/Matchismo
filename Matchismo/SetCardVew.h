//
//  SetCardVew.h
//  Matchismo
//
//  Created by Henok T on 9/7/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardVew : UIView

@property (nonatomic) NSUInteger number;
@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSString *shading;
@property (strong, nonatomic) NSString *color;
@property (nonatomic) BOOL faceUp;

@end