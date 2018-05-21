/* global TAG, byId, body, ajaxSendAsJson, setAttribute */
let isLogado = {"action": "read", "status": "informational"};

function reTrigger() {
    ajaxSendAsJson("acesso", isLogado).onreadystatechange = function () {
        if (ajaxSucces(this)) {
            let resposta = ajaxParseJson(this);
            if (resposta.mensagem === "true") {
                alert("Redirecionando para: " + resposta.dados);
                triggerRedirect(resposta.dados);
            } else {
                showBody();
            }
        }
    };
}

function enviarCadastro(dadosCadastro) {
    ajaxSendAsJson("acesso", dadosCadastro).onreadystatechange = function () {
        if (ajaxSucces(this)) {
            let resposta = ajaxParseJson(this);
            if (resposta.status === "redirect") {
                byId("formCadastro").reset();
                alert(resposta.mensagem);
                redirect(resposta.dados);
            } else {
                alert(this.responseText);
            }
        }
    };
}

function cadastrar() {
    let formCadastro = document.getElementById("formCadastro");
    let dadosCadastro = {
        "action": "create",
        "loginName": value(formCadastro.loginName),
        "email": value(formCadastro.email),
        "pass": value(formCadastro.pass)
    };
    enviarCadastro(dadosCadastro);
}

