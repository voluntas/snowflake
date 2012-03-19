var fs = require('fs')

function bench(binary) {
    return JSON.stringify(JSON.parse(binary))
}

var binary = fs.readFileSync('tokoroten.json')
var n = 100
var t = new Date().getTime()
for (var i = 0; i < n ; i++) {
    bench(binary)
}
console.log((new Date().getTime() - t)  * 1000)
