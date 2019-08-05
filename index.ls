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
  new Promise(
    (resolve, reject)~>
      klaw(cwd)
        .on(
          \data
          ({path, stats})~>
            if stats.isDirectory!
              return
            console.log path.slice(cut), sodium.hash(await fs.readFile(path)).toString('base64')
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

