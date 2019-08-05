#!/usr/bin/env -S node -r livescript-transform-implicit-async/register

require! <[
  path
  klaw
]>

require! {
  \sodium-6du : sodium
  \config-6du/6du : config
  \fs-extra : fs
}

read = (name)~>
  fs.readFile(
    path.join(
      __dirname, "../private/key/6du.#name"
    )
  )


hash = (cwd)~>
  cut = cwd.length+1
  fileli = []
  hashli = []
  new Promise(
    (resolve, reject)~>
      klaw(cwd)
        .on(
          \data
          ({path, stats})~>
            if stats.isDirectory!
              return
            fileli.push path.slice(cut)
            hashli.push sodium.hash(await fs.readFile(path))
        )
        .on(
          \error
          (err, item) ~>
            console.log err.message
            console.log item.path
        )
        .on(
          'end'
          ~>
            buf = Buffer.allocUnsafe(6)
            buf.writeUIntLE(fileli.length,0,6)
            console.log buf.readUIntLE(0,6)
            # console.log fileli
            # console.log hashli
            resolve()
        )

  )


do !->
  dirpath = "/root/tmp/sh"
  # console.log dirpath
  await hash(dirpath)
  # sk = await read('sk')
  # msg = Buffer.from(\11)
  # signed = sodium.sign(sk, msg)
  # console.log signed

  # pk = await read('pk')
  # msg = sodium.verify(pk, signed)
  # console.log msg.toString()

