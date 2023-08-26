const CommandPalette = {
  mounted() {
    const handleKeyDown = (e) => {
      switch (e.key) {
        case "ArrowUp":
          e.preventDefault();

          this.removeHighlight(this.search_results[this.selected]);
          this.selected =
            (this.selected - 1 + this.search_results.length) %
            this.search_results.length;

          this.highlightSelection(this.search_results[this.selected]);

          break;
        case "ArrowDown":
          e.preventDefault();

          this.removeHighlight(this.search_results[this.selected]);
          this.selected = (this.selected + 1) % this.search_results.length;

          this.highlightSelection(this.search_results[this.selected]);

          break;
        case "Enter":
          e.preventDefault();
          const target = this.search_results[this.selected];

          if (target) {
            clickableTarget = target.querySelector(
              "a, button, [data-clickable]"
            );
            clickableTarget && clickableTarget.click();
          }
          break;
        case "Tab":
          e.preventDefault();
          console.log("Do something on tab");
          break;
        case "Escape":
          e.preventDefault();
          break;
      }
    };

    document.addEventListener("keydown", (e) => {
      if (e.key === "k" && e.metaKey) {
        e.preventDefault();
        liveSocket.execJS(this.el, this.el.getAttribute("data-show-modal"));

        !this.search_results && this.fetchDomNodes().bind(this);
      } else {
        this.el.addEventListener("keydown", handleKeyDown);
      }
    });

    this.handleEvent("search-results-ready", this.fetchDomNodes.bind(this));
  },
  highlightSelection(target) {
    if (!target) return;
    target.setAttribute("aria-selected", true);
    target.scrollIntoView({
      behavior: "smooth",
      block: "center",
    });
  },
  removeHighlight(target) {
    if (!target) return;
    target.setAttribute("aria-selected", false);
  },
  fetchDomNodes() {
    this.search_results =
      Array.from(
        document.querySelectorAll("#command-palette-results > ul > li")
      ) || [];

    this.selected && this.removeHighlight(this.search_results[this.selected]);
    this.selected = 0;
    this.highlightSelection(this.search_results[this.selected]);
  },
};

export default CommandPalette;
