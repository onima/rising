(function() {

  var rulesButton = document.getElementById('rules');

  var addClickEventOnRulesButton = function addClickEventOnRulesButton() {
    rulesButton.onclick = function() {
      swal({
        title: 'Rules',
        html:
        '<b>How many players are there? </b> There are 2 players. ' +
        'Player 1 must choose between orc and humans. Player 2 will receive the other race. ' +
        'Please note that race choice has no impact on game logic.' +
        '</br>' +
        '</br>' +
        '<b>How do you win this game? </b>' +
        'You must conquer more regions than your opponent. Each region has a number of defense points.' +
        'You have only 5 troops to spend each turn.' +
        'When it\'s your turn, hover over the map and you will easily recognize conquerable regions.' +
        '</br>' +
        '</br>' +
        '<b>How long will it take to complete the game ?</b> 10 turns. When the last turn has been played by each player, the game is finished and the player who has most regions wins.' +
        '</br>' +
        '</br>' +
        '<b>I saw some T letters on certain regions... What is it?</b> Well, some regions have tribes. Once all players have had a turn, a new turn begins and those regions have new random defense points. ' +
        'Sometimes, it will be easy for you to conquer some regions, sometimes not...' +
        '</br>' +
        '</br>' +
        '<b> Why can\'t I attack blue regions ?</b> Because those regions are seas' +
        '</br>' +
        '</br>' +
        '<b> Ok, I think I understand this game</b> ' +
        '<p> Well, let\'s go !</p>',
        width: 700,
        imageUrl: 'images/rules.png',
        animation: false
      });
    };
  };

  var interactWithImages = function interactWithImages() {

    var racesImg   = document.getElementsByClassName('race-img');
    var orcImg     = racesImg[0];
    var humanImg   = racesImg[1];
    var capitalize = function capitalize(string) {
      return string.replace(/^./, capitalize.call.bind("".toUpperCase));
    };

    var sendRace   = function sendRace(img) {
      var name      = img.id;
      var parameter = encodeURI('name=' + name);
      var xhr3      = new XMLHttpRequest();

      xhr3.onreadystatechange = function() {
        if (xhr3.readyState === 4) {
          if (xhr3.status === 200 || xhr3.status === 0) {
            window.location.href = "http://localhost:9292/play_turn";
          } else {
            console.log('There was a problem with the request.');
          }
        }
      };
      xhr3.open("POST", 'http://localhost:9292/race');
      xhr3.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded ');
      xhr3.send(parameter);
    };

    var addClickEventOnPicture = function addClickEventOnPicture(img1, img2) {
      img1.addEventListener('click', function() {
        swal({
          title: "Are you sure you want to choose " + capitalize(img1.id) + "?",
          type: "info",
          showCancelButton: true,
          confirmButtonColor: "#6CDA6C",
          confirmButtonText: "Yes, I'm sure!",
          cancelButtonText: "No, not yet!",
          cancelButtonColor: "#b3b3b3",
          closeOnConfirm: false,
          closeOnCancel: false
        },
        function(isConfirm){
          if (isConfirm) {
            swal({
              title: "You choose " + capitalize(img1.id) + "!",
              text: "Player red has received the " + capitalize(img2.id) + ".  " + "Now it's time to fight !",
              imageUrl: "images/sword.png",
              showConfirmButton: true
            },
            function() {
              swal.disableButtons();
              sendRace(img1);
            });
          } else {
            swal("Well", "You can choose an other race :)", "error");
          }
        });
      });
    };
    addClickEventOnPicture(orcImg, humanImg);
    addClickEventOnPicture(humanImg, orcImg);
  };

  var sendIdAndPlayerName = function sendIdAndPlayerName(hexagonObject) {
    var hexagonId  = hexagonObject.node.id;
    var playerName = document.getElementById('player_name').innerText;
    var parameters = encodeURI('id=' + hexagonId + '&name=' + playerName);
    var xhr2       = new XMLHttpRequest();

    xhr2.onreadystatechange = function() {
      if (xhr2.readyState === 4) {
        if (xhr2.status === 200 || xhr2.status === 0) {

          var playerObj       = JSON.parse(xhr2.responseText);
          var updateGameBoard = function updateGameBoard() {
            var troopsNumber = document.getElementById('troops_number');
            var occupiedRegions = document.getElementById('occupied_regions');
            troopsNumber.innerText = playerObj.race[0].troops_number + '';
            occupiedRegions.innerText = playerObj.occupied_regions.length + '';
            showActualGameState();
          };

          updateGameBoard();
        } else {
          console.log('There was a problem with the request.');
        }
      }
    };
    xhr2.open("POST", 'http://localhost:9292/hexa_id_and_player_name');
    xhr2.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded ');
    xhr2.send(parameters);
  };

  var showActualGameState = function showActualGameState() { //object with id_regions as keys and regions_land_type as values
    var xhr = new XMLHttpRequest();

    xhr.onreadystatechange = function() {
      if (xhr.readyState === 4) {
        if (xhr.status === 200 || xhr.status === 0) {

          var regionsObject = JSON.parse(xhr.responseText);
          var divDrawing    = document.getElementById('drawing');

          if (!divDrawing.firstElementChild) {
            createMap(regionsObject);
          } else {
            while (divDrawing.firstChild) {
              divDrawing.removeChild(divDrawing.firstChild);
            }
            createMap(regionsObject);
          }

        } else {
          console.log('There was a problem with the request.');
        }
      }
    };
    xhr.open("GET", 'http://localhost:9292/regions_hsh');
    xhr.send(null);
  };

  var createMap = function createMap(regionsObject) {
    var svg           = SVG('drawing').size(600, 700);
    var map           = svg.group().addClass('map');
    var mapDimensions = { width: 5, height: 6 };
    var r             = 50;
    var actualPlayerColor = document.getElementById('player_color').innerText;

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

    var drawMap = function drawMap(mapDimensions) {
      var clickOnId = function() {
        sendIdAndPlayerName(this);
      };

      for(var i = 1; i < mapDimensions.width + 1; i++) {
        for(var j = 1; j < mapDimensions.height + 1; j++) {

          var id           = i + ',' + j;
          var arrayOfIJ    = f(i,j);
          var coordinates  = findHexagonCoordinates(arrayOfIJ[0], arrayOfIJ[1]);
          var regionObject = regionsObject[id];
          var hexagon      = svg.polyline([coordinates]).attr( {
            fill: regionObject.color,
            stroke: '#000',
            id: id
          }).addClass('hexagon');

          if (regionObject.occupied) {
            hexagon.stroke({ color: regionObject.occupied, width: 2 });
          }

          if (regionObject.attackable && regionObject.occupied !== actualPlayerColor ) {
            hexagon.addClass('attackable');
            hexagon.click(clickOnId);
          }

          if (regionObject.has_tribe) {
            svg.text('T').attr( {
              x: coordinates[6] + 45,
              y: coordinates[7] + 10
            } );
          }

          map.add(hexagon);

          svg.text(regionObject.conquest_points + '').attr( { // defense_points_text
            x: coordinates[6] + 45,
            y: coordinates[7] - 15
          });
        }
      }
    };
    drawMap(mapDimensions);
  };
  addClickEventOnRulesButton();
  showActualGameState();
  interactWithImages();

}) ();
