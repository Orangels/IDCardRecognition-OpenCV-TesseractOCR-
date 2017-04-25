//
//  ViewController.m
//  身份证识别(openCV+TesseractOCR)
//
//  Created by Orangels on 16/11/23.
//  Copyright © 2016年 ls. All rights reserved.
//

#import "ViewController.h"
#import "RecogizeCardManager.h"

@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *IDnum;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *CameraBtn;
@property (weak, nonatomic) IBOutlet UIButton *photoAlbum;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)takeCamera:(id)sender {
    
    
}
- (IBAction)openPhotoAlbum:(id)sender {
    UIImagePickerController* pickerC = [[UIImagePickerController alloc] init];
    pickerC.delegate = self;
    pickerC.allowsEditing = YES;
    pickerC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:pickerC animated:YES completion:nil];
}

#pragma mark delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage* image = info[UIImagePickerControllerEditedImage];
    _imageView.image = image;
    
    [[RecogizeCardManager shardRecogizeCardManager] recogizeCardWithImage:image compleate:^(NSString *text) {
        _IDnum.text = text;
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


































