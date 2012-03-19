require 'json'
require 'benchmark'

def bench binary
  JSON.generate(JSON.parse(binary))
end

binary = open('tokoroten.json', 'rb').read
N = 100
r = Benchmark.measure { N.times { bench(binary) } }
puts r.real * 1000 * 1000
