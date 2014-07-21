# Adform iOS SDK

Adform brings brand advertising to the programmatic era at scale, making display advertising simple, relevant and rewarding!

##How to import Adform SDK to iOS project?

Adform SDK is built as a static iOS library with an included resources bundle. Before adding ad banners to your application you will first need to import this static library to your project and configure it. To do this follow these steps:

1. Download latest build version of Adform SDK. (Currently v.0.1.2)
2. Open your existing xCode project, o create a new one.
3. Drag AdformSDK folder to your project, when asked select **Copy items into destination group's folder**.
4. Go to your application target’s configuration > Build settings > Linking > Other Linker Flags, and set **-ObjC** flag.
5. Go to your application target’s configuration > General > Linked Frameworks and Libraries section and add **AdSupport.framework** to your project.
6. (Optional) You should import NewRelic SDK to the project. It is used by AdformSDK for error tracking. You can find instructions how to import it here: [ios-installation-and-configuration](https://docs.newrelic.com/docs/mobile-monitoring-installation/ios-installation-and-configuration).
7. Finaly import **AdformSDK.h** and you are ready to use Adform banners:
    
		#import “AdformSDK.h”

Adform SDK is Automatic Reference Counting (ARC) compliant. 

The use of Adform SDK (v.0.1.1) requires the following:

* Xcode 5.0 or later.
* iOS SDK 7.0 or later.
* Requires deployment target 6.0 or later

##How to add ad banners to your application?

It is very easy to use AdformSDK to place ad banners in your application. The example code provided below shows you how to add a banner to your view controller. You just need a Master Tag Id.

	#import "ViewController.h"
	#import "AdformSDK.h"

	@implementation ViewController

	- (void)viewDidLoad
	{
		[super viewDidLoad];
    
   		//Create new banner view with Master tag id and position
    	AFBannerView *bannerView = [[AFBannerView alloc] initWithMasterTagId:MasterTagId position:AFBannerPositionBottom];
    	
    	//Add the newly created banner view as a subview to view controllers view
    	[self.view addSubview:bannerView];
    
    	//Iniate ad loading
    	[bannerView loadAd];
	}

	@end

##How to respond to banner size changes?

Adform banner view is shown only when advertisemnt is loaded, if no ad is loaded it is hidden. Transitions between these states are animated, so you should reposition your applications content accordingly. To do so you must implement `AFBannerViewDelegate` protocol methods: `bannerViewWillShow:` and `bannerViewWillHide`. The example code provided below shows you how to reposition UITextView so that when the banner shows its content wont be hidden by it. You should not rely on banner view `frame` property to determen its size and instead use `bannerSize` property.

	- (void)bannerViewWillShow:(AFBannerView *)bannerView {

    	UIEdgeInsets insets = _textView.contentInset;
   		insets.bottom += bannerView.bannerSize.height;
    	UIEdgeInsets scrollInsets = _textView.contentInset;
    	scrollInsets.bottom += bannerView.bannerSize.height;
    	[UIView animateWithDuration:kBannerAnimationDuration
                     	animations:^{
                         	_textView.contentInset = insets;
                         	_textView.scrollIndicatorInsets = scrollInsets;
                     	}];
	}

	- (void)bannerViewWillHide:(AFBannerView *)bannerView {
    
        UIEdgeInsets insets = _textView.contentInset;
       	insets.bottom -= bannerView.bannerSize.height;
       	UIEdgeInsets scrollInsets = _textView.contentInset;
       	scrollInsets.bottom -= bannerView.bannerSize.height;
       	[UIView animateWithDuration:kBannerAnimationDuration
                       	animations:^{
                           	_textView.contentInset = insets;
                           	_textView.scrollIndicatorInsets = scrollInsets;
                       	}];
	}
	
##What does banner position mean?
When creating banner view you can provide three banner positions:

1. **`AFBannerPositionTop`** - banner view is automatically positioned at the top of its container view, horizontaly centered in it. You should not set its frame manualy because it may result in unexpected banner view behavior.
2. **`AFBannerPositionBottom`** - banner view is automatically positioned at the bottom of its container view, horizontaly centered in it. You should not set its frame manualy because it may result in unexpected banner view behavior.
3. **`AFBannerPositionCustom`** - when using this position, you must manually set banner position in its container view by setting frame.origin property. The example code provided below shows you how to position banner view manually. You should use this position type only if you want to add banner inside your content, eg. place it inside scroll view together with your content.

		//Create new banner view with position AFBannerPositionCustom
		AFBannerView *bannerView = [[AFBannerView alloc] initWithMasterTagId:MasterTagId position:AFBannerPositionCustom];

		//Get banner frame property
    	CGRect frame = bannerView.frame;

		//Calculate banner view origin to place banner bellow label, horizontally centered in scrollView
    	frame.origin = CGPointMake((self.scrollView.frame.size.width - 		bannerView.frame.size.width) / 2, self.label.frame.origin.y + self.label.frame.size.height);

		//Set new, calculated banner frame
    	bannerView.frame = frame;

		//Add banner to scrollView
    	[self.scrollView addSubview:bannerView];

		//Initiate ad loading
    	[bannerView loadAd];


##How to add banner to UITableView?

Adform banner view can be added to table view contaners. It can be added as a section or table view header or footer and inside table view cells also. When adding banner view to table view you should ensure that you are properly reusing views to avoid performance issues if you are adding multiple banners. The example code provided below shows you how to add banner views to tablew view as section footers.

	- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	
		return [AFBannerView expectedBannerSize].height;
	}

	- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    	UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"BannerFooterIdentifier"];
    
    	AFBannerView *banner;
    
        if (!headerView) {
            headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"BannerFooterIdentifier"];
            
            banner = [[AFBannerView alloc] initWithMasterTagId:MasterTagId position:AFBannerPositionBottom];
            [headerView.contentView addSubview:banner];
            [banner loadAd];
    	}     
    
    	return headerView;
	}

