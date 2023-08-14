export const CommandPalette = {
  mounted() {
    document.addEventListener("keydown", (e) => {
      e.preventDefault();
      if (e.key === "k" && e.metaKey) {
        this.el.focus();
      }
    });
  },
};

export const PrimaryInput = {
  mounted() {
    document.addEventListener("keyup", (e) => {
      e.preventDefault();
      if (e.key === "/" && document.activeElement.id !== "search-box") {
        this.el.focus();
      }
    });
  },
};
