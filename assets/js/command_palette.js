const CommandPalette = {
  mounted() {
    document.addEventListener("keydown", (e) => {
      if (e.key === "k" && e.metaKey) {
        e.preventDefault();
        this.el.focus();
      } else if (e.key === "p" && e.metaKey) {
        e.preventDefault();

        const bg = document.querySelector(`#${this.el.id}-bg`);
        const container = document.querySelector(`#${this.el.id}-container`);
        const content = document.querySelector(`#${this.el.id}-content`);

        this.el.style.display = "block";
        bg.style.display = "block";
        bg.classList.add("opacity-100");
        container.style.display = "block";
        document.body.classList.add("overflow-hidden");
        content.focus();
      }
    });
  },
};

export default CommandPalette;
