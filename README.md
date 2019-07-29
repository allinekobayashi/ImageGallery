#  Alline Kobayashi - Image Gallery 

## About the app

### The main idea
This app shows a list of images grouped by albums. 

### The data
This app gets its data from http://jsonplaceholder.typicode.com/

## About the solution

### File organisation:
I chose to organize the files based on layers instead of domain giving the size of this project. I am aware that in bigger projects, it might be better to do it by domain because it creates a bounded context that helps the developer to understand what each part of the app does and how they connect to each other. 

### Data mapping:
There is a simpler solution for this app that is accessing the database directly, i.e. using the NSManagedObject as the model. However, I chose to create layers of abstraction. So, the AlbumsStorage is responsible for accessing the database and mapping the database model to the apps model. I chose to decouple the app's model from the database model because it facilitates changes in the database in the future (for example, if we decide to migrate to Realm) and it avoids one class having many responsibilities. 

### Performance:

#### Number of requests
When getting the data from the server, this app does one request to fetch all the albums of the user and, for each album, it does another request to fetch all of its content. When creating each table view or collection view cell, it does another request to fetch the image of the photo if it isn't cached. Hence, it takes some time to load the content for the first time. It can be improved paginating the data both from album and from photos.

### Tests:
Due to time constraints, I was not able to implement all the unit tests required for an ideal solution. 
