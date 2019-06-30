//
//  ViewMain.m
//  NSUrlRequestProject
//
//  Created by Vladimir Ereskin on 29/06/2019.
//  Copyright © 2019 Alexey Levanov. All rights reserved.
//

#import "ViewMain.h"

#import "ViewModelMain.h"
#import "ModelMain.h"

#import "CustomLayout.h"
#import "ViewDetail.h"
#import "ViewModelDetail.h"

#import "FlickrCollectionViewCell.h"

#import "NetworkHelper.h"
#import "NetworkService.h"

@import UserNotifications;

static NSString * const identifierForActions = @"LCTReminderCategory";

@interface ViewMain () <NetworkServiceOutputProtocol, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
{
    CustomLayout *customLayout;
    UICollectionViewFlowLayout *flowLayout;
}

@property (strong, nonatomic) ViewModelMain *viewModel;
@property (nonatomic, strong) NetworkService *networkService;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UILabel *isNotDataLoaded;
@property (nonatomic, strong) UISegmentedControl *layoutSegmentControl;
@property (nonatomic, strong) UITableView *tableViewSearchHistory;

@property (nonatomic, assign) NSInteger pagesLoading;
@property (nonatomic, copy) NSString *searchText;
@property (nonatomic, strong) NSMutableArray *arraySearchedToSave;
@property (nonatomic, strong) NSMutableArray *arraySearchedToSavePredicate;
@property (nonatomic, assign) Boolean isSearched;

@end

@implementation ViewMain


#pragma mark - Life cyckle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareUIFlickr];
    
    self.viewModel = [ViewModelMain sharedInstanceWithViewController:self];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    // наблюдатель за изменениями данных
    [self.viewModel.model addObserver:self forKeyPath:@"dataMainDictionary" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    ;
    
    self.networkService = [NetworkService new];
    self.networkService.output = self;
    
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"Введите ваш запрос";
    self.searchBar.text = self.searchText;
    
    [self.collectionView registerClass:[FlickrCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    
    flowLayout = (id)self.collectionView.collectionViewLayout;
    
    self.pagesLoading = 25;
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [self loadSearchHystory];
    
    self.isSearched = false;
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.viewModel.model removeObserver:self forKeyPath:@"dataMainDictionary"];
}


#pragma mark - CreateUI

- (void)prepareUIFlickr
{
    
    // создание SearchBar
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 50, CGRectGetWidth(self.view.frame), 50)];
    [self.view addSubview:self.searchBar];
    
    // создание переключателя Flow/Custom layout
    self.layoutSegmentControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) / 2 - 100, CGRectGetHeight(self.searchBar.frame) + 60, 200, 40)];
    [self.layoutSegmentControl insertSegmentWithTitle:@"Flow" atIndex:0 animated:YES];
    [self.layoutSegmentControl insertSegmentWithTitle:@"Custom" atIndex:1 animated:NO];
    [self.layoutSegmentControl setSelectedSegmentIndex:0];
    [self.layoutSegmentControl addTarget:self action:@selector(changeSelectedSegmentControl) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.layoutSegmentControl];
    
    // создание CollectionView
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.layoutSegmentControl.frame) + 10, CGRectGetWidth(self.view.frame) - 20, CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.layoutSegmentControl.frame) - self.searchBar.frame.size.height - 50 - 60) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    [self.view addSubview:self.collectionView];
    
    // создание метки для отображения информации если нет данных
    self.isNotDataLoaded = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) / 2 - 100, CGRectGetHeight(self.view.frame) / 2 - 15, 200, 30)];
    self.isNotDataLoaded.textColor = [UIColor blackColor];
    self.isNotDataLoaded.textAlignment = NSTextAlignmentCenter;
    self.isNotDataLoaded.text = @"Ничего не найдено";
    
    [self.view addSubview:self.isNotDataLoaded];
    [self.isNotDataLoaded setHidden:YES];
    
    // Custom Layout
    customLayout = [CustomLayout new];
    customLayout.cellSize = CGSizeMake(CGRectGetWidth(self.collectionView.frame) / 2 - 20, (CGRectGetWidth(self.collectionView.frame) / 2 - 20) * 1.5);
    customLayout.sectionSpacing = CGSizeMake(10, 10);
}


