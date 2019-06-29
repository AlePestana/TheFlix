//
//  MoviesGridViewController.m
//  TheFlix
//
//  Created by marialepestana on 6/28/19.
//  Copyright © 2019 marialepestana. All rights reserved.
//

#import "MoviesGridViewController.h"
#import "MovieCollectionCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

// -----> Interface
@interface MoviesGridViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

// Movies array global variable - same as in the movies controller file
@property (strong, nonatomic) NSArray *movies;
// Collection view
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end


// -----> Implementation
@implementation MoviesGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self fetchMovies];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    
    // Fixed number of cells per line
    CGFloat postersPerLine = 3;
    CGFloat cellWidth = self.collectionView.frame.size.width / postersPerLine;
    
    // Can change the spacing between the cells manually
    // layout.minimumInteritemSpacing = (some number);
    // layout.minimumLineSpacing = (some number);
    
    CGFloat cellHeight = cellWidth * 1.6;
    
    layout.itemSize = CGSizeMake(cellWidth, cellHeight);
}


// Method that fetches movies - stores movies in an array
- (void)fetchMovies {
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            // --------------------------> Alert controller
            // Alert controller setup
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Network Error" message:@"Check your internet connection and please try again later." preferredStyle:(UIAlertControllerStyleAlert)];
            
            // create an OK action
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // handle response here.
                [self fetchMovies];
            }];
            
            // add the OK action to the alert controller
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:^{}];
            // --------------------------> Alert controller
            
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            // Saves the movies fetched from the API to movies array - which is declared as a property above
            self.movies = dataDictionary[@"results"];
            [self.collectionView reloadData];
            
        }
     }];
    [task resume];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Asks the table view to return the index path of the object I send it
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
    NSDictionary *movie = self.movies[indexPath.row];
    
    // View controller that's going to be shown
    DetailsViewController *detailsViewController = [segue destinationViewController];
    // Set public movie property to the movie
    // Passes movie that was tapped
    detailsViewController.movie = movie;
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    // Need to return the cell
    MovieCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.movies[indexPath.item];

    // Process to make complete URL post and display image
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *completePosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    NSURL *posterURL = [NSURL URLWithString:completePosterURLString];
    // Clears out previous poster
    cell.posterView.image = nil;
    
    // Use method defined in AFNetworking class - managed using Cocoa Pods
    [cell.posterView setImageWithURL:posterURL];
    
    return cell;
}

// Function that returns the amount of items there are
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;
}


@end
