//
//  NoteListViewController.m
//  Note
//
//  Created by Jeason on 14-4-19.
//  Copyright (c) 2014年 Jeason. All rights reserved.
//

#import "NoteListViewController.h"
#import "NoteAppDelegate.h"
#import "Note.h"
#import "NoteViewController.h"

@interface NoteListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) NSMutableArray *listArray;
@end

@implementation NoteListViewController

- (NSMutableArray *)listArray {
    NoteAppDelegate *delegate = (NoteAppDelegate *)[[UIApplication sharedApplication] delegate];
    return delegate.notes;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark -UIViewController Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.listTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _listTableView.dataSource = self;
    _listTableView.delegate = self;
    
    [self.view addSubview:_listTableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"新建" style:UIBarButtonItemStyleDone target:self action:@selector(createNewNote:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [_listTableView reloadData];
}

- (void)createNewNote:(id)sender {
    NoteViewController *noteViewController = [NoteViewController new];
    noteViewController.note = [Note noteWithText:@"" NoteID:[self.listArray count] + 1];
    [self.listArray addObject:noteViewController.note];
    [self.navigationController pushViewController:noteViewController animated:YES];
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    Note* note = self.listArray[indexPath.row];
    cell.textLabel.text = note.title;
    return cell;
}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NoteViewController *noteViewController = [[NoteViewController alloc] init];
    noteViewController.note = self.listArray[indexPath.row];
    [self.navigationController pushViewController:noteViewController animated:YES];
}

@end
