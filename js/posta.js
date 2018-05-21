/* global TAG, byName, byId, byClass, body, setAttributes */
window.onunload = function () {
    byId("formPost").reset();
};

function adicionarUrl(tagNameBase) {
    let len = byName(tagNameBase).length - 1;
    if (len < 9) {
        let textLabel = tagNameBase.replace("url", "");
        let input = create(TAG.input);
        let atributos = [
            ["type", "text"],
            ["name", tagNameBase],
            ["onchange", "validarUrl()"],
            ["placeholder", textLabel]
        ];
        setAttributes(input, atributos);
        let button = setAttributes(create(TAG.input), [["type", "button"], ["value", "-"], ["name", "_" + tagNameBase]]);
        let span = setAttributes(create(TAG.span), [["class", "validate"]]);
        let label = createWhithTextNode(TAG.label, textLabel + " url");
        let newP = create(TAG.p);
        appendAll(newP, [label, input, span, button]);

        if (len > 0) {
            insertAfter(byName("_" + tagNameBase)[len - 1].parentNode, newP);
        } else {
            insertAfter(byId(tagNameBase), newP);
        }
        button.onclick = function () {
            byId("formPost").removeChild(newP);
        };

        label.onclick = function () {
            input.focus();
        };
    }
}

function validarUrl() {
    let source = getSource();
    let sibling = source.nextSibling;
    sibling = /.*text.*/i.test(sibling) ? sibling.nextSibling : sibling;
    alterarIconValidate(sibling, /https?:\/\/.*/.test(value(source)));
}

function alterarIconValidate(node, isOn) {
    node.style.background = 'url("img/sprite_padrao_' + (isOn ? "on" : "off") + '.png") -176.5px -143px';
}

function adicionarUrlVideo() {
    adicionarUrl("urlVideo");
}

function adicionarUrlImagem() {
    adicionarUrl("urlImagem");
}

function adicionarUrlSite() {
    adicionarUrl("urlSite");
}

function postar() {
    let formPost = byId("formPost");
    let imagePost = formPost.imagePost.files[0];
    if (imagePost.size > megaByte(2)) {
        alert("A imagem deve ter menos de " + 2 + "megabytes");
        return;
    }
    let postagem = {"videos": addFromNodeList([], byName("urlVideo")),
        "imagens": addFromNodeList([], byName("urlImagem")),
        "sites": addFromNodeList([], byName("urlSite")),
        "titulo": formPost.txtTitulo.value,
        "descricao": formPost.txtDescricao.value,
        "patrocinadores": formPost.txtPatrocinador.value,
        "nameImagePost": imagePost.name,
        "typeImagePost": imagePost.type
    };
    newPost(imagePost, ajaxSendAsJson("posto", postagem));
}

function newPost(imagePost, ajax) {

    ajax.onreadystatechange = function () {
        if (ajaxSucces(this)) {
            resposta = ajaxParseJson(this);
            if (resposta.status === "succes") {
                alert(this.responseText);
                enviarImagem(imagePost);
            } else {
                alert("erro: " + this.responseText);
            }
        }
    };
}

function enviarImagem(imageFile) {
    let files = byId("formPost").imagePost;
    let img = create(TAG.img);
    showImagem(imageFile, img);
    insertAfter(byId("imgPost"), img);
    if (files.files) {
        let arquivo = files.files[0];
        let xhttp = new XMLHttpRequest();
        xhttp.open("POST", "posto", true);
        xhttp.setRequestHeader("Content-type", "multipart/form-data");
        xhttp.send(arquivo);

        xhttp.onreadystatechange = function () {
            if (ajaxSucces(this)) {
                let resposta = ajaxParseJson(this);
                if (resposta.status === "succes") {
                    alert(this.responseText);
                } else {
                    alert("erro: " + this.responseText);
                }
            }
        };
    }
}

function alterarImagemPost() {
    let newImage = byId("formPost").imagePost.files[0];
    showBackGroundImage(newImage, byId("imgPost"));

}

function showBackGroundImage(imageFile, elementTarget) {
    let reader = new FileReader();
    reader.onload = function () {
        elementTarget.style.backgroundImage = "url(" + reader.result + ")";
    };
    reader.readAsDataURL(imageFile);
}

function showImagem(imageFile, imgTarget) {
    let reader = new FileReader();
    reader.onload = function (e) {
        imgTarget.src = e.target.result;
    };
    reader.readAsDataURL(imageFile);
}

function atualizarTitulo() {
    let titulo = value(byId("forTitulo"));
    byId("tituloPost").innerHTML = titulo ? titulo : "Novo Post";
}

function limparValidate() {
    let validates = byClass("validate");
    for (var index in validates) {
        if (/.*span.*/i.test(validates[index])) {
            alterarIconValidate(validates[index]);
        }
    }
}