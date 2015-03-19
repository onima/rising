(function() {

  var map = { width: 5, height: 6, gridWidth: 400 },
      radius = map.gridWidth / (map.width * 1.5),
      xBaseOffset = 50,
      hexagonSemiVerticalHeight = Math.sqrt(3) * radius / 2,
      yBaseOffset = 50,
      yBaseOffsetLower = yBaseOffset + hexagonSemiVerticalHeight;

  var svg = Snap("#svg");

  var findHexagonCoordinates = function findHexagonCoordinates(xCentre, yCentre, radius) {
    var hexagonCoordinates = [];
    for (var i = 0; i < 6; i++) {
      var coordinates = {
        x: radius * Math.cos(2*Math.PI*i/6) + xCentre,
        y: radius * Math.sin(2*Math.PI*i/6) + yCentre
      };
      hexagonCoordinates.push(coordinates.x, coordinates.y);
    }
   return hexagonCoordinates;
  };

  var drawMap = function drawMap(map) {

  var drawHexagonCol = function drawHexagonCol(map, x, xOffset, yOffset, widthIndex) {
    for(var j = 0; j < map.height; j++) {
      var y = j * radius * Math.sqrt(3);
      svg.polyline((findHexagonCoordinates( x + xOffset, y + yOffset, radius)));
    }
  };

    for(var k = 0; k < map.width; k++) {
      var yOffset = (k % 2 === 0) ? yBaseOffset : yBaseOffsetLower;
      drawHexagonCol(map, 1.5 * k * radius, xBaseOffset, yOffset, k);
    }
  };

  drawMap(map);
// console.log(JSON.stringify(findHexagonCoordinates(450, 450, 450)));
}) ();
