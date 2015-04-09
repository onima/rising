(function() {

  var map                       = { width: 5, height: 6 };
  var r                         = 50;
  var hexagonArray              = [];
  var svg                       = SVG('drawing').size(600, 700);
  var xhr                       = new XMLHttpRequest();

  var capitalize = function(str) {
        return str.charAt(0).toUpperCase() + str.slice(1);
  };

  xhr.onreadystatechange = alertContents;
  xhr.open('GET', 'http://localhost:9292/regions_hsh');
  xhr.send();

  function alertContents() {
    if (xhr.readyState === 4) {
      if (xhr.status === 200) {
        regions_object = JSON.parse(xhr.responseText);
        createMap(regions_object);
      } else {
        alert('There was a problem with the request.');
      }
    }
  }

  var createMap = function createMap(regions_object) {

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

  var drawMap = function drawMap(map) {

    for(var i = 1; i < map.width + 1; i++) {
      for(var j = 1; j < map.height + 1; j++) {
        var array_i_j = f(i,j);
        var coordinates = findHexagonCoordinates(array_i_j[0], array_i_j[1]);
        hexagonArray.push(svg.polyline([coordinates]).attr({ fill: regions_object[i + ',' + j].color, 'fill-opacity': 0.6, stroke: '#000', text: 'hello' }));
      }
    }
    return hexagonArray;
  };
  drawMap(map);
  };

}) ();
