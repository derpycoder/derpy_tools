const CommandPalette = {
  mounted() {
    document.addEventListener("keydown", (e) => {
      if (e.key === "k" && e.metaKey) {
        e.preventDefault();
        liveSocket.execJS(this.el, this.el.getAttribute("data-show-modal"));

        this.search_results =
          Array.from(
            document.querySelectorAll("#command-palette-results>ul>li>a")
          ) || [];
        this.selected &&
          this.removeHighlight(this.search_results[this.selected]);
        this.selected = 0;
        this.highlightSelection(this.search_results[this.selected]);
      } else {
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
            target.click();
          case "Tab":
            e.preventDefault();
            console.log("Do something on tab");
          default:
            this.selected &&
              this.removeHighlight(this.search_results[this.selected]);
        }
      }
    });
    this.handleEvent("search-results-ready", () => {
      this.search_results =
        Array.from(
          document.querySelectorAll("#command-palette-results>ul>li>a")
        ) || [];

      this.selected && this.removeHighlight(this.search_results[this.selected]);
      this.selected = 0;
      this.highlightSelection(this.search_results[this.selected]);
    });
  },
  destroyed() {},
  highlightSelection(target) {
    if (!target) return;
    target.classList.add("bg-slate-900/80", "text-slate-50");
    target.scrollIntoView({
      behavior: "smooth",
      block: "center",
    });
  },
  removeHighlight(target) {
    if (!target) return;
    target.classList.remove("bg-slate-900/80", "text-slate-50");
  },
};

export default CommandPalette;