#pragma mark - скрытие клавиатуры

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self.view endEditing:YES];
    [self hideTableViewSearchHistory];
}


#pragma mark - SearchBar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchedText = searchBar.text;
    [self updateSearchHistory:searchedText];
    [searchBar resignFirstResponder];
    [self hideTableViewSearchHistory];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.searchText = searchText;
    
    if ([searchText length] == 0)
    {
        self.isSearched = NO;
    }
    else
    {
        self.isSearched = YES;
    }
    
    [self.viewModel getData:searchText pagesLoading:[NSString stringWithFormat:@"%ld",self.pagesLoading]];
    
    [self filterSearchArray];
    
    [self updateTableViewSearchFrame];
    
    [self.tableViewSearchHistory reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self presentHistorySearch];
}


#pragma mark - CollectionView delegate/dataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.dataMain != nil && self.dataMain.count != 0)
    {
        [self.collectionView setHidden:NO];
        [self.isNotDataLoaded setHidden:YES];
    }
    else
    {
        [self.collectionView setHidden:YES];
        [self.isNotDataLoaded setHidden:NO];
    }
    
    return self.dataMain.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FlickrCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    
    NSDictionary *photo = (NSDictionary *)self.dataMain[indexPath.row];
    
    NSString *urlString = [NetworkHelper URLForGetPhoto:photo[@"id"]
                                                 farmId:photo[@"farm"]
                                               serverId:photo[@"server"]
                                               secretId:photo[@"secret"]];
    
    cell.isActivity = YES;
    [self.networkService startImageLoading:urlString success:^(NSData *data) {
        if (data != nil)
        {
            cell.coverImage = [UIImage imageWithData:data];
            cell.isActivity = NO;
        }
    }];
    
    cell.title = photo[@"title"];
    
    // загрузка следующей страницы
    if (indexPath.row == ([self.dataMain count] - 1))
    {
        self.pagesLoading += 25;
        NSString *pageNumber = [NSString stringWithFormat:@"%ld",self.pagesLoading];
        [self loadNextPage:pageNumber];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *detailPhoto = self.dataMain[indexPath.row].mutableCopy;

    FlickrCollectionViewCell *cell = (FlickrCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.coverImage != nil)
    {
        [detailPhoto setObject:UIImagePNGRepresentation(cell.coverImage)  forKey:@"selectedImage"];
    }
    
    ViewDetail *viewDetail = [ViewDetail new];
    ViewModelDetail *viewModel = [ViewModelDetail sharedInstanceWithViewController: viewDetail];
    [viewModel setData:detailPhoto];
    
    [self presentViewController:viewDetail animated:YES completion:nil];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat size = CGRectGetWidth(self.view.frame) / 2 - 20;
    return CGSizeMake(size, size * 1.5);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self hideTableViewSearchHistory];
}


#pragma mark - observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSDictionary *newData = [change objectForKey:@"new"];
    
    if ([NSNull null] != (NSNull *)newData)
    {
        self.dataMain = (NSArray *) newData;
    }
    else
    {
        self.dataMain = [[NSArray alloc] init];
    }

    [self.collectionView reloadData];
}


#pragma mark - TableView DataSource/Delegate

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSMutableArray *arraySearch = self.arraySearchedToSave;
    if (self.isSearched)
    {
        arraySearch = self.arraySearchedToSavePredicate;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = arraySearch[indexPath.row];
    cell.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSMutableArray *arraySearch = self.arraySearchedToSave;
    if (self.isSearched)
    {
        arraySearch = self.arraySearchedToSavePredicate;
    }
    
    return arraySearch.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *arraySearch = self.arraySearchedToSave;
    if (self.isSearched)
    {
        arraySearch = self.arraySearchedToSavePredicate;
    }
    
    [self setPushSearchText:arraySearch[indexPath.row]];
    [self.searchBar resignFirstResponder];
    [self hideTableViewSearchHistory];
}


#pragma mark - User Methods

- (void) loadNextPage:(NSString *)pageNumber
{
    [self.viewModel getData:self.searchText pagesLoading:pageNumber];
}

- (void)changeSelectedSegmentControl
{
    if (self.layoutSegmentControl.selectedSegmentIndex == 0) {
        [self.collectionView setCollectionViewLayout:flowLayout animated:YES];
    }
    else
    {
        [self.collectionView setCollectionViewLayout:customLayout animated:YES];
    }
}

