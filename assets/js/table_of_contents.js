const TableOfContents = {
  mounted() {
    if (location.hash) {
      const hash = location.hash.replace("#", "");
      const header = document.querySelector(`#${hash}`);

      header &&
        header.scrollIntoView({
          behavior: "instant",
          block: "start",
          inline: "end",
        });

      highlightNav(
        hash,
        [
          "hover:text-slate-900",
          "dark:text-slate-400",
          "dark:hover:text-slate-300",
        ],
        ["text-sky-500", "dark:text-sky-400"]
      );
    }
    window.addEventListener("hashchange", handleHashChange);
  },
  destroyed() {
    window.removeEventListener("hashchange", handleHashChange);
  },
};

function handleHashChange(event) {
  if (event.oldURL.includes("#")) {
    const hash = event.oldURL.split("#").pop();

    highlightNav(
      hash,
      ["text-sky-500", "dark:text-sky-400"],
      [
        "hover:text-slate-900",
        "dark:text-slate-400",
        "dark:hover:text-slate-300",
      ]
    );
  }

  if (location.hash) {
    const hash = location.hash.replace("#", "");

    highlightNav(
      hash,
      [
        "hover:text-slate-900",
        "dark:text-slate-400",
        "dark:hover:text-slate-300",
      ],
      ["text-sky-500", "dark:text-sky-400"]
    );
  }
}

function highlightNav(hash, remove, add) {
  const nav = document.querySelector(`#${hash}-link`);

  if (nav) {
    nav.classList.remove(...remove);
    nav.classList.add(...add);

    const { parent } = nav.dataset;

    if (parent) {
      parent.split(">").forEach((parentId) => {
        const parent = document.querySelector(`#${parentId}-link`);

        if (parent) {
          parent.classList.remove(...remove);
          parent.classList.add(...add);
        }

        const parentContainer = document.querySelector(
          `#${parentId}-container`
        );

        if (parentContainer) {
          parentContainer.classList.remove("hidden");
          if (location.hash == `#${hash}`) parentContainer.style.display = null;
        }
      });
    }
  }
}

export default TableOfContents;
