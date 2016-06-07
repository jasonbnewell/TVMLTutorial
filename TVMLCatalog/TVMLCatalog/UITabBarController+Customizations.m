#import "UITabBarController+Customizations.h"
#import <objc/runtime.h>

@implementation UITabBarController (Customizations)
+ (void)load {
    static dispatch_once_t onceToken;
    // Borrowed from Mattt Thompson. This allows you to swap out the implementation of one method with another.
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        void (^swizzle)(SEL, SEL) = ^void(SEL originalSelector, SEL swizzledSelector) {
            Method originalMethod = class_getInstanceMethod(class, originalSelector);
            Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
            
            BOOL didAddMethod =
            class_addMethod(class,
                            originalSelector,
                            method_getImplementation(swizzledMethod),
                            method_getTypeEncoding(swizzledMethod));
            
            if (didAddMethod) {
                class_replaceMethod(class,
                                    swizzledSelector,
                                    method_getImplementation(originalMethod),
                                    method_getTypeEncoding(originalMethod));
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
        };
        swizzle(@selector(viewDidLayoutSubviews), @selector(x_viewDidLayoutSubviews));
    });
}


- (void)x_viewDidLayoutSubviews {
    // Call the replaced method to avoid horribly breaking everything.
    [self x_viewDidLayoutSubviews];
    // Customize the first tab bar button on every instance of UITabBar (typically there's only one)
    UITabBarItem *first = [self.tabBar.items objectAtIndex:1];
    first.image = [[UIImage imageNamed:@"smile.png"] imageWithRenderingMode:UIImageRenderingModeAutomatic]; // Render as mask
    first.selectedImage = [UIImage imageNamed:@"smile.png"];
    first.title = @"";
}
@end