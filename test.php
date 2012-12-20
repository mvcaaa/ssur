<?PHP
function expn($value, $prec = 3, $base = 1000, $prefix = '') {
    $e = array('a', 'f', 'p', 'n', 'u', 'm', '', 'k', 'M', 'G', 'T', 'P', 'E');
    $p = min(max(floor(log(abs($value), $base)), -6), 6);
    return round((float)$value / pow($base, $p), $prec) . $prefx . $e[$p + 6];
}

echo expn(225)."\r\n";
?>
