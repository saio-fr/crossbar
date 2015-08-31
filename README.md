Crossbar config
===============
There are 2 transports servers, one for users (aka "public") and one for services (aka "private").

Transport
---------

* realm: "saio"
* public port: 8080 (should be open)
* private port: 8081 (must not be open)

Authentication
--------------

* public: dynamic authenticator at "fr.saio.service.crossbar.session.manager.authenticate"

	{ authid: [sessionId], password: [token] }, gives authrole: "user"

* private: static authentication

	{ authid: "service", password: "service" }, gives authrole: "service"

Authorization
-------------

* public: dynamic authorizer at "fr.saio.service.authorizer.crossbar.can"

* private: static authorization, publish / subscribe / call / register granted for all routes.
