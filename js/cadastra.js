/* global TAG, byId */
function ex() {

    let divLogado = appendAll("logado", [
        create(TAG.h3, "h3 novo termo 11"),
        create(TAG.h3, "h3 novo termo 21"),
        create(TAG.h3, "h3 novo termo 31")
    ]);
    let colNames = ["col ano", "col dia", "col mes"];
    let rows = [
        ["ana", "maria", "juliana"]


    ];
    appendTo(divLogado, createTable(colNames, rows));
}


function value(element) {
    return element.value;
}

function loadDoc(dadosCadastro) {
    var xhttp = new XMLHttpRequest();
    xhttp.open("POST", "cadastro", true);
    xhttp.setRequestHeader("Content-type", "application/json");
    xhttp.send(dadosCadastro);

    xhttp.onreadystatechange = function () {
        if (this.readyState === 4 && this.status === 200) {
            let resposta = JSON.parse(this.responseText);
            if (resposta.status === "succes") {
                let thead = ["user name", "email", "senha"];
                let tr = [[resposta.userName, resposta.email, resposta.pass]];
                let table = createTable(thead, tr);
                table.setAttribute("id","tableCadastro");
                append("div3", table);
                alert("Vamos logar");
                window.location.href = "post";
            } else {
                alert(this.responseText);
            }
        }
    };

}

function cadastrar() {
    cadastro = document.getElementById("formCadastro");
    dados = JSON.stringify({
        "userName": value(cadastro.userName),
        "email": value(cadastro.email),
        "pass": value(cadastro.pass)
    });
    loadDoc(dados);
    cadastro.reset();
}