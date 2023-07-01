export const CommandPalette = {
  mounted() {
    document.addEventListener("keydown", (e) => {
      if (e.key === "k" && e.metaKey) {
        this.el.focus();
      }
    });
  },
};

export const PrimaryInput = {
  mounted() {
    document.addEventListener("keyup", (e) => {
      if (e.key === "/" && document.activeElement.id !== "search-box") {
        this.el.focus();
      }
    });
  },
};
