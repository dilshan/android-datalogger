//////////////////////////////////////////////////////////////////////////////////////////////
// Sensor framework - Raspberry Pi micro web server.
//
// Last update: 	05-07-2018 10:56PM.
// Author: 			Dilshan R Jayakody [jayakody2000lk@gmail.com]
// Platform: 		Raspberry Pi 3 Model B+
//
// Copyright (C) 2018 Dilshan R Jayakody.
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.
//////////////////////////////////////////////////////////////////////////////////////////////

var express = require('express');
var bodyParser = require('body-parser');
var Gpio = require('onoff').Gpio;

var webApp = express();

var sensor1 = new Gpio(21, 'in', 'none');
var sensor2 = new Gpio(13, 'in', 'none');
var sensor3 = new Gpio(4, 'in', 'none');
var sensor4 = new Gpio(5, 'in', 'none');
var sensor5 = new Gpio(6, 'in', 'none');
var sensor6 = new Gpio(7, 'in', 'none');
var sensor7 = new Gpio(8, 'in', 'none');
var sensor8 = new Gpio(9, 'in', 'none');
var sensor9 = new Gpio(10, 'in', 'none');
var sensor10 = new Gpio(19, 'in', 'none');

var channel1 = new Gpio(12, 'out');
var channel2 = new Gpio(16, 'out');
var channel3 = new Gpio(20, 'out');

var triggerAlm = new Gpio(26, 'out');

var sensor = [sensor1, sensor2, sensor3, sensor4, sensor5, sensor6, sensor7, sensor8, sensor9, sensor9, sensor10];

webApp.use(bodyParser.urlencoded({ extended: true }));
webApp.use(bodyParser.json());

var router = express.Router();

router.post('/', function(req, res) {
	var chBinary = parseInt(req.body.sensorId, 10).toString(2);
	var triggerData = (typeof req.body.trigger == 'undefined') ? 0 : parseInt(req.body.trigger);

	if(chBinary.length == 1) {
		chBinary = "00" + chBinary;
	}
	else if(chBinary.length == 2) {
		chBinary = "0" + chBinary;
	}

	var chBit0 = parseInt(chBinary[2]);
	var chBit1 = parseInt(chBinary[1]);
	var chBit2 = parseInt(chBinary[0]);

	channel1.writeSync(chBit0);
	channel2.writeSync(chBit1);
	channel3.writeSync(chBit2);

	triggerAlm.writeSync(triggerData > 0 ? 1 : 0);

	setTimeout(function() {

		var val = 0;

		for(var pos = 0; pos < 11; pos++) {
			val += (sensor[pos].readSync() << pos);
		}

		res.json({ "sensorId": req.body.sensorId, "sensorValue" : val });

	}, 125);
});

webApp.use('/api', router);
webApp.listen(8080);
