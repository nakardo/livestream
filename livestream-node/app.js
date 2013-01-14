var WebSocketServer = require('ws').Server
  , wss = new WebSocketServer({port: 8080})
  , secrets = new Array()
  , clients = new Array();

function findClientWithSecret(secret) {
  var idx = secrets.indexOf(secret);
  if (idx > -1) {
    return clients[idx];
  }

  return null;
}

wss.on('connection', function(ws) {

  console.log('\n[connected]');

  ws.on('message', function(data, flags) {
    var requestJson = JSON.parse(data.toString());
    console.log('-> ' + data.toString());

    // ping
    // -> {"event":"ping", "data":{"secret":"magumbo"}}
    // <- {"event":"ping", "data":{"status":0, "message":"ok"}}
    // <- {"event":"ping", "data":{"status":-1, "message":"client not registered using secret: magumbo"}}
    if ('ping' == requestJson.event) {
      var secret = requestJson.data.secret;
      if (secret) {
        var responseJson = {};
        responseJson.event = "ping";
        responseJson.data = {};

        if (findClientWithSecret(secret) != null) {
          responseJson.data.status = 0;
          responseJson.data.message = "ok";
        } else {
          responseJson.data.status = -1;
          responseJson.data.message = "client not registered using secret: " + secret;
        }

        var res = JSON.stringify(responseJson);
        ws.send(res);
        console.log("<- " + res);
      } else {
        console.log('secret not found on data object');
      }
    }

    // register
    // -> {"event":"register", "data":{"secret":"magumbo"}}
    // <- {"event":"register", "data":{"status":"0", "message":"success"}}
    if ('register' == requestJson.event) {
      var secret = requestJson.data.secret;
      if (secret) {
        var client = findClientWithSecret(secret);
        if (client != null) {
          console.log("-- deleting old client for secret: " + secret);
          delete clients[client]; delete secrets[secret];
        }
        clients.push(ws); secrets.push(secret);

        var res = JSON.stringify({"event":"register", "data":{"status":"0", "message":"success"}});
        ws.send(res);
        console.log("<- " + res);
      }
    }

    // action [play_pause, stop, close]
    // -> {"event":"action", "data":{"secret":"magumbo", "action":"stop", "url":"http://ichunk.livestream.com/../.."}}
    // <- {"event":"action", "data":{"status":"0", "message":"success"}}
    // <- {"event":"action", "data":{"status":"-1", "message":"client not found for secret: magumbo"}}
    // <> {"event":"action", "data":{"action":"stop", "url":"http://ichunk.livestream.com/../.."}}
    if ('action' == requestJson.event) {
      var responseJson = {};
      responseJson.event = "action";
      responseJson.data = {};

      var secret = requestJson.data.secret;
      if (secret) {
        var client = findClientWithSecret(secret);
        if (client != null) {
          responseJson.data.status = 0;
          responseJson.data.message = "success";

          var data = requestJson.data;
          var res = JSON.stringify({"event":"action", "data":{"action":data.action, "url":data.url}});
          client.send(res);
          console.log("<-[" + secret + "] " + res);
        } else {
          responseJson.data.status = -1;
          responseJson.data.message = "client not found for secret: " + secret;
        }
      }

      var res = JSON.stringify(responseJson);
      ws.send(res);
      console.log("<- " + res);
    }
  });

  ws.on('close', function() {
    var idx = clients.indexOf(ws);
    if (idx > -1) {
      console.log("-- deleting client: " + secrets[idx]);
      delete clients[ws];
    };

    console.log('[close]\n');
  });

  ws.on('error', function(e) {
    console.log('[error]\n', e);
  });
});