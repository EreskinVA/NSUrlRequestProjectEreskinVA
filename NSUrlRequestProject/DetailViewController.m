//
//  DetailViewController.m
//  NSUrlRequestProject
//
//  Created by Vladimir Ereskin on 28/06/2019.
//  Copyright © 2019 Alexey Levanov. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (nonatomic, strong) NSDictionary* detailData;
@property (nonatomic, strong) UITextView* textView;

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareUI];
    
    [self setDisplayData];
}

- (void)prepareUI
{
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 60, CGRectGetWidth(self.view.frame) - 20, 400)];
    self.textView.textColor = [UIColor blackColor];
    [self.textView setEditable:NO];
    [self.view addSubview:self.textView];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addBackButton];
}

- (void) setDisplayData
{
    NSString *dataString = [NSString stringWithFormat:@"farm - %@\nid - %@\nisfamily - %@\nisfriend - %@\nispublic - %@\nowner - %@\nsecret - %@\nserver - %@\n\ntitle - %@",
                            self.detailData[@"farm"],
                            self.detailData[@"id"],
                            self.detailData[@"isfamily"],
                            self.detailData[@"isfriend"],
                            self.detailData[@"ispublic"],
                            self.detailData[@"owner"],
                            self.detailData[@"secret"],
                            self.detailData[@"server"],
                            self.detailData[@"title"]];
    
    
    self.textView.text = dataString;
}

- (void) addBackButton
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) / 2 - 40, CGRectGetHeight(self.view.frame) / 2 + 200, 80, 40)];
    [backButton setTitle:@"Закрыть" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(navigateBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.view addSubview:backButton];
}

- (void) navigateBack
{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)setData:(NSDictionary *)data
{
    self.detailData = data;
}

@end
