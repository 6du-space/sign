(function(){
  var path, klaw, zlib, sodium, config, fs, promisify, read, hash, pack;
  path = require('path');
  klaw = require('klaw');
  zlib = require('zlib');
  sodium = require('sodium-6du');
  config = require('config-6du/6du');
  fs = require('fs-extra');
  promisify = require("util").promisify;
  read = function(name){
    return fs.readFile(path.join(__dirname, "../private/key/6du." + name));
  };
  hash = function(cwd){
    var cut, li;
    cut = cwd.length + 1;
    li = [];
    return new Promise(function(resolve, reject){
      return klaw(cwd).on('data', async function(arg$){
        var path, stats;
        path = arg$.path, stats = arg$.stats;
        if (stats.isDirectory()) {
          return;
        }
        return li.push([path.slice(cut), sodium.hash((await fs.readFile(path)))]);
      }).on('error', function(err, item){
        console.log(err.message);
        return console.log(item.path);
      }).on('end', function(){
        var fileli, hashli, i$, ref$, len$, ref1$, f, h, n;
        li.sort(function(a, b){
          if (a > b) {
            return -1;
          } else {
            return 1;
          }
        });
        fileli = [];
        hashli = [];
        for (i$ = 0, len$ = (ref$ = li).length; i$ < len$; ++i$) {
          ref1$ = ref$[i$], f = ref1$[0], h = ref1$[1];
          fileli.push(f);
          hashli.push(h);
        }
        hashli.unshift(Buffer.from(fileli.join("\n")));
        n = Buffer.allocUnsafe(6);
        n.writeUIntLE(fileli.length, 0, 6);
        hashli.unshift(n);
        return resolve(Buffer.concat(hashli));
      });
    });
  };
  pack = async function(dirpath){
    var result, ref$;
    result = (await hash(dirpath));
    return promisify(zlib.brotliCompress, {
      params: (ref$ = {}, ref$[zlib.constants.BROTLI_PARAM_QUALITY + ""] = zlib.constants.BROTLI_MAX_QUALITY, ref$[zlib.constants.BROTLI_PARAM_SIZE_HINT + ""] = result.length, ref$)
    })(result);
  };
  (async function(){
    var dirpath, packed, sk;
    dirpath = "/root/tmp/sh";
    packed = (await pack(dirpath));
    sk = (await read("sk"));
    console.log(sodium.sign(sk, sodium.hash(packed)));
  })();
}).call(this);
