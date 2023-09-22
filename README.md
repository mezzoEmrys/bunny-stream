# bunny-stream

Local project meant for adding some fun features to my stream, using
the software Mix It Up as the connective tissue between OBS and my
lisp code. Mainly relies on hunchentoot as a server for Mix It Up
to make web requests to; ostensibly has drakma to make requests back
to Mix It Up, but there's some kind of socket nonsense that makes
that not work. 

The package name of bstream should be bunny-stream also, but I 
enjoy being able to type a little bit less while doing all my
debugging, etc. 

Future goals:
Trigger commands automatically to trigger the funishments starting
and stopping. Have to fix whatever drakma socket nonsense is
breaking to fix this, as well as configure Mix It Up to recieve.

Trading card system, which requires above. Let trading cards be
pulled by chatters, which are just small images in a card frame
with maybe some kind of foiling applied for visual things. This is
purely for fun.
