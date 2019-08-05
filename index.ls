#!/usr/bin/env node -r livescript-transform-implicit-async/register 

require! <[
  path
]>

require! {
  \sodium-native : sodium
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
  message = Buffer.from \test
  signed = Buffer.alloc sodium.crypto_sign_BYTES + message.length
  secret = await read('sk')
  sodium.crypto_sign(signed, message, secret)
  console.log signed

  pk = await read('pk')
  message = Buffer.alloc(
    signed.length - sodium.crypto_sign_BYTES
  )
  sodium.crypto_sign_open(message, signed, pk)
  console.log message.toString()

