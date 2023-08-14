export const CommandPalette = {
  mounted() {
    document.addEventListener("keydown", (e) => {
      if (e.key === "k" && e.metaKey) {
        e.preventDefault();
        this.el.focus();
      }
    });
  },
};

export const PrimaryInput = {
  mounted() {
    document.addEventListener("keyup", (e) => {
      if (e.key === "/" && document.activeElement.id !== "search-box") {
        e.preventDefault();
        this.el.focus();
      }
    });
  },
};
