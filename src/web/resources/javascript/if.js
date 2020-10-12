document.onkeydown = function (event) { ifjs.keyDown(event); };
document.onkeyup = function (event) { ifjs.keyUp(event); };

const observer = new MutationObserver((mutationList, observer) => {
	for (let mutation of mutationList) {
		if (mutation.type === 'childList') {
			const node = mutation.addedNodes[0];
			if (node && node.tagName && node.tagName.toLowerCase() === 'form') {
				node.childNodes[1].innerHTML = '—';
				// No funciona correctamente en Firefox:
				// node.childNodes[2].focus({ preventScroll:true });
			}
		}
	}

	var lastInput = Array.from(document.getElementsByClassName("lineinput last"));
	if (lastInput[0]) {
		lastInput[0].scrollIntoView();
	}
});

var outputElement = document.getElementById("output");
observer.observe(outputElement, { attributes: false, childList: true, subtree: true });

var ifjs = (function (ifjs) {

  // ATRIBUTOS:

  ifjs.config = {
    highlightKeyCodes: [16, 40], // LeftShift, DownArrow
    highlightStyleId: "highlights"
  };

  // MÉTODOS PÚBLICOS:

  ifjs.clearHyperlinks = function () {
	var currentLocation = Array.from(document.getElementsByClassName("current-location"));
	currentLocation.map((item) => item.className = "previous-location");

    var remarkable = Array.from(document.getElementsByClassName("white-letters"));
    remarkable.map((item) => item.className = "");
    var dirs = Array.from(document.getElementsByClassName("red-letters"));
    dirs.map((item) => item.className = "");

    var anchors = document.getElementsByTagName("A");
    var span;
    while (anchors.length > 0) {
      span = document.createElement("SPAN");
      span.innerHTML = anchors[0].innerHTML;
      anchors[0].parentNode.replaceChild(span, anchors[0]);
    }
  };

  ifjs.keyDown = function (event) {
    if (ifjs.config.highlightKeyCodes.includes(event.keyCode)) {
      document.getElementById(ifjs.config.highlightStyleId)
        .disabled = true;
    }
  };

  ifjs.keyUp = function (event) {
    if (ifjs.config.highlightKeyCodes.includes(event.keyCode)) {
      document.getElementById(ifjs.config.highlightStyleId)
        .disabled = false;
    }
  };

  return ifjs;
}(ifjs || {}));
