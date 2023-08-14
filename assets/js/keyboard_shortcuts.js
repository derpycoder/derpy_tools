export const CommandPalette = {
  mounted() {
    document.addEventListener("keydown", (e) => {
      if (e.key === "k" && e.metaKey) {
        e.preventDefault();
        this.el.focus();
      } else if (e.key === "p" && e.metaKey) {
        e.preventDefault();
        console.log("Cmd + p", this.el);
        this.el.style.display = "block";
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
