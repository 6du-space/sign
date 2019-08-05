#!/usr/bin/env node -r livescript-transform-implicit-async/register 

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
  new Promise(
    (resolve, reject)~>
      klaw(cwd)
        .on(
          \readable
          ->
            while 1
              item = @read()
              if not item
                break
              console.log item.path
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
  dirpath = process.cwd()
  await hash(dirpath)
  # sk = await read('sk')
  # msg = Buffer.from(\11)
  # signed = sodium.sign(sk, msg)
  # console.log signed

  # pk = await read('pk')
  # msg = sodium.verify(pk, signed)
  # console.log msg.toString()

