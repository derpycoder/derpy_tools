const CommandPalette = {
  mounted() {
    document.addEventListener("keydown", (e) => {
      if (e.key === "k" && e.metaKey) {
        e.preventDefault();
        liveSocket.execJS(this.el, this.el.getAttribute("data-show-modal"));
      }
    });
  },
};

export default CommandPalette;
