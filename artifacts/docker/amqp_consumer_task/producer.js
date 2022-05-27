const amqp = require('amqplib/callback_api')

const config = require("config")

const express = require("express")

const opt = { 
  credentials: amqp.credentials.plain(config.get("amqp.user"), config.get("amqp.password")) 
}

let RABBITMQ_INSTANCE

async function getChannel(){

  if(RABBITMQ_INSTANCE){

    return RABBITMQ_INSTANCE
  }

  RABBITMQ_INSTANCE = await createConnection()

  return RABBITMQ_INSTANCE

}

function createConnection(){

  return new Promise(function(ok, ko){

    amqp.connect(config.get("amqp.server"), opt, function(error, connection){

      if(error){

        throw error
      }

      connection.createChannel(function(error1, channel){

        if(error1){

          throw error1
        }

        const queue = config.get("amqp.queue")

        channel.assertQueue(queue, {


        })

        ok(channel)

      })

    })
  })
}


const app = express()

app.post("/enqueue", function(req, res){

  const queue = config.get("amqp.queue")

  getChannel()

    .then((ch) => {

      const date = new Date().toISOString().
                    replace(/T/, ' ').    
                    replace(/\..+/, '') 

      ch.sendToQueue(queue, Buffer.from(`MSG_MSG (${date})`))

      res.send("OK!")

    })

})

app.listen('8080')
