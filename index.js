(function(){
  var path, sodium, config, fs, read;
  path = require('path');
  sodium = require('sodium-6du');
  config = require('config-6du/6du');
  fs = require('fs-extra');
  read = function(name){
    return fs.readFile(path.join(__dirname, "../private/key/6du." + name));
  };
  (function(){
    var dirpath;
    dirpath = process.cwd();
    console.log(dirpath);
  })();
}).call(this);
