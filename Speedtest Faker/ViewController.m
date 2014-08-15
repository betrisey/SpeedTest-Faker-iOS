//
//  ViewController.m
//  Speedtest Faker
//
//  Created by Samuel Bétrisey on 14.08.14.
//
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnGenerate:(UIButton *)sender {
    [_txtDown resignFirstResponder];
    [_txtUp resignFirstResponder];
    [_txtPing resignFirstResponder];
    [_txtResult resignFirstResponder];
    
    int down, up, ping, serverId;
    
    down = _txtDown.text.intValue;
    up = _txtUp.text.intValue;
    ping = _txtPing.text.intValue;
    serverId = 3026;
    
    NSString *result = @"";
    result = [self getDataFrom:[NSString stringWithFormat:@"http://samuelbe.ch/speedtest/api-ios.php?down=%i&up=%i&ping=%i&serverid=%i",down,up,ping,serverId]];
    
    _txtResult.text = result;
    _txtResult.hidden = false;
    
    NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: result]];
    _imgResult.image = [UIImage imageWithData: imageData];
}

- (NSString *) getDataFrom:(NSString *)url{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %i", url, [responseCode statusCode]);
        return nil;
    }
    
    return [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
}
@end
