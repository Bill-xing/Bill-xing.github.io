(function () {
  function renderMermaidBlocks() {
    var blocks = document.querySelectorAll("pre > code.language-mermaid");
    if (!blocks.length || !window.mermaid) {
      return;
    }

    window.mermaid.initialize({
      startOnLoad: false,
      securityLevel: "loose",
      theme: "default",
      flowchart: {
        htmlLabels: true,
        curve: "basis"
      }
    });

    blocks.forEach(function (code, index) {
      var source = code.textContent.trim();
      if (!source) {
        return;
      }

      var container = document.createElement("div");
      container.className = "mermaid";
      container.id = "mermaid-diagram-" + index;
      container.textContent = source;

      var wrapper = code.closest(".highlighter-rouge") || code.closest("pre");
      wrapper.parentNode.replaceChild(container, wrapper);
    });

    window.mermaid.run({
      querySelector: ".mermaid"
    });
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", renderMermaidBlocks);
  } else {
    renderMermaidBlocks();
  }
})();
