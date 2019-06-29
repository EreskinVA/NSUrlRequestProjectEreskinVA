//
//  ViewDetail.m
//  NSUrlRequestProject
//
//  Created by Vladimir Ereskin on 29/06/2019.
//  Copyright © 2019 Alexey Levanov. All rights reserved.
//

#import "ViewDetail.h"
#import "ViewModelDetail.h"
#import "ModelDetail.h"

static NSString * const keyPathForData = @"dataDetailDictionary";
static const CGFloat buttonSpacing = 10.f;
static const CGFloat buttonHeight = 30;
static const CGFloat buttonWidth = 30.f;

@interface ViewDetail ()

@property (strong, nonatomic) ViewModelDetail *viewModel;

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, retain) NSMutableArray<UIImage *> *arrayImages;

@end

@implementation ViewDetail


#pragma mark - Life cyckle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.viewModel = [ViewModelDetail sharedInstanceWithViewController: self];
    
    [self createUI];

    // наблюдатель за изменениями данных
    [self.viewModel.model addObserver:self forKeyPath:keyPathForData options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    
    self.arrayImages = [[NSMutableArray alloc] init];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // удаление наблюдателя
    [self.viewModel.model removeObserver:self forKeyPath:keyPathForData];
}


#pragma mark - обновление интерфейса

- (void)updateDisplay
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *dataString = [NSString stringWithFormat:@"farm - %@\nid - %@\nisfamily - %@\nisfriend - %@\nispublic - %@\nowner - %@\nsecret - %@\nserver - %@\n\ntitle - %@",
                                self.data[@"farm"],
                                self.data[@"id"],
                                self.data[@"isfamily"],
                                self.data[@"isfriend"],
                                self.data[@"ispublic"],
                                self.data[@"owner"],
                                self.data[@"secret"],
                                self.data[@"server"],
                                self.data[@"title"]];
        
        self.textView.text = dataString;
        self.imageView.image = [UIImage imageWithData:self.data[@"selectedImage"]];
    });
}


#pragma mark - observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    self.data = [change objectForKey:@"new"];
    [self updateDisplay];
}


#pragma mark - создание интерфейса

- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addTextView];
    [self addBackButton];
    [self addImageView];
    [self addFilterButton];
    [self addCancelFilterEffectButton];
}

// добавление View для отображения детальной информации по данным
- (void)addTextView
{
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 60, CGRectGetWidth(self.view.frame) - 20, 250)];
    self.textView.textColor = [UIColor blackColor];
    [self.textView setEditable:NO];
    
    [self.view addSubview:self.textView];
}

// добавление кнопки Закрыть
- (void) addBackButton
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) / 2 - 40, CGRectGetHeight(self.view.frame) - 120, 80, 40)];
    [backButton setTitle:@"Закрыть" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(navigateBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.view addSubview:backButton];
}

// добавление кнопки отмена последнего эффекта
- (void) addCancelFilterEffectButton
{
    UIButton *cancelFilterEffect = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) / 2 - 60, CGRectGetMaxY(self.imageView.frame) + buttonSpacing, 120, 40)];
    [cancelFilterEffect setTitle:@"Отменить" forState:UIControlStateNormal];
    [cancelFilterEffect addTarget:self action:@selector(сancelFilterEffect) forControlEvents:UIControlEventTouchUpInside];
    [cancelFilterEffect setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.view addSubview:cancelFilterEffect];
}

