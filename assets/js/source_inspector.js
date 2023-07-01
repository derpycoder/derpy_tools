import { computePosition, flip, offset, arrow } from "../vendor/floating-ui";

const SourceInspector = {
  mounted() {
    if (!this.el.dataset) {
      console.log("Please pass in file & line data attributes!");
      return;
    }

    const globalTooltip = document.querySelector("#inspector-tooltip");

    let tooltip = globalTooltip.cloneNode(true);
    tooltip.setAttribute("id", `inspect-${this.el.id}`);
    const inspectSourceBtn = tooltip.querySelector("#source-btn");
    const arrowElement = tooltip.querySelector("#arrow");

    this.el.addEventListener("mouseenter", (e) => {
      const { file, line } = this.el.dataset;

      this.el.appendChild(tooltip);

      tooltip.classList.remove("hidden");
      tooltip.classList.add("flex");

      placeTooltip(this.el, tooltip, arrowElement);

      this.el.classList.add(
        "rounded-lg",
        "outline",
        "outline-offset-4",
        "outline-pink-500"
      );

      inspectSourceBtn.setAttribute("phx-value-file", file);
      inspectSourceBtn.setAttribute("phx-value-line", line);
    });
    this.el.addEventListener("mouseleave", (e) => {
      handleMouseLeave(this.el, tooltip);
    });
  },
};

function handleMouseLeave(target, tooltip) {
  target.classList.remove(
    "rounded-lg",
    "outline",
    "outline-offset-4",
    "outline-pink-500"
  );

  tooltip.classList.add("hidden");
  tooltip.classList.remove("flex");
}

function placeTooltip(target, tooltip, arrowElement) {
  computePosition(target, tooltip, {
    placement: "top",
    middleware: [
      flip(),
      offset(8),
      arrow({
        element: arrowElement,
      }),
    ],
  }).then(({ x, y, placement, middlewareData }) => {
    Object.assign(tooltip.style, {
      left: `${x}px`,
      top: `${y}px`,
    });

    const { x: arrowX, y: arrowY } = middlewareData.arrow;

    const staticSide = {
      top: "bottom",
      right: "left",
      bottom: "top",
      left: "right",
    }[placement.split("-")[0]];

    Object.assign(arrowElement.style, {
      left: arrowX != null ? `${arrowX}px` : "",
      top: arrowY != null ? `${arrowY}px` : "",
      right: "",
      bottom: "",
      [staticSide]: "-10px",
    });
  });
}

export default SourceInspector;
