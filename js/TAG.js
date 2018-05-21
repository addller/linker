const TAG = {
    "hgroup": "hgroup", "h1": "h1", "h2": "h2", "h3": "h3", "h4": "h4", "h5": "h5",
    "form": "form",
    "table": "table", "thead": "thead", "tbody": "tbody", "tfoot": "tfoot",
    "tr": "tr", "th": "th", "td": "td",
    "fieldset": "fieldset",
    "input": "input",
    "script": "script",
    "p": "p",
    "span": "span",
    "iframe": "iframe",
    "div": "div",
    "section": "section",
    "aside": "aside",
    "a": 'a',
    "br": "br",
    "label": "label",
    "button": "button",
    "img": "img",
    "trigger": "trigger"
};

/**
 * Ok
 * Cria um elemento htmo
 * @param element {String} elemento html que deseja criar
 * @returns {Element} o elemento que foi criado
 */
function create(element) {
    return document.createElement(element);
}

/**
 * Ok
 * Cria um elemento e insere um texto nele
 * @param element {String} elemento que deseja criar
 * @param text {String} a ser inserido no elemento
 * @returns {Element} retorna o elemento que foi criado
 */
function createWhithInner(tag, text) {
    let node = document.createElement(tag);
    node.innerHTML = text;
    return node;
}

function createWhithTextNode(tag, text) {
    let node = document.createElement(tag);
    node.appendChild(document.createTextNode(text));
    return node;
}

/**
 * Ok
 * @param id {Element} o id procurado
 * @returns {Element} retorna o elemento procurado pelo id
 */
function byId(id) {
    return document.getElementById(id);
}

function byName(name) {
    return document.getElementsByName(name);
}

function byTagName(name) {
    return document.getElementsByTagName(name);
}

function byClass(className) {
    return document.getElementsByClassName(className);
}

function insertAllAfter(parent, childs) {
    len = childs.length;
    for (var i = 0; i < len; i++) {
        insertAfter(parent, childs[i]);
    }
}

function removeElements(parent, childs) {
    len = childs.length;
    for (var i = 0; i < len; i++) {
        parent.removeChild(childs[i]);
    }
}
function setAttributes(node, matriz) {
    for (var linha in matriz) {
        node.setAttribute(matriz[linha][0], matriz[linha][1]);
    }
    return node;
}

function setAttribute(node, vetor) {
    node.setAttribute(vetor[0], vetor[1]);
    return node;
}



function insertAfter(referenceNode, newNode) {
    referenceNode.parentNode.insertBefore(newNode, referenceNode.nextSibling);
}

function insertBefore(referenceNode, newNode) {
    referenceNode.parentNode.insertBefore(newNode, referenceNode);
}


/**
 * Ok
 * recebe um ARRAY de elementos a serem apensados ao nó pai
 * @param parentId {String} parent nó pai
 * @param childrens {Blue} um ou mais nós a serem apensados ao nó pai
 * @returns {Element} retorno o nó pai
 */
function appendAll(parentNode, childrens) {
    if (childrens) {
        count = 0;
        while (childrens[count]) {
            parentNode.appendChild(childrens[count++]);
        }
    }
}

/**
 * @param {Element} parent node pai
 * @param {Element} children node filho
 * @returns {Element} retorna o node pai
 */
function appendTo(parent, children) {
    parent.appendChild(children);
}

/**
 * 
 * @param {String} parentId encontra o node pai pelo id
 * @param {Element} children node filho
 * @returns {Element} retorna o node pai 
 */
function append(parentId, children) {
    parent = byId(parentId);
    parent.appendChild(children);
    return parent;
}

/**
 * 
 * @param {Array} colNames nome das colunas
 * @param {Matriz} rows que compões a tabela
 * @returns {Element|Node|table}
 */
function createTable(colNames, rows) {
    table = create(TAG.table);
    thead = create(TAG.thead);
    tbody = create(TAG.tbody);
    thead.appendChild(createRow(colNames, false));
    for (var row in rows) {
        tbody.appendChild(createRow(rows[row], true));
    }
    table.appendChild(thead);
    table.appendChild(tbody);
    return table;
}

