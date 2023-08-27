const CopySnippet = {
  tooltipTimeout: null,
  mounted() {
    this.el.addEventListener("click", this.handleClick.bind(this));
  },
  destroyed() {
    this.el.removeEventListener("click", this.handleClick.bind(this));

    if (this.tooltipTimeout) {
      clearTimeout(this.tooltipTimeout);
      this.tooltipTimeout = null;
    }
  },
  handleClick() {
    let { target, targetLines } = this.el.dataset;

    target = document.querySelector(`#${target}-container pre`);
    if (!target) return;

    if (targetLines) {
      targetLines = targetLines.split(",");
      targetSpans = target.querySelectorAll("code > span");
      let textContents = targetLines.map((targetLine) => {
        return targetSpans[parseInt(targetLine)].textContent.replace(
          /^[\$❯] /,
          ""
        );
      });

      navigator.clipboard.writeText(textContents.join(""));
    } else {
      navigator.clipboard.writeText(target.textContent);
    }

    this.el.classList.add("active");

    if (this.tooltipTimeout) clearTimeout(this.tooltipTimeout);

    this.tooltipTimeout = setTimeout(
      () => this.el.classList.remove("active"),
      1000
    );
  },
};

export default CopySnippet;
