//
//  MoviesViewController.m
//  TheFlix
//
//  Created by marialepestana on 6/26/19.
//  Copyright © 2019 marialepestana. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

// -----> Interface

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate>

// Table view
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// Movies array global variable - available in other files
@property (strong, nonatomic) NSArray *movies;

// Refresh control
@property (strong, nonatomic) UIRefreshControl *refreshControl;

// Activity indicator
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end


// -----> Implementation

@implementation MoviesViewController


// Method called when the screen starts to load
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // --------------------------> Activity indicator
        // Activity indicator
    [self.activityIndicator startAnimating];
    // --------------------------> Activity indicator

    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // So when the view loads, it fetches the movies
    [self fetchMovies];

    // Instantiate object
    self.refreshControl = [[UIRefreshControl alloc] init];
    // Add refresh control to table view - do this since the refresh control is designed to work with the scroll view (tracks how much user scrolls)
    [self.refreshControl
     addTarget:self
     action:@selector(fetchMovies)
     forControlEvents:UIControlEventValueChanged
    ];
    // [self.tableView addSubview:self.refreshControl];
    // So it appears on the back of the table view
    [self.tableView insertSubview:self.refreshControl atIndex:0];
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
            
            // Cancel action
           /*
            
            // create a cancel action
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                 // handle cancel response here. Doing nothing will dismiss the view.
            }];
            
            // add the cancel action to the alertController
            [alert addAction:cancelAction];
            
            */
            
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
            // To display all the movies array -- NSLog(@"%@", dataDictionary);
            
            // Iterates through movies array and displays their title on the console
            /* for (NSDictionary *movie in self.movies) {
                NSLog(@"%@", movie[@"title"]);
            }
             */
            
            // Method that calls data source methods again
            // Allows the app to be up to date - reloads our table view data
            [self.tableView reloadData];
            
        }
        
        [self.refreshControl endRefreshing];
        // Everything was uploaded
        // --------------------------> Activity indicator
        [self.activityIndicator stopAnimating];
        // --------------------------> Activity indicator
        
    }];
    [task resume];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


// Method that returns the number of stories to display
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}


// Method that configures and returns a cell based on a different index path
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    NSDictionary *movie = self.movies[indexPath.row];
    // Assign objects displayed on screen the corresponding values from the movies array
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"];
    // cell.textLabel.text = movie[@"title"];
    
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



 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
// Special function called automatically
// Leave view controller and go to another screen
// Lifecycle method that asks if there's anything that needs to be sent to the destination view controller - in this case, the movie the user wants to see the details of (the one he clicks)
// Even though there's no id involved in the function, the sender sends the table view cell that got tapped on
// Sender = object that fired an event
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
     // Asks the table view to return the index path of the object I send it
     UITableViewCell *tappedCell = sender;
     NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
     NSDictionary *movie = self.movies[indexPath.row];
     
     // View controller that's going to be shown
     DetailsViewController *detailsViewController = [segue destinationViewController];
        // Set public movie property to the movie
        // Passes movie that was tapped
     detailsViewController.movie = movie;
     
     
     
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 


@end
