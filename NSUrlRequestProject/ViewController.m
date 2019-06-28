//
//  ViewController.m
//  NSUrlRequestProject
//
//  Created by Alexey Levanov on 30.11.17.
//  Copyright © 2017 Alexey Levanov. All rights reserved.
//

#import "ViewController.h"
#import "NetworkService.h"
#import "SBSProgressView.h"
#import "FlickrCollectionViewCell.h"
#import "NetworkHelper.h"
#import "DetailViewController.h"


#define FIRST_STEP 0
#define SECOND_STEP 0
#define THIRD_STEP 0
#define FLICKR 1

static const CGFloat imageOffset = 100.f;

@interface ViewController () <NetworkServiceOutputProtocol, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIProgressView *progressView;
//@property (nonatomic, strong) SBSProgressView *sbsProgressView;
@property (nonatomic, strong) UIButton *cancelDownloadButton;
@property (nonatomic, strong) UIButton *resumeDownloadButton;
@property (nonatomic, strong) UILabel *isNotDataLoaded;

@property (nonatomic, strong) NetworkService *networkService;

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray<NSString *> *list;
@property (nonatomic, copy) NSString *searchText;
@property (nonatomic, assign) NSInteger indexPageLoaded;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.indexPageLoaded = 25;
    
#if FIRST_STEP
    // Простейший способ - STEP 1
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:@"https://itunes.apple.com/search?term=apple&media=software"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error)
        {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"%@", json);
        }
        else
        {
            NSLog(@"Error occured!");
        }
    }];
    
    [dataTask resume];
#endif
    
#if SECOND_STEP
    [self prepareUI];
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:[NSURL URLWithString:@"https://upload.wikimedia.org/wikipedia/commons/4/4e/Pleiades_large.jpg"]];
    // http://is1.mzstatic.com/image/thumb/Purple2/v4/91/59/e1/9159e1b3-f67c-6c05-0324-d56f4aee156a/source/100x100bb.jpg
    [downloadTask resume];
#endif
   
#if THIRD_STEP
    [self prepareUI];
    self.networkService = [NetworkService new];
    self.networkService.output = self;
    [self.networkService configureUrlSessionWithParams:nil];
    [self.networkService startImageLoading];
#endif
    
#if FLICKR
    [self prepareUIFlickr];
    self.networkService = [NetworkService new];
    self.networkService.output = self;
    [self.networkService configureUrlSessionWithParams:nil];
    
    self.networkService = [NetworkService new];
    self.networkService.output = self;
    
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"Введите ваш запрос";
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[FlickrCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    
//    [self.networkService findFlickrPhotoWithSearchString:@"Nature"];
#endif
    
    
    
}

- (void)prepareUI
{
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    self.imageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:self.imageView];
    
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.frame = CGRectMake(imageOffset, self.view.center.y - imageOffset/2, CGRectGetWidth(self.view.frame) - imageOffset*2, imageOffset);
    [self.view addSubview:self.progressView];
    
    // NEXT STEP
    self.resumeDownloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.resumeDownloadButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.resumeDownloadButton setTitle:@"Запустить" forState:UIControlStateNormal];
    [self.resumeDownloadButton addTarget:self action:@selector(resumeDownloadAction) forControlEvents:UIControlEventTouchUpInside];
    self.resumeDownloadButton.frame =CGRectMake(imageOffset, CGRectGetHeight(self.view.frame) - imageOffset * 2, imageOffset, imageOffset);
    self.resumeDownloadButton.hidden = YES;
    [self.view addSubview:self.resumeDownloadButton];

    self.cancelDownloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelDownloadButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.cancelDownloadButton setTitle:@"Остановить" forState:UIControlStateNormal];
    [self.cancelDownloadButton addTarget:self action:@selector(suspendDownLoadAction) forControlEvents:UIControlEventTouchUpInside];
    self.cancelDownloadButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 2*imageOffset, CGRectGetHeight(self.view.frame) - imageOffset * 2, imageOffset, imageOffset);
    [self.view addSubview:self.cancelDownloadButton];
}

