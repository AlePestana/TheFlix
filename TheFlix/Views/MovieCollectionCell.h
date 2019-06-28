//
//  MovieCollectionCell.h
//  TheFlix
//
//  Created by marialepestana on 6/28/19.
//  Copyright © 2019 marialepestana. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieCollectionCell : UICollectionViewCell

// Poster image view - for the collection view
@property (weak, nonatomic) IBOutlet UIImageView *posterView;

@end

NS_ASSUME_NONNULL_END