// добавление кнопок применения различных фильтров
- (void) addFilterButton
{
    UIButton *filter1Button = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame) + buttonSpacing, CGRectGetMidY(self.imageView.frame) - buttonSpacing - buttonHeight * 1.5, buttonWidth, buttonHeight)];
    [filter1Button setTitle:@"1" forState:UIControlStateNormal];
    [filter1Button addTarget:self action:@selector(setFilterImageButton1) forControlEvents:UIControlEventTouchUpInside];
    [filter1Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    filter1Button.layer.cornerRadius = CGRectGetWidth(filter1Button.frame) / 2;
    filter1Button.layer.masksToBounds = YES;
    filter1Button.backgroundColor = [UIColor blueColor];
    
    
    [self.view addSubview:filter1Button];
    
    UIButton *filter2Button = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame) + buttonSpacing, CGRectGetMaxY(filter1Button.frame) + buttonSpacing, buttonWidth, buttonHeight)];
    [filter2Button setTitle:@"2" forState:UIControlStateNormal];
    [filter2Button addTarget:self action:@selector(setFilterImageButton2) forControlEvents:UIControlEventTouchUpInside];
    [filter2Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    filter2Button.layer.cornerRadius = CGRectGetWidth(filter1Button.frame) / 2;
    filter2Button.layer.masksToBounds = YES;
    filter2Button.backgroundColor = [UIColor blueColor];
    
    
    [self.view addSubview:filter2Button];
    
    UIButton *filter3Button = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame) + buttonSpacing, CGRectGetMaxY(filter2Button.frame) + buttonSpacing, buttonWidth, buttonHeight)];
    [filter3Button setTitle:@"3" forState:UIControlStateNormal];
    [filter3Button addTarget:self action:@selector(setFilterImageButton3) forControlEvents:UIControlEventTouchUpInside];
    [filter3Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    filter3Button.layer.cornerRadius = CGRectGetWidth(filter1Button.frame) / 2;
    filter3Button.layer.masksToBounds = YES;
    filter3Button.backgroundColor = [UIColor blueColor];
    
    
    [self.view addSubview:filter3Button];
}

// добавление View для отображения картинки
- (void) addImageView
{
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(self.textView.frame) + 50, CGRectGetWidth(self.view.frame) - 100, 350)];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    [self.view addSubview:self.imageView];
}


#pragma mark - Image Filtering

- (void) setFilterImageButton1
{
    [self setFilterImage:[NSNumber numberWithInt:1]];
}

- (void) setFilterImageButton2
{
    [self setFilterImage:[NSNumber numberWithInt:2]];
}

- (void) setFilterImageButton3
{
    [self setFilterImage:[NSNumber numberWithInt:3]];
}

- (void) setFilterImage:(NSNumber *)buttonNumber
{
    [self.arrayImages addObject:self.imageView.image];
    
    NSNumber *intensity = [NSNumber numberWithInt:40];
    self.imageView.image = [self imageAfterFiltering:self.imageView.image withIntensity:intensity forButton:buttonNumber];
}

- (void)сancelFilterEffect
{
    if (self.arrayImages.count != 0)
    {
        [self.imageView setImage:self.arrayImages.lastObject];
        [self.arrayImages removeObject:self.arrayImages.lastObject];
    }
}

- (UIImage *)imageAfterFiltering:(UIImage *)imageToFilter withIntensity: (NSNumber *) intensity forButton:(NSNumber *)buttonNumber
{
    UIImage *imageToDisplay = [self normalizedImageWithImage:imageToFilter];
    
    CIContext *context = [[CIContext alloc] initWithOptions:nil];
    CIImage *ciImage = [[CIImage alloc] initWithImage:imageToDisplay];
    
    CIImage *result = [CIImage new];
    
    if (buttonNumber == [NSNumber numberWithInt:1])
    {
        CIFilter *ciEdges = [CIFilter filterWithName:@"CISepiaTone"];
        [ciEdges setValue:ciImage forKey:kCIInputImageKey];
        [ciEdges setValue:intensity forKey:@"inputIntensity"];
        result = [ciEdges valueForKey:kCIOutputImageKey];
    }
    
    if (buttonNumber == [NSNumber numberWithInt:2])
    {
        CIFilter *ciEdges = [CIFilter filterWithName:@"CIPhotoEffectMono"];
        [ciEdges setValue:ciImage forKey:kCIInputImageKey];
        result = [ciEdges valueForKey:kCIOutputImageKey];
    }
    
    if (buttonNumber == [NSNumber numberWithInt:3])
    {
        CIFilter *ciEdges = [CIFilter filterWithName:@"CIColorInvert"];
        [ciEdges setValue:ciImage forKey:kCIInputImageKey];
        result = [ciEdges valueForKey:kCIOutputImageKey];
    }
    
    CGRect extent = [result extent];
    CGImageRef cgImage = [context createCGImage:result fromRect:extent];
    UIImage *filteredImage = [[UIImage alloc] initWithCGImage:cgImage];
    CFRelease(cgImage);
    
    return filteredImage;
}


#pragma mark - Helpers method

- (UIImage *)normalizedImageWithImage:(UIImage *)image
{
    if (image.imageOrientation == UIImageOrientationUp)
    {
        return image;
    }
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [image drawInRect:(CGRect){0, 0, image.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}

#pragma mark - Navigation

- (void) navigateBack
{
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