- (void)setPushSearchText:(NSString *)pushSearchText
{
    self.searchText = pushSearchText;
    [self.searchBar setText:pushSearchText];
    
    [self.viewModel getData:self.searchText pagesLoading:[NSString stringWithFormat:@"%ld",self.pagesLoading]];
}

- (void)loadSearchHystory
{
    NSArray *searchHystory = [[NSUserDefaults standardUserDefaults] arrayForKey:@"searchHistory"];
    self.arraySearchedToSave = searchHystory ? searchHystory.mutableCopy : [NSMutableArray new];
}

- (void)updateSearchHistory:(NSString *)searchString
{
    [self.arraySearchedToSave insertObject:searchString atIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:self.arraySearchedToSave forKey:@"searchHistory"];
}

- (void)presentHistorySearch
{
    self.tableViewSearchHistory = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), CGRectGetWidth(self.view.frame), 0) style:UITableViewStylePlain];
    self.tableViewSearchHistory.delegate = self;
    self.tableViewSearchHistory.dataSource = self;
    
    [self filterSearchArray];
    
    [self updateTableViewSearchFrame];
    
    [self.view addSubview:self.tableViewSearchHistory];
}

- (void)hideTableViewSearchHistory
{
    __block CGRect frame = self.tableViewSearchHistory.frame;
    frame.size.height = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.tableViewSearchHistory.frame = frame;
    } completion:^(BOOL finished) {
        [self.tableViewSearchHistory removeFromSuperview];
    }];
}

- (void)updateTableViewSearchFrame
{
    __block CGRect frame = self.tableViewSearchHistory.frame;
    
    if (self.isSearched)
    {
        frame.size.height = self.arraySearchedToSavePredicate.count < 4 ? self.arraySearchedToSavePredicate.count * 45 : 4 * 45;
    }
    else
    {
        frame.size.height = self.arraySearchedToSave.count < 4 ? self.arraySearchedToSavePredicate.count * 45 : 4 * 45;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.tableViewSearchHistory.frame = frame;
    }];
}

- (void)filterSearchArray
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@",self.searchText];
    self.arraySearchedToSavePredicate = [self.arraySearchedToSave filteredArrayUsingPredicate:predicate].copy;
}


#pragma mark - LocalNotifications

- (void)sheduleLocalNotification
{
    /* Контент - сущность класса UNMutableNotificationContent
     Содержит в себе:
     title: Заголовок, обычно с основной причиной показа пуша
     subtitle: Подзаговолок, не обязателен
     body: Тело пуша
     badge: Номер бейджа для указания на иконке приложения
     sound: Звук, с которым покажется push при доставке. Можно использовать default или установить свой из файла.
     launchImageName: имя изображения, которое стоит показать, если приложение запущено по тапу на notification.
     userInfo: Кастомный словарь с данными
     attachments: Массив UNNotificationAttachment. Используется для включения аудио, видео или графического контента.
     */
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    content.title = @"Напоминание!";
    content.body = [NSString stringWithFormat:@"Вы давно не искали: %@",self.searchText];
    content.sound = [UNNotificationSound defaultSound];
    
    content.badge = @([self giveNewBadgeNumber] + 1);
    
    //    //  Добавляем кастомный attachement
    //    UNNotificationAttachment *attachment = [self imageAttachment];
    //    if (attachment)
    //    {
    //        content.attachments = @[attachment];
    //    }
    
    NSDictionary *dict = @{
                           @"text": self.searchText
                           };
    content.userInfo = dict;
    
    // Добавляем кастомную категорию
    content.categoryIdentifier = identifierForActions;
    
    // Смотрим разные варианты триггеров
    UNNotificationTrigger *whateverTrigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
    
    // Создаем запрос на выполнение
    // Objective-C
    NSString *identifier = @"NotificationId";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier
                                                                          content:content trigger:whateverTrigger];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error)
     {
         if (error)
         {
             NSLog(@"Чот пошло не так... %@",error);
         }
     }];
}


#pragma mark - ContentType

- (NSInteger)giveNewBadgeNumber
{
    return [UIApplication sharedApplication].applicationIconBadgeNumber;
}


@end
