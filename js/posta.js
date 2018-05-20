/* global TAG, byName, byId */

function adicionarUrl(tagNameBase, idButtonBase) {
    var len = byName(tagNameBase).length - 1;
    var input = create(TAG.input);
    setAttributes(input, [["type", "text"], ["name", tagNameBase]]);
    if (len < 9) {
        var button = create(TAG.input);
        setAttributes(button, [["type", "button"], ["value", "-"], ["name", "_" + tagNameBase]]);
        var br = create(TAG.br);
        if (len > 0) {
            insertAfter(byName("_" + tagNameBase)[len - 1], br);
        } else {
            insertAfter(byId(idButtonBase), br);
        }
        insertAllAfter(br, [button, input]);
        button.onclick = function () {
            removeElements(byId("formPost"), [input, button, br]);
        };
    }
}

function adicionarUrlVideo() {
    adicionarUrl("urlVideo", "btnAdicionarVideo");
}

function adicionarUrlImagem() {
    adicionarUrl("urlImagem", "btnAdicionarImagem");
}

function adicionarUrlSite() {
    adicionarUrl("urlSite", "btnAdicionarSite");
}

function postar() {
    let formPost = byId("formPost");
    let imagePost = formPost.imagePost.files[0];
    if (imagePost.size > megaByte(.5)) {
        alert("A imagem deve ter menos de " + 1 + "megabytes");
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
    newPost(imagePost, ajaxSendAsJson("posto", postagem, true));
}

function newPost(imagePost, ajax) {

    ajax.onreadystatechange = function () {
        if (ajaxSucces(this)) {
            resposta = JSON.parse(this.responseText);
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
    showImagem(files, img);
    insertAfter(files, img);
    if (files.files) {
        let arquivo = files.files[0];
        let xhttp = new XMLHttpRequest();
        xhttp.open("POST", "posto", true);
        xhttp.setRequestHeader("Content-type", "multipart/form-data");
        xhttp.send(arquivo);

        xhttp.onreadystatechange = function () {
            if (this.readyState === 4 && this.status === 200) {
                resposta = JSON.parse(this.responseText);
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