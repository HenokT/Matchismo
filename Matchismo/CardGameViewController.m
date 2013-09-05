//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Buta on 8/16/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "CardGameViewController.h"
#import "Deck.h"
#import "CardMatchingGame.h"
#import "FlipResult.h"

@interface CardGameViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UISlider *timeMachine;

@property (strong, nonatomic) CardMatchingGame *game;
@property (nonatomic) int flipCount;
@property (nonatomic) NSArray * playModes;

@end

@implementation CardGameViewController


-(CardMatchingGame *)game
{
    if(!_game) _game=[[CardMatchingGame  alloc]  initWithCardCount:self.startingCardCount
                                                              deck:[self createDeck]
                                                          numberOfCardsToMatch:self.numberOfCardsToMatch
                                                        matchBonus:self.matchBonus
                                                   mismatchPenalty:self.mismatchPenality];
    return _game;
}


-(NSUInteger) startingCardCount
{
    return self.cardButtons.count;
}

-(Deck *) createDeck { return nil; } //abstract


- (void)setCardButtons:(NSArray *)cardButtons{
    _cardButtons=cardButtons;
    [self  updateUI];
}

-(void)setResultLabel:(UILabel *)resultLabel
{
    _resultLabel=resultLabel;
    _resultLabel.text=@"";
}

- (void) updateUI
{
    //NSLog(@"[%@ updateUI", self.class);
    for(UIButton *cardButton in self.cardButtons)
    {
        Card * card=[self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [self updateCardButton:cardButton withCard:card];
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.resultLabel.attributedText = [self attributedDescriptionOfFlipResult:[self.game.flipResults lastObject]];
    self.resultLabel.alpha=1;
    //adjust the maximum value for the slider based on the flip result count
    if(self.game.flipResults.count + 2 > self.timeMachine.maximumValue){
        self.timeMachine.maximumValue += 2;
    }
    self.timeMachine.value=self.game.flipResults.count;
}

-(void)updateCardButton:(UIButton *)cardButton withCard:(Card *)card {} //abstract


- (NSAttributedString *) attributedDescriptionOfFlipResult:(FlipResult *) flipResult
{
    NSString * flipResultAsText=@"";
    if(flipResult){
        if(flipResult.points > 0){
            flipResultAsText= [NSString stringWithFormat:@"Matched %@ for %d points",[flipResult.cards componentsJoinedByString:@" & "], flipResult.points];
        }
        else if(flipResult.points < 0){
            flipResultAsText= [NSString stringWithFormat:@"%@ don't match! %d point penalty!",[flipResult.cards componentsJoinedByString:@" & "], flipResult.points];
        }
        else{
            Card *card=[flipResult.cards lastObject];
            flipResultAsText= [@"Flipped up " stringByAppendingString:card.contents];
        }
    }
    return [[NSAttributedString alloc] initWithString:flipResultAsText];
}


- (IBAction)flipCard:(UIButton *)sender {
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateUI];
}
     
- (void) setFlipCount:(int)flipCount
{
 _flipCount=flipCount;
 self.flipsLabel.text=[NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)deal:(UIButton *)sender {
    self.game = nil;
    self.flipCount = 0;
    [self updateUI];
}

- (IBAction)timeTravel:(UISlider *)sender {
    int flipResultIndex = sender.value;
    NSLog(@"Traveling to flipResult at index %d:",flipResultIndex);
    if(flipResultIndex < self.game.flipResults.count){
        self.resultLabel.attributedText=[self attributedDescriptionOfFlipResult:self.game.flipResults[flipResultIndex]];
        self.resultLabel.alpha=0.3;
    }
}

@end
