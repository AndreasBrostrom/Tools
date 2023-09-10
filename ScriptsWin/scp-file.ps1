

$file = $args[0]
$fileName = Split-Path $file -leaf

scp $file fileupload:~/file.evul.nu/public_html/0/$fileName