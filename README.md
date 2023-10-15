# Flickr Demo Notes

Here's a broad list of the order I went about things along with any observations I made:

1. Created a local Swift package, FlickrAPI, in which I defined the endpoints, models and public functions to access the data I believed would be required to populate the app.
	* Mapped out the endpoints in Paw (similar to Postman) first to test and validate I was getting correct responses.
	* Added some lightweight tests to ensure that the JSON responses decode into my models correctly.
    * Perhaps the protocol and function scoping are overkill for this simple demo project, but it's quite nice that a lot of the groundwork is laid such that new endpoints could be added relatively easily in future.
    * Played around with property wrappers to deal with instances where fields in JSON responses were internally wrapped in their own 'content' object.
2. Created PhotosProvider responsible for making network calls and transforming responses into UI-friendly models. This pattern provides consistency and a way to flatten certain responses and clean up fields, but I acknowledge it can sometimes feel unnecessary for simple requests.
3. Created RootViewModel that conforms to `@Observable`. Since most of the business logic has been abstracted elsewhere, it's quite simple.
	* Made a NetworkResource enum to encapsulate the different states a network response can be in.
	* Made a PhotosProviding protocol so I could mock out PhotosProvider's response and unit test the search function in RootViewModel.
4. Built out a basic RootView to validate that the ViewModel was providing data correctly.
	* Rewrote `PhotosProvider.search()` to run `getInfo` calls in parallel, massively speeding up response time.
5. Renamed RootView and related classes to SearchView, and built out the UI for the search screen.
	* Opted to overlay the username and tags on top of each image to maximise display of the primary content.
	* Used the MockPhotosProvider from the unit tests to display sample data in SwiftUI previews.
	* Switched on NetworkResource to easily handle loading, loaded and failed states.