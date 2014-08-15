//
//  ViewController.m
//  Speedtest Faker
//
//  Created by Samuel Bétrisey on 14.08.14.
//
//

#import "ViewController.h"
#import <CommonCrypto/CommonDigest.h>

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
    // Fermeture du clavier
    [_txtDown resignFirstResponder];
    [_txtUp resignFirstResponder];
    [_txtPing resignFirstResponder];
    [_txtResult resignFirstResponder];
    
    // Déclaration des variables
    int down, up, ping, serverId;
    NSString *result = @"", *post_data, *curlResultTxt;
    
    // Récupération des valeurs saisies
    down = _txtDown.text.intValue;
    up = _txtUp.text.intValue;
    ping = _txtPing.text.intValue;
    serverId = 3026;
    
    // Préparation des données à envoyer au serveur
    post_data = [NSString stringWithFormat: @"download=%i&upload=%i&ping=%i&serverid=%i&hash=%@", down, up, ping, serverId, [self convertIntoMD5:[NSString stringWithFormat:@"%i-%i-%i-297aae72",ping,up,down]]];
    
    // Requête cURL
    CURL *_curl;
    
    struct MemoryStruct chunk;
    
    chunk.memory = malloc(1);  /* will be grown as needed by the realloc above */
    chunk.size = 0;    /* no data at this point */
    
    _curl = curl_easy_init();
    curl_easy_setopt(_curl, CURLOPT_URL, "http://www.speedtest.net/api/api.php");
    curl_easy_setopt(_curl, CURLOPT_REFERER, "http://c.speedtest.net/flash/speedtest-unicode.swf?v=441647");
    curl_easy_setopt(_curl, CURLOPT_POSTFIELDS, [post_data UTF8String]);
    curl_easy_setopt(_curl, CURLOPT_WRITEFUNCTION, WriteMemoryCallback);
    curl_easy_setopt(_curl, CURLOPT_WRITEDATA, (void *)&chunk);
    curl_easy_perform(_curl);
    curl_easy_cleanup(_curl);
    
    NSData *data = [NSData dataWithBytes:chunk.memory length:chunk.size];
    
    if(chunk.memory)
        free(chunk.memory);
    
    curlResultTxt = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    // Traitement du résultat
    result = [[curlResultTxt componentsSeparatedByString:@"="][1]componentsSeparatedByString:@"&"][0];
    result = [NSString stringWithFormat:@"http://www.speedtest.net/result/%@.png", result];
    
    // Affichage du résultat
    _txtResult.text = result;
    _txtResult.hidden = false;
    
    // Téléchargement et affichage de l'image
    NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: result]];
    _imgResult.image = [UIImage imageWithData: imageData];
}

struct MemoryStruct {
    char *memory;
    size_t size;
};

static size_t WriteMemoryCallback(void *contents, size_t size, size_t nmemb, void *userp) {
    size_t realsize = size * nmemb;
    struct MemoryStruct *mem = (struct MemoryStruct *)userp;
    
    mem->memory = realloc(mem->memory, mem->size + realsize + 1);
    if (mem->memory == NULL) {
        /* out of memory! */
        printf("not enough memory (realloc returned NULL)\n");
        exit(EXIT_FAILURE);
    }
    
    memcpy(&(mem->memory[mem->size]), contents, realsize);
    mem->size += realsize;
    mem->memory[mem->size] = 0;
    
    return realsize;
}

- (NSData*) downloadFileToMemory:(NSString*)url {
    CURL *curl_handle;
    
    struct MemoryStruct chunk;
    
    chunk.memory = malloc(1);  /* will be grown as needed by the realloc above */
    chunk.size = 0;    /* no data at this point */
    
    curl_handle = curl_easy_init();
    curl_easy_setopt(curl_handle, CURLOPT_URL, [url cStringUsingEncoding:[NSString defaultCStringEncoding]]);
    curl_easy_setopt(curl_handle, CURLOPT_WRITEFUNCTION, WriteMemoryCallback);
    curl_easy_setopt(curl_handle, CURLOPT_WRITEDATA, (void *)&chunk);
    curl_easy_setopt(curl_handle, CURLOPT_USERAGENT, "libcurl-agent/1.0");
    curl_easy_perform(curl_handle);
    curl_easy_cleanup(curl_handle);
    
    NSData *data = [NSData dataWithBytes:chunk.memory length:chunk.size];
    
    if(chunk.memory)
        free(chunk.memory);
    
    return data;
}

- (NSString *)convertIntoMD5:(NSString *) string{
    const char *cStr = [string UTF8String];
    unsigned char digest[16];
    
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *resultString = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [resultString appendFormat:@"%02x", digest[i]];
    return  resultString;
}

@end
