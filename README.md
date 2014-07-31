# Getting Started

Adform brings brand advertising to the programmatic era at scale, making display advertising simple, relevant and rewarding!

## 1. General Info

The use of Adform SDK requires the following:

* Xcode 5.0 or later.
* iOS SDK 7.0 or later.
* Requires deployment target 6.0 or later

![alt tag](http://37.157.0.44/mobilesdk/help/images/iphone/page_01.png)

## 2. Drag AdformSDK folder to your project.

* Download latest build version of Adform SDK.
* Drag AdformSDK folder to your project, when asked select **Copy items into destination group's folder**.

![alt tag](http://37.157.0.44/mobilesdk/help/images/iphone/page_02.png)

![alt tag](http://37.157.0.44/mobilesdk/help/images/iphone/page_03.png)

* Go to your application target’s configuration > General > Linked Frameworks and Libraries section and add **AdSupport.framework** to your project.

![alt tag](http://37.157.0.44/mobilesdk/help/images/iphone/page_05.png)

* Go to your application target’s configuration > Build settings > Linking > Other Linker Flags, and set **-ObjC** flag.

![alt tag](http://37.157.0.44/mobilesdk/help/images/iphone/page_04.png)

* (Optional) You should import NewRelic SDK to the project. It is used by AdformSDK for error tracking. You can find instructions how to import it here: [ios-installation-and-configuration](https://docs.newrelic.com/docs/mobile-monitoring-installation/ios-installation-and-configuration).

* Finaly import **AdformSDK.h** and you are ready to use Adform banners:

![alt tag](http://37.157.0.44/mobilesdk/help/images/iphone/page_06.png)

	#import "AdformSDK.h"
	
> Adform SDK is Automatic Reference Counting (ARC) compliant. 

## 3. Basic Adform Mobile Advertising SDK Banner View implementation

It is very easy to use AdformSDK to place ad banners in your application. The example code provided below shows you how to add a banner to your view controller. You just need a Master Tag Id.

![alt tag](http://37.157.0.44/mobilesdk/help/images/iphone/page_07.png)

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

Thats it! You are ready to go.
