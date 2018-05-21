
/* global TAG, byId, byClass */
window.addEventListener("resize", function () {
    let myAjustNodes = byClass("ajusteFrame");
    for (let myLine in myAjustNodes) {
        if (myAjustNodes[myLine].parentNode) {
            let ajusteNode = myAjustNodes[myLine];
            let value = parseInt(ajusteNode.value);
            let myFrames = ajusteNode.parentNode.getElementsByTagName(TAG.iframe);
            for (let item in myFrames) {
                if (myFrames[item].parentNode) {
                    myFrames[item].style.height = (window.innerWidth / value) + "px";
                }
            }
        }
    }
});

