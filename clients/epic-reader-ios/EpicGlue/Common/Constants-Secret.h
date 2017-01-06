#ifdef DEBUG

static NSString *const ApiServer = @"http://192.168.1.103:7000";
static NSString *const ApiVersion = @"v1";
static NSString *const UserAgent = @"Epic Glue App [DEV]";

static NSString *const RedditClientId = @"";
static NSString *const RedditClientSecret = @"";

#else

static NSString *const ApiServer = @"https://api.epicglue.com";
static NSString *const ApiVersion = @"v1";
static NSString *const UserAgent = @"EpicGlue App";

static NSString *const RedditClientId = @"";
static NSString *const RedditClientSecret = @"";

#endif
