Livestream
==========

This project is just a quick experiment I made during a weekend using Livestream library. So there's no much fancy code in here, just a simple proof of concept.

It's composed by 3 subprojects:
* An OS X client
* An iOS simple application
* A Node-based WS

The Node WS serves as communication bridge between the OS X and iOS clients, using websockets as common protocol. The iOS App enables user to pick a video from streams list, and start broadcasting on the Mac.

The server should support more than a single client at the same time, but it may be a little buggy since I didn't have much time to make testing. But the functionality is there.
