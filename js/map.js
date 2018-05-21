/* global google, byId, TAG*/

window.onload = main;
function main() {
    let script = create(TAG.script);
    setAttributes(script, [["src", "https://maps.googleapis.com/maps/api/js?key=AIzaSyBn9g5R6XM4GSxeHPwQHMX-OdqefGcBlTs&callback=initMap"], ["type", "text/javascript"]]);
    insertAfter(byId("map"), script);
}

function createMap(idElement, position, zoom) {
    return new google.maps.Map(byId(idElement), {
        zoom: zoom,
        center: position
    });
}

function createMarker(map, position, title) {
    return new google.maps.Marker({
        position: position,
        map: map,
        title: title
    });
}

function createInfoWindow(contentHtml, maxWidth) {
    return new google.maps.InfoWindow({
        content: contentHtml,
        maxWidth: maxWidth
    });

}
function createControlTagP(innerHtml, className) {
    return setAttributes(createWhithInner(TAG.p, innerHtml), [["class", className]]);
}

function createMapControls(latLng) {
    if (byId(event.latLng)) {
        alert("Já existe um evento para este local");
        return;
    }
    let div = setAttributes(create(TAG.div), [["id", latLng], ["class", "divControlMap"]]);
    let tagControls = [
        setAttributes(createWhithInner(TAG.span, "Amago"), [["class", "controlMapHead"]]),
        createControlTagP("Detalhes do registro", "controlMapDetalhes"),
        createControlTagP("Solucionar", "controlMapSolucionar"),
        createControlTagP("Atualizar", "controlMapAtualizar"),
        createControlTagP("Excluir", "controlMapExcluir")
    ];
    
    for (let item in tagControls) {
        tagControls[item].onclick = function(){
            alert(item+" Clicou em "+tagControls[item].innerHTML);
        };
        div.appendChild(tagControls[item]);        
    }
    return div;
}



function initMap() {
    let coords = byId("coords");
    let infoWindowAtual;
    let centerPosition = {lat: -11.1882, lng: -38.0032};

    var map = createMap("map", centerPosition, 14);

    var marker = createMarker(map, centerPosition, "Clique para mais detalhes");

    let infoWindowMarker = createInfoWindow('<p>Marker Location:' + marker.getPosition() + '</p>', 200);
    marker.addListener('click', function () {
        infoWindowMarker.open(map, marker);
    });

    map.addListener('mousemove', function (event) {
        displayCoordinates(event.latLng);
    });

    function displayCoordinates(pnt) {
        coords.innerHTML = "Latitude: " + pnt.lat().toFixed(4) + "  Longitude: " + pnt.lng().toFixed(4);
        posicaoAtual = pnt;
    }


    /*
     map.addListener('center_changed', function () {
     // 3 seconds after the center of the map has changed, pan back to the
     // marker.
     window.setTimeout(function () {
     map.panTo(marker.getPosition());
     }, 3000);
     });
     */
    map.addListener('dblclick', function (event) {
        let newMark = createMarker(map, event.latLng, "Clique para mais detalhes");
        let div = createMapControls(event.latLng);
        let x = '<div style="magin:auto">'
                + '<p id= "' + newMark.getPosition() + '">Localização do material: Lat:' + newMark.getPosition().lat() + "<br>Long" + newMark.getPosition().lng() + '</p>'
                + '<figure style="width:25%px; height:25%px; border:1px solid red;">'
                + '<img style="width:100%; height:100%"src="img/bot.png"/>'
                + '<figcaption>We are bots!<br/>Many bots!!!</figcaption>'
                + '</figure>'
                + '<br/>'
                + '</figcaption>'
                + '</div>';
        let infowindow = createInfoWindow(div, 180);
        newMark.addListener('click', function () {
            if (infoWindowAtual) {
                if (infoWindowAtual !== infowindow) {
                    infoWindowAtual.close();
                }
            }
            if (infoWindowAtual !== infowindow) {
                infowindow.open(map, newMark);
                infoWindowAtual = infowindow;
            }
        });
    });

}



