import time

import zmq

ctx = zmq.Context()
sock = ctx.socket(zmq.PUB)

sock.bind('tcp://127.0.0.1:5555')

time.sleep(1.0)

sock.send_json({'foo': ['bing', 2.3, True]})
