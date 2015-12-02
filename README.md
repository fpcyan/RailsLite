Rails Lite is a web server MVC framework inspired by the functionality of Ruby on Rails.

Rails Lite currently features:
* Interfacing with the server (WEBrick) reading requests and providing responses
* Custom routing through the controller to views
* Reading and writing to cookies, allowing for data to persist across sessions
* Parsing params from headers, queries, and forms to be sent to the body.
  - Supports the use of strong params.

This project is a Work In Progress. Currently being developed: dynamic routing based on "resources" and nested routes. On completion, resource routing will be integrated into [Whales][whales-link], written by [wdhorton][wdhorton].


[whales-link]: https://github.com/fpcyan/whales
[wdhorton]: https://github.com/wdhorton
