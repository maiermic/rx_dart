import 'dart:io';

main() {
  var p = Process.start('pub', ['run', 'test'], runInShell: true);
  p.then((result) {
    stdout.addStream(result.stdout);
    stderr.addStream(result.stderr);
  });
}