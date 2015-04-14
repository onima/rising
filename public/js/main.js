(function() {

  var xhr = new XMLHttpRequest();

  xhr.onreadystatechange = function() {
    if (xhr.readyState === 4) {
      if (xhr.status === 200 || xhr.status === 0) {
        var regions_object = JSON.parse(xhr.responseText);
        createMap(regions_object);
      } else {
        console.log('There was a problem with the request.');
      }
    }
  }; 
  xhr.open("GET", 'http://localhost:9292/regions_hsh');
  xhr.send(null);

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

      for(var i = 1; i < map_dimensions.width + 1; i++) {
        for(var j = 1; j < map_dimensions.height + 1; j++) {
          var i_j_array           = f(i,j);
          var coordinates         = findHexagonCoordinates(i_j_array[0], i_j_array[1]);
          var region_object       = regions_object[i + ',' + j];
          var hexagon             = svg.polyline([coordinates]).attr( {
            fill: regions_object[i + ',' + j].color,
            stroke: '#000'
          } );
          svg.text(region_object.conquest_points + '').attr( { // defense_points_text
            x: coordinates[6] + 45,
            y: coordinates[7] - 15
          } );
          hexagon.addClass('hexagon');
          if (region_object.attackable) {
            hexagon.addClass('attackable');
          }
          map.add(hexagon);
        }
      }
    };
    drawMap(map_dimensions);
  };

}) ();
