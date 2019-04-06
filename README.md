
# **Alex's Mavel**

## *The Architecuture*

In this project we use MVVM. Our **View** requests to our **ViewModel** any information then our **ViewModel** requests to our **Service** to request to our **API** or **Repository** that information, then they return to our service our **Model** 
finally our **Service** transforms that **Model**  into a **ViewModel** and returns to our **View**.

## *Third Party Libraries*

### RxSwift:
    
RxSwfit its a powerful library how offers an alternative to handle callback hell. It makes the code more functional and easy to understand and threat callbacks and errors. In this particulary project it was essencial to chain requests  in Marvel's Detail, without probaly my code would more extensive and dirty.

### Quick/Nimble:

QuickNimble its a layer between the native sintaxe and us, it makes Unit tests easier to write and read also similar to other unit tests of different programming languages such NodeJs. 

