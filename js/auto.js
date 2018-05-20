function auto() {

    let formAuto = byId("formAuto");
    let arquivo = formAuto.files.files[0];

    let dados = {
        "arquivoName": arquivo.name,
        "arquivoType": arquivo.type,
        "txtName": formAuto.name.value
    };
    enviarDadosPostagem(ajaxSendAsJson("autotest", dados, true), arquivo);
}

function enviarDadosPostagem(ajax, arquivo) {
    ajax.onreadystatechange = function () {
        if (ajaxSucces(ajax)) {
            let resposta = JSON.parse(this.responseText);
            if (resposta.status === "succes") {
                alert("enviar o complemento " + arquivo.name);
                enviarImagemPostagem(ajaxSendFile("autotest", arquivo, true));
            } else {
                alert("None " + JSON.stringify(resposta));
            }
        }
    };
}

function enviarImagemPostagem(ajax) {
    ajax.onreadystatechange = function () {
        if (ajaxSucces(ajax)) {
            let resposta = JSON.parse(this.responseText);
            if (resposta.status === "succes") {
                alert("Atualizar a tela " + JSON.stringify(resposta));
            } else {
                alert("Tratar erro " + JSON.stringify(resposta));
            }
        }
    };
}
