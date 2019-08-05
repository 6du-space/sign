(function(){
  var path, sodium, config, fs, read;
  path = require('path');
  sodium = require('sodium-native');
  config = require('config-6du/6du');
  fs = require('fs-extra');
  read = function(name){
    return fs.readFile(path.join(__dirname, "../private/key/6du." + name));
  };
  (async function(){
    var message, signed, secret, pk;
    message = Buffer.from('test');
    signed = Buffer.alloc(sodium.crypto_sign_BYTES + message.length);
    secret = (await read('sk'));
    sodium.crypto_sign(signed, message, secret);
    console.log(signed);
    pk = (await read('pk'));
    message = Buffer.alloc(signed.length - sodium.crypto_sign_BYTES);
    sodium.crypto_sign_open(message, signed, pk);
    console.log(message.toString());
  })();
}).call(this);
