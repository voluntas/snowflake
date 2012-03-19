<?php
function bench($binary) {
    json_encode(json_decode($binary));
}
$binary = file_get_contents('tokoroten.json');
$n = 100;
$t = microtime(true);
for ($i = 0; $i < $n; ++$i) {
    bench($binary);
}
echo (microtime(true) - $t) * 1000 * 1000 . PHP_EOL;
