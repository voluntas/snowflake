import timeit

import simplejson

def bench(binary):
  simplejson.dumps(simplejson.loads(binary))

if __name__ == '__main__':
  print(simplejson.__version__)
  binary = open('tokoroten.json', 'rb').read()
  print timeit.Timer("bench(binary)", "from bench import bench; binary = open('tokoroten.json', 'rb').read()").timeit(100) * 1000 * 1000
