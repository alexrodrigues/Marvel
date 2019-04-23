
# **Alex's Mavel**

## *First things first*



 **$ pod install** <br>
 **run the suit of tests** <br>
 **run $bundle** <br>
 **$ fastlane test**


## *The Architecuture*


In this project we use **MVVMC**. 

Our **View** is binded to a **ViewModel** and notify him with all user interecations. **The ViewModel** request to our Data Provides such as **Services** or **Repository** to fetch data by using CoreData or APi classes and then return to our ViewModel that information. Our **ViewModel** has a **CoordinatorLayout** to navigate between views preveting the use of segues.

## *Third Party Libraries*


### RxSwift:
    
RxSwfit its a powerful library how offers an alternative to handle callback hell. It makes the code more functional and easy to understand and threat callbacks and errors. In this particulary project it was essencial to chain requests  in Marvel's Detail, without probaly my code would more extensive and dirty.

### Quick/Nimble:

QuickNimble its a layer between the native sintaxe and us, it makes Unit tests easier to write and read also similar to other unit tests of different programming languages such NodeJs. 

### KingFisher:

A Great framework to download images and present activity indicator and cache.

## SwiftLint:

To make sure the swift project standards

## CCBottomRefreshControl: 

To help us to present refreshers at bottom of collection view

