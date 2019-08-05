#!/usr/bin/env node -r livescript-transform-implicit-async/register 

require! <[
  path
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

do !~>
  sk = await read('sk')
  msg = Buffer.from(\1)
  signed = sodium.sign(sk, msg)
  console.log signed

  pk = await read('pk')
  msg = sodium.verify(pk, signed)
  console.log msg.toString()

