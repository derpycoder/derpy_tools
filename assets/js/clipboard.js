const Clipboard = {
  mounted() {
    const initialInnerHTML = this.el.innerHTML;

    this.el.addEventListener("click", () => {
      const { content } = this.el.dataset;
      navigator.clipboard.writeText(content);

      this.el.innerHTML = "Copied!";

      setTimeout(() => {
        this.el.innerHTML = initialInnerHTML;
      }, 2000);
    });
  },
};

export default Clipboard;
