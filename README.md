# RouteIstanbul
[Please click here to watch the video of the app](https://youtu.be/w2ZmXDP6Fgs)

## Prerequisites

Before using any of the view controllers in this project, ensure that you have the following prerequisites set up:

- Firebase SDK installed and configured in your project.
- Required Firebase modules imported (import Firebase, import FirebaseAuth, import FirebaseFirestore, import FirebaseStorage).
- Ensure you have a storyboard or XIB file that includes the necessary UI elements and connects them to the appropriate outlets and actions.
- Xcode and an iOS development environment compatible with the Swift language.
  
## 1. Home View Controller

<p align="center">
  <img src="https://github.com/oykuhazer/RouteIstanbul/assets/130215854/b613bda1-0b18-423f-8ad7-e6aa08ee8524" alt="zyro-image" width="200" height="450">
</p>

The HomeViewController class is a view controller responsible for displaying a welcome message and a button for signing up with an email. It inherits from UIViewController and overrides the viewDidLoad method to set up the view.

## 2. Sign Up View Controller

<p align="center">
  <img src="https://github.com/oykuhazer/RouteIstanbul/assets/130215854/d0379b0d-ce98-4247-a401-41f990c6e4a0" alt="zyro-image" width="200" height="450">
</p>

This is a view controller class that provides a user interface for signing up with an email address, username, and password. It includes text fields for entering the email, username, and password, as well as a sign-up button and a login button. The class utilizes Firebase for user authentication and Firestore for storing user data.

### Usage

To use this view controller, follow these steps:
- Initialize an instance of EmailSignUpViewController and present or push it in your navigation flow.
- Implement the necessary delegate methods for the text fields and customize the behavior as needed.
- Customize the appearance and functionality of the view controller as desired.

## 3. Log In View Controller

<p align="center">
  <img src="https://github.com/oykuhazer/RouteIstanbul/assets/130215854/2731da9f-e2e0-4131-a16c-e3af5ca7ddeb" alt="zyro-image" width="200" height="450">
</p>

The LogInViewController is a view controller class that provides a user interface for users to log in with their email addresses and passwords. It uses Firebase Authentication and Firestore to authenticate user identities and store user data.

### Usage

- Instantiate the LogInViewController class to use it and add it to the current view controller hierarchy.
- Define and configure the required view elements in the LogInViewController.
- Implement the necessary delegates and customize the methods.

## 4. Entry View Controller

<p align="center">
  <img src="https://github.com/oykuhazer/RouteIstanbul/assets/130215854/b89cf2d0-2c23-4aed-8eb5-220e84acdc20" alt="zyro-image" width="200" height="450">
</p>

The EntryViewController is a view controller class that provides a user interface for displaying various destinations and categories to the user. It uses Firebase for data storage and retrieval, including Firebase Storage for image downloads.

### Usage

- Instantiate the EntryViewController class to use it and add it to the current view controller hierarchy.
- Implement the necessary delegates and customize the methods.
- Configure the appearance and behavior of the collection views and other UI elements.

### Note

You may need to modify the collection view identifiers (entryUpCell and entryBottomCell) to match your project's identifiers.

## 5. Category View Controller

<p align="center">
  <img src="https://github.com/oykuhazer/RouteIstanbul/assets/130215854/29dc0106-7586-4fdf-b5d7-de041da1c7a5" alt="zyro-image" width="200" height="450">
</p>

The CategoryViewController is a view controller class that displays a list of categories in a table view. It retrieves the category data from Firebase and presents it to the user.

### Usage

- Instantiate the CategoryViewController class to use it and add it to the current view controller hierarchy.
- Implement the necessary delegates and customize the methods.
- Configure the appearance and behavior of the table view and other UI elements.

### Note

You may need to modify the table view cell identifier (categoriesCell) to match your project's identifier.

## 6. HistoriesByCategories View Controller

<p align="center">
  <img src="https://github.com/oykuhazer/RouteIstanbul/assets/130215854/d3fafb5f-b7b9-4a21-b80e-5107469225af" alt="zyro-image" width="200" height="450">
 <img src="https://github.com/oykuhazer/RouteIstanbul/assets/130215854/9fedfea0-0986-4273-b2e6-42823234558e" alt="zyro-image" width="200" height="450">
</p>

The HistoriesByCategoriesViewController is a view controller class that displays historical sites categorized by a specific category. It uses a collection view to show the historical sites and provides search functionality to filter the sites based on their names.

### Usage

- Instantiate the HistoriesByCategoriesViewController class to use it and add it to the current view controller hierarchy.
- Implement the necessary delegates and customize the methods.
- Configure the appearance and behavior of the collection view, search bar, labels, buttons, and other UI elements.

### Note

You may need to modify the collection view cell identifier (historiesByCategoriesCell) to match your project's identifier.

## 7. AllHistories View Controller

<p align="center">
  <img src="https://github.com/oykuhazer/RouteIstanbul/assets/130215854/d9976793-48eb-47d9-9b2a-584704b8739b" alt="zyro-image" width="200" height="450">
 <img src="https://github.com/oykuhazer/RouteIstanbul/assets/130215854/f41d892e-5060-4c4b-8f49-8fffc82f8bdc" alt="zyro-image" width="200" height="450">
</p>

The AllHistoriesViewController is a view controller class that displays a collection view of all histories. It also includes a search bar for filtering the histories based on their names.

### Usage

- Instantiate the AllHistoriesViewController class to use it and add it to the current view controller hierarchy.
- Implement the necessary delegates and customize the methods.
- Configure the appearance and behavior of the collection view, search bar, and other UI elements.

### Note

You may need to modify the collection view cell identifier (allHistoriesCell) and the segue identifier (toDetailAllHistories) to match your project's identifiers.

## 8. HistoriesDetail View Controller

<p align="center">
  <img src="https://github.com/oykuhazer/RouteIstanbul/assets/130215854/78412cda-4813-4aba-9a6b-65da1ae2f61e" alt="zyro-image" width="200" height="450">
 <img src="https://github.com/oykuhazer/RouteIstanbul/assets/130215854/305f963c-a1d4-4e54-9d36-ff59363aa763" alt="zyro-image" width="200" height="450">
  <img src="https://github.com/oykuhazer/RouteIstanbul/assets/130215854/c1dad10d-cdb1-4738-a217-9f9f0269c01b" alt="zyro-image" width="200" height="450">
  <img src="https://github.com/oykuhazer/RouteIstanbul/assets/130215854/dc1f51e2-0993-4999-a22b-b85a66b3c2df" alt="zyro-image" width="200" height="450">
  <img src="https://github.com/oykuhazer/RouteIstanbul/assets/130215854/9b251bf0-bc74-4c7a-9b26-379d4761dd08" alt="zyro-image" width="200" height="450">
  <img src="https://github.com/oykuhazer/RouteIstanbul/assets/130215854/3a14cab0-ac80-4ff2-b8b1-44bf802c9a7c" alt="zyro-image" width="200" height="450">
</p>

The HistoriesDetailViewController is a view controller class that displays detailed information about a historical site. It includes an image, text, and name of the historical site. The view controller also provides additional functionality such as showing a map location and adding comments.

### Usage

- Instantiate the HistoriesDetailViewController class to use it and add it to the current view controller hierarchy.
- Implement the necessary delegates and customize the methods.
- Configure the appearance and behavior of the image view, text view, labels, buttons, and other UI elements.

### Notes

The HistoriesDetailViewController includes functionality related to displaying a map location and adding comments. You may need to implement additional code and configure the necessary view controllers for these features to work correctly.

## 9. DetailInf View Controller

<p align="center">
  <img src="https://github.com/oykuhazer/RouteIstanbul/assets/130215854/5b6c26e0-41b7-4d33-aaf0-8319ce86c405" alt="zyro-image" width="200" height="450">
 <img src="https://github.com/oykuhazer/RouteIstanbul/assets/130215854/afb83209-2dbc-4e79-82d9-09a2597589c3" alt="zyro-image" width="200" height="450">
</p>

The DetailInfViewController is a view controller class that displays detailed information about a historical site. It includes a title label and a text view for displaying the information. The view controller is designed to be presented as a bottom sheet view controller.

### Usage

- Instantiate the DetailInfViewController class to use it and add it to the current view controller hierarchy.
- Set the tarih_ad property to the desired title for the detailed information.
- Set the tarih_uzun property to the detailed information text.
- Configure the appearance and behavior of the label and text view.

### Notes

The DetailInfViewController is designed to be presented as a bottom sheet view controller. You may need to configure the presentation style and behavior of the view controller to match your project's requirements.

## 10. AddIdea View Controller

<p align="center">
  <img src="https://github.com/oykuhazer/RouteIstanbul/assets/130215854/7e900ec0-4eee-4461-8a58-bbf9786de526" alt="zyro-image" width="200" height="450">
 <img src="https://github.com/oykuhazer/RouteIstanbul/assets/130215854/2c8ba43d-cfa2-4e3d-8ccd-05e62d53aa5d" alt="zyro-image" width="200" height="450">
</p>

The AddIdeaViewController is a view controller class that allows users to add their ideas or comments about a specific place. It includes text fields for the place name and username, a text view for the comment, and a share button to submit the idea. The view controller also includes a segmented control for selecting the category of the comment.

### Usage

- Instantiate the AddIdeaViewController class to use it and add it to the current view controller hierarchy.
-	Customize the appearance and behavior of the text fields, text view, and share button.
-	Implement the necessary delegate methods for the text view and text fields.
-	Set the appropriate values for the selectedCategory variable based on the segmented control's value.
-	Implement the logic for the shareButtonTapped function to handle the submission of the idea or comment.
-	Optionally, fetch the username from Firestore and populate the textFieldUsername text field.
-	Customize the appearance and behavior of the segmented control based on your project's design.

### Notes

- Implement the necessary delegate methods for the text view and text fields to handle user input and behavior.
- The AddIdeaViewController is designed to be used as a view controller in your project and can be customized and extended based on your specific requirements.

## 11. CommentList View Controller

<p align="center">
  <img src="https://github.com/oykuhazer/RouteIstanbul/assets/130215854/67e6976b-bc4d-479d-b3de-8a546842b70c" alt="zyro-image" width="200" height="450">
</p>

The CommentListViewController is a view controller class that displays a list of comments or ideas from users. It includes a table view to present the comments and a segmented control to filter the comments by category. The view controller also allows users to add new comments by tapping the "Add" button in the navigation bar.

### Usage

- Instantiate the CommentListViewController class to use it and add it to the current view controller hierarchy.
- Customize the appearance and behavior of the table view and segmented control.
- Implement the necessary delegate and data source methods for the table view to populate the comments.
- Implement the logic for the setListener function to set up the Firestore snapshot listener and retrieve the comments.
- Customize the appearance and behavior of the segmented control based on your project's design.
- Customize the table view cell in the IdeasTableViewCell class and XIB file to display the comment information.

### Notes

- Create a custom table view cell class, IdeasTableViewCell, and a corresponding XIB file to display the comment information.
- Customize the appearance and behavior of the table view and segmented control according to your project's design.
- Implement the necessary delegate and data source methods for the table view to populate the comments based on your custom table view cell class.
- The CommentListViewController is designed to be used as a view controller in your project and can be customized and extended based on your specific requirements.

## 12. Favorite View Controller

<p align="center">
  <img src="https://github.com/oykuhazer/RouteIstanbul/assets/130215854/f2b9ffb5-a6cd-48c6-9f7c-5af2609866cd" alt="zyro-image" width="200" height="450">
 <img src="https://github.com/oykuhazer/RouteIstanbul/assets/130215854/b8889360-44fd-4029-af90-dd778547bbc2" alt="zyro-image" width="200" height="450">
</p>

The FavoriteViewController is a view controller class that displays a list of favorite historical sites. It uses a table view to show the favorite sites based on the provided favoriteList and historiesList.

### Usage

- Instantiate the FavoriteViewController class to use it and add it to the current view controller hierarchy.
- Implement the necessary delegates and customize the methods.
- Configure the appearance and behavior of the table view, labels, buttons, and other UI elements.

### Note

You may need to modify the table view cell identifier (favCell) to match your project's identifier.

## 13. WishList View Controller

<p align="center">
  <img src="https://github.com/oykuhazer/RouteIstanbul/assets/130215854/9093468e-a287-4852-8e55-f561b83f3e95" alt="zyro-image" width="200" height="450">
</p>

The WishListViewController is a view controller class that displays a wishlist of favorite historical sites. It uses a table view to show the list of sites and allows the user to mark/unmark a site as a favorite by tapping on the corresponding row.

### Usage

- Instantiate the WishListViewController class to use it and add it to the current view controller hierarchy.
- Implement the necessary delegates and customize the methods.
- Configure the appearance and behavior of the table view, labels, buttons, and other UI elements.

### Note

You may need to modify the table view cell identifier (wishCell) to match your project's identifier.








