(function() {

  var map                       = { width: 5, height: 6, gridWidth: 400 };
  var radius                    = map.gridWidth / (map.width * 1.5);
  var xBaseOffset               = 55;
  var hexagonSemiVerticalHeight = Math.sqrt(3) * radius / 2;
  var yBaseOffset               = 50;
  var yBaseOffsetLower          = yBaseOffset + hexagonSemiVerticalHeight;
  var hexagonArray              = [];
  var svg                       = Snap("#svg");

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
      hexagonArray.push(svg.polyline((findHexagonCoordinates( x + xOffset, y + yOffset, radius))));
    }
  };

    for(var k = 0; k < map.width; k++) {
      var yOffset = (k % 2 === 0) ? yBaseOffset : yBaseOffsetLower;
      drawHexagonCol(map, 1.5 * k * radius, xBaseOffset, yOffset, k);
    }
  };

//  var assignHexagonColors = function () {
//    var hexagonColors = ["#FF8C00", "#228B22", "#FFD700", "#708090", "#333300"];
//    var hexagonSea = [hexagonArray[0], hexagonArray[15], hexagonArray[29]];
//    var rand = hexagonColors[Math.floor(Math.random() * hexagonColors.length)];
//
//    hexagonArray.forEach(function(hexagon) {
//      hexagon.attr({ fill: rand });
//    });
//
//    hexagonSea.forEach(function(hexagon) {
//      hexagon.attr({ fill: "#2266bb"});
//    });
//  };

  drawMap(map);
//  assignHexagonColors();
// console.log(JSON.stringify(findHexagonCoordinates(450, 450, 450)));
}) ();