/**
 * 
 * @param {Cel} rowData pode ser th ou tr
 * @param {Boolean} isTableData se true temos trata-se de td, se não th
 * @returns {Element|Node|tr}
 */
function createRow(rowData, isTableData) {
    tr = create(TAG.tr);
    if (rowData) {
        index = 0;
        while (rowData[index]) {
            cel = createWhithTextNode(isTableData ? TAG.td : TAG.th, rowData[index++]);
            tr.appendChild(cel);
        }
    }
    return tr;
}

function addFromNodeList(array, itens) {
    for (var i = 0; i < itens.length; i++) {
        array.push(itens[i].value);
    }
    return array;
}

function ajaxSucces(ajax) {
    return ajax.readyState === 4 && ajax.status === 200;
}
function ajaxParseJson(ajax) {
    let resposta = JSON.parse(ajax.responseText);
    return resposta;
}

function ajaxSendAsJson(url, toJson) {
    let ajax = new XMLHttpRequest();
    ajax.open("POST", url, true);
    ajax.setRequestHeader("Content-type", "application/json");
    ajax.send(JSON.stringify(toJson));
    return ajax;
}

function ajaxSendFile(url, file) {
    let ajax = new XMLHttpRequest();
    ajax.open("POST", url, true);
    ajax.setRequestHeader("Content-type", "multipart/form-data");
    ajax.send(file);
    return ajax;
}

function kiloByte(value) {
    return parseInt((value * 1024));
}

function megaByte(value) {
    return parseInt((kiloByte(value) * 1024));
}

function value(element) {
    return element.value;
}

function getSource() {
    let source = window.event.target || window.event.srcElement;
    return source;
}

function getEvent(event) {
    event = event || window.event;
    return event;
}

function body() {
    return document.body;
}

function hideBody() {
    hide(body());
}

function showBody() {
    show(body());
}

function hide(element) {
    element.style.display = "none";
}

function show(element) {
    element.style.display = "block";
}

function redirect(namePage) {
    window.location.href = namePage;
}

function pushState() {
    window.history.pushState("", "", "/");
}

function trigger() {
    hideBody();
    let atributos = [
        ["id", TAG.trigger],
        ["method", "POST"],
        ["class", "hide"]
    ];
    let form = setAttributes(create(TAG.form), atributos);
    insertBefore(byTagName(TAG.script)[0], form);
    reTrigger();
}

function triggerRedirect(namePage) {
    setAttribute(byId(TAG.trigger), ["action", namePage]).submit();
}

function retangulo(element) {
    let dado = element.getBoundingClientRect();

    let retorno = {
        "x0": dado.left,
        "x1": dado.right,
        "y0": dado.top,
        "y1": dado.bottom,
        "literal": ""
    };
    retorno.literal = element + ": (x0,y0)[" + retorno.x0 + "," + retorno.y0
            + "] (x1,y1)[" + retorno.x1 + "," + retorno.y1 + "]";
    return retorno;
}

let getMousePosition;
let c = 0;

function monitoreBodyMousePosition() {

    if (!getMousePosition) {
        getMousePosition = {"x": 0,
            "y": 0
        };
        document.body.onmousemove = function (e) {
            byId("metrica").innerHTML = " - c" + c++;

            getMousePosition.x = e.clientX;
            getMousePosition.y = e.clientY;
            getMousePosition.literal = "Mouse position: (x,y)[" + getMousePosition.x + "," + getMousePosition.y + "]";
        };

    }
}
//não está verificando se o elemento está escondido
function isMouseOver(element) {

    if (element.style) {
        let pos = retangulo(element);
        let x = getMousePosition.x;
        let y = getMousePosition.y;

        if (pos.x0 <= x && x <= pos.x1) {
            return pos.y0 <= y && y <= pos.y1;
        }
    }
    return false;
}

function display(element, value, opacity) {
    element.style.display = value;
    if (opacity) {
        element.style.opacity = opacity;
    }
}