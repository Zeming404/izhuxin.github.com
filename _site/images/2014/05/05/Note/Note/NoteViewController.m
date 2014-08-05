//
//  NoteViewController.m
//  Note
//
//  Created by Jeason on 14-4-12.
//  Copyright (c) 2014年 Jeason. All rights reserved.
//

#import "NoteViewController.h"
#import "Note.h"
//0
static const int statusBarHeight = 20;
static const int dateFontSize = 10;
static const int buttonSize = 30;
static const int inset = 10;
static const int navigationHeight = 44;

@interface NoteViewController ()<UITextViewDelegate>
@property (nonatomic, strong) UITextView *textView;
@end

@implementation NoteViewController

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    //1
    CGRect labelFrame = CGRectMake(0,statusBarHeight + navigationHeight + inset,self.view.frame.size.width,inset);
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:labelFrame];
    dateLabel.font = [UIFont systemFontOfSize:dateFontSize];
    dateLabel.text = [formatter stringFromDate:_note.timestamp];
    dateLabel.textColor = [UIColor grayColor];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:dateLabel];
    
    //2
    CGRect textFrame = CGRectMake(inset,//x
                                  inset*2 + statusBarHeight + navigationHeight,//y
                                  self.view.frame.size.width,//width
                                  self.view.frame.size.height-inset*2-statusBarHeight-buttonSize);
    self.textView = [[UITextView alloc] initWithFrame:textFrame];
    _textView.scrollEnabled = YES;
    _textView.delegate = self;
    _textView.text = _note.contents;
    [self.view addSubview:_textView];
    
    //3
    CGRect buttonFrame = CGRectMake(inset, self.view.frame.size.height - buttonSize - inset, buttonSize, buttonSize);
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    
    [button setImage:[UIImage imageNamed:@"share-.jpg"]
            forState:UIControlStateNormal];
    
    [button addTarget:self
               action:@selector(pressShare:)
     forControlEvents:UIControlEventTouchDragInside];
    [self.view addSubview:button];

    //4
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    
    //5
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -TextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    // TODO: save note to db
    _note.contents = _textView.text;
    self.navigationItem.rightBarButtonItem = nil;
}


- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)done:(id)sender {
    [_textView resignFirstResponder];
}

- (void)pressShare: (id)sender {
    //4
    NSLog(@"press share btn!");
}


@end
