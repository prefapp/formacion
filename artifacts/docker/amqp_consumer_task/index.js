
const amqp = require('amqplib')

const config = require("config")

const opt = { 
  credentials: amqp.credentials.plain(config.get("amqp.user"), config.get("amqp.password")) 
}

amqp.connect(config.get("amqp.server"), opt, function(err, connection) {
  if (err) {
    throw err;
  }
  
  connection.createChannel(function(error, channel) {
  
    if (error) {
      throw error;
    }

    const queue = config.get("amqp.queue")

    channel.assertQueue(queue, {
      durable: true
    });

    channel.prefetch(1);

    channel.consume(queue, function(msg) {

      console.log("Recibido '%s'", msg.content.toString())

      setTimeout(function() {
  
        channel.ack(msg);
  
      }, config.get("amqp.consume_rate"))
  
    });
  
  });
});
