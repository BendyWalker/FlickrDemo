# Flickr Demo Notes

1. I started by creating a local Swift package, FlickrAPI, in which I defined the endpoints, models and public functions to access the data I believed would be required to populate the app.
	* Mapped out the endpoints in Paw (similar to Postman) first to test and validate I was getting correct responses.
	* Added some lightweight tests to ensure that the JSON responses decode into my models correctly.
    * Perhaps the protocol and function scoping are overkill for this simple demo project, but it's quite nice that a lot of the groundwork is laid such that new endpoints could be added relatively easily in future.
    * Played around with property wrappers to deal with instances where fields in JSON responses were internally wrapped in their own 'content' object.
