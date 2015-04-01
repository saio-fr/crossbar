Crossbar Test Config

Realm : "saio_crossbar_realm"

Transports | protocol / possible auth methods : (=> non testé TODO)
	- WebSocket ws://0.0.0.0:8080 / "anonymous" & wampcra auth as "enterprise"
	- RawSocket (over tcp) tcp://0.0.0.0:4242 / wampcra auth as "service"

Roles | role / namespaces / permissions (ie PSCR - pub, sub, call, reg) :
	- anonymous
		com.saio.api.public.* / 1110
		com.saio.api.enterprise.* / 0000
		com.saio.api.service.* / 0000
	- enterprise (user : "enterprise" / password : "enterprisepassword")
		com.saio.api.public.* / 1110
		com.saio.api.enterprise.* / 1110
		com.saio.api.service.* / 0000
	- service (user : "enterprise" / password : "enterprisepassword")
		com.saio.api.public.* / 1111
		com.saio.api.enterprise.* / 1111
		com.saio.api.service.* / 1111

Deploy :
	$ docker build .
	=> return "$ Successfully built [imageID]"
	$ docker run -P [imageID]