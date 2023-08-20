const PrimaryInput = {
  mounted() {
    this.el.focus();

    document.addEventListener("keyup", (e) => {
      if (
        e.key === "/" &&
        document.activeElement.id !== "command-palette-search-field"
      ) {
        e.preventDefault();
        this.el.focus();
      }
    });
  },
};

export default PrimaryInput;
