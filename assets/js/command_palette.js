const CommandPalette = {
  mounted() {
    document.addEventListener("keydown", (e) => {
      if (e.key === "k" && e.metaKey) {
        e.preventDefault();

        const bg = document.querySelector(`#${this.el.id}-bg`);
        const container = document.querySelector(`#${this.el.id}-container`);
        const content = document.querySelector(`#${this.el.id}-content`);
        const focusable = content.querySelector(
          'button, [href], input, [tabindex="0"]'
        );

        this.el.style.display = "block";
        bg.style.display = "block";
        bg.classList.add("opacity-100");
        container.style.display = "block";
        document.body.classList.add("overflow-hidden");
        focusable.focus();
      }
    });
  },
};

export default CommandPalette;
