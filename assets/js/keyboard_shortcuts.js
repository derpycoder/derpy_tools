const PrimaryInput = {
  mounted() {
    document.addEventListener("keyup", (e) => {
      if (e.key === "/" && document.activeElement.id !== "search-box") {
        e.preventDefault();
        this.el.focus();
      }
    });
  },
};

export default PrimaryInput;
