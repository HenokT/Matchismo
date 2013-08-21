//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Buta on 8/16/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSwitch;

@property (strong, nonatomic) CardMatchingGame *game;
@property (nonatomic) int flipCount;
@property (nonatomic) NSArray * gameModes;

@end


@implementation CardGameViewController

-(CardMatchingGame *)game
{
    if(!_game) _game=[[CardMatchingGame  alloc]  initWithCardCount:self.cardButtons.count
                                                         usingDeck:[[PlayingCardDeck alloc] init]];
    return _game;
}

-(NSArray *)gameModes{
    if(!_gameModes) _gameModes=@[[NSNumber  numberWithInt:twoCardMatch],[NSNumber numberWithInt:threeCardMatch]];
    return _gameModes;
}

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
    for(UIButton *cardButton in self.cardButtons)
    {
        Card * card=[self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton  setTitle:card.contents
                     forState:UIControlStateSelected];
        [cardButton  setTitle:card.contents
                     forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected=card.isFaceUp;
        cardButton.enabled=!card.isUnplayable;
        cardButton.alpha=card.isUnplayable ? 0.3 : 1;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.resultLabel.text = self.game.lastFlipResult;
}


- (IBAction)flipCard:(UIButton *)sender {
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateUI];
    self.modeSwitch.enabled=false;
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
    self.modeSwitch.enabled=true;
}

- (IBAction)switchMode:(UISegmentedControl *)sender {
   
    if(sender.selectedSegmentIndex < self.gameModes.count){
        self.game.mode=[self.gameModes[sender.selectedSegmentIndex] intValue];
    }
    NSLog(@"Switching Mode to %d", self.game.mode);
}

@end
