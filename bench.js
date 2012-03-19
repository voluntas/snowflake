// for node.js
// npm install benchmark microtime
var fs = require('fs')
var Benchmark = require('benchmark')

function bench(binary) {
    return JSON.stringify(JSON.parse(binary))
}

var binary = fs.readFileSync('tokoroten.json')
var n = 100
var s = new Benchmark.Suite()
s.add('json', function() {
    for (var i = 0; i < n ; i++) {
        bench(binary)
    }
}).on('complete', function() {
    console.log(this[0].times.period * 1000 * 1000)
}).run()
