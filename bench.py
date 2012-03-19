import timeit

import simplejson
import json
import ujson

def bench(binary):
  simplejson.dumps(simplejson.loads(binary))

def bench_json(binary):
  json.dumps(json.loads(binary))

def bench_ujson(binary):
  ujson.dumps(ujson.loads(binary))

if __name__ == '__main__':
  print('simplejson: ' + simplejson.__version__)
  binary = open('tokoroten.json', 'rb').read()
  print timeit.Timer("bench(binary)", "from bench import bench; binary = open('tokoroten.json', 'rb').read()").timeit(100) * 1000 * 1000

  print('json: ' + json.__version__)
  print timeit.Timer("bench_json(binary)", "from bench import bench_json; binary = open('tokoroten.json', 'rb').read()").timeit(100) * 1000 * 1000

  print('ujson: ' + ujson.__version__)
  print timeit.Timer("bench_ujson(binary)", "from bench import bench_ujson; binary = open('tokoroten.json', 'rb').read()").timeit(100) * 1000 * 1000
