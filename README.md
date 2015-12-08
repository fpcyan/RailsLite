Rails Lite is a web server MVC framework inspired by the functionality of Ruby on Rails.

Rails Lite currently features:
* Interfacing with the server (WEBrick) reading requests and providing responses
* Custom routing through the controller to views
  - routes are drawn from resources, with proper pathing for nested resources
  - routes can create the default set of methods, or it can be restricted with :only and :except.
* Reading and writing to cookies, allowing for data to persist across sessions
* Parsing params from headers, queries, and forms to be sent to the body.
  - Supports the use of strong params.