##Setting publisher id and "custom data" parameters

Publisher id is set globally using main `AdformSDK` class and `setPublisherId:andCustomData:` method. Custom data is an optional parameter and you can pass nil to this method. However, if you want to target your users more accurately you should use "custom data" parameter. It is a `NSDictionary` object containig key-value pairs (e.g. {"gender":"male"}) and is set globally to all ad requests. This parameter should be set bofore loading any ads, because after a successful request to the server (with this parameter) "custom data" cannot be modified (you can still set it if you haven't done it before loading the ads). The best place to set "custom data" parameter is `application:didFinishLaunchingWithOptions:` application delegate method. The example code bellow shows you how to set "custom data" parameter:

	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
	{
		//Create custom data parameter dictionary, we are using literal definition for this, but you can use any other definition as well
		NSDictionary *customData = @{@"gender": @"male", @"age": @"20"};
		
    	//Set AdformSDK custom data parameter
    	[AdformSDK setPublisherId:PublisherID andCustomData:customData];
    	
    	return YES;
	}

##Setting custom banner refresh time interval
Every banner has a property `refreshInterval`. By setting this property you can override the dfault refresh time interval received with the ad. Refresh interval is mesured in seconds. This property has a couple of rules:

1. Setting it to 0 means that the banner will show only one ad and wont refresh it at all.
2. The values assigned to this property must be greater than 30 sec. (except 0), if you try to set it less than that it is automatically corrected to 30 sec.

An example below shows you how to set the banner refresh interval to 60 sec.

	- (void)viewDidLoad
	{
	    [super viewDidLoad];
		// Do any additional setup after loading the view, typically from a nib.
    
	    AFBannerView *bannerView = [[AFBannerView alloc] initWithMasterTagId:MasterTagID position:AFBannerPositionBottom];

	    bannerView.refreshInterval = 60;

	    [self.view addSubview:bannerView];
        
	    [bannerView loadAd];
	}

##AFBannerViewDelegate and AFInterstitialViewDelegate protocols
You can use `AFBannerViewDelegate` and `AFInterstitialViewDelegate` protocols to get callbacks when banner view states change or events occure. By using these protocols you can track banner load state, get callbacks about their visibility changes ant be informed about various events such as when banner opens an internal web browser or a modal view. An example below shows you how to track banner loading state, analogous code can be used with interstitial ad views.

	...
	//We must define that our view conntroller conforms to AFBannerViewDelegate protocol
	@interface ViewController () <AFBannerViewDelegate>

	...
	
	- (void)viewDidLoad
	{
   		[super viewDidLoad];
		// Do any additional setup after loading the view, typically from a nib.
    
    	//Create an AFBannerView object
    	AFBannerView *bannerView = [[AFBannerView alloc] initWithMasterTagId:444444 position:AFBannerPositionBottom];

		//Set a delegate to the newly created AFBannerView object
    	bannerView.delegate = self;

		//Add it to view hieararchy and start loading
    	[self.view addSubview:bannerView];        
    	[bannerView loadAd];
	} 

	...
	
	//Finaly we must define two methods which will get called when our banner either finishes loading or fails to load
	
	- (void)bannerViewDidLoadAd:(AFBannerView *)bannerView {
    	
    	//This method gets called when a banner view finishes loading a new ad
	}

	- (void)bannerViewDidFailToLoadAd:(AFBannerView *)bannerView withError:(NSError *)error {
    
    	//This method gets called when a banner view fails to load an ad
    	//An error object describes what went wrong
	}

If our banner fails to load, you can use `bannerViewDidFailToLoadAd:withError:` method to add any backup logic, such as loading a banner from another SDK, but dont forget that AFBannerView autorefreshes. The default refresh interval for a banner is 30 seconds if it is not set differently by the developer, so it may load a new banner after some time even if it failed to load the last one. If ad request was successfull but no ad was received from the server an error with code -997 will be passed to this method.