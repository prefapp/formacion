module.exports = {  

    amqp : {
        server: process.env["AMQP_SERVER"] || "rabbitmq",

        user: process.env["AMQP_USER"] || "user",
        
        password: process.env["AMQP_PASSWORD"] || "",
        
        queue: process.env["AMQP_QUEUE"] || "rabbit-queue",
        
        consume_rate: process.env["AMQP_CONSUME_RATE"] || 1000
    }

}
