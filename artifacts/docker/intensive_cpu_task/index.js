const express = require("express")

const app = express()

function fibo(n){

  if(n < 2){
    return 1
  }
  else{
    return fibo(n-2) + fibo(n-1)
  }
}

app.get("/fibo/:number", function(req, res){

  console.log(req.params)

  const num = parseInt(req.params.number)

  if(num){
    res.json({num: fibo(num)})
  }
  else{

    res.status(400)
    res.end("")
  }
    

})

app.listen("8080")
