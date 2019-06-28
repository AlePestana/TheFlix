//
//  DetailsViewController.h
//  TheFlix
//
//  Created by marialepestana on 6/27/19.
//  Copyright © 2019 marialepestana. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController

// Public property which will allow me to display the movie
// It will be set in another place
@property (strong, nonatomic) NSDictionary *movie;

@end

NS_ASSUME_NONNULL_END
