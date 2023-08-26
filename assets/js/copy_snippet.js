const CopySnippet = {
  tooltipTimeout: null,
  mounted() {
    this.el.addEventListener("click", () => {
      let { target } = this.el.dataset;

      target = document.querySelector(`#${target}-container pre`);
      if (!target) return;

      target.focus();

      navigator.clipboard.writeText(target.textContent);
      this.el.classList.add("active");

      if (this.tooltipTimeout) clearTimeout(this.tooltipTimeout);

      this.tooltipTimeout = setTimeout(
        () => this.el.classList.remove("active"),
        1000
      );
    });
  },
};

export default CopySnippet;
