(function() {

  var map                       = { width: 5, height: 6 };
  var r                         = 50;
  var hexagonSemiVerticalHeight = Math.sqrt(3) * r / 2;
  var hexagonArray              = [];
  var svg                       = SVG('drawing').size(600, 700);
  var xhr                       = new XMLHttpRequest();

  xhr.onreadystatechange = alertContents;
  xhr.open('GET', 'http://localhost:9292/regions_hsh');
  xhr.send();

  function alertContents() {
    if (xhr.readyState === 4) {
      if (xhr.status === 200) {
        regions_object = JSON.parse(xhr.responseText);
      } else {
        alert('There was a problem with the request.');
      }
    }
  }

  var createMap = function createMap() {

  var findHexagonCoordinates = function findHexagonCoordinates(xCentre, yCentre) {
    var hexagonCoordinates = [];
    for (var k = 0; k < 6; k++) {
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

    for(var i = 0; i < map.width; i++) {
      for(var j = 0; j < map.height; j++) {
        var array_i_j = f(i,j);
        var coordinates = findHexagonCoordinates(array_i_j[0] + 50, array_i_j[1] + 50);
        hexagonArray.push(svg.polyline([coordinates]));
      }
    }
    return hexagonArray;
  };
  drawMap(map);
  };

  createMap();

}) ();
