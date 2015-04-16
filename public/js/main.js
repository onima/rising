(function() {

  var sendHexagonObjectToServer = function sendIdToServer(hexagon_object) { //send id in string format
    var hexagon_id = hexagon_object.node.id;
    var playerName = document.getElementById('player_name').innerText;
    var xhr_2 = new XMLHttpRequest();
    xhr_2.onreadystatechange = function() {
      if (xhr_2.readyState === 4) {
        if (xhr_2.status === 200 || xhr_2.status === 0) {
          var playerObj = JSON.parse(xhr_2.responseText);
          var updateGameBoard = function updateGameBoard() {
            var troopsNumber = document.getElementById('troops_number');
            troopsNumber.innerText = playerObj.races[0].troops_number + '';
            hexagon_object.stroke({ color: playerObj.color, width: 2 });
            hexagon_object.removeClass('attackable');
          };
          updateGameBoard();
        } else {
          console.log('There was a problem with the request.');
        }
      }
    };
    xhr_2.open("POST", 'http://localhost:9292/hexa_id');
    xhr_2.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded ');
    var parameters = encodeURI("id=" + hexagon_id + '&name=' + playerName);
    xhr_2.send(parameters);
  };

  var retrieveRegionsFromServer = function retrieveRegionsFromServer() { //object with id_regions as keys and regions_land_type as values
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
      if (xhr.readyState === 4) {
        if (xhr.status === 200 || xhr.status === 0) {
          var regionsObject = JSON.parse(xhr.responseText);
          createMap(regionsObject);
//          retrieveRegionsAttackablesFromServer(map);
        } else {
          console.log('There was a problem with the request.');
        }
      }
    };
    xhr.open("GET", 'http://localhost:9292/regions_hsh');
    xhr.send(null);
  };
/*
  var retrieveRegionsAttackablesFromServer = function retrieveRegionsAttackablesFromServer(map) {
    var xhr_3 = new XMLHttpRequest();
    xhr_3.onreadystatechange = function() {
      if (xhr_3.readyState === 4) {
        if (xhr_3.status === 200 || xhr_3.status === 0) {
          var regionsAttackables = JSON.parse(xhr_3.responseText);
        } else {
          console.log('There was a problem with the request.');
        }
      }
    };
    xhr_3.open("GET", 'http://localhost:9292/regions_attackable');
    xhr_3.send(null);
  };
*/

  retrieveRegionsFromServer();

  var createMap = function createMap(regions_object) {

    var svg                       = SVG('drawing').size(600, 700);
    var map                       = svg.group().addClass('map');
    var map_dimensions            = { width: 5, height: 6 };
    var r                         = 50;

    var findHexagonCoordinates = function findHexagonCoordinates(xCentre, yCentre) {
      var hexagonCoordinates = [];
      for (var k = 0; k < 7; k++) {
        var coordinates = {
          x: r * Math.cos(2*Math.PI*k/6) + xCentre,
          y: r * Math.sin(2*Math.PI*k/6) + yCentre
        };
        hexagonCoordinates.push(coordinates.x, coordinates.y);
      }
      return hexagonCoordinates;
    };

    var f = function f(i,j) {
      var x = 1.5 * i * r;
      var y = i % 2 === 0 ? Math.sqrt(3) * j * r : Math.sqrt(3) * j * r + ((Math.sqrt(3) / 2) * r);
      return [x, y];
    };

    var drawMap = function drawMap(map_dimensions) {
      var clickOnId = function() {
        sendHexagonObjectToServer(this);
      };
      for(var i = 1; i < map_dimensions.width + 1; i++) {
        for(var j = 1; j < map_dimensions.height + 1; j++) {
          var id                  = i + ',' + j;
          var i_j_array           = f(i,j);
          var coordinates         = findHexagonCoordinates(i_j_array[0], i_j_array[1]);
          var region_object       = regions_object[id];
          var hexagon             = svg.polyline([coordinates]).attr( {
            fill: regions_object[id].color,
            stroke: '#000',
            id: id
          });
          svg.text(region_object.conquest_points + '').attr( { // defense_points_text
            x: coordinates[6] + 45,
            y: coordinates[7] - 15
          });
          hexagon.addClass('hexagon');
          if (region_object.attackable) {
            hexagon.addClass('attackable');
            hexagon.on('click', clickOnId);
          }
          map.add(hexagon);
        }
      }
    };
    drawMap(map_dimensions);
    return map;
  };

}) ();
