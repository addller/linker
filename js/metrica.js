/* global TAG, byId, body */


let bodyToMetrica = body();
let elementoAlvo = byId("metrica");
let divMetrica = setAttributes(create(TAG.div), [["id", "mostrarMetrica"]]);
let pMetrica = createWhithTextNode(TAG.p, "Métrica ativa: Largura & altura");
divMetrica.appendChild(pMetrica);
bodyToMetrica.appendChild(divMetrica);
window.addEventListener("resize",function () {    
    pMetrica.innerHTML
            =
            "Métricas:<br/>"
            + elementoAlvo
            + "<br/><br/>largura: "
            + elementoAlvo.offsetWidth
            + "<br/>& altura: "
            + elementoAlvo.offsetHeight
            + "<br/>& window width " + window.innerWidth;
});