- (void)prepareUIFlickr
{
    // создание SearchBar
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 50, CGRectGetWidth(self.view.frame), 50)];
    [self.view addSubview:self.searchBar];
    
    // создание CollectionView
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, self.searchBar.frame.origin.y + self.searchBar.frame.size.height + 10, CGRectGetWidth(self.view.frame) - 20, CGRectGetHeight(self.view.frame) - self.searchBar.frame.size.height - 50) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    self.isNotDataLoaded = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.collectionView.frame) / 2 - 100, CGRectGetHeight(self.collectionView.frame) / 2 - 15, 200, 30)];
    self.isNotDataLoaded.textColor = [UIColor blackColor];
    self.isNotDataLoaded.textAlignment = NSTextAlignmentCenter;
    self.isNotDataLoaded.text = @"Ничего не найдено";
    
    [self.view addSubview:self.isNotDataLoaded];
    [self.isNotDataLoaded setHidden:YES];
}

// STEP 3
- (NSURLSession *)configuredNSURLSession
{
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // Настравиваем Session Configuration
    [sessionConfiguration setAllowsCellularAccess:YES];
    [sessionConfiguration setHTTPAdditionalHeaders:@{ @"Accept" : @"application/json" }];
    
    // Создаем сессию
    return [NSURLSession sessionWithConfiguration:sessionConfiguration];
}

- (void)resumeDownloadAction
{
    if ([self.networkService resumeNetworkLoading])
    {
        self.resumeDownloadButton.hidden = YES;
        self.cancelDownloadButton.hidden = NO;
    }
}

- (void)suspendDownLoadAction
{
    [self.networkService suspendNetworkLoading];
    self.resumeDownloadButton.hidden = NO;
    self.cancelDownloadButton.hidden = YES;
}

// STEP 2
#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSData *data = [NSData dataWithContentsOfURL:location];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressView.hidden = YES;
        self.cancelDownloadButton.hidden = YES;
        self.resumeDownloadButton.hidden = YES;
        self.imageView.image = [UIImage imageWithData:data];
    });
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    double progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.progressView setProgress:progress animated:true];
    });
}


#pragma mark - NetworkServiceOutput

- (void)loadingIsDoneWithDataRecieved:(NSData *)dataRecieved
{
    [self.progressView setHidden:YES];
    self.cancelDownloadButton.hidden = YES;
    self.resumeDownloadButton.hidden = YES;
    [self.imageView setImage:[UIImage imageWithData:dataRecieved]];
}

- (void)loadingIsDonePhoto:(NSDictionary *)data
{
        self.list = data[@"photo"];
        [self.collectionView reloadData];
}

- (void)loadingContinuesWithProgress:(double)progress
{
    self.progressView.progress = progress;
}

// delegates

//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//    NSString *searchedText = searchBar.text;
//
//    [self.networkService findFlickrPhotoWithSearchString:searchedText];
//
//    [searchBar resignFirstResponder];
//}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.searchText = searchText;
    [self.networkService findFlickrPhotoWithSearchString:searchText page:[NSString stringWithFormat:@"%ld",self.indexPageLoaded]];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.list != nil)
    {
        [self.collectionView setHidden:NO];
        [self.isNotDataLoaded setHidden:YES];
    } else
    {
        [self.collectionView setHidden:YES];
        [self.isNotDataLoaded setHidden:NO];
    }
    
    return self.list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FlickrCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    
    NSDictionary *photo = self.list[indexPath.row];
    
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
    if (indexPath.row == ([self.list count] - 1))
    {
        self.indexPageLoaded += 25;
        NSString *pageNumber = [NSString stringWithFormat:@"%ld",self.indexPageLoaded];
        [self loadNextPage:pageNumber];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailVC = [DetailViewController new];
    
    NSDictionary *detailPhoto = self.list[indexPath.row];
    
    detailVC.data = detailPhoto;
    
    [self presentViewController:detailVC animated:true completion:nil];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat size = CGRectGetWidth(self.view.frame) / 2 - 20;
    return CGSizeMake(size, size * 1.5);
}
     
- (void) loadNextPage:(NSString *)pageNumber
{
    [self.networkService findFlickrPhotoWithSearchString:self.searchText page:pageNumber];
}

@end
