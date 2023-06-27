const CommandPallete = {
  mounted() {
    document.addEventListener("keydown", (e) => {
      if (e.key === "k" && e.metaKey) {
        this.el.focus();
      }
    });
  },
};

export default CommandPallete;
