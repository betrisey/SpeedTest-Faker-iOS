//
//  ViewController.h
//  Speedtest Faker
//
//  Created by Samuel Bétrisey on 14.08.14.
//
//

#import <UIKit/UIKit.h>
#import "curl/curl.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtDown;
@property (weak, nonatomic) IBOutlet UITextField *txtUp;
@property (weak, nonatomic) IBOutlet UITextField *txtPing;
@property (weak, nonatomic) IBOutlet UITextField *txtResult;
@property (weak, nonatomic) IBOutlet UIImageView *imgResult;
- (IBAction)btnGenerate:(UIButton *)sender;
- (NSString *)convertIntoMD5:(NSString *)string;

- (NSData*) downloadFileToMemory:(NSString*)url;
static size_t WriteMemoryCallback(void *contents, size_t size, size_t nmemb, void *userp);
struct MemoryStruct;
@end
